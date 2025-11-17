-- ~/.config/nvim/lua/plugins/00-theme.lua

return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1001,
    config = function()
      -- We set tokyonight as the default
      --vim.cmd.colorscheme("kanagawa")
      --vim.cmd.colorscheme("kanagawa-dragon") 
      --vim.cmd.colorscheme("kanagawa-wave") -- good
      -- vim.cmd.colorscheme("kanagawa-lotus") -- flashbang, do not try
    end,
  },
}
