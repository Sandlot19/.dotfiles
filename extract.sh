#!/bin/sh

# Remove automatic shell installation. This part is just easier if it's done manually.
# PREREQ: Install fish.

repo_path=$(dirname "$0")

echo "Installing fish configuration"
FISH_DIR="${HOME}"/.config/fish
mkdir -p ${FISH_DIR}
for f in ${repo_path}/fish/** ; do
  mkdir -p $(dirname $f)
  cp -v "$f" "${FISH_DIR}/$f"
done
unset FISH_DIR

echo "Installing bash hack for fish bootstrapping"
cat ${repo_path}/bashrc-hack >> ../.bashrc

echo "You might want to install fzf.fish or fuchsia.git//scripts/fx-env.fish now."

if [ -d ${repo_path}/legacy_zsh ] ; then
  echo "Note: legacy zsh dotfiles are in ${PWD}/legacy_zsh"
fi

echo "installing zellij configuration"
ZELLIJ_DIR="${HOME}/.config/zellij"
mkdir -p ${ZELLIJ_DIR}
for f in ${repo_path}/zellij/** ; do
  cp -v "${repo_path}/$f" "${ZELLIJ_DIR}/$f"
done
echo "done"

echo "installing jj configuration"
mkdir -p "${HOME}/.config/jj"
cp "${repo_path}/jj_config.toml" "${HOME}"/.config/jj/config.toml
echo "done"

echo "You might want to install jj using mise."

echo "setting up neovim"
NVIM_DIR="${HOME}/.config/nvim"
mkdir -p ${NVIM_DIR}
for f in ${repo_path}/nvim/** ; do
  cp -v "${repo_path}/$f" "${NVIM_DIR}/$f"
done
echo "done"
unset NVIM_DIR

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
