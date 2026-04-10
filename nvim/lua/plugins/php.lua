-- AppData/Local/nvim/lua/plugins/lang/php.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        phpactor = {
          settings = {
            phpactor = {
              language_server_worse_reflection_inlay_hints = { enable = true },
              language_server_code_transform = {
                apply = "never",
              },
            },
          },
        },
      },
    },
  },
  -- Optional: Addintelephense alternative
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       intelephense = {
  --         settings = {
  --           intelephense = {
  --             files = { maxSize = 5000000 }, -- 5MB
  --             stubs = { "wordpress", "woocommerce" }, -- Add as needed
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
}