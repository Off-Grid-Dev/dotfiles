return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		-- Ensure mason-lspconfig is loaded first
		local mason_lspconfig = require("mason-lspconfig")
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Common LSP settings
		local on_attach = function(client, bufnr)
			-- Enable inlay hints if supported
			if client:supports_method("textDocument/inlayHint") then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end

			-- Buffer-local keymaps
			local map = function(mode, keys, func, desc)
				vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
			end

			map("n", "grn", vim.lsp.buf.rename, "Rename symbol")
			map({ "n", "v" }, "gra", vim.lsp.buf.code_action, "Code action")
			map("n", "grD", vim.lsp.buf.declaration, "Go to declaration")
			map("n", "gD", vim.lsp.buf.type_definition, "Go to type definition")
			map("n", "gd", vim.lsp.buf.definition, "Go to definition")
			map("n", "gr", vim.lsp.buf.references, "Go to references")
			map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")

			-- Auto-highlight references on CursorHold
			if client:supports_method("textDocument/documentHighlight") then
				local augroup = vim.api.nvim_create_augroup("lsp-highlight-" .. bufnr, { clear = true })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = bufnr,
					group = augroup,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = bufnr,
					group = augroup,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end

		-- Setup mason-lspconfig
		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"phpactor",
				"rust_analyzer",
				"html",
				"cssls",
				"jsonls",
				"yamlls",
				"eslint",
				"emmet_ls",
			},
			automatic_installation = false,

			-- Default handler for all servers
			function(server_name)
				vim.lsp.config(server_name, {
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end,

			-- Special handler for lua_ls
			["lua_ls"] = function()
				vim.lsp.config("lua_ls", {
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = vim.api.nvim_get_runtime_file("", true),
							},
							telemetry = { enable = false },
							hint = { enable = true },
						},
					},
				})
			end,
		})

		-- Diagnostic configuration
		vim.diagnostic.config({
			update_in_insert = false,
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			virtual_text = { spacing = 2, prefix = "●" },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			},
		})
	end,
}
