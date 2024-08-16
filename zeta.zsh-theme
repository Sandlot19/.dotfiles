# Zeta theme for oh-my-zsh
# Tested on Linux, Unix and Windows under ANSI colors.
# Copyright: Skyler Lee, 2015

# Colors: black|red|blue|green|yellow|magenta|cyan|white
local black=$fg[black]
local red=$fg[red]
local blue=$fg[blue]
local green=$fg[green]
local yellow=$fg[yellow]
local magenta=$fg[magenta]
local cyan=$fg[cyan]
local white=$fg[white]

local black_bold=$fg_bold[black]
local red_bold=$fg_bold[red]
local blue_bold=$fg_bold[blue]
local green_bold=$fg_bold[green]
local yellow_bold=$fg_bold[yellow]
local magenta_bold=$fg_bold[magenta]
local cyan_bold=$fg_bold[cyan]
local white_bold=$fg_bold[white]

local highlight_bg=$bg[red]

local zeta="=> "

########################### BEGIN RIP FROM OMZ TIMER PLUGIN ########################################
# The below is taken from the 'timer' plugin fro omz, modified slightly to set a variable that is
# placeable in my prompt rather than setting an unconfigurable print location.
local __tdiffstr=""

zmodload zsh/datetime

__timer_current_time() {
  zmodload zsh/datetime
  echo $EPOCHREALTIME
}

__timer_format_duration() {
  local mins=$(printf '%.0f' $(($1 / 60)))
  local secs=$(printf "%.${TIMER_PRECISION:-1}f" $(($1 - 60 * mins)))
  local duration_str=$(echo "${mins}m${secs}s")
  local format="${TIMER_FORMAT:-/%d}"
  echo "${format//\%d/${duration_str#0m}}"
}

__timer_save_time_preexec() {
  __timer_cmd_start_time=$(__timer_current_time)
}

__timer_display_timer_precmd() {
  if [ -n "${__timer_cmd_start_time}" ]; then
    local cmd_end_time=$(__timer_current_time)
    local tdiff=$((cmd_end_time - __timer_cmd_start_time))
    unset __timer_cmd_start_time
    if [[ -z "${TIMER_THRESHOLD}" || ${tdiff} -ge "${TIMER_THRESHOLD}" ]]; then
        __tdiffstr=$(__timer_format_duration ${tdiff})
        local cols=$((COLUMNS - ${#tdiffstr} - 1))
        echo -e "\033[1A\033[${cols}C ${tdiffstr}"
    fi
  fi
}
########################### END RIP FROM OMZ TIMER PLUGIN ##########################################

# Machine name.
function get_box_name {
    if [ -f ~/.box-name ]; then
        cat ~/.box-name
    else
        echo $HOST
    fi
}

# User name.
function get_usr_name {
    local name="%n"
    if [[ "$USER" == 'root' ]]; then
        name="%{$highlight_bg%}%{$white_bold%}$name%{$reset_color%}"
    fi
    echo $name
}

# Directory info.
function get_current_dir {
    echo '%~'
}

# Git info.
ZSH_THEME_GIT_PROMPT_PREFIX="%{$yellow_bold%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$green_bold%} ✔ "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$red_bold%} ✘ "

# Git status.
ZSH_THEME_GIT_PROMPT_ADDED="%{$green_bold%}+"
ZSH_THEME_GIT_PROMPT_DELETED="%{$red_bold%}-"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$magenta_bold%}*"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$blue_bold%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$cyan_bold%}="
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$yellow_bold%}?"

# Git sha.
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="[%{$yellow%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}]"

function get_git_prompt {
    if [[ -n $(git rev-parse --is-inside-work-tree 2>/dev/null) ]]; then
    #    local git_status="$(git_prompt_status)"
    #    if [[ -n $git_status ]] ; then
    #        git_status="[$git_status%{$reset_color%}]"
    #    fi
    #    local git_prompt=" <$(git_prompt_info)$git_status>"
    #    echo $git_prompt
      local git_branch="$(git_current_branch)"

      if git diff --quiet ; then
        echo " <%{$green_bold%}$git_branch%{$reset_color%}>"
      else
        echo " <%{$red_bold%}$git_branch%{$reset_color%}>"
      fi

    fi
}

function get_space {
    local str=$1$2
    local zero='%([BSUbfksu]|([FB]|){*})'
    local len=${#${(S%%)str//$~zero/}}
    local size=$(( $COLUMNS - $len - 1 ))
    local space=""
    while [[ $size -gt 0 ]]; do
        space="$space "
        let size=$size-1
    done
    echo $space
}

# Prompt: # USER@MACHINE: DIRECTORY <BRANCH [STATUS]> --- (TIME_STAMP)
# > command
function print_prompt_head {
    local left_prompt="\
%{$blue_bold%}[\
%{$green_bold%}$(get_usr_name)%{$reset_color%}\
%{$blue_bold%}] \
%{$white%}%4~%{$reset_color%} \
$(get_git_prompt) ${__tdiffstr}"
    #local right_prompt="%{$blue%})%{$reset_color%} "
    #print -rP "$left_prompt$(get_space $left_prompt $right_prompt)$right_prompt"
    print -rP "$left_prompt$(get_space $left_prompt)"
    unset __tdiffstr
}

function get_prompt_indicator {
    if [[ $? -eq 0 ]]; then
        echo "%{$blue_bold%}$zeta %{$reset_color%}"
    else
        echo "%{$red_bold%}$zeta %{$reset_color%}"
    fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec __timer_save_time_preexec
add-zsh-hook precmd __timer_display_timer_precmd
add-zsh-hook precmd print_prompt_head
setopt prompt_subst

PROMPT='$(get_prompt_indicator)'
