return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "catppuccin",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "neo-tree", "TelescopePrompt" },
				always_divide_middle = true,
				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "" },
				lualine_c = { "branch", "diff", "diagnostics" },
				lualine_x = {
					{
						"filetype",
						colored = true,
						icon_only = false,
					},
					"encoding",
				},
				lualine_z = {
					{ "filename" },
					{ "location" },
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "neo-tree", "fzf", "quickfix" },
		})
	end,
}
