vim.g.mapleader = ' '
vim.keymap.set('n', '<C-e>', vim.cmd.Ex)

vim.keymap.set('n', 'H', '^')                   -- beginning of line
vim.keymap.set('n', 'L', '$')                   -- end of line

vim.keymap.set('n', '<M-k>', ':move-2<CR>')     -- move line up
vim.keymap.set('n', '<M-j>', ':move+<CR>')      -- move line down
vim.keymap.set('n', '<M-l>', '>>')              -- indent line
vim.keymap.set('n', '<M-h>', '<<')              -- outdent line
vim.keymap.set('x', '<M-k>', ':move-2<CR>gv')   -- move selection up
vim.keymap.set('x', '<M-j>', ':move\'>+<CR>gv') -- move selection down
vim.keymap.set('x', '<M-l>', '>gv')             -- indent selection
vim.keymap.set('x', '<M-h>', '<gv')             -- outdent selection

vim.keymap.set('n', 'J', 'mzJ`z')

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('x', '<leader>p', '"_dP')

vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+Y')

vim.keymap.set('n', '<leader>qo', '<cmd>copen<CR>')
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<CR>')
vim.keymap.set('n', ']q', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '[q', '<cmd>cprev<CR>zz')

vim.keymap.set('n', '<leader>t', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set('c', '<C-h>', '<left>')
vim.keymap.set('c', '<C-j>', '<down>')
vim.keymap.set('c', '<C-k>', '<up>')
vim.keymap.set('c', '<C-l>', '<right>')
vim.keymap.set('c', '^', '<home>')
vim.keymap.set('c', '$', '<end>')
