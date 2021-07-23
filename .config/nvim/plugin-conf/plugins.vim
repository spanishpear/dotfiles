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


nnoremap <A-Up> :m-2<CR>
nnoremap <A-Down> :m+<CR>

augroup filetype_jsx
  autocmd!
  autocmd FileType javascript set filetype=javascriptreact
augroup END

