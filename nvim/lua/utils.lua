local M = {}

-- Git ルート or カレントパスを返す関数
function M.get_git_root()
  -- 現在のファイルのパスを取得
  local filepath = vim.fn.expand('%:p:h')
  -- Git root を取得するために systemlist で git rev-parse を実行
  local git_root = vim.fn.systemlist('git -C ' .. filepath .. ' rev-parse --show-toplevel')[1]

  -- 結果が空でなければそれを返す、失敗時はカレントパス
  if vim.v.shell_error == 0 then
    return git_root
  else
    return vim.loop.cwd()
  end
end

return M
