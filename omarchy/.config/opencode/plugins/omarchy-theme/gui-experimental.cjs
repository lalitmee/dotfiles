"use strict";

const { Plugin, Ipc, Theme } = require("@opencode/plugin/gui");
const { Schema } = require("effect");
const { createEffect, onCleanup } = require("solid-js");

const OmarchyIpc = Ipc.define({
  id: "omarchy-theme",
  state: Schema.String,
  methods: {},
  events: {},
});

module.exports = Plugin.define({
  os: ["linux"],
  main(ctx) {
    const fs = require("node:fs");
    const os = require("node:os");
    const path = require("node:path");

    const xdgConfig = process.env.XDG_CONFIG_HOME || path.join(os.homedir(), ".config");
    const configDir = path.join(xdgConfig, "ai.opencode.desktop");
    const themeFile = path.join(configDir, "omarchy-theme.json");

    function readTheme() {
      try {
        const raw = fs.readFileSync(themeFile, "utf8");
        JSON.parse(raw);
        return raw;
      } catch {
        return "";
      }
    }

    const channel = ctx.provide(OmarchyIpc, {
      state: () => readTheme(),
    });

    let timer = null;
    let watcher = null;

    if (fs.existsSync(configDir)) {
      try {
        watcher = fs.watch(configDir, (_eventType, filename) => {
          if (filename && filename !== "omarchy-theme.json") return;
          if (timer) clearTimeout(timer);
          timer = setTimeout(() => {
            timer = null;
            channel.changed();
          }, 100);
        });
        watcher.on("error", () => {});
      } catch {
        watcher = null;
      }
    }

    ctx.onCleanup(() => {
      if (timer) {
        clearTimeout(timer);
        timer = null;
      }
      if (watcher) {
        watcher.close();
        watcher = null;
      }
    });
  },
  setup(ctx) {
    const ipc = ctx.use(OmarchyIpc);

    createEffect(() => {
      const conn = ipc();
      if (conn.status !== "active") return;
      const raw = conn.value.state();
      if (!raw) return;

      let theme;
      try {
        theme = JSON.parse(raw);
      } catch {
        return;
      }

      const dispose = ctx.add(Theme, theme);
      onCleanup(() => dispose());
    });
  },
});
