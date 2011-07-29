
" override some of the MacVim menu bindings and keys
if has("gui_macvim")
    macmenu File.Close key=<nop>
    macmenu File.New\ Tab key=<nop>
    macmenu Tools.Make key=<nop>
    no <silent> <D-w> :bd<cr>
    ino <silent> <D-w> <C-o>:bd<cr>
    no <silent> <D-t> :CommandT<cr>
endif
