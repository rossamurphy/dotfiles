syntax on
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set number relativenumber
:imap jj <Esc>
map J }
map K {
" nnoremap <c-j> }
" nnoremap <c-k> {
" shift Y to yank to Mac OS Clipboard
map Y "*y


" install plug-in manager if you don't have it "
if empty(glob('~/.vim/autoload/plug.vim'))
   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
 endif


let mapleader = " "

" ctrl-A to select all
nnoremap <C-A> ggVG

" tab to dent and de-dent like in Pycharm
nnoremap <TAB> >>
nnoremap <S-TAB> <<
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv
inoremap <S-Tab> <C-d>

" execute a line just like in pycharm
" if no line is selected, it will execute one line
" if numerous lines are selected, say you did
" ctrl-A for example, it will run the whole thing
noremap <leader>e :SlimeSend<cr>

" easy way to reload init.vim
nnoremap <leader>sv :source $MYVIMRC<CR>


call plug#begin('~/.local/share/nvim/plugged')
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'davidhalter/jedi-vim'
Plug 'morhetz/gruvbox'
"Plug 'jiangmiao/auto-pairs'
Plug 'mbbill/undotree'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
" Plug 'jpalardy/vim-slime'
Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }
call plug#end()



" map the shortcut to comment out code
noremap <leader>/ :Commentary<CR>

colorscheme gruvbox
let g:gruvbox_contrast_dark='soft'
set background=dark
if executable('rg')
    let g:rg_derive_root='true'
endif

"Autocompletion
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif "close preview"
"tab completion
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" disable autocompletion, because we use deoplete for completion
let g:jedi#completions_enabled = 0
let g:jedi#goto_definitions_command = "<leader>b"
let g:jedi#documentation_command = "<leader>d"
" if you don't want the docstring to pop up when
" autocompleting using jedi and deoplete
" autocmd FileType python setlocal completeopt-=preview


" Terminal Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction


"------------------------------------------------------------------------------
" ipython-cell configuration section
"------------------------------------------------------------------------------

" this will execute the cell you are in ONLY, but it will also send the whole thing
" to the REPL. so you will see all the code
nmap <leader>f <Plug>SlimeSendCell

" if you don't want to see the code, but you just want to execute the cell,
" then just do this below.
" map <Leader>c to execute the current cell
nnoremap <leader>c :IPythonCellExecuteCell<CR>

" I don't think this works with jedi
" map <Leader>s to start IPython
" nnoremap <leader>s :SlimeSend1 ipython --matplotlib<CR>
" the documentation wants you to use ipython
" but for some reason, it seems that if you run ipython in a venv that does not have
" ipython, it will just switch the venv and use a venv that does have ipython
" weird... so, in my .zshrc I have mapped ipy to only load an ipython
" that exists in the venv (as, I'd prefer to be made aware that I need to
" pip install ipython, rather than have my venv switch unbeknownst to me)
nnoremap <leader>1 :SlimeSend1 ipy --matplotlib<CR>

" this causes some issues because it triggers replace for me if I use r
" so I switch to number 2. So you can do leader 1, and then leader 2. Nice.
" map <Leader>r to run script
nnoremap <leader>2 :IPythonCellRun<CR>

" this is a handy way of running everything. it also times it.
" you can of course just do ctrl-A and then leader e though 
" ctrl-A selects all, and leader e will execute the selection
" map <Leader>R to run script and time the execution
" I change the capital R to be a 3, so it keeps with the above sort of
" sequence idea.
nnoremap <leader>3 :IPythonCellRunTime<CR>


" this does what it says on the tin
" map <Leader>C to execute the current cell and jump to the next cell
nnoremap <leader>C :IPythonCellExecuteCellJump<CR>

" this doesn't work for me because I use leader and the directions to jump
" between vim screens
" map <Leader>l to clear IPython screen
" nnoremap <Leader>l :IPythonCellClear<CR>

" map <Leader>x to close all Matplotlib figure windows
nnoremap <leader>x :IPythonCellClose<CR>

" this is very handy even if only for purely navigation purposes!
" map [c and ]c to jump to the previous and next cell header
nnoremap [c :IPythonCellPrevCell<CR>
nnoremap ]c :IPythonCellNextCell<CR>

" I use leader e to execute lines and selections
" nmap <Leader>c <Plug>SlimeLineSend
" xmap <Leader>h <Plug>SlimeRegionSend

" map <Leader>p to run the previous command
nnoremap <leader>p :IPythonCellPrevCommand<CR>

" map <Leader>Q to restart ipython
nnoremap <leader>Q :IPythonCellRestart<CR>

" I don't use the below because I have leader D
" mapped to finding the documentation using Jedi and Deoplete
" map <Leader>d to start debug mode
" nnoremap <leader>d :SlimeSend1 %debug<CR>
nnoremap <leader>9 :SlimeSend1 %debug<CR>

" map <Leader>q to exit debug mode or IPython
nnoremap <leader>q :SlimeSend1 exit<CR>

" nmap <leader>6 :IPythonCellInsertAbove<CR>a
nmap <leader>5 I# %% jj 
" nmap <leader>7 :IPythonCellInsertBelow<CR>a


" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"
let g:jedi#rename =""


nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
noremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeToggle<CR>

nnoremap <leader>m :NERDTreeToggle <CR>
nnoremap <leader>u :UndotreeShow<CR>l
let g:vimtex_fold_enabled = 1
"------------------------------------------------------------------------------
" slime configuration
"------------------------------------------------------------------------------
" always use tmux
let g:slime_target = 'tmux'

" fix paste issues in ipython
let g:slime_python_ipython = 1

" always send text to the top-right pane in the current tmux tab without asking
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': '{top-right}' }
let g:slime_dont_ask_default = 1

let g:slime_cell_delimiter = "# %%"
let g:ipython_cell_delimit_cells_by = 'tags'
let g:ipython_cell_tag = ["# %%"]


" function SlimeOverrideConfig(key,mapped)
"   let b:slime_config[key] = input(key,mapped)
" endfunction




