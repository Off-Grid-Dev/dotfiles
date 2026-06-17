return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
		{ "<C-n>", "<cmd>Neotree filesystem reveal left<CR>", desc = "NeoTree reveal" },
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			source_selector = {
				winbar = true,
				statusline = false,
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = true,
					hide_by_name = {
						".git",
						".DS_Store",
						"thumbs.db",
						"node_modules",
					},
					never_show = {
						".git",
						".svn",
						".hg",
						".bzr",
						".tox",
						".venv",
						"venv",
						"env",
					},
				},
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
				use_libuv_file_watcher = vim.g.is_windows, -- Better for Windows
			},
			window = {
				position = "left",
				width = 30,
				mappings = {
					["<space>"] = "none",
					["<C-n>"] = "close_window",
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true,
					expander_collapsed = "",
					expander_expanded = "^",
					expander_highlight = "NeoTreeExpander",
				},
				git_status = {
					symbols = {
						added = "✚",
						deleted = "✖",
						modified = "m",
						renamed = "➜",
						untracked = "★",
						ignored = "◌",
						unstaged = "u",
						staged = "✓",
						conflict = "",
					},
				},
			},
		})
	end,
}
