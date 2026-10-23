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
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      enable = true,
      max_lines = 3, -- how many context lines to show
      trim_scope = 'outer',
    },
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

  { { 'kepano/flexoki-neovim', name = 'flexoki' } },
  { 'NLKNguyen/papercolor-theme' },
  { 'sainnhe/everforest' },
  { 'sainnhe/edge' },
  { 'folke/tokyonight.nvim' },
  { 'rose-pine/neovim', name = 'rose-pine' },
  { 'Shatur/neovim-ayu', name = 'ayu' },
  {
    'NvChad/nvim-colorizer.lua',
    opts = {
      user_default_options = {
        tailwind = true,
      },
    },
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
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
    },
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
      vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)

      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end

      require('ufo').setup {
        fold_virt_text_handler = handler,
        provider_selector = function(_, filetype, _)
          return { 'treesitter', 'indent' }
        end,
      }
    end,
  },
  {
    'folke/zen-mode.nvim',
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      window = {
        backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        -- height and width can be:
        -- * an absolute number of cells when > 1
        -- * a percentage of the width / height of the editor when <= 1
        -- * a function that returns the width or the height
        width = 80, -- width of the Zen window
        height = 1, -- height of the Zen window
        -- by default, no options are changed for the Zen window
        -- uncomment any of the options below, or add other vim.wo options you want to apply
        options = {
          spell = false, -- disable spellcheck in zen mode
          signcolumn = 'no', -- disable signcolumn
          number = false, -- disable number column
          -- relativenumber = false, -- disable relative numbers
          -- cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          -- foldcolumn = "0", -- disable fold column
          -- list = false, -- disable whitespace characters
        },
      },
    },
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
  { 'mg979/vim-visual-multi' },
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
    'nickjvandyke/opencode.nvim',
    version = '*', -- Latest stable release
    dependencies = {
      {
        -- `snacks.nvim` integration is recommended, but optional
        ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
        'folke/snacks.nvim',
        optional = true,
        opts = {
          input = {}, -- Enhances `ask()`
          picker = { -- Enhances `select()`
            actions = {
              opencode_send = function(...)
                return require('opencode').snacks_picker_send(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any; goto definition on the type or field for details
      }

      vim.o.autoread = true -- Required for `opts.events.reload`

      -- Recommended/example keymaps
      vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
        require('opencode').ask('@this: ', { submit = true })
      end, { desc = 'Ask opencode…' })
      vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
        require('opencode').select()
      end, { desc = 'Execute opencode action…' })
      vim.keymap.set({ 'n', 't' }, '<leader>oc', function()
        require('opencode').toggle()
      end, { desc = 'Toggle opencode' })

      vim.keymap.set({ 'n', 'x' }, '<leader>ogo', function()
        return require('opencode').operator '@this '
      end, { desc = 'Add range to opencode', expr = true })
      vim.keymap.set('n', '<leader>ogoo', function()
        return require('opencode').operator '@this ' .. '_'
      end, { desc = 'Add line to opencode', expr = true })
    end,
  },
  {
    'nvim-pack/nvim-spectre',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
        desc = 'Toggle Spectre',
      })
    end,
  },
  { 'brooth/far.vim' },
  -- {
  --   'nvim-treesitter/nvim-treesitter', -- Optional, but recommended
  --   branch = 'main', -- NOTE; not the master branch! (for neotest)
  --   lazy = false,
  --   build = function()
  --     vim.cmd ':TSUpdate go'
  --   end,
  -- },
  -- {
  --   'nvim-neotest/neotest',
  --   dependencies = {
  --     'nvim-neotest/nvim-nio',
  --     'nvim-lua/plenary.nvim',
  --     'antoinemadec/FixCursorHold.nvim',
  --     {
  --       'fredrikaverpil/neotest-golang',
  --       build = function()
  --         vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait() -- Optional, but recommended
  --       end,
  --     },
  --   },
  --   config = function()
  --     local config = {
  --       -- runner = 'gotestsum', -- Optional, but recommended
  --       --
  --     }
  --     local neotest = require 'neotest'
  --     neotest.setup {
  --       adapters = {
  --         require 'neotest-golang'(config),
  --       },
  --       output_panel = {
  --         enabled = true,
  --         open = 'vsplit', -- force vertical split
  --       },
  --     }

  --     --       vim.keymap.set('n', 'gtt', function()
  --     --         neotest.run.run(vim.fn.expand '%') -- current file
  --     --       end, { desc = 'Go test current file' })
  --     --
  --     --       vim.keymap.set('n', 'gta', function()
  --     --         neotest.run.run(vim.fn.getcwd()) -- run all tests in cwd
  --     --       end, { desc = 'Go test all' })
  --     --
  --     --       vim.keymap.set('n', 'gtn', function()
  --     --         neotest.run.run() -- nearest test under cursor
  --     --       end, { desc = 'Go test nearest' })
  --     --
  --     --       vim.keymap.set('n', 'gto', function()
  --     --         neotest.output.open { enter = true } -- show last output
  --     --       end, { desc = 'Go test output' })

  --     vim.keymap.set('n', 'gtt', function()
  --       neotest.run.run(vim.fn.expand '%')
  --     end, { desc = 'Go test current file' })
  --     vim.keymap.set('n', 'gta', function()
  --       neotest.run.run(vim.fn.getcwd())
  --     end, { desc = 'Go test all' })
  --     vim.keymap.set('n', 'gtn', function()
  --       neotest.run.run()
  --     end, { desc = 'Go test nearest' })
  --     vim.keymap.set('n', 'gto', function()
  --       neotest.output.open { enter = true }
  --     end, { desc = 'Go test output' })
  --     vim.keymap.set('n', 'gtp', function()
  --       neotest.output_panel.toggle()
  --     end, { desc = 'Toggle test panel' })
  --     vim.keymap.set('n', 'gtw', function()
  --       neotest.watch.toggle(vim.fn.expand '%')
  --     end, { desc = 'Watch file tests' })
  --   end,
  -- },
}
