-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "williamboman/mason.nvim",
      config = true,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = {
            "lua_ls",   -- Lua
            "pyright",  -- Python
            "ts_ls",    -- TypeScript, JavaScript
            "marksman", -- Markdown
            "html",     -- HTML
            "cssls",    -- CSS
            "jsonls",   -- JSON
            "yamlls",   -- YAML
            "bashls",   -- Bash
            "vimls",    -- Vim
            "dockerls", -- Docker
            "gopls",    -- Go
            "graphql",  -- GraphQL
          },
        })
      end,
    },
    {
      "neovim/nvim-lspconfig",
      config = function()
        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        })
      end,
    },
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
            vim.cmd("startinsert!")
          end,
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
      config = function()
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
      keys = {
        {
          "<leader>h",
          function()
            require("telescope.builtin").help_tags()
          end,
          desc = "Help tags",
        },
        -- current directory をファイラーで開く（:o）
        {
          "<Leader>o",
          function()
            require("telescope").extensions.file_browser.file_browser({
              cwd = vim.fn.expand("%:p:h"),
              initial_mode = "normal",
              hidden = true,
            })
          end, { desc = "FileBrowser (cwd)" }
        },
        -- 🔍 Git プロジェクトのルートから検索（あれば）
        {
          "<leader>p",
          function()
            local utils = require("utils")
            require("telescope").extensions.file_browser.file_browser({
              cwd = utils.get_git_root(),
              initial_mode = "normal",
              hidden = true,
            })
          end, { desc = "FileBrowser (git root or cwd)" }
        },
        -- 📂 最近開いたファイル（oldfiles）
        {
          "<leader>fh",
          function()
            require("telescope.builtin").oldfiles()
          end, { desc = "Recent files" }
        },
        -- 📑 バッファ一覧（開いているファイル）
        {
          "<leader>b",
          function()
            require("telescope.builtin").buffers()
          end, { desc = "List buffers" }
        },
        -- 🔍 live grep（ripgrep が必要）
        {
          "<leader>lg",
          function()
            require("telescope.builtin").live_grep()
          end, { desc = "Live grep" }
        },
        -- Diagnostic list
        {
          "<leader>e",
          function()
            require("telescope.builtin").diagnostics()
          end, { desc = "Telescope diagnostics" }
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

        vim.keymap.set("n", "<leader>tt", function()
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
          on_open = function()
            vim.cmd("startinsert!")
          end,
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
})
