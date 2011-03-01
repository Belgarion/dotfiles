# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

UNAMES=`uname -s`
export UNAMES

echo $LANG | grep -i utf >/dev/null && UTF8=1 || UTF8=0

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
shopt -s cmdhist
set -o noclobber #prevent overwriting files with > (use >| if you want to overwrite)
set -o notify #notify job status direct instead of before next prompt

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$chroot" ] && [ -r /etc/gentoo_chroot ]; then
    chroot=$(cat /etc/gentoo_chroot)
fi

if [[ ${EUID} == 0 ]]; then
	USERCOLOR="\e[1;31m"
elif [[ `hostname` == "Belgarion" ]]; then
	USERCOLOR="\e[1;36m"
elif [[ "${UNAMES%_*}" == "CYGWIN" ]]; then
	USERCOLOR="\e[0;32m"
else
	USERCOLOR="\e[1;33m"
fi

if [[ $UTF8 -eq 1 ]]; then
	PS1='\[\e[1;30m\]┐ ${chroot:+(\[\e[1;32m\]$chroot\[\e[1;30m\]) }('${USERCOLOR}'\u\[\e[1;30m\]@\[\e[0;36m\]\h\[\e[1;30m\]) [\[\e[1;36m\]\t\[\e[0;36m\]\[\e[6D:\]\[\e[2C:\]\[\e[2C\]\[\e[1;30m\]|\[\e[0;36m\]\d\[\e[1;30m\]] [\[\e[0;36m\]`_bashish_prompt_cwd "\[\e[1;30m\]" "\[\e[0;36m\]" 58`\[\e[1;30m\]] \n\[\e[1;30m\]└\[\e[0;36m\]──\[\e[1;36m\]─>\[\e[0m\] '
else
	PS1='\[\e[1;30m\]${chroot:+(\[\e[1;32m\]$chroot\[e[1;30m\]) }('$USERCOLOR'\u\[\e[1;30m\]@\[\e[0;36m\]\h\[\e[1;30m\]) [\[\e[1;36m\]\t\[\e[0;36m\]\[\e[6D:\]\[\e[2C:\]\[\e[2C\]\[\e[1;30m\]|\[\e[0;36m\]\d\[\e[1;30m\]] [\[\e[0;36m\]`_bashish_prompt_cwd "\[\e[1;30m\]" "\[\e[0;36m\]" 58`\[\e[1;30m\]] \n\[\e[1;36m\]>\[\e[0m\] '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|screen*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Aliases
[ -f ~/.aliases ] && . ~/.aliases

#Configure screen
[ -f ~/.screenconf.sh ] && . ~/.screenconf.sh

[ -d ~/apps/bin ] && PATH=~/apps/bin:"${PATH}"
[ -d ~/bin ] && PATH=~/bin:"${PATH}"

[ -f ~/.bash_os-based ] && . ~/.bash_os-based


(which vimmanpager >&/dev/null) && export MANPAGER="vimmanpager"
if (which most >&/dev/null); then
	export PAGER="most -s"
	export BROWSER="most -s"
fi
[ -f ~/.sh/less_colors ] && . ~/.sh/less_colors 
export LESS='-R -M --shift 5'
(which lesspipe.sh >&/dev/null) && export LESSOPEN='|lesspipe.sh %s'

export CONCURRENCY_LEVEL=3
export EDITOR="vim"

export GTK2_RC_FILES=$HOME/.gtkrc-2.0
export HISTFILE=/dev/null
export HISTIGNORE="fg"
export MOZ_DISABLE_PANGO=1

export MPD_HOST="mpdpassword@polgara.home"

# Colorful message
which toilet >&/dev/null && toilet --gay "$UNAMES "

if [ -e ~/TODO ]; then
	if [[ $SHLVL -eq 4 || $SHLVL -eq 5 ]]; then
		echo tail ~/TODO -n5
		tail ~/TODO -n5
	fi
fi

#stty erase 
stty -ixon # disable ^s ^x flow control

# Bash-completion
if [ -f /etc/profile.d/bash-completion ]; then
	. /etc/profile.d/bash-completion
elif [ -f /usr/local/etc/bash_completion ]; then
	. /usr/local/etc/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if type keychain >&/dev/null; then
	keychain ~/.ssh/id_rsa ~/.ssh/id_dsa
	source ~/.keychain/${HOSTNAME}-sh
fi
