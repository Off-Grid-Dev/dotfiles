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

    -- Simple start screen when opening nvim without arguments
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("custom-dashboard", { clear = true }),
      once = true,
      callback = function()
        if vim.fn.argc(-1) > 0 or vim.fn.line2byte("$") ~= -1 then
          return
        end

        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].buftype = "nofile"
        vim.bo[buf].bufhidden = "wipe"
        vim.bo[buf].swapfile = false
        vim.api.nvim_buf_set_name(buf, "[Landing]")

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
          [[||.=='  _ _-'                                                     `' |  /==.||]],
          [[==' _-'                        <  N E O V I M />                      \/   `==]],
          [[\   _-'                          =============                         `-_   /]],
          [[ `''                                                                      ``' ]],
          "",
          "",
        }

        local width = vim.o.columns
        for i, line in ipairs(lines) do
          local pad = string.rep(" ", math.max(0, math.floor((width - #line) / 2)))
          lines[i] = pad .. line
        end
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false

        vim.api.nvim_set_current_buf(buf)
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.cursorline = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.list = false
        vim.opt_local.wrap = false

        local ok, palettes = pcall(require, "catppuccin.palettes")
        local mocha = ok and palettes.get_palette("mocha") or nil
        vim.api.nvim_set_hl(0, "DashboardHeader", { fg = mocha and mocha.mauve or nil, bold = true })
        local ns = vim.api.nvim_create_namespace("custom-dashboard")
        vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
          end_row = #lines,
          hl_group = "DashboardHeader",
          hl_eol = true,
        })
      end,
    })
  end,
}
