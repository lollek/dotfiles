""" Extra commands
nnoremap <SPACE> <Nop>
let mapleader = " "

"" Shortcuts
map <Leader>w :w<CR>
map <Leader>q :q<CR>

"" Hacky solution to pasting without yanking
map <Leader>p "_dP

"" Remove highlight after searching
map <silent> <Leader><Space> :silent noh<Bar>echo<CR>

"" Visual
set listchars=tab:>·,trail:~,extends:>,precedes:<	" Configure invisible characters
set list						" Show invisible characters
set number						" Show line number to the left
set cursorline						" Highlight current line

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

"" FZF
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
	" Open fuzzy file finder
	map <Leader>f :FZF<CR>
	map <Leader>F :FZF ~<CR>
	" Open fuzzy tag finder
	map <Leader>d :Tags<CR>
	map <Leader>r :Rg<CR>

"" NerdTree
Plug 'preservim/nerdtree'
	map <Leader>n :NERDTree<CR>

"" Gruvbox color scheme
Plug 'morhetz/gruvbox'
	autocmd vimenter * ++nested colorscheme gruvbox

call plug#end()

autocmd FileType asm setlocal noexpandtab shiftwidth=8 softtabstop=8
autocmd FileType go setlocal noexpandtab shiftwidth=8 softtabstop=8
autocmd FileType markdown setlocal shiftwidth=2 softtabstop=2
autocmd FileType python setlocal shiftwidth=4 softtabstop=4
autocmd FileType sh setlocal noexpandtab shiftwidth=4 softtabstop=4
autocmd FileType swift setlocal shiftwidth=4 softtabstop=4
autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/
