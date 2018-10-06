function! Test_util_parse_name() abort
  let input = 'https://github.com/foo/vim-bar.git'
  call assert_equal('vim-bar', thinpl#util#parse_name(input))

  let input = 'git@github.com:foo/vim-bar.git'
  call assert_equal('vim-bar', thinpl#util#parse_name(input))

  let input = 'foo/vim-bar'
  call assert_equal('vim-bar', thinpl#util#parse_name(input))

  let input = 'vim-bar'
  call assert_equal('vim-bar', thinpl#util#parse_name(input))
endfunction

function! Test_util_parse_repository() abort
  let input = 'https://github.com/foo/vim-bar.git'
  call assert_equal('https://github.com/foo/vim-bar.git', thinpl#util#parse_repository(input))

  let input = 'git@github.com:foo/vim-bar.git'
  call assert_equal('git@github.com:foo/vim-bar.git', thinpl#util#parse_repository(input))

  let input = 'foo/vim-bar'
  call assert_equal('https://github.com/foo/vim-bar.git', thinpl#util#parse_repository(input))

  let input = 'vim-bar'
  call assert_equal('', thinpl#util#parse_repository(input))
endfunction

function! Test_util_local_location() abort
  let g:thinpl#git_clone_location = '~/foo/repos'
  let input = {'name': 'vim-bar'}
  call assert_equal('~/foo/repos/vim-bar', thinpl#util#local_location(input))

  let g:thinpl#git_clone_location = '~/thinpl/repos'
  let input = {'name': 'vim-bar'}
  call assert_equal('~/thinpl/repos/vim-bar', thinpl#util#local_location(input))
endfunction

function! Test_util_pack_link_location() abort
  let g:thinpl#packname = 'foo'
  let input = {'name': 'vim-bar'}
  call assert_equal('~/.vim/pack/foo/opt/vim-bar', thinpl#util#pack_link_location(input))

  let g:thinpl#packname = 'thinpl'
  let input = {'name': 'vim-bar'}
  call assert_equal('~/.vim/pack/thinpl/opt/vim-bar', thinpl#util#pack_link_location(input))
endfunction

function! s:run_test() abort
  let v:errors = []

  call Test_util_parse_name()
  call Test_util_parse_repository()
  call Test_util_local_location()
  call Test_util_pack_link_location()

  if empty(v:errors)
    echo 'Test Passed!'
  else
    echo 'Test Failed!'
    for error in v:errors
      echo error
    endfor
  endif
endfunction

call s:run_test()
