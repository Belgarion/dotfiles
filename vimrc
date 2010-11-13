set nocompatible
" {{{ Set up according to platform
if has("win32") || has("win16")
	let osys="windows"
else
	let osys=system('uname -s')
endif

if has("unix")
	let &shell="zsh"
	set clipboard=autoselect
endif

" }}}
" {{{ Terminals and colors
" {{{ Makes title work in screen
if &term == "screen" || &term == "screen-256color"
  set t_ts=]0;
  set t_fs=\
endif
if &term == "screen" || &term == "screen-256color" || &term == "xterm" 
  set title
endif
" }}}
" {{{ fix for colors on some terms
if &term =~ "xterm"
	if has("terminfo")
		set t_Co=8
		set t_Sf=[3%p1%dm
		set t_Sb=[4%p1%dm
	else
		set t_Co=8
		set t_Sf=[3%dm
		set t_Sb=[4%dm
	endif
endif
" }}}
" {{{ Fixes for vt100
if &term =~ "vt100"
  set t_Co=8           "set number of colors
  set t_Sf=[3%p1%dm  "set foreground color
  set t_Sb=[4%p1%dm  "set background color
  if osys == "Linux"
	  set t_kD=[3~      "fix delete button
	  set t_kh=[1~      "fix home button
	  set t_@7=[4~      "fix end button
  elseif osys == "FreeBSD"
	  "set t_kD=[3~      "fix delete button
	  set t_kh=[H      "fix home button
	  set t_@7=[F      "fix end button
  endif
endif
" }}}
" {{{ 256 color
if &term == "xterm-256color" || &term == "screen-256color" || &term == "rxvt-unicode"
	set t_Co=256
endif
" }}}
" {{{ Mouse
set ttymouse=xterm2
set mouse=a

" Scrolling
map <M-Esc>[62~ <MouseDown>
map! <M-Esc>[62~ <MouseDown>
map <M-Esc>[63~ <MouseUp>
map! <M-Esc>[63~ <MouseUp>
map <M-Esc>[64~ <S-MouseDown>
map! <M-Esc>[64~ <S-MouseDown>
map <M-Esc>[65~ <S-MouseUp>
map! <M-Esc>[65~ <S-MouseUp>
" }}}
" }}}

set history=40

syntax on
set number
set shiftwidth=4
set tabstop=4
set ignorecase
set nowrapscan
set showcmd
set showmode
set autowrite
set autoindent
set ruler
set title
set ttyfast
set formatoptions=tcqor
set scrolloff=3
set incsearch
set hlsearch
set backspace=indent,eol,start
set cinwords=if,else,while,do,for,switch,case
set fileformat=unix
set fileformats=unix
set smartcase
set display+=uhex
set confirm
set undolevels=1000
set visualbell
set guipty
set foldmethod=marker
set foldcolumn=2
if version >= 700
	set showtabline=1
	set listchars=tab:>-,extends:>,precedes:<,trail:-,nbsp:%,eol:$

	" Save session info
	set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize,localoptions
endif
set splitright
set splitbelow
set shellslash

" Include angle brackets in matching.
set matchpairs+=<:>

function! VarExists(var, val)
	if exists(a:var) | return a:val | else | return '' | endif
endfunction

" {{{ Statusline
"set statusline=%t(%2.3n)%m%r%{VarExists('b:gzflag','\ [GZ]')}%h%w\ %([%{&ff}]%)%(:%y%)%(:[%{&fenc}]%)\ %=[%1.7l,%1.7c]\ \ [%p%%]
set statusline=%F%m%r%{VarExists('b:gzflag','\ [GZ]')}%h%w\ [%Y:%{&ff}:%{&fenc}]\ [A=\%03.3b]\ [0x=\%02.2B]\ %=[%1.7l,%1.7c]\ \ [%l/%L,%v][%p%%]
" Always show statusline
set laststatus=2
" }}}
" {{{ Mappings
" {{{ mapping for numeric
imap <Esc>OM <c-m>
 map <Esc>OM <c-m>
imap <Esc>OP <nop>
 map <Esc>OP <nop>
imap <Esc>OQ /
 map <Esc>OQ /
imap <Esc>OR *
 map <Esc>OR *
imap <Esc>OS -
 map <Esc>OS -
imap <Esc>Ol +
imap <Esc>Om -
imap <Esc>On ,
imap <Esc>Op 0
imap <Esc>Oq 1
imap <Esc>Or 2
imap <Esc>Os 3
imap <Esc>Ot 4
imap <Esc>Ou 5
imap <Esc>Ov 6
imap <Esc>Ow 7
imap <Esc>Ox 8
imap <Esc>Oy 9
imap <Esc>Oz 0
" }}}
" {{{ Easily add html tags around selected text in visual mode
vmap sb "zdi<b><C-R>z</b><ESC>
vmap su "zdi<u><C-R>z</u><ESC>
vmap si "zdi<i><C-R>z</i><ESC>
" }}}
" {{{ Comments
map cc v:s!^!//!g <CR>
map cx v:s!^\s*//!!g <CR>v=
vmap cc :s!^!//!g <CR>
vmap cx :s!^\s*//!!g <CR>v=

vmap pc :s!^!#!g <CR>
vmap px :s!^\s*#!!g <CR>v=
" }}}
" {{{ Movement between split windows
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
" }}}
" {{{ File Explorer
" nnoremap <silent> <F8> :Explore<CR>
nnoremap <silent> <C-F8> :Vexplore<CR>
nnoremap <silent> <S-F8> :Hexplore<CR>
"}}}
" {{{ Justify text (center,left,right).
noremap <silent> ,c :ce <CR> << <CR>
noremap <silent> ,l :le <CR>
noremap <silent> ,r :ri <CR>
" }}}
" {{{ Tabs
" Open new tab
nnoremap <silent> \tt :tabnew<CR>
map ,t :tabnew<CR>
" Cycle tabs (forward)
nnoremap <silent> \tn :tabnext<CR>
nnoremap <F12> :tabnext<CR>
inoremap <F12> <Esc>:tabnext<CR>
" Cycle tabs (reverse)
nnoremap <silent> \tp :tabprevious<CR>
nnoremap <F11> :tabprevious<CR>
inoremap <F11> <Esc>:tabprevious<CR>
" }}}
" Paste with ctrl+v
"nmap <silent> <C-v> :set paste<CR>"*p:set nopaste<CR>

" Toggle show line endings with $
nmap <F9> :set invlist <CR>

" Toggle taglist
nmap <F10> :TlistToggle <CR>

" Toggle NERDTree
nmap <F8> :NERDTreeToggle <CR>

" Toggle HLSearch
nmap <F7> :set hlsearch! <CR>

" Disable 'Replace mode'
imap <Ins> <Esc>i

map <Tab> ==
" }}}
" {{{ Highlight embedded code
let perl_extended_vars=1

let php_sql_query=1
let php_htmlInStrings=1
let php_asp_tags=1
let php_folding=1
let php_parent_error_close=1

let html_use_css=1
let html_no_pre=1
let use_xhtml = 1
" }}}

let g:calendar_monday=1

let autodate_keyword_pre='Last Modified: '
let autodate_keyword_post='$'
let autodate_format='%a %Y-%m-%d %H:%M:%S (%z)'

cab Q q
cab W w
cab WQ wq

" Load matchit (% to bounce from do to end, etc.)
runtime! macros/matchit.vim

" {{{ Menu on F5
runtime! menu.vim
set wildmenu
set cpo-=<
set wcm=<C-Z>
nmap <F5> :emenu <C-Z>
" }}}

" Set grep to always display the filename.
"set grepprg=grep\ -nH\ $*
set grepprg=internal

" Insert timestamp
iab xstamp <C-R>=strftime("%a %Y-%m-%d %H:%M:%S (%z)")

" Insert last modified header
iab lastmod Last Modified: <C-R>=strftime("%a %Y-%m-%d %H:%M:%S (%z)")<Esc>

" Use ack instead of grep
if executable("ack")
	let grepprg = "ack "
endif

" Define mapleader
let mapleader = ","

" Save info about files
set viminfo='100

" Completion
" Map C-Space to omnicomplete
inoremap <Nul> <C-x><C-o>

" {{{ Taglist
let Tlist_Auto_Open = 1
let Tlist_Exit_OnlyWindow = 1
" }}}
" {{ Eclim
let g:EclimProjectTreeAutoOpen = 1
" }}
func! MuttCfg() " {{{
	"map <C-J> {gq}                  " Ctrl+J rejustifies current paragraph
	"set formatoptions=tcroqv        " see :help formatoptions
	set comments=nb:>               " rejustify quoted text correctly
	set tw=75                       " wrap lines to 75 chars
	set ft=mail                     " mail file type
endfunc
" }}}
func! Template(extension) " {{{
	let l:tmplPath=$HOME . "/.vim/skel/tmpl." . a:extension
	let l:scriptPath=$HOME . "/.vim/skel/do_header"
	if filereadable(l:tmplPath)
		%d
		silent execute '0r' l:tmplPath
		if executable(l:scriptPath)
			silent execute '%!' l:scriptPath expand('%')
		endif
		execute 'set ft='.a:extension
	endif
endfunc " }}}
" {{{ Autocmd
if has("autocmd")
	autocmd BufNewFile,BufRead * set tw=0

	filetype plugin indent on

	autocmd BufNewFile,BufRead *.cpp,*.c hi! link Include PreProc
	autocmd BufNewFile,BufRead *.hs set fdm=marker sw=4 sts=4 ts=4 et ai
	autocmd BufNewFile,BufRead /tmp/mutt* call MuttCfg()
	autocmd BufNewFile,BufRead /etc/apache2/* set filetype=apache
	autocmd BufNewFile,BufRead *.pd set filetype=html
	autocmd BufNewFile,BufRead modprobe.conf set syntax=modconf
	autocmd BufReadCmd *.jar,*.war,*.ear,*.sar,*.rar,*.xpi call zip#Browse(expand("<amatch>"))

	" omnicomplete
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS
	autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
	autocmd FileType php set omnifunc=phpcomplete#CompletePHP
	autocmd FileType c set omnifunc=ccomplete#CompleteCpp

	" Key bindings
	autocmd FileType tex nmap <buffer> E :!pdflatex %<CR>
	autocmd FileType tex inoremap ^ ^{}<LEFT>
	autocmd FileType tex inoremap _ _{}<LEFT>
	autocmd FileType tex inoremap { {}<LEFT>
	autocmd FileType tex noremap ß :%s/\(\<<c-r>=expand("<cword>")<cr>\>\)/\\begin{\1}\r\r\\end{\1}/<CR><UP>

	" Templates
	autocmd BufNewFile * call Template(expand("%:e"))

	" Python {{{
	autocmd FileType python set omnifunc=pythoncomplete#Complete
	autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
	autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
	" }}}
endif
"}}}
" {{{ Theme
colorscheme zenburn
set background=dark
hi Normal ctermbg=black
hi LineNr ctermbg=black guibg=#3f3f3f
hi Pmenu ctermbg=236
hi Comment gui=none

highlight OverLength ctermbg=black guibg=black
autocmd BufNewFile,BufRead *.c,*.cpp,*.php,*.py syn match OverLength /\%>80v.\+/ containedin=ALL

highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufNewFile,BufRead * syn match ExtraWhitespace /\s\+$/ containedin=ALL

let g:bg = 0

function! LightBG()
	if &t_Co == 256
		hi Normal ctermbg=238
		hi LineNr ctermbg=237 ctermfg=248
		hi NonText ctermfg=242
		set background=dark
	endif
endfunction
command! LightBG call LightBG()

function! DarkBG()
	if &t_Co == 256
		hi Normal ctermbg=black
		hi LineNr ctermfg=248 ctermbg=0
		hi NonText ctermfg=238
		set background=dark
	endif
endfunction
command! DarkBG call DarkBG()

function! ToggleBG()
	if g:bg == 1
		LightBG
		let g:bg = 0
	else
		DarkBG
		let g:bg = 1
	endif
endfunction
command! ToggleBG call ToggleBG()

LightBG

if osys=="windows"
	set guifont=ter-112n:h9
	set printfont=ter-112n:h9
else
	set guifont=Terminus\ 9
	set printfont=Terminus\ 9
endif
" }}}
" {{{ Host Specific
if $HOSTNAME == "nas"
	let Tlist_Auto_Open = 0
	let loaded_matchparen = 1
elseif $HOSTNAME == "polgara"
	let loaded_matchparen = 1
elseif $HOSTNAME == "belgarion"
	set pdev=MP640R
endif
" }}}
