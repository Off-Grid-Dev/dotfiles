return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  opts = {
    -- Per-language servers live in their own files (cpp.lua, rust.lua, web.lua, …)
    -- and merge into this table through lazy.nvim spec merging.
    -- Set `enabled = false` on a server to keep mason-lspconfig from starting it.
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            hint = { enable = true },
          },
        },
      },
    },
  },
  config = function(_, opts)
    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

    local disabled = {}
    for name, cfg in pairs(opts.servers) do
      if cfg.enabled == false then
        table.insert(disabled, name)
      else
        vim.lsp.config(name, cfg)
      end
    end

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "phpactor",
        "rust_analyzer",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        "eslint",
        "emmet_ls",
      },
      automatic_enable = { exclude = disabled },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        local builtin = require("telescope.builtin")
        local bufmap = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
        end

        bufmap("n", "gd", builtin.lsp_definitions, "Go to definition")
        bufmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        bufmap("n", "grr", builtin.lsp_references, "References")
        bufmap("n", "gri", builtin.lsp_implementations, "Go to implementation")
        bufmap("n", "grt", builtin.lsp_type_definitions, "Go to type definition")
        bufmap("n", "grn", vim.lsp.buf.rename, "Rename symbol")
        bufmap({ "n", "v" }, "gra", vim.lsp.buf.code_action, "Code action")
        bufmap("n", "<leader>ss", builtin.lsp_document_symbols, "Document symbols")

        if client:supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end

        if client:supports_method("textDocument/documentHighlight") then
          local group = vim.api.nvim_create_augroup("lsp-highlight-" .. ev.buf, { clear = true })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = ev.buf,
            group = group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = ev.buf,
            group = group,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    vim.diagnostic.config({
      update_in_insert = false,
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR },
      virtual_text = { spacing = 2, prefix = "●" },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      },
    })
  end,
}
