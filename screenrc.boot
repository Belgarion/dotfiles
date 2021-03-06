# vim:ft=screen
autodetach on
activity "%c activity -> %n%f %t"
startup_message off
crlf off
defscrollback 1000
silencewait 15
pow_detach_msg "Screen session of \$LOGNAME \$:cr:\$:nl:ended."
altscreen on
defbce on
term screen-256color
utf8 on
defutf8 on
escape ^aa

hardcopy_append on
nonblock on

termcapinfo xterm*|rxvt* ti@:te@
termcapinfo xterm*|rxvt*|kterm*|Eterm* 'hs:ts=\E]0;:fs=\007:ds=\E]0;\007'
termcapinfo xterm*|linux*|rxvt*|Eterm* OP
termcapinfo xterm|rxvt hs@:cs=\E[%i%d;%dr:im=\E[4h:ei=\E[4l
termcapinfo xterm|rxvt hs@:cs=\E[%i%p1%d;%p2%dr:im=\E[4h:ei=\E[4l
termcapinfo xterm*|rxvt* Z0=\E[?3h:Z1=\E[?3l:is=\E[r\E[m\E[2J\E[H\E[?7h\E[?1;4;6l
termcapinfo xterm* OL=100
termcapinfo xterm|rxvt 'VR=\E[?5h:VN=\E[?5l'
termcapinfo xterm|rxvt 'k1=\E[11~:k2=\E[12~:k3=\E[13~:k4=\E[14~'
termcapinfo xterm|rxvt 'kh=\EOH:kI=\E[2~:kD=\E[3~:kH=\EOF:kP=\E[5~:kN=\E[6~'
termcapinfo xterm|rxvt 'vi=\E[?25l:ve=\E[34h\E[?25h:vs=\E[34l'
termcapinfo xterm|rxvt 'XC=K%,%\E(B,[\304,\\\\\326,]\334,{\344,|\366,}\374,~\337'
termcapinfo xterm*|rxvt* be
termcapinfo rxvt-unicode|xterm-256color 'Co#256:AB=\E[48;5;%dm:AF=\E[38;5;%dm' #to make colors work properly with rxvt-unicode with 256color patch (and with xterm-256color on freebsd)

backtick 1 0 0 /home/sebastian/.screen/battery
caption always '%{= .G}[ %{G}%H %{g}][%= %{= .w}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}]%1`[%{B} %d/%m %{W}%c %{g}]'
hardstatus string '%h' # %h = hardstatus = xterm title
hardstatus off # displays hardstatus in titlebar

bindkey "^[[c" next
bindkey "^[[d" prev

#unbind dangerous keys
bind ^\
bind .
bind \\
bind h
bind ^h

screen -t weechat      0 zsh
screen -t mutt         1 mutt -y
#screen -t alsamixer	   2 alsamixer -c0
#screen -t ncmpcpp      3 ncmpcpp
#screen -t calcurse     4 calcurse

# this will log screen errors to a daily log under the speficied directory
logfile /home/sebastian/logs/screen_%y-%m-%d_%0c

# these last 2 lines are to set the focus on startup (which screen window we look at when screen finishes starting)
focus
select 0
