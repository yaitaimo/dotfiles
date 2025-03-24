-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    {
      "github/copilot.vim",
    },
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      dependencies = {
        { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      },
      build = "make tiktoken", -- Only on MacOS or Linux
      config = function()
        require("CopilotChat").setup({
          on_open = function(term)
            vim.cmd("startinsert!")
          end,
          on_close = function(term)
            vim.cmd("startinsert!")
          end,
        })

        vim.keymap.set("n", "<leader>c", function()
          require("CopilotChat").toggle()
        end, { desc = "💬 Copilot Chat toggle" })

        vim.keymap.set("v", "<leader>c", function()
          require("CopilotChat").toggle()
        end, { desc = "💬 Copilot Chat toggle" })

        vim.keymap.set("v", "<leader>ce", function()
          require("CopilotChat").ask("このコードを説明して")
        end, { desc = "💬 このコードを説明" })

        vim.keymap.set("v", "<leader>cf", function()
          require("CopilotChat").ask("このコードを修正して")
        end, { desc = "💬 このコードを修正" })
      end,
    },
    {
      "ishan9299/nvim-solarized-lua", -- Lua版の Solarized
      config = function()
        solarized_bkg = "light"
        vim.cmd("colorscheme solarized") -- Solarized Light を適用
      end,
    },
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('lualine').setup()
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          build = "make",
          config = function()
            require("telescope").load_extension("fzf")
          end,
        },
      },
      config = function()
        require("telescope").setup({
          defaults = {
            sorting_strategy = "ascending",
            prompt_prefix = "🔍 ",
            selection_caret = "➤ ",
          },
          pickers = {
            buffers = {
              sort_mru = true,
              theme = "dropdown",
            },
            oldfiles = {
              theme = "dropdown",
            },
          },
          extensions = {
            fzf = {
              fuzzy = true,
            },
            file_browser = {
              theme = "dropdown",
              hijack_netrw = true,
              mappings = {
                ["i"] = {
                  -- your custom insert mode mappings
                },
                ["n"] = {
                  -- your custom insert mode mappings
                },
              },
            },
          },
        })
      end,
    },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },
    {
      'akinsho/toggleterm.nvim',
      version = "*",
      config = function()
        require("toggleterm").setup({
          direction = "float",
          open_mapping = nil,
          float_opts = {
            border = "curved",
          }
        })

        vim.keymap.set("n", "<Leader>tt", function()
          require("toggleterm").toggle(1)
        end, { noremap = true, silent = true, desc = "🖥️ ターミナルをトグル" })

        vim.keymap.set("n", "<Leader>tc", function()
          local Terminal = require("toggleterm.terminal").Terminal
          local term = Terminal:new({
            dir = vim.fn.expand("%:p:h"),
            hidden = true,
            direction = "float", -- 必要なら他の方向に変更可
          })
          term:toggle()
        end, { noremap = true, silent = true, desc = "🖥️ カレントディレクトリでターミナルをトグル" })

        local Terminal = require("toggleterm.terminal").Terminal

        local lazygit = Terminal:new({
          cmd = "lazygit",
          hidden = true,
          direction = "float",
          on_open = function(term)
            vim.cmd("startinsert!")
          end,
          on_close = function(term)
            vim.cmd("startinsert!")
          end,
          count = 99, -- 他と被らない番号
        })

        vim.keymap.set("n", "<Leader>g", function()
          lazygit:toggle()
        end, { desc = "🌀 Lazygit をトグル" })
      end,
    }
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
