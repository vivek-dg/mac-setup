""""""""""""""""""""""""""""""""""
" ==> DAP shortcuts
""""""""""""""""""""""""""""""""""
nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
nnoremap <silent> <leader>dso :lua require'dap'.step_over()<CR>
nnoremap <silent> <leader>dsi :lua require'dap'.step_into()<CR>
nnoremap <silent> <leader>dsu :lua require'dap'.step_out()<CR>
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

require('dap').set_log_level('DEBUG')

-- set this variable to lldb or gdb according your preference
-- setrust
local debugger_for_rust = 'lldb'

if debugger_for_rust == 'lldb' then

	-- lldb paths
	-- Linux
	local rust_adapter_command = '/usr/bin/lldb-vscode'

	--MacOS
	if vim.fn.has('mac') == 1 then
		print "mac detected..."
		--Brew llvm : works!
		-- should try with   $(brew --prefix llvm)/bin/lldb-vscode and $(brew --prefix llvm)/bin/lldb
		rust_adapter_command = '/usr/local/opt/llvm/bin/lldb-vscode'


		--other midebugger values that work
		--rust_midebugger_path = '/usr/local/opt/llvm/bin/lldb'
		--Make sure it's signed
		--rust_midebugger_path = vim.fn.expand('~/.cargo/bin/rust-lldb')
		--rust_midebugger_path = vim.fn.expand('~/.cargo/bin/rust-gdb')

		--print ("adapter: " .. rust_adapter_command)
		--print ("debugger: " .. rust_midebugger_path)
	end


	-- Rust / c / c++ : Adapter
	local dap = require('dap')
	dap.adapters.lldb = {
		type = 'executable',
		command = rust_adapter_command,
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
				return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
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
			--miDebuggerPath = rust_midebugger_path,
			MIMode = "lldb",

			--trying adding for codelldb
			--sourceLanguages = {"rust"}

			},
		}

elseif debugger_for_rust == 'gdb' then

	-- gdb paths
	-- Linux
	local rust_adapter_command = vim.fn.expand('~/Documents/dev/gdb/cpptools-linux/extension/debugAdapters/OpenDebugAD7')
	local rust_midebugger_path = '/usr/bin/rust-gdb'
	local rust_mimode = 'gdb'

	-- MacOS
	if vim.fn.has('mac') == 1 then

		-- WORKS! with OpenDebugAD7, lldb-mi and mimode = 'lldb'
		rust_adapter_command = vim.fn.expand('~/.vscode/extensions/ms-vscode.cpptools-1.5.1/debugAdapters/OpenDebugAD7')
		rust_midebugger_path = vim.fn.expand('~/.vscode/extensions/ms-vscode.cpptools-1.5.1/debugAdapters/lldb-mi/bin/lldb-mi')

		--rust_midebugger_path= vim.fn.expand('~/.cargo/bin/rust-gdb')
		rust_mimode = 'lldb'

	end

	-- Rust / c / c++ : Adapter
	local dap = require('dap')
	dap.adapters.cppdbg = {
		type = 'executable',
		command = rust_adapter_command,
		name = "cppdbg"
		}


	-- DAP config for Rust / c / c++
	local dap = require('dap')
	dap.configurations.rust= {
		{
				name = "Launch file",
				type = "cppdbg",
				request = "launch",
				stopOnEntry = false,
				cwd = '${workspaceFolder}',
				MIMode = rust_mimode,
				miDebuggerPath = rust_midebugger_path,
				externalConsole = false,
				program = function()
				return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
			end,
			},
		{
				name = "Attach to gdbserver :1234",
				type = "cppdbg",
				request = "launch",
				MIMode = rust_mimode,
				miDebuggerServerAddress = "localhost:1234",
				miDebuggerPath = rust_midebugger_path,
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

EOF

