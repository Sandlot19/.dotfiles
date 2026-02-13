abbr -a -- bdbg 'fx build --host \
  //src/developer/debug/zxdb \
  //src/developer/debug/zxdb:zxdb_tests_executable \
  //src/developer/debug/e2e_tests:zxdb_e2e_tests_executable \
  //tools/symbolizer \
  //tools/symbolizer:symbolizer_tests_executable \
  //src/lib/unwinder:unwinder_tests_bin'

abbr -a --position anywhere --set-cursor='%' -- L '% | less'
abbr -a -- es 'zellij action edit-scrollback'
