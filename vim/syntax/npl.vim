" Vim syntax file
" Language:	Niakwa Programming Language
" Maintainer:	Sebastian Larsson <belgarion@brokenbrain.eu>
" Last Change:	lör 2009-12-19 03:38:29 (+0100)

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

" A bunch of useful npl keywords
syn keyword nplStatement	ABS ADD ALL ARCCOS ARCSIN ATN
syn keyword nplStatement	BIN BOOL BREAK $BOXTABLE $BREAK BEGIN
syn keyword nplStatement	CASE CLEAR COM $CLOSE CLOSE CONTINUE CONVERT COPY COS
syn keyword nplStatement	DAC DATA DATE DBACKSPACE $DECLARE DEFFN DEFFN' DELETE $DEMO $DET $DEVICE DIM DSC DSKIP
syn keyword nplStatement	ELSE END $END ENDIF ERR$ ERROR ENDDO
syn keyword nplStatement	FIELD FOR $FORMAT FUNCTION
syn keyword nplStatement	$GIO GOSUB GOSUB' GOTO
syn keyword nplStatement	#HDC $HELP $HELPINDEX HEXPACK HEXPRINT HEXUNPACK
syn keyword nplStatement	$IF IF $IMAGEF $IMAGEL INCLUDE INIT INPUT
syn keyword nplStatement	$KEEPREMS $KEYBOARD KEYIN
syn keyword nplStatement	$LDATE LET LIMITS LINPUT LIST LOAD LOAD*' LOOP
syn keyword nplStatement	$MACHINE MAT MODULE MOVE $MSG
syn keyword nplStatement	$NETID NEXT $NUMBERS 
syn keyword nplStatement	$OBJECT ON $OPEN OPEN $OPTIONS $OSERR
syn keyword nplStatement	PACK $PACK PRINT $PRINTER PRINTUSING PROCEDURE $PROGRAM $PSTAT PUBLIC
syn keyword nplStatement	READ RECORD REDIM $RELEASE RENAME RENUMBER REPEAT RESAVE RESET RESTORE RETURN $REV ROTATE RUN $RUNDIR
syn keyword nplStatement	SAVE SCRATCH $SCREEN SEEK SELECT $SELECT $SER SET $SHELL STEP STOP SUB SWITCH
syn keyword nplStatement	$TAB #TERM THEN TO TIME TRACE $TRAN
syn keyword nplStatement	UNPACK $UNPACK UNSCRATCH UNTIL $USER USES
syn keyword nplStatement	VERIFY WEND WHILE WRITE XOR

syn keyword nplFunction	#ID INT STR HEX ERR EXP $FIELDFORMAT #FIELDLENGTH #FIELDSTART
syn keyword nplFunction FIX FN #GOLDKEY LEN LGT LOG MAX MIN MOD $NAMEOF NUM
syn keyword nplFunction AT BOX HEXOF TAB POS #PI #PART #RECORDLENGTH RND ROUND
syn keyword nplFunction SGN SIN SPACE SPACEF SPACEK SPACEP SPACEV SPACEW SQR TAN VAL VER
syn keyword nplTodo contained	TODO

"integer number, or floating point number without a dot.
syn match  nplNumber		"\<\d\+\>"
"floating point number, with dot
syn match  nplNumber		"\<\d\+\.\d*\>"
"floating point number, starting with a dot
syn match  nplNumber		"\.\d\+\>"

" String and Character contstants
syn match   nplSpecial contained "\\\d\d\d\|\\."
syn region  nplString		  start=+"+  skip=+\\\\\|\\"+  end=+"+  contains=nplSpecial

syn region  nplComment	start="REM" end="$\|:" contains=nplTodo
syn match   nplLineNumber	"^\d*\s"
syn match   nplTypeSpecifier	"[a-zA-Z0-9][\$%&!#]"ms=s+1
syn match   nplFilenumber	"#\d\+"
syn match   nplMathsOperator	"-\|=\|[:<>+\*^/\\]\|AND\|OR"
syn keyword nplLogicalOperator	AND OR

" Define the default highlighting.
if version >= 508 || !exists("did_npl_syntax_inits")
  if version < 508
    let did_npl_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink nplLabel		Label
  HiLink nplConditional	Conditional
  HiLink nplRepeat		Repeat
  HiLink nplLineNumber	Comment
  HiLink nplNumber		Number
  HiLink nplError		Error
  HiLink nplStatement	Statement
  HiLink nplString		String
  HiLink nplComment		Comment
  HiLink nplSpecial		Special
  HiLink nplTodo		Todo
  HiLink nplFunction		Identifier
  HiLink nplTypeSpecifier Type
  HiLink nplFilenumber nplTypeSpecifier
  "hi nplMathsOperator term=bold cterm=bold gui=bold
  HiLink nplLogicalOperator Statement

  delcommand HiLink
endif

let b:current_syntax = "npl"

" vim: ts=8
