vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true -- highlight the line the cursor is on
vim.opt.showmode = false

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 4
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')

vim.opt.updatetime = 50

vim.opt.colorcolumn = '100'

vim.opt.splitbelow = true
vim.opt.splitright = true

-- use rg instead of grep if available
if vim.fn.executable('rg') then
  vim.opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
end

vim.opt.list = true
vim.opt.listchars = {
  extends = '',
  precedes = '',
  nbsp = '·',
  tab = ' ',
  trail = '·',
}

vim.opt.foldmethod = 'manual'
-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.opt.foldenable = false
-- vim.opt.foldnestmax = 1

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

vim.g.python3_host_prog = '~/.pyenv/versions/3.12.3/bin/python'
