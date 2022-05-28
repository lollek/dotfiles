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
set nofoldenable                  " Disable folding per default
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

""" Extra commands
nnoremap <SPACE> <Nop>
let mapleader = " "

"" Remove highlight after searching
map <silent> <Leader><Space> :silent noh<Bar>echo<CR>

"" Quick save
map <Leader>w :w<CR>

"" Quick quit
map <Leader>q :q<CR>

"" Elevate with sudo and save
map <Leader>W :!sudo tee % >/dev/null

"" `make`
map <Leader>e :make<CR>

"" Recreate ctags
map <Leader>c :!ctags -R .<CR>

"" Hacky solution to pasting without yanking
map <Leader>p "_dP


""" Neovim features
if has('nvim')
  tnoremap <Esc> <C-\><C-n>

  "" See https://github.com/junegunn/vim-plug#unix-linux
  "" Then run :PlugInstall
  if filereadable(glob("~/.local/share/nvim/site/autoload/plug.vim"))
      call plug#begin()

      "" FZF
      Plug 'junegunn/fzf'
      Plug 'junegunn/fzf.vim'
      "" Open fuzzy file finder
      map <Leader>f :FZF<CR>
      "" Open fuzzy tag finder
      map <Leader>d :Tags<CR>

      "" NerdTree
      Plug 'preservim/nerdtree'
      map <Leader>n :NERDTree<CR>

      "" Theme
      set t_Co=256
      set background=dark
      set termguicolors
      Plug 'lollek/gruvbox.vim'
      autocmd vimenter * ++nested colorscheme gruvbox


      call plug#end()
  endif

endif

""" Indenting and Filetypes:
" let g:is_bash=1 " Shell usually means bash
filetype plugin indent on
autocmd FileType python setlocal shiftwidth=4 softtabstop=4
autocmd FileType swift setlocal shiftwidth=4 softtabstop=4
autocmd FileType asm setlocal noexpandtab shiftwidth=8 softtabstop=8
autocmd FileType go setlocal noexpandtab shiftwidth=8 softtabstop=8
autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
