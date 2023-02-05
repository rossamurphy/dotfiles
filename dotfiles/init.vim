syntax on
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set hidden
set noerrorbells
set tabstop=6 softtabstop=6
" need to set this to 6, or you will have a bad time with js
set shiftwidth=6
" setting the shiftwidth for MD files equal to 2,
" so that GitHub can understand nested bulleted lists.
autocmd BufRead,BufNewFile *.md set shiftwidth=2
autocmd BufRead,BufNewFile *.js set shiftwidth=6
autocmd BufRead,BufNewFile *.jsx set shiftwidth=6
autocmd BufRead,BufNewFile *.ts set shiftwidth=6
autocmd BufRead,BufNewFile *.tsx set shiftwidth=6

filetype indent on
set ai
set si
set expandtab
set nosmartindent
set autoindent
set number relativenumber
let g:loaded_matchit = 1


" Adding this to make IPythonCell commands work
" let g:python3_host_prog = '/Users/rossmurphy/.pyenv/shims/python'


" ***************************
" ***************************
" COC says add the below
" ***************************
" ***************************
"
" suggestion from a user
if has('nvim')
    autocmd User CocOpenFloat call nvim_win_set_config(g:coc_last_float_win, {'relative': 'editor', 'row': 0, 'col': 0})
    autocmd User CocOpenFloat call nvim_win_set_width(g:coc_last_float_win, 9999)
endif
" coc says add this as some servers have issues
" with backup files
set nobackup
set nowritebackup

" Give more space for displaying messages.
" set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

set shortmess+=c
"
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif


" ***************************
" ***************************
" end of COC section 
" ***************************
" ***************************


" Set floating window to be slightly transparent
" set winbl=10

:imap jj <Esc>
map J }
map K {

" Copy paste to Mac OS Clipboard
map Y "*y

" install plug-in manager if you don't have it "
if empty(glob('~/.vim/autoload/plug.vim'))
   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
 endif

let mapleader = " " 

" ctrl-P to select all
map <C-p> ggVG

" this below can be useful when starting out
" however, it messes up with some other stuff in vim
" like ctrl-i to go forward to where your cursor was, 
" after you have done ctrl-o
" once you get used to using << and >> in normal mode
" and ctrl-d and ctrl-t in insert mode, they are actually
" easier and better to use
" " tab to dent and de-dent like in Pycharm
" nnoremap <TAB> >>
" nnoremap <S-TAB> <<
" vnoremap <TAB> >gv
" vnoremap <S-TAB> <gv
" inoremap <S-Tab> <C-d>

" this, is actually a more minimalist helper for the tabbing
" elements of vim. This will allow you to select a paragraph 
" or block of code (vip for exmample), and then just continue tabbing it
" using the greater than or less than signs (because usually, without this,
" once you do one tab, it deselects the visual block, in which case you
" usually need to resort to using . or u to cycle through indentation levels).
" vnoremap > >gv
" vnoremap < <gv



" execute a line just like in pycharm
" if no line is selected, it will execute one line
" if numerous lines are selected, say you did
" ctrl-A for example, it will run the whole thing
" noremap <C-j> :SlimeSend<CR> 
noremap <leader>e :SlimeSend<CR> 

" easy way to reload init.vim
nnoremap <leader>sv :source $MYVIMRC<CR>

call plug#begin('~/.nvim/plugged')
" trying out not doing the below as using coc
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'zchee/deoplete-jedi'
" Plug 'davidhalter/jedi-vim'

" Themes
" Here we install both themes
" if you want to change theme, just do
" :colorscheme gruvbox, or, :colorscheme monokai
Plug 'morhetz/gruvbox'
Plug 'sainnhe/sonokai'
Plug 'olimorris/onedarkpro.nvim'
" Plug 'crusoexia/vim-monokai'

" JS and JSX
Plug 'pangloss/vim-javascript'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
" Plug 'sheerun/vim-polyglot'

"Plug 'jiangmiao/auto-pairs'
Plug 'tomlion/vim-solidity'
" new ... recommended linting by the enzyme team
Plug 'mbbill/undotree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'andymass/vim-matchup'
Plug 'github/copilot.vim'
"
" trying this out, not sure if will keep
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion'
Plug 'ambv/black'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
Plug 'christoomey/vim-tmux-navigator'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'jremmen/vim-ripgrep'
Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-c --enable-python'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rust-lang/rust.vim'
" adding nvim telescope on 26th december 2022
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }
" if you have issues with jedi language server, always make sure to first try pip installing jedi-language-server before proceeding
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'nvim-treesitter/playground'
call plug#end()


" ============================================================================ "
" ===                           EasyMotion PLUGIN SETUP                       === "
" ============================================================================ "

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" remarkably annoyingly, when you use easymotion, you basically add highlighted
" text to a buffer, and then that buffer itself messes up the linting that coc gives
" you. Which is demonstrably infuriating. I tried using vim-sneak, hop, vim-seek, and even
" coc's own version, but all of them are kind of jank. So, the 'work-around' for now is
" to just disable and then re-enable Coc every time you want to use easymotion.
" which, isn't really a work-around at all, but hopefully it gets fixed in the near future.
autocmd User EasyMotionPromptBegin silent! CocDisable
autocmd User EasyMotionPromptEnd silent! CocEnable

map  <Leader>w <Plug>(easymotion-bd-w)
nmap s <Plug>(easymotion-bd-f2)



" ============================================================================ "
" ===                           VIMSPECTOR PLUGIN SETUP                   === "
" ============================================================================ "
"
"
nnoremap <Leader>dd :call vimspector#Launch()<CR>
nnoremap <Leader>de :call vimspector#Reset()<CR>
nnoremap <Leader>dc :call vimspector#Continue()<CR>

nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>

nmap <Leader>dk <Plug>VimspectorRestart
nmap <Leader>dh <Plug>VimspectorStepOut
nmap <Leader>dl <Plug>VimspectorStepInto
nmap <Leader>dj <Plug>VimspectorStepOver



" ============================================================================ "
" ===                             TELESCOPE PLUGIN SETUP                   === "
" ============================================================================ "
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fd <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>t <cmd>lua require('telescope.builtin').find_files()<cr>


nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>l <cmd>lua require('telescope.builtin').live_grep()<cr>

nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>


" ============================================================================ "
" ===                           ONEDARK PLUGIN SETUP                       === "
" ============================================================================ "


colorscheme onedark_vivid


" ============================================================================ "
" ===                           AIRLINE PLUGIN SETUP                       === "
" ============================================================================ "


" let g:airline_theme='dark'
" let g:airline_theme='gruvbox'
" let g:airline_theme='sonokai'
let g:airline_theme='onedark'


let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts = 0
let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])


" ============================================================================ "
" ===                           VIM SURROUND HELP                       === "
" ============================================================================ "

" VIM surround helps you add, change, and remove surrounding of words and sentences
" cs"' on a word will change " surrounds for '
" ysiw] will wrap a word in []
" ysip] will wrap a paragraph in []
" yss' will wrap a sentence in '
" ysiw' will wrap a word in []
" ds' will delete ' around a word


" ============================================================================ "
" ===                           INDENT GUIDES HELP                       === "
" ============================================================================ "


" lines that help you see how indented parts of your code are
" set the lines to be on at start up. 
" you can toggle like so:
" :IndentGuidesEnable
" :IndentGuidesDisable
" :IndentGuidesToggle

" leader ig will toggle it on and off easily

let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_auto_colors = 0
let g:indent_guides_color_change_percent = 10
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_space_guides = 1
let g:indent_guides_tab_guides = 0
" change colours
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4


" ============================================================================ "
" ===                             VIM COMMENTER                       === "
" ============================================================================ "

" map the shortcut to comment out code
noremap <leader>/ :Commentary<CR>


" ============================================================================ "
" ===                              GRUVBOX THEME                       === "
" ============================================================================ "

 " colorscheme gruvbox
 " let g:gruvbox_contrast_dark='soft'
 " set background=dark
 " if executable('rg')
 "     let g:rg_derive_root='true'
 " endif




" '''*#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!
" <---------------------------------------------------------------------------->
" >
" > Sonokai theme https://github.com/sainnhe/sonokai
" >
" >----------------------------------------------------------------------------<
" *#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!*#*#*#!>'''

" if has('termguicolors')
"       set termguicolors
" endif
"   " The configuration options should be placed before `colorscheme sonokai`.
" let g:sonokai_style = 'andromeda'
" " let g:sonokai_style = 'atlantis'
" " let g:sonokai_style = 'default'
" let g:sonokai_better_performance = 1
" let g:sonokai_transparent_background = 0
" let g:sonokai_dim_inactive_windows = 0
" let g:sonokai_spell_foreground = 'colored' 


" function! s:sonokai_custom() abort
"       highlight! link groupA groupB
"       highlight! link groupC groupD
"       let l:palette = sonokai#get_palette('atlantis', {})
"       call sonokai#highlight('groupA', l:palette.red, l:palette.none, 'undercurl', l:palette.red)
" endfunction

" augroup SonokaiCustom
"       autocmd!
"       autocmd ColorScheme sonokai call s:sonokai_custom()
" augroup END


" colorscheme sonokai


" ============================================================================ "
" ===                              AUTOCOMPLETION                        === "
" ============================================================================ "

" CHOOSE THIS OR THE ABOVE

" === coc.nvim === "
"   <leader>dd    - Jump to definition of current symbol
"   <leader>dr    - Jump to references of current symbol
"   <leader>dj    - Jump to implementation of current symbol
"   <leader>ds    - Fuzzy search current project symbols
nmap <silent> <leader>b <Plug>(coc-definition)
nmap <silent> <leader>r <Plug>(coc-references)
" nmap <silent> <leader>b <Plug>(coc-implementation)

nnoremap <silent> <leader>ds :<C-u>CocList -I -N --top symbols<CR>

" tab autocompletes
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" enter autocompletes on the selection
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" navigating the autocompletion list
inoremap <expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
inoremap <expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"


" ******
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" *********

au ColorScheme * hi! link CocMenuSel PmenuSel
au ColorScheme * hi! link CocPumMenu Pmenu
au ColorScheme * hi! link CocPumVirtualText Comment
"
" show documentation
nnoremap <leader>d :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction


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


" ============================================================================ "
" ===                              TreeSitter                        === "
" ============================================================================ "
"



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
"
nnoremap <leader>1 :SlimeSend1 ipy --matplotlib<CR>
" nnoremap <leader>1 :SlimeSend1 ipy<CR>

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
nmap <leader>h i#jja 

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
" slime cell delineations
"
"
nmap <leader>5 I# %%jj 
" easy function docstring commenting
nmap <leader>6 2o'''jjO
" header for sections of code
nmap <leader>7 I'''jj11a*#*#*#!jjo<jj76a-jja>jj4o>jj76a-jja<jjojj11a*#*#*#!jja>'''jj3ka


" nmap <leader>7 :IPythonCellInsertBelow<CR>a


" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"
let g:jedi#rename =""

" don't really need these now that tmux vim is enabled
" nnoremap <leader>h :wincmd h<CR>
" nnoremap <leader>j :wincmd j<CR>
" nnoremap <leader>k :wincmd k<CR>
" noremap <leader>l :wincmd l<CR>
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

" alt keys for moving lines up and down
" note that this is only possible because I have remapped tmux
" to resize only on SHIFT ALT rather than just alt
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv





