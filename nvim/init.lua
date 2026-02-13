local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Remap mapleader to what I like.
vim.api.nvim_set_keymap('', ';', '<Nop>', {})
vim.g.leader = ';' -- Maybe this one is not needed?
vim.g.mapleader = ';'
vim.g.maplocalleader = ';'

opts = {
    default = {
        lazy = true,
    },
}

-- 'plugins' automatically finds all of the plugins located in lua/plugins.
require('lazy').setup('plugins', opts)

-- Set colorscheme immediately.
vim.cmd.colorscheme('tokyonight')

-- Require all the top level configs, I feel like these should be able to go in
-- lua/init.lua, but for some reason that doesn't always get run. This always
-- works.
require('config')
require('keymap')
require('neorg')
