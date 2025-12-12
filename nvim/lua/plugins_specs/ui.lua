return {
  -- Colorscheme
  {
    "ishan9299/nvim-solarized-lua",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme solarized")
    end,
  },

  -- Statusline + Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
  },

  -- Toggleable terminal + Lazygit helper
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        direction = "float",
        open_mapping = nil,
        float_opts = { border = "curved" },
      })

      vim.keymap.set("n", "<leader>tt", function()
        require("toggleterm").toggle(1)
      end, { noremap = true, silent = true, desc = "🖥️ ターミナルをトグル" })

      vim.keymap.set("n", "<Leader>tc", function()
        local Terminal = require("toggleterm.terminal").Terminal
        local term = Terminal:new({
          dir = vim.fn.expand("%:p:h"),
          hidden = true,
          direction = "float",
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
        count = 99,
      })

      vim.keymap.set("n", "<Leader>g", function()
        lazygit:toggle()
      end, { desc = "🌀 Lazygit をトグル" })
    end,
  },

  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    opts = {},
  },
}
