-- ~/.config/nvim/lua/plugins/00-theme.lua

return {
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        config = function()
            -- 1. Setup the configuration and overrides FIRST
            require("tokyonight").setup({
                on_highlights = function(hl, c)
                    -- 'hl' is the list of highlight groups
                    -- 'c' is the color palette (c.blue, c.red, c.bg, etc.)

                    -- Change the variable color (LSP Semantic Token)
                    -- You can use a palette color:
                    --hl["@lsp.type.variable"] = { fg = c.red }
                    --hl["@lsp.typemod.method.static"] = { fg = c.orange }

                    -- OR a specific Hex color:
                    -- hl["@lsp.type.variable"] = { fg = "#d1aaff" }

                    -- If you specifically want to target only C#:
                    -- hl["@lsp.type.variable.cs"] = { fg = c.green }
                end,
            })

            -- 2. Load the colorscheme AFTER setting up
            vim.cmd.colorscheme("tokyonight")
        end,
    },
--  {
--    "rebelot/kanagawa.nvim",
--    priority = 1001,
--    config = function()
--      -- We set tokyonight as the default
--      --vim.cmd.colorscheme("kanagawa")
--      --vim.cmd.colorscheme("kanagawa-dragon") 
--      --vim.cmd.colorscheme("kanagawa-wave") -- good
--      -- vim.cmd.colorscheme("kanagawa-lotus") -- flashbang, do not try
--    end,
--  },
--  {
--      "catppuccin/nvim",
--      name = "catppuccin",
--      priority = 1002,
--      config = function()
--          --vim.cmd.colorscheme("catppuccin-latte")
--          --vim.cmd.colorscheme("catppuccin-frappe")
--          --vim.cmd.colorscheme("catppuccin-macchiato")
--          --vim.cmd.colorscheme("catppuccin-mocha")
--      end,
--
--  },
--
--  {
--      "EdenEast/nightfox.nvim",
--      name = "nightfox",
--      priority = 1003,
--      config = function()
--          --vim.cmd.colorscheme("nightfox")
--          --vim.cmd.colorscheme("catppuccin-frappe")
--          --vim.cmd.colorscheme("catppuccin-macchiato")
--          --vim.cmd.colorscheme("catppuccin-mocha")
--      end,
--
--  },
--  {
--    "nickkadutskyi/jb.nvim",
--    priority = 1004,
--    config = function()
--        -- Options: "jb-regular", "jb-dark", "jb-light"
--        -- "jb-regular" is the Classic Darcula
--        -- "jb-dark" is the New UI Dark
--        vim.cmd.colorscheme("jb")
--    end,
--}
}
