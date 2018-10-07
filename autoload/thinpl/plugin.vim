" plugin functions

function! thinpl#plugin#setup(plugin) abort
  let plugin = a:plugin

  function! plugin.is_installed() abort
    return isdirectory(expand(self.pack_link_location))
  endfunction

  function! plugin.has_local_repository() abort
    if !isdirectory(expand(self.local_location))
      return 0
    endif

    return 1
  endfunction

  function! plugin.load() abort
    if !self.is_installed()
      let command = 'autocmd VimEnter * call thinpl#confirm_install("' . self.raw_name .'")'
      execute command
      return
    endif

    if has_key(self, 'will_load')
      call self.will_load()
    endif

    execute 'packadd ' . self.name

    if has_key(self, 'did_load')
      call self.did_load()
    endif
  endfunction
endfunction