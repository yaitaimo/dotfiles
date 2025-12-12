local map = vim.keymap.set

-- キーマッピング
map("n", "j", "gj", { noremap = true, desc = "Move by display line (down)" })
map("n", "k", "gk", { noremap = true, desc = "Move by display line (up)" })
map(
  "n",
  "<Space>d",
  [[:<C-u>r! LC_ALL=en_US.UTF-8 date '+\%Y/\%m/\%d (\%a) \%H:\%M'<CR>kdd]],
  { noremap = true, desc = "Insert current date/time" }
)
map("n", "<Space>l", [[O<ESC>78i-<ESC>]], { noremap = true, desc = "Insert horizontal line" })
map("n", "<C-b>D", ":bd!<CR>", { noremap = true, silent = true, desc = "Force close buffer" })
map("n", "<C-b>d", ":bd<CR>", { noremap = true, silent = true, desc = "Close buffer" })

map("i", "<C-a>", "<Home>", { noremap = true, desc = "Insert: Home" })
map("i", "<C-e>", "<End>", { noremap = true, desc = "Insert: End" })
map("i", "<C-b>", "<Left>", { noremap = true, desc = "Insert: Left" })
map("i", "<C-f>", "<Right>", { noremap = true, desc = "Insert: Right" })
map("i", "<C-n>", "<Down>", { noremap = true, desc = "Insert: Down" })
map("i", "<C-p>", "<Up>", { noremap = true, desc = "Insert: Up" })
map("i", "<C-k>", "<C-o>d$", { noremap = true, desc = "Insert: Delete to end of line" })
map("i", "<Nul>", "<C-n>", { noremap = true, desc = "Insert: Next completion" })

-- 消去
map("i", "<C-h>", "<BS>", { noremap = true, desc = "Insert: Backspace" })
map("i", "<C-d>", "<Del>", { noremap = true, desc = "Insert: Delete" })

-- .e で init.lua を開く
map("n", ".e", function()
  vim.cmd("edit ~/.config/nvim/init.lua")
end, { desc = "Edit init.lua" })

-- .r で init.lua をリロード
map("n", ".r", function()
  vim.cmd("source ~/.config/nvim/init.lua")
  print("✅ init.lua reloaded!")
end, { desc = "Reload init.lua" })
