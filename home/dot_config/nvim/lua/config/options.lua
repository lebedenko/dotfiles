-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.ai_cmp = false -- disable ai completion in cmp
vim.g.snacks_animate = false -- disable snacks animation

-- it seems it doesn't work
vim.g.copilot_no_tab_map = true -- disable copilot tab mapping

vim.diagnostic.config({
  float = {
    border = "rounded",
    focusable = true,
  },
})

vim.filetype.add({
  extension = {
    qmljs = "qmljs",
  },
})
