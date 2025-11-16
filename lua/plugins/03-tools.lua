-- ~/.config/nvim/lua/plugins/03-tools.lua

return {
  -- Fuzzy Finding
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Find Text (Grep)" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Find Buffers" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          border_chars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },
      })
    end,
  },

  -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    keys = {
      { "]c", function() require("gitsigns").next_hunk() end, desc = "Next Git Hunk" },
      { "[c", function() require("gitsigns").prev_hunk() end, desc = "Previous Git Hunk" },
      { "<leader>hs", function() require("gitsigns").stage_hunk() end, desc = "Git Stage Hunk" },
      { "<leader>hr", function() require("gitsigns").reset_hunk() end, desc = "Git Reset Hunk" },
      { "<leader>hu", function() require("gitsigns").undo_stage_hunk() end, desc = "Git Undo Stage Hunk" },
      { "<leader>hp", function() require("gitsigns").preview_hunk() end, desc = "Git Preview Hunk" },
    },
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Auto Pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function()
      require("mini.pairs").setup()
    end,
  },
}
