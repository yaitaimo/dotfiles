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
    opts = {},
  },

  -- Which-key: show available keybindings and their descriptions
  {
    "folke/which-key.nvim",
    opts = {},
  },
}
