-- Enable line numbers.
vim.o.number = true
vim.o.tabstop = 8
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.textwidth = 100
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.scrolloff = 10
vim.opt.colorcolumn = "101"
vim.g.clipboard = "osc52"

-- Filetypes I use a lot, that aren't recognized properly.
vim.filetype.add({
  extension = {
    cml = 'json5',
    fidl = 'fidl',
    gn = 'gn',
    gni = 'gn',
  }
})

local function set_ft_option(ft, option, value)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    group = vim.api.nvim_create_augroup('CommentaryOptions', { clear = false }),
    desc = ('set option "%s" to "%s" for this filetype'):format(option, value),
    callback = function()
      vim.opt_local[option] = value
    end
  })
end

set_ft_option({ 'c', 'cc', 'cpp', 'json5' }, 'commentstring', '// %s')
set_ft_option({ 'gn', 'gni' }, 'commentstring', '# %s')
set_ft_option({ 'fidl' }, 'commentstring', '/// %s')

local consts = require("consts")
local keymap = require("keymap")

-- =================================================================================================
-- LSP Configuration
-- =================================================================================================

-- Common configuration for all LSPs.
local lsp_default_setup = function()
    vim.lsp.inlay_hint.enable()
    keymap.SetLspKeymaps()
end

-- This autocmd is used for all LSPs (make sure the LSP configuration has the right filetypes).
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function()
    lsp_default_setup()
  end,
})

vim.lsp.config("clangd", {
  -- Command and arguments to start the server.
  cmd = { consts.kFuchsiaDir .. 'prebuilt/third_party/clang/linux-x64/bin/clangd' },
  -- Filetypes to automatically attach to.
  filetypes = { 'cpp' },
})

local is_fuchsia = string.find(vim.loop.cwd() or "", "/fuchsia")
local fx_clippy = { overrideCommand = { "fx", "clippy", "-f", "$saved_file", "--raw" } }
vim.lsp.config("rust-analyzer", {
  cmd = { consts.kFuchsiaDir .. "prebuilt/third_party/rust-analyzer/rust-analyzer" },
  filetypes = { 'rust' },
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = false,
      -- checkOnSave = is_fuchsia and fx_clippy or { command = "clippy" }, -- false, --
      cachePriming = { enable = false },
      diagnostics = {
        disabled = { "unresolved-proc-macro" },
        refreshSupport = false,
      },
      completion = { callable = { snippets = "none" }, postfix = { enable = false } },
    },
  }
})

vim.lsp.config("pylsp", {
  filetypes = { "python" },
})

-- Workaround for "server cancelled the request" error when editing rust.
-- https://github.com/neovim/neovim/issues/30985#issuecomment-2447329525
for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end

vim.lsp.config("lua-language-server", {
  filetypes = { "lua" },
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    lsp_default_setup()
    -- vim.lsp.start({
    --   name = 'lua-language-server',
    --   cmd = { "/usr/local/google/home/jruthe/.local/bin/lua-language-server" },
    --   on_attach = keymap.SetLspKeymaps,
      -- This came from my old LSPConfig configuration, but things seem to work fine without it?
      --
      -- on_init = function(client, _result)
      --   local path = client.workspace_folders[1].name
      --   if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      --     client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
      --       Lua = {
      --         runtime = {
      --           -- Tell the language server which version of Lua you're using
      --           -- (most likely LuaJIT in the case of Neovim)
      --           version = 'LuaJIT'
      --         },
      --         -- Make the server aware of Neovim runtime files
      --         workspace = {
      --           checkThirdParty = false,
      --           library = {
      --             vim.env.VIMRUNTIME
      --             -- "${3rd}/luv/library"
      --             -- "${3rd}/busted/library",
      --           }
      --           -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
      --           -- library = vim.api.nvim_get_runtime_file("", true)
      --         }
      --       }
      --     })

      --     client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      --   end
      --   return true
      -- end
    -- })
  end,
})

vim.lsp.enable({"clangd", "rust-analyzer", "pylsp", "lua-language-server"})
