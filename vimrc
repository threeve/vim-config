
set nocp	" we use vim, not vi

" use incremental, highlighting, smart case-insensitive search
set incsearch
set ignorecase
set smartcase
set hlsearch " turn on search match highlighting...
nohl " ...but turn it off immediately, in case reloading.

" buffer control
set switchbuf=usetab


set ruler " show line/col position
set scrolloff=3 " show 3 lines of context when scrolling
set backspace=2 " backspace crosses newlines?
set whichwrap+=<>[]

syntax on
filetype on
filetype plugin on
filetype indent on
set hidden " allow hidden buffers, rather than closing

set wildchar=<TAB>
set wildmenu
set wildmode=longest:full,full " complete longest match, showing list, then cycle through full matches

set autoindent
set autoread " automatically reload files changed outside Vim
" set autowrite " automatically write files when doing things like :make

" use 4 space tabs and indents
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab " spaces be damned!
set smarttab " tabs to indent, spaces to align
set cmdheight=2
set laststatus=2
set showcmd
set statusline=[%l,%c\ %P%M]\ %f\ %r%h%w
set number

" key mappings
noremap <silent> <ESC> :nohl<CR><ESC>

autocmd BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)

" TagList customizations
let Tlist_Use_Right_Window=1
let Tlist_Enable_Fold_Column=1
let Tlist_Show_One_File=1
let Tlist_Compact_Format=1
set updatetime=1000

" set GUI options (font, color, etc)
" TODO move this to .gvimrc ?
set guioptions-=T " no toolbar
if has("gui_running")
	set guifont=Inconsolata:h12
	colorscheme wombat
endif

set co=135 " 135 columns by default
set lines=999 " as many lines as will fit.

