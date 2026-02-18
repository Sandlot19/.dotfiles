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

local keymap = require("keymap")

require('illuminate').configure({
  large_file_cutoff = 50000,
})

require('noice').setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

require('render-markdown').setup({
  completions = { lsp = { enabled = true } },
  html = { enabled = false },
  latex = { enabled = false },
  yaml = { enabled = false },
  enabled = true,
})

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

vim.lsp.enable({"clangd", "rust_analyzer", "pylsp", "lua-language-server"})
