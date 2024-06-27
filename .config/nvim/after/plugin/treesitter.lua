require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = {
    'c',
    'lua',
    'vim',
    'vimdoc',
    'query',
    'awk',
    'bash',
    'cpp',
    'css',
    'html',
    'java',
    'javascript',
    'json',
    'json5',
    'python',
    'scss',
    'sql',
    'typescript',
    'yaml',
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = ';',
      scope_incremental = 'grc',
      node_decremental = ',',
    },
  },

  autotag = {
    enable = true,
  },
}
