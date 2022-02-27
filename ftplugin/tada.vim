if exists('b:did_ftplugin') | finish | endif

call tada#init#Init()

function! s:IsTodoItem(line)
  return tada#IsTodoItem(a:line)
endfunction

function! s:IsEmptyIndentable()
  return g:tada_smart_tab && getline('.') =~ '^\s*\%(-\s*\%(\[.\]\)\?\|>\)\s*$'
endfunction

function! s:IsEmptyListOrTodo()
  return getline('.') =~ '^\s*-\s*\%(\[.\]\)\?\s*$'
endfunction

function! s:HandleNormalCR()
  return tada#fold#HandleCR()
endfunction

function! s:HandleInsertCR()
  return tada#autoline#ImapCR()
endfunction

function! s:Handleo()
  return tada#autoline#Nmapo()
endfunction

function! s:HandleO()
  return tada#autoline#NmapO()
endfunction

function! s:NextTopic()
  if getline('.') =~ g:tada_pat_topic
    call <SID>SearchTopic(indent('.'), 'eW')
  else
    call s:NextParentTopic()
  endif
endfunction
command -nargs=0 NextTopic :call <SID>NextTopic()

function! s:NextParentTopic()
  let next_indent = max([indent('.') - &sw, 0])

  call <SID>SearchTopic(next_indent, 'eW')
endfunction
command -nargs=0 NextParentTopic :call <SID>NextParentTopic()

function! s:PreviousTopic()
  if getline('.') =~ g:tada_pat_topic
    call <SID>SearchTopic(indent('.'), 'beW')
  else
    call s:PreviousParentTopic()
  endif
endfunction
command -nargs=0 PreviousTopic :call <SID>PreviousTopic()

function! s:PreviousParentTopic()
  let next_indent = max([indent('.') - &sw, 0])

  call <SID>SearchTopic(next_indent, 'beW')
endfunction
command -nargs=0 PreviousParentTopic :call <SID>PreviousParentTopic()

function! s:SearchTopic(indent, flags)
  call search('^\s\{,' . a:indent . '\}-.*:$', a:flags)
endfunction

command -nargs=1 Fold :call tada#fold#To(<args>)
command -nargs=0 TadaBox :call tada#box#Toggle()
command -nargs=0 Cut :call tada#map#EmptyLine()
command -nargs=0 NextTodo :call tada#todo#ToggleTodoStatus(1)
command -nargs=0 PreviousTodo :call tada#todo#ToggleTodoStatus(-1)

execute 'nnoremap <silent> <buffer> ' . g:tada_todo_switch_status_mapping . ' :NextTodo<CR>'
execute 'nnoremap <silent> <buffer> ' . g:tada_todo_switch_status_reverse_mapping . ' :PreviousTodo<CR>'
nmap <silent> <buffer> <nowait> <script> <expr> <CR> <SID>HandleNormalCR()
nnoremap <silent> <buffer> <script> <expr> o <SID>Handleo()
nnoremap <silent> <buffer> <script> <expr> O <SID>HandleO()
execute 'nnoremap <silent> <buffer> ' . g:tada_map_prefix . '1 :Fold(0)<CR>'
execute 'nnoremap <silent> <buffer> ' . g:tada_map_prefix . '2 :Fold(1)<CR>'
execute 'nnoremap <silent> <buffer> ' . g:tada_map_prefix . '3 :Fold(2)<CR>'
execute 'nnoremap <silent> <buffer> ' . g:tada_map_prefix . '4 :Fold(3)<CR>'
execute 'nnoremap <silent> <buffer> ' . g:tada_map_prefix . '5 :Fold(4)<CR>'
execute 'nnoremap <silent> <buffer> ' . g:tada_map_prefix . '6 :Fold(5)<CR>'
execute 'nnoremap <silent> <buffer> ' . g:tada_map_prefix . '0 :Fold(6)<CR>'
execute 'nnoremap <silent> <buffer> ' . g:tada_map_prefix . 'o :normal! zO<CR>'
execute 'nnoremap <silent> <buffer> ' . g:tada_map_prefix . 'c :normal! zc<CR>'
execute 'nnoremap <silent> <buffer> ' . g:tada_map_box . ' :TadaBox<CR>'

if g:tada_goto_maps
  nnoremap <buffer> <script> ( <Cmd>PreviousTopic<CR>
  nnoremap <buffer> <script> ) <Cmd>NextTopic<CR>
  nnoremap <buffer> <script> { <Cmd>PreviousParentTopic<CR>
  nnoremap <buffer> <script> } <Cmd>NextParentTopic<CR>
endif

execute 'inoremap <buffer> <script> ' . g:tada_map_box . ' <Cmd>TadaBox<CR>'
execute 'inoremap <buffer> <script> ' . g:tada_map_empty_line . ' <Cmd>call tada#map#EmptyLine()<CR>'
inoremap <silent> <buffer> <script> <expr> \| <SID>IsEmptyListOrTodo() ? '\|<C-O>:call tada#map#EmptyLine()<CR> ' : '\|'
inoremap <silent> <buffer> <script> <expr> > <SID>IsEmptyListOrTodo() ? '><C-O>:call tada#map#EmptyLine()<CR> ' : '>'
inoremap <silent> <buffer> <script> <expr> : <SID>IsEmptyListOrTodo() ? '<C-O>S<C-D>- ' : ':'
inoremap <silent> <buffer> <script> <expr> <Tab> <SID>IsEmptyIndentable() ? '<C-T>' : '<Tab>'
inoremap <silent> <buffer> <script> <expr> <S-Tab> <SID>IsEmptyIndentable() ? '<C-D>' : '<S-Tab>'
inoremap <silent> <buffer> <script> <expr> <CR> <SID>HandleInsertCR()

if g:tada_autolines
  setlocal comments=b:\|,b:-,b:>
  setlocal formatoptions=tron
end

setlocal commentstring=#\ %s
setlocal ts=2 sw=2 sts=2 expandtab smarttab
setlocal autoindent
setlocal foldmethod=expr
setlocal foldtext=tada#fold#TextForTopic()
setlocal foldexpr=tada#fold#Level(v:lnum)
setlocal fillchars=fold:\ "
setlocal foldenable
setlocal foldlevel=6

function s:Hi(group, fg, bg = "")
  if a:fg != ""
    exec "hi " . a:group . " guifg=#" . a:fg
  endif

  if a:bg != ""
    exec "hi " . a:group . " guibg=#" . a:bg
  endif
endfun

call <SID>Hi("tadaArchivedTopic", b:tada_colors["archive"])
call <SID>Hi("tadaTopicTitle1", b:tada_colors["topic"]["1"])
call <SID>Hi("tadaTopicTitle2", b:tada_colors["topic"]["2"])
call <SID>Hi("tadaTopicTitle3", b:tada_colors["topic"]["3"])
call <SID>Hi("tadaTopicTitle4", b:tada_colors["topic"]["4"])
call <SID>Hi("tadaTopicTitle5", b:tada_colors["topic"]["5"])
call <SID>Hi("tadaTopicTitle6", b:tada_colors["topic"]["6"])
call <SID>Hi("tadaInvalidConfig", "ffffff", b:tada_colors["invalid_config"])
call <SID>Hi("tadaComment", b:tada_colors["comment"])
call <SID>Hi("tadaMetadata", b:tada_colors["metadata"])
call <SID>Hi("tadaNote", b:tada_colors["note"])

for status in b:tada_todo_statuses
  let name = tada#utils#Camelize(status)

  if has_key(b:tada_colors["todo"], status)
    let color = substitute(b:tada_colors["todo"][status], '^#', '', '')
    execute 'call <SID>Hi("tadaTodoItem' . name . '", "' . color . '")'
  endif
endfor

let b:did_ftplugin = 1
