import * as fs from "fs/promises";
import { exec, focused, hc, openOverlay, closeOverlay, panes, run, spaces, terminals } from "herdr";
import { SCRATCHPADS } from "./scratchpads.js";

const openFloatWindows = new Map(); // key -> { overlayId, terminal }

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

function showTerminalWindow(key, addr, width = 0.88, height = 0.86) {
  const id = openOverlay({
    kind: "window",
    key,
    width,
    height,
    layout: {
      type: "column",
      children: [
        { type: "block", size: { px: 28 }, content: { mod: "peek", props: { terminal: addr } } },
        { type: "block", content: { terminal: addr } },
      ],
    },
  });
  openFloatWindows.set(key, { overlayId: id, terminal: addr });
  run("pane.focus", { terminal: addr });
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
    const openEntry = openFloatWindows.get(key);
    if (openEntry && ctx.terminal === existing.address) {
      closeOverlay(openEntry.overlayId);
      openFloatWindows.delete(key);
      return;
    }
    showTerminalWindow(key, existing.address);
    return;
  }

  const args = ["run", "--bg", "--json", "--no-parent", "--outlive-parent", "--label", `tpad=${key}`];
  if (dir) args.push("--cwd", dir);
  if (ctx.machine) args.push("--on", ctx.machine);
  if (spec.sh) {
    args.push("--", "zsh", "-lc", spec.sh);
  }
  const res = await hc(args);
  if (res.code !== 0) return;
  const parsed = JSON.parse(res.stdout);
  const addr = parsed.address ?? parsed.terminal;
  if (addr) showTerminalWindow(key, addr);
}

export async function openFloatShell(shCmd, keyPrefix = "float") {
  const ctx = activeContext();
  const args = ["run", "--bg", "--json", "--no-parent", "--rm"];
  if (ctx.cwd) args.push("--cwd", ctx.cwd);
  if (ctx.machine) args.push("--on", ctx.machine);
  args.push("--", "zsh", "-lc", shCmd);
  const res = await hc(args);
  if (res.code !== 0) return;
  const parsed = JSON.parse(res.stdout);
  const addr = parsed.address ?? parsed.terminal;
  if (addr) {
    showTerminalWindow(`${keyPrefix}:${Date.now()}`, addr, 0.85, 0.85);
  }
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
