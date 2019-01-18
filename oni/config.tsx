import * as React from "react";
import * as Oni from "oni-api";

export const activate = (oni: Oni.Plugin.Api) => {
  console.log("config activated");

  // Input
  //
  // Add input bindings here:
  //
  oni.input.bind("<c-enter>", () => console.log("Control+Enter was pressed"));

  //
  // Or remove the default bindings here by uncommenting the below line:
  //
  // oni.input.unbind("<c-p>")

  // quickFind plugin for search
  oni.input.bind(["<c-f>"], "marene.quickFind");
};

export const deactivate = (oni: Oni.Plugin.Api) => {
  console.log("config deactivated");
};

export const configuration = {
  //add custom config here, such as

  // neovim path for launching
  // "debug.neovimPath": "/home/linuxbrew/.linuxbrew/bin/nvim",
  "debug.neovimPath": "/home/linuxbrew/.linuxbrew/Cellar/neovim/0.3.1/bin/nvim",
  // "debug.neovimPath": "",

  "ui.colorscheme": "gruvbox",
  "statusbar.fontSize": "1.2em",
  "oni.hideMenu": true,
  "editor.formatting.formatOnSwitchToNormalMode": true,
  "editor.fontSize": "20px",
  "editor.fontWeight": "600",
  "editor.fontFamily":
    "Operator Mono Lig Book, Monofur for Powerline, Fira Code",
  "browser.defaultUrl": "https://google.com",

  // UI customizations
  "ui.animations.enabled": true,
  "ui.fontSmoothing": "auto",

  // sidebar settings
  "sidebar.default.open": false,

  // autoUpdate settings
  "autoUpdate.enabled": true
};
