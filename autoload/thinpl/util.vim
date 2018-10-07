" utilities

function! thinpl#util#parse_name(name) abort
  let name = a:name
  let fname = fnamemodify(name, ':t')
  let adjusted = substitute(fname, '\.git$', '', '')
  return adjusted
endfunction

function! thinpl#util#parse_repository(name) abort
  let name = a:name
  if match(name, '\.git$') > -1
    return name
  endif
  if match(name, '/') > -1
    return 'https://github.com/' . name . '.git'
  endif
  return ''
endfunction

function! thinpl#util#local_location(plugin) abort
  let name = a:plugin.name
  let git_clone_location = get(g:, 'thinpl#git_clone_location', '~/thinpl/repos')
  return git_clone_location . '/' . name
endfunction

function! thinpl#util#pack_link_location(plugin) abort
  let name = a:plugin.name
  let packname = get(g:, 'thinpl#packname', 'thinpl')
  return thinpl#util#vim_pack_opt_dir() . '/' . name
endfunction

function! thinpl#util#vim_home_dir() abort
  return '~/.vim'
endfunction

function! thinpl#util#vim_pack_opt_dir() abort
  let packname = get(g:, 'thinpl#packname', 'thinpl')
  return thinpl#util#vim_home_dir() . '/pack/' . packname . '/opt'
endfunction

function! thinpl#util#vim_pack_start_dir() abort
  return thinpl#util#vim_home_dir() . '/pack/' . packname . '/start'
endfunction

function! thinpl#util#execute(...) abort
  let command = join(a:000, ' ')
  execute command
endfunction
