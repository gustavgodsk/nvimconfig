-- ~/.config/nvim/lua/config/options.lua

 local opt = vim.o --what does this do?

vim.o.number = true         -- Show line numbers
vim.o.relativenumber = true -- Use relative line numbers
vim.o.splitbelow = true     -- On split, new window appears at bottom
vim.o.splitright = true     -- On split, new window appears at right
vim.o.ignorecase = true     -- Case-insensitive searching
vim.o.smartcase = true      -- ...unless it has a capital letter
vim.o.cursorline = true     -- Highlight the line where the cursor is
vim.o.scrolloff = 10        -- Keep 10 lines above/below cursor
vim.o.list = true           -- Show <tab> and trailing spaces
vim.o.confirm = true        -- Ask for confirmation
vim.o.updatetime = 50       -- update every 50ms
vim.o.virtualedit = 'all'   -- allows cursor to be anywhere
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true


-- Sync clipboard between OS and Neovim
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

