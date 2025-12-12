-- Central entry for lazy.nvim using split specs
require("lazy").setup({
  spec = {
    -- Import all plugin specs from lua/plugins_specs/*.lua
    { import = "plugins_specs" },
  },
})
