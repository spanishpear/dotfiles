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


" set line numbers to be on
set number

" vimwiki wants this 
set nocompatible
filetype plugin on
syntax on

" tabwidth for spaces
set tabstop=2
set shiftwidth=2
set expandtab
set updatetime=100
" set mouse to be on
set mouse=a


