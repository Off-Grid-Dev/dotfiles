return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    require("mini.ai").setup({ n_lines = 500 })
    require("mini.surround").setup()
    require("mini.indentscope").setup({
      symbol = "│",
      options = { try_as_border = true },
    })
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("CustomDashboard", { clear = true }),
      pattern = "*",
      once = true, -- only on first startup
      callback = function()
        -- Skip if opening a file or in non-normal mode
        if vim.fn.argc(-1) > 0 or vim.fn.line2byte("$") ~= -1 then return end

        -- Create a new buffer
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
        vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
        vim.api.nvim_buf_set_option(buf, "swapfile", false)
        vim.api.nvim_buf_set_option(buf, "filetype", "dashboard") -- for syntax/highlight if wanted
        vim.api.nvim_buf_set_name(buf, "[Landing]")

        -- Set content (centered, mocha-friendly)
        local lines = {
          "",
          "",
          [[=================     ===============     ===============   ========  ========]],
          [[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
          [[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||]],
          [[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
          [[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
          [[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||]],
          [[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||]],
          [[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||]],
          [[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||]],
          [[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||]],
          [[||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||]],
          [[||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||]],
          [[||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||]],
          [[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||]],
          [[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
          [[||.=='    _-'                                                     `' |  /==.||]],
          [[==' _-'                      <  N E O V I M  >                        \/   `==]],
          [[\   _-'                           =======                              `-_   /]],
          [[ `''                                                                      ``' ]],
          "",
          "",
          "",
        }

        -- Center the lines horizontally (simple version)
        local width = vim.o.columns
        for i, line in ipairs(lines) do
          local pad = string.rep(" ", math.max(0, math.floor((width - #line) / 2)))
          lines[i] = pad .. line
        end

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

        -- Switch to the buffer
        vim.api.nvim_set_current_buf(buf)

        -- Basic buffer options for clean look
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.cursorline = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.statusline = "" -- hide statusline
        vim.opt_local.showtabline = 0
        vim.opt_local.list = false
        vim.opt_local.wrap = false

        -- Mocha colors (apply after colorscheme loaded)
        vim.defer_fn(function()
          local ok, mocha = pcall(require("catppuccin.palettes").get_palette, "mocha")
          if not ok or not mocha then return end

          vim.api.nvim_buf_add_highlight(buf, -1, "Normal", 0, 0, -1)            -- fallback
          vim.api.nvim_buf_add_highlight(buf, -1, "MiniStarterHeader", 2, 0, -1) -- line 3-8 approx
          vim.api.nvim_set_hl(0, "MiniStarterHeader", { fg = mocha.mauve, bold = true })
          vim.api.nvim_set_hl(0, "MiniStarterFooter", { fg = mocha.overlay0, italic = true })
          -- Apply to footer lines (approx lines 10-11)
          vim.api.nvim_buf_add_highlight(buf, -1, "MiniStarterFooter", 10, 0, -1)
          vim.api.nvim_buf_add_highlight(buf, -1, "MiniStarterFooter", 11, 0, -1)
        end, 100) -- small delay to ensure catppuccin loaded

        -- Optional: make <C-n> explicit here too (though global should work now)
        vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle<cr>", { buffer = buf, silent = true })
      end,
    })
  end,
}
