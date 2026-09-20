local group = vim.api.nvim_create_augroup("DotfilesConfig", { clear = true })

-- Markdown の改行用スペースを残し、それ以外の末尾空白を削除
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = "*",
  callback = function(event)
    if vim.bo[event.buf].filetype == "markdown" then
      return
    end
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
