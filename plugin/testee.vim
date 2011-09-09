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

if !exists('g:quickrun_config')
  let g:quickrun_config = {}

  let g:quickrun_config['*'] = {
        \ 'runner/vimproc/updatetime' : 100,
        \ 'outputter/file/name' : '/tmp/testee.log',
        \ 'split': 'vertical rightbelow',
        \ 'targets' : ['quickfix', 'buffer', 'file'],
        \ 'outputter' : 'buffer',
        \ 'runner' : 'vimproc',
        \ 'into' : 0,
        \ 'runmode' : 'async:remote:vimproc'
        \}
else
  let g:quickrun_config = extend(g:quickrun_config, {
        \ 'targets' : ['quickfix', 'buffer', 'file'],
        \ 'outputter/file/name' : '/tmp/testee.log'
        \ })
endif


let &cpo = s:save_cpo
unlet s:save_cpo
