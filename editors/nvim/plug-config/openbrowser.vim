let g:openbrowser_default_search = 'duckduckgo'

nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" devdocs
xnoremap <A-d> :<C-u>execute printf('OpenBrowserSmartSearch -devdocs %s %s', &filetype, vimrc#getwords_last_visual())<CR>
nnoremap <A-d> :<C-r>=printf('OpenBrowserSmartSearch -devdocs %s ', &filetype)<CR>

" 追加
let g:openbrowser_search_engines = {
\   'devdocs': 'http://devdocs.io/#q={query}',
\   'github': 'http://github.com/search?q={query}',
\   'vimawesome': 'https://vimawesome.com/?q={query}',
\   'duckduckgo': 'http://duckduckgo.com/?q={query}',
\   'memo': 'https://scrapbox.io/tamago324vim/search/page?q={query}',
\   'mdnwebdocs': 'https://developer.mozilla.org/ja/search?q={query}',
\   'python': 'https://docs.python.org/3/search.html?q={query}',
\   'clang_func_dict': 'http://www.c-tipsref.com/cgi-bin/index.cgi?q={query}&b.x=0&b.y=0',
\   'neovim-vim-patch': 'https://github.com/neovim/neovim/issues?q=is%3Aopen+sort%3Aupdated-desc+{query}',
\   'vim/commits': 'https://github.com/vim/vim/search?q={query}&type=commits',
\   'luaroks': 'https://luarocks.org/search?q={query}',
\   'rust_doc_std': 'https://doc.rust-lang.org/std/index.html?search={query}',
\   'crates.io': 'https://crates.io/search?q={query}',
\   'utf8-icons': 'https://www.utf8icons.com/search?query={query}',
\}
