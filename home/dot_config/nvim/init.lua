-- Local tool paths and preferences load before LazyVim.
local local_config = vim.fn.stdpath("config") .. "/local.lua"
if vim.uv.fs_stat(local_config) then
  dofile(local_config)
end
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
