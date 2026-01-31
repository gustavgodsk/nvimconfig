return {
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
    vim.keymap.set('n', '<leader>nt', function() vim.cmd(":Markview Toggle") end, { desc = "Toggle Markview" }),
    vim.keymap.set('n', '<leader>ns', function() vim.cmd(":Markview splitToggle") end, { desc = "Toggle Markview" }),
};
