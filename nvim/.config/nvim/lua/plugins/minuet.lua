return {
  "milanglacier/minuet-ai.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    require("minuet").setup({
      request_timeout = 3,
      throttle = 400,
      debounce = 200,
      provider = "openai_compatible",
      provider_options = {
        openai_compatible = {
          model = "ornith-1.5:9b",
          end_point = "http://localhost:11434/v1/chat/completions",
          api_key = "OLLAMA",
          name = "Ollama",
          stream = true,
          optional = {
            max_tokens = 128,
            temperature = 0.2,
          },
        },
      },
    })
  end,
}
