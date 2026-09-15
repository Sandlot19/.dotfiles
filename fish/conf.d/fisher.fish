# Configure fisher to install and load plugins from user data directory
# so third-party plugin files do not dirty the dotfiles repository.
set -g fisher_path $__fish_user_data_dir/fisher

set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2>/dev/null
end
