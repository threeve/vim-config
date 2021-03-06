"=============================================================================
" Copyright (c) 2007-2010 Takeshi NISHIDA
"
"=============================================================================
" LOAD GUARD {{{1

if !l9#guardScriptLoading(expand('<sfile>:p'), 702, 100)
  finish
endif

" }}}1
"=============================================================================
" GLOBAL FUNCTIONS {{{1

"
function fuf#mrufile#createHandler(base)
  return a:base.concretize(copy(s:handler))
endfunction

"
function fuf#mrufile#getSwitchOrder()
  return g:fuf_mrufile_switchOrder
endfunction

"
function fuf#mrufile#renewCache()
  let s:cache = {}
endfunction

"
function fuf#mrufile#requiresOnCommandPre()
  return 0
endfunction

"
function fuf#mrufile#onInit()
  call fuf#defineLaunchCommand('FufMruFile', s:MODE_NAME, '""')
  augroup fuf#mrufile
    autocmd!
    autocmd BufEnter     * call s:updateInfo()
    autocmd BufWritePost * call s:updateInfo()
  augroup END
endfunction

" }}}1
"=============================================================================
" LOCAL FUNCTIONS/VARIABLES {{{1

let s:MODE_NAME = expand('<sfile>:t:r')

"
function s:updateInfo()
  if !empty(&buftype) || !filereadable(expand('%'))
    return
  endif
  let items = fuf#loadDataFile(s:MODE_NAME, 'items')
  let items = fuf#updateMruList(
        \ items, { 'word' : expand('%:p'), 'time' : localtime() },
        \ g:fuf_mrufile_maxItem, g:fuf_mrufile_exclude)
  call fuf#saveDataFile(s:MODE_NAME, 'items', items)
  call s:removeItemFromCache(expand('%:p'))
endfunction

"
function s:removeItemFromCache(word)
  for items in values(s:cache)
    if exists('items[a:word]')
      unlet items[a:word]
    endif
  endfor
endfunction

" returns empty value if invalid item
function s:formatItemUsingCache(item)
  if a:item.word !~ '\S'
    return {}
  endif
  if !exists('s:cache[a:item.word]')
    if filereadable(a:item.word)
      let s:cache[a:item.word] = fuf#makePathItem(
            \ fnamemodify(a:item.word, ':p:~'), strftime(g:fuf_timeFormat, a:item.time), 0)
    else
      let s:cache[a:item.word] = {}
    endif
  endif
  return s:cache[a:item.word]
endfunction

" }}}1
"=============================================================================
" s:handler {{{1

let s:handler = {}

"
function s:handler.getModeName()
  return s:MODE_NAME
endfunction

"
function s:handler.getPrompt()
  return fuf#formatPrompt(g:fuf_mrufile_prompt, self.partialMatching)
endfunction

"
function s:handler.getPreviewHeight()
  return g:fuf_previewHeight
endfunction

"
function s:handler.isOpenable(enteredPattern)
  return 1
endfunction

"
function s:handler.makePatternSet(patternBase)
  return fuf#makePatternSet(a:patternBase, 's:interpretPrimaryPatternForPath',
        \                   self.partialMatching)
endfunction

"
function s:handler.makePreviewLines(word, count)
  return fuf#makePreviewLinesForFile(a:word, a:count, self.getPreviewHeight())
endfunction

"
function s:handler.getCompleteItems(patternPrimary)
  return self.items
endfunction

"
function s:handler.onOpen(word, mode)
  call fuf#openFile(a:word, a:mode, g:fuf_reuseWindow)
endfunction

"
function s:handler.onModeEnterPre()
endfunction

"
function s:handler.onModeEnterPost()
  " NOTE: Comparing filenames is faster than bufnr('^' . fname . '$')
  let bufNamePrev = fnamemodify(bufname(self.bufNrPrev), ':p:~')
  let self.items = fuf#loadDataFile(s:MODE_NAME, 'items')
  call map(self.items, 's:formatItemUsingCache(v:val)')
  call filter(self.items, '!empty(v:val) && v:val.word !=# bufNamePrev')
  call fuf#mapToSetSerialIndex(self.items, 1)
  call fuf#mapToSetAbbrWithSnippedWordAsPath(self.items)
endfunction

"
function s:handler.onModeLeavePost(opened)
endfunction

" }}}1
"=============================================================================
" vim: set fdm=marker:
