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

-- Filetypes I use a lot, that aren't recognized properly.
vim.filetype.add({ extension = {
  cml = 'json5',
  fidl = 'fidl',
  gn = 'gn',
  gni = 'gn',
}})

local function set_ft_option(ft, option, value)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    group = vim.api.nvim_create_augroup('CommentaryOptions', { clear = false });
    desc = ('set option "%s" to "%s" for this filetype'):format(option, value),
    callback = function()
      vim.opt_local[option] = value
    end
  })
end

set_ft_option({'c', 'cc', 'cpp', 'json5'}, 'commentstring', '// %s')
set_ft_option({'gn', 'gni'}, 'commentstring', '# %s')
set_ft_option({'fidl'}, 'commentstring', '/// %s')
