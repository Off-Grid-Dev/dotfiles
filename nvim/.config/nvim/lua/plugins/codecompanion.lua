return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "saghen/blink.cmp",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "ollama_gemma",
        },
        inline = {
          adapter = "ollama_ornith",
        },
      },
      adapters = {
        http = {
          ollama_gemma = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "gemma4:12b",
              schema = {
                model = {
                  default = "gemma4:12b",
                },
              },
            })
          end,
          ollama_ornith = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "ornith-1.5:9b",
              schema = {
                model = {
                  default = "ornith-1.5:9b",
                },
              },
            })
          end,
        },
      },
      display = {
        chat = {
          render_headers = true,
          window = {
            layout = "vertical",
            position = "right",
            width = 0.35,
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle AI Chat (Right Sidebar)" },
    { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline AI Popup / Refactor" },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Action Palette" },
  },
}
