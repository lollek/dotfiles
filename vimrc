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

  "" See https://github.com/junegunn/vim-plug#unix-linux
  "" Then run :PlugInstall
  if filereadable(glob("~/.local/share/nvim/site/autoload/plug.vim"))
      call plug#begin()

      "" FZF
      Plug 'junegunn/fzf'
      Plug 'junegunn/fzf.vim'
      "" Find fuzzy files with ^P
      nmap <C-P> :FZF<CR>
      "" Find fuzzy tags with ^N
      nmap <C-N> :Tags<CR>
      
      "" Theme                                                                                                                                                                           
      Plug 'morhetz/gruvbox'                                                                                                                                                             
      let g:gruvbox_italic=1                                                                                                                                                             
      let g:gruvbox_termcolors=16                                                                                                                                                        
      set nocursorline                                                                                                                                                                   
      autocmd vimenter * ++nested colorscheme gruvbox     

      call plug#end()
  endif

endif

""" Extra commands
" Press space to quit search:
nnoremap <silent> <Space> :noh<CR>
" Save with W
nnoremap W :w<CR>
" `make` with E
nnoremap E :make<CR>
" remake ctags with Q
nnoremap Q :!ctags -R .<CR>
" sudo save with Sudow
command Sudow w !sudo tee % >/dev/null

""" Indenting and Filetypes:
" let g:is_bash=1 " Shell usually means bash
filetype plugin indent on
autocmd FileType python setlocal shiftwidth=4 softtabstop=4
autocmd FileType swift setlocal shiftwidth=4 softtabstop=4
autocmd FileType asm setlocal noexpandtab shiftwidth=8 softtabstop=8
autocmd FileType go setlocal noexpandtab shiftwidth=8 softtabstop=8
