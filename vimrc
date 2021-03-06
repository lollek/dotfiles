" Olle K vimrc

""" General stuff
set encoding=utf-8                " Standard encoding
set backspace=2                   " Set backspace=indent,eol,start

""" Graphics
colorscheme peachpuff             " Colorscheme - peachpuff and delek are OK
syntax on                         " Syntax highlighting
" Fix black Pmenu
highlight Pmenu ctermfg=15 ctermbg=0 guifg=#ffffff guibg=#000000
set list listchars=trail:~,tab:>_ " Show tabs/trailing whitespace
set scrolloff=4                   " Tries to keep cursor a bit centered

set ruler                         " Shows cursor position in lowerright corner
set number                        " Show linenumber on the left side
set cursorline                    " Underline current line
set showcmd                       " Show (partial) command in status line.
set wildmenu                      " Show many results when opening files and stuff
set showmatch                     " Show matching brackets.
set lazyredraw                    " Make vim not flush screen during e.g. macros

""" Formatting
set autoindent                    " Copy indent from current line to new line
" set smartindent                 " Add extra indent from time to time
set softtabstop=4                 " 4 space indents
set shiftwidth=4                  " 4 space indents
set expandtab                     " Type spaces instead of tabs
set textwidth=80                  " Wrap at 80 chars
set foldmethod=syntax             " Try to fold (=hide) information

""" Searching
set incsearch                     " Incremental
set ignorecase                    " Case insensitive
set smartcase                     " Do smart case matching
set hlsearch                      " Highlighted search

""" Backup
set nobackup                      " Remove backups when done
set nowritebackup                 " Don't write backup
set noswapfile                    " Remove swapfile when done
set viminfo=                      " Stop vim from saving crap settings

""" Neovim features
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
endif

""" Extra commands
" Press space to quit search:
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>
" Save with W
nnoremap W :w<CR>
" `make` with E
nnoremap E :make<CR>
" sudo save with Sudow
command Sudow w !sudo tee % >/dev/null

" Prio 1: Try Pathogen if it exists
if filereadable(glob("~/.vim/autoload/pathogen.vim"))
  execute pathogen#infect('pathogen-bundle/{}')

" Prio 2: Try Vundle if it exists
elseif isdirectory(glob("~/.vim/bundle"))
  set rtp+=~/.vim/bundle/Vundle.vim
  filetype off
  call vundle#begin()

  " Plugins
  " Plugin 'VundleVim/Vundle.vim'
  " Plugin 'Valloric/YouCompleteMe'
  " Plugin 'ctrlpvim/ctrlp.vim'

  call vundle#end()
  filetype plugin indent on
endif

""" Indenting and Filetypes:
" let g:is_bash=1 " Shell usually means bash
filetype plugin indent on
autocmd FileType python setlocal shiftwidth=4 softtabstop=4
autocmd FileType swift setlocal shiftwidth=4 softtabstop=4
autocmd FileType asm setlocal noexpandtab shiftwidth=8 softtabstop=8
