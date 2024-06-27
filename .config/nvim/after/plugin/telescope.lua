local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fs', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fc', builtin.command_history, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fh', ':Telescope find_files hidden=true<CR>', {})

local telescope = require('telescope')
local actions = require('telescope.actions')
local previewers = require('telescope.previewers')

telescope.setup({
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--trim',
    },
    layout_strategy = 'flex',
    mappings = {
      i = {
        ['<CR>'] = actions.select_default + actions.center,
        ['<Esc>'] = actions.close,
        ['<Tab>'] = actions.add_selection,
      },
    },
    color_devicons = true,
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
  },
})

telescope.load_extension('fzf')
