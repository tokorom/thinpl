" autoload functions

" add a plugin
function! thinpl#add(name) abort
  let name = thinpl#util#parse_name(a:name)
  let repository = thinpl#util#parse_repository(a:name)

  let plugin = {}
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

" load a managed plugin
function! thinpl#load_plugin(plugin) abort
  let plugin = a:plugin
  if type(plugin) == type('')
    let plugin = get(g:thinpl#plugins_by_name, plugin, {})
  endif

  if has_key(plugin, 'will_load')
    call plugin.will_load()
  endif

  execute 'packadd ' . plugin.name

  if has_key(plugin, 'did_load')
    call plugin.did_load()
  endif
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
      call thinpl#load_plugin(plugin)
    else
      for filetype in filetypes
        let command = 'call thinpl#load_plugin("' . plugin.name . '")'
        execute 'autocmd FileType ' . filetype . ' ' . command
      endfor
    endif
  endfor
endfunction
