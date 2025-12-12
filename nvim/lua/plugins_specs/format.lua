return {
  {
    "stevearc/conform.nvim",
    opts = {
      notify_on_error = true,
      -- 保存時に自動フォーマット（Conform に一本化）
      format_on_save = {
        lsp_fallback = true, -- 外部フォーマッタが無いときだけ LSP へフォールバック
        timeout_ms = 1000,
      },
      -- ファイルタイプごとのフォーマッタ（上から順に試行）
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        sh = { "shfmt" },
        go = { "goimports", "gofmt" }, -- まず goimports で import 整理 → なければ gofmt
        python = { "black" },
        toml = { "taplo" },
      },
      -- 各フォーマッタへの追加引数
      formatters = {
        shfmt = { prepend_args = { "-i", "2", "-ci" } }, -- indent=2, case indent
        stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
        prettier = { extra_args = { "--single-quote", "--trailing-comma", "es5" } },
      },
    },
  },
}
