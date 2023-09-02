set number
set relativenumber

set backupcopy=yes

set background=dark
colorscheme PaperColor

nnoremap <SPACE> <Nop>
let mapleader=" "

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_winsize = 20

" Open Netrw on the directory of the current file
nnoremap <leader>dd :Lexplore %:p:h<CR>

" Toggle the Netrw window
nnoremap <Leader>da :Lexplore<CR>

" reload vimrc
nnoremap <Leader>vr :source $MYVIMRC<CR>
