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
    cmd = { "Codex", "CodexChat", "CodexAgent" },
    -- Minimal opts – let the CLI handle most configuration
    opts = {
      bin = "codex", -- assumes Homebrew-installed codex in PATH
    },
    keys = {
      { "<leader>ac", function()
          -- Prefer plugin command if available
          local ok = pcall(vim.cmd, "CodexChat")
          if not ok then
            vim.notify("codex.nvim is not ready. Use <leader>atc (ToggleTerm fallback)", vim.log.levels.WARN)
          end
        end, desc = "Codex Chat" },
      { "<leader>ag", function()
          local ok = pcall(vim.cmd, "CodexAgent")
          if not ok then
            vim.notify("codex.nvim is not ready. Use <leader>atg (ToggleTerm fallback)", vim.log.levels.WARN)
          end
        end, desc = "Codex Agent" },
    },
  },
}
