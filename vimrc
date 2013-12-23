" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

set nocompatible
set background=dark
syntax on
set t_Co=256
set enc=utf-8
colorscheme delek

"" Searching:
" Incremental, case insensitive, highlighted search:
set incsearch ignorecase hlsearch
" Press space to quit search:
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd                    " Show (partial) command in status line.
set showmatch                  " Show matching brackets.
set smartcase                  " Do smart case matching
set autowrite                  " Autosave before commands like :next and :make
set hidden                     " Hide buffers when they are abandoned
set backspace=indent,eol,start " Decides which chars backspace can delete
set ruler                      " Shows cursor position in lowerright corner
set number
set backupdir=~/.vim/backup    " Move backups here
set dir=~/.vim/backup
set scrolloff=4                " Tries to keep cursor a bit centered

"" Indenting and Filetypes:
filetype plugin indent on
" General filetypes:
set autoindent                 " Automatic indentation
set expandtab                  " Spaces > tabs
set shiftwidth=2               " 2 space indents
set softtabstop=2              " 2 space indents
" Special filetypes:
autocmd FileType python setlocal expandtab shiftwidth=4 softtabstop=4

" Quick switching between buffers:
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprevious<CR>
nnoremap <C-k> :bdelete<CR>

" To keep me out of INSERT-mode
map <Left>  <NOP>
map <Right> <NOP>
map <Up>    <NOP>
map <Down>  <NOP>
imap <Left>  <NOP>
imap <Right> <NOP>
imap <Up>    <NOP>
imap <Down>  <NOP>
