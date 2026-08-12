---
name: env-setup
description: >-
  Explain, inspect, configure, and troubleshoot Cloud Agent development
  environments. Use when the user asks about environment setup or
  changing/improving the environment.
environments:
  - cloud
---
# Cloud Agent Environment Setup

Use this skill to teach users how Cloud Agent environments work and, when requested, to inspect or improve the current repository's setup. Match the response to the request: explain a concept, audit configuration, make a focused patch, or troubleshoot a failed setup.

## Mental Model

A Cloud Agent starts in an isolated remote machine. Its environment has two layers:

1. **Base environment**: a saved snapshot, Dockerfile-built image, explicit image, or Codex's default image supplies the operating system, system packages, and toolchains.
2. **Repository bootstrap**: after Codex checks out the selected repository revision, `install` refreshes project dependencies and generated state. `start` and `terminals` then start services needed while the agent works.

Put slow, stable system dependencies in the Dockerfile. Put repository-dependent work in `install`, where it can see the checked-out source. Keep `install` idempotent because it can run repeatedly and against cached or partially prepared state.

Environment changes normally affect newly started agents. Do not imply that editing configuration rebuilds or migrates an already-running agent.

## Configuration Sources and Precedence

Codex resolves environment configuration in this order:

1. `.cursor/environment.json` from the repository revision used to start the agent.
2. A personal saved environment for the repository.
3. A team saved environment for the repository.

The first available source wins. A committed `.cursor/environment.json` therefore overrides dashboard-managed personal and team environments. Before proposing a change, determine which source the current agent actually used. Prefer the Cloud Agent environment-info tool when available; otherwise inspect the repository and explain what cannot be confirmed.

Repository-defined environments are versioned with code and are best when the setup should follow branches and pull requests. Dashboard-managed environments are useful for interactive setup, secrets, and reusable saved snapshots without committing configuration to the repository.

## Common environment.json Fields

Use the current public schema instead of relying on a memorized exhaustive field list:

- Schema: https://cursor.com/schemas/environment.schema.json
- Setup guide: https://cursor.com/docs/cloud-agent/setup
- Environment settings: https://cursor.com/docs/cloud-agent/settings

Use the schema for validation, but do not add a `$schema` property to `.cursor/environment.json`; the current schema rejects undeclared fields.

Common fields:

| Field | Purpose |
| --- | --- |
| `name` | Human-readable environment name. |
| `user` | User that runs commands in the environment. It must exist in the image. |
| `build.dockerfile` | Dockerfile path, relative to the directory containing `environment.json`. |
| `build.context` | Docker build context, also relative to that directory. It defaults to `.cursor`. |
| `snapshot` | Saved base-environment snapshot ID. |
| `install` | Idempotent repository bootstrap/update command run after source is available. |
| `start` | Command run when the environment starts; failure prevents a successful start. |
| `terminals` | Named persistent processes presented to the agent and run in tmux-backed terminals. |
| `ports` | Container ports to expose. |
| `repositoryDependencies` | Additional repositories that must be in the generated GitHub token's access scope. |
| `agentCanUpdateSnapshot` | Whether the agent may update a snapshot-backed environment. |

Check the live schema before adding less-common fields. Product behavior can evolve faster than this skill.

## Choosing install, start, or terminals

Classify each setup action by the lifetime of the state it creates:

| Location | Use it for | Expected behavior |
| --- | --- | --- |
| `install` | Durable repository setup tied to checked-out source: package installation, compilation, code generation, and local configuration that can be recreated. | Runs after source is available and may run again after changes or against cached state. It must be idempotent, non-interactive, and terminate successfully. No process started here should be expected to survive into a later boot. |
| `start` | Per-boot runtime initialization: starting system daemons, restoring ephemeral service state, or launching a supervised/background service required whenever the machine starts. | Runs every time the environment starts. It must tolerate restarts, avoid duplicate processes, and reach a clear success or failure state. |
| `terminals` | Long-running foreground processes the agent should see, inspect, restart, or read logs from: development servers, watchers, and workers. | Runs as named tmux-backed processes after startup. Commands may remain active for the lifetime of the environment. |

A development server does not belong in `install`: cached setup or a snapshot may preserve its files but not its process, and a foreground server can prevent installation from completing. Put it in `terminals` when the agent benefits from visible logs and direct restarts. Use `start` when a startup script launches or reconciles the service under a process manager, confirms readiness, and then returns.

Keep dependency installation and source-derived generation out of `start`. Running them on every boot increases startup time and hides failures that belong in repository setup. If runtime initialization depends on an artifact, produce that artifact in `install` and consume it in `start`.

### Diagnose misplaced work

When environment setup hangs, behaves differently after a snapshot, or loses services between agents:

1. Identify the phase and command from setup logs. Do not infer the failing phase from the script name alone.
2. Ask whether the command creates durable files or requires a live process.
3. If `install` launches a server, watcher, worker, Docker daemon, or other process that must still be running later, move that responsibility to `start` or `terminals`.
4. If `start` repeatedly installs packages, compiles the repository, or regenerates source-derived files, move that responsibility to `install`.
5. Make the destination idempotent:
   - `install` should converge without appending state or rewriting lockfiles unexpectedly.
   - `start` should detect an already-running service, clean up stale PID/socket files, and fail clearly when readiness is not reached.
   - `terminals` should use stable names, bind services to the intended interface and port, and emit useful logs.
6. Validate each phase independently, then reboot or start a fresh agent to prove runtime services return without rerunning one-time setup manually.

Typical signals:

- **Install never completes:** a foreground server or interactive command is running in `install`.
- **Files exist but the service disappears on a later boot:** the service was started during `install` and its process was not part of durable state.
- **Every boot is slow or changes the lockfile:** dependency setup is incorrectly running in `start`.
- **Start fails with “address already in use” or duplicate workers:** the start path is not idempotent.
- **A service starts but cannot serve requests:** add an explicit readiness check and verify its port is configured and bound correctly.

## Dockerfile and Build Context

`build.dockerfile` and `build.context` are resolved relative to the directory containing `.cursor/environment.json`:

- `"dockerfile": "Dockerfile"` means `.cursor/Dockerfile`.
- Omitting `context` uses `.cursor` as the build context.
- `"context": "."`, `"./"`, or `".."` makes the repository root available as the build context.

Codex checks out the requested repository revision separately after preparing the base environment. Avoid copying the whole repository into the image: it creates stale duplicate source, weakens layer caching, and makes branch behavior confusing. Use the Dockerfile for operating-system packages and stable tool versions; use `install` for dependency installation tied to lockfiles and source.

### Minimal default-image setup

~~~json
{
  "name": "My project",
  "install": "npm ci"
}
~~~

### Custom Dockerfile

`.cursor/environment.json`:

~~~json
{
  "name": "My project",
  "build": {
    "dockerfile": "Dockerfile",
    "context": ".."
  },
  "user": "ubuntu",
  "install": "./scripts/cloud-agent-install.sh"
}
~~~

`.cursor/Dockerfile`:

~~~dockerfile
FROM node:22-bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends git build-essential python3 \
    && rm -rf /var/lib/apt/lists/* \
    && corepack enable

USER node
~~~

### Idempotent install script

~~~bash
#!/usr/bin/env bash
set -euo pipefail

corepack pnpm install --frozen-lockfile
corepack pnpm generate
~~~

This Node example assumes `package.json` pins pnpm with `packageManager` and defines a deterministic `generate` script. Adapt the image and commands to the repository. Prefer its pinned package manager and lockfile; avoid broad upgrades or lockfile rewrites during environment setup unless the user explicitly requests them.

## Working on an Environment

### Explain or audit

1. Read the public setup documentation and current schema when field-level accuracy matters.
2. Inspect `.cursor/environment.json`, its referenced Dockerfile and scripts, dependency manifests, lockfiles, and repository-specific agent guidance.
3. If available, inspect environment-info to identify the effective source, version, build, and network policy.
4. Explain the effective lifecycle and call out uncertainty instead of inventing undocumented behavior.

### Make a change

1. Establish the requested outcome and the effective configuration source.
2. For repository-managed environments, edit `.cursor/environment.json` and its referenced files narrowly.
3. For dashboard-managed environments, do not pretend a repository patch changes dashboard state. Explain the dashboard action or use a supported environment workflow when explicitly requested.
4. Validate JSON against the current schema and run lightweight checks for changed scripts or Dockerfiles.


## Troubleshooting

Find the earliest failing layer:

1. **Image build**: Dockerfile syntax, unavailable packages, build context, architecture, or registry access.
2. **Provisioning and checkout**: repository access, selected ref, runtime user, disk, or network policy.
3. **Install**: non-idempotent scripts, missing lockfiles, private dependency authentication, or generated-file assumptions.
4. **Start and terminals**: commands that exit unexpectedly, bind the wrong interface or port, or depend on setup that did not complete.

Use setup or build logs as evidence. Reproduce the smallest safe failing command when possible, then rerun the relevant verification. Treat definitive credential, authorization, quota, or entitlement failures as blockers after confirming them once.

## Safety

- Never put tokens, passwords, private keys, or secret values in `environment.json`, Dockerfiles, committed scripts, logs, or chat output. Use supported environment secrets or build-secret mechanisms.
- Do not deploy, publish, apply infrastructure, or mutate production resources as part of environment setup.
- Keep Dockerfiles and install scripts deterministic, non-interactive, and narrowly scoped.
- Do not weaken network, certificate, or package-integrity controls merely to make setup pass.


## Response

Lead with the outcome. Include only the sections relevant to the request:

- Effective configuration source and lifecycle.
- What was inspected or changed.
- Validation evidence.

- Remaining manual action, uncertainty, or blocker.
