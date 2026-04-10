-- AppData/Local/nvim/lua/plugins/lang/cpp.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = vim.g.is_windows and { "clangd.exe", "--background-index", "--clang-tidy" } or { "clangd", "--background-index", "--clang-tidy" },
          capabilities = {
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = true,
                },
              },
            },
          },
        },
      },
    },
  },
}
