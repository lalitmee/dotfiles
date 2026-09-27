#!/usr/bin/env python3
"""Exercise the Gitleaks pre-commit hook in an isolated temporary repository."""

from __future__ import annotations

import base64
import json
import secrets
import shutil
import subprocess
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HOOK_CONFIG = """repos:
- repo: https://github.com/gitleaks/gitleaks
  rev: v8.18.2
  hooks:
  - id: gitleaks
"""


def run(command: list[str], repo: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        command,
        cwd=repo,
        capture_output=True,
        text=True,
        check=False,
    )


def run_case(
    repo: Path,
    baseline: str,
    name: str,
    contents: str,
    should_block: bool,
    synthetic_values: tuple[str, ...] = (),
) -> None:
    target = repo / name
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(contents, encoding="utf-8")

    added = run(["git", "add", "--", name], repo)
    if added.returncode != 0:
        raise SystemExit(f"fixture staging failed for {name}")

    result = run(["git", "commit", "-m", "fixture"], repo)
    output = result.stdout + result.stderr
    blocked = result.returncode != 0
    if blocked != should_block:
        raise SystemExit(f"unexpected commit result for {name}")
    if any(value in output for value in synthetic_values):
        raise SystemExit("hook output exposed a generated fixture value")

    reset = run(["git", "reset", "--hard", baseline], repo)
    clean = run(["git", "clean", "-fd"], repo)
    if reset.returncode != 0 or clean.returncode != 0:
        raise SystemExit("could not reset isolated fixture repository")


def main() -> int:
    pre_commit = shutil.which("pre-commit")
    if pre_commit is None:
        raise SystemExit("pre-commit is required to run the Gitleaks fixture test")

    with tempfile.TemporaryDirectory(prefix="gitleaks-precommit-test-") as temp_dir:
        repo = Path(temp_dir)
        copied_config = repo / ".gitleaks.toml"
        shutil.copyfile(ROOT / ".gitleaks.toml", copied_config)
        (repo / ".pre-commit-config.yaml").write_text(HOOK_CONFIG, encoding="utf-8")

        initialized = run(["git", "init", "--quiet"], repo)
        if initialized.returncode != 0:
            raise SystemExit("could not initialize fixture repository")

        for setting, value in (
            ("user.name", "Gitleaks Fixture"),
            ("user.email", "gitleaks-fixture@example.invalid"),
        ):
            configured = run(["git", "config", setting, value], repo)
            if configured.returncode != 0:
                raise SystemExit("could not initialize fixture Git identity")

        added = run(["git", "add", "--", ".gitleaks.toml", ".pre-commit-config.yaml"], repo)
        if added.returncode != 0:
            raise SystemExit("could not stage fixture baseline")
        baseline_commit = run(["git", "commit", "--quiet", "-m", "fixture baseline"], repo)
        if baseline_commit.returncode != 0:
            raise SystemExit("could not commit fixture baseline")
        baseline = run(["git", "rev-parse", "HEAD"], repo).stdout.strip()

        installed = run([pre_commit, "install", "--install-hooks"], repo)
        if installed.returncode != 0:
            raise SystemExit("could not install Gitleaks in fixture repository")

        secret_cases = [
            ("json", "configs/example.json", lambda value: json.dumps({"api_key": value})),
            ("toml", "configs/example.toml", lambda value: f'api_key = "{value}"\n'),
            ("yaml", "configs/example.yaml", lambda value: f'api_key: "{value}"\n'),
            ("yaml-bare", "configs/bare.yaml", lambda value: f'api_key: {value}\n'),
            (
                "jsonc",
                "configs/example.jsonc",
                lambda value: f'{{\n  // test config\n  "Authorization": "Bearer {value}"\n}}\n',
            ),
            ("markdown", "assistant/command.md", lambda value: f'Authorization: Bearer {value}\n'),
            ("markdown-token", "assistant/token.md", lambda value: f'token: {value}\n'),
            (
                "allowlist-mixed-line",
                "assistant/mixed-line.md",
                lambda value: f'api_key: "{value}" # ${{SAFE_SAMPLE_KEY}}\n',
            ),
        ]
        for case_name, filename, render in secret_cases:
            value = secrets.token_urlsafe(48)
            run_case(repo, baseline, filename, render(value), True, (value,))

        safe_cases = [
            ("env-json.json", json.dumps({"api_key": "${SAFE_API_KEY}"})),
            ("env-toml.toml", 'api_key = "${SAFE_API_KEY}"\n'),
            ("env-yaml.yaml", 'api_key: "${SAFE_API_KEY}"\n'),
            ("env-jsonc.jsonc", '{"Authorization": "Bearer ${SAFE_BEARER}"}\n'),
            ("placeholder.md", "api_key: YOUR_API_KEY\n"),
            ("sk-placeholder.md", "api_key: sk-your-api-key-here\n"),
        ]
        for filename, contents in safe_cases:
            run_case(repo, baseline, filename, contents, False)

        private_key_body = base64.b64encode(secrets.token_bytes(64)).decode("ascii")
        private_key = (
            "-----BEGIN RSA "
            + "PRIVATE KEY-----\n"
            + private_key_body
            + "\n-----END RSA "
            + "PRIVATE KEY-----\n"
        )
        run_case(repo, baseline, "keys/example.pem", private_key, True, (private_key_body,))

    print("Gitleaks staged-hook fixtures passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
