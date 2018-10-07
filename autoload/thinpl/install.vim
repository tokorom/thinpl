" install functions

function! thinpl#install#run(plugin) abort
  let plugin = a:plugin
  let repository = plugin.repository

  if !empty(plugin.repository) && !plugin.has_local_repository()
    let repos_location = expand(g:thinpl#git_clone_location)
    if !isdirectory(repos_location)
      mkdir(repos_location)
    endif

    call thinpl#install#clone_and_link(plugin)
    return
  else
    call thinpl#install#link(plugin)
  endif
endfunction

function! thinpl#install#clone_and_link(plugin) abort
  let plugin = a:plugin
  let command = thinpl#git#clone_command(plugin)

  echom join(command, ' ')

  let callback = {'plugin': plugin}
  function! callback.output(ch, msg) abort
    echom a:msg
  endfunction
  function! callback.exit(job, exit_status) abort
    let status = a:exit_status
    if status != 0
      return
    endif
    call thinpl#install#link(self.plugin)
  endfunction

  call job_start(command, {
  \ 'callback': callback.output,
  \ 'exit_cb': callback.exit,
  \ })
endfunction

function! thinpl#install#link(plugin) abort
  let plugin = a:plugin

  let opt_dir = expand(thinpl#util#vim_pack_opt_dir())
  if !isdirectory(opt_dir)
    mkdir(opt_dir)
  endif

  let local_location = expand(plugin.local_location)
  if !isdirectory(local_location)
    echoerr local_location . ' is not found.'
    return
  endif

  let pack_link_location = expand(plugin.pack_link_location)

  let command = ['command', 'ln', '-s', local_location, pack_link_location]

  echom join(command, ' ')

  let callback = {'plugin': plugin}
  function! callback.output(ch, msg) abort
    echom a:msg
  endfunction
  function! callback.exit(job, exit_status) abort
    let status = a:exit_status
    if status != 0
      return
    endif
    echom 'successfully installed: ' . self.plugin.name
  endfunction

  call job_start(command, {
  \ 'callback': callback.output,
  \ 'exit_cb': callback.exit,
  \ })
endfunction
