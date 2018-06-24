function! SimpleSnippets#core#obtainTrigger()
	return s:trigger
endfunction

function! SimpleSnippets#core#isExpandable()
	call s:ObtainTrigger()
	if SimpleSnippets#getSnipFileType(s:trigger) != -1
		return 1
	endif
	call s:ObtainAlternateTrigger()
	if SimpleSnippets#getSnipFileType(s:trigger) != -1
		return 1
	endif
	let s:trigger = ''
	return 0
endfunction

function! s:ObtainTrigger()
	if s:trigger == ''
		if mode() == 'i'
			let l:cursor_pos = getpos(".")
			call cursor(line('.'), col('.') - 1)
			let s:trigger = expand("<cWORD>")
			call cursor(l:cursor_pos[1], l:cursor_pos[2])
		else
			let s:trigger = expand("<cWORD>")
		endif
	endif
endfunction

function! s:ObtainAlternateTrigger()
	if mode() == 'i'
		let l:cursor_pos = getpos(".")
		call cursor(line('.'), col('.') - 1)
		let s:trigger = expand("<cword>")
		call cursor(l:cursor_pos[1], l:cursor_pos[2])
	else
		let s:trigger = expand("<cword>")
	endif
endfunction

" 7.4 compability layer
function! SimpleSnippets#core#execute(command, ...)
	if a:0 != 0
		let l:silent = a:1
	else
		let l:silent = ""
	endif
	if exists("*execute")
		let l:result = execute(a:command, l:silent)
	else
		redir => l:result
		if l:silent == "silent"
			silent execute a:command
		elseif l:silent == "silent!"
			silent! execute a:command
		else
			execute a:command
		endif
		redir END
	endif
	return l:result
endfunction
