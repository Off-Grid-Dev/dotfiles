return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = true,
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        telescope = true,
        notify = true,
        mini = { enabled = true },
        treesitter = true,
        noice = true,
        lsp_trouble = true,
      },
      custom_highlights = function(colors)
        return {
          -- Neon accent overrides
          CursorLine = { bg = colors.surface0 },
          Visual = { bg = colors.surface1, style = { "italic" } },
          Comment = { fg = colors.overlay0, style = { "italic" } },
          -- Neon hints
          DiagnosticHint = { fg = colors.lavender },
          DiagnosticVirtualTextHint = { fg = colors.lavender },
          -- Prettier/ESLint highlights
          LspReferenceText = { underline = true, bg = colors.surface1 },
          LspReferenceRead = { underline = true, bg = colors.surface1 },
          LspReferenceWrite = { underline = true, bg = colors.surface1 },
        }
      end,
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}

