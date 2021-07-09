syntax on
set nocompatible              " be iMproved, required
filetype off                  " required


" set the runtime path to include Vundle and initialize
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set nosmartindent
set autoindent
set number relativenumber

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
noremap <leader>e :SlimeSend<CR> 

" easy way to reload init.vim
nnoremap <leader>sv :source $MYVIMRC<CR>

call plug#begin('~/.nvim/plugged')
" trying out not doing the below as using coc
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'zchee/deoplete-jedi'
" Plug 'davidhalter/jedi-vim'
Plug 'morhetz/gruvbox'
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build' }
"Plug 'jiangmiao/auto-pairs'
Plug 'mbbill/undotree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'christoomey/vim-tmux-navigator'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'jremmen/vim-ripgrep'
Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
if has('nvim')
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/denite.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
call plug#end()

" ***************
" make sure to *brew install ripgrep*
" ============================================================================ "
" ===                           DENITE PLUGIN SETUP                        === "
" ============================================================================ "

" Wrap in try/catch to avoid errors on initial install before plugin is available
try
" === Denite setup ==="
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Custom options for Denite
"   split                       - Use floating window for Denite
"   start_filter                - Start filtering on default
"   auto_resize                 - Auto resize the Denite window height automatically.
"   source_names                - Use short long names if multiple sources
"   prompt                      - Customize denite prompt
"   highlight_matched_char      - Matched characters highlight
"   highlight_matched_range     - matched range highlight
"   highlight_window_background - Change background group in floating window
"   highlight_filter_background - Change background group in floating filter window
"   winrow                      - Set Denite filter window to top
"   vertical_preview            - Open the preview window vertically

let s:denite_options = {'default' : {
\ 'split': 'floating',
\ 'start_filter': 1,
\ 'auto_resize': 1,
\ 'source_names': 'short',
\ 'prompt': 'λ ',
\ 'highlight_matched_char': 'QuickFixLine',
\ 'highlight_matched_range': 'Visual',
\ 'highlight_window_background': 'Special',
\ 'highlight_filter_background': 'DiffAdd',
\ 'winrow': 1,
\ 'vertical_preview': 1
\ }}


" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)
catch
  echo 'Denite not installed. It should work after running :PlugInstall'
endtry



" ============================================================================ "
" ===                           AIRLINE PLUGIN SETUP                       === "
" ============================================================================ "


" let g:airline_theme='dark'
let g:airline_theme='gruvbox'

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

colorscheme gruvbox
let g:gruvbox_contrast_dark='soft'
set background=dark
if executable('rg')
    let g:rg_derive_root='true'
endif



" ============================================================================ "
" ===                              AUTOCOMPLETION                        === "
"                                  CHOOSE ONE!
"                                  AND REMEMBER TO CHANGE
"                                  PLUGINS!
" ============================================================================ "


" CHOOSE THIS OR THE BELOW
"
" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif "close preview"
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
"
"Autocompletion
" let g:deoplete#enable_at_startup = 1
"tab completion
" disable autocompletion, because we use deoplete for completion
"
" let g:jedi#completions_enabled = 0
" let g:jedi#goto_definitions_command = "<leader>b"
" let g:jedi#documentation_command = "<leader>d"
" if you don't want the docstring to pop up when
" autocompleting using jedi and deoplete
" autocmd FileType python setlocal completeopt-=preview


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
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


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


" **************************
" === Denite shorcuts === "
" **************************
"   ;         - Browser currently open buffers
"   <leader>t - Browse list of files in current directory
"   <leader>g - Search current directory for occurences of given term and close window if no results
"   <leader>j - Search current directory for occurences of word under cursor
nmap ; :Denite buffer<CR>
nmap <leader>t :DeniteProjectDir file/rec<CR>
nnoremap <leader>k :<C-u>Denite grep:. -no-empty<CR>
nnoremap <leader>j :<C-u>DeniteCursorWord grep:.<CR>

" Define mappings while in 'filter' mode
"   <C-o>         - Switch to normal mode inside of search results
"   <Esc>         - Exit denite window in any mode
"   <CR>          - Open currently selected file in any mode
"   <C-t>         - Open currently selected file in a new tab
"   <C-v>         - Open currently selected file a vertical split
"   <C-h>         - Open currently selected file in a horizontal split
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o>
  \ <Plug>(denite_filter_update)
  inoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  inoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  inoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  inoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction

" Define mappings while in denite window
"   <CR>        - Opens currently selected file
"   q or <Esc>  - Quit Denite window
"   d           - Delete currenly selected file
"   p           - Preview currently selected file
"   <C-o> or i  - Switch to insert mode inside of filter prompt
"   <C-t>       - Open currently selected file in a new tab
"   <C-v>       - Open currently selected file a vertical split
"   <C-h>       - Open currently selected file in a horizontal split
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  " nnoremap <silent><buffer><expr> d
  " \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-o>
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction



