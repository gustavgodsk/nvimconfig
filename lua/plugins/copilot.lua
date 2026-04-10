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
                panel = { enabled = false },
            })
            vim.keymap.set("n", "<leader>ct", function()
                require("copilot.suggestion").toggle_auto_trigger()

                -- Optional: Add a little notification so you know if it's on or off
                if vim.b.copilot_suggestion_auto_trigger then
                    vim.notify("Copilot Auto-Suggestions: ON", vim.log.levels.INFO)
                else
                    vim.notify("Copilot Auto-Suggestions: OFF", vim.log.levels.WARN)
                end
            end, { desc = "Toggle Copilot Auto-Suggestions" })
        end,
    }
}
