return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-git',
      },
      -- {
      --   "L3MON4D3/LuaSnip",
      --   -- follow latest release.
      --   version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      --   -- install jsregexp (optional!).
      --   build = "make install_jsregexp",
      --   config = function()
      --     require("luasnip.loaders.from_vscode").lazy_load()
      --   end,
      -- },
    },
    config = function()
      local cmp = require('cmp')
      vim.opt.completeopt = { "menu", "menuone", "noselect" }
      -- local ls = require('luasnip')

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif vim.snippet.active({ direction = 1 }) then
                vim.snippet.jump(1)
              else
                fallback()
              end
              -- if cmp.visible() then
              --   cmp.select_next_item()
              -- elseif ls.locally_jumpable(1) then
              --   ls.jump(1)
              -- else
              --   fallback()
              -- end
            end,
            { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
          ),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif vim.snippet.active({ direction = -1 }) then
                vim.snippet.jump(-1)
              else
                fallback()
              end
              -- if cmp.visible() then
              --   cmp.select_prev_item()
              -- elseif ls.locally_jumpable(-1) then
              --   ls.jump(-1)
              -- else
              --   fallback()
              -- end
            end,
            { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
          )
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            -- { name = 'ultisnips' }, -- For ultisnips users.
            -- { name = 'vsnip' }, -- For vsnip users.
            -- { name = 'luasnip' }, -- For luasnip users.
            -- { name = 'snippy' }, -- For snippy users.
          },
          {
            { name = 'buffer' },
          })
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
            { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
          },
          {
            { name = 'buffer' },
          })
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
          },
          {
            { name = 'cmdline' }
          })
      })
    end -- config
  },
}
