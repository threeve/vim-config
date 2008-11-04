scriptencoding utf-8

set nocp    " we use vim, not vi

" use ~/.vim on Windows too.
if has("win32")
    let &runtimepath = substitute(&runtimepath,'\(\~\|jason\|jforeman\)/vimfiles\>','\1/.vim','g')
endif
" adds .vim/bundle/* to runtimepath
silent! call pathogen#runtime_append_all_bundles()

set noswapfile " do not want
set nobackup   " do not want

set lazyredraw

" use incremental, highlighting, smart case-insensitive search
set incsearch
set ignorecase
set smartcase
set infercase " better case handling for insert mode completion
set hlsearch " turn on search match highlighting...
nohl " ...but turn it off immediately, in case reloading.

" buffer control
set switchbuf=usetab
set noequalalways

set ruler " show line/col position
set scrolloff=3 " show 3 lines of context when scrolling
set backspace=eol,start,indent " backspace crosses newlines?
set whichwrap+=<>[]
set display=lastline " show as much of the last line as possible

" enable filetype based indents and plugins, and turn on syntax highlighting
filetype plugin indent on
syntax on

set hidden " allow hidden buffers, rather than closing

set wildchar=<TAB>
set wildmenu
set wildmode=longest:full,full " complete longest match, showing list, then cycle through full matches
set wildignore=*.o,*.obj,*.bak,*.exe,*.so,*~

set completeopt=longest,menu,preview " happy completion style

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

" Configure a nice status line (based on jamessan's?)
set statusline=
set statusline+=%3.3n\                       " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%1*%m%r%w%0*               " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%{exists('loaded_VCSCommand')?VCSCommandGetStatusLine():''} " show vcs status
set statusline+=%=                           " right align
set statusline+=\[%{exists('loaded_taglist')?Tlist_Get_Tag_Prototype_By_Line(expand('%'),line('.')):'no\ tags'}]\   " show tag prototype
set statusline+=0x%-8B\                      " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

set number

set encoding=utf-8
" nicer looking tabs and whitespace
if (&termencoding == "utf-8") || has("gui_running")
    if v:version >= 700
        set listchars=tab:»·,trail:·,extends:…,eol:¶
    else
        set listchars=tab:»·,trail:·,extends:…,eol:¶
    endif
endif


" key mappings
nnoremap <silent> <C-[> :nohl<CR><C-[>
nnoremap <silent> <F6> :mak<CR>
nnoremap <silent> <C-F6> :mak clean<CR>
nnoremap <silent> <F2> :NERDTreeToggle<CR>
nnoremap <silent> <F12> :TlistToggle<CR>
map Y y$

" Platform specific junk
if has("win32")
    set shellslash      " Use / instead of \
    set winaltkeys=no   " <ALT> is mappable
endif
if has("gui_running") && has("gui_macvim")
    macmenu File.Close key=<nop>
    no <silent> <D-w> :bd<cr>
    ino <silent> <D-w> <C-o>:bd<cr>
endif

autocmd BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)
" setup git commits to use the git syntax highlighting
autocmd BufNewFile,BufRead COMMIT_EDITMSG set filetype=gitcommit

" load matchit
runtime! macros/matchit.vim

" OmniCppComplete
let OmniCpp_NamespaceSearch=2
let OmniCpp_SelectFirstItem=2
let OmniCpp_LocalSearchDecl=1
" no automatic popup.  Use <C-x><C-o> or <Tab> (See CleverTab function)
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

" vcscommand customization
let VCSCommandEnableBufferSetup=1

" NERD plugin config
let NERDShutUp=1 " no more f*cking 'unknown filetype' warnings!

" Dr Chip (Align, et al)
let DrChipTopLvlMenu="&Plugin."

" Syntax customizations
let g:is_posix=1
let g:c_gnu=0
let g:c_space_errors=0
let g:c_curly_error=0
set cinoptions=g1,h3,t0,(0,W4

" TODO enable doxygen syntax when fix color scheme
let g:load_doxygen_syntax=1
let g:doxygen_enhanced_color=0
let g:doxygen_my_rendering=1

" FuzzyFinder
nnoremap <silent> <Leader>fw :FuzzyFinderBuffer<CR>
nnoremap <silent> <Leader>ff :FuzzyFinderFile<CR>
nnoremap <silent> <Leader>fd :FuzzyFinderDir<CR>
nnoremap <silent> <Leader>fj :FuzzyFinderTextMate<CR>
nnoremap <silent> <Leader>ft :FuzzyFinderTag<CR>
nnoremap <silent> <Leader>fk :FuzzyFinderMruCmd<CR>
nnoremap <silent> <Leader>fm :FuzzyFinderMruFile<CR>

" snippetsEmu
let g:snippetsEmu_key="<C-L>"
let g:snippetsEmu_menu = "&Plugin."

" speeddating
let g:speeddating_no_mappings=1
nmap  <C-Up>    <Plug>SpeedDatingUp
nmap  <C-Down>  <Plug>SpeedDatingDown
xmap  <C-Up>    <Plug>SpeedDatingUp
xmap  <C-Down>  <Plug>SpeedDatingDown
nmap d<C-Up>    <Plug>SpeedDatingNowUTC
nmap d<C-Down>  <Plug>SpeedDatingNowLocal

" set GUI options (font, color, etc)
" TODO move this to .gvimrc ?
set guioptions=acegi
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
    " better TODO highlighting.  The default bright-ass yellow bg is not fun.
    hi Todo guifg=#d9db56 guibg=NONE gui=bold
    " better search highlighting.  Less obnoxious than Yellow.
    hi Search guifg=Black guibg=#d9db56
endif

" maximize
if has("gui_running")
    if has("win32")
        au GUIEnter * simalt ~x
    elseif has("mac")
        " TODO
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
nnoremap <silent> <C-a> 0
nnoremap <silent> <C-e> $
nnoremap <silent> <C-k> D

" http://vim.wikia.com/wiki/Smart_mapping_for_tab_completion
function! CleverTab()
  if pumvisible()
    return "\<C-N>"
  endif
  if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
    return "\<Tab>"
  elseif exists('&omnifunc') && &omnifunc != ''
    return "\<C-X>\<C-O>"
  else
    return "\<C-N>"
  endif
endfunction
inoremap <silent> <Tab> <C-R>=CleverTab()<CR>

" hitting enter with completion open selects the completion and closes preview
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

" Regenerate help files
helptags ~/.vim/doc/
for d in pathogen#glob_directories('~/.vim/bundle/**/doc')
    exec 'helptags ' . d
endfor

" read host local vimrc if available
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

