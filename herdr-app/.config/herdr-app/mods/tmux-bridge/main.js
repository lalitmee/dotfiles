import { View, div } from "gpui-kit";
import { checking, focused, nextCommand, openOverlay, run, shared } from "herdr";
import { captureScrollback, cyclePane, openFloatShell, openScratchpad, sendRawCtrl, togglePeek, vimAwareGo } from "./actions.js";

const MAX_HISTORY = 32;

// Mounted as a 1px block in lalitmee-main.json so shortcuts work across every tab and space.
export default class TmuxBridge extends View {
  init(_props, cx) {
    this.history = [];
    this.histIdx = -1;
    this.navigating = false;
    this.lastJobNonce = null;

    if (checking()) return;

    cx.spawn(async () => {
      for (;;) {
        const cmd = await nextCommand();
        await this.dispatch(cmd);
      }
    });
  }

  recordFocus() {
    if (this.navigating) return;
    const f = focused();
    if (!f?.pane) return;
    const cur = this.history[this.histIdx];
    if (cur && cur.pane === f.pane) return;
    this.history = this.history.slice(0, this.histIdx + 1);
    this.history.push({ pane: f.pane, space: f.space });
    if (this.history.length > MAX_HISTORY) {
      this.history.shift();
    }
    this.histIdx = this.history.length - 1;
  }

  jumpHistory(delta) {
    if (this.history.length === 0) return;
    const nextIdx = Math.max(0, Math.min(this.history.length - 1, this.histIdx + delta));
    if (nextIdx === this.histIdx) return;
    this.histIdx = nextIdx;
    const target = this.history[nextIdx];
    if (!target) return;
    this.navigating = true;
    try {
      if (target.space) run("space.select", { id: target.space });
      run("pane.focus", { pane: target.pane });
    } finally {
      this.navigating = false;
    }
  }

  consumeSharedJob(cx) {
    const job = shared("tmux_bridge_job");
    if (!job || !job.nonce || job.nonce === this.lastJobNonce) return;
    this.lastJobNonce = job.nonce;
    cx.spawn(async () => {
      if (job.kind === "scratchpad") await openScratchpad(job.name);
      else if (job.kind === "float") await openFloatShell(job.sh, job.prefix ?? "float");
      else if (job.kind === "send_ctrl") await sendRawCtrl(job.letter);
    });
  }

  async dispatch(cmd) {
    if (cmd === "vim_left") return vimAwareGo("left");
    if (cmd === "vim_down") return vimAwareGo("down");
    if (cmd === "vim_up") return vimAwareGo("up");
    if (cmd === "vim_right") return vimAwareGo("right");
    if (cmd === "pane_prev") return cyclePane(-1);
    if (cmd === "pane_next") return cyclePane(1);
    if (cmd === "history_back") return this.jumpHistory(-1);
    if (cmd === "history_forward") return this.jumpHistory(1);
    if (cmd === "capture_scrollback") return captureScrollback();
    if (cmd === "toggle_peek") return togglePeek();
    if (cmd === "leader_prefix") {
      openOverlay({ mod: "tmux-leader", kind: "dialog", width: 680, height: 470, props: { mode: "prefix" } });
      return;
    }
    if (cmd === "leader_layout") {
      openOverlay({ mod: "tmux-leader", kind: "dialog", width: 680, height: 470, props: { mode: "layout-mode" } });
      return;
    }
    if (cmd.startsWith("scratchpad:")) {
      return openScratchpad(cmd.slice("scratchpad:".length));
    }
  }

  render(cx) {
    this.recordFocus();
    if (!checking()) this.consumeSharedJob(cx);
    return div();
  }
}
