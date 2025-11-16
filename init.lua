 -- ~/.config/nvim/init.lua

-- Set <space> as the leader key
vim.g.mapleader = ' '

-- Load your personal configurations
require("config.options")
require("config.keymaps")
require("config.core")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Tell lazy.nvim to load all files from lua/plugins/
require("lazy").setup("plugins")

-- NOTE: We will delete the "LSP CONFIG BELOW" section
-- It will be moved inside lua/plugins/02-lsp.lua
--
--
