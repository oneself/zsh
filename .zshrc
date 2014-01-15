#{{{ ZSH Modules

autoload -U compinit promptinit zcalc zsh-mime-setup
compinit
promptinit
zsh-mime-setup

#}}}

#{{{ Options

# why would you type 'cd dir' if you could just type 'dir'?
setopt AUTO_CD

# Now we can pipe to multiple outputs!
setopt MULTIOS

# Spell check commands!  (Sometimes annoying)
setopt CORRECT

# http://stackoverflow.com/questions/3986760/cd-1-2-3-etc-in-z-shell

# This makes cd=pushd
setopt AUTO_PUSHD

# This will use named dirs when possible
setopt AUTO_NAME_DIRS

# If we have a glob this will expand it
setopt GLOB_COMPLETE
setopt PUSHD_MINUS

# No more annoying pushd messages...
# setopt PUSHD_SILENT

# blank pushd goes to home
#setopt PUSHD_TO_HOME

# this will ignore multiple directories for the stack.  Useful?  I dunno.
setopt PUSHD_IGNORE_DUPS

# 10 second wait if you do something that will delete everything.  I wish I'd had this before...
#setopt RM_STAR_WAIT

# use magic (this is default, but it can't hurt!)
setopt ZLE

setopt NO_HUP

setopt EMACS

export EDITOR="emacs -Q -nw"

# If I could disable Ctrl-s completely I would!
setopt NO_FLOW_CONTROL

# beeps are annoying
setopt NO_BEEP

# Case insensitive globbing
setopt NO_CASE_GLOB

# Be Reasonable!
setopt NUMERIC_GLOB_SORT

# I don't know why I never set this before.
setopt EXTENDED_GLOB

# hows about arrays be awesome?  (that is, frew${cool}frew has frew surrounding all the variables, not just first and last
setopt RC_EXPAND_PARAM

autoload run-help
HELPDIR=~/zsh_help

#}}}

#{{{ Completion Stuff

# Faster! (?)
zstyle ':completion::complete:*' use-cache 1

# case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete
#zstyle ':completion:*' completer _expand _force_rehash _complete _approximate _ignored
zstyle ':completion:*' completer _expand _complete _approximate _ignored

# generate descriptions with magic.
zstyle ':completion:*' auto-description 'specify: %d'

# Don't prompt for a huge list, page it!
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Don't prompt for a huge list, menu it!
zstyle ':completion:*:default' menu 'select=0'

# Have the newer files last so I see them first
zstyle ':completion:*' file-sort modification reverse

# color code completion!!!!  Wohoo!
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"

unsetopt LIST_AMBIGUOUS
setopt  COMPLETE_IN_WORD

# Separate man page sections.  Neat.
zstyle ':completion:*:manuals' separate-sections true

# Egomaniac!
zstyle ':completion:*' list-separator 'fREW'

# complete with a menu for xwindow ids
zstyle ':completion:*:windows' menu on=0
zstyle ':completion:*:expand:*' tag-order all-expansions

# more errors allowed for large words and fewer for small words
zstyle ':completion:*:approximate:*' max-errors 'reply=(  $((  ($#PREFIX+$#SUFFIX)/3  ))  )'

# Errors format
zstyle ':completion:*:corrections' format '%B%d (errors %e)%b'

# Don't complete stuff already on the line
zstyle ':completion::*:(rm|vi):*' ignore-line true

# Don't complete directory we are already in (../here)
zstyle ':completion:*' ignore-parents parent pwd

zstyle ':completion::approximate*:*' prefix-needed false

#}}}

#{{{ History Stuff

# Where it gets saved
HISTFILE=~/.zshhistory

# Remember about a years worth of history (AWESOME)
SAVEHIST=10000
HISTSIZE=10000

# Don't overwrite, append!
setopt APPEND_HISTORY

# Write after each command
# setopt INC_APPEND_HISTORY

# Killer: share history between multiple shells
setopt SHARE_HISTORY

# If I type cd and then cd again, only save the last one
setopt HIST_IGNORE_DUPS

# Even if there are commands inbetween commands that are the same, still only save the last one
setopt HIST_IGNORE_ALL_DUPS

# Pretty    Obvious.  Right?
setopt HIST_REDUCE_BLANKS

# If a line starts with a space, don't save it.
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

# When using a hist thing, make a newline show the change before executing it.
setopt HIST_VERIFY

# Save the time and how long a command ran
setopt EXTENDED_HISTORY

setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

#}}}

#{{{ Prompt

# This is a hook function that is called whenever you cd somewhere. It then looks if there is a file
# env or .env.rc is in the new directory or one of the directories above in the tree and sources it,
# if found. I have a env file in every project directory, in which I set up development environment
# stuff, like updating the PERL5LIB variable with new paths, refreshing tags files etc. It really
# saves a lot of time if you're often switching between projects or branches.
function chpwd; {
    DIRECTORY="$PWD"
    while true; do
        if [ -f './.env.rc' ]; then
            source './.env.rc'
            break
        fi
        if [ -f './env' ]; then
            source './env'
            break
        fi
        [ $PWD = '/' ] && break
        cd -q ..
    done
    cd -q "$DIRECTORY"
}

# This code comes from here: http://github.com/olivierverdier/zsh-git-prompt

# Initialize colors.
autoload -U colors
colors

# Allow for functions in the prompt.
setopt PROMPT_SUBST

## Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)

chpwd_update_git_vars() {
    update_current_git_vars.sh
}

precmd_update_git_vars() {
    if [ -n "$__EXECUTED_GIT_COMMAND" ]; then
        update_current_git_vars.sh
        unset __EXECUTED_GIT_COMMAND
    fi
}

preexec_update_git_vars () {
    case "$1" in
    git*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    eg*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    esac
}


## Spotify repo completion
function spclone() {
  repo=$1 ; shift
  git clone git.spotify.net:$repo $*
}

function _repo_complete() {
  local host file now
  host=${SP_REPO_HOST:-git.spotify.net}
  file=${SP_REPO_FILE:-$HOME/.spclone_cache}
  now=$(date +'%s')

  # Use a simple cache to speed things up.
  # export SP_REPO_CACHE=0 to force refresh.
  if [[ ! -f $file ]] || [[ $(($now - ${SP_REPO_CACHE:-0})) -gt 300 ]]; then
    ssh $host gerrit ls-projects 2> /dev/null > $file
    export SP_REPO_CACHE=$now
  fi

  reply=($(<$file))
}

compctl -K _repo_complete spclone

# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

# Set the prompt.
#PROMPT=$'%U%n@%m%u:%{${fg[cyan]}%}%B%~%b$(prompt_git_info)%{${fg[default]}%} '
#PROMPT=$'%U%n@%m%u:%{${fg[cyan]}%}%B%~%b%{${fg[default]}%} '
#PROMPT='%B%.%b$ '
#PROMPT=$'\e[1;32m%n@%m\e[0m:\e[1;34m%.\e[0m$ '
#PROMPT='%U%n@%m%u:%B%.%b$ '
if [ -z "$SSH_CONNECTION" ]; then
  # Regular prompt
  #PROMPT="%{$fg[green]%}%B%n%b%{$reset_color%}@%{$fg[blue]%}%B%m%b%{$reset_color%}:%B%.%b> "
  PROMPT="%{$fg[green]%}%B%n%b%{$reset_color%}@%{$fg[blue]%}%B%m%b%{$reset_color%}:%B%C%b> "
else
  # SSH
  PROMPT="%{$fg[green]%}%B%n%b%{$reset_color%}@%{$fg[yellow]%}%m%b%{$reset_color%}:%B%C%b> "
fi

RPROMPT='%b$(prompt_git_info)'

# Needed to make emacs tramp mode work
if [[ "$TERM" == "dumb" ]]
then
  unsetopt zle
  unsetopt prompt_cr
  unsetopt prompt_subst
  unfunction precmd
  unfunction preexec
  PS1='$ '
fi

#}}}

#{{{ ZSH Modules

autoload -U compinit promptinit zcalc zsh-mime-setup
compinit
promptinit
zsh-mime-setup

#}}}

source $HOME/.zshenv
