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
                'honza/vim-snippets',
            },
            {
                'quangnguyen30192/cmp-nvim-ultisnips',
                config = function()
                    -- optional call to setup (see customization section)
                    require("cmp_nvim_ultisnips").setup{}
                end,
                requires = { "nvim-treesitter/nvim-treesitter" },
            },
            {
                'SirVer/ultisnips',
                config = function()
                    vim.go.UltiSnipsExpandTrigger = "<tab>"
                    vim.go.UltiSnipsJumpForwardTrigger = "<c-b>"
                    vim.go.UltiSnipsJumpBackwardTrigger = "<c-z>"
                end
            },
            -- {
            --     'quangnguyen30192/cmp-nvim-ultisnips',
            --     config = function()
            --         -- optional call to setup (see customization section)
            --         require("cmp_nvim_ultisnips").setup{}
            --     end,
            -- },
        },
        config = function()
            local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
            local cmp = require('cmp')
            vim.opt.completeopt = { "menu", "menuone", "noselect" }

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                    end, -- expand
                },
                window = {
                    -- completion = cmp.config.window.bordered(),
                    -- documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                    end,
                    { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
                    ),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        cmp_ultisnips_mappings.jump_backwards(fallback)
                    end,
                    { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
                    )
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'ultisnips' }, -- For ultisnips users.
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
