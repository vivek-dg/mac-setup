# Setting up Rust Debugging with Neovim on Fedora Linux

This setup gives a way to easily test visual debugging on neovim for rust using the following tools. Serves as a simple startup template.

* [Neovim](https://neovim.io/)
* [nvim-dap](https://github.com/mfussenegger/nvim-dap)
	* [nvim-dap installation notes](https://github.com/mfussenegger/nvim-dap/wiki)
* [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
* [vim-plug](https://github.com/junegunn/vim-plug)
	* You don't need to install vim-plug manually when using the exact steps below. The sample startup config file would automatically install if unavailable on the system.
* There are some other minimal use of plugins just to make things easier

* Easily extendable to other flavors of linux, unix and MacOS.
* Easily extendable to C and C++ with some minor modifications.
* Go check out the original project websites, and learn more about them.

## Neovim + tools install
```
sudo dnf install neovim
sudo dnf install ripgrep
sudo dnf install fzf
sudo dnf install bat
sudo dnf install fd-find
```

## Treesitter
```
npm install -g tree-sitter
npm install -g tree-sitter-cli
```

## Get either lldb or gdb
```
sudo dnf install lldb
```

## Need at least one of these
```
sudo dnf install rust-lldb
sudo dnf install rust-gdb
```

## Check libstdc++ availability. Mine had an issue for some reason
```
sudo dnf install libstdc++-static
```

## Rust compiler + cargo
```
sudo dnf install rust cargo
```

## Install rust-analyzer and source for better support
```
sudo dnf install rust-src
sudo dnf copr enable robot/rust-analyzer
sudo dnf install rust-analyzer
```

## If using gdb, then you need the debug adapter
Go through the instructions for vscode-cpptools at the [wiki site for nvim-dap](https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-\(gdb-via--vscode-cpptools\)).

## Additional hints and gotchas
* If you don't use `vim-plug`, or for other reasons would like to delete the entire list of plugins after testing this out, then you could delete the corresponding directories easily.
	* `~/.local/share/nvim/site/autoload/plug.vim`
	* `~/.local/share/nvim/plugged`
	* For all the other installations above, use the appropriate `sudo dnf remove ...` commands
* If you already have `vim-plug` then check out the correct installation directories within the `nvim-dap_rust.vim` file. 
* Don't forget to use the `-g` flag when invoking `rustc` directly. Otherwise
the debug symbols won't be available. Your debugger won't work as expected.
* Change the variable `debugger_for_rust` to the appropriate value according to your setup within the default `nvim-dap_rust.vim`. 


## Fire up Neovim
* Get the `nvim-dap_rust.vim` file somewhere on your local machine and start Neovim with `nvim -u /path/to/nvim-dap_rust.vim`.
* This will make sure your existing configuration won't mess up.
* If you need to manually update some of the plugins, use `:PlugClean`, `:PlugUpdate` and `:PlugInstall` appropriately.

## Final check
* Make sure you have the compiled binary file for your project/source file ready. It should be compiled with debug symbols. For `rustc`, it is with the option `-g`.


## Start the debug session
* Open up the rust file that you want to run within Neovim.
* Move your cursor to a line where you'd like to place a breakpoint.
* Press `<leader>b` to toggle breakpoint according to the shortcuts. You should see a red marker on the editor.
* Press `F5`. You'll be asked to select a binary. Make sure you fill out the correct binary file name.
* That's it. You should see the debugging UI within Neovim with the session stopped at your breakpoint.
