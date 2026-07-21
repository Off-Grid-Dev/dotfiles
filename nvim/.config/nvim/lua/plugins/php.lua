return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      phpactor = {
        settings = {
          phpactor = {
            language_server_worse_reflection_inlay_hints = { enable = true },
            language_server_code_transform = { apply = "never" },
          },
        },
      },
    },
  },
}
