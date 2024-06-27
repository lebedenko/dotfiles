require('tokyonight').setup({
  style = 'storm',
  dim_inactive = true,
  -- transparent = true,
  styles = {
    comments = { italic = true },
    keywords = { bold = true },
    types = { italic = true, bold = true },
  },
})

vim.cmd[[colorscheme tokyonight]]
