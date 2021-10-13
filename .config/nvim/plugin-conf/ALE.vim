
" ALE (Asynchronous Lint Engine)
let g:ale_fixers = {
 \ 'javascript': ['eslint'],
 \ 'rust': ['analyzer'],
 \ }

let g:ale_fixers = { 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines'] }

let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'

nnoremap <C-LeftMouse> :ALEGoToDefinition<CR>

