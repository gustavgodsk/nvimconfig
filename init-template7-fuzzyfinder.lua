-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-------------------------------------------------------
-----------------OPTIONS BELOW-------------------------
-------------------------------------------------------
-- [[ Setting options ]] See `:h vim.o`

vim.o.number = true         -- Show line numbers
vim.o.relativenumber = true -- Use relative line numbers
vim.o.splitbelow = true     -- On split, new window appears at bottom
vim.o.splitright = true     -- On split, new window appears at right
vim.o.ignorecase = true     -- Case-insensitive searching
vim.o.smartcase = true      -- ...unless it has a capital letter
vim.o.cursorline = true     -- Highlight the line where the cursor is
vim.o.scrolloff = 10        -- Keep 10 lines above/below cursor
vim.o.list = true           -- Show <tab> and trailing spaces
vim.o.confirm = true        -- Ask for confirmation
vim.o.updatetime = 50       -- update every 50ms

-- Sync clipboard between OS and Neovim
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})


-------------------------------------------------------
----UNIVERSAL (not plugin-specific) -KEYMAPS BELOW-----
-------------------------------------------------------
-- [[ Set up keymaps ]] See `:h vim.keymap.set()`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- Make <Esc> clear the search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>', { desc = 'Clear search highlight' })

-------------------------------------------------------
------------------BASIC AUTOCOMMANDS BELOW-------------
-------------------------------------------------------
-- [[ Basic Autocommands ]] See `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Associate .xaml files with the xml filetype for Treesitter
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.xaml',
  callback = function()
    vim.bo.filetype = 'xml'
  end,
})

-------------------------------------------------------
---------------USER COMMANDS BELOW---------------------
-------------------------------------------------------
-- [[ Create user commands ]] See `:h nvim_create_user_command()`

-- Create a command `:GitBlameLine`
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.')
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.fn.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }))
end, { desc = 'Print the git blame for the current line' })

-------------------------------------------------------
---------------------PLUGINS BELOW---------------------
-------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c_sharp", "lua", "vim", "xml" },
        highlight = {
          enable = true,
        },
        auto_install = true,
      })
    end,
  },
  
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- Core LSP configuration
  { "neovim/nvim-lspconfig" },

  -- Helper to install LSPs (like csharp_ls)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- "Glue" plugin to connect mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup({
        ensure_installed = { "csharp_ls" },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,
        },
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
        },
        sections = {
          lualine_c = { "filename" },
          lualine_x = { "diagnostics" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  { "nvim-tree/nvim-web-devicons" }, -- Icon plugin

  -- Autocompletion (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      
      -- THIS IS THE CORRECTED REPOSITORY NAME
      --"saadparwaiz1/cmp_luasnip",
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
  },


  -------------------------------------------------------
  -- NEW PLUGIN FOR FILE EXPLORER
  -------------------------------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x", -- Use the stable version
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- Already installed, but good to list
      "MunifTanjim/nui.nvim",
    },
    -- We add a new keymap to toggle the tree
    keys = {
      { 
        "<leader>fe", -- "File Explorer"
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
        end,
        desc = "Toggle File Explorer" 
      },
    },
    config = function()
      require("neo-tree").setup({
        -- This makes it behave more like a traditional IDE file explorer
        close_if_last_window = true,
        popup_border_style = "rounded",
        window = {
          position = "left",
          width = 30,
        },
        filesystem = {
          -- This will make neo-tree follow your main window
          follow_current_file = {
            enabled = true,
          },
          -- This hides .git, node_modules, etc.
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = true,
          },
        },
        -- This adds git status icons to your files
        git_status = {
          symbols = {
            added    = "A",
            modified = "M",
            deleted  = "D",
            renamed  = "R",
            untracked = "?",
          },
        },
      })
    end,
  },

  -------------------------------------------------------
  -- NEW PLUGIN FOR FUZZY FINDING (Search Everywhere)
  -------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x", -- Pin to a stable version
    dependencies = { "nvim-lua/plenary.nvim" }, -- You already have this
    
    -- These keys will lazy-load the plugin
    keys = {
      -- "Find Files" (like Rider's Ctrl+P)
      { "<leader>ff", 
        function() require("telescope.builtin").find_files() end, 
        desc = "Find Files" 
      },
      -- "Find Text" / "Live Grep" (like Rider's Find in Files)
      { "<leader>fg", 
        function() require("telescope.builtin").live_grep() end, 
        desc = "Find Text (Grep)" 
      },
      -- "Find Buffers" (open files)
      { "<leader>fb", 
        function() require("telescope.builtin").buffers() end, 
        desc = "Find Buffers" 
      },
    },
    
    config = function()
      -- This is a basic setup. Telescope has MANY options.
      require("telescope").setup({
        defaults = {
          -- This makes the pop-up window look nicer with tokyonight
          border_chars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },
      })
    end,
  },

  -------------------------------------------------------
  -- NEW PLUGINS FOR DEBUGGING (DAP)
  -------------------------------------------------------
-- This is the new, separate plugin spec for mason-nvim-dap
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    -- This config function is moved from your nvim-dap config
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "netcoredbg" },
        handlers = {}, -- This will use the default handlers
      })
    end,
  },

  -- This is your modified nvim-dap plugin spec
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim", -- This dependency string is now correct
    },

    ft = { "cs"}, --load on .cs file open


    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP: Start/Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP: Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle Breakpoint" },
      { "<S-F5>", function() require("dap").terminate() end, desc = "DAP: Stop Session" },
      { "<leader>dbc", function() require("dap").toggle_breakpoint_condition() end, desc = "DAP: Breakpoint Condition" },
      { "<leader>dr", function() require("dapui").toggle() end, desc = "DAP: Toggle UI" }, 
      --In normal mode, move your cursor over a variable and press this. It will prompt you to "add to watch" so you can monitor it in the watch window.
      { "<leader>dw", function() require("dapui").eval(nil, { enter = true }) end, desc = "DAP: Add to Watch" }     
    },
      config = function()

      local dap = require("dap")
      local dapui = require("dapui")

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo" })
      

      -- Setup the Debugger UI
      dapui.setup()

      -- Add listeners to automatically open/close the UI when debugging
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}) -- END OF lazy.setup

-------------------------------------------------------
---------------------LSP CONFIG BELOW------------------
-------------------------------------------------------

-- Set up keymaps for when the LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  end,
})
