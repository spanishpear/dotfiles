call plug#begin("~/.config/nvim/plugged")
  " Plugin Section
  " Plug 'pluginOwner/pluginNames'
  " pull from github repo
  
  " Color Schemes
  Plug 'dracula/vim', { 'as': 'dracula' }
  
  " FZF searching 
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  " File Explorer
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'kyazdani42/nvim-web-devicons' " for file icons  
  
  " Tab Bar
  Plug 'romgrk/barbar.nvim'

  " Git in side
  Plug 'airblade/vim-gitgutter'
  
  " Conquerer of Completion
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " auto pair brackets n stuff
  Plug 'jiangmiao/auto-pairs'

  " starter screen
  Plug 'mhinz/vim-startify'

  " statusline
  
  Plug 'itchyny/lightline.vim'
  " Lightline
  let g:lightline = {
    \     'colorscheme': 'powerlineish',
    \     'active': {
    \         'left': [['mode', 'paste' ], ['readonly', 'filename', 'modified']],
    \         'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding']]
    \     }
  \ }

  " For Git Commands 
  Plug 'tpope/vim-fugitive'

  " VimWiki
  Plug 'vimwiki/vimwiki'
  
  "Linting
  Plug 'w0rp/ale'
  
  " Plugin for Sytnax Highlighting
  Plug 'sheerun/vim-polyglot'
  
  " JSX
  Plug 'MaxMEllon/vim-jsx-pretty' 
  "coc plugins
  "coc-tsserver coc-eslint coc-json coc-prettier coc-css


  Plug 'maxmellon/vim-jsx-pretty'
  "LazyGit
  "Telescope
  "Fugitive
  "CocGit
  "WHICH TO USE WTF

call plug#end()
" Everything after this line will be the config section

source $HOME/.config/nvim/plugin-conf/ALE.vim
source $HOME/.config/nvim/plugin-conf/barbar.vim
source $HOME/.config/nvim/plugin-conf/coc.vim
source $HOME/.config/nvim/plugin-conf/fzf.vim
source $HOME/.config/nvim/plugin-conf/nvim-tree.vim
source $HOME/.config/nvim/plugin-conf/git-gutter.vim

source $HOME/.config/nvim/plugin-conf/startify.vim


nnoremap <A-Up> :m-2<CR>
nnoremap <A-Down> :m+<CR>

augroup filetype_jsx
  autocmd!
  autocmd FileType javascript set filetype=javascriptreact
augroup END

source 
