let s:save_cpo = &cpo
set cpo&vim

function! testee#case()
  let cases = s:test_cases_for_pattern(s:test_case_patterns['test'])
  if cases != 'false'
    let cases = substitute(cases, "'\\|\"", '.', 'g')
    let g:testee_config['last_exec'] = "%o %c -Itest " . expand("%") . " %a"
    let g:testee_config['last_args'] = "-n " . cases 
    let &l:errorformat = s:errorformat_backtrace
    execute 'QuickRun -outputter multi -errorformat "'. s:errorformat_backtrace .'" -runner vimproc' .
          \' -exec "' . g:testee_config['last_exec'] . 
          \'" -args "' . g:testee_config['last_args'] . '"'
  else
    echoerr 'No test cases found.'
  endif
endfunction

function! testee#file()
  if s:testeeble()
    let g:testee_config['last_exec'] = "%o %c -Itest " . expand("%")
  else
    let g:testee_config['last_exec'] = "%o %c -Itest " . split(rails#buffer().related(), '\n')[0]
  endif
  let g:testee_config['last_args'] = -1
  execute 'QuickRun -outputter multi -runner vimproc' .
        \' -exec "' . g:testee_config['last_exec'] . '"' 
endfunction

function! testee#last()
  if g:testee_config['last_args'] == -1
    execute 'QuickRun -outputter multi -runner vimproc' .
          \' -exec "' . g:testee_config['last_exec'] . '"' 
  else
    execute 'QuickRun -outputter multi -runner vimproc' .
          \' -exec "' . g:testee_config['last_exec'] . 
          \'" -args "' . g:testee_config['last_args'] . '"'
  endif
endfunction

function! s:test_cases_for_pattern(pattern)
  let line_number = a:firstline
  while line_number > 0
    let line = getline(line_number)
    for pattern in keys(a:pattern)
      if line =~ pattern
        return a:pattern[pattern](line)
      endif
    endfor
    let line_number -= 1
  endwhile
  return 'false'
endfunction

function! s:testeeble()
  for pattern in ['test']
    if @% =~ pattern
      let s:pattern = pattern
      return 1
    endif
  endfor
endfunction

function! s:test_case_with_index_1(str)
  return split(a:str)[1]
endfunction

function! s:test_case_with_index_2(str)
  return "test_" . join(split(split(a:str, '"')[1]), '_')
endfunction

function! s:test_case_with_index_3(str)
  return split(a:str, '"')[1]
endfunction

function! s:test_case_with_index_4(str)
  return "test_" . join(split(split(a:str, "'")[1]), '_')
endfunction

function! s:test_case_with_index_5(str)
  return split(a:str, "'")[1]
endfunction

let s:test_case_patterns = {}
let s:test_case_patterns['test'] = {
      \'^\s*def test':function('s:test_case_with_index_1'),
      \'^\s*test \s*"':function('s:test_case_with_index_2'),
      \"^\\s*test \\s*'":function('s:test_case_with_index_4'),
      \'^\s*should \s*"':function('s:test_case_with_index_3'),
      \"^\\s*should \\s*'":function('s:test_case_with_index_5')
      \}

let s:my_errorformat='%A%\\d%\\+)%.%#,'

" current directory
let s:my_errorformat=s:my_errorformat . '%D(in\ %f),'

" failure and error headers, start a multiline message
let s:my_errorformat=s:my_errorformat
      \.'%A\ %\\+%\\d%\\+)\ Failure:,'
      \.'%A\ %\\+%\\d%\\+)\ Error:,'
      \.'%+A'."'".'%.%#'."'".'\ FAILED,'

" exclusions
let s:my_errorformat=s:my_errorformat
      \.'%C%.%#(eval)%.%#,'
      \.'%C-e:%.%#,'
      \.'%C%.%#/lib/gems/%\\d.%\\d/gems/%.%#,'
      \.'%C%.%#/lib/ruby/%\\d.%\\d/%.%#,'
      \.'%C%.%#/vendor/rails/%.%#,'

" specific to template errors
let s:my_errorformat=s:my_errorformat
      \.'%C\ %\\+On\ line\ #%l\ of\ %f,'
      \.'%CActionView::TemplateError:\ compile\ error,'

" stack backtrace is in brackets. if multiple lines, it starts on a new line.
let s:my_errorformat=s:my_errorformat
      \.'%Ctest_%.%#(%.%#):%#,'
      \.'%C%.%#\ [%f:%l]:,'
      \.'%C\ \ \ \ [%f:%l:%.%#,'
      \.'%C\ \ \ \ %f:%l:%.%#,'
      \.'%C\ \ \ \ \ %f:%l:%.%#]:,'
      \.'%C\ \ \ \ \ %f:%l:%.%#,'

" catch all
let s:my_errorformat=s:my_errorformat
      \.'%Z%f:%l:\ %#%m,'
      \.'%Z%f:%l:,'
      \.'%C%m,'

" syntax errors in the test itself
let s:my_errorformat=s:my_errorformat
      \.'%.%#.rb:%\\d%\\+:in\ `load'."'".':\ %f:%l:\ syntax\ error\\\, %m,'
      \.'%.%#.rb:%\\d%\\+:in\ `load'."'".':\ %f:%l:\ %m,'

" and required files
let s:my_errorformat=s:my_errorformat
      \.'%.%#:in\ `require'."'".':in\ `require'."'".':\ %f:%l:\ syntax\ error\\\, %m,'
      \.'%.%#:in\ `require'."'".':in\ `require'."'".':\ %f:%l:\ %m,'

" exclusions
let s:my_errorformat=s:my_errorformat
      \.'%-G%.%#/lib/gems/%\\d.%\\d/gems/%.%#,'
      \.'%-G%.%#/lib/ruby/%\\d.%\\d/%.%#,'
      \.'%-G%.%#/vendor/rails/%.%#,'
      \.'%-G%.%#%\\d%\\d:%\\d%\\d:%\\d%\\d%.%#,'

" final catch all for one line errors
let s:my_errorformat=s:my_errorformat
      \.'%-G%\\s%#from\ %.%#,'
      \.'%f:%l:\ %#%m,'

let s:errorformat_backtrace='%D(in\ %f),'
      \.'%\\s%#from\ %f:%l:%m,'
      \.'%\\s%#from\ %f:%l:,'
      \.'%\\s#{RAILS_ROOT}/%f:%l:\ %#%m,'
      \.'%\\s%##\ %f:%l:%m,'
      \.'%\\s%##\ %f:%l,'
      \.'%\\s%#[%f:%l:\ %#%m,'
      \.'%\\s%#%f:%l:\ %#%m,'
      \.'%\\s%#%f:%l:,'
      \.'%m\ [%f:%l]:'

let s:errorformat_ruby='\%-E-e:%.%#,\%+E%f:%l:\ parse\ error,%W%f:%l:\ warning:\ %m,%E%f:%l:in\ %*[^:]:\ %m,%E%f:%l:\ %m,%-C%\tfrom\ %f:%l:in\ %.%#,%-Z%\tfrom\ %f:%l,%-Z%p^'

let s:efm_backtrace='%D(in\ %f),'
      \.'%\\s%#from\ %f:%l:%m,'
      \.'%\\s%#from\ %f:%l:,'
      \.'%\\s#{RAILS_ROOT}/%f:%l:\ %#%m,'
      \.'%\\s%##\ %f:%l:%m,'
      \.'%\\s%##\ %f:%l,'
      \.'%\\s%#[%f:%l:\ %#%m,'
      \.'%\\s%#%f:%l:\ %#%m,'
      \.'%\\s%#%f:%l:,'
      \.'%m\ [%f:%l]:'

let &cpo = s:save_cpo
