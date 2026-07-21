return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      -- Transparent so the WezTerm background opacity (0.85) shows through
      transparent_background = true,
      term_colors = true,
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        neotree = true,
        telescope = true,
        notify = true,
        mini = { enabled = true },
        treesitter = true,
        noice = true,
        which_key = true,
      },
      custom_highlights = function(colors)
        return {
          CursorLine = { bg = colors.surface0 },
          Visual = { bg = colors.surface1, style = { "italic" } },
          Comment = { fg = colors.overlay0, style = { "italic" } },
          DiagnosticHint = { fg = colors.lavender },
          DiagnosticVirtualTextHint = { fg = colors.lavender },
          LspReferenceText = { underline = true, bg = colors.surface1 },
          LspReferenceRead = { underline = true, bg = colors.surface1 },
          LspReferenceWrite = { underline = true, bg = colors.surface1 },
        }
      end,
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
