-- ~/.config/nvim/lua/plugins/02-lsp.lua

return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c_sharp", "lua", "vim", "xml", "java" },
        highlight = { enable = true, additional_vim_regex_highlighting = false },
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
          ensure_installed = { "csharp_ls", "jdtls", "java-debug-adapter", "java-test" }
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
        ensure_installed = { "csharp_ls" },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              -- We do NOT need to pass on_attach here anymore.
              -- The autocmd in keymaps.lua handles it automatically.
            })
          end,
          ["jdtls"] = function() end, -- Handled by lang-java.lua
        }
      })
    end,
  },

  -- Autocompletion (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
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
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
      })
    end,
  }
}
