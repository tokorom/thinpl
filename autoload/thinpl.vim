" autoload functions

" add a plugin
function! thinpl#add(name) abort
  let name = thinpl#util#parse_name(a:name)
  let repository = thinpl#util#parse_repository(a:name)

  let plugin = {}
  call thinpl#plugin#setup(plugin)
  let plugin.raw_name = a:name
  let plugin.name = name " plugin unique identifier
  let plugin.repository = repository " plugin repository
  let plugin.local_location = thinpl#util#local_location(plugin) " plugin local locaiton
  let plugin.pack_link_location = thinpl#util#pack_link_location(plugin) " plugin pack link location
  let plugin.filetype = [] " supported filetypes

  " let plugin.will_load = function('foo')
  " let plugin.did_load = function('foo')

  call add(g:thinpl#plugins, plugin)
  let g:thinpl#plugins_by_name[name] = plugin
  return plugin
endfunction

" setup added plugins
function! thinpl#setup_plugins(...) abort
  let plugins = get(a:, 1, g:thinpl#plugins)

  for plugin in plugins
    let filetypes = get(plugin, 'filetype', [])
    if type(filetypes) == type('')
      let filetypes = [filetypes]
    endif
    if empty(filetypes)
      call plugin.load()
    else
      for filetype in filetypes
        let command = 'call thinpl#load_plugin("' . plugin.name . '")'
        execute 'autocmd FileType ' . filetype . ' ' . command
      endfor
    endif
  endfor
endfunction

" load a plugin
function! thinpl#load_plugin(name) abort
  let name = a:name

  if !has_key(g:thinpl#plugins_by_name, name)
    echoerr name . ' is not found.'
    return
  endif

  let plugin = g:thinpl#plugins_by_name[name]
  call plugin.load()
endfunction

" install a plugin
function! thinpl#install(name) abort
  let name = a:name
  if has_key(g:thinpl#plugins_by_name, name)
    let plugin = g:thinpl#plugins_by_name[name]
  else
    let plugin = thinpl#add(name)
  endif
  call thinpl#install#run(plugin)
endfunction

" confirm whether to install
function! thinpl#confirm_install(name) abort
  let name = a:name

  let response = input(name . ' is not enabled. ' .
  \ 'Would you like to install this plugin now? [y/n] ')

  if (response == 'y') || (response == 'Y')
    call thinpl#install(name)
  endif
endfunction
