local function qmlls_build_dir(root)
  local override = vim.env.QMLLS_BUILD_DIR
  if override and override ~= "" then
    return vim.fs.normalize(vim.startswith(override, "/") and override or (root .. "/" .. override))
  end

  local candidates = {
    root .. "/build/dev",
    root .. "/build",
    root .. "/build/debug",
    root .. "/build/Debug",
  }
  for _, candidate in ipairs(candidates) do
    if vim.uv.fs_stat(candidate .. "/compile_commands.json") then
      return vim.fs.normalize(candidate)
    end
  end

  local databases = vim.fs.find("compile_commands.json", {
    path = root,
    type = "file",
    limit = 20,
  })
  return vim.fs.normalize(databases[1] and vim.fs.dirname(databases[1]) or (root .. "/build"))
end

local function qmlls_import_paths(build_dir)
  local paths = {}
  local seen = {}
  for _, qmldir in ipairs(vim.fs.find("qmldir", { path = build_dir, type = "file", limit = 100 })) do
    local file = io.open(qmldir, "r")
    local module = file and file:read("*l"):match("^module%s+([%w_.]+)$")
    if file then
      file:close()
    end

    local directory = vim.fs.dirname(qmldir)
    local parts = module and vim.split(module, ".", { plain = true }) or {}
    if #parts > 0 and vim.fs.basename(directory) == parts[#parts] then
      local root = directory
      for _ = 1, #parts do
        root = vim.fs.dirname(root)
      end
      if not seen[root] then
        seen[root] = true
        table.insert(paths, root)
      end
    end
  end
  return paths
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        update_in_insert = false,
        underline = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "", -- Error icon
            [vim.diagnostic.severity.WARN] = "", -- Warning icon
            [vim.diagnostic.severity.INFO] = "", -- Info icon
            [vim.diagnostic.severity.HINT] = "", -- Hint icon
          },
        },
      },
      servers = {
        qmlls = {
          cmd = function(dispatchers, config)
            local root = config.root_dir or vim.fn.getcwd()
            local build_dir = qmlls_build_dir(root)
            local import_paths = qmlls_import_paths(build_dir)
            local command = { vim.env.QMLLS_BIN or "qmlls" }
            if #import_paths == 0 then
              vim.list_extend(command, { "--build-dir", build_dir })
            end
            for _, import_path in ipairs(import_paths) do
              vim.list_extend(command, { "--build-dir", import_path })
              vim.list_extend(command, { "-I", import_path })
            end
            return vim.lsp.rpc.start(command, dispatchers, { cwd = root })
          end,
          filetypes = {
            "qml",
            "qmljs",
          },
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          root_dir = function(bufnr, on_dir)
            local name = vim.api.nvim_buf_get_name(bufnr)
            local root = vim.fs.root(name, { ".qmlls.ini", "CMakePresets.json", "CMakeLists.txt", ".git" })
            if root then
              on_dir(root)
            end
          end,
        },
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--compile-commands-dir=build",
            "--query-driver=" .. (vim.env.CLANGD_QUERY_DRIVER or (vim.fn.expand("~") .. "/.espressif/tools/xtensa-esp-elf/*/xtensa-esp-elf/bin/xtensa-esp32-elf-*")),
          },
        },
      },
    },
    -- opts = function(_, opts)
    --   opts.diagnostics = {
    --     virtual_text = false,
    --     update_in_insert = false,
    --     underline = true,
    --     signs = {
    --       text = {
    --         [vim.diagnostic.severity.ERROR] = "", -- Error icon
    --         [vim.diagnostic.severity.WARN] = "", -- Warning icon
    --         [vim.diagnostic.severity.INFO] = "", -- Info icon
    --         [vim.diagnostic.severity.HINT] = "", -- Hint icon
    --       },
    --     },
    --   }
    --   return opts
    -- end,
  },
}
