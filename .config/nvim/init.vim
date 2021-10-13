"loads the luafile
lua require('tree');
" Everything after this line will be the config section
source $HOME/.config/nvim/plugin-conf/plugins.vim
" setup the colour schemes
if (has("termguicolors"))
  set termguicolors
endif
set background=dark
colorscheme dracula
" try and make highlighted yank work
highlight HighlightedyankRegion cterm=reverse gui=reverse

" set line numbers to be on
set number

let mapleader = ","

" ,q will close the current buffer
nnoremap <leader>q :BufferClose!<Enter>


" vimwiki wants this 
set nocompatible
filetype plugin on
syntax on

" map esc + esc to exit terminal
tnoremap <C-Q> <C-\><C-N>


" tabwidth for spaces
set tabstop=2
set shiftwidth=2
set expandtab
set updatetime=100
set nowrap
set foldmethod=syntax
" set mouse to be on
set mouse=a

"keep terminals open?
set hidden

"set rust filetype
autocmd BufNewFile,BufRead *.rs set filetype=rust
