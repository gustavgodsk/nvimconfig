-- ~/.config/nvim/lua/config/core.lua

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Create a command `:GitBlameLine`
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.')
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.fn.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }))
end, { desc = 'Print the git blame for the current line' })

--vim.api.nvim_create_autocmd("ColorScheme", {
--  pattern = "*", -- Applies to all themes
--  callback = function()
--    local fn_hl = vim.api.nvim_get_hl(0, { name = "Function" })
--    -- 1. Change Variables to look like "Constants" 
--    -- (Constants are usually Orange, Purple, or bright colored in most themes)
--    vim.api.nvim_set_hl(0, "@lsp.type.variable", { link = "Constant" })
--
--    -- 2. Change Static Methods to look like "Types" or "PreProcessors"
--    -- (Often Yellow, Teal, or distinct from normal functions)
--    vim.api.nvim_set_hl(0, "@lsp.typemod.method.static", { link = "PreProc" })
--    --vim.api.nvim_set_hl(0, "@lsp.typemod.class.static", { link = "PreProc" })
--    vim.api.nvim_set_hl(0, "@lsp.typemod.class.static", { 
--            fg = fn_hl.fg, 
--            italic = true,
--            bold = fn_hl.bold
--        })
-- 
--  end,
--})
