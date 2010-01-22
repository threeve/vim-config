
" import base theme
runtime colors/ir_black.vim

let g:colors_name = "jf_black"


" Overrides and additions

" I like to see the nontext chars (showbreak)
hi NonText guifg=#3D3D3D guibg=black gui=NONE ctermfg=black ctermbg=NONE cterm=NONE
"hi Error guifg=#cccccc guibg=#500000 gui=none
hi Error guifg=#500000 guibg=NONE gui=underline

hi cSpaceError ctermbg=red guibg=#500000


hi link objcMethodName cBlock
