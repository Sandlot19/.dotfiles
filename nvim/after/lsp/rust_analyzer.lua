local consts = require("consts")

local is_fuchsia = string.find(vim.loop.cwd() or "", "/fuchsia")
local fx_clippy = { overrideCommand = { "fx", "clippy", "-f", "$saved_file", "--raw" } }

return {
  cmd = { consts.kFuchsiaDir .. "prebuilt/third_party/rust-analyzer/rust-analyzer" },
  filetypes = { 'rust' },
  settings = {
    ['rust-analyzer'] = {
      -- NOTE: To use this properly as it is, you must launch nvim from Fuchsia's source root,
      -- (i.e. //). I'm sure there's something we could do here to normalize the path we get in
      -- {arg} so that it works from anywhere in the tree, but I can't be bothered to figure that
      -- out right now.
      workspace = {
        discoverConfig = {
          command = {
            consts.kFuchsiaDir .. "build/rust/discover_rust_project.py",
            "--workspace-dir",
            consts.kFuchsiaDir,
            "--discover-args",
            -- FIXME: Maybe use Plenary:Path:Normalize here somehow? If that doesn't work then the
            -- path normalization will probably have to happen in the python script.
            "{arg}",
          },
          progressLabel = "rust-analyzer-discover-config",
          filesToWatch = {
            "BUILD.bazel",
            "MODULE.bazel",
          },
        },
      },
      checkOnSave = true,
      cachePriming = { enable = true },
      diagnostics = {
        disabled = { "unresolved-proc-macro" },
        refreshSupport = false,
      },
      completion = { callable = { snippets = "none" }, postfix = { enable = false } },
    },
  }
}
