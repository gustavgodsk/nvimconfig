return {
    "eero-lehtinen/oklch-color-picker.nvim",
    event = "VeryLazy",
    -- v5 requires Neovim 0.12+, pin to v4 which supports 0.10/0.11.
    version = "^4",
    keys = {
        {
            "<leader>v",
            function() require("oklch-color-picker").pick_under_cursor() end,
            desc = "Color pick under cursor",
        },
    },
    ---@type oklch.Opts
    opts = {},
}
