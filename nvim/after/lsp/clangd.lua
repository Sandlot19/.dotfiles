local consts = require("consts")

return {
  -- Command and arguments to start the server.
  cmd = { consts.kFuchsiaDir .. 'prebuilt/third_party/clang/linux-x64/bin/clangd' },
  -- Filetypes to automatically attach to.
  filetypes = { 'c', 'cpp' },
}
