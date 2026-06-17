-- AppData/Local/nvim/lua/plugins/lang/rust.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
              cargo = { 
                allFeatures = true,
                loadOutDirsFromCheck = true,
              },
              procMacro = { enable = true },
              inlayHints = {
                bindingModeHints = { enable = true },
                closureReturnTypes = { enable = true },
                parameterHints = { enable = true },
                chainingHints = { enable = true },
              },
            },
          },
        },
      },
    },
  },
  -- Optional: Rust tools
  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup({
        null_ls = { enabled = true },
        popup = {
          border = "rounded",
        },
      })
    end,
  },
} 