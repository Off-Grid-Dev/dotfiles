return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "v" },
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      end
      return {
        timeout_ms = 1000,
        lsp_format = "fallback",
      }
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
      typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
      html = { "biome", "prettier" },
      css = { "biome", "prettier" },
      scss = { "prettierd", "prettier", stop_after_first = true },
      json = { "biome", "prettierd", "prettier", stop_after_first = true },
      jsonc = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      php = { "pretty-php", "php_cs_fixer", stop_after_first = true },
      rust = { "rustfmt" },
      cpp = { "clang-format" },
      c = { "clang-format" },
    },
    formatters = {
      prettierd = {
        condition = function(_, ctx)
          -- Only use prettierd if package.json or .prettierrc exists nearby
          local util = require("conform.util")
          return util.root_pattern("package.json", ".prettierrc", ".prettierrc.js", ".prettierrc.json")(
            ctx.filename
          ) ~= nil
        end,
      },
      eslint = {
        condition = function(_, ctx)
          local util = require("conform.util")
          return util.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.json", "eslint.config.js")(
            ctx.filename
          ) ~= nil
        end,
      },
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)

    -- Auto-install formatters via Mason (optional helper)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "html",
        "css",
        "json",
        "php",
        "rust",
        "cpp",
        "c",
      },
      callback = function()
        pcall(require, "mason")
      end,
    })
  end,
}
