-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-tree/nvim-web-devicons' }
    }
  }

  use 'folke/tokyonight.nvim'

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
  }

  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

  use 'nvim-treesitter/nvim-treesitter-context'

  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = { 'nvim-treesitter' },
    requires = { 'nvim-treesitter/nvim-treesitter' },
  }

  use 'Wansmer/treesj'

  -- use {
  --   'windwp/nvim-ts-autotag',
  --   after = { 'nvim-treesitter' },
  --   requires = { 'nvim-treesitter/nvim-treesitter' },
  -- }

  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    requires = {
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      {'neovim/nvim-lspconfig'},
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    }
  }

  use 'onsails/lspkind.nvim'

  -- use {
  --   'jose-elias-alvarez/null-ls.nvim',
  --   requires = {
  --     { 'nvim-lua/plenary.nvim' },
  --     { 'VonHeikemen/lsp-zero.nvim' },
  --   }
  -- }

  use 'theprimeagen/harpoon'

  use 'tpope/vim-fugitive'

  use 'NvChad/nvim-colorizer.lua'

  use {
    'kevinhwang91/nvim-bqf',
    ft = 'qf'
  }

  use 'lukas-reineke/indent-blankline.nvim'

  use 'lewis6991/gitsigns.nvim'

  use 'kylechui/nvim-surround'

  use 'christoomey/vim-tmux-navigator'

end)
