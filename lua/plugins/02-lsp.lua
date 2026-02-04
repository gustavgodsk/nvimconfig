-- ~/.config/nvim/lua/plugins/02-lsp.lua

return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" }, -- Load immediately when opening a file
    build = ":TSUpdate",
    config = function()
      vim.treesitter.language.register('xml', 'xaml')

      -- run setup
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c_sharp",
          "lua",
          "vim",
          "java",
          "typst",
          "xml",
          "cpp",
          "javascript",
          "typescript",
          "markdown",
          "markdown_inline",
          "html"
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
          "csharp_ls", 
          "clangd",
          "jdtls", 
          "java-debug-adapter", 
          "java-test", 
          "tinymist",
          "prettier",
          "typescript-language-server",
          "svelte-language-server",
          "netcoredbg"
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
        ensure_installed = { "csharp_ls", "tinymist", "ts_ls" },

        handlers = {
          -- Default handler (applies to csharp_ls, ts_ls, etc.)
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,

          ["jdtls"] = function() end, -- Handled by lang-java.lua

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
    -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  })
  end,
  },
  -- 7. INDENT BLANKLINE 
  -- { 
  --     "lukas-reineke/indent-blankline.nvim", 
  --     dependencies = { "nvim-treesitter/nvim-treesitter" }, 
  --     event = { "BufReadPre", "BufNewFile" }, 
  --     main = "ibl", 
  --     opts = { 
  --         -- 1. DISABLE STATIC LINES
  --         indent = { 
  --             char = " ",  -- Set the character to an empty string (invisible)
  --         }, 
  --
  --         -- 2. KEEP ACTIVE SCOPE (Only shows when cursor is inside)
  --         scope = { 
  --             enabled = true, 
  --             show_start = false, 
  --             show_end = false, 
  --             char = "│",       -- Use the bar character ONLY for the active scope
  --             highlight = "IblScope", 
  --             priority = 500, 
  --             -- You can keep your exclusions here if you want, 
  --             -- but they matter less now since static lines are gone.
  --             exclude = {
  --                 node_type = {
  --                     ["*"] = {
  --                         "if_statement",
  --                         "for_statement",
  --                         "while_statement",
  --                         "switch_statement",
  --                         "try_statement",
  --                         "catch_clause",
  --                     },
  --                 },
  --             },
  --         }, 
  --     }, 
  --     config = function(_, opts) 
  --         -- Optional: Make the scope line slightly brighter since it's the only one you'll see
  --         vim.api.nvim_set_hl(0, "IblScope", { fg = "#263c42", bold = false }) 
  --         require("ibl").setup(opts) 
  --     end,
  -- },

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
      },
      formatters = {
        prettier = {
          prepend_args = { "--plugin", "@prettier/plugin-xml" },
        },
        xamlstyler = {
          command = "xstyler",
          -- REVERTED: Use file mode because xstyler demands it
          args = { "-f", "$FILENAME", "-c", vim.fn.getcwd() .. "/Settings.XamlStyler" },
          stdin = false,
        },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      },
    })

    -- THE FIX: Strip BOM <feff> on save
    -- This MUST be placed after conform.setup so it runs *after* formatting
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.xaml", "*.xml" },
      callback = function()
        -- Save cursor position to avoid jumping
        local cur = vim.fn.getpos(".")
        -- Remove the BOM character (U+FEFF) from the first line only
        -- 'silent!' prevents errors if the tag isn't there
        vim.cmd("silent! 1s/^\\%uFEFF//e")
        -- Restore cursor
        vim.fn.setpos(".", cur)
      end,
    })
  end,
  }
}
