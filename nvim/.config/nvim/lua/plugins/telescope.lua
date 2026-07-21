return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup({
      defaults = {
        prompt_prefix = "   ",
        selection_caret = "  ",
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

    map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
    map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    map("n", "<leader>sb", builtin.buffers, { desc = "[S]earch [B]uffers" })
    map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
    map("n", "<leader>.", builtin.oldfiles, { desc = "Recent files" })
  end,
}
