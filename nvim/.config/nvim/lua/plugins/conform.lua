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
      return { timeout_ms = 1000, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
      go = { "goimports", "gofumpt" },
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
      cpp = { "clang-format" },
      c = { "clang-format" },
    },
    formatters = {
      prettierd = {
        condition = function(_, ctx)
          local util = require("conform.util")
          return util.root_pattern("package.json", ".prettierrc", ".prettierrc.js", ".prettierrc.json")(ctx.filename)
            ~= nil
        end,
      },
    },
  },
}
