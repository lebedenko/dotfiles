require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      lookahead = true,

      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['ak'] = '@conditional.outer',
        ['ik'] = '@conditional.inner',
        ['aa'] = '@parameter.outer',
        ['ai'] = '@parameter.inner',
        ['as'] = {
          query = '@scope',
          query_group = 'locals',
        },
      },

      selection_modes = {
        ['@parameter.outer'] = 'v',
        ['@function.outer'] = 'V',
        ['@function.inner'] = 'V',
        ['@class.outer'] = 'V',
        ['@class.inner'] = 'V',
        ['@conditional.outer'] = 'V',
        ['@conditional.inner'] = 'V',
        ['@loop.outer'] = 'V',
        ['@loop.inner'] = 'V',
      },

      -- include_surrounding_whitespace = true,
    },

    move = {
      enable = true,
      set_jumps = false,
      goto_next_start = {
        [']]'] = '@class.outer',
        [']f'] = '@function.outer',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
      },
      goto_previous_start = {
        ['[['] = '@class.outer',
        ['[f'] = '@function.outer',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
      },
      goto_next = {
        [']l'] = '@loop.outer',
        [']k'] = '@conditional.outer',
        [']a'] = '@parameter.inner',
      },
      goto_previous = {
        ['[l'] = '@loop.outer',
        ['[k'] = '@conditional.outer',
        ['[a'] = '@parameter.inner',
      },
    },
  },
}

local ts_repeat_move = require'nvim-treesitter.textobjects.repeatable_move'

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
-- vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
-- vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f)
vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F)
vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t)
vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T)
