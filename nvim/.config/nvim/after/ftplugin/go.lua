lk.augroup("go_au", {
  {
    event = { "BufWritePre" },
    pattern = { "*.go" },
    command = function()
      require("go.format").gofmt()
    end,
  },
})