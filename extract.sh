#!/bin/sh

if command -v getent ; then
    user_sh=$(getent passwd "${USER}" | sed 's/.*://')
else
    # pray that the default setup sets $SHELL
    user_sh="$(echo ${SHELL})"
fi

case "${user_sh}" in
    *"zsh")
        echo "Default shell is ${user_sh}"
        ;;

    *)  # Interesting note, BSD is smart enough to figure out which
        # shell you want just by the shell name. i.e. I could say
        # chsh -s zsh and it would find a path ending with zsh,
        # but on Linux you need to give chsh the full path to the shell
        # you want
        zsh=$(grep zsh /etc/shells | head -n1)
        echo "Default shell is ${user_sh}"
        echo "Setting \$SHELL to ${zsh}"
        chsh -s "${zsh}"
        ;;
esac

if [ ! -d "${HOME}/.oh-my-zsh" ] ; then
    echo "installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

repo_path=$(dirname "$0")

for file in .zshrc .zsh.exports .zsh.path .tmux.conf .gitconfig .gitignore; do
    if [ -e "${HOME}/${file}" ] ; then
        mv "${HOME}/${file}" "${HOME}/${file}.old"
    fi
    echo "copying ${file} to ${HOME}/${file}"
    cp "${repo_path}/${file}" "${HOME}/${file}"
done

if [ -d "${HOME}/.vim" ] ; then
    mv "${HOME}/.vim" "${HOME}/.vim.old"
fi

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

cp "${repo_path}/zeta.zsh-theme" "${HOME}/.oh-my-zsh/custom/themes/"

exec zsh
