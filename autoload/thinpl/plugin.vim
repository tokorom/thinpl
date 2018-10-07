" plugin functions

function! thinpl#plugin#setup(plugin) abort
  let plugin = a:plugin

  let plugin.is_loaded = 0

  function! plugin.is_installed() abort
    return isdirectory(expand(self.pack_link_location))
  endfunction

  function! plugin.has_local_repository() abort
    if !isdirectory(expand(self.local_location))
      return 0
    endif

    return 1
  endfunction

  function! plugin.confirm_install() abort
    if !self.is_installed()
      let command = 'call thinpl#confirm_install("' . self.raw_name .'")'
      call thinpl#util#execute('augroup', 'thinpl')
      call thinpl#util#execute('autocmd', 'VimEnter', '*', command)
      call thinpl#util#execute('augroup', 'END')
      return
    endif

  endfunction

  function! plugin.load(...) abort
    if self.is_loaded
      return
    endif

    let success_message = get(a:, 1, '')

    if has_key(self, 'will_load')
      call self.will_load()
    endif

    call thinpl#util#execute('packadd', self.name)

    let self.is_loaded = 1

    if self.has_augroup()
      call self.remove_plugin_augroup()
    endif

    if has_key(self, 'did_load')
      call self.did_load()
    endif

    if !empty(success_message)
      echomsg success_message
    endif
  endfunction

  function! plugin.has_augroup() abort
    return !empty(self.filetype) ||
    \ !empty(self.autocmd) ||
    \ !empty(self.command) || 
    \ !empty(self.function)
  endfunction

  function! plugin.remove_plugin_augroup() abort
    call thinpl#util#execute('autocmd!', self.augroup_name)
  endfunction
endfunction
