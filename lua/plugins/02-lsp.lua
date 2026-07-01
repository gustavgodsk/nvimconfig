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
                    "java-test", "tinymist", "prettierd", "prettier",
                    "typescript-language-server", "svelte-language-server", "netcoredbg",
                    "html-lsp", "css-lsp", "emmet-language-server" ,
                    "tailwindcss-language-server",

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

            -- mason-lspconfig v2 dropped `handlers`; it auto-enables installed
            -- servers and expects native `vim.lsp.config` for per-server settings.
            -- Apply cmp completion capabilities to every server.
            vim.lsp.config("*", { capabilities = capabilities })

            -- Silence "Unknown at rule" for Tailwind v4 at-rules
            -- (@theme, @apply, @plugin, @custom-variant, etc.)
            vim.lsp.config("cssls", {
                settings = {
                    css = { lint = { unknownAtRules = "ignore" } },
                    scss = { lint = { unknownAtRules = "ignore" } },
                    less = { lint = { unknownAtRules = "ignore" } },
                },
            })

            require("mason-lspconfig").setup({
                ensure_installed = { "csharp_ls", "tinymist", "ts_ls", "html", "cssls", "emmet_language_server", "tailwindcss", "clangd" },

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

                    -- NEW: Smart, context-aware Emmet
                    ["emmet_language_server"] = function()
                        require("lspconfig")["emmet_language_server"].setup({
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
                
                -- NEW: Add labels to the dropdown menu so you can see who is suggesting it
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end
                },

                -- NEW: Set priorities so LSP ranks higher than raw snippets
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "luasnip", priority = 750 },
                    { name = "buffer", priority = 500 },
                    { name = "path", priority = 250 },
                }),
                
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    -- THE FIX: 'select = false' means Enter will just create a new line UNLESS you explicitly arrow-down to a suggestion
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
                    typescript = { "prettierd", "prettier", stop_after_first = true },
                    html = { "prettier" },
                    css = { "prettier" },
                    json = { "prettier" },
                    svelte = { "prettier" },

                    cpp = { "clang-format" },
                    c = { "clang-format" },

                    -- javascript = { "prettier" },
                    -- typescript = { "prettier" },
                    -- html = { "prettier" },
                    -- css = { "prettier" },
                    -- json = { "prettier" },
                },
                formatters = {
                    prettier = {
                        condition = function(self, ctx)
                            return vim.loop.fs_realpath(ctx.filename) ~= nil
                        end,
                    },
                    ["clang-format"] = {
                        prepend_args = { "--style={IndentWidth: 4, TabWidth: 4, UseTab: Never}" },
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
                    lsp_fallback = false,
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
