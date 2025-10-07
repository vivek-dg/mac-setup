" " List the actual plugins that you need to install here
" call plug#begin(stdpath('data').'/plugged')

" " Rust support
" Plug 'rust-lang/rust.vim'
" Plug 'nvim-lua/lsp_extensions.nvim'

" " LSP configs that use native Neovim LSP client
" Plug 'neovim/nvim-lspconfig'
" " autocompletion
" Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" " 9000+ Snippets
" Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

" call plug#end()


" COQ settings override
"let g:coq_settings = { 'auto_start': v:true, 
"\	'limits.completion_auto_timeout': 0.99,
"\	'limits.completion_manual_timeout': 0.99,
"\	}
let g:coq_settings = { 'auto_start': v:true }


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


" Avoid showing extra messages when using completion
set shortmess+=c

lua << EOF

vim.o.completeopt = "menuone,noselect"

-- LSP config
local nvim_lsp = require('lspconfig')
--Autocompletions
local nvim_coq = require('coq')

local on_attach = function(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Enable rust_analyzer
nvim_lsp.rls.setup(nvim_coq.lsp_ensure_capabilities({}))
-- nvim_lsp.rust_analyzer.setup(nvim_coq.lsp_ensure_capabilities({
--    capabilities=capabilities,
--    on_attach=on_attach,
--}))


-- function to attach completion when setting up lsp
--local on_attach = function(client)
--	vim.cmd('COQnow --shut-up')
--	nvim_coq.on_attach(client)
--end
--
---- Enable rust_analyzer
--nvim_lsp.rust_analyzer.setup({ on_attach=on_attach })

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = true,
	signs = true,
	update_in_insert = true,
	}
)

EOF
""""""""""""""""""""""""""""""
" ==> End Lua code
""""""""""""""""""""""""""""""


"" Use <Tab> and <S-Tab> to navigate through popup menu
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"" use <Tab> as trigger keys
"imap <Tab> <Plug>(completion_smart_tab)
"imap <S-Tab> <Plug>(completion_smart_s_tab)


"" Code navigation shortcuts
"nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
"nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
"nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
"nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
"nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
"nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
"nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
"nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>


"nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
" autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

"" Goto previous/next diagnostic warning/error
"nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
"nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
			\ lua require'lsp_extensions'.inlay_hints{ prefix = ' >> ', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }
