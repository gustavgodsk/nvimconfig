
local sf = 1;
vim.g.neovide_scale_factor = sf
vim.g.neovide_fullscreen = false;
vim.g.neovide_scroll_animation_length = 0.1;
vim.g.neovide_hide_mouse_when_typing = 1;
vim.g.neovide_cursor_animation_length = 0.100;

vim.g.neovide_title_background_color = '#202233'
vim.g.neovide_title_text_color = "#202233"

vim.o.guifont = "JetBrainsMono_Nerd_Font:h12"

-- Change scale factor with Ctrl+ or Ctrl-
vim.keymap.set('n', '<C-=>', function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
end)

vim.keymap.set('n', '<C-->', function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
end)

vim.keymap.set('n', '<C-0>', function()
  vim.g.neovide_scale_factor = sf
end)

vim.keymap.set({ 'n', 'v' }, '<leader><F11>', function()
  if vim.g.neovide_fullscreen ~= true then
    vim.g.neovide_fullscreen = true
  else
    vim.g.neovide_fullscreen = false
  end
end)

local op = 1;
vim.keymap.set({ 'n', 'v' }, '<leader>l', function()
  if op == 1 then
    op = 0.75
  elseif op == 0.75 then
    op = 0
  else 
    op = 1
  end
  vim.g.neovide_opacity = op
end)
