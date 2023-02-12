"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Doug's .vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" echomsg "Do printf-style debugging with echomsg, followed by :messages"
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
" :Helptags

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
" Syntastic
nnoremap <Leader>x :SyntasticCheck<CR>

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

syntax enable   " Enable syntax highlighting
" filetypes
filetype plugin on
filetype indent on
set number      " Show line numbers
set wildchar=<Tab> wildmenu wildmode=longest:full,full
set laststatus=2
" hi StatusLine cterm=bold ctermfg=Yellow ctermbg=DarkRed
" hi StatusLineNC cterm=bold ctermfg=Black ctermbg=DarkGray

set expandtab   " insert spaces instead of tabs
set softtabstop=2
set shiftwidth=2
set smarttab    " tab at the start of the line obeys indent, not tabstops
set tabstop=4
set showcmd
set guicursor=n-v-c:block-blinkon500-blinkoff500
hi Search cterm=bold ctermbg=Magenta
set ignorecase
set smartcase  " only do case sensitive if a capital is present
set incsearch
set hlsearch   " Highlight everything that matches a search
set history=50
set nowrap
set showmatch

set backspace=indent,eol,start  " What to backspace through..

set errorformat=%f:%l:%c\ %m

" These are unicode characters in hex for: https://unicodemap.org/range/2/Latin-1_Supplement/
" let indentLine_char="\u22ee"
let indentLine_char="|"
let g:indentLine_color_term = 233

" It is the indentLine package that shows us the fake tab vertical bars, even
" when indenting with spaces.
" https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg

" " Highlight certain unwelcome characters, such as tabs, trailing whitespace, etc
" You can run :digraph to see the options:
"   \xB7 (183) is a small dot in the center
"   \xBB (187) is a double right arrow character
"   \xA6 (166) is a vertical bar
"   \u22ee (8942) is triple vertical dots
"   \u02fd is a small square cup
" exec "set listchars=tab:\uBB\uB7,trail:\uB7,nbsp:\u02FD"
set listchars="tab:\uBB\uB7,trail:\uB7,nbsp:\u02FD"
highlight SpecialKey guifg=DarkGray ctermfg=235
highlight LineNr ctermfg=235
set list

"
" " Warn if we're going wider than 80 characters by highlighting when you go too far
" TODO We should set this up to toggle on/off when we hit <Leader>R or something
" like that
" highlight ColorColumn ctermbg=red
" call matchadd('ColorColumn', '\%81v', 100)

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
nnoremap ; :

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

"inoremap <C-o> <Esc>O

" If we're in "view" mode, then quit on just "q"
if v:progname ==? 'view'
  nnoremap q :q<CR>
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vimwiki
" Requires native fzf and ag:  brew install fzf ag  @ Not sure we need command
" line fzf; maybe just fzf.vim
let wiki_1 = {'path': '~/proj/zettelkasten', 'links_space_char': '-', 'path_html': '~/zk/', 'auto_generate_links': 1, 'auto_tags': 1, 'diary_rel_path': './', 'auto_diary_index': 1}

let g:vimwiki_list = [wiki_1]
let g:vimwiki_auto_header = 1
let g:zettel_format = "%y%m%d-%H%M-%title"
let g:zettel_options = [{"template": "~/proj/zettelkasten/00template.tpl"}]
" let g:zettel_fzf_command = "ag --column --line-number --ignore-case --no-heading --color=always"
" \ww - new wiki page
" \w\w - go to today's diary entry
" [[ - insert a link to a wiki page (zettel); it will help you search
" \wr - Rename wiki file you're in (but not Zettle %title)
" <S-CR> - horizontal split and follow link
" <C-CR> - vertical split and follow link
" <Tab> - find the next link in the current page
" @@@ TODO - should create a \zt - only search for titles (if available)
nnoremap <Leader>zn :ZettelNew<space>
augroup zettelstuff
  autocmd! 
  autocmd FileType vimwiki nnoremap <buffer> <silent> <Leader><space> :VimwikiToggleListItem<CR>
  autocmd FileType vimwiki nnoremap <buffer> <silent> <Leader>zo :ZettelOpen<CR>
  autocmd FileType vimwiki nnoremap <buffer> <silent> <Leader>zi :ZettelInbox<CR>
  autocmd FileType vimwiki nnoremap <buffer> <silent> <Leader>zb :ZettelBackLinks<CR>
  autocmd FileType vimwiki nnoremap <buffer> <silent> <Leader>zl :ZettelGenerateLinks<CR>
  autocmd FileType vimwiki nnoremap <buffer> <silent> <Leader>zt :VimwikiGenerateTagsLinks<space>
  nnoremap <Leader>zz :edit proj/zettelkasten/index.wiki<CR>
augroup END

" Possible future stuff
" map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" nnoremap <silent> _ :silent sp<CR>:exe "silent normal \<PlugVinegarUp"<CR>
" nnoremap <Leader><C-w>f :split %:h/<cfile><CR>
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OCaml support
if filereadable("/usr/local/bin/opam")
  let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
  execute "set rtp^=" . g:opamshare . "/merlin/vim"
  execute "set rtp^=" . g:opamshare . "/ocp-indent/vim"
  " Also run the following line in vim to index the documentation:
  "     :execute "helptags " . g:opamshare . "/merlin/vim/doc" 
  " ^X^O gives you pop-up context-sensitive completions
  " \t gives you the type of the selection
  " gd jumps to the definition of a function
  inoremap <C-X><C-T> <Esc>:MerlinTypeOf<CR>
  " Need to tell Syntastic to use the Merlin syntax
  let g:syntastic_ocaml_checkers = ['merlin']
  " Tips:  when inserting, type <C-X><C-O> to see type-aware completion list
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Abstract interpretation symbols
function Absint_keys()
    iab join@ <C-V>u2294
    iab meet@ <C-V>u2293
    iab le@ <C-V>u2291
    iab ge@ <C-V>u2292
    iab top@ <C-V>u22a4
    iab bot@ <C-V>u22a5
    iab rarrow@ <C-V>u2192
    iab larrow@ <C-V>u2190
    iab widen@ <C-V>u2207
    iab narrow@ <C-V>u2206
    iab empty@ <C-V>u2205
    iab element@ <C-V>u2208
    iab forall@ <C-V>u2200
    iab exists@ <C-V>u2203
    iab turn@ <C-V>u22a6
    echo "Installed abbreviations@ for absint symbols"
endfunction
nnoremap <Leader>@ :silent :call Absint_keys()<CR>

" This is an exmple of a modeline.  Requires modelines>0
set modeline
set modelines=3
" vim: tw=78:ts=2:nowrap
