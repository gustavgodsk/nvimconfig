-- ~/.config/nvim/lua/plugins/00-theme.lua

return {
 {
  "nyoom-engineering/oxocarbon.nvim",
  -- Add in any other configuration; 
  --   event = foo, 
  --   config = bar
  --   end,
        -- config = function()
        --     vim.opt.background = "dark", -- set this to dark or light
        --     vim.cmd("colorscheme oxocarbon")
        -- end,
},
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
     {
       "rebelot/kanagawa.nvim",
       priority = 1001,
       -- config = function()
       --   -- We set tokyonight as the default
       --   --vim.cmd.colorscheme("kanagawa")
       --   --vim.cmd.colorscheme("kanagawa-dragon") 
       --   --vim.cmd.colorscheme("kanagawa-wave") -- good
       --   -- vim.cmd.colorscheme("kanagawa-lotus") -- flashbang, do not try
       -- end,
     },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1002,
        -- config = function()
        --     -- vim.cmd.colorscheme("catppuccin-latte")
        --     -- vim.cmd.colorscheme("catppuccin-frappe")
        --     -- vim.cmd.colorscheme("catppuccin-macchiato")
        --     -- vim.cmd.colorscheme("catppuccin-mocha")
        -- end,

    },

     {
         "EdenEast/nightfox.nvim",
         name = "nightfox",
         priority = 1003,
         -- config = function()
         --     --vim.cmd.colorscheme("nightfox")
         --     --vim.cmd.colorscheme("catppuccin-frappe")
         --     --vim.cmd.colorscheme("catppuccin-macchiato")
         --     --vim.cmd.colorscheme("catppuccin-mocha")
         -- end,

     },
     {
       "nickkadutskyi/jb.nvim",
       priority = 1004,
       -- config = function()
       --     -- Options: "jb-regular", "jb-dark", "jb-light"
       --     -- "jb-regular" is the Classic Darcula
       --     -- "jb-dark" is the New UI Dark
       --     vim.cmd.colorscheme("jb")
       -- end,
    }
    -- {
    --     "navarasu/onedark.nvim",
    --     priority = 1000,
    --     config = function()
    --         local onedark = require('onedark')
    --
    --         onedark.setup {
    --             style = 'dark', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
    --             transparent = false,  -- Show/hide background
    --             term_colors = true, -- Change terminal color as per the selected theme style
    --             ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
    --             cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
    --
    --             -- toggle theme style ---
    --             toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
    --             toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between
    --
    --             -- Change code style ---
    --             -- Options are italic, bold, underline, none
    --             -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
    --             code_style = {
    --                 comments = 'italic',
    --                 keywords = 'italic',
    --                 functions = 'none',
    --                 strings = 'none',
    --                 variables = 'none'
    --             },
    --
    --             -- Lualine options --
    --             lualine = {
    --                 transparent = false, -- lualine center bar transparency
    --             },
    --
    --             -- Custom Highlights --
    --             colors = {}, -- Override default colors
    --             highlights = {}, -- Override highlight groups
    --
    --             -- Plugins Config --
    --             diagnostics = {
    --                 darker = true, -- darker colors for diagnostic
    --                 undercurl = true,   -- use undercurl instead of underline for diagnostics
    --                 background = true,    -- use background color for virtual text
    --             },
    --         }
    --         onedark.load()
    --
    --         -- Manual toggle with a safety check for the style name
    --         vim.keymap.set("n", "<leader>ts", function()
    --             onedark.toggle()
    --
    --             -- Get the style safely
    --             local current_style = "Unknown"
    --             if onedark.config and onedark.config.style then
    --                 current_style = onedark.config.style
    --             else
    --                 -- Fallback: check the global vim variable the plugin sometimes sets
    --                 current_style = vim.g.onedark_config and vim.g.onedark_config.style or "darker"
    --             end
    --
    --             -- Clear the command line and print the new style
    --             vim.api.nvim_command('redraw')
    --             print("" .. current_style)
    --         end, { desc = "Toggle OneDark Style & Show Name" })
    --     end
    -- }
}
