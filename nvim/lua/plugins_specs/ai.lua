return {
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
    build = "make tiktoken", -- Only on MacOS or Linux
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
  -- codex.nvim: OpenAI Codex CLI integration (trial)
  {
    "johnseth97/codex.nvim",
    -- Lazy-load on its user commands; falls back nicely if not used
    cmd = { "Codex", "CodexToggle" },
    -- Minimal opts – let the CLI handle most configuration
    opts = {
      keymaps     = {
        toggle = nil, -- Keybind to toggle Codex window (Disabled by default, watch out for conflicts)
        quit = '<Esc>', -- Keybind to close the Codex window (default: Ctrl + q)
      },         -- Disable internal default keymap (<leader>cc -> :CodexToggle)
      border      = 'rounded',  -- Options: 'single', 'double', or 'rounded'
      width       = 0.8,        -- Width of the floating window (0.0 to 1.0)
      height      = 0.8,        -- Height of the floating window (0.0 to 1.0)
      model       = nil,        -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
      autoinstall = false,       -- Automatically install the Codex CLI if not found
      panel       = false,      -- Open Codex in a side-panel (vertical split) instead of floating window
      use_buffer  = false,
    },
    keys = {
      {
          "<leader>j",
          -- Prefer plugin command (lazy-loads via :Codex)
          function() require('codex').toggle() end,
          desc = 'Toggle Codex popup or side-panel',
      },
    },
  },
}
