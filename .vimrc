call plug#begin('~/.vim/plugged')
Plug 'rust-lang/rust.vim'
Plug 'justinmk/vim-syntax-extra'
Plug 'Shirk/vim-gas'
Plug 'Sandlot19/vim-colorschemes'
Plug 'OrangeT/vim-csharp'
Plug 'neilhwatson/vim_cf3'
Plug 'tpope/vim-fugitive'
Plug 'lervag/vimtex'
Plug 'ycm-core/YouCompleteMe'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'themadsens/tagbar'
"Plug 'Nonius/cargo.vim'
Plug 'kergoth/vim-bitbake'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'vim-syntastic/syntastic'
call plug#end()

" Don't redraw the backgound if using a 256-color terminal so vim doesn't
" mess up in tmux specifically:
" https://superuser.com/questions/457911/in-vim-background-color-changes-on-scrolling
" https://sunaku.github.io/vim-256color-bce.html
if &term =~ '256color'
  set t_ut=
endif

" I like ; better than the default \
let mapleader = ';'

let g:ycm_confirm_extra_conf = 0
let g:ycm_clangd_args = ['-background-index']
let g:ycm_clangd_uses_ycmd_caching = 0
let g:ycm_clangd_binary_path = exepath("clangd")
let g:ycm_autoclose_preview_window_after_completion = 1
"let g:ycm_server_python_interpreter = '/usr/bin/python'
"let g:lsp_signs_enabled = 1
let g:vimtex_view_general_viewer = 'zathura'
let g:rust_recommended_style = 0

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_sh_shellcheck_args = '-x'


" Personal shortcuts
nnoremap <Leader>o :call fzf#run({'sink': 'badd'})<Cr>
nnoremap <Leader>b :Buffers<Cr>
nnoremap <Leader>G :Rg 
nnoremap <Leader>g :Rg <C-r><C-w>
nnoremap <Leader>f :YcmCompleter GoToImprecise<Cr>
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
inoremap jk <Esc>

syntax enable 

set t_kb=
set nocompatible
set modeline
set backspace=eol,indent,start
set autoindent
set smartindent
set textwidth=80
set colorcolumn=80

runtime ftplugin/man.vim

" don't highlight the last search upon startup
set viminfo="h"

" Do C-style auto indentation on C/C++/Perl files only
filetype on
filetype plugin on
autocmd FileType c,cpp,perl :set cindent
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType h set omnifunc=ccomplete#Complete
" autocmd FileType cf set syntax=/home/jruthe10/.vim/syntax/cf3

" stop Vim from beeping all the time
set vb

"set tabstop=8
set shiftwidth=4
"set softtabstop=4
set smarttab
set expandtab

set ruler
set background=dark

"Tell you if you are in insert mode
set showmode

"match parenthesis, i.e. ) with (  and } with {
set showmatch

"ignore case when doing searches, except when
"there's a single capital letter in the search
set ignorecase
set smartcase

"tell you how many lines have been changed
set report=0

"Keep 10 lines of context at the top and bottom of the screen
set scrolloff=10

"When pressing tab as part of a shell escape command, complete the
"longest match so far on the first tab press, then list the ambiguities
"upon pressing tab the second time (like bash)
set wildmode=longest,list

"Highlight the next word matching the search expression as the 
"search expression is typed (press 'esc' to exit the search)
set incsearch

"Highlight all matches of the current search on the current screen
set hlsearch

"I like the colors
colorscheme hybrid_material

"Always show the tabline
set showtabline=2

:set wrap
":set linebreak
":set nolist  " list disables linebreak

autocmd BufNewFile,BufRead /tmp/mtt* set noautoindent filetype=mail wm=0 tw=78 nonumber digraph nolist
autocmd BufNewFile,BufRead ~/tmp/mutt* set noautoindent filetype=mail wm=0 tw=78 nonumber digraph nolist

hi CursorLine   cterm=NONE ctermbg=236 ctermfg=NONE
hi LineNr ctermfg=darkgrey
hi CursorLineNr ctermfg=yellow
set cursorline
set nu

if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    \ })
        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType cpp setlocal omnifunc=lsp#complete
        autocmd FileType objc setlocal omnifunc=lsp#complete
        autocmd FileType objcpp setlocal omnifunc=lsp#complete
    augroup end
endif
