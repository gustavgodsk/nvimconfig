-- ~/.config/nvim/init.lua

_G.IS_WINDOWS = (vim.fn.has("win32") == 1) or (vim.fn.has("win64") == 1)
_G.IS_WSL = (vim.fn.has("wsl") == 1) or (vim.fn.has("unix") == 1 and not is_windows)

-- Set <space> as the leader key
vim.g.mapleader = ' '

-- Load your personal configurations
require("config.options")
require("config.keymaps")
require("config.core")

if vim.g.neovide then
  require("config.neovide")
end

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
