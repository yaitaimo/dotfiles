-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
      },
      config = function()
        require("mason").setup({})
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
        local on_attach = function(_, _)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
          end
          map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
          map("n", "gr", vim.lsp.buf.references, "Find References")
          map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
          map("n", "K", vim.lsp.buf.hover, "Show Hover")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, "Format")
        end

        local lspconfig = require("lspconfig")

        require("mason-lspconfig").setup_handlers({
          function(server_name)
            lspconfig[server_name].setup({
              on_attach = on_attach,
            })
          end,
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              on_attach = on_attach,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                },
              },
            })
          end,
        })
      end,
    },
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup({
          suggestion = {
            enabled = true,      -- インライン補完を有効化
            auto_trigger = true, -- 自動的に補完候補を表示
            keymap = {
              accept = "<Tab>",  -- 候補の確定
              dismiss = "<Esc>", -- 候補の破棄
            },
          },
          filetypes = {
            markdown = true,
          },
          panel = {
            enabled = false, -- CopilotのサイドパネルUIはオフ（必要に応じて）
          },
        })
      end,
    },
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      dependencies = {
        { "zbirenbaum/copilot.lua" },
        { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
      },
      build = "make tiktoken",                          -- Only on MacOS or Linux
      opts = {},
      config = function()
        require("CopilotChat").setup({
          on_open = function()
            vim.cmd("startinsert!")
          end,
          on_close = function()
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
      "ishan9299/nvim-solarized-lua",
      config = function()
        vim.cmd("colorscheme solarized")
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
        -- Load extensions
        pcall(require("telescope").load_extension, "file_browser")
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
          on_close = function()
            vim.cmd("startinsert!")
          end,
          count = 99, -- 他と被らない番号
        })

        vim.keymap.set("n", "<Leader>g", function()
          lazygit:toggle()
        end, { desc = "🌀 Lazygit をトグル" })
      end,
    },
    {
      "numToStr/Comment.nvim",
      opts = {},
    },
  },
})
