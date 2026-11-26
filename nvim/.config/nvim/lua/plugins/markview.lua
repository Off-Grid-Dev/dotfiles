return {
  "OXY2DEV/markview.nvim",
  lazy = true,
  ft = "markdown", -- Laster kun når du åpner en markdown-fil
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons" -- Valgfritt: Gir fine ikoner i lister og kodeblokker
  },
  config = function()
    local markview = require("markview")

    markview.setup({
      -- Grunnerleggende konfigurasjon (kan tilpasses etter eget ønske)
      preview = {
        filetypes = { "markdown", "quarto", "rmd" },
        ignore_fp = { "text" },
      },
      
      -- Eksempel på hvordan du kan endre ikoner for overskrifter (valgfritt)
      headings = {
        enable = true,
        shift_width = 1,
      },

      -- Aktiver/deaktiver spesifikke elementer du vil style
      code_blocks = { enable = true },
      tables      = { enable = true },
      checkboxes  = { enable = true },
    })

    -- Nyttige tasteprevinger (Keymaps) for å skru visningen av/på manuelt
    vim.keymap.set("n", "<leader>mv", "<cmd>Markview toggle<cr>", { desc = "Toggle Markview (Markdown Preview)" })
    vim.keymap.set("n", "<leader>ms", "<cmd>Markview splitToggle<cr>", { desc = "Toggle Split Markdown View" })
  end
}
