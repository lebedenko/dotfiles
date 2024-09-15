local lsp = require('lsp-zero')
local border_shape = 'rounded'

require('lspconfig.ui.windows').default_options.border = border_shape

require('mason').setup({
  ui = {
    border = border_shape,
    width = 0.6,
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

require('mason-lspconfig').setup({
  ensure_installed = {
    'angularls',
    'clangd',
    'cssls',
    'eslint',
    'html',
    'jsonls',
    'lua_ls',
    'pyright',
    'ruff',
    'ts_ls',
  },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,

    pyright = function()
      require('lspconfig').pyright.setup({
        on_attach = function(_, bufnr)
          vim.keymap.set('n', 'gi', ':PyrightOrganizeImports<CR>', {
            buffer = bufnr,
            remap = false,
          })

          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format()
            end,
          })
        end,
      })
    end,

    eslint = function()
      require('lspconfig').eslint.setup({
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            command = 'EslintFixAll'
          })
        end,
      })
    end,

    ts_ls = function()
      require('lspconfig').ts_ls.setup({
        on_attach = function(_, bufnr)
          vim.keymap.set('n', 'gi', ':OrganizeImports<CR>', {
            buffer = bufnr,
            remap = false,
          })
        end,
        commands = {
          OrganizeImports = {
            organize_imports,
            description = 'Organize Imports'
          }
        },
      })
    end,

  }
})

lsp.on_attach(function(_, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set('n', '<leader>d', function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, opts)
  vim.keymap.set('n', '<leader>r', function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set('n', '<leader>bf', function() vim.lsp.buf.format() end, opts)
  vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»',
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

cmp.setup({
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'symbol_text',
    })
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

vim.diagnostic.config({
  virtual_text = false
})
