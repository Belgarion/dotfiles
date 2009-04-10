#; If sudo exists, clear our tickets.
if (type sudo &>/dev/null); then
	sudo -k 2>/dev/null
fi

# when leaving the console clear the screen to increase privacy
if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
