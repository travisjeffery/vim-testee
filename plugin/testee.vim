if exists('g:loaded_testee')
  finish
endif
let g:loaded_testee = 1

let s:save_cpo = &cpo
set cpo&vim

noremap <silent>
      \ <Plug>(testee-test-case) :<C-u>call testee#case()<CR>
noremap <silent>
      \ <Plug>(testee-test-file) :<C-u>call testee#file()<CR>
noremap <silent>
      \ <Plug>(testee-test-last) :<C-u>call testee#last()<CR>

let g:testee_config = {}

let &cpo = s:save_cpo
unlet s:save_cpo
