return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- leaving opts empty to revert to default.
  -- to see config options, click here: https://github.com/folke/todo-comments.nvim
  opts = {
    gui_style = {
      fg = "NONE",
      bg = "BOLD",
    },

    highlight = {
      before = "",
      keyword = "bg",
      after = "",
    },
  },
}
