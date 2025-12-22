return {
    "Wansmer/treesj",
    keys = { "<space>m", "<space>j", "<space>s" },
    dependencies = { "nvim-treesitter/nvim-treesitter"},
    config = function()
        local lang_utils = require('treesj.langs.utils')

        require("treesj").setup({
            langs = {
                c_sharp = {
                    argument_list = lang_utils.set_preset_for_args(),
                    tuple_type = lang_utils.set_preset_for_args(),
                    attribute_argument_list = lang_utils.set_preset_for_args(),
                    parameter_list = lang_utils.set_preset_for_args(),
                    initializer_expression = lang_utils.set_preset_for_list(),
                    element_binding_expression = lang_utils.set_preset_for_list(),
                    block = lang_utils.set_preset_for_statement(),
                }
            },
        })
    end,
}
