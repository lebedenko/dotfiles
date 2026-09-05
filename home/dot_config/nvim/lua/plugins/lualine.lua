return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_a = {
        { "mode", icons_enabled = true, icon = "" },
      }
      return opts
    end,
  },
}
