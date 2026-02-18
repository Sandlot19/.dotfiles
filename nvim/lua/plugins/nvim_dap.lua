return {
  'mfussenegger/nvim-dap',
  config = function()
    local dap = require('dap')

    dap.adapters.zxdb = {
      type = 'server',
      port = "${port}",
      command = '~/upstream/fuchsia/.jiri_root/bin/ffx',
      args = {'debug', 'connect', '--', '--enable-debug-adapter', '--debug-adapter-port', '${port}'},
      name = 'zxdb',
    }

    dap.configurations.cpp = {
      {
        name = 'Launch',
        type = 'zxdb',
        request = 'launch',
        launchCommand = 'fx test debug_agent_unit_tests',
        process = 'debug_agent_unit_tests',
      },
    }

    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp
  end
}
