import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { checking, closeOverlay, exec, props, run, setShared, theme } from "herdr";
import { MODES } from "./modes.js";

function candidatesForEvent(e) {
  const out = [];
  if (e.keystroke) out.push(e.keystroke);
  if (e.key_char && !e.modifiers?.control && !e.modifiers?.alt) {
    out.push(e.key_char);
  }
  if (e.modifiers?.shift && !e.modifiers?.control && !e.modifiers?.alt && e.key?.length === 1) {
    out.push(e.key.toUpperCase());
  }
  return out;
}

let jobSeq = 0;
function dispatchBridgeJob(job) {
  jobSeq += 1;
  setShared("tmux_bridge_job", { nonce: `${Date.now()}-${jobSeq}`, ...job });
}

export default class TmuxLeader extends View {
  init(initialProps, cx) {
    this.mode = initialProps?.mode ?? props()?.mode ?? "prefix";
    this.filter = "";
    this.filtering = false;
    this.handle = cx.focus_handle();
    this.handle.focus();
    if (!checking()) cx.timer.after(40, () => this.handle.focus());
  }

  closeSelf() {
    const id = props()?.overlay;
    if (id) closeOverlay(id);
  }

  async executeItem(item, cx) {
    const spec = MODES[this.mode];
    const sticky = Boolean(spec?.sticky);

    if (item.kind === "mode") {
      this.mode = item.mode;
      this.filter = "";
      this.filtering = false;
      cx.notify();
      return;
    }

    if (item.kind === "resize_enter") {
      run("pane.resize", { direction: item.dir, px: 36 });
      this.mode = "resize";
      this.filter = "";
      this.filtering = false;
      cx.notify();
      return;
    }

    if (!sticky) this.closeSelf();

    if (item.kind === "run") {
      run(item.cmd, item.args);
      return;
    }
    if (item.kind === "send") {
      const letterMap = { "\u0001": "a", "\u0008": "h", "\n": "j", "\u000b": "k", "\u000c": "l" };
      const letter = letterMap[item.text];
      if (letter) dispatchBridgeJob({ kind: "send_ctrl", letter });
      return;
    }
    if (item.kind === "scratchpad") {
      dispatchBridgeJob({ kind: "scratchpad", name: item.name });
      return;
    }
    if (item.kind === "float") {
      dispatchBridgeJob({ kind: "float", sh: item.sh, prefix: this.mode });
      return;
    }
    if (item.kind === "exec") {
      await exec(item.cmd, item.args ?? []);
      return;
    }
    if (item.kind === "split_ratio") {
      run("pane.split", { direction: item.dir });
      run("pane.resize", { direction: item.dir, px: item.px });
      return;
    }
    if (item.kind === "bridge") {
      run(`tmux-bridge.${item.action}`);
    }
  }

  onKeyDown(e, cx) {
    if (e.key === "escape") {
      cx.stop_propagation();
      return this.closeSelf();
    }

    if (this.filtering) {
      cx.stop_propagation();
      if (e.key === "backspace") {
        this.filter = this.filter.slice(0, -1);
        cx.notify();
        return;
      }
      if (e.key === "enter") {
        this.filtering = false;
        cx.notify();
        return;
      }
      if (e.key_char && !e.modifiers?.control && !e.modifiers?.alt) {
        this.filter += e.key_char;
        cx.notify();
      }
      return;
    }

    const candidates = candidatesForEvent(e);
    if (candidates.includes("?") && this.mode !== "ask-tools") {
      cx.stop_propagation();
      this.filtering = true;
      this.filter = "";
      cx.notify();
      return;
    }

    const spec = MODES[this.mode] ?? MODES.prefix;
    const match = spec.items.find((it) => candidates.includes(it.key));
    if (match) {
      cx.stop_propagation();
      cx.spawn(async (cx) => {
        await this.executeItem(match, cx);
      });
      return;
    }

    if (candidates.includes("q") && this.mode !== "layout-mode") {
      cx.stop_propagation();
      this.closeSelf();
    }
  }

  render() {
    const t = theme();
    const spec = MODES[this.mode] ?? MODES.prefix;
    const f = this.filter.toLowerCase();
    const items = spec.items.filter(
      (it) => !f || it.key.toLowerCase().includes(f) || it.label.toLowerCase().includes(f),
    );

    return v_flex()
      .id("tmux-leader")
      .track_focus(this.handle)
      .on_key_down((e, cx) => this.onKeyDown(e, cx))
      .size_full()
      .min_h(0)
      .p(16)
      .gap(10)
      .bg(t.popover)
      .text_size(12)
      .child(
        h_flex()
          .items_center()
          .justify_between()
          .child(div().text_size(14).font_semibold().text_color(t.foreground).child(spec.title))
          .child(
            div()
              .text_size(11)
              .text_color(t.dim)
              .child(this.filtering ? `Filter: ${this.filter}_` : "? filter · q/Esc close"),
          ),
      )
      .child(
        v_flex()
          .flex_1()
          .min_h(0)
          .overflow_y_scrollbar()
          .gap(3)
          .children(
            items.map((it) =>
              h_flex()
                .id(`item-${this.mode}-${it.key}-${it.label}`)
                .px(8)
                .py(5)
                .rounded(6)
                .items_center()
                .cursor_pointer()
                .hover((s) => s.bg(t.hover))
                .on_click((_ev, cx) => {
                  cx.spawn(async (cx) => {
                    await this.executeItem(it, cx);
                  });
                })
                .child(div().w(125).font_semibold().text_color(t.accent).child(it.key))
                .child(div().text_color(t.foreground).child(it.label)),
            ),
          ),
      );
  }
}
