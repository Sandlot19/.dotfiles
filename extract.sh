#!/bin/sh

# Remove automatic shell installation. This part is just easier if it's done manually.
# PREREQ: Install fish.

repo_path=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}"
mkdir -p "${CONFIG_DIR}"

link_config() {
  app="$1"
  target="${CONFIG_DIR}/${app}"
  source="${repo_path}/${app}"

  if [ -L "${target}" ]; then
    rm -f "${target}"
  elif [ -d "${target}" ] || [ -e "${target}" ]; then
    echo "Backing up existing ${target} to ${target}.old"
    rm -rf "${target}.old"
    mv "${target}" "${target}.old"
  fi
  ln -s -v "${source}" "${target}"
}

echo "setting up mise"
if ! command -v mise >/dev/null 2>&1 && [ ! -x "${HOME}/.local/bin/mise" ]; then
  echo "installing mise"
  curl -fsSL https://mise.run | sh
fi
export PATH="${HOME}/.local/bin:${PATH}"
link_config mise

if command -v mise >/dev/null 2>&1; then
  MISE_BIN="mise"
elif [ -x "${HOME}/.local/bin/mise" ]; then
  MISE_BIN="${HOME}/.local/bin/mise"
fi

if [ -n "${MISE_BIN}" ]; then
  echo "installing mise tools"
  "${MISE_BIN}" install --yes
  eval "$("${MISE_BIN}" activate bash)"
fi
echo "done"

echo "Installing fish configuration"
link_config fish
echo "done"

if ! command -v fish >/dev/null 2>&1; then
  echo "WARNING: fish is not yet installed to PATH"
else
  if ! fish -c "type -q fisher" >/dev/null 2>&1; then
    echo "Installing fisher"
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
  fi
  echo "Installing fisher plugins"
  fish -c "fisher update"
fi

echo "Installing bash hack for fish bootstrapping"
cat "${repo_path}/bashrc-hack" >> "${HOME}/.bashrc"

echo "You might want to install fuchsia.git//scripts/fx-env.fish now."

if [ -d "${repo_path}/legacy_zsh" ] ; then
  echo "Note: legacy zsh dotfiles are in ${repo_path}/legacy_zsh"
fi

echo "installing zellij configuration"
link_config zellij
echo "done"

echo "installing jj configuration"
link_config jj
echo "done"

echo "You might want to install jj using mise."

echo "installing jjui configuration"
link_config jjui
echo "done"

echo "installing herdr configuration"
link_config herdr
echo "done"

echo "installing git configuration"
link_config git
echo "done"

echo "setting up neovim"
link_config nvim
echo "done"

if ! command -v nvim ; then
  echo "WARNING: Neovim is not yet installed to PATH"
else
  echo "Installing plugins using Lazy"
  sleep 3
  # install vim plugins using Lazy
  nvim +Lazy
fi

upstream="${HOME}/upstream"
if [ ! -d "${upstream}" ] ; then
  mkdir -p "${upstream}"
fi

# Exec bash so that our bashrc hack gets executed which will dump us into a fish shell reliably.
# This is only needed because changing the default shell at work is a hassle.
exec bash
