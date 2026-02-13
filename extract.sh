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

echo "Installing bash hack for fish bootstrapping"
cat ${repo_path}/bashrc-hack >> ../.bashrc

echo "You might want to install fzf.fish or fuchsia.git//scripts/fx-env.fish now."

if [ -d ${repo_path}/legacy_zsh ] ; then
  echo "Note: legacy zsh dotfiles are in ${PWD}/legacy_zsh"
fi

if [ -d "${HOME}/.vim" ] ; then
    mv "${HOME}/.vim" "${HOME}/.vim.old"
fi

echo "installing zellij configuration"
mkdir -p "${HOME}/.config/zellij"
cp "${repo_path}/config.kdl" "${HOME}"/.config/zellij
echo "done"

echo "installing jj configuration"
mkdir -p "${HOME}/.config/jj"
cp "${repo_path}/jj_config.toml" "${HOME}"/.config/jj/config.toml
echo "done"

echo "setting up neovim"
mkdir -p "${HOME}/.config/nvim"
cp "${repo_path}/init.lua" "${HOME}/.config/nvim/"
cp -r "${repo_path}/lua" "${HOME}/.config/nvim"
echo "done"

if ! command -v nvim ; then
    # figure out how to install neovim -- will need to continuously update this
    # based on how to fetch the package.

    # Method #1: brew
    if command -v brew ; then
        brew install nvim
    fi
fi

# install vim plugins using Lazy
nvim +Lazy

upstream="${HOME}/upstream"
if [ ! -d "${upstream}" ] ; then
  mkdir -p "${upstream}"
fi

# Exec bash so that our bashrc hack gets executed which will dump us into a fish shell reliably.
# This is only needed because changing the default shell at work is a hassle.
exec bash
