return {
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
      { "nvim-telescope/telescope-file-browser.nvim" },
    },
    keys = {
      {
        "<leader>fh",
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
        end,
        desc = "FileBrowser (cwd)",
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
        end,
        desc = "FileBrowser (git root or cwd)",
      },
      -- 📂 最近開いたファイル（oldfiles）
      {
        "<leader>h",
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "Recent files",
      },
      {
        "<leader>H",
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "Recent files",
      },
      -- 📑 バッファ一覧（開いているファイル）
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "List buffers",
      },
      -- 🔍 live grep（ripgrep が必要）
      {
        "<leader>lg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Live grep",
      },
      -- Diagnostic list
      {
        "<leader>e",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Telescope diagnostics",
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
              ["i"] = {},
              ["n"] = {},
            },
          },
        },
      })
      -- Load extensions
      pcall(require("telescope").load_extension, "file_browser")
    end,
  },
}
