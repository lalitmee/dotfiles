vim.g.openbrowser_default_search = 'duckduckgo'

vim.cmd [[nmap gx <Plug>(openbrowser-smart-search)]]
vim.cmd [[vmap gx <Plug>(openbrowser-smart-search)]]

-- devdocs
vim.cmd [[xnoremap <A-s> :<C-u>execute printf('OpenBrowserSmartSearch -devdocs %s %s', &filetype, helpers#general#getwords_last_visual())<CR>]]
vim.cmd [[nnoremap <A-s> :<C-r>=printf('OpenBrowserSmartSearch -devdocs %s ', &filetype)<CR>]]

-- openbrowser search engines
vim.g.openbrowser_search_engines = {
  clang_func_dict = 'http://www.c-tipsref.com/cgi-bin/index.cgi?q={query}&b.x=0&b.y=0',
  crates_io = 'https://crates.io/search?q={query}',
  devdocs = 'http://devdocs.io/#q={query}',
  duckduckgo = 'http://duckduckgo.com/?q={query}',
  github = 'http://github.com/search?q={query}',
  luaroks = 'https://luarocks.org/search?q={query}',
  mdnwebdocs = 'https://developer.mozilla.org/ja/search?q={query}',
  memo = 'https://scrapbox.io/tamago324vim/search/page?q={query}',
  neovim_patch = 'https://github.com/neovim/neovim/issues?q=is%3Aopen+sort%3Aupdated-desc+{query}',
  python = 'https://docs.python.org/3/search.html?q={query}',
  rust_doc_std = 'https://doc.rust-lang.org/std/index.html?search={query}',
  utf8_icons = 'https://www.utf8icons.com/search?query={query}',
  vim_commits = 'https://github.com/vim/vim/search?q={query}&type=commits',
  vimawesome = 'https://vimawesome.com/?q={query}'
}
