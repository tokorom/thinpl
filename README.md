# thinpl plugin manager for Vim 8

thinpl is a simple and thin plugin manager for Vim 8

## Required

- Vim 8
    - +packages
    - +job

## Installation

```sh
mkdir -p ~/.vim/pack/thinpl/start
git clone https://github.com/tokorom/thinpl ~/.vim/pack/thinpl/start/thinpl
vim ~/.vim/plugins.vim
# and edit plugins.vim
```

## Simple usage

- `~/.vim/plugins.vim`

```vim
" add a plugin to ~/.vim/pack/thinpl/opt and packadd
" 常に使うpluginならaddするだけ
call thinpl#add('w0ng/vim-hybrid')

" call this at the end!
" pluginを追加し終わったら最後にこれを呼ぶ
call thinpl#setup_plugins()
```

## Many options

- `~/.vim/plugins.vim`

```vim
" Use a local plugin
" リモートからcloneせずにローカルのものも使えます
let plugin = thinpl#add('swift_vim')
let plugin.repository = ''
let plugin.local_location = '~/repos/apple/swift/utils/vim'

" This plugin loads when becomes specific filetypes
" 特定のfiletypeのときだけpluginを読み込むこともできます
let plugin = thinpl#add('swift-dict.vim')
let plugin.filetype = ['swift']

" This plugin loads specific autocmds as a trigger
" autocmdをトリガーにpluginを読み込むこともできます
let plugin = thinpl#add('kana/vim-smartinput')
let plugin.autocmd = ["InsertEnter"]

" This plugin loads specific commands as a trigger
" 特定のcommandを実行しようとしたときに読み込むこともできます
let plugin = thinpl#add('sjl/gundo.vim')
let plugin.command = ['Gundo*']

" This plugin loads specific functions as a trigger"
" 特定のfunctionを呼ぼうとしたときに読み込ませることもできます
let plugin = thinpl#add('tokorom/foo')
let plugin.function = ['foo#*']

" Use prepare function
" prepare()を定義するとVim起動時にこれが呼ばれます
let plugin = thinpl#add('tokorom/bar')
function! plugin.prepare() abort
  let g:bar#base_dir = '~/bar'
endfunction

" Use will_load function
" will_load()を定義するとpluginが読み込まれる前に呼ばれます
let plugin = thinpl#add('ale')
function! plugin.will_load() abort
  let g:ale_lint_on_save = 1
  let g:ale_lint_on_text_changed = 0
endfunction

" Use did_load function
" did_load()を定義するとpluginが読み込まれた後に呼ばれます
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
