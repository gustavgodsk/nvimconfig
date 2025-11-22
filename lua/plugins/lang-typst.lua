 -- plugins/lang-typst.lua
return {
  {
    'chomosuke/typst-preview.nvim',
    lazy = false, -- Open immediately on startup
    version = '1.*',
    build = function() require 'typst-preview'.update() end,
    opts = {
      -- Configuration for the previewer
      open_mode = 'split', -- 'split' | 'vsplit' | 'tab' | 'browser'
      layout = 'horizontal', -- 'vertical' | 'horizontal'
    },
    -- Force filetype detection if it fails
    init = function()
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*.typ",
        callback = function()
          vim.bo.filetype = "typst"
        end,
      })
    end
  }
}
