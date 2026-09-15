# Personal Dotfiles

Personal configuration files managed through directory symlinks targeting
`$XDG_CONFIG_HOME` (defaulting to `$HOME/.config`).

## Usage

Run the extraction script from the repository root:

```sh
./extract.sh
```

By default, the script installs configurations into `~/.config`. While the
script respects `XDG_CONFIG_HOME`, overriding this variable is generally not
recommended because most tools expect configurations in `$HOME/.config`.

## What the Script Does

1. Bootstraps `mise` if not present and installs all configured tools.
2. Symlinks configuration directories (`fish`, `git`, `herdr`, `jj`, `jjui`,
   `mise`, `nvim`, `zellij`) into `$XDG_CONFIG_HOME`.
3. Backs up pre-existing physical directories in `$XDG_CONFIG_HOME` with a
   `.old` suffix before creating symlinks.
4. Automatically bootstraps Fisher and installs configured Fish plugins into
   `~/.local/share/fish/fisher`.
5. Appends a snippet to `$HOME/.bashrc` to activate the Mise environment in Bash
   and switch into Fish shell upon login.
6. Invokes Lazy plugin installation if Neovim is installed.
