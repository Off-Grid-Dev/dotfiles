vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- ── Bootstrap lazy.nvim ──────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

require("lazy").setup({
  spec = { { import = "plugins" } },
  rocks = { enabled = false, hererocks = false },
  ui = { icons = vim.g.have_nerd_font and {} or { plugin = "🔌", lazy = "💤" } },
})

-- ── Options ──────────────────────────────────────────────────────────────────
-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.breakindent = true

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 13
vim.opt.showmode = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- Behaviour
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.confirm = true
vim.opt.mouse = "a"

-- System clipboard (scheduled to keep startup fast)
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Reload neovim silently when changes are made other places
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})

-- ── Keymaps ──────────────────────────────────────────────────────────────────
local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Windows (mirrors the WezTerm leader scheme: v = right, s = below)
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split right" })
map("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split below" })
map("n", "<leader>wn", "<cmd>vnew<CR>", { desc = "New empty split right" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Arrow-key training wheels
for _, key in ipairs({ "h", "j", "k", "l" }) do
  local arrow = key == "h" and "left" or key == "j" and "down" or key == "k" and "up" or "right"
  map("n", "<" .. arrow .. ">", function()
    vim.notify("Use " .. key .. " to move " .. arrow, vim.log.levels.INFO)
  end, { desc = "Disabled (use " .. key .. ")" })
end

-- Diagnostics
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix" })

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ── Autocommands ─────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Auto-create parent directories on save",
  group = vim.api.nvim_create_augroup("auto-mkdir", { clear = true }),
  callback = function(args)
    if args.file:match("^%w+://") then
      return
    end
    vim.fn.mkdir(vim.fn.fnamemodify(args.file, ":p:h"), "p")
  end,
})

-- ── Update config from git ───────────────────────────────────────────────────
local function update_config()
  local config_path = vim.fn.stdpath("config")

  if vim.fn.executable("git") == 0 then
    vim.notify("git is not in PATH", vim.log.levels.ERROR)
    return
  end

  vim.fn.system(string.format("git -C %s rev-parse --is-inside-work-tree", config_path))
  if vim.v.shell_error ~= 0 then
    vim.notify("Config dir is not a git repo", vim.log.levels.WARN)
    return
  end

  local status = vim.fn.system(string.format("git -C %s status --porcelain", config_path))
  if status ~= "" then
    vim.notify("Config repo has uncommitted changes — commit or stash first", vim.log.levels.WARN)
    return
  end

  vim.notify("Pulling config…", vim.log.levels.INFO)
  vim.fn.jobstart({ "git", "-C", config_path, "pull", "--ff-only" }, {
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify("git pull failed", vim.log.levels.ERROR)
        return
      end
      local lazy_ok, lazy = pcall(require, "lazy")
      if lazy_ok then
        lazy.sync({ wait = true })
      end
      local mason_ok, registry = pcall(require, "mason-registry")
      if mason_ok then
        registry.refresh()
      end
      vim.notify("Config, plugins and Mason registry updated", vim.log.levels.INFO)
    end,
  })
end

map("n", "<leader>cu", update_config, { desc = "Update config and plugins from git" })
