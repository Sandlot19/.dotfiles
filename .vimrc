call plug#begin('~/.vim/plugged')
Plug 'Shirk/vim-gas'
Plug 'Sandlot19/vim-colorschemes'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'neovim/nvim-lspconfig'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vimwiki/vimwiki'

" nvim-cmp setup
Plug 'hrsh7th/cmp-nvim-lsp', { 'branch': 'main' }
Plug 'hrsh7th/cmp-buffer', { 'branch': 'main' }
Plug 'hrsh7th/cmp-path', { 'branch': 'main' }
Plug 'hrsh7th/cmp-cmdline', { 'branch': 'main' }
Plug 'hrsh7th/nvim-cmp', { 'branch': 'main' }

" For vsnip users.
Plug 'hrsh7th/cmp-vsnip', { 'branch': 'main' }
Plug 'hrsh7th/vim-vsnip', { 'branch': 'main' }

call plug#end()

" Don't redraw the backgound if using a 256-color terminal so vim doesn't
" mess up in tmux specifically:
" https://superuser.com/questions/457911/in-vim-background-color-changes-on-scrolling
" https://sunaku.github.io/vim-256color-bce.html
"if &term =~ '256color'
"  set t_ut=
"endif

let g:vimwiki_list = [{  'path': '~/vimwiki/',
\                        'syntax': 'markdown',
\                        'ext': '.md',
\                        'auto_toc': 1,
\                        'nexted_syntaxes': {'python': 'python', 'c++': 'cpp', 'bash': 'bash'},
\                        'list_margin': -1
\                     }]

" Only treat *.md like wiki files if they're in the wiki path above
let g:vimwiki_global_ext = 0

" I like ; better than the default \
let mapleader = ';'

" Personal shortcuts
nnoremap <Leader>o :call fzf#run({'sink': 'badd'})<Cr>
nnoremap <Leader>b :Buffers<Cr>
nnoremap <Leader>G :Rg 
nnoremap <Leader>g :Rg <C-r><C-w>
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/
nnoremap <Leader>h :match SpellRare /<C-r><C-w>\c/<Cr>
nnoremap <Leader>n :match none<Cr>
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
colorscheme dracula

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
