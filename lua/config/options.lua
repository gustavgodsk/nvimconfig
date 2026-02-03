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
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.opt.tabline = "%t"

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

vim.g.neovide_scale_factor = 0.9
vim.g.neovide_fullscreen = false;
vim.g.neovide_scroll_animation_length = 0.1;
vim.g.neovide_hide_mouse_when_typing = 1;
vim.g.neovide_cursor_animation_length = 0.100;

vim.g.neovide_title_background_color = '#202233'
vim.g.neovide_title_text_color = "#202233"

 -- Define a global function to render the tabline
function _G.MyTabLine()
  local tabline = ''
  local tabpages = vim.api.nvim_list_tabpages()

  for _, tabpage in ipairs(tabpages) do
    -- Get the actual tab number
    local tab_num = vim.api.nvim_tabpage_get_number(tabpage)
    
    -- Highlight the current tab differently
    if tabpage == vim.api.nvim_get_current_tabpage() then
      tabline = tabline .. '%#TabLineSel#'
    else
      tabline = tabline .. '%#TabLine#'
    end

    -- Enable mouse click for this tab
    tabline = tabline .. '%' .. tab_num .. 'T '

    -- Get the file name of the active window in this tab
    local win = vim.api.nvim_tabpage_get_win(tabpage)
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)

    -- Extract just the filename (the 'tail')
    local file_name = buf_name == '' and '[No Name]' or vim.fn.fnamemodify(buf_name, ':t')

    -- Add the tab number and the short file name to the string
    -- tabline = tabline .. tab_num .. ': ' .. file_name .. ' '
    tabline = tabline ..  file_name .. ' '
  end

  -- Fill the rest of the bar with default background and reset mouse click
  tabline = tabline .. '%#TabLineFill#%T'
  return tabline
end

-- Tell Neovim to use this function for the tabline
vim.opt.tabline = '%!v:lua.MyTabLine()'
