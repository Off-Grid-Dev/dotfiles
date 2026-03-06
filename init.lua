vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.is_windows = vim.fn.has("win32") == 1
vim.g.have_nerd_font = true

-- Install lazy.nvim if missing
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy with plugins import
require("lazy").setup({
	spec = { { import = "plugins" } },
	rocks = { enabled = false, hererocks = false },
	ui = { icons = vim.g.have_nerd_font and {} or { plugin = "🔌", lazy = "💤" } },
})

-- options
-- Typography & Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- UI & Display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 13
vim.opt.showmode = false
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Search & Navigation
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Clipboard (Windows-compatible)
vim.schedule(function()
	if vim.g.is_windows then
		vim.opt.clipboard = "unnamed"
	else
		vim.opt.clipboard = "unnamedplus"
	end
end)

-- Whitespace visualization
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Undo & Safety
vim.opt.undofile = true
vim.opt.confirm = true
vim.opt.breakindent = true

-- Mouse support
vim.opt.mouse = "a"

-- Keymaps
local map = vim.keymap.set

-- Clear search highlights
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- NeoTree toggle
map("n", "<C-n>", "<cmd>Neotree filesystem reveal left<CR>", { desc = "Toggle NeoTree" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })

-- Disable arrow keys in normal mode (optional training)
for _, key in ipairs({ "h", "j", "k", "l" }) do
	local arrow = key == "h" and "left" or key == "j" and "down" or key == "k" and "up" or "right"
	map("n", "<" .. arrow .. ">", function()
		vim.notify("Use the " .. key .. " to move you wicked noob!", vim.log.levels.WARN)
	end, { desc = "Disable arrow key" })
end

-- Diagnostic shortcuts
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix" })

-- Format buffer
map({ "n", "v" }, "<leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- Exit terminal mode easily
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Auto Commands
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

-- Auto-create directory when saving
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Auto-create parent directories",
	callback = function(args)
		local dir = vim.fn.fnamemodify(args.file, ":p:h")
		vim.fn.mkdir(dir, "p")
	end,
})
