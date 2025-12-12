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

      -- codex CLI fallback launchers (Chat / Agent) via ToggleTerm
      local function git_root_or_cwd()
        local ok, utils = pcall(require, "utils")
        if ok and utils and utils.get_git_root then
          return utils.get_git_root()
        end
        return vim.loop.cwd()
      end

      local codex_chat = Terminal:new({
        cmd = "codex chat",
        hidden = true,
        direction = "float",
        dir = git_root_or_cwd(),
        count = 21, -- reserved slot
        on_open = function()
          vim.cmd("startinsert!")
        end,
        on_close = function()
          vim.cmd("startinsert!")
        end,
      })

      local codex_agent = Terminal:new({
        cmd = "codex agent",
        hidden = true,
        direction = "float",
        dir = git_root_or_cwd(),
        count = 22, -- reserved slot
        on_open = function()
          vim.cmd("startinsert!")
        end,
        on_close = function()
          vim.cmd("startinsert!")
        end,
      })

      -- AI group (ToggleTerm fallbacks)
      vim.keymap.set("n", "<leader>atc", function()
        codex_chat:toggle()
      end, { desc = "🤖 Codex Chat (ToggleTerm)" })
      vim.keymap.set("n", "<leader>atg", function()
        codex_agent:toggle()
      end, { desc = "🤖 Codex Agent (ToggleTerm)" })
    end,
  },

  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  -- Which-key: show available keybindings and their descriptions
  {
    "folke/which-key.nvim",
    opts = {},
  },
}
