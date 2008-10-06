scriptencoding utf-8

set nocp    " we use vim, not vi

set noswapfile " do not want
set nobackup   " do not want

" use incremental, highlighting, smart case-insensitive search
set incsearch
set ignorecase
set smartcase
set infercase " better case handling for insert mode completion
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
    macmenukey File.Close
    no <silent> <D-w> :bd<cr>
    ino <silent> <D-w> <C-o>:bd<cr>
endif

autocmd BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)
" setup git commits to use the git syntax highlighting
autocmd BufNewFile,BufRead COMMIT_EDITMSG set filetype=gitcommit

" TagList customizations
let Tlist_Use_Right_Window=1
let Tlist_Enable_Fold_Column=1
let Tlist_Show_One_File=1
let Tlist_Compact_Format=1
let Tlist_Process_File_Always=0
set updatetime=1000

" vcscommand customization
let VCSCommandEnableBufferSetup=1

" NERD plugin config
let NERDShutUp=1 " no more f*cking 'unknown filetype' warnings!


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
    set co=120 " 120 columns by default
    set lines=999 " as many lines as will fit.
endif

" tags config
set tags=tags;/

" A little bit (just a little) of Emacs stylee navigation.
" Hard to un-learn these, and they work in lots of apps
inoremap <silent> <C-a> <C-o>0
inoremap <silent> <C-e> <C-o>$
inoremap <silent> <C-k> <C-o>D
nnoremap <silent> <C-a> 0
nnoremap <silent> <C-e> $
nnoremap <silent> <C-k> D

" read host local vimrc if available
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

