call plug#begin('~/.vim/plugged')
    Plug 'preservim/nerdtree'
    Plug 'EdenEast/nightfox.nvim'
    Plug 'vim-airline/vim-airline'
call plug#end()

" -------------------------------------------
" Mode N
" -------------------------------------------

nnoremap <silent> <C-n> :NERDTreeToggle<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" -------------------------------------------
" vim config
" -------------------------------------------

colorscheme nightfox

" 줄 번호
set number
" 상단 탭 라인
set showtabline=2
" 탭 정지
set tabstop=4
" 쉬프트 (<< or >>) 이동거리
set shiftwidth=4
" vim 과 os 의 클립보드 동기화
set clipboard=unnamedplus
" use space characters instaed of tabs
set expandtab

if has("syntax")
    syntax on
endif
