" git utilities

function! thinpl#git#clone_command(plugin) abort
  let plugin = a:plugin
  let repository = plugin.repository
  let local_location = expand(plugin.local_location)

  return ['command', 'git', 'clone', repository, local_location]
endfunction
