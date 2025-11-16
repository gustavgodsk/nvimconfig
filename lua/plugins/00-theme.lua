-- ~/.config/nvim/lua/plugins/00-theme.lua

return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      -- We set tokyonight as the default
      vim.cmd.colorscheme("tokyonight")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1001,
    -- No config needed, we'll load it manually if we want
  },
}
