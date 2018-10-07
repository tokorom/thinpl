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
  let plugin.filetype = [] " This plugin loads when becomes specific filetypes
  let plugin.autocmd = [] " This plugin loads specific autocmds as a trigger
  let plugin.command = [] " This plugin loads specific commands as a trigger
  let plugin.function = [] " This plugin loads specific functions as a trigger
  let plugin.augroup_name = 'thinpl_' . name

  " let plugin.prepare = function('foo')
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
    if has_key(plugin, 'prepare')
      call plugin.prepare()
    endif

    call plugin.confirm_install()

    let filetypes = get(plugin, 'filetype', [])
    if type(filetypes) == type('')
      let filetypes = [filetypes]
    endif

    let autocmds = get(plugin, 'autocmd', [])
    if type(autocmds) == type('')
      let autocmds = [autocmds]
    endif

    let commands = get(plugin, 'command', [])
    if type(commands) == type('')
      let commands = [commands]
    endif

    let functions = get(plugin, 'function', [])
    if type(functions) == type('')
      let functions = [functions]
    endif

    if empty(filetypes) && empty(autocmds) && empty(commands) && empty(functions)
      call plugin.load()
    else
      for filetype in filetypes
        let load_plugin = 'call thinpl#load_plugin("' . plugin.name . '")'
        call thinpl#util#execute('augroup', plugin.augroup_name)
        call thinpl#util#execute('autocmd', 'FileType', filetype, load_plugin)
        call thinpl#util#execute('augroup', 'END')
      endfor
      for autocmd in autocmds
        let load_plugin = 'call thinpl#load_plugin("' . plugin.name . '")'
        call thinpl#util#execute('augroup', plugin.augroup_name)
        call thinpl#util#execute('autocmd', autocmd, '*', load_plugin)
        call thinpl#util#execute('augroup', 'END')
      endfor
      for command in commands
        let load_plugin = 'call thinpl#load_plugin("' . plugin.name . '")'
        call thinpl#util#execute('augroup', plugin.augroup_name)
        call thinpl#util#execute('autocmd', 'CmdUndefined', command, load_plugin)
        call thinpl#util#execute('augroup', 'END')
      endfor
      for fmatch in functions
        let load_plugin = 'call thinpl#load_plugin("' . plugin.name . '")'
        call thinpl#util#execute('augroup', plugin.augroup_name)
        call thinpl#util#execute('autocmd', 'FuncUndefined', fmatch, load_plugin)
        call thinpl#util#execute('augroup', 'END')
      endfor
    endif
  endfor
endfunction

" load a plugin
function! thinpl#load_plugin(name, ...) abort
  let name = a:name
  let success_message = get(a:, 1, '')

  if !has_key(g:thinpl#plugins_by_name, name)
    echoerr name . ' is not found.'
    return
  endif

  let plugin = g:thinpl#plugins_by_name[name]
  call plugin.load(success_message)
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

" print loaded plugins
function! thinpl#print_loaded_plugins() abort
  let loaded_names = []
  for plugin in g:thinpl#plugins
    if plugin.is_loaded
      call add(loaded_names, plugin.name)
    endif
  endfor

  echo join(loaded_names, "\n")
endfunction
