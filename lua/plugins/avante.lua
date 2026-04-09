return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, 
    opts = {
        provider = "copilot",
        auto_suggestions_provider = "copilot",
        -- mode = "legacy",
        behaviour = {
            auto_suggestions = false, 
            auto_set_highlight_group = true,
            auto_set_keymaps = true,
            auto_apply_diff_after_generation = false,
            support_paste_from_clipboard = false,
            enable_fastapply = false,
        },
    },
    -- ⬇️ This is the magic line that fixes the Windows build ⬇️
    -- build = vim.fn.has("win32") == 1 
    build = _G.IS_WINDOWS
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" 
        or "make",
    dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        "zbirenbaum/copilot.lua",
        {
            "MeanderingProgrammer/render-markdown.nvim",
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
}
