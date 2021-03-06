scriptencoding utf-8

set nocp    " we use vim, not vi
set modelines=0 " practice safe vimming
set nomodeline

" use ~/.vim on Windows too.
"if has("win32")
    "let &runtimepath = substitute(&runtimepath,'\(\~\|jason\|jforeman\)/vimfiles\>','\1/.vim','g')
"endif
" adds .vim/bundle/* to runtimepath

"filetype off " to support pathogen loading ftdetect files, comes back on later
silent! call pathogen#runtime_append_all_bundles()
silent! call pathogen#helptags()

" put backups and swap files somewhere out of the way
set backupdir=~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.tmp,~/tmp,/var/tmp,/tmp
set swapfile " do want
set backup   " do want

" persist undo across launches, vim 7.3+
if has('persistent_undo')
    set undodir=~/.tmp,~/tmp,/var/tmp,/tmp
    set undofile
endif

set lazyredraw
set ttyfast

" use incremental, highlighting, smart case-insensitive search
set incsearch
set ignorecase smartcase
set hlsearch " turn ON search match highlighting...
nohl         " ...but turn it off immediately, in case reloading.

" buffer control
set switchbuf=usetab
set noequalalways

set ruler " show line/col position
set scrolloff=3 " show 3 lines of context when scrolling
set backspace=eol,start,indent " backspace crosses newlines?
set whichwrap+=<>[]
set display=lastline " show as much of the last line as possible
set showmatch
set matchtime=2
set timeout timeoutlen=3000 ttimeoutlen=100 " adjust map/key timeouts

set hidden " allow hidden buffers, rather than closing

set foldmethod=syntax
set foldlevelstart=99

set wildchar=<TAB>
set wildmenu
set wildmode=longest:full,full " complete longest match, showing list, then cycle through full matches
"set wildmode=longest,list,full
set wildignore=*.o,*.obj,*.bak,*.exe,*.so,*~,build/*,.DS_Store

set completeopt=longest,menu,preview " happy completion style
"set completeopt=menu,preview " happy completion style

set autoindent
set autoread " automatically reload files changed outside Vim
set autowrite " automatically write files when doing things like :make

" use 4 space tabs and indents
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab " tabs to indent, spaces to align
set cmdheight=2
set laststatus=2
set showcmd
set showfulltag
set shortmess+=ts

"""" Text Formatting
set formatoptions=q         " Format text with gq, but don't format as I type.
set formatoptions+=n        " gq recognizes numbered lists, and will try to
set formatoptions+=1        " break before, not after, a 1 letter word

set number
set numberwidth=4

set encoding=utf-8

set clipboard=unnamed

" nicer looking tabs and whitespace
if (&termencoding == "utf-8") || has("gui_running")
    if v:version >= 700
        set listchars=tab:»·,trail:·,extends:…,eol:¶
        "let &showbreak=nr2char(8618).'   '
        "let &showbreak='->  '
    else
        set listchars=tab:»·,trail:·,extends:…,eol:¶
    endif
endif
set cpoptions+=$

set vb t_vb=

let mapleader=","

" ack >> grep
if executable('ack')
    set grepprg=ack
    set grepformat=%f:%l:%m
endif

" key mappings
nnoremap <silent> <C-l> :nohl<CR>
nnoremap <silent> <F1> :YRShow<CR>
nnoremap <silent> <F2> :NERDTreeToggle<CR>
nnoremap <silent> <F6> :mak<CR>
nnoremap <silent> <C-F6> :mak clean<CR>
nnoremap <silent> <F12> :TlistToggle<CR>
map Y y$

" no Ex mode, reformat instead
map Q gq

" Ack mappings
nmap g/ :Ack! 
nmap g* :Ack! -w <C-R><C-W> 
nmap gn :cnext<cr>
nmap gp :cprev<cr>
nmap gq :ccl<cr>

" open help on bottom
cnoreabbrev h bot h

" Platform specific junk
if has("win32")
    set shellslash      " Use / instead of \
    set winaltkeys=no   " <ALT> is mappable
endif

" load matchit
runtime! macros/matchit.vim

let no_buffers_menu=1       " Disable gvim 'Buffers' menu
let surround_indent=1       " Automatically reindent text surround.vim actions

" OmniCppComplete
let OmniCpp_NamespaceSearch=2
let OmniCpp_SelectFirstItem=2
let OmniCpp_LocalSearchDecl=1
" no automatic popup.  Use <C-x><C-o> or <Tab>
let [ OmniCpp_MayCompleteDot, OmniCpp_MayCompleteArrow ] = [ 0, 0 ]
set tags=tags;~/

" TagList customizations
let Tlist_Use_Right_Window=1
let Tlist_Enable_Fold_Column=0
let Tlist_Show_One_File=1
let Tlist_Compact_Format=1
let Tlist_Process_File_Always=1
let Tlist_Exit_OnlyWindow=1
let Tlist_GainFocus_On_ToggleOpen=1
set updatetime=1000
au BufEnter __Tag_List__ :setlocal statusline=Tag\ List 

" yankring
let yankring_history_file='.yankring'
let yankring_paste_using_g=0 " disable gp map, we use it for something else

" vcscommand customization
let VCSCommandEnableBufferSetup=1

" NERD plugin config
let NERDShutUp=1 " no more f*cking 'unknown filetype' warnings!

" Dr Chip (Align, et al)
let DrChipTopLvlMenu="&Plugin."

" Syntax customizations
let is_posix=1
let c_gnu=1
let c_space_errors=1
let c_curly_error=0
let c_no_bracket_error=1
let objc_syntax_for_h=1
let filetype_m='objc'
set cinoptions=g1,h3,t0,(0,W4

let load_doxygen_syntax=1
let doxygen_enhanced_color=1
let doxygen_my_rendering=0

" enable filetype based indents and plugins, and turn on syntax highlighting
filetype plugin indent on
syntax on

" supertab config
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"

" auto-enable doxygen highlighting for Obj-C/C++ files.
au Syntax objc,objcpp
        \ if (exists('b:load_doxygen_syntax') && b:load_doxygen_syntax)
        \       || (exists('g:load_doxygen_syntax') && g:load_doxygen_syntax)
        \   | runtime! syntax/doxygen.vim
        \ | endif

" lookup modules in OCaml online documentation
au BufRead,BufNewFile *.ml set keywordprg=~/.vim/scripts/ocaml_doc.sh

" FuzzyFinder
let g:fuf_file_exclude = '\v\~$|\.(o|exe|dll|bak|sw[po])$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|^build($|[/\\])'
nnoremap <silent> <Leader>fw :FufBuffer<CR>
nnoremap <silent> <Leader>fj :FufFile<CR>
nnoremap <silent> <Leader>fd :FufDir<CR>
nnoremap <silent> <Leader>ft :FufTag<CR>
nnoremap <silent> <Leader>fq :FufQuickfix<CR>

" snippetsEmu
let snippetsEmu_key="<C-L>"
let snippetsEmu_menu = "&Plugin."

" speeddating
let speeddating_no_mappings=1
nmap  <C-Up>    <Plug>SpeedDatingUp
nmap  <C-Down>  <Plug>SpeedDatingDown
xmap  <C-Up>    <Plug>SpeedDatingUp
xmap  <C-Down>  <Plug>SpeedDatingDown
nmap d<C-Up>    <Plug>SpeedDatingNowUTC
nmap d<C-Down>  <Plug>SpeedDatingNowLocal

" CommandT
let g:CommandTMaxHeight=10

" set GUI options (font, color, etc)
" TODO move this to .gvimrc ?
set guioptions=aAcegi
set showtabline=0
if has("gui_running")
    if has("win32")
        set guifont=Consolas:h10
    elseif has("mac")
        set guifont=Inconsolata:h11
    else
        set guifont=Consolas\ 12,Courier\ 12
        set linespace=1
    endif
    colorscheme wombat
    "colorscheme manuscript
    "colorscheme jf_black
    " better TODO highlighting.  The default bright-ass yellow bg is not fun.
    hi Todo guifg=#d9db56 guibg=NONE gui=bold
    " better search highlighting.  Less obnoxious than Yellow.
    hi Search guifg=Black guibg=#d9db56
    " Better Error highlighting than a red block...
    "hi Error guifg=red guibg=NONE gui=underline
endif

" maximize
if has("gui_running")
    if has("win32")
        au GUIEnter * simalt ~x
    elseif has("mac")
        let script='osascript -e "tell application \"MacVim\""'
                    \ . ' -e "set zoomed of first window to true"'
                    \ . ' -e "end tell"'
        au VIMEnter * call system(script)
    else
        set co=120 " 120 columns by default
        set lines=999 " as many lines as will fit.
    endif
endif

" A little bit (just a little) of Emacs style navigation.
" Hard to unlearn these, and they work in lots of apps
imap <silent> <C-a> <Home>
inoremap <silent> <C-e> <End>
inoremap <silent> <C-k> <C-o>D
nmap <silent> <C-a> <Home>
nnoremap <silent> <C-e> <End>
nnoremap <silent> <C-k> D
map j gj
map k gk

" hitting enter with completion open selects the completion and closes preview
" TODO do these really work like I think they do?
inoremap <silent> <expr> <CR> pumvisible() ? "\<C-Y>\<C-O>\<C-W>z" : "\<CR>"
inoremap <silent> <expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<S-Tab>"

" http://dotfiles.org/~caio/.vimrc
function! s:SmartHome()
    let ll = strpart(getline('.'), -1, col('.'))
    if ll =~ '^\s\+$' | normal! 0
    else              | normal! ^
    endif
endfunction
inoremap <silent> <HOME> <C-O>:call <SID>SmartHome()<CR>
nnoremap <silent> <HOME> :call <SID>SmartHome()<CR>

" function to regenerate all tag types (ctags, gtags, cscope) for cwd
function! s:RegenerateTags()
    let tags = []
    " use the ctags found by taglist if it exists
    if exists('g:Tlist_Ctags_Cmd')
        let ctags = g:Tlist_Ctags_Cmd
    else
        let ctags = 'ctags'
    endif
    if executable(ctags)
        call system(ctags . ' -R --c++-kinds=+p --fields=+iaS --extra=+q .')
        if (v:shell_error)
            echoerr "Error executing ctags"
        else
            call add(tags, ctags)
        endif
    endif

    if executable('gtags')
        call system('gtags')
        if (v:shell_error)
            echoerr "Error executing gtags"
        else
            call add(tags, 'gtags')
        endif
    endif

    if executable('cscope')
        " TODO
    endif

    echomsg "Tags generated: " . join(tags, ', ')
endfunction
com! -nargs=0 RegenerateTags call s:RegenerateTags()
nnoremap <silent> <C-F12> :RegenerateTags<CR>

" function to cycle through available line numbering modes [off, abs, rel]
function! s:CycleLineNumbers()
    if &nu
        if exists('+relativenumber')
            set rnu
        else
            set nonu
        endif
    elseif exists('+relativenumber') && &rnu
        set nornu
    else
        set nu
    endif
endfunction
com! -nargs=0 CycleLineNumbers call <SID>CycleLineNumbers()
nnoremap <silent> <F11> :CycleLineNumbers<CR>

" http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

" read host local vimrc if available
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

