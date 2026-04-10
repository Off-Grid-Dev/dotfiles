return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
  config = function()
    require("noice").setup({
      messages = {
        enabled = false, -- Disable the bottom message area completely
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      views = {
        cmdline_popup = {
          position = { row = "50%", col = "50%" },
          border = { style = "rounded", padding = { 1, 2 } },
        },
      },
      -- Suppress common noisy messages
      routes = {
        {
          filter = { event = "msg_show", kind = "", find = "written" },
          opts = { skip = true },
        },
        {
          filter = { event = "lsp", kind = "progress" },
          view = "mini", -- Show LSP progress as tiny popup, not bottom bar
        },
      },
    })
    require("notify").setup({
      background_colour = "#200030",
      timeout = 1200, -- Faster dismiss
      top_down = true,
    })
    vim.notify = require("notify")
  end,
}
