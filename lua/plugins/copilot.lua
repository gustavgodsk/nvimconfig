return {
    {
        "zbirenbaum/copilot.lua",
        -- cmd = "Copilot",
        -- event = "InsertEnter",
        lazy = false,
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept = "<C-l>", -- Accept ghost text with Ctrl+L
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<C-]>",
                    },
                },
                panel = { enabled = false }, -- We don't need this, Sidekick is better
            })
        end,
    }
}
