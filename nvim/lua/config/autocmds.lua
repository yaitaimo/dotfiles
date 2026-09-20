local group = vim.api.nvim_create_augroup("DotfilesConfig", { clear = true })

-- 不要なスペースを削除
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- ウィンドウリサイズ時にウィンドウを均等にリサイズ
vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  pattern = "*",
  callback = function()
    vim.cmd("wincmd =")
  end,
})
