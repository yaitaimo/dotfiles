-- Git-related plugins
return {
  -- Diffview: clean UI for reviewing diffs and history
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- optional but nice icons
    },
    opts = {},
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",       desc = "Diffview Open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>",      desc = "Diffview Close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History (current)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",  desc = "Diffview Repo History" },
    },
  },
}
