local keymap = require('vim.keymap')
local wk = require('which-key')

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
keymap.set('n', '<leader>b', function() builtin.buffers({layout = {}}) end, opts)
keymap.set('n', '<leader>q', builtin.quickfix, opts)
-- End Telescope

-- Oil
opts = { noremap = true, silent = true }
keymap.set('n', '<leader>O', '<cmd>Oil<CR>', opts)
keymap.set('n', '<leader>vO', '<cmd>vsplit | Oil<CR>', opts)
keymap.set('n', '<leader>hO', '<cmd>split | Oil<CR>', opts)
keymap.set('n', '<leader>fO', '<cmd>Oil --float<CR>', opts)
-- End Oil

-- Fugitive
-- These are just straight vim commands, there is no lua api.
opts = { noremap = true, silent = true }
keymap.set('n', '<leader>gb', '<cmd>Git blame<CR>', opts)
--

-- nvim-dap NOT WORKING PRESENTLY
-- opts = { noremap = true }
-- local dap = require('dap')
-- keymap.set('n', '<leader>B', dap.toggle_breakpoint, opts)
-- keymap.set('n', '<leader>c', dap.continue, opts)
-- keymap.set('n', '<leader>so', dap.step_over, opts)
-- keymap.set('n', '<leader>si', dap.step_into, opts)
-- local dap_widgets = require('dap.ui.widgets')
-- keymap.set('n', '<leader>fr', function()
--   local sidebar = dap_widgets.sidebar(dap_widgets.frames)
--   sidebar.toggle()
-- end, opts)
-- End nvim-dap

-- Diagnostics
opts = { noremap = true, silent = true }
keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
keymap.set('n', '<leader>q', vim.diagnostic.setqflist, opts)
-- End Diagnostics

-- OSC52 - neovim native
local osc52 = require('vim.ui.clipboard.osc52')
opts = { noremap = true }
keymap.set('v', '<leader>c', function()
  function table_length(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end

  function get_visual_selection()
    -- this will exit visual mode
    -- use 'gv' to reselect the text
    local _, csrow, cscol, cerow, cecol
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == '' then
      -- if we are in visual mode use the live position
      _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
      _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
      if mode == 'V' then
        -- visual line doesn't provide columns
        cscol, cecol = 0, 999
      end
      -- exit visual mode
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>",
          true, false, true), 'n', true)
    else
      -- otherwise, use the last known visual position
      _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
      _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
    end
    -- swap vars if needed
    if cerow < csrow then csrow, cerow = cerow, csrow end
    if cecol < cscol then cscol, cecol = cecol, cscol end
    local lines = vim.fn.getline(csrow, cerow)
    -- local n = cerow-csrow+1
    local n = table_length(lines)
    if n <= 0 then return '' end
    lines[n] = string.sub(lines[n], 1, cecol)
    lines[1] = string.sub(lines[1], cscol)
    return lines
  end

  osc52.copy('+')(get_visual_selection())
end, opts)
-- End OSC52

-- Harpoon
local harpoon = require('harpoon')
harpoon:setup()
local harpoon_mark = harpoon.mark
local harpoon_ui = harpoon.ui
keymap.set('n', '<leader>m', function() harpoon:list():add() end, opts)
keymap.set('n', '<leader>l', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, opts)

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

-- vim.keymap.set("n", "<leader>a", function() toggle_telescope(harpoon:list()) end,
--     { desc = "Open harpoon window" })


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

local M = {}

function M.SetLspKeymaps(_client, bufnr)
  local builtin = require('telescope.builtin')
  local opts = { buffer = bufnr }

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

return M
