return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    adapters = {
      http = {
        ["llama-server"] = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "http://127.0.0.1:8080",
              chat_url = "/v1/chat/completions",
              api_key = nil, -- llama.cpp doesn't check this, just needs something present
            },
            schema = {
              model = { default = "qwen2.5-coder-3b" },
            },
          })
        end,
      },
    },
    strategies = {
      chat = {
        adapter = "llama-server",
        opts = { completion_provider = "blink" },
      },
      inline = { adapter = "llama-server" },
      cmd = { adapter = "llama-server" },
    },
  },
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle AI Chat", mode = { "n", "v" } },
    { "<leader>ai", "<cmd>CodeCompanion<cr>",            desc = "Inline AI Edit", mode = { "n", "v" } },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>",     desc = "AI Actions" },
  },
}
