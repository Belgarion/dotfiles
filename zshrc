export UNAMES=`uname -s`

fsource() {
	local file=$1
	[ -f $file ] && source $file
}

fsource ~/.bash_os-based

fsource ~/.zsh/options

# Autoload zsh modules when they are referenced
zmodload -a -i zsh/stat stat
zmodload -a -i zsh/zpty zpty
zmodload -a -i zsh/zprof zprof
#zmodload -ap zsh/mapfile mapfile

addToPath() {
	local pos=$1
	local dir=$2

	[ ! -d $dir ] && return # don't add non existing directories

	for p in $path; do
		if [[ $p == $dir ]]; then
			return
		fi
	done

	if [[ $pos == "^" ]]; then
		export PATH=$dir:$PATH
	elif [[ $pos == "$" ]]; then
		export PATH=$PATH:$dir
	fi
}

addToPath "^" "/sbin"
addToPath "^" "/bin"
addToPath "^" "/usr/sbin"
addToPath "^" "/usr/bin"
addToPath "^" "/usr/local/sbin"
addToPath "^" "/usr/local/bin"
addToPath "$" "/opt/vmware/server/lib/bin"
addToPath "^" "$HOME/SDK/android-sdk-linux/tools/"
addToPath "^" "$HOME/bin"

export LANG='sv_SE.UTF-8'
export TZ="Europe/Stockholm"
export HOSTNAME="`hostname`"

if which vimmanpager >&/dev/null; then
	export MANPAGER="vimmanpager"
elif which vim >&/dev/null; then
	export MANPAGER="/bin/sh -c \"unset PAGER;col -b -x | \
	  vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
	  -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
	  -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""
fi

if which most >&/dev/null; then
	export PAGER="most -s"
	export BROWSER="most -s"
else
	export PAGER="less"
	export BROWSER="less"
fi

fsource ~/.sh/less_colors
export LESS='-R -M --shift 5'
(which lesspipe.sh >&/dev/null) && export LESSOPEN='|lesspipe.sh %s'

if which vim >&/dev/null; then
	export EDITOR="vim"
	export MUTT_EDITOR="vim"
elif which vi >&/dev/null; then
	export EDITOR="vi"
	export MUTT_EDITOR="vi"
elif which nano >&/dev/null; then
	export EDITOR="nano"
	export MUTT_EDITOR="nano"
fi

unsetopt ALL_EXPORT

###
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$chroot" ] && [ -r /etc/chroot ]; then
    chroot=$(cat /etc/chroot)
fi

alias man='LC_ALL=C LANG=C man'
fsource ~/.aliases
fsource ~/.zsh/git
fsource ~/.zsh/prompt

fpath=(~/.zsh/completion $fpath)

autoload -U compinit
compinit

typeset -a mailpath
for i in ~/.mail/lists/*(.); do
   mailpath[$#mailpath+1]="${i}?You have new mail in ${i:t}."
done
if [ ! $MAIL ]; then 
	mailpath[$#mailpath+1]="/var/spool/mail/$USER?You have new mail."
else 
	mailpath[$#mailpath+1]="$MAIL?You have new mail."
fi

fsource ~/.zsh/bindkey

### VARIABLES
export CONCURRENCY_LEVEL=3

export GTK2_RC_FILES=$HOME/.gtkrc-2.0
export MOZ_DISABLE_PANGO=1

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

# Completion styles
fsource ~/.zsh/zstyle

# Local settings
fsource ~/.zsh/local

# Screen settings
fsource ~/.screenconf.sh

# ccache
if [ -f /etc/gentoo-release ]; then
	addToPath "^" "/usr/lib/ccache/bin"
elif [ -f /etc/debian_version ]; then
	addToPath "^" "/usr/lib/ccache"
fi

if [[ $HOSTNAME == "nas" ]]; then
	export TZ="Europe/Brussels"
	export LANG="en_US.utf8"
	export CCACHE_PREFIX="distcc"
	export DISTCC_HOSTS="192.168.5.111"
fi

if type keychain >&/dev/null; then
	keychain ~/.ssh/id_rsa ~/.ssh/id_dsa
	fsource ~/.keychain/${HOSTNAME}-sh
fi

type fortune >&/dev/null && fortune
