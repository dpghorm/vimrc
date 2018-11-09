"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Doug's .vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
let mapleader="\\"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Profiling - how long things take to start up
" silent! profile start /tmp/vimprofile.out
" silent! profile! file *

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PathogenA - package manager
runtime bundle/vim-pathogen-master/autoload/pathogen.vim
exec pathogen#infect()

" Note that after adding a new plugin to our setup, just run
" the following (provided by Pathogen) to reindex the docs:
" :Helptabs

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Streamline the GUI
if has('gui_running')
        set guioptions-=m
        set guioptions-=T
        set guioptions-=r
        set guioptions-=R
        set guioptions-=l
        set guioptions-=L
        set guioptions-=b
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline - fancy mode lines
let g:airline#extensions#tabline#enabled = 1
if has ('gui_running')
else
        let g:airline#extensions#tabline#left_sep = ' '
        let g:airline#extensions#tabline#left_alt_sep = '|'
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP - fuzzy buffer/window/file switching
" :help ctrlp-commands ctrlp-extensions ctrlp-mappings ctrlp-options
" Once CtrlP is open, use the following:
"   .. to go up a level in the directory tree
"   <c-f> and <c-b> to cycle between modes
"   <c-d> to switch to filename only search instead of full path
"   <c-r> to switch to regexp mode
"   <c-j>, <c-k> or the arrow keys to navigate the result list
"   <c-t> or <c-v>, <c-x> to open the selected entry in a new tab or in a new split
"   <c-n>, <c-p> to select the next/previous string in the prompt's history
"   <c-y> to create a new file and its parent directories
"   <c-z> to mark/unmark multiple files and <c-o> to open them
nnoremap <Leader>b :<C-u>CtrlPBuffer<CR>
nnoremap <Leader>f :<C-u>CtrlP<CR>
nnoremap <Leader>t :<C-u>CtrlPTag<CR>
nnoremap <Leader>l :<C-u>CtrlPMRU<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vinegar - directory browser
" Bring it up with '-'
" 'I' turns on the information header with other commands

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CScope

set tags=./tags,tags
set cscopequickfix=s-,c-,d-,i-,t-,e-
set csverb
set cspc=3
silent! cs add cscope.out

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My settings

syntax enable
" filetypes
filetype plugin on
filetype indent on
set number
set wildchar=<Tab> wildmenu wildmode=longest:full,full
set laststatus=2
" hi StatusLine cterm=bold ctermfg=Yellow ctermbg=DarkRed
" hi StatusLineNC cterm=bold ctermfg=Black ctermbg=DarkGray

set expandtab
set softtabstop=4
set shiftwidth=4
set smarttab
set noautoindent
set cinw=
set cink=
" set tabstop=4
set showcmd
set guicursor=n-v-c:block-blinkon100-blinkoff100
hi Search cterm=bold ctermbg=Magenta
set ignorecase
set smartcase  " only do case sensitive if a capital is present
set incsearch
set hlsearch
set history=50
set nowrap
set showmatch

set backspace=indent,eol,start  " What to backspace through..

set errorformat=%f:%l:%c\ %m

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My functions

" Grep for the word under the cursor
set grepprg=grep\ -nr

function! Grep()
        execute "normal wb"
        execute "normal \"zyw"
        let s:ftype = expand("%:e")
        if s:ftype == "f" || s:ftype == "dat"
                " use case-sensitive search for Fortran
                execute ":grep! -wi " . @z . " *"
        else
                execute ":grep! -w ". @z . " *"
        endif
endfunction

" Search CScope database for symbol under the cursor
function! SymbolSearch()
        execute "normal wb"
        execute "normal \"zwb"
        execute ":cs find s " . @z
endfunction

" We can load more functions with: silent! source ~/scripts/comment.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto commands
augroup user
autocmd!
autocmd QuickFixCmdPost * copen
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My key mappings
" Available keys seem to be:  \ | ~ ` &
map Y y$
" Cancel search highlighting with \\
nnoremap <Leader>\ :noh<CR>:<backspace>
nnoremap <Leader>o <C-w>o
nnoremap <Leader>c <C-w>c
nnoremap <Leader>p "+gP
nnoremap <Leader><space> :%s/\s\+$//e<CR>

nnoremap <Leader>G :silent :call Grep()<CR>
nnoremap <Leader>g :grep -r
nnoremap <Leader>* :silent :call SymbolSearch()<CR>

nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprevious<CR>

inoremap <C-o> <Esc>O

" If we're in "view" mode, then quit on just "q"
if &readonly == 1
        map q :q<CR>
endif

" Possible future stuff
" map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" nnoremap <silent> _ :silent sp<CR>:exe "silent normal \<PlugVinegarUp"<CR>
" nnoremap <Leader><C-w>f :split %:h/<cfile><CR>
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OCaml support
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
" Also run the following line in vim to index the documentation:
"     :execute "helptags " . g:opamshare . "/merlin/vim/doc" 
" ^X^O gives you pop-up context-sensitive completions
nnoremap <Leader>T :MerlinTypeOf<CR>
inoremap <C-X><C-T> <Esc>:MerlinTypeOf<CR>
