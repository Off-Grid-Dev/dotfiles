-- lua/plugins/telescope.lua
return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				prompt_prefix = "   ",
				selection_caret = "  ",
				path_display = { "smart" },
				file_ignore_patterns = { "node_modules", "%.git/", "%.venv/", "vendor/" },
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<Esc>"] = actions.close,
						["<C-c>"] = actions.close,
					},
					n = {
						["q"] = actions.close,
					},
				},
			},
		})

		local builtin = require("telescope.builtin")
		local map = vim.keymap.set

		-- Search mappings
		map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		map("n", "<leader>sb", builtin.buffers, { desc = "[S]earch [B]uffers" })
		map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		map("n", "<leader>.", builtin.oldfiles, { desc = "[S]earch Recent Files" })

		-- LSP mappings (set on LspAttach - with nil checks!)
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local buf = ev.buf
				local opts = { buffer = buf, desc = "LSP Telescope" }

				-- Only set keymaps if the function exists
				if builtin.lsp_definitions then
					map(
						"n",
						"gd",
						builtin.lsp_definitions,
						vim.tbl_extend("force", opts, { desc = "Go to Definition" })
					)
				end
				if builtin.lsp_references then
					map("n", "gr", builtin.lsp_references, vim.tbl_extend("force", opts, { desc = "Go to References" }))
				end
				if builtin.lsp_declarations then
					map(
						"n",
						"gD",
						builtin.lsp_declarations,
						vim.tbl_extend("force", opts, { desc = "Go to Declaration" })
					)
				end
				if builtin.lsp_implementations then
					map(
						"n",
						"gI",
						builtin.lsp_implementations,
						vim.tbl_extend("force", opts, { desc = "Go to Implementation" })
					)
				end
				if builtin.lsp_type_definitions then
					map(
						"n",
						"gT",
						builtin.lsp_type_definitions,
						vim.tbl_extend("force", opts, { desc = "Go to Type Definition" })
					)
				end
				if builtin.lsp_document_symbols then
					map(
						"n",
						"<leader>ss",
						builtin.lsp_document_symbols,
						vim.tbl_extend("force", opts, { desc = "Document Symbols" })
					)
				end
			end,
		})
	end,
}
