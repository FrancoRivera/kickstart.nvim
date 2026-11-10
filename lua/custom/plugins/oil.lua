return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      image = { enabled = true },
      picker = {
        enabled = true,
        ui_select = false,
      },
      indent = {},
      dim = {},
      words = {},
      statuscolumn = {},
      scroll = {},
    },
    keys = {
      {
        '<leader>fi',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find files with image previews',
      },
    },
  },
}
