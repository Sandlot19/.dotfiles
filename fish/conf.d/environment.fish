set --export --global EDITOR nvim
set --export --global FZF_DEFAULT_COMMAND 'rg --files --no-ignore-vcs --hidden'

# Fuchsia specific stuff.
set --export --global CIPD_PARALLEL_DOWNLOADS 32
set --export --global NINJA_STATUS_MAX_COMMANDS 8
set --export --global NINJA_STATUS_REFRESH_MILLIS 250
set --export --global NINJA_PERSISTENT_MODE 1
set --export --global FUCHSIA_ANALYTICS_DISABLED 1
set --export --global FX_BUILD_WITH_LABELS 1
set --export --global FX_BUILD_RBE_STATS 1

set --export --global FUCHSIA_BAZEL_DISK_CACHE {$HOME}/.cache/bazel_disk_cache
set --export --global FUCHSIA_BAZEL_DISK_CACHE_SIZE 40G

fish_add_path --global --prepend {$HOME/.local/bin}

if test -f {$HOME}/.env.private.fish
  source {$HOME}/.env.private.fish
end
