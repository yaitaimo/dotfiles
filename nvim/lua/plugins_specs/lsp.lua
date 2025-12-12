return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",   -- Lua
          "pyright",  -- Python
          "ts_ls",    -- TypeScript, JavaScript
          "marksman", -- Markdown
          "html",     -- HTML
          "cssls",    -- CSS
          "jsonls",   -- JSON
          "yamlls",   -- YAML
          "bashls",   -- Bash
          "vimls",    -- Vim
          "dockerls", -- Docker
          "gopls",    -- Go
          "graphql",  -- GraphQL
        },
      })

      local on_attach = function(_, _)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
        map("n", "gr", vim.lsp.buf.references, "Find References")
        map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
        map("n", "K", vim.lsp.buf.hover, "Show Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>f", function()
          require("conform").format({ lsp_fallback = true, async = true })
        end, "Format (Conform)")
      end

      local lspconfig = require("lspconfig")

      require("mason-lspconfig").setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = on_attach,
          })
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            on_attach = on_attach,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          })
        end,
      })
    end,
  },
}
