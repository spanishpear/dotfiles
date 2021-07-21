" ---------- FZF ------------
nnoremap <C-p> :GFiles<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --theme=Dracula --color=always --style=header,grid --line-range :300 {}'"
" Remove node_modules and files in .gitignor
let $FZF_DEFAULT_COMMAND = 'ag -g ""'
