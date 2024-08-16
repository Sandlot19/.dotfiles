local keymap = require('vim.keymap')

local opts = { noremap = true, silent = true }

-- Pane movement
keymap.set('n', '<C-h>', function() vim.cmd('wincmd h') end, opts);
keymap.set('n', '<C-j>', function() vim.cmd('wincmd j') end, opts);
keymap.set('n', '<C-k>', function() vim.cmd('wincmd k') end, opts);
keymap.set('n', '<C-l>', function() vim.cmd('wincmd l') end, opts);
-- End Pane movement

-- Telescope non-LSP
local builtin = require('telescope.builtin')
opts = { noremap = true }
keymap.set('n', '<leader>o', builtin.find_files, opts)
keymap.set('n', '<leader>g', builtin.grep_string, opts)
keymap.set('n', '<leader>G', builtin.live_grep, opts)
keymap.set('n', '<leader>b', builtin.buffers, opts)
-- End Telescope

-- Fugitive
-- These are just straight vim commands, there is no lua api.
opts = { noremap = true, silent = true }
keymap.set('n', '<leader>gb', '<cmd>Git blame<CR>', opts)
--

-- nvim-dap NOT WORKING PRESENTLY
opts = { noremap = true }
local dap = require('dap')
keymap.set('n', '<leader>B', dap.toggle_breakpoint, opts)
keymap.set('n', '<leader>c', dap.continue, opts)
keymap.set('n', '<leader>so', dap.step_over, opts)
keymap.set('n', '<leader>si', dap.step_into, opts)
local dap_widgets = require('dap.ui.widgets')
keymap.set('n', '<leader>fr', function()
  local sidebar = dap_widgets.sidebar(dap_widgets.frames)
  sidebar.toggle()
end, opts)
-- End nvim-dap

-- Diagnostics
opts = { noremap = true, silent = true }
keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)
-- End Diagnostics

-- OSC52 - neovim native
local osc52 = require('vim.ui.clipboard.osc52')
opts = { noremap = true }
keymap.set('v', '<leader>c', function()
  -- Modified to return the raw table from
  -- https://neovim.discourse.group/t/function-that-return-visually-selected-text/1601.
  -- The function returned by osc52.copy expects a table of lines, which will be joined internally.
  local function get_visual_selection()
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local n_lines = math.abs(s_end[2] - s_start[2]) + 1
    local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
    lines[1] = string.sub(lines[1], s_start[3], -1)
    if n_lines == 1 then
      lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
    else
      lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
    end
    return lines
  end

  osc52.copy('+')(get_visual_selection())
end, opts)
-- End OSC52

-- Harpoon
local harpoon_mark = require('harpoon.mark')
local harpoon_ui = require('harpoon.ui')
keymap.set('n', '<leader>m', function() harpoon_mark.add_file() end, opts)
keymap.set('n', '<leader>l', function() harpoon_ui.toggle_quick_menu() end, opts)
keymap.set('n', '<leader>a', '<cmd>Telescope harpoon marks<CR>', opts)

opts.callback = nil
keymap.set('n', '<leader>1', function() harpoon_ui.nav_file(1) end)
keymap.set('n', '<leader>2', function() harpoon_ui.nav_file(2) end)
keymap.set('n', '<leader>3', function() harpoon_ui.nav_file(3) end)
keymap.set('n', '<leader>4', function() harpoon_ui.nav_file(4) end)
keymap.set('n', '<leader>5', function() harpoon_ui.nav_file(5) end)
keymap.set('n', '<leader>6', function() harpoon_ui.nav_file(6) end)
keymap.set('n', '<leader>7', function() harpoon_ui.nav_file(7) end)
keymap.set('n', '<leader>8', function() harpoon_ui.nav_file(8) end)
keymap.set('n', '<leader>9', function() harpoon_ui.nav_file(9) end)
-- End Harpoon

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

  keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end
