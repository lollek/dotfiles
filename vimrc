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
      " Open fuzzy file finder
      map <Leader>f :FZF<CR>
      " Open fuzzy tag finder
      map <Leader>d :Tags<CR>

      "" NerdTree
      Plug 'preservim/nerdtree'
      map <Leader>n :NERDTree<CR>

      "" Theme
      " set t_Co=256
      " set background=dark
      " set termguicolors
      " Plug 'lollek/gruvbox.vim'
      " autocmd vimenter * ++nested colorscheme gruvbox

      "" Collection of common configurations for the Nvim LSP client
      Plug 'neovim/nvim-lspconfig'

      Plug 'hrsh7th/nvim-cmp'       " Autocompletion framework
      Plug 'hrsh7th/cmp-nvim-lsp'   " cmp LSP completion
      Plug 'hrsh7th/cmp-vsnip'      " cmp Snippet completion
      Plug 'hrsh7th/cmp-path'       " cmp Path completion
      Plug 'hrsh7th/cmp-buffer'
      " See hrsh7th other plugins for more great completion sources!

      "" Rust
      Plug 'hrsh7th/vim-vsnip'        " Snippet engine
      Plug 'simrat39/rust-tools.nvim' " Adds extra functionality over rust analyzer

      call plug#end()

      " Set completeopt to have a better completion experience
      " :help completeopt
      " menuone: popup even when there's only one match
      " noinsert: Do not insert text until a selection is made
      " noselect: Do not select, force user to select one from the menu
      set completeopt=menuone,noinsert,noselect

      " Avoid showing extra messages when using completion
      set shortmess+=c

      " Configure LSP through rust-tools.nvim plugin.
      "
      " rust-tools will configure and enable certain LSP features for us.
      " See https://github.com/simrat39/rust-tools.nvim#configuration
      lua <<EOF

      -- nvim_lsp object
      local nvim_lsp = require'lspconfig'

      local opts = {
          tools = {
              runnables = {
                  use_telescope = true
                  },
              inlay_hints = {
                  auto = true,
                  show_parameter_hints = false,
                  parameter_hints_prefix = "",
                  other_hints_prefix = "",
                  },
              },

          -- all the opts to send to nvim-lspconfig
          -- these override the defaults set by rust-tools.nvim
          -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
          server = {
              -- on_attach is a callback called when the language server attachs to the buffer
              -- on_attach = on_attach,
              settings = {
                  -- to enable rust-analyzer settings visit:
                  -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                  ["rust-analyzer"] = {
                      -- enable clippy on save
                      checkOnSave = {
                          command = "clippy"
                          },
                      }
                  }
              },
          }

      require('rust-tools').setup(opts)
EOF

      " Code navigation shortcuts
      " as found in :help lsp
      nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
      nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
      nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
      nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
      nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
      nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
      nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
      nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>

      " Quick-fix
      nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

      " Setup Completion
      " See https://github.com/hrsh7th/nvim-cmp#basic-configuration
      lua <<EOF
      local cmp = require'cmp'
      cmp.setup({
      snippet = {
          expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
          end,
          },
      mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Add tab support
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
          })
      },

  -- Installed sources
  sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'path' },
      { name = 'buffer' },
      },
  })
EOF

      " have a fixed column for the diagnostics to appear in
      " this removes the jitter when warnings/errors flow in
      set signcolumn=yes

      " Set updatetime for CursorHold
      " 300ms of no cursor movement to trigger CursorHold
      set updatetime=300
      " Show diagnostic popup on cursor hover
      autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

      " Goto previous/next diagnostic warning/error
      nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
      nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>
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
