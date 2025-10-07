" Use Vim settings, rather than Vi settings.
" This must be first, because it changes other options as a side effect.
set nocompatible

" Install vim-plug if not found
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(autoload_plug_path)
	silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs 
				\ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
endif
unlet autoload_plug_path

"""""""""""""""""""""""
" ==> start Vim-Plug
""""""""""""""""""""""
" List the actual plugins that you need to install here
" Modify plugin path as needed. 
call plug#begin(stdpath('data').'/plugged')

" Colorschemes
Plug 'morhetz/gruvbox'

" Rust support
Plug 'rust-lang/rust.vim'

Plug 'neovim/nvim-lspconfig'

" Optional dependencies
Plug 'nvim-lua/popup.nvim'
" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Using vim-plug
Plug 'puremourning/vimspector'

call plug#end()

" Run PlugInstall if there are missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

""""""""""""""""""""
" ==> end Vim-Plug
""""""""""""""""""""

" Set colorscheme
set background=dark

set termguicolors
"let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
colorscheme gruvbox

set number
"set relativenumber
set encoding=utf-8


" Set personalized leader
let mapleader = ','

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" You can use 'VISUAL_STUDIO' or 'HUMAN'
" Visual Studio config avoid to the mapping of <F3> key, sometimes used to map file explorer buffer.
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

lua << EOF


EOF
""""""""""""""""""""""""""""""
" ==> End Lua code
""""""""""""""""""""""""""""""
