#!/bin/sh

user_sh=$(getent passwd "${USER}" | sed 's/.*://')
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

repo_path=$(dirname "$(readlink -f "$0")")

for file in .zshrc .zsh.aliaes .zsh.exports .vimrc .tmux.conf ; do
    if [ -e "${HOME}/${file}" ] ; then
        mv "${HOME}/${file}" "${HOME}/${file}.old"
    fi
    echo "copying ${file} to ${HOME}/${file}"
    cp "${repo_path}/${file}" "${HOME}/${file}"
done

if [ -d "${HOME}/.vim" ] ; then
    mv "${HOME}/.vim" "${HOME}/.vim.old"
fi

echo "copying ${repo_path}/.vim to ${HOME}/.vim"
cp -r "${repo_path}/.vim" "${HOME}/.vim"

# install vim plugins using Plug
vim +PlugInstall +qall

upstream="${HOME}/upstream"
if [ ! -d "${upstream}" ] ; then
  mkdir -p "${upstream}"
fi
echo "Cloning Zeta theme to ${upstream}/zeta-zsh-theme"
mkdir ${upstream}/zeta-zsh-theme
git clone https://github.com/Sandlot19/zeta-zsh-theme.git ${upstream}/zeta-zsh-theme
cp ${upstream}/zeta-zsh-theme/zeta.zsh-theme ${HOME}/.oh-my-zsh/custom/themes/

exec zsh
