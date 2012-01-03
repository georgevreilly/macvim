" Vim indent file
" Language:     LaTeX
" Maintainer:   Zhou YiChao <broken.zhou@gmail.com>
" Created:      Sat, 16 Feb 2002 16:50:19 +0100
" Last Change:	2011 Dec 24
" Last Update:  25th Sep 2002, by LH :
"               (*) better support for the option
"               (*) use some regex instead of several '||'.
"               Oct 9th, 2003, by JT:
"               (*) don't change indentation of lines starting with '%'
"               2005/06/15, Moshe Kaminsky <kaminsky@math.huji.ac.il>
"               (*) New variables:
"                   g:tex_items, g:tex_itemize_env, g:tex_noindent_env
"               2011/3/6, by Zhou YiChao <broken.zhou@gmail.com>
"               (*) Don't change indentation of lines starting with '%'
"                   I don't see any code with '%' and it doesn't work properly
"                   so I add some code.
"               (*) New features: Add smartindent-like indent for "{}" and  "[]".
"               (*) New variables: g:tex_indent_brace
"               2011/9/25, by Zhou Yichao <broken.zhou@gmail.com>
"               (*) Bug fix: smartindent-like indent for "[]"
"               (*) New features: Align with "&".
"               (*) New variable: g:tex_indent_and
"               2011/10/23 by Zhou Yichao <broken.zhou@gmail.com>
"               (*) Bug fix: improve the smartindent-like indent for "{}" and
"               "[]".
"
" Version: 0.62

" Options: {{{
"
" To set the following options (ok, currently it's just one), add a line like
"   let g:tex_indent_items = 1
" to your ~/.vimrc.
"
" * g:tex_indent_brace
"
"   If this variable is unset or non-zero, it will use smartindent-like style
"   for "{}" and "[]"
"
" * g:tex_indent_items
"
"   If this variable is set, item-environments are indented like Emacs does
"   it, i.e., continuation lines are indented with a shiftwidth.
"
"   NOTE: I've already set the variable below; delete the corresponding line
"   if you don't like this behaviour.
"
"   Per default, it is unset.
"
"              set                                unset
"   ----------------------------------------------------------------
"       \begin{itemize}                      \begin{itemize}
"         \item blablabla                      \item blablabla
"           bla bla bla                        bla bla bla
"         \item blablabla                      \item blablabla
"           bla bla bla                        bla bla bla
"       \end{itemize}                        \end{itemize}
"
"
" * g:tex_items
"
"   A list of tokens to be considered as commands for the beginning of an item
"   command. The tokens should be separated with '\|'. The initial '\' should
"   be escaped. The default is '\\bibitem\|\\item'.
"
" * g:tex_itemize_env
"
"   A list of environment names, separated with '\|', where the items (item
"   commands matching g:tex_items) may appear. The default is
"   'itemize\|description\|enumerate\|thebibliography'.
"
" * g:tex_noindent_env
"
"   A list of environment names. separated with '\|', where no indentation is
"   required. The default is 'document\|verbatim'.
"
" * g:tex_indent_and
"
"   If this variable is unset or zero, vim will try to align the line with first
"   "&". This is pretty useful when you use environment like table or align.
"   Note that this feature need to search back some line, so vim may become
"   a little slow.
"
" }}}

if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

" Delete the next line to avoid the special indention of items
if !exists("g:tex_indent_items")
    let g:tex_indent_items = 1
endif
if !exists("g:tex_indent_brace")
    let g:tex_indent_brace = 1
endif
if !exists("g:tex_indent_and")
    let g:tex_indent_and = 1
endif
if g:tex_indent_items
    if !exists("g:tex_itemize_env")
        let g:tex_itemize_env = 'itemize\|description\|enumerate\|thebibliography'
    endif
    if !exists('g:tex_items')
        let g:tex_items = '\\bibitem\|\\item'
    endif
else
    let g:tex_items = ''
endif

if !exists("g:tex_noindent_env")
    let g:tex_noindent_env = 'document\|verbatim\|lstlisting'
endif

setlocal autoindent
setlocal nosmartindent
setlocal indentexpr=GetTeXIndent()
exec 'setlocal indentkeys+=},],\&' . substitute(g:tex_items, '^\|\(\\|\)', ',=', 'g')
let g:tex_items = '^\s*' . g:tex_items


" Only define the function once
if exists("*GetTeXIndent") | finish
endif

let s:cpo_save = &cpo
set cpo&vim

function GetTeXIndent()
    " Find a non-blank line above the current line.
    let lnum = prevnonblank(v:lnum - 1)

    " Comment line is not what we need.
    while lnum != 0 && getline(lnum) =~ '^\s*%'
        let lnum = prevnonblank(lnum - 1)
    endwhile

    " At the start of the file use zero indent.
    if lnum == 0
        return 0
    endif

    let line = getline(lnum)             " last line
    let cline = getline(v:lnum)          " current line

    " You want to align with "&"
    if g:tex_indent_and
        " Align with last line if last line has a "&"
        if stridx(cline, "&") != -1 && stridx(line, "&") != -1
            return indent(v:lnum) + stridx(line, "&") - stridx(cline, "&")
        endif

        " set line & lnum to the line which doesn't contain "&"
        while lnum != 0 && (stridx(line, "&") != -1 || line =~ '^\s*%')
            let lnum = prevnonblank(lnum - 1)
            let line = getline(lnum)
        endwhile
    endif


    if lnum == 0
        return 0
    endif

    let ind = indent(lnum)

    " New code for comment: retain the indent of current line
    if cline =~ '^\s*%'
        return indent(v:lnum)
    endif

    " Add a 'shiftwidth' after beginning of environments.
    " Don't add it for \begin{document} and \begin{verbatim}
    ""if line =~ '^\s*\\begin{\(.*\)}'  && line !~ 'verbatim'
    " LH modification : \begin does not always start a line
    " ZYC modification : \end after \begin won't cause wrong indent anymore
    if line =~ '\\begin{.*}' && line !~ g:tex_noindent_env
                \ && line !~ '\\begin{.\{-}}.*\\end{.*}'

        let ind = ind + &sw

        if g:tex_indent_items
            " Add another sw for item-environments
            if line =~ g:tex_itemize_env
                let ind = ind + &sw
            endif
        endif
    endif


    " Subtract a 'shiftwidth' when an environment ends
    if cline =~ '^\s*\\end' && cline !~ g:tex_noindent_env

        if g:tex_indent_items
            " Remove another sw for item-environments
            if cline =~ g:tex_itemize_env
                let ind = ind - &sw
            endif
        endif

        let ind = ind - &sw
    endif

    if g:tex_indent_brace
        " Add a 'shiftwidth' after a "{" or "[".
        let sum1 = 0
        for i in range(0, strlen(line)-1)
            if line[i] == "}" || line[i] == "]"
                let sum1 = max([0, sum1-1])
            endif
            if line[i] == "{" || line[i] == "["
                let sum1 += 1
            endif
        endfor

        let sum2 = 0
        for i in reverse(range(0, strlen(cline)-1))
            if cline[i] == "{" || cline[i] == "["
                let sum2 = max([0, sum2-1])
            endif
            if cline[i] == "}" || cline[i] == "]"
                let sum2 += 1
            endif
        endfor

        let ind += (sum1 - sum2) * &sw
    endif


    " Special treatment for 'item'
    " ----------------------------

    if g:tex_indent_items

        " '\item' or '\bibitem' itself:
        if cline =~ g:tex_items
            let ind = ind - &sw
        endif

        " lines following to '\item' are intented once again:
        if line =~ g:tex_items
            let ind = ind + &sw
        endif

    endif

    return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: set sw=4 textwidth=80:
