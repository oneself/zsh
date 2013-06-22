
## General
export CVS_RSH=ssh
export JPDA_ADDRESS=9005
# Prevent firefox from open remote instance locally
export MOZ_NO_REMOTE=1
export LC_ALL=en_US.UTF-8

## Java
export JAVA_HOME=/devel/jdk
export JDK_HOME=$JAVA_HOME
export MAVEN_HOME=/devel/maven
export ANT_OPTS=-Xmx256M
# Java 1.7 causes the keyboard to stop working
export IDEA_JDK=/devel/jdk6
export M2_HOME=/devel/maven

# Needs this to make Java work with xmonad.
# Commented this out since I think it causes keyboard problems.
#export AWT_TOOLKIT='MToolkit'
export _JAVA_AWT_WM_NONREPARENTING=1

## Python
export WORKON_HOME="$HOME/.virtualenvs"
#source /usr/bin/virtualenvwrapper.sh
source /etc/bash_completion.d/virtualenvwrapper

## Jython
# Cannot use JYTHON_HOME because it conflicts with some Jython scripts.
export JYTHON_HME="/devel/jython"
alias jeasy_install="$JYTHON_HME/bin/easy_install"
alias jeasy_install2.5="$JYTHON_HME/bin/easy_install-2.5"
alias jvirtualenv="$JYTHON_HME/bin/virtualenv"

## Oracle
export ORACLE_HOME=/devel/instantclient_11_2
export PATH=$PATH:$ORACLE_HOME
export LD_LIBRARY_PATH=$ORACLE_HOME
export CPATH=$CPATH:$ORACLE_HOME/sdk/include
export TNS_ADMIN=$HOME/etc/oracle

## Keychain
#[ -z "$HOSTNAME" ] && HOSTNAME=`uname -n`
#[ -f $HOME/.keychain/$HOSTNAME-sh ]     && . $HOME/.keychain/$HOSTNAME-sh
#[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ] && . $HOME/.keychain/$HOSTNAME-sh-gpg
#keychain ~/.ssh/id_rsa
#keychain ~/.ssh/id_rsa_ihr

## SSH Agent
if [ -r $HOME/etc/.ssh-agent ]; then
  source $HOME/etc/.ssh-agent > /dev/null
fi

# Path
PATH="$HOME/bin:$PATH"
PATH="$PATH:/sbin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:$JAVA_HOME/bin"
PATH="$PATH:$HOME/bin/kindle"
PATH="$PATH:/devel/google_appengine"
PATH="$PATH:$ORACLE_HOME/bin"
PATH="$PATH:/devel/scala/bin"
PATH="$PATH:$HOME/.cabal/bin"
PATH="$PATH:/devel/android/sdk/platform-tools"
PATH="$PATH:$JYTHON_HME/bin"
PATH="$PATH:$ANT_HOME/bin"
PATH="$PATH:/opt/cxoffice/bin"
PATH="$PATH:/devel/maven/bin"

alias cvs='cvs -q'
alias rsync='rsync -e ssh'
alias ls='ls --color'
alias ll='ls -lh'
alias la='ls -lha'
alias ack-grep='ack-grep --follow'
alias ack='ack-grep --follow'
#alias nosetests='nosetests -v'
alias wtag='cat CVS/Tag'
alias search='find -L $PWD -iname'
alias gitk='gitk --all'
alias update='update_current_git_vars.sh'
alias df='df -h --total -l'
alias du='du -sch'
alias wl='wc -l'
alias untar='tar xvf'
alias ungzip='tar xvzf'
alias unbzip='tar xvjf'
alias tgz='tar -pczf'
alias root='sudo su -'
alias grep='grep --color -I'
alias diff='colordiff'
alias R="R --no-save"
alias emacsnox="emacs -Q -nw"
alias fm="emacs -Q -nw -f dired"
alias ssh='ssh-add -l|grep -v "The agent has no identities" || ssh-add && unalias ssh && ssh'
alias git='ssh-add -l|grep -v "The agent has no identities" || ssh-add && unalias git && git'
#alias git='git --no-pager'
alias mkvirtualenv='mkvirtualenv --no-site-packages'
alias vpn="$HOME/bin/sshuttle/sshuttle -r jump1.ash.spotify.net -x 10.40.0.0/24 -x 192.168.1.0/24 0.0.0.0/0"

alias emerge='emerge -avt -p'
alias em='/usr/bin/emerge -vt'
alias emsyn='eix-sync'
alias emupdate='emerge -uND world'
alias emrevdep='revdep-rebuild'
alias emremove='emerge -c'
alias embuild='emerge -uNDB world' # Build but don't install
alias emapply='emerge -uNDK world' # Install previously built
alias emclean="rm -rf /var/tmp/portage/*; rm -rf /usr/portage/distfiles/*"

# Set terminal title
case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;%n@%m: %~\a"}
        ;;
esac
