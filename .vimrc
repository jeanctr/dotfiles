" Vimrc

let g:mapleader="\<Space>"
let g:maplocalleader="\<Space>"

set number relativenumber cursorline colorcolumn=80 showtabline=2 laststatus=2
set nocompatible expandtab tabstop=4 shiftwidth=4 smarttab autoindent smartindent wrap hidden clipboard=unnamedplus
set encoding=utf-8 fileencoding=utf-8 mouse=a splitbelow splitright background=dark
syntax enable
filetype plugin indent on
set termguicolors

" Keys
inoremap jk <Esc>
inoremap kj <Esc>
inoremap jj <Esc>
inoremap kk <Esc>
nnoremap <C-c> <Esc>
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>
nnoremap <M-j> :resize -2<CR>
nnoremap <M-k> :resize +2<CR>
nnoremap <C-s> :w<CR>
nnoremap <C-q> :wq!<CR>
nnoremap <C-b> :bd<CR>
vnoremap < <gv
vnoremap > >gv
xnoremap J :move '>+1<CR>gv-gv
xnoremap K :move '<-2<CR>gv-gv
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>p :Prettier<CR>
nnoremap <leader>/ :Commentary<CR>
vnoremap <leader>/ :Commentary<CR>
nnoremap <leader>e :CocCommand explor<CR>

" Plugins
call plug#begin('$HOME/.vim/plugged')
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/NERDTree'
Plug 'ryanoasis/vim-devicons'
Plug 'vimwiki/vimwiki'
Plug 'alvan/vim-closetag'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'prettier/vim-prettier', {'do':'npm install'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'mhinz/vim-signify'
Plug 'easymotion/vim-easymotion'
Plug 'mattn/emmet-vim'
call plug#end()

" Theme
colorscheme onedark
let g:airline_theme='onedark'
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
hi Comment cterm=italic
hi LineNr ctermbg=NONE guibg=NONE

" CoC
set hidden nobackup nowritebackup cmdheight=2 updatetime=300 shortmess+=c signcolumn=number
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nmap gd <Plug>(coc-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)
nnoremap K :call CocAction('doHover')<CR>
autocmd CursorHold * silent call CocActionAsync('highlight')
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
command! -nargs=0 Format :call CocAction('format')
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" FZF
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :Marks<CR>
let g:fzf_layout={'up':'~90%','window':{'width':0.8,'height':0.8,'yoffset':0.5,'xoffset':0.5,'border':'sharp'}}
let $FZF_DEFAULT_OPTS='--layout=reverse --info=inline'
let $FZF_DEFAULT_COMMAND='rg --files --hidden'

" Git
let g:signify_sign_add='+'
let g:signify_sign_delete='_'
let g:signify_sign_delete_first_line='‾'
let g:signify_sign_change='~'
let g:signify_sign_show_count=0
let g:signify_sign_show_text=1
nmap <leader>gj <plug>(signify-next-hunk)
nmap <leader>gk <plug>(signify-prev-hunk)

" Close tags
let g:closetag_filenames='*.html,*.xhtml,*.phtml,*.vue'
let g:closetag_filetypes='html,xhtml,phtml,javascript'
let g:closetag_xhtml_filetypes='xhtml,jsx'
let g:closetag_emptyTags_caseSensitive=1
let g:closetag_regions={'typescript.tsx':'jsxRegion,tsxRegion','javascript.jsx':'jsxRegion'}
let g:closetag_shortcut='>'
let g:closetag_close_shortcut='<leader>>'

