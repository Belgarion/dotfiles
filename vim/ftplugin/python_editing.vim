" Only do this when not done yet for this buffer
if exists("b:did_pythonediting_plugin")
	finish
endif
let b:did_pythonediting_plugin = 1

map <buffer> <S-e> :w<CR>:!/usr/bin/env python % <CR>
map <buffer> gd /def <C-R><C-W><CR> 

set foldmethod=expr
set foldexpr=PythonFoldExpr(v:lnum)
set foldtext=PythonFoldText()

map <buffer> f za
map <buffer> F :call ToggleFold()<CR>
let b:folded = 1

function! ToggleFold()
	if( b:folded == 0 )
		exec "normal! zM"
		let b:folded = 1
	else
		exec "normal! zR"
		let b:folded = 0
	endif
endfunction

function! PythonFoldText()
	let indent = ""
	for i in range(indent(v:foldstart))
		let indent = " " . indent
	endfor

	let size = 1 + v:foldend - v:foldstart
	if size < 10
		let size = " " . size
	endif
	if size < 100
		let size = " " . size
	endif
	if size < 1000
		let size = " " . size
	endif

	let text = getline(v:foldstart)

	let text = substitute(text, '^\s*', '', 'g')
	let text = substitute(text, '"""', '', 'g' )
	let text = substitute(text, "'''", '', 'g' )

	return indent . size . ' lines: '. text . ' '

endfunction

function! PythonFoldExpr(lnum)

	" Determine folding level in Python source
	"
	let line = getline(a:lnum)

	" Handle suport markers
	if line =~ '{{{'
		return "a1"
	elseif line =~ '}}}'
		return "s1"
	endif

	" Classes and functions get their own folds
	if line =~ '^\s*\(class\|def\)\s'
		" Verify if the next line is a class or function definition
		" as well
		let imm_nnum = a:lnum + 1
		let nnum = nextnonblank(imm_nnum)
		let nind = indent(nnum)
		let pind = indent(a:lnum)
		if pind >= nind
			let nline = getline(nnum)
			let w:nestinglevel = nind
			return "<" . ((w:nestinglevel + &sw) / &sw)
		endif
		let w:signature = 1
		let w:nestinglevel = indent(a:lnum)
	endif

	if line =~ '^.*:' && w:signature
		let w:signature = 0
		return ">" . ((w:nestinglevel + &sw) / &sw)
	endif

	" If next line has less or equal indentation than the first one,
	" we end a fold.
	let nnonblank = nextnonblank(a:lnum + 1)
	let nextline = getline(nnonblank) 
	if (nextline !~ '^#\+.*')
		let nind = indent(nnonblank)
		if nind <= w:nestinglevel
			let w:nestinglevel = nind
			return "<" . ((w:nestinglevel + &sw) / &sw)
		else
			let ind = indent(a:lnum)
			if ind == (w:nestinglevel + &sw)
				if nind < ind
					let w:nestinglevel = nind
					return "<" . ((w:nestinglevel + &sw) / &sw)
				endif
			endif
		endif
	endif

	" If none of the above apply, keep the indentation
	return "="

endfunction

" In case folding breaks down
function! ReFold()
	set foldmethod=expr
	set foldexpr=0
	set foldnestmax=2
	set foldmethod=expr
	set foldexpr=PythonFoldExpr(v:lnum)
	set foldtext=PythonFoldText()
	echo 
endfunction

