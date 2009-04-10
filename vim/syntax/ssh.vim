" SSH syntax file
" Language:	SSH known hosts

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match	host	/^[^ ]\+/
syn match	type	/ssh-[rd]s[as]/

if !exists("did_ssh_syntax_inits")
  let did_ssh_syntax_inits = 1
  hi def host	ctermfg=darkred guifg=darkred gui=bold
  hi def type	ctermfg=magenta guifg=magenta
endif

let b:current_syntax="ssh"
