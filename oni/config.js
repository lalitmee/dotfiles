"use strict";
exports.__esModule = true;
exports.activate = function(oni) {
  console.log("config activated");
  // Input
  //
  // Add input bindings here:
  //
  oni.input.bind("<c-enter>", function() {
    return console.log("Control+Enter was pressed");
  });
  //
  // Or remove the default bindings here by uncommenting the below line:
  //
  // oni.input.unbind("<c-p>")
  // quickFind plugin for search
  oni.input.bind(["<c-f>"], "marene.quickFind");
};
exports.deactivate = function(oni) {
  console.log("config deactivated");
};
exports.configuration = {
  //add custom config here, such as

  // neovim path
  "debug.neovimPath": "/home/linuxbrew/.linuxbrew/Cellar/neovim/0.3.1/bin/nvim",
  // "debug.neovimPath": "/home/linuxbrew/.linuxbrew/Cellar/neovim/0.3.4/bin/nvim",
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
