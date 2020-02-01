let g:syntaxinfo_enabled = get(g:, 'syntaxinfo_enabled', v:false)

let s:format = get(g:, 'syntaxinfo_format', 'base=%base%, linked=%linked%')
let s:delay = get(g:, 'syntaxinfo_delay', 250)

let s:ns = nvim_create_namespace('syntaxinfo')
let s:timer_id = -1

function! s:get_syn_id(transparent)
  let synid = synID(line('.'), col('.'), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction

function! s:get_syn_attr(synid)
  return synIDattr(a:synid, 'name')
endfunction

function! syntaxinfo#show() abort
  let base = s:get_syn_attr(s:get_syn_id(0))
  let linked = s:get_syn_attr(s:get_syn_id(1))
  let msg = substitute(s:format, '%base%', base != '' ? base : 'Normal', 'g')
  let msg = substitute(msg, '%linked%', linked != '' ? linked : 'Normal', 'g')
  let line = line('.')
  let bufnr = bufnr('')

  call nvim_buf_set_virtual_text(bufnr, s:ns, line - 1, [[msg, 'SyntaxInfo']], {})
endfunction

function! syntaxinfo#clear() abort
  let bufnr = bufnr('')
  call nvim_buf_clear_namespace(bufnr, s:ns, 0, -1)
endfunction

function! syntaxinfo#refresh() abort
  if !g:syntaxinfo_enabled
    return
  endif

  call timer_stop(s:timer_id)
  call syntaxinfo#clear()

  let s:timer_id = timer_start(s:delay, { id -> syntaxinfo#show() })
endfunction

function! syntaxinfo#enable() abort
  if g:syntaxinfo_enabled
    return
  endif

  let g:syntaxinfo_enabled = v:true

  call syntaxinfo#init()
  call syntaxinfo#show()
endfunction

function! syntaxinfo#disable() abort
  if !g:syntaxinfo_enabled
    return
  endif

  autocmd! syntaxinfo
  call timer_stop(s:timer_id)
  call syntaxinfo#clear()

  let g:syntaxinfo_enabled = v:false
  let s:timer_id = -1
endfunction

function! syntaxinfo#toggle() abort
  if g:syntaxinfo_enabled
    call syntaxinfo#disable()
    call syntaxinfo#clear()
  else
    call syntaxinfo#enable()
    call syntaxinfo#show()
  endif
endfunction

function! syntaxinfo#init() abort
  if !g:syntaxinfo_enabled
    return
  endif

  augroup syntaxinfo
    autocmd!
    autocmd BufEnter,BufWritePost,CursorMoved * :call syntaxinfo#refresh()
  augroup END
endfunction
