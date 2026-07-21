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
  {
    "saecki/crates.nvim",
    ft = { "toml" },
    opts = {
      popup = { border = "rounded" },
    },
  },
}
