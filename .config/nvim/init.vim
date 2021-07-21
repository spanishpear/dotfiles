"loads the luafile
luafile $HOME/.config/nvim/lua/init.lua
luafile $HOME/.config/nvim/lua/tree.lua
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

" tabwidth for spaces
set tabstop=2
set shiftwidth=2
set expandtab
set updatetime=100
" set mouse to be on
set mouse=a

source $HOME/.config/nvim/plugin-conf/nvim-tree.vim
"source $HOME/.config/nvim/plugin-conf/git-gutter.vim
source $HOME/.config/nvim/plugin-conf/fzf.vim

