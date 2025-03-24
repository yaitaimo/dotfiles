local map = vim.keymap.set

-- キーマッピング
map("n", "j", "gj", { noremap = true })
map("n", "k", "gk", { noremap = true })
map("n", "<Space>d", [[:<C-u>r! LC_ALL=en_US.UTF-8 date '+\%Y/\%m/\%d (\%a) \%H:\%M'<CR>kdd]], { noremap = true })
map("n", "<Space>l", [[O<ESC>78i-<ESC>]], { noremap = true })
map("n", "<silent> <C-b>D", ":bd!<CR>", { noremap = true, silent = true })
map("n", "<silent> <C-b>d", ":bd<CR>", { noremap = true, silent = true })

map("i", "<C-a>", "<Home>", { noremap = true })
map("i", "<C-e>", "<End>", { noremap = true })
map("i", "<C-b>", "<Left>", { noremap = true })
map("i", "<C-f>", "<Right>", { noremap = true })
map("i", "<C-n>", "<Down>", { noremap = true })
map("i", "<C-p>", "<Up>", { noremap = true })
map("i", "<C-k>", "<C-o>d$", { noremap = true })
map("i", "<Nul>", "<C-n>", { noremap = true })

-- 消去
map("i", "<C-h>", "<BS>", { noremap = true })
map("i", "<C-d>", "<Del>", { noremap = true })

-- .e で init.lua を開く
map("n", ".e", function()
  vim.cmd("edit ~/.config/nvim/init.lua")
end, { desc = "Edit init.lua" })

-- .r で init.lua をリロード
map("n", ".r", function()
  vim.cmd("source ~/.config/nvim/init.lua")
  print("✅ init.lua reloaded!")
end, { desc = "Reload init.lua" })

local builtin = require("telescope.builtin")

-- current directory をファイラーで開く（:o）
map("n", "<Leader>o", function()
  require("telescope").extensions.file_browser.file_browser({ cwd = vim.fn.expand("%:p:h"), initial_mode = "normal" })
end, { desc = "FileBrowser (cwd)" })

-- 🔍 Git プロジェクトのルートから検索（あれば）
map("n", "<leader>p", function()
  require("telescope").extensions.file_browser.file_browser({ cwd = get_git_root(), initial_mode = "normal" })

end, { desc = "FileBrowser (git root or cwd)" })

-- 📂 最近開いたファイル（oldfiles）
map("n", "<leader>h", builtin.oldfiles, { desc = "Recent files" })

-- 📑 バッファ一覧（開いているファイル）
map("n", "<leader>b", builtin.buffers, { desc = "List buffers" })

-- 🔍 live grep（ripgrep が必要）
map("n", "<leader>lg", builtin.live_grep, { desc = "Live grep" })
