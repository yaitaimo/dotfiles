return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        -- 基本
        "lua", "vim", "vimdoc", "bash", "markdown", "json", "yaml", "html", "css",
        -- Web/TS 系
        "javascript", "typescript",
        -- 言語
        "go", "python",
        -- 任意であとから追加可能: "toml", "graphql", "dockerfile"
      },
      highlight = {
        enable = true,
        disable = function(_, buf)
          -- 大きなファイルでは自動無効化（>1MB）
          local max = 1024 * 1024
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size and stats.size > max then
            return true
          end
          return false
        end,
      },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
