syn match pythonError "^\s*\(class\|def\|for\|while\|try\|except\|finally\|if\|elif\|else\)[^\:]*$" display
syn match pythonError "^\s*\(class\|def\|for\|while\|try\|except\|finally\|if\|elif\|else\)$" display
syn match pythonError "&&" display
syn match pythonError "||" display
syn match pythonError "[;]$" display
syn keyword pythonError do

hi link pythonError Error
