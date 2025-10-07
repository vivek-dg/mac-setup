" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
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
"Plug 'morhetz/gruvbox'
"Plug 'dracula/vim'
"Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'
"Plug 'freeo/vim-kalisi'
"Plug 'arzg/vim-colors-xcode'
"Plug 'chriskempson/base16-vim'

" Colorizer
Plug 'norcalli/nvim-colorizer.lua'

" Java syntax
Plug 'uiiaoo/java-syntax.vim'

" Rust support
Plug 'rust-lang/rust.vim'

" Search Interfaces
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Source Control - symbols
Plug 'airblade/vim-gitgutter'
" Source control - interaction
Plug 'tpope/vim-fugitive'

" File Navigation
Plug 'justinmk/vim-dirvish'

" Tabular
Plug 'godlygeek/tabular'

"Startup time
Plug 'dstein64/vim-startuptime'

" LSP enable
"Plug 'prabirshrestha/vim-lsp'
"Plug 'mattn/vim-lsp-settings'

" Enable autocomplete
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'
"
" Latex
"Plug 'lervag/vimtex'

Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'

" Highlighting for toml files
Plug 'cespare/vim-toml'

" Optional dependencies
Plug 'nvim-lua/popup.nvim'
" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Debugging (needs plenary from above as well)
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-telescope/telescope-dap.nvim'

" Status Line
Plug 'hoob3rt/lualine.nvim'

" Icons for vim
Plug 'ryanoasis/vim-devicons'

" Markdown support
Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app && yarn install'}

call plug#end()

" Run PlugInstall if there are missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==> end Vim-Plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""
" Git markers update
""""""""""""""""""""""
let g:gitgutter_realtime = 1
set updatetime=250

" Use fontawesome icons as signs
let g:gitgutter_sign_added = ''
let g:gitgutter_sign_modified = ''
let g:gitgutter_sign_removed = ''
let g:gitgutter_sign_removed_first_line = ''
let g:gitgutter_sign_modified_removed = ''


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


if isdirectory(expand(stdpath('data').'/plugged/fzf') || expand('~/.vim/plugged/fzf')) || executable('fzf')
	" PLUGIN: FZF
	nnoremap <silent> <leader>b   :Buffers<CR>
	nnoremap <silent> <C-p>       :Files<CR>
	nnoremap <silent> <leader>f   :Rg<CR>
	nnoremap <silent> <leader>/   :BLines<CR>
	nnoremap <silent> <leader>'   :Marks<CR>
	nnoremap <silent> <leader>g   :Commits<CR>
	nnoremap <silent> <leader>H   :Helptags<CR>
	nnoremap <silent> <leader>hh  :History<CR>
	nnoremap <silent> <leader>h:  :History:<CR>
	nnoremap <silent> <leader>h/  :History/<CR>


	" The query history for this command will be stored as 'ls' inside g:fzf_history_dir.
	" The name is ignored if g:fzf_history_dir is not defined.
	command! -bang -complete=dir -nargs=? LS
				\ call fzf#run(fzf#wrap('ls', {'source': 'ls', 'dir': <q-args>}, <bang>0))

	if executable('fd')
		command! -bang -complete=dir -nargs=? FD
					\ call fzf#run(fzf#wrap('fd', {'source':'fd -td', 'dir': <q-args>, 'sink': 'cd'}, <bang>0))

		" Switch working directories fast!
		nnoremap <silent> <leader>fd :FD ~<CR>
	endif
endif


"""""""""""""""""""""""""""""""""""""""""""
" ==> Ripgrep for searching file contents
"""""""""""""""""""""""""""""""""""""""""""

if executable('rg')
	set grepprg=rg\ --vimgrep\ --smart-case\ --follow

	" We will be using Rg specifically only for searching within files
	" Fzf for file finding with Rg command defaulted internally.
	command! -bang -nargs=* Rg call fzf#vim#grep(
				\ "rg --column --line-number --no-heading --color=always --smart-case "
				\ .shellescape(<q-args>), 1,
				\ {'options': '--delimiter : --nth 4..'}, <bang>0
				\ )
endif


""""""""""""""""""""""""""""""""""
" ==> Python support for NeoVim
""""""""""""""""""""""""""""""""""
let g:python_host_prog = expand('/.pyenv/shims/python2')
let g:python3_host_prog = expand('/.pyenv/shims/python3')

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


"For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
	highlight clear CursorLine
	let g:java_highlight_all = 1 " Enable full highlighting for Java
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=78

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		autocmd BufReadPost *
					\ if line("'\"") >= 1 && line("'\"") <= line("$") |
					\   exe "normal! g`\"" |
					\ endif
	augroup END

	" Enable file type detection
	filetype on

	augroup fileTypeEx
		au!
		" Syntax of these languages is fussy over tabs Vs spaces
		autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
		autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

		" Treat .rss files as XML
		autocmd BufNewFile,BufRead *.rss setfiletype xml

		" Set syntax off for Java for interview practice
		autocmd FileType java setlocal syntax=OFF
	augroup END

else
	set autoindent		" always set autoindenting on
endif " has("autocmd")



""""""""""""""""""""""""""""""
" ==> Convenient Diffs
""""""""""""""""""""""""""""""
" Command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
				\ | wincmd p | diffthis -c 'set diffopt+=iwhite'
endif



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==>
" Prevent that the langmap option applies to characters that result from a
" mapping.  If unset (default), this may break plugins (but it's backward
" compatible).
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('langmap') && exists('+langnoremap')
	set langnoremap
endif


"""""""""""""""""""""""""""""""""
" ==> Reload vimrc file on save
"""""""""""""""""""""""""""""""""
if has ('autocmd') " Remain compatible with earlier versions
	augroup vimrc     " Source vim configuration upon save
		au!
		autocmd! BufWritePost $MYVIMRC nested source % | echom "Reloaded " . $MYVIMRC | redraw
		autocmd! BufWritePost $MYGVIMRC nested if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
	augroup END
endif " has autocmd

nnoremap <leader>so :source %<CR>


""""""""""""""""""""""""""""""""
" ==> Whitespace and Indentation
""""""""""""""""""""""""""""""""
" Execute <leader>$ for removing all whitespace at the end of line for the entire
" file
" Execute <leader>= for re-indenting the entire file
function! <SID>Preserve(command)
	" Preparation: save last search, and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")
	" Do the business:
	execute a:command
	" Clean up: restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
endfunction


"Clean Trailing WhiteSpaces
function! <SID>ClearWhiteSpaces()
	call <SID>Preserve("%s/\\s\\+$//e")
endfunction

nmap <leader>$ :call <SID>ClearWhiteSpaces()<CR>
nmap <leader>= :call <SID>Preserve("normal gg=G")<CR> "fix Indentation

" Remove trailing whitespaces for all the programming files on save
if has ('autocmd') " Remain compatible with earlier versions
	augroup vimrcWS     " Source vim configuration upon save
		au!
		autocmd BufWritePre *.py,*.js,*.java,$MYVIMRC,$MYGVIMRC :call <SID>ClearWhiteSpaces()
	augroup END
endif " has autocmd


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==> Change working directory of current window to that of the current file
nnoremap <leader>cd :lcd %:p:h<CR>:pwd<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""
" ==> Invisible Chars
""""""""""""""""""""""""""""""""

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬


""""""""""""""""""""""""""""""""
" ==> tabstop
""""""""""""""""""""""""""""""""

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
	let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
	if l:tabstop > 0
		let &l:sts  = l:tabstop
		let &l:ts   = l:tabstop
		let &l:sw   = l:tabstop
	endif
	call SummarizeTabs()
endfunction

command! -nargs=* SummarizeTabs call SummarizeTabs()
function! SummarizeTabs()
	try
		echohl ModeMsg
		echon 'tabstop='.&l:ts
		echon ' shiftwidth='.&l:sw
		echon ' softtabstop='.&l:sts
		if &l:et
			echon ' expandtab'
		else
			echon ' noexpandtab'
		endif
	finally
		echohl None
	endtry
endfunction

" Set the tabstop softtabstop and shiftwidth to 4 manually on startup
" If you like to change these values, use Stab command above
" If you like to view the current configuration for tabs, use SummarizeTabs
" command
" You'll need to use the ftplugin for programming language specific tabbing
set ts=4 sts=4 sw=4 noexpandtab


""""""""""""""""""""""""""""""""""
" ==> Clearing Registers
""""""""""""""""""""""""""""""""""
function! ClearRegisters()
	let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
	for r in regs
		call setreg(r, [])
	endfor
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==> Copy current line and paste to new buffer in a new window
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F3> :redir @a<CR>:normal! Y<CR>:redir END<CR>:vnew<CR>:put! "a<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ==> open splits to the right and to the bottom
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
set splitbelow
set splitright

set title

