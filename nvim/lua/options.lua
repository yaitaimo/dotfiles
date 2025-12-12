-- 基本設定（init.lua から分離）

-- UI/表示
vim.opt.title = true
vim.opt.showmatch = true
vim.opt.matchtime = 3
vim.opt.ruler = true
vim.opt.laststatus = 2
vim.opt.number = true
vim.opt.visualbell = true
vim.opt.mouse = "a"
vim.opt.cursorline = true
vim.opt.termguicolors = true

-- 折り畳み（Treesitter 連携）
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- タブ・インデント
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true

-- クリップボード（macOS）
vim.opt.clipboard = "unnamedplus"

-- エンコーディング（読み込み優先順）
vim.opt.fileencodings = "utf-8,sjis,cp932,iso-2022-jp,euc-jp"
