-- ~/.config/nvim/lua/plugins/02-lsp.lua

return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c_sharp", "lua", "vim", "xml", "java" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        auto_install = true,
      })
    end,
  },

  -- Core LSP configuration
  { "neovim/nvim-lspconfig" },

  -- Helper to install LSPs
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup({
          ensure_installed = {
              --C# tools
              "csharp_ls", 
              -- "netcoredbg", -- custom setup in lang-csharp.lua 

              -- Java tools
              "jdtls",
              "java-debug-adapter",
              "java-test",
          }
      })
    end,
  },

  -- "Glue" plugin to connect mason and lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        -- Enable "format on save"
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = true })
            end,
          })
        end
        if client.supports_method("textDocument/semanticTokens") then
            vim.lsp.buf.semantic_tokens_full()
        end
      end

      vim.g.my_lsp_on_attach = on_attach

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason-lspconfig").setup({
        ensure_installed = { "csharp_ls" },
        handlers = {
          function(server_name)
            -- 4. Pass on_attach and capabilities to *all* servers
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              on_attach = vim.g.my_lsp_on_attach, -- This is the crucial change
            })
          end,
          --
          -- This tells mason-lspconfig: "Do NOT run the default
          -- setup for 'jdtls', because we have a special plugin
          -- (nvim-jdtls in lang-java.lua) that will handle it."
          ["jdtls"] = function()
          -- Do nothing. Let lang-java.lua handle it.
          end,
        }
      })
    end,
  },

  -- Autocompletion (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
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
