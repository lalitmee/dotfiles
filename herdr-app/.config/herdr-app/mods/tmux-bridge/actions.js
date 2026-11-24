import * as fs from "fs/promises";
import { exec, focused, hc, panes, run, spaces, terminals } from "herdr";
import { SCRATCHPADS } from "./scratchpads.js";

function activeContext() {
  const f = focused();
  const allPanes = panes();
  const activePane = allPanes.find((p) => p.focused) ?? (f?.pane ? allPanes.find((p) => p.pane === f.pane) : null);
  const allSpaces = spaces();
  const activeSpace = allSpaces.find((s) => s.active) ?? allSpaces[0];
  return {
    focused: f,
    pane: activePane,
    space: activeSpace,
    machine: activeSpace?.machine ?? null,
    cwd: f?.cwd ?? activePane?.cwd ?? activeSpace?.folder ?? null,
    terminal: f?.terminal ?? activePane?.terminal ?? null,
  };
}

export function isVimFocused() {
  const { pane } = activeContext();
  const key = pane?.program?.key;
  return key === "nvim" || key === "vim";
}

export async function vimAwareGo(direction) {
  const { terminal } = activeContext();
  if (terminal && isVimFocused()) {
    const keyMap = { left: "ctrl+h", down: "ctrl+j", up: "ctrl+k", right: "ctrl+l" };
    await hc(["keys", terminal, keyMap[direction]]);
    return;
  }
  run("pane.go", { direction });
}

export async function sendRawCtrl(letter) {
  const { terminal } = activeContext();
  if (terminal) {
    await hc(["keys", terminal, `ctrl+${letter}`]);
  }
}

export function cyclePane(delta) {
  const { focused: f } = activeContext();
  const allPanes = panes();
  const tabPanes = f?.tab ? allPanes.filter((p) => p.tab === f.tab) : allPanes;
  if (tabPanes.length < 2) return;
  const idx = tabPanes.findIndex((p) => p.focused || (f?.pane && p.pane === f.pane));
  const nextIdx = idx < 0 ? 0 : (idx + delta + tabPanes.length) % tabPanes.length;
  run("pane.focus", { pane: tabPanes[nextIdx].pane });
}

export function togglePeek() {
  const { terminal, pane } = activeContext();
  if (!terminal) return;
  if (pane) {
    run("terminal.peek", { terminal });
  } else {
    run("terminal.keep", { terminal });
  }
}

async function gitRoot(cwd, machine) {
  if (!cwd) return cwd;
  try {
    const r = await exec("git", ["-C", cwd, "rev-parse", "--show-toplevel"], { cwd, on: machine });
    if (r.code === 0 && r.stdout.trim()) return r.stdout.trim();
  } catch {
    // Fallback to cwd when not inside a git repo.
  }
  return cwd;
}

function uniqueTerminalName(base) {
  const clean = (base || "scratchpad")
    .toLowerCase()
    .replace(/[^a-z0-9_-]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 26) || "scratchpad";
  const taken = new Set(terminals().map((t) => t.name).filter(Boolean));
  if (!taken.has(clean)) return clean;
  for (let i = 2; i < 100; i += 1) {
    const candidate = `${clean}-${i}`.slice(0, 32);
    if (!taken.has(candidate)) return candidate;
  }
  return `${clean.slice(0, 20)}-${Date.now().toString(36).slice(-6)}`;
}

export async function openScratchpad(name) {
  const spec = SCRATCHPADS[name];
  if (!spec) return;
  const ctx = activeContext();
  let dir = ctx.cwd;
  if (spec.perDir && dir) {
    dir = await gitRoot(dir, ctx.machine);
  }
  const key = `tpad:${name}${spec.perDir && dir ? `:${dir}` : ""}`;
  const liveTerms = terminals();
  const existing = liveTerms.find((t) => t.labels?.tpad === key || t.name === key);

  if (existing) {
    if (ctx.terminal === existing.address) {
      run("overlay.close");
      return;
    }
    run("terminal.peek", { terminal: existing.address });
    return;
  }

  const baseName = spec.perDir && dir ? `${name}-${dir.split("/").filter(Boolean).pop()}` : name;
  const args = [
    "run", "--bg", "--json", "--no-parent", "--outlive-parent",
    "--name", uniqueTerminalName(baseName),
    "--label", `tpad=${key}`,
  ];
  if (dir) args.push("--cwd", dir);
  if (ctx.machine) args.push("--on", ctx.machine);
  if (spec.sh) {
    args.push("--", "zsh", "-lc", spec.sh);
  }
  const res = await hc(args);
  if (res.code !== 0) return;
  const parsed = JSON.parse(res.stdout);
  const addr = parsed.address ?? parsed.terminal;
  if (addr) run("terminal.peek", { terminal: addr });
}

export async function openFloatShell(shCmd, label = "float") {
  const ctx = activeContext();
  const args = [
    "run", "--bg", "--json", "--no-parent", "--rm",
    "--name", uniqueTerminalName(label),
  ];
  if (ctx.cwd) args.push("--cwd", ctx.cwd);
  if (ctx.machine) args.push("--on", ctx.machine);
  args.push("--", "zsh", "-lc", shCmd);
  const res = await hc(args);
  if (res.code !== 0) return;
  const parsed = JSON.parse(res.stdout);
  const addr = parsed.address ?? parsed.terminal;
  if (addr) run("terminal.peek", { terminal: addr });
}

export async function captureScrollback() {
  const ctx = activeContext();
  if (!ctx.terminal) return;
  const res = await hc(["read", ctx.terminal, "--lines", "5000"]);
  if (res.code !== 0) return;
  const tmp = `/tmp/herdr-pane-${Date.now()}.txt`;
  await fs.writeFile(tmp, res.stdout, "utf8");
  await openFloatShell(`nvim +'set binary noeol' +'$' "${tmp}"; rm -f "${tmp}"`, "scrollback");
}
