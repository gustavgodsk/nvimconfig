-- ~/.config/nvim/lua/config/keymaps.lua

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- Make <Esc> clear the search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>', { desc = 'Clear search highlight' })

 -- ============================================================================
--  LSP Keymaps (Global)
-- ============================================================================
-- This autocommand runs whenever ANY LSP (Java, C#, etc.) attaches to a buffer.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    -- Go-to definitions
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to Declaration", buffer = ev.buf })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition", buffer = ev.buf })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "Go to Implementation", buffer = ev.buf })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "References", buffer = ev.buf })
    
    -- Information
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover Info", buffer = ev.buf })
    
    -- Actions
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename", buffer = ev.buf })
    
    -- Diagnostics (The one you were missing!)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show Line Diagnostic", buffer = ev.buf })
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous Diagnostic", buffer = ev.buf })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next Diagnostic", buffer = ev.buf })
    
    -- Format on save
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end,
})
