local lualine = require('lualine')
local conf = lualine.get_config()

conf.sections.lualine_a = {
  {
    'mode',
    icons_enabled = true,
    icon = '',
  }
}

conf.sections.lualine_b = {
  {
    'branch',
    draw_empty = true,
  },
  'diff',
  'diagnostics',
}

conf.sections.lualine_c = {
  {
    'filename',
    icons_enabled = true,
    symbols = {
      modified = '●',
      readonly = '',
    }
  },
  'filesize',
}

conf.sections.lualine_x = {
  'encoding',
  'fileformat',
  {
    'filetype',
    colored = true,
    icon_only = true,
  },
}

conf.sections.lualine_z = {
  'location',
}

conf.options.section_separators = { left = '', right = '' }
conf.options.component_separators = { left = '', right = '' }

conf.extensions = { 'quickfix', 'fugitive', 'mason' }

lualine.setup(conf)
