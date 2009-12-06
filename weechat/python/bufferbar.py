import weechat
from itertools import ifilter

SCRIPT_NAME = "bufferbar"
SCRIPT_VERSION = "0.1"
SCRIPT_AUTHOR="Sebastian"
SCRIPT_LICENSE="GPL3"
SCRIPT_DESC="bufferlist in infobar"
keydict = {}

hotlistLevel = { 0:'low', 1:'message', 2:'private', 3:'highlight' }
hotlistLevelColor = { 
		'low':'cyan', 
		'message':'yellow', 
		'private':'lightgreen',
		'highlight':'magenta'
		}

def update_keydict(*kwargs):
	global keydict

	keylist = weechat.infolist_get('key', '', '')
	while weechat.infolist_next(keylist):
		key = weechat.infolist_string(keylist, 'key')
		if 'j' in key:
			continue

		key = key.replace('meta-', '')

		command = weechat.infolist_string(keylist, 'command')
		if command.startswith('/buffer'):
			command = command.replace('/buffer ', '')
			buffer = command.lstrip('*')
			keydict[buffer] = key

	weechat.infolist_free(keylist)

def bufferbar_item_cb(*kwargs):
	global keydict

	window = kwargs[2]

	infolist = weechat.infolist_get('window', '', '')
	curBuffer = None
	while weechat.infolist_next(infolist):
		if weechat.infolist_pointer(infolist, 'pointer') == window:
			curBuffer = weechat.infolist_pointer(infolist, 'buffer')
	weechat.infolist_free(infolist)


	chars = 0
	width = -1

	bufferbarPtr = weechat.bar_search('bufferbar')
	bar = weechat.infolist_get('bar_window', '', '')
	while weechat.infolist_next(bar):
		if weechat.infolist_pointer(bar, 'bar') == bufferbarPtr:
			width = weechat.infolist_integer(bar, 'width')
			break
	weechat.infolist_free(bar)


	activeBuffers = {}
	hotlist = weechat.infolist_get('hotlist', '', '')
	while weechat.infolist_next(hotlist):
		number = str(weechat.infolist_integer(hotlist, 'buffer_number'))
		priority = weechat.infolist_integer(hotlist, 'priority')
		activeBuffers[number] = priority

	weechat.infolist_free(hotlist)

	result = weechat.color('red') + "[" + weechat.color('reset')
	chars += 1

	first = True

	buffers = weechat.infolist_get('buffer', '', '')
	while weechat.infolist_next(buffers):
		if not weechat.infolist_integer(buffers, 'active'):
			continue

		if not first:
			result += " "
			chars += 1
		else:
			first = False

		if weechat.config_get_plugin("short_names") == "on":
			name = weechat.infolist_string(buffers, 'short_name')
		else:
			name = weechat.infolist_string(buffers,'name')

		number = str(weechat.infolist_integer(buffers,'number'))

		numberstr = "[" + number + "]"
		if number in keydict:
			numberstr = keydict[number] + " "

		colorFg = weechat.config_get_plugin("color_default")
		if weechat.infolist_pointer(buffers, 'pointer') == curBuffer:
			colorFg = weechat.config_get_plugin("color_current")
		elif number in activeBuffers:
			colorFg = weechat.config_get_plugin("color_hotlist_" + hotlistLevel[activeBuffers[number]])

		length = len(numberstr.decode('utf-8')) + len(name.decode('utf-8'))

		if length > width - 2:
			numlen = len(numberstr.decode('utf-8'))
			l = width - 2 - numlen
			name = name[:l]
			length = l + numlen
			first = True

		if chars + length + 1  >= width:
			result += " " * (width - chars - 1)
			result += weechat.color('red') + "][" + weechat.color('reset')
			chars = 1

		result += '%s%s%s%s%s%s' % (
				weechat.color(weechat.config_get_plugin("color_number")), 
				numberstr, 
				weechat.color('reset'),
				weechat.color(colorFg), name, weechat.color('reset'))
		chars += length

	result += weechat.color('red') + "]" + weechat.color('reset')

	weechat.infolist_free(buffers)

	return result

def update_item(*kwargs):
	weechat.bar_item_update('bufferbar')
	return weechat.WEECHAT_RC_OK

if __name__ == "__main__":
	if weechat.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, "", ""):
		for i in hotlistLevelColor:
			if weechat.config_get_plugin("color_hotlist_" + i) == "":
				weechat.config_set_plugin("color_hotlist_" + i, hotlistLevelColor[i])
		if weechat.config_get_plugin("color_current") == "":
			weechat.config_set_plugin("color_current", "blue")
		if weechat.config_get_plugin("color_number") == "":
			weechat.config_set_plugin("color_number", "default")
		if weechat.config_get_plugin("color_default") == "":
			weechat.config_set_plugin("color_default", "default")

		if weechat.config_get_plugin("short_names") == "":
			weechat.config_set_plugin("short_names", "on")
		

		weechat.hook_signal('hotlist_*', 'update_item', '')
		weechat.hook_signal('key_bind', 'update_keydict', '')
		weechat.hook_signal('key_unbind', 'update_keydict', '')
		weechat.hook_config("plugins.var.python.bufferbar.*", "update_item", "");
		

		weechat.bar_item_new('bufferbar', 'bufferbar_item_cb', '')
		weechat.bar_new('bufferbar', "on", "501", "window", "", "bottom", 
				"horizontal", "vertical", "0", "0", "default", "default",
				"default", "0", "bufferbar")
		update_keydict()
		weechat.bar_item_update('bufferbar')

# vim:set tabstop=4 softtabstop=4 shiftwidth=4:
