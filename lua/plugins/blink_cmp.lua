return {
  'saghen/blink.cmp',
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = {
    'Kaiser-Yang/blink-cmp-avante',
    'nvim-tree/nvim-web-devicons',
    'rafamadriz/friendly-snippets',
  },

  -- use a release tag to download pre-built binaries
  version = 'v0.*',
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- On musl libc based systems you need to add this flag
  -- build = 'RUSTFLAGS="-C target-feature=-crt-static" cargo build --release',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- adjusts spacing to ensure icons are aligned
    -- nerd_font_variant = 'mono',

    -- for keymap, all values may be string | string[]
    -- use an empty table to disable a keymap
    keymap = { preset = 'enter' },

    completion = {
      menu = { auto_show = function(ctx) return ctx.mode ~= 'cmdline' end }
    },

    sources = {
      default = { 'avante', 'lsp', 'path','snippets', 'buffer' },
      providers = {
        avante = {
          module = 'blink-cmp-avante',
          name = 'Avante',
          opts = {
            -- options for blink-cmp-avante
          }
        }
      },
    },

    -- experimental auto-brackets support
    -- accept = { auto_brackets = { enabled = true } }

    -- experimental signature help support
    -- trigger = { signature_help = { enabled = true }, },
    --signature.window.show_documentation = false
  }
}
