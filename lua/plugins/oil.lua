return {
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "-",
        function()
          require("oil").open()
        end,
        desc = "Open parent directory",
      },
      {
        "<leader>fo",
        function()
          require("oil").open()
        end,
        desc = "Open Oil",
      },
    },
    opts = {
      default_file_explorer = false,

      columns = {
        "icon",
      },

      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,

      view_options = {
        show_hidden = true,
        natural_order = true,
      },
    },
  },
}
