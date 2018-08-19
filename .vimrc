call plug#begin('~/.vim/plugged')
Plug 'rust-lang/rust.vim'
Plug 'justinmk/vim-syntax-extra'
Plug 'Shirk/vim-gas'
Plug 'Sandlot19/vim-colorschemes'
Plug 'OrangeT/vim-csharp'
Plug 'neilhwatson/vim_cf3'
Plug 'tpope/vim-fugitive'
" Plug 'Valloric/YouCompleteMe'
call plug#end()

syntax enable 

set t_kb=
set nocompatible
set modeline
set backspace=eol,indent,start
set autoindent
set smartindent

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

set tabstop=2
set shiftwidth=2
set softtabstop=2
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

"I like the desert
colorscheme gentooish

"Always show the tabline
set showtabline=2

:set wrap
":set linebreak
":set nolist  " list disables linebreak

au BufRead,BufNewFile *.cf set ft=cf3
autocmd BufNewFile,BufRead /tmp/mutt* set noautoindent filetype=mail wm=0 tw=78 nonumber digraph nolist
autocmd BufNewFile,BufRead ~/tmp/mutt* set noautoindent filetype=mail wm=0 tw=78 nonumber digraph nolist

