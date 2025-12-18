-- ~/.config/nvim/lua/plugins/02-lsp.lua

return {
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" }, -- Load immediately when opening a file
        build = ":TSUpdate",
        config = function()
            -- treat xaml files like xml
            vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
                pattern = '*.xaml',
                callback = function()
                    vim.bo.filetype = 'xml'
                end,
            })

            -- run setup
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c_sharp", "lua", "vim", "java", "typst", "xml", "cpp" },
                highlight = { 
                    enable = true,
                    additional_vim_regex_highlighting = false 
                },
                indent = { enable = true },
                auto_install = true,
            })
        end,
    },

    -- Core LSP configuration
    { "neovim/nvim-lspconfig" },

    -- Mason
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup({
                ensure_installed = { 
                    "csharp_ls", 
                    "jdtls", 
                    "java-debug-adapter", 
                    "java-test", 
                    "tinymist",
                    "prettier"
                }
            })
        end,
    },

    -- Mason-LSPConfig
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("mason-lspconfig").setup({
                ensure_installed = { "csharp_ls", "tinymist" },
                handlers = {
                    -- Default handler (applies to csharp_ls)
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,
                    ["jdtls"] = function() end, -- Handled by lang-java.lua
                    -- 3. TINYMIST (Typst) Specific Configuration
                    -- This is where the config from the docs belongs!
                    ["tinymist"] = function()
                        require("lspconfig")["tinymist"].setup({
                            capabilities = capabilities,
                            settings = {
                                formatterMode = "typstyle",
                                exportPdf = "onSave", 
                                semanticTokens = "disable",
                            }
                        })
                    end,
                }
            })
        end,
    },

    -- Autocompletion (nvim-cmp)
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
        event = "InsertEnter",
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup({
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm(),
                    -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
            })
        end,
    },
    -- 7. INDENT BLANKLINE (Your Purple Line Fix) 
    { 
        "lukas-reineke/indent-blankline.nvim", 
        dependencies = { "nvim-treesitter/nvim-treesitter" }, 
        event = { "BufReadPre", "BufNewFile" }, 
        main = "ibl", 
        opts = { 
            indent = { 
                char = "│", 
                highlight = "IblIndent" }, 
            scope = { 
                enabled = true, 
                show_start = false, 
                show_end = false, 
                highlight = "IblScope", 
                priority = 500, 
            }, 
        }, 
        config = function(_, opts) 
            vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4261" }) 
            vim.api.nvim_set_hl(0, "IblScope", { fg = "#5b627f", bold = false }) 
            require("ibl").setup(opts) 
        end, 
    },

    {
        'stevearc/conform.nvim',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.filetype.add({ extension = { xaml = "xaml" } })

            require("conform").setup({
                formatters_by_ft = {
                    xml = { "prettier" },
                    xaml = { "prettier" },
                },
                -- ADD THIS to customize the tool behavior
                formatters = {
                    prettier = {
                        -- This forces 4 spaces indentation. 
                        -- Change "4" to "2" if you prefer 2 spaces.
                        prepend_args = { "--plugin", "@prettier/plugin-xml" },
                    }
                },
                -- format_on_save = { 
                --     timeout_ms = 3000, 
                --     lsp_fallback = true 
                -- },
            })
        end,
    }
}
