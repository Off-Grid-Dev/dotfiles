return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
		build = ":MasonUpdate",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "⟳",
					package_uninstalled = "✗",
				},
			},
			max_concurrent_installers = vim.g.is_windows and 2 or 4,
		},
	},
}
