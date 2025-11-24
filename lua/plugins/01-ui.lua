-- ~/.config/nvim/lua/plugins/01-ui.lua

return {
    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    -- theme = "tokyonight",
                    theme = "auto",
                },
                sections = {
                    lualine_c = { "filename" },
                    lualine_x = { "diagnostics" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },
    { "nvim-tree/nvim-web-devicons" }, -- Icon plugin

    -- File Explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        keys = {
            {
                "<leader>fe",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
                end,
                desc = "Toggle File Explorer",
            },
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                popup_border_style = "rounded",
                window = {
                    position = "left",
                    width = 30,
                },
                filesystem = {
                    follow_current_file = {
                        enabled = true,
                    },
                    filtered_items = {
                        visible = true,
                        hide_dotfiles = false,
                        hide_gitignored = true,
                    },
                },
                git_status = {
                    symbols = {
                        added = "A",
                        modified = "M",
                        deleted = "D",
                        renamed = "R",
                        untracked = "?",
                    },
                },
            })
        end,
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            wezterm = {
                enabled = true,
                font = "+4"
            }
        }
    }
}
