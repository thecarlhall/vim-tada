" Vim syntax file
" Language:   Tada
" Maintainer: John DeWyze <john@dewyze.dev>
" Filenames:  *.tada

if exists("b:current_syntax")
  finish
endif

syn spell toplevel
syn sync fromstart
syn case ignore

execute 'syn match tadaDescription "' . g:tada_pat_description . '"'
execute 'syn match tadaArchive "' . g:tada_pat_archive . '"'
execute 'syn match tadaComment "' . g:tada_pat_comment . '"'
execute 'syn match tadaListItem "' . g:tada_pat_list_item . '" contains=tadaContext,tadaProject'
execute 'syn match tadaListItem "' . g:tada_pat_list_item_empty . '"'
execute 'syn match tadaMetadata "' . g:tada_pat_metadata . '"'
execute 'syn match tadaNote "' . g:tada_pat_note . '"'

for level in [1,2,3,4,5,6]
  let indent = (level - 1) * 2
  execute 'syn region tadaTopicTitle' . level . ' matchgroup=tadaDelimiter start="^\s\{' . indent . '}-\s*" end=":$" oneline'
endfor

for [status, symbol] in items(b:tada_todo_symbols)
  let name = tada#utils#Camelize(status)

  execute 'syn match tadaTodoItem' . name . ' /^\s*-\s*\[' . symbol . '\].*$/ contains=tadaContext,tadaProject'
endfor

execute 'syn match tadaInvalidConfig "' . g:tada_pat_invalid_config . '"'
execute 'syn match tadaBufferConfig "' . g:tada_pat_buffer_config . '"'

syn match tadaContext '\(^\|\W\)@[^[:blank:]]\+' contained
syn match tadaProject '\(^\|\W\)+[^[:blank:]]\+' contained

syn match tadaPreSep ":" conceal cchar= contained
syn match tadaStatusPre "[\?]" conceal cchar=📊 contained containedin=tadaMetadata nextgroup=tadaPreSep
syn match tadaAssignPre "@" conceal cchar=🧑 contained containedin=tadaMetadata nextgroup=tadaPreSep
syn match tadaStartPre "\^" conceal cchar=🛫 contained containedin=tadaMetadata nextgroup=tadaPreSep
syn match tadaDuePre "\$" conceal cchar=📅 contained containedin=tadaMetadata nextgroup=tadaPreSep
syn match tadaLinkPre "&" conceal cchar=🔗 contained containedin=tadaMetadata nextgroup=tadaPreSep
syn match tadaTagsPre "#" conceal cchar=🏷️ contained containedin=tadaMetadata nextgroup=tadaPreSep
syn match tadaPrioPre "!" conceal cchar=❗ contained containedin=tadaMetadata nextgroup=tadaPreSep

hi def link tadaArchive Comment
hi def link tadaBufferConfig Comment
hi def link tadaComment Comment
hi def link tadaInvalidConfig SpellBad
hi def link tadaMetadata Identifier
hi def link tadaNote SpecialComment
hi def link tadaTodoItemFlagged Error
hi def link tadaTodoItemDone Label
hi def link tadaTodoItemInProgress Type
hi def link tadaTopicTitle1 Define
hi def link tadaTopicTitle2 Function
hi def link tadaTopicTitle3 String
hi def link tadaTopicTitle4 Define
hi def link tadaTopicTitle5 Function
hi def link tadaTopicTitle6 String

hi def link tadaContext Special
hi def link tadaProject Special

hi Folded guifg=CadetBlue

let b:current_syntax = "tada"
