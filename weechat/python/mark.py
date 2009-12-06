import weechat

SCRIPT_NAME = "mark"
SCRIPT_AUTHOR = "Belgarion <belgarion@brokenbrain.eu>"
SCRIPT_VERSION = "0.1"
SCRIPT_LICENSE = "GPL3"
SCRIPT_DESC = "Put a mark in current buffer"

weechat.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE,
				SCRIPT_DESC, "", "")
weechat.hook_command("mark", "Puts a mark in current buffer", "", "", "", "mark", "")

def mark(data, buffer, args):
	weechat.prnt(weechat.current_buffer(), "-----------------------------------------")
	return weechat.WEECHAT_RC_OK
