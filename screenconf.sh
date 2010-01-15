# vim: ft=sh
# Screen per-host configuration
__screen_config() {
	local caption host hs hostfunc

	host=${HOSTNAME%%.*}

	hs=$(echo -ne "[%n: %t] %h")

	caption='%{= .G}[ %{G}%H %{g}][%= %{= .w}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}]%1`[%{B} %d/%m %{W}%c %{g}]'

	hostfunc=__screen_host_${HOSTNAME//./_}
	if [ $ZSH_VERSION ]; then
		(whence $hostfunc 2>/dev/null) || hostfunc=__screen_host_default
	else
		[[ $(type -t $hostfunc 2>/dev/null ) == "function" ]] || hostfunc=__screen_host_default
	fi
	eval "$hostfunc"

	screen_cmd defhstatus "${hs}"
	screen_cmd hardstatus string "${hs}" # xterm-title
	screen_cmd hardstatus off # displays hardstatus in titlebar
	screen_cmd caption always "${caption}"

	screen_cmd bindkey "^[[c" next #shift-right
	screen_cmd bindkey "^[[d" prev #shift-left

	# Let new shells know we've been setup
	screen_cmd setenv SCREEN_FIX_HOST ${HOSTNAME}
	export SCREEN_FIX_HOST=${HOSTNAME}
}
__screen_local() {
	# Set the escape to ^qq
	screen_cmd defescape q
	screen_cmd escape q

	screen_cmd bindkey -k k3 prev
	screen_cmd bindkey -k k4 next
}
__screen_host_default() {
	# Set the escape to ^aa
	screen_cmd defescape a
	screen_cmd escape a

	screen_cmd bindkey -k k1 prev
	screen_cmd bindkey -k k2 next
}
__screen_host_Belgarion() {
	__screen_local
}
__screen_host_Kheldar() {
	__screen_local
}

[ ${STY} ] && [[ ${SCREEN_FIX_HOST} != ${HOSTNAME} ]] && __screen_config
unset __screen_config __screen_local __screen_host_default __screen_host_Belgarion __screen_host_Kheldar
# End of screen per-host configuration
