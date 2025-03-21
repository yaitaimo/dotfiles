-- Autocmdグループの作成
local my_group = vim.api.nvim_create_augroup("MyAutoCmd", { clear = true })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
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
vim.opt.foldmethod = "marker"

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

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    {
      "github/copilot.vim",
      lazy=false,
    },
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      dependencies = {
        { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
        { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
      },
      build = "make tiktoken", -- Only on MacOS or Linux
      opts = {
        -- See Configuration section for options
      },
      -- See Commands section for default commands if you want to lazy load on them
    },
    {
      "ishan9299/nvim-solarized-lua", -- Lua版の Solarized
      lazy = false, -- すぐに読み込む
      priority = 1000, -- 高優先度で適用
      config = function()
        solarized_bkg = "light"
        vim.cmd("colorscheme solarized") -- Solarized Light を適用
      end,
    },
    {
      'nvim-lualine/lualine.nvim',
      lazy = false,
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('lualine').setup()
      end,
    }
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})


-- キーマッピング
vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true })
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true })
vim.api.nvim_set_keymap("n", "<Space>d", [[:<C-u>r! LC_ALL=en_US.UTF-8 date '+\%Y/\%m/\%d (\%a) \%H:\%M'<CR>kdd]], { noremap = true })
vim.api.nvim_set_keymap("n", "<Space>l", [[O<ESC>78i-<ESC>]], { noremap = true })
vim.api.nvim_set_keymap("n", "<silent> <C-b>D", ":bd!<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<silent> <C-b>d", ":bd<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "<C-a>", "<Home>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-e>", "<End>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-b>", "<Left>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-f>", "<Right>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-n>", "<Down>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-p>", "<Up>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-k>", "<C-o>d$", { noremap = true })
vim.api.nvim_set_keymap("i", "<Nul>", "<C-n>", { noremap = true })

-- 消去
vim.api.nvim_set_keymap("i", "<C-h>", "<BS>", { noremap = true })
vim.api.nvim_set_keymap("i", "<C-d>", "<Del>", { noremap = true })

-- ファイル編集
vim.opt.fileencodings = "utf-8,sjis,cp932,iso-2022-jp,euc-jp"

-- Netrw 表示スタイル（ツリー風）
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

-- current directory をファイラーで開く（:o）
vim.keymap.set("n", "<Leader>o", ":Ex<CR>", { desc = "Open file explorer in current directory" })
