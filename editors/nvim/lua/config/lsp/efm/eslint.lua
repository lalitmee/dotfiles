-- NOTE: old command for eslint
-- return {
--   lintCommand = 'eslint_d --stdin --stdin-filename ${INPUT} -f unix',
--   lintStdin = true,
--   lintIgnoreExitCode = true
-- }
-- NOTE: this is taken from here:
-- https://phelipetls.github.io/posts/configuring-eslint-to-work-with-ne
-- ovim-lsp/
-- return {
--   lintCommand = './node_modules/.bin/eslint -f unix --stdin',
--   lintIgnoreExitCode = true,
--   lintStdin = true
-- }
return {
  lintCommand = 'eslint_d -f unix --stdin --stdin-filename ${INPUT}',
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { '%f:%l:%c: %m' },
  formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
  formatStdin = true
}
