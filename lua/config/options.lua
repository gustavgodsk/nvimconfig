-- ~/.config/nvim/lua/config/options.lua
 -- views can only be fully collapsed with the global statusline
vim.o.termguicolors = true
vim.o.laststatus = 3
-- 1. Create a highlight group with the 'inverse' attribute
vim.api.nvim_set_hl(0, 'InsertCursor', { fg = '#000000', bg = '#ffffff' })
vim.o.signcolumn = "yes"
-- 2. Link this group to the insert mode cursor
vim.o.guicursor = "n-v-c:block-Cursor,i:block-InsertCursor"
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
vim.o.tabstop = 4     -- Number of spaces that a <Tab> in the file counts for
vim.o.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.o.expandtab = true -- converts tab to spaces
vim.o.autoindent = true
vim.o.smartindent = true
vim.opt.tabline = "%t"
-- When editing, enable BOM support so the <feff> is hidden/handled correctly
vim.opt.fileencodings = "ucs-bom,utf-8,default,latin1"
-- Disable BOM (Byte Order Mark) by default
vim.opt.bomb = false
vim.opt.binary = false

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

