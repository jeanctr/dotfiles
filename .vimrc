"  ▘  ▗
"  ▌▛▘▜▘▛▘ Jean Carlos (jctr)
"  ▌▙▖▐▖▌  https://github.com/jeanctr/
" ▙▌       https://jeanctr.me

set nocompatible
filetype off

" ---------- Plugins (vim-plug) ----------
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plug')
    " UI and Themes
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'joshdick/onedark.vim'

    " Essential Productivity
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'
    Plug 'jiangmiao/auto-pairs'
    Plug 'alvan/vim-closetag'

    " Navigation and Files
    Plug 'scrooloose/nerdtree'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'ryanoasis/vim-devicons'
    Plug 'airblade/vim-rooter'

    " Search
    Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
    Plug 'junegunn/fzf.vim'

    " Git and LSP
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'machakann/vim-highlightedyank'
    Plug 'wellle/targets.vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

filetype plugin indent on

" ---------- General ----------
set hidden
set encoding=utf-8
set mouse=a
set clipboard=unnamedplus
set noerrorbells visualbell t_vb=
set backspace=indent,eol,start
set wildmenu wildignore+=*/node_modules/*,*/.git/*,*/dist/*,*/build/*,*.o,*.pyc

let g:mapleader = "\<Space>"

" ---------- Persistent undo ----------
if !isdirectory($HOME . "/.vim/undodir")
    call mkdir($HOME . "/.vim/undodir", "p")
endif
set undofile
set undodir=~/.vim/undodir

" ---------- Search ----------
set incsearch hlsearch ignorecase smartcase
nnoremap <silent> <leader><space> :nohlsearch<CR>

" ---------- UI ----------
syntax enable
set termguicolors
set number relativenumber colorcolumn=81 cursorline
set scrolloff=8 sidescrolloff=8
set splitbelow splitright laststatus=2 showtabline=2 background=dark
set smartindent autoindent expandtab smarttab tabstop=4 shiftwidth=4
set formatoptions-=cro nowrap
set cmdheight=1 updatetime=300 shortmess+=c
set signcolumn=yes noshowmode

" ---------- Essential Mappings ----------
nnoremap <C-c> <Esc>
inoremap jk <Esc>
inoremap kj <Esc>

" Resize windows
nnoremap <M-j> :resize -2<CR>
nnoremap <M-k> :resize +2<CR>
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>

" Save/Quit
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
nnoremap <C-q> :wq!<CR>
nnoremap <C-b> :bd<CR>

" Move lines in visual mode
xnoremap K :move '<-2<CR>gv-gv
xnoremap J :move '>+1<CR>gv-gv

" Window and buffer navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>

" Comments
nnoremap <leader>/ :Commentary<CR>
vnoremap <leader>/ :Commentary<CR>

" ---------- Airline & Colors ----------
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'onedark'
colorscheme onedark

" ---------- coc.nvim -----------------
" Tab for autocompletion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction

inoremap <silent><expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Essential LSP mappings
nmap <silent> K :call <SID>show_documentation()<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)
nmap <silent> <leader>f <Plug>(coc-format-selected)
xmap <silent> <leader>f <Plug>(coc-format-selected)

function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
        execute 'h ' . expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Quick diagnostics
nnoremap <silent><nowait> <space>a :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>e :<C-u>CocList extensions<cr>

" ---------- FZF ----------------
let $FZF_DEFAULT_COMMAND = "rg --files --hidden"
let g:fzf_layout = {'down': '~40%'}
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>

" ---------- NERDTree ----------
nnoremap <leader>n :NERDTreeToggle<CR>
" Mejora visual de iconos en NERDTree
let g:NERDTreeDevIconsDefaultFolderOpenSymbol = ' '
let g:NERDTreeDevIconsDefaultFileSymbol = ' '

" ---------- Signify (Git Gutter) ----------
let g:signify_sign_add = '+'
let g:signify_sign_delete = '_'
let g:signify_sign_change = '~'
nmap <leader>gj <plug>(signify-next-hunk)
nmap <leader>gk <plug>(signify-prev-hunk)

" ---------- Closetag ----------
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.vue,*.jsx,*.tsx'
let g:closetag_filetypes = 'html,xhtml,phtml,javascript,javascriptreact,typescriptreact'

" ---------- Auto-format on save (coc.nvim) ----------
augroup CocFormatOnSave
    autocmd!
    autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx,*.json,*.html,*.css,*.py,*.vue CocCommand editor.action.formatDocument
augroup END
