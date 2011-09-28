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

let g:quickrun_config = {}

let g:quickrun_config['*'] = {
      \ 'runner/vimproc/updatetime' : 100,
      \ 'outputter/file/name' : '/tmp/testee.log',
      \ 'split': 'belowright vertical',
      \ 'targets' : ['file', 'message', 'error'],
      \ 'outputter' : 'multi',
      \ 'log' : 1,
      \ 'success' : 'message',
      \ 'error' : 'quickfix',
      \ 'runner' : 'vimproc',
      \ 'into' : 0,
      \ 'runmode' : 'async:remote:vimproc'
      \}
let g:quickrun_config['ruby'] = {'command': 'ruby', 'exec': '%o %c -Itest %s', 'cmdopt': 'env ROR_NO_COLOR=1'}


let &cpo = s:save_cpo
unlet s:save_cpo
