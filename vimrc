scriptencoding utf-8

set nocp    " we use vim, not vi

set noswapfile " do not want
set nobackup   " do not want

set lazyredraw

" use incremental, highlighting, smart case-insensitive search
set incsearch
set ignorecase
set smartcase
set noinfercase " better case handling for insert mode completion
set hlsearch " turn on search match highlighting...
nohl " ...but turn it off immediately, in case reloading.

" buffer control
set switchbuf=usetab

set ruler " show line/col position
set scrolloff=3 " show 3 lines of context when scrolling
set backspace=eol,start,indent " backspace crosses newlines?
set whichwrap+=<>[]

if has("syntax")
    syntax on
endif

filetype on
filetype plugin on
filetype indent on

set hidden " allow hidden buffers, rather than closing

set wildchar=<TAB>
set wildmenu
set wildmode=longest:full,full " complete longest match, showing list, then cycle through full matches

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

" Configure a nice status line
set statusline=
set statusline+=%2*%-3.3n%0*\                " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%1*%m%r%w%0*               " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%{VCSCommandGetStatusLine()} " show vcs status
set statusline+=%=                           " right align
set statusline+=%2*0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

set number

" nicer looking tabs and whitespace
if (&termencoding == "utf-8") || has("gui_running")
    if v:version >= 700
        set listchars=tab:»·,trail:·,extends:…,eol:¶
    else
        set listchars=tab:»·,trail:·,extends:…,eol:¶
    endif
endif


" key mappings
noremap <silent> <ESC> :nohl<CR><ESC>

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

" OmniCppComplete
let OmniCpp_NamespaceSearch=2
let OmniCpp_SelectFirstItem=2
let OmniCpp_LocalSearchDecl=1
set tags=tags;/

" TagList customizations
let Tlist_Use_Right_Window=1
let Tlist_Enable_Fold_Column=0
let Tlist_Show_One_File=1
let Tlist_Compact_Format=1
let Tlist_Process_File_Always=0
let Tlist_Exit_OnlyWindow=1
set updatetime=1000
au BufEnter __Tag_List__ :setlocal statusline=Tag\ List 

" vcscommand customization
let VCSCommandEnableBufferSetup=1

" NERD plugin config
let NERDShutUp=1 " no more f*cking 'unknown filetype' warnings!

" Dr Chip (Align, et al)
let DrChipTopLvlMenu="&Plugin."

" Syntax customizations
let c_gnu=1
let c_space_errors=1
let c_curly_error=1

" TODO enable doxygen syntax when fix color scheme
"let g:load_doxygen_syntax=1
let doxygen_enhanced_color=0
let doxygen_my_rendering=1

" FuzzyFinder
nnoremap <silent> <Leader>fw :FuzzyFinderBuffer<CR>
nnoremap <silent> <Leader>ff :FuzzyFinderFile<CR>

" snippetsEmu
let snippetsEmu_key="<C-L>"
let snippetsEmu_menu = "&Plugin."

" set GUI options (font, color, etc)
" TODO move this to .gvimrc ?
set guioptions-=T " no toolbar
if has("gui_running")
    if has("win32")
        set guifont=Consolas:h10
    elseif has("mac")
        set guifont=Inconsolata:h11
    else
        set guifont=Courier\ 12
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

" A little bit (just a little) of Emacs stylee navigation.
" Hard to un-learn these, and they work in lots of apps
inoremap <silent> <C-a> <C-o>0
inoremap <silent> <C-e> <C-o>$
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
    " use the ctags found by taglist if it exists
    if exists('g:Tlist_Ctags_Cmd')
        let ctags = g:Tlist_Ctags_Cmd
    else
        let ctags = 'ctags'
    endif
    if executable(ctags)
        " TODO
        echomsg "Executing ctags"
    endif

    if executable('gtags')
        echomsg "Executing gtags"
    endif

    if executable('cscope')
        echomsg "Executing cscope"
    endif
endfunction
com! -nargs=0 RegenerateTags call s:RegenerateTags()

" Regenerate help files
if has('win32')
    helptags ~/vimfiles/doc/
else
    helptags ~/.vim/doc/
endif

" read host local vimrc if available
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

