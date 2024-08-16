-- Keymap is done in the LspAttach augroup created below.
local function on_attach(client, bufnr)
  vim.lsp.inlay_hint.enable()
end

return {
  'neovim/nvim-lspconfig',
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require('lspconfig')

    local is_fuchsia = string.find(vim.loop.cwd() or "", "/fuchsia")
    local kFuchsiaDir = "/usr/local/google/home/jruthe/upstream/fuchsia/"

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        require('keymap')
        OnLspAttach(ev)
      end,
    })

    lspconfig.clangd.setup({
      cmd = { kFuchsiaDir .. 'prebuilt/third_party/clang/linux-x64/bin/clangd' },
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lspconfig.pylsp.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    local fx_clippy = { overrideCommand = { "fx", "clippy", "-f", "$saved_file", "--raw" } }
    lspconfig.rust_analyzer.setup({
      cmd = { kFuchsiaDir .. "prebuilt/third_party/rust-analyzer/rust-analyzer" },
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        ['rust-analyzer'] = {
          checkOnSave = is_fuchsia and fx_clippy or { command = "clippy" }, -- false, --
          cachePriming = { enable = false },
          diagnostics = { disabled = { "unresolved-proc-macro" } },
          completion = { callable = { snippets = "none" }, postfix = { enable = false } },
        },
      }
    })

    lspconfig.lua_ls.setup({
      cmd = { "/usr/local/google/home/jruthe/bin/lua-language-server" },
      on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
          client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
              },
              -- Make the server aware of Neovim runtime files
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME
                  -- "${3rd}/luv/library"
                  -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
              }
            }
          })

          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
      end
    })
  end
}
