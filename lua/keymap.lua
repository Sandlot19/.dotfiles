keymap = require('vim.keymap')

print("Loading keymap.lua")

local builtin = require('telescope.builtin')
local opts = { noremap = true }
keymap.set('n', '<leader>o', builtin.find_files, opts)
keymap.set('n', '<leader>g', builtin.grep_string, opts)
keymap.set('n', '<leader>G', builtin.live_grep, opts)
keymap.set('n', '<leader>b', builtin.buffers, opts)

opts = { noremap=true, silent=true }
keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- This one explicitly is not ending with CR so I can type the replacement
-- string. The [[ ]] is lua literal string syntax so we don't need so many
-- escapes. This needed to be changed from using <cmd> to using ":" since <cmd>
-- commands must end in a <CR>. I found https://neovim.discourse.group/t/non-buggy-keymap-to-search-and-replace-word-under-cursor/4314/4
-- which is the exact same issue and results in the string below instead.
keymap.set('n', '<leader>s', [[:%s/<C-r><C-w>/]])
keymap.set('n', '<leader>n', '<cmd>noh<CR>')

function OnLspAttach(ev) 
    local builtin = require('telescope.builtin')
    local opts = { buffer = ev.buf }

    keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    keymap.set('n', 'gd', builtin.lsp_definitions, opts)
    keymap.set('n', '<leader>h', vim.lsp.buf.hover, opts)
    keymap.set('n', 'gi', builtin.lsp_implementations, opts)
    keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
    keymap.set('n', '<leader>D', builtin.lsp_type_definitions, opts)
    keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    keymap.set('n', '<leader>r', builtin.lsp_references, opts)
    keymap.set('n', '<leader>i', builtin.lsp_incoming_calls, opts)

    keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true })
    end, opts)
end
