-- AppData/Local/nvim/lua/plugins/lang/web.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {
          filetypes = { "html", "twig", "hbs" },
        },
        cssls = {
          filetypes = { "css", "scss", "less", "html" },
        },
      },
    },
  },
}