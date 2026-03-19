-- Git-related plugins
return {
  -- Fugitive: git integration including full-file blame view
  {
    "tpope/vim-fugitive",
    config = function()
      local function toggle_git_blame()
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "fugitiveblame" then
            vim.api.nvim_win_close(win, true)
            return
          end
        end
        vim.cmd("Git blame")
      end

      vim.keymap.set("n", "<leader>b", toggle_git_blame, { desc = "Git blame toggle (full file)" })
    end,
    keys = {
      { "<leader>b", desc = "Git blame toggle (full file)" },
    },
  },

  -- Gitsigns: inline blame and hunk actions
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = false,
    },
  },

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
