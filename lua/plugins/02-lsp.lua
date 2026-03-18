-- ~/.config/nvim/lua/plugins/02-lsp.lua

return {
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            vim.treesitter.language.register('xml', 'xaml')

            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "c_sharp", "lua", "vim", "java", "typst", "xml", "cpp",
                    "javascript", "typescript", "markdown", "markdown_inline",
                    "html", "css", "tsx", -- HTML and CSS are already here!
                },
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
        enabled = _G.IS_WINDOWS,
        config = function()
            require("mason").setup({
                ensure_installed = { 
                    "csharp_ls", "clangd", "jdtls", "java-debug-adapter", 
                    "java-test", "tinymist", "prettier",
                    "typescript-language-server", "svelte-language-server", "netcoredbg",
                    -- NEW: Added HTML, CSS, and Emmet to Mason
                    "html-lsp", "css-lsp", "emmet-ls" 
                }
            })
        end,
    },

    -- Mason-LSPConfig
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp" },
        enabled = _G.IS_WINDOWS,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("mason-lspconfig").setup({
                -- NEW: Added html, cssls, and emmet_ls to ensure_installed
                ensure_installed = { "csharp_ls", "tinymist", "ts_ls", "html", "cssls", "emmet_ls" },

                handlers = {
                    -- Default handler (this will automatically catch and setup html and cssls correctly)
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,

                        })
                    end,

                    ["svelte"] = function()
                        require("lspconfig")["svelte"].setup({
                            capabilities = capabilities,
                        })
                    end,


                    ["jdtls"] = function() end, -- Handled by lang-java.lua

                    -- NEW: Specific handler for Emmet to define filetypes (including Svelte/TSX from your config)
                    ["emmet_ls"] = function()
                        require("lspconfig")["emmet_ls"].setup({
                            capabilities = capabilities,
                            filetypes = { "html", "css", "sass", "scss", "less", "javascriptreact", "typescriptreact", "svelte" },
                        })
                    end,

                    -- Tinymist (Typst)
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
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
            })
        end,
    },

    -- Conform
    {
        'stevearc/conform.nvim',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    xml = { "xamlstyler" },
                    xaml = { "xamlstyler" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    html = { "prettier" },
                    css = { "prettier" }, -- NEW: Mapped CSS to Prettier
                    json = { "prettier" },
                },
                formatters = {
                    prettier = {
                        prepend_args = { "--plugin", "@prettier/plugin-xml" },
                    },
                    xamlstyler = {
                        command = "xstyler",
                        stdin = false, 
                        args = function(self, ctx)
                            local config_path = vim.fs.find("Settings.XamlStyler", {
                                path = ctx.dirname,
                                upward = true,     
                                stop = vim.loop.os_homedir(), 
                                type = "file"
                            })[1]

                            if config_path then
                                return { "-f", "$FILENAME", "-c", config_path }
                            else
                                return { "-f", "$FILENAME" }
                            end
                        end,
                    },
                },
                format_on_save = {
                    timeout_ms = 3000,
                    lsp_fallback = true,
                },
            })

            -- THE FIX: Strip BOM <feff> on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = { "*.xaml", "*.xml" },
                callback = function()
                    local cur = vim.fn.getpos(".")
                    vim.cmd("silent! 1s/^\\%uFEFF//e")
                    vim.fn.setpos(".", cur)
                end,
            })
        end,
    }
}
