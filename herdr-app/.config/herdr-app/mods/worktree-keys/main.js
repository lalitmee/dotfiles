import { View, div } from "gpui-kit";
import { nextCommand, openOverlay, panes, spaces } from "herdr";

// Mounted outside the sidebar so hiding it does not disable the shortcuts.
export default class WorktreeKeys extends View {
    init(_props, cx) {
        cx.spawn(async () => {
            for (;;) {
                this.command(await nextCommand());
            }
        });
    }

    render() {
        return div();
    }

    command(action) {
        if (action !== "new" && action !== "open") return;
        const space = spaces().find((space) => space.active);
        if (!space) return;
        openOverlay({
            mod: "worktree",
            kind: "dialog",
            width: action === "open" ? 560 : 460,
            height: action === "open" ? 480 : 280,
            props: {
                space: space.id,
                folder: panes().find((pane) => pane.focused)?.cwd,
                action,
            },
        });
    }
}
