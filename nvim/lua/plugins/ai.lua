return {
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
