require('tokyonight').setup({
  style = 'storm',
  -- style = 'day',
  dim_inactive = true,
  -- transparent = true,
  styles = {
    comments = { italic = true },
    keywords = { bold = true },
    types = { italic = true, bold = true },
  },
})

vim.cmd[[colorscheme tokyonight]]
