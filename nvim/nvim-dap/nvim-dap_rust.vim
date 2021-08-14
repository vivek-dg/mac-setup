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
Plug 'simrat39/rust-tools.nvim'

" Optional dependencies
Plug 'nvim-lua/popup.nvim'
" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Debugging (needs plenary from above as well)
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-telescope/telescope-dap.nvim'

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


""""""""""""""""""""
" ==> DAP shortcuts
"""""""""""""""""""" 
nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
" If Function keys are already mapped to other items, use below
nnoremap <silent> <leader>dr :lua require'dap'.step_over()<CR>
nnoremap <silent> <leader>di :lua require'dap'.step_into()<CR>
nnoremap <silent> <leader>do :lua require'dap'.step_out()<CR>

nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>


lua << EOF

--------------------------------------------------------------------
-- DAP tool for debugging - Needs individual setup for each language
-- Requires 1. Adapter per language
--			2. Config per language
--------------------------------------------------------------------

-- Uncomment below and look at the log file ~/.cache/nvim/dap.log file for any issues
-- require('dap').set_log_level('DEBUG')

-- ************************************************************
-- set this variable to lldb or gdb according your preference

-- NOTE: It's obvious that you need only one debugger for 
-- debugging session to work. This is to just here to switch
-- between multiple setups as needed
-- ************************************************************
local debugger_for_rust = 'lldb'

if debugger_for_rust == 'lldb' then

	-- Rust / c / c++ : Adapter
	local dap = require('dap')
	dap.adapters.lldb = {
		type = 'executable',
		command = '/usr/bin/lldb-vscode', -- adjust as needed
		name = "lldb"
		}


	-- DAP config for Rust / c / c++
	local dap = require('dap')
	dap.configurations.rust= {
		{
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
				return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
			end,
			cwd = '${workspaceFolder}',
			stopOnEntry = false,
			args = {},

			-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
			--
			--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
			--
			-- Otherwise you might get the following error:
			--
			--    Error on launch: Failed to attach to the target process
			--
			-- But you should be aware of the implications:
			-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
			runInTerminal = false,
			},
		}

elseif debugger_for_rust == 'gdb' then

	-- Rust / c / c++ : Adapter
	local dap = require('dap')
	dap.adapters.rdbg = {
		type = 'executable',
		-- See the following page for how to install the cpptools for your operating system
		-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
		command = '/home/malolan/Documents/dev/gdb/cpptools-linux/extension/debugAdapters/OpenDebugAD7',
		name = "rdbg"
		}


	-- DAP config for Rust / c / c++
	local dap = require('dap')
	dap.configurations.rust= {
		{
				name = "Launch file",
				type = "rdbg",
				request = "launch",
				program = function()
				return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
			end,
			cwd = '${workspaceFolder}',
			stopOnEntry = false,
			},
		{
				name = "Attach to gdbserver :1234",
				type = "rdbg",
				request = "launch",
				MIMode = "gdb",
				miDebuggerServerAddress = "localhost:1234",
				-- Change to /usr/bin/gdb for c/c++
				miDebuggerPath = "/usr/bin/rust-gdb",
				cwd = '${workspaceFolder}',
				program = function()
				return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
			end,
			},
		}

end

--If you want to use this for c++ and c, add something like this:
--dap.configurations.c = dap.configurations.rust
--dap.configurations.cpp = dap.configurations.rust

-- add dap ui config
require("dapui").setup()

-- debug point highlight for dap
require('dap')
vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

-- Rust tools
-- This isn't necessary for nvim-dap or nvim-dap-ui to work
require('rust-tools').setup()


EOF
""""""""""""""""""""""""""""""
" ==> End Lua code
""""""""""""""""""""""""""""""
