let s:save_cpo = &cpo
set cpo&vim

function! testee#case()
  let cases = s:test_cases_for_pattern(s:test_case_patterns['test'])
  if cases != 'false'
    let cases = substitute(cases, "'\\|\"", '.', 'g')
    let g:testee_config['last_exec'] = "%c -Itest %s -n /" . cases . "/"
    execute 'QuickRun -outputter buffer -runner vimproc -exec "' . g:testee_config['last_exec'] . '"'
  else
    echoerr 'No test cases found.'
  endif
endfunction

function! testee#file()
  let g:testee_config['last_exec'] = "%c -Itest %s"
  execute 'QuickRun -outputter buffer -runner vimproc -exec "' . g:testee_config['last_exec'] . '"'
endfunction

function! testee#last()
  execute 'QuickRun -outputter buffer -runner vimproc -exec "' . g:testee_config['last_exec'] . '"'
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


let &cpo = s:save_cpo
