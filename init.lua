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

-- window/pane stuff
map("n", "<leader>lf", "<cmd>vnew<CR>", { desc = "New Window Right" })
map("n", "<leader>ls", "<cmd>vsplit<CR>", { desc = "New Split Right (same shit, different window)" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })

-- Disable arrow keys in normal mode (optional training)
for _, key in ipairs({ "h", "j", "k", "l" }) do
  local arrow = key == "h" and "left" or key == "j" and "down" or key == "k" and "up" or "right"
  map("n", "<" .. arrow .. ">", function()
    vim.notify("Use the " .. key .. " to move " .. arrow .. " you wicked noob!", vim.log.levels.INFO)
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

-- Update config repo

local function update_config()
  local config_path = vim.fn.stdpath("config")

  -- 1. Safety Check: Ensure git is available
  if vim.fn.executable("git") == 0 then
    vim.notify("Git is not in yo PATH homey!!", vim.log.levels.ERROR)
    return
  end

  -- 2. Anoooother Safter Check: Ensure config is a git repo
  local git_check = vim.fn.system(string.format("git -C %s rev-parse --is-inside-work-tree", config_path))
  if vim.v.shell_error ~= 0 then
    vim.notify("Config dir is not in the git repo dipshit.", vim.log.levels.WARN)
    return
  end

  -- 3. What the fuck... Safety Check: Ensure no uncommitted changes (No Dirty Business)
  -- synchronously at first then get to work
  local status = vim.fn.system(string.format("git -C %s status --porcelain", config_path))
  if status ~= "" then
    vim.notify("Fix your shit! This place is a mess. Save or stash.", vim.log.levels.INFO)
    return
  end

  vim.notify("Let's get you updated!", vim.log.levels.INFO)

  -- 4. Run Git Pull Async
  vim.jobstart({
      "git",
      "-C",
      config_path,
      "pull",
      "--ff-only",
    },
    {
      on_exit = function(job_id, exit_code, event_type)
        if exit_code == 0 then
          vim.notify("Updated config repo.. it's Lazy and Mason time!", vim.log.levels.INFO)

          -- 5. Sync Lazy
          local status_ok, lazy = pcall(require, "lazy")
          if status_ok then
            lazy.sync({ wait = true })
          end

          -- 6. Refresh Mason
          local mason_ok, registry = pcall(require, "mason-registry")
          if mason_ok then
            registry.refresh()
            vim.notify("Mason is all fresh and sexy", vim.log.levels.INFO)
          end

          vim.notify("Config is happy and updated!", vim.log.levels.INFO)
        else
          vim.notify("Oh FUCK! The config is ruined and the world is over!", vim.log.levels.WARN)
        end
      end,
    }, {
      stdout_buffered = true,
      stderr_buffered = true,
    })
end

-- 7. Map config update
vim.keymap.set("n", "<leader>cu", update_config, { desc = "update config and plugins from github" })
