local lazygit
local ai_terminals = {}
-- 既存セッションは再利用し、新規作成時だけプロジェクトを解決する。
local function toggle_ai_terminal(cmd, id)
  local terminal = require("toggleterm.terminal")
  local term = ai_terminals[id]
  if not term or terminal.get(term.id, true) ~= term then
    term = terminal.Terminal:new({
      cmd = cmd,
      hidden = true,
      direction = "float",
      dir = require("util.project").get_git_root(),
      -- 希望番号を他の端末が使用中なら ToggleTerm に空き番号を選ばせる。
      count = not terminal.get(id, true) and id or nil,
      on_open = function()
        vim.cmd("startinsert!")
      end,
      on_close = function()
        vim.cmd("startinsert!")
      end,
    })
    ai_terminals[id] = term
  end
  term:toggle()
end

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
        function() toggle_ai_terminal("codex chat", 21) end,
        silent = false,
        desc = "🤖 Codex Chat (ToggleTerm)",
      },
      {
        "<leader>atg",
        function() toggle_ai_terminal("codex agent", 22) end,
        silent = false,
        desc = "🤖 Codex Agent (ToggleTerm)",
      },
    },
  },
}
