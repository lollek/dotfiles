" Last Updated 29 Dec 2013
" Olle K vimrc
"
""" General stuff
set nocompatible " Remove vi backward compability
set history=50   " 50 lines of command line history
set enc=utf-8    " Standard encoding
set modeline     " Very handy, but sometimes a security issue
" set suffixes=.bak,.swp,.o, " Lower priority for some files at :e
set backspace=indent,eol,start " Decides which chars backspace can delete

""" Graphics
set t_Co=256                      " 256 Colors
set background=dark               " Dark background
colorscheme delek                 " Colorscheme
"peachpuff and delek are OK
syntax on                         " Syntax highlighting
set list listchars=trail:.,tab:>. " Show tabs/trailing whitespace
set scrolloff=4                   " Tries to keep cursor a bit centered

set ruler                         " Shows cursor position in lowerright corner
set number                        " Show linenumber on the left side
set showcmd                       " Show (partial) command in status line.
set wildmenu                      " Show many results when opening files and stuff
set showmatch                     " Show matching brackets.

""" Formatting
set autoindent     " Automatic indent
set smartindent    " Do it well
set softtabstop=2  " 2 space indents
set shiftwidth=2   " 2 space indents
set expandtab      " Type spaces instead of tabs
set nosmarttab     " Don't remember this
set textwidth=80   " Wrap at 80 chars

""" Searching
set incsearch  " Incremental
set ignorecase " Case insensitive
set smartcase  " Do smart case matching
set hlsearch   " Highlighted search

""" Backup
set nobackup                   " Remove backups when done
set nowritebackup              " Don't write backup
set noswapfile                 " Remove swapfile when done
set backupdir=~/.vim/backup    " Move backups here
set backupcopy=yes             " Backups retain attributes
set dir=~/.vim/backup          " Move .swaps here

""" Extra commands
" Press space to quit search:
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>

" To keep me out of INSERT-mode
map <Left>  <NOP>
map <Right> <NOP>
map <Up>    <NOP>
map <Down>  <NOP>
imap <Left>  <NOP>
imap <Right> <NOP>
imap <Up>    <NOP>
imap <Down>  <NOP>

""" Indenting and Filetypes:
let g:is_bash=1 " Shell usually means bash
filetype plugin indent on
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4
