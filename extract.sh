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



#exec zsh
