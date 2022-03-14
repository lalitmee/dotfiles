require("filetype").setup({
  overrides = {
    extensions = {
      pn = "potion",
      md = "markdown",
    },
    literal = {
      Caddyfile = "conf",
      [".env"] = "env",
    },
    complex = {
      -- Set the filetype of any full filename matching the regex to gitconfig
      [".*git/config"] = "gitconfig", -- Included in the plugin
      ["*.env.*"] = "env",
      ["*.conf"] = "conf",
      [".{jscs,jshint,eslint,babel}rc"] = "json",
      ["*.md"] = "markdown",
    },

    shebang = {
      -- Set the filetype of files with a dash shebang to sh
      dash = "sh",
    },
  },
})