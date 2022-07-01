local ok, code_runner = lk.safe_require("code_runner")
if not ok then
  return
end

code_runner.setup({
  filetype = {
    cpp = "g++ -o $fileBase && ./$fileBase",
    go = "go run",
    java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
    javascript = "node",
    lua = "lua",
    markdown = "glow",
    python = "python3 -u",
    rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
    sh = "sh",
    typescript = "deno run",
  },
})
