-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local orig_set_signs = vim.lsp.diagnostic.set_signs
    local set_signs_limited = function(diagnostics, bufnr, client_id, sign_ns, opts)
        opts = opts or {}
        opts.severity_limit = 'Error'
        orig_set_signs(diagnostics, bufnr, client_id, sign_ns, opts)
    end
    vim.lsp.diagnostic.set_signs = set_signs_limited

    require('clangd_extensions.inlay_hints').setup_autocmd()
    require('clangd_extensions.inlay_hints').set_inlay_hints()
end

return {
    'neovim/nvim-lspconfig',
    config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspconfig = require('lspconfig')

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                require('keymap')
                OnLspAttach(ev)
            end,
        })

        lspconfig.clangd.setup({
            cmd = { 'clangd-13' },
            on_attach = on_attach,
            capabilities = capabilities,
        })

        lspconfig.pylsp.setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })

        lspconfig.rust_analyzer.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = {
                        allTargets = false,
                    },
                },
            }
        })

        lspconfig.zls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end
}
