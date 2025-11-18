 -- ~/.config/nvim/lua/plugins/lang-csharp.lua

return {
  -- .xaml filetype association
  {
    "nvim-treesitter/nvim-treesitter", -- We're just adding a config to an existing plugin
    config = function()
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = '*.xaml',
        callback = function()
          vim.bo.filetype = 'xml'
        end,
      })
    end,
  },

  -- DAP installer
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
    ft = { "cs" },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "netcoredbg" },
        handlers = {},
      })
    end,
  },

  -- DAP core
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
    },
    ft = { "cs" }, -- Only load for C# files
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP: Start/Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP: Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle Breakpoint" },
      { "<S-F5>", function() require("dap").terminate() end, desc = "DAP: Stop Session" },
      { "<leader>dbc", function() require("dap").toggle_breakpoint_condition() end, desc = "DAP: Breakpoint Condition" },
      { "<leader>dr", function() require("dapui").toggle() end, desc = "DAP: Toggle UI" },
      { "<leader>dw", function() require("dapui").eval(nil, { enter = true }) end, mode = {"n", "v"}, desc = "DAP: Add to Watch" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo" })

      dapui.setup()

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
}
