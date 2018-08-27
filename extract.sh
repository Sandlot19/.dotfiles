#!/bin/sh

user_sh=$(getent passwd $USER | sed 's/.*://')
case "$user_sh" in
    *"zsh")
        echo "Default shell is $user_sh" 
        ;;

    *)  # Interesting note, BSD is smart enough to figure out which
        # shell you want just by the shell name. i.e. I could say
        # chsh -s zsh and it would find a path ending with zsh,
        # but on Linux you need to give chsh the full path to the shell
        # you want
        zsh=$(grep zsh /etc/shells | head -n1) 
        echo "Default shell is $user_sh" 
        echo "Setting \$SHELL to $zsh"
        chsh -s $zsh
        ;;
esac

if [ ! -e $HOME/.oh-my-zsh ] ; then
    echo "installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

repo_path=$(dirname $(readlink -f $0))

if [ -e $HOME/.zshrc ] ; then
    mv $HOME/.zshrc $HOME/.old.zshrc
fi

echo copying $repo_path/.zshrc to $HOME/.zshrc
cp $repo_path/.zshrc $HOME/.zshrc

if [ -e $HOME/.zsh.aliases ] ; then
    mv $HOME/.zsh.aliases $HOME/.old.zsh.aliases
fi

echo copying $repo_path/.zsh.aliases to $HOME/.zsh.aliases
cp $repo_path/.zsh.aliases $HOME/.zsh.aliases

if [ -e $HOME/.vimrc ] ; then
    mv $HOME/.vimrc $HOME/.old.vimrc
fi

echo copying $repo_path/.vimrc to $HOME/.vimrc
cp $repo_path/.vimrc $HOME/.vimrc

if [ -d $HOME/.vim ] ; then
    mv $HOME/.vim $HOME/.old.vim
fi

echo copying $repo_path/.vim to $HOME/.vim
cp -r $repo_path/.vim $HOME/.vim

# install vim plugins using Plug
vim +PlugInstall +qall

upstream=$HOME/upstream
mkdir -p ${upstream}
echo "Cloning Zeta theme to ${upstream}"
git clone https://github.com/Sandlot19/zeta-zsh-theme.git ${upstream}
cp ${upstream}/zeta-zsh-theme/zeta.zsh-theme ${HOME}/.oh-my-zsh/custom/themes/

exec zsh
