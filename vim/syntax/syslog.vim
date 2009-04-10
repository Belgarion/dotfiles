" $Id: syslog.vim,v 1.1 2002/09/17 16:10:00 rhiestan Exp $
" Vim syntax file
" Language:	syslog log file
" Maintainer:	Bob Hiestand <bob@hiestandfamily.org>
" Last Change:	$Date: 2002/09/17 16:10:00 $
" Remark: Add some color to log files produced by sysklogd.

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match	text 				/\w\+/
syn match	Parenthesis			/).*(/ contains=text
syn match	syslogPath			/\/[a-zA-Z0-9_\-\.]\+/
syn match	syslogParenthesis	/(.*)/ contains=Parenthesis,syslogPath,syslogIp
syn match	syslogIp			/\d\+\.\d\+\.\d\+\.\d\+/
syn match	syslogText			/.*$/ contains=syslogIp,syslogParenthesis,syslogPath
syn match	syslogPid			/\[.*\]/ nextgroup=syslogText
syn match	syslogFacility		/.\{-1,}\[.*\][^\ ]/	contains=syslogPid
syn match	syslogHost			/\S\+/	nextgroup=syslogFacility,syslogText
syn match	syslogDate			/^.\{-}\d\d:\d\d:\d\d/	nextgroup=syslogHost skipwhite

if !exists("did_syslog_syntax_inits")
  let did_syslog_syntax_inits = 1
  hi def syslogDate			ctermfg=darkgreen guifg=green
  hi def syslogHost			ctermfg=darkred guifg=darkred gui=bold
  hi def syslogFacility		ctermfg=red guifg=lightred
  hi def syslogPid			ctermfg=blue guifg=blue
  hi def syslogIp			ctermfg=magenta guifg=magenta
  hi def syslogPath			ctermfg=green guifg=lightgreen
  hi def syslogParenthesis	ctermfg=darkgreen guifg=green
  hi def Parenthesis		ctermfg=darkgreen guifg=green
endif

let b:current_syntax="syslog"
