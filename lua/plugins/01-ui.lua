-- ~/.config/nvim/lua/plugins/01-ui.lua

return {
    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    -- component_separators = "",
                    section_separators = {left = "", right = ""},
                    -- theme = "tokyonight",
                    theme = "auto",
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'diff'},
                    lualine_c = { "filename" },
                    lualine_x = { "diagnostics", "progress" },
                    lualine_y = { "location" },
                    lualine_z = { 
                        {
                            function()
                                return os.date("%R")
                            end
                        }
                    },
                },
                tabline = { },
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
            plugins = {
                wezterm = { enabled = true, font = "+4" },
                neovide = {
                    enabled = false,
                    scale = 1.2,
                    disable_animations = {
                        -- neovide_animation_length = 0,
                        -- neovide_cursor_animate_command_line = false,
                        -- neovide_scroll_animation_length = 0,
                        -- neovide_position_animation_length = 0,
                        -- neovide_cursor_animation_length = 0,
                        -- neovide_cursor_vfx_mode = "",
                    }

                }
            },
            -- 1. Configuration to hide Line Numbers
            window = {
                backdrop = 0.0, -- Optional: shade the backdrop
                width = 1,     -- Optional: width of the zen window
                options = {
                    signcolumn = "no",      -- Hide the signcolumn (git signs, errors)
                    number = false,         -- Hide absolute line numbers
                    relativenumber = false, -- Hide relative line numbers
                    cursorline = false,     -- Optional: Disable cursorline highlighting
                    cursorcolumn = false,   -- Optional: Disable cursor column
                    foldcolumn = "0",       -- Optional: Hide fold column
                    list = false,           -- Optional: Hide list chars (tabs/spaces)
                },
            },
            -- Callback when Zen Mode opens
            on_open = function()
                -- Disable indent-blankline (v3) for the current buffer
                -- require("ibl").setup_buffer(0, { enabled = false })
                if vim.fn.has("nvim-0.9") == 1 then
                    vim.api.nvim_set_option_value("statuscolumn", string.rep(" ", 20), { win = win })
                end
                if vim.g.neovide then
                    vim.g.neovide_scale_factor = 1.0
                    vim.opt.linespace = 5
                end
            end,
            -- Callback when Zen Mode closes
            on_close = function()
                -- Re-enable indent-blankline (v3) for the current buffer
                -- require("ibl").setup_buffer(0, { enabled = true })
                if vim.fn.has("nvim-0.9") == 1 then
                    vim.api.nvim_set_option_value("statuscolumn", string.rep(" ", 0), { win = win })
                end
                if vim.g.neovide then
                    vim.g.neovide_scale_factor = 0.9
                    vim.opt.linespace = 1
                end
            end,
        }
    }
}
