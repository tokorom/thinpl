# thinpl plugin manager for Vim 8

thinpl is a simple and thin plugin manager for Vim 8

## Required

- Vim 8
    - +packages
    - +job

## Installation

```sh
mkdir -p ~/.vim/pack/thinpl/start
git clone https://github.com/tokorom/thinpl ~/.vim/pack/thinpl/start/thimpl
vim ~/.vim/plugins.vim
# and edit plugins.vim
```

## Simple usage

- `~/.vim/plugins.vim`

```vim
" add a plugin to ~/.vim/pack/thimpl/opt and packadd
call thinpl#add('w0ng/vim-hybrid')

" call this at the end!
call thinpl#setup_plugins()
```

## Many options

- `~/.vim/plugins.vim`

```vim
" use a local plugin
let plugin = thinpl#add('swift_vim')
let plugin.repository = ''
let plugin.local_location = '~/repos/apple/swift/utils/vim'

" this plugin loads when becomes specific filetypes
let plugin = thinpl#add('swift-dict.vim')
let plugin.filetype = ['swift']

" this plugin loads specific autocmds as a trigger
let plugin = thinpl#add('kana/vim-smartinput')
let plugin.autocmd = ["InsertEnter"]

" This plugin loads specific commands as a trigger
let plugin = thinpl#add('sjl/gundo.vim')
let plugin.command = ['Gundo*']

" This plugin loads specific functions as a trigger"
let plugin = thinpl#add('tokorom/foo')
let plugin.function = ['foo#*']

" Use prepare function
let plugin = thinpl#add('tokorom/bar')
function! plugin.prepare() abort
  let g:bar#base_dir = '~/bar'
endfunction

" Use will_load function
let plugin = thinpl#add('ale')
function! plugin.will_load() abort
  let g:ale_lint_on_save = 1
  let g:ale_lint_on_text_changed = 0
endfunction

" Use did_load function
let plugin = thinpl#add('airblade/vim-gitgutter')
let plugin.autocmd = ['BufWrite']
function! plugin.did_load() abort
  call gitgutter#all(1)
endfunction
```

### Sample plugins.vim

- [tokorom's plugins.vim](https://github.com/tokorom/dotfiles/blob/master/.vim/plugins.vim)

## Override plugin options

### Change plugins.vim

```vim
" this is default value
let g:thinpl#plugins_file = '~/.vim/plugins.vim'
```

### Change git clone location

```vim
" this is default value
let g:thinpl#git_clone_location = '~/thinpl/repos'
```

### Change pack location

```vim
" this is default value
let g:thinpl#packname = 'thinpl'
" ~/.vim/pack/thinpl/opt
```

## Limitations

- Do not support Windows
- Do not support Vim 7 or less
