-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
--
vim.keymap.set('n', '<leader>rl', function()
  vim.cmd('lua ' .. vim.fn.getline '.')
end, { desc = 'Run current line as Lua' })

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

return {
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup()

      vim.keymap.set('n', '<leader>e', function()
        require('nvim-tree.api').tree.toggle()
      end)
    end,
  },
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
    config = function()
      vim.keymap.set('n', 'gcc', function()
        require('Comment.api').toggle.linewise.current()
      end)
      vim.keymap.set('v', 'gc', function()
        require('Comment.api').toggle.linewise(vim.fn.visualmode())
      end)
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup { direction = 'float' }
      vim.keymap.set('n', '<leader>tt', ':ToggleTerm<CR>', { desc = 'Toggle Terminal' })
    end,
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  -- Project extension
  {
    'nvim-telescope/telescope-project.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      vim.keymap.set('n', '<leader>pp', require('telescope').extensions.project.project, { desc = 'Switch Project' })
    end,
  },

  { 'NLKNguyen/papercolor-theme' },
  { 'sainnhe/everforest' },
  { 'sainnhe/edge' },
  { 'folke/tokyonight.nvim' },
  { 'rose-pine/neovim', name = 'rose-pine' },
  {
    'luckasRanarison/tailwind-tools.nvim',
    name = 'tailwind-tools',
    build = ':UpdateRemotePlugins',
    lazy = false, -- ensure it loads before LSP & completion
    priority = 100, -- load early
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim', -- optional
      'neovim/nvim-lspconfig', -- optional
    },
    config = function()
      require('tailwind-tools').setup {
        server = {
          override = true,
          settings = {
            includeLanguages = { vue = 'html' }, -- example
          },
        },
      }
    end,

    -- server = {
    --   override = true, -- setup the server from the plugin if true
    --   settings = { -- shortcut for `settings.tailwindCSS`
    --     -- experimental = {
    --     --   classRegex = { "tw\\('([^']*)'\\)" }
    --     -- },
    --     includeLanguages = {
    --         vue = "html",
    --   clojure = "html",
    --   eelixir = "html-eex",
    --   elixir = "phoenix-heex",
    --   eruby = "erb",
    --   heex = "phoenix-heex",
    --   htmlangular = "html",
    --   rust = "html",
    --   templ = "html",
    --     },
    --     -- },
    --   on_attach = function(client, bufnr) end, -- callback executed when the language server gets attached to a buffer
    --   root_dir = function(fname) end, -- overrides the default function for resolving the root directory
    -- },
    -- }, -- your configuration
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      'nvim-telescope/telescope.nvim', -- optional
      'ibhagwan/fzf-lua', -- optional
      'echasnovski/mini.pick', -- optional
      'folke/snacks.nvim', -- optional
    },
    config = function()
      vim.keymap.set('n', '<space>gg', ':Neogit<CR>')
    end,
  },
  { 'andymass/vim-matchup' },
  {
    'monkoose/matchparen.nvim',
    config = function()
      require('matchparen').setup()
    end,
  },
  {
    'Pocco81/true-zen.nvim',
    config = function()
      local api = vim.api

      api.nvim_set_keymap('n', '<leader>za', ':TZAtaraxis<CR>', {})
      require('true-zen').setup {
        -- your config goes here
        -- or just leave it empty :)
        modes = {
          ataraxis = {
            -- shade = 'dark', -- if `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
            -- backdrop = 50,
            minimum_writing_area = {
              width = 90,
              height = 80,
            },
          },
        },
      }
    end,
  },
  {
    'reedes/vim-pencil',
    ft = { 'markdown', 'text' },
    config = function()
      -- Automatically enable pencil for specified filetypes
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'markdown', 'text' },
        callback = function()
          vim.cmd 'PencilSoft' -- Enable soft wrap + textwidth
          vim.opt_local.spell = true -- Optional: enable spell check
          vim.opt_local.textwidth = 80
        end,
      })
    end,
  },
  {
    'mg979/vim-visual-multi',
  },
  {
    'vim-test/vim-test',
    keys = {
      { 'gt_t', '<cmd>TestFile<cr>', desc = 'Go test current file' },
      { 'gt_a', '<cmd>TestSuite<cr>', desc = 'Go test all' },
    },
    config = function()
      vim.g['test#strategy'] = 'neovim' -- runs tests inside a floating terminal
    end,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      {
        'nvim-treesitter/nvim-treesitter', -- Optional, but recommended
        branch = 'main', -- NOTE; not the master branch!
        build = function()
          vim.cmd ':TSUpdate go'
        end,
      },
      {
        'fredrikaverpil/neotest-golang',
        build = function()
          vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait() -- Optional, but recommended
        end,
      },
    },
    config = function()
      local config = {
        -- runner = 'gotestsum', -- Optional, but recommended
        --
      }
      local neotest = require 'neotest'
      neotest.setup {
        adapters = {
          require 'neotest-golang'(config),
        },
        output_panel = {
          enabled = true,
          open = 'vsplit', -- force vertical split
        },
      }

      --       vim.keymap.set('n', 'gtt', function()
      --         neotest.run.run(vim.fn.expand '%') -- current file
      --       end, { desc = 'Go test current file' })
      --
      --       vim.keymap.set('n', 'gta', function()
      --         neotest.run.run(vim.fn.getcwd()) -- run all tests in cwd
      --       end, { desc = 'Go test all' })
      --
      --       vim.keymap.set('n', 'gtn', function()
      --         neotest.run.run() -- nearest test under cursor
      --       end, { desc = 'Go test nearest' })
      --
      --       vim.keymap.set('n', 'gto', function()
      --         neotest.output.open { enter = true } -- show last output
      --       end, { desc = 'Go test output' })

      vim.keymap.set('n', 'gtt', function()
        neotest.run.run(vim.fn.expand '%')
      end, { desc = 'Go test current file' })
      vim.keymap.set('n', 'gta', function()
        neotest.run.run(vim.fn.getcwd())
      end, { desc = 'Go test all' })
      vim.keymap.set('n', 'gtn', function()
        neotest.run.run()
      end, { desc = 'Go test nearest' })
      vim.keymap.set('n', 'gto', function()
        neotest.output.open { enter = true }
      end, { desc = 'Go test output' })
      vim.keymap.set('n', 'gtp', function()
        neotest.output_panel.toggle()
      end, { desc = 'Toggle test panel' })
      vim.keymap.set('n', 'gtw', function()
        neotest.watch.toggle(vim.fn.expand '%')
      end, { desc = 'Watch file tests' })
    end,
  },
}
