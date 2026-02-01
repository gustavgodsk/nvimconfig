return {
    {
        "scalameta/nvim-metals",
        enabled = _G.IS_WINDOWS,
        dependencies = {
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp"
        },
        opts = function()
            local metals_config = require("metals").bare_config()
            metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
            metals_config.on_attach = function(client, bufnr)
                vim.keymap.set("n", "K", vim.lsp.buf.hover)
            end
            return metals_config
        end,
        config = function(metals, metals_config)
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    require("metals").initialize_or_attach(metals_config)
                end
            })
        end
    }
}
