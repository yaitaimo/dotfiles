local lazygit
local codex_chat
local codex_agent

return {
  -- Toggleable terminal + Lazygit helper
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    -- keys に移しても従来どおり起動時に読み込む
    lazy = false,
    opts = {
      direction = "float",
      open_mapping = nil,
      float_opts = { border = "curved" },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal
      lazygit = Terminal:new({
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

      -- codex CLI fallback launchers (Chat / Agent) via ToggleTerm
      local function git_root_or_cwd()
        local ok, utils = pcall(require, "util.project")
        if ok and utils and utils.get_git_root then
          return utils.get_git_root()
        end
        return vim.loop.cwd()
      end

      codex_chat = Terminal:new({
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

      codex_agent = Terminal:new({
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

    end,
    keys = {
      {
        "<leader>tt",
        function() require("toggleterm").toggle(1) end,
        noremap = true,
        silent = true,
        desc = "🖥️ ターミナルをトグル",
      },
      {
        "<Leader>tc",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local term = Terminal:new({
            dir = vim.fn.expand("%:p:h"),
            hidden = true,
            direction = "float",
          })
          term:toggle()
        end,
        noremap = true,
        silent = true,
        desc = "🖥️ カレントディレクトリでターミナルをトグル",
      },
      {
        "<Leader>g",
        function() lazygit:toggle() end,
        silent = false,
        desc = "🌀 Lazygit をトグル",
      },
      {
        "<leader>atc",
        function() codex_chat:toggle() end,
        silent = false,
        desc = "🤖 Codex Chat (ToggleTerm)",
      },
      {
        "<leader>atg",
        function() codex_agent:toggle() end,
        silent = false,
        desc = "🤖 Codex Agent (ToggleTerm)",
      },
    },
  },
}
