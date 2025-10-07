set nocompatible
let mapleader = ','
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==> start Vim-Plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install vim-plug if not found
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(autoload_plug_path)
	silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
				\ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
endif
unlet autoload_plug_path

" List the actual plugins that you need to install here
call plug#begin(stdpath('data').'/plugged')

" Colorschemes
Plug 'lifepillar/vim-solarized8'
" Status Line
Plug 'hoob3rt/lualine.nvim'
" Icons for vim
Plug 'ryanoasis/vim-devicons'


" Rust support
Plug 'rust-lang/rust.vim'

" LSP configs that use native Neovim LSP engine
Plug 'neovim/nvim-lspconfig'

" autocompletion
"Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" 9000+ Snippets
"Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

Plug 'hrsh7th/nvim-compe'


call plug#end()

" Run PlugInstall if there are missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==> end Vim-Plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""
" ==> color scheme
""""""""""""""""""""""""""""""""""""""""

" solarized options
set background=light

set termguicolors
colorscheme solarized8_high

"""""""""""""""""""""""""""""""""
" ==> end colorscheme
"""""""""""""""""""""""""""""""""


" set the line number
set number " show the number for the line where the cursor lives
set relativenumber	" the line numbers will be relative
set signcolumn=yes

""""""""""""""""""""""""""""""""
" ==> Fuzzy Finders for search
""""""""""""""""""""""""""""""""
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


""""""""""""""""""""""""""""""""""
" ==> Python support for NeoVim
""""""""""""""""""""""""""""""""""
let g:python_host_prog = expand('~/.pyenv/shims/python2')
let g:python3_host_prog = expand('~/.pyenv/shims/python3')

""""""""""""""""""""""""""""""""""
" ==> Node support for NeoVim
""""""""""""""""""""""""""""""""""
let g:node_host_prog = expand('/usr/local/lib/node_modules/neovim/bin/cli.js')


" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
	set nobackup		" do not keep a backup file, use versions instead
else
	set backup		" keep a backup file (restore to previous version)
	set undofile		" keep an undo file (undo changes after closing)
endif
set history=50		" keep 50 lines of command line history
"set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

set encoding=UTF-8
"set fileencoding=utf-8

" Move temporary files to a secure location to protect against CVE-2017-1000382
if exists('$XDG_CACHE_HOME')
	let &g:directory=$XDG_CACHE_HOME
else
	let &g:directory=$HOME . '/.cache'
endif
let &g:undodir=&g:directory . '/nvim/undo//'
let &g:backupdir=&g:directory . '/nvim/backup//'
let &g:directory.='/nvim/swap//'
" Create directories if they doesn't exist
if ! isdirectory(expand(&g:directory))
	silent! call mkdir(expand(&g:directory), 'p', 0700)
endif
if ! isdirectory(expand(&g:backupdir))
	silent! call mkdir(expand(&g:backupdir), 'p', 0700)
endif
if ! isdirectory(expand(&g:undodir))
	silent! call mkdir(expand(&g:undodir), 'p', 0700)
endif

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
	" Enable file type detection.
	" automatically do language-dependent indenting.
	filetype plugin indent on

	augroup fileTypeEx
		au!
		"		autocmd FileType rust COQnow --shut-up
	augroup END

else
	set autoindent		" always set autoindenting on
endif " has("autocmd")


nnoremap <leader>so :source %<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==> Terminal mode key map for Neovim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
"To map <Esc> to exit terminal-mode:
tnoremap <Esc> <C-\><C-n>

"To simulate |i_CTRL-R| in terminal-mode:
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'


let g:coq_settings = { 'auto_start': v:true, 
\	'limits.completion_auto_timeout': 0.99,
\	'limits.completion_manual_timeout': 0.99,
\	}

" LSP config (the mappings used in the default file don't quite work right)
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
" auto-format
autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 100)


lua << EOF


--"""""""""""""""""""""""""""""
--" ==> Setup the status line
--"""""""""""""""""""""""""""""
-- Lualine setup for status line

require'lualine'.setup{}

-- LSP config
local nvim_lsp = require('lspconfig')
--Autocompletions
--local nvim_coq = require('coq')

vim.o.completeopt = "menuone,noselect"

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = false;

  source = {
    path = true;
    buffer = true;
    calc = true;
    vsnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})


local custom_attach = function(client)
    require'compe'.on_attach(client)
end

--vim.cmd('COQnow --shut-up')
--nvim_lsp.rust_analyzer.setup(nvim_coq.lsp_ensure_capabilities({
nvim_lsp.rust_analyzer.setup({
on_attach=custom_attach,
settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})
--Uncomment for nvim_coq
--)


--nvim_lsp.rls.setup(nvim_coq.lsp_ensure_capabilities({}))

EOF
""""""""""""""""""""""""""""""
" ==> End Lua code
""""""""""""""""""""""""""""""

