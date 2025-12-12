local map = vim.keymap.set

-- キーマッピング
map("n", "j", "gj", { noremap = true })
map("n", "k", "gk", { noremap = true })
map("n", "<Space>d", [[:<C-u>r! LC_ALL=en_US.UTF-8 date '+\%Y/\%m/\%d (\%a) \%H:\%M'<CR>kdd]], { noremap = true })
map("n", "<Space>l", [[O<ESC>78i-<ESC>]], { noremap = true })
map("n", "<C-b>D", ":bd!<CR>", { noremap = true, silent = true })
map("n", "<C-b>d", ":bd<CR>", { noremap = true, silent = true })

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
