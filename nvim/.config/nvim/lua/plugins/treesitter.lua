-- nvim-treesitter on the `main` branch (the rewrite): no more `configs` module.
-- Parsers are installed with require("nvim-treesitter").install() and
-- highlighting is started per buffer with vim.treesitter.start().
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local parsers = {
        "bash",
        "c",
        "cpp",
        "css",
        "go",
        "gomod",
        "gosum",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "php",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      }
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if lang and pcall(vim.treesitter.start, args.buf, lang) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
      })

      local function select(query)
        return function()
          require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
        end
      end
      vim.keymap.set({ "x", "o" }, "af", select("@function.outer"), { desc = "Select function (outer)" })
      vim.keymap.set({ "x", "o" }, "if", select("@function.inner"), { desc = "Select function (inner)" })
      vim.keymap.set({ "x", "o" }, "ac", select("@class.outer"), { desc = "Select class (outer)" })
      vim.keymap.set({ "x", "o" }, "ic", select("@class.inner"), { desc = "Select class (inner)" })
    end,
  },
}
