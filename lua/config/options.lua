-- ~/.config/nvim/lua/config/options.lua

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

 -- Define a global Lua function to format the fold text
_G.CustomFoldText = function()
    -- Get the first line of the fold block
    local line = vim.fn.getline(vim.v.foldstart)

    -- Calculate the total number of lines in the fold
    local lines_count = vim.v.foldend - vim.v.foldstart + 1

    -- local text = line .. "    " .. lines_count .. " lines "
    local text = line .. "  ...  " .. lines_count .. " lines "

    return text
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
        -- These options will only apply to C# files
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.opt_local.foldlevel = 1
        vim.opt_local.fillchars:append({ fold = " " })
        vim.opt_local.foldtext = "v:lua.CustomFoldText()"
    end,
})
--
-- Sync clipboard between OS and Neovim
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})


    vim.g.neovide_fullscreen = true;
    vim.g.neovide_scroll_animation_length = 0.1;
vim.g.neovide_hide_mouse_when_typing = 1;

