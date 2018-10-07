" global variables

let g:thinpl#plugins_file = get(g:, 'thinpl#plugins_file', '~/.vim/plugins.vim')

let g:thinpl#packname = get(g:, 'thinpl#packname', 'thinpl')
let g:thinpl#git_clone_location = get(g:, 'thinpl#git_clone_location', '~/thinpl/repos')

let g:thinpl#plugins = get(g:, 'thinpl#plugins', [])
let g:thinpl#plugins_by_name = get(g:, 'thinpl#plugins_by_name', {})

let plugins_file = expand(g:thinpl#plugins_file)
if filereadable(plugins_file)
  call thinpl#util#execute('source', plugins_file)
else
  echomsg plugins_file . ' is not found.'
endif
