-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ";"
vim.g.maplocalleader = "\\"

require("plugins")
require("utils")
require("keymaps")
require("autocmds")

-- 基本設定
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

-- 折り畳み設定
-- Treesitter 連携に切り替え
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- タブ・インデント設定
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- 検索設定
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true

-- macOSのクリップボード設定
vim.opt.clipboard = "unnamedplus"

-- ファイル編集
vim.opt.fileencodings = "utf-8,sjis,cp932,iso-2022-jp,euc-jp"
