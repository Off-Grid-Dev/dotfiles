-- AppData/Local/nvim/lua/plugins/lang/javascript.lua
-- Shared config for JS (extends typescript setup)
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          filetypes = { "javascript", "javascriptreact" },
        },
      },
    },
  },
}