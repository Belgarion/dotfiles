" Vim filetype detection file
" Language:	Gentoo Things
" Author:	Ciaran McCreesh <ciaranm@gentoo.org>
" Copyright:	Copyright (c) 2004-2005 Ciaran McCreesh
" Licence:	You may redistribute this under the same terms as Vim itself
"
" This sets up syntax highlighting for Gentoo ebuilds, eclasses, GLEPs and
" Gentoo style ChangeLogs.
"

if &compatible || v:version < 603
    finish
endif

" package.mask, package.unmask
au BufNewFile,BufRead */package.{mask,unmask}/*
    \     set filetype=gentoo-package-mask

" package.keywords
au BufNewFile,BufRead */package.keywords/*
    \     set filetype=gentoo-package-keywords

" package.use
au BufNewFile,BufRead */package.use/*
    \     set filetype=gentoo-package-use
