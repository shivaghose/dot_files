" This uses vim-plug to manage plugins: https://github.com/junegunn/vim-plug

" Install YouCompleteMe automagically 
" source: https://github.com/junegunn/vim-plug#post-update-hooks
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer
  endif
endfunction

call plug#begin('~/.vim/plugged')
" Sensible vim defaults, little better than just nocompatible
Plug 'tpope/vim-sensible'

" The solarized colour scheme
Plug 'altercation/vim-colors-solarized'

" View uncommited changes in a repo
Plug 'tpope/vim-fugitive'

" YouCompleteMe for auto completion: remember to compile for C++ support
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }

" Auto surrounds text snippets with quotes and what-have-yous
Plug 'tpope/vim-surround'

" Comments code
Plug 'tomtom/tcomment_vim'

" Syntastic for linting and syntax-stuff
Plug 'scrooloose/syntastic'

" To insert lines before or after a line.
Plug 'tpope/vim-unimpaired'

" To handle automatic ctag genration 
Plug 'xolox/vim-easytags'

" Needed by vim-easytags 
Plug 'xolox/vim-misc'

" VIM-ROS for ROS features
Plug 'taketwo/vim-ros'

" Builds code behind the scenes
Plug 'tpope/vim-dispatch'

" Handles easier vim motions
Plug 'easymotion/vim-easymotion'

" Adds ack-compatibility for VIM
Plug 'mileszs/ack.vim'

" For XML editing. Use \c or \C 
Plug 'othree/xml.vim'

" Get the solarized theme
Plug 'altercation/vim-colors-solarized'

" Used to repeat plugin commands with:
Plug 'tpope/vim-repeat'

" Lightweight status bar at the bottom of the vim terminal
Plug 'itchyny/lightline.vim'

" FZF support in vim
Plug 'junegunn/fzf.vim'

" Runs python code checkers. Remember to run 
" sudo pip install frosted pycodestyle mccabe
" Plug 'andviro/flake8-vim'

" General purpose code formatter interface (uses external formatters)
Plug 'Chiel92/vim-autoformat'

" Add plugins to the runtime-path
call plug#end()


" Enable the solarized colour scheme
set background=dark
colorscheme solarized

" show line numbers
set number

" redraw only when we need to.
set lazyredraw          

" show a visual line under the cursor's current line 
set cursorline
hi CursorLine term=bold cterm=bold guibg=Gray20 

" enable all Python syntax highlighting features
let python_highlight_all = 1

" SEARCHING
" search as characters are entered
set incsearch

" Use smartcase sensitive search (ignores case unless capitalization is used)
set smartcase

" highlight matches
set hlsearch

" The Silver Searcher specific configs
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag over ack in ack.vim
  let g:ackprg = 'ag --nogroup --nocolor --column'

endif


" move vertically by visual line
nnoremap j gj
nnoremap k gk

filetype plugin indent on

" Syntastic settings:
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


" Move cursor by display lines when wrapping
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

" roslaunch xml syntax hilighting with inline yaml support
" From https://gist.github.com/jbohren/5964014
autocmd BufRead,BufNewFile *.launch setfiletype roslaunch

" Reselect visual block after indent/outdent indent visual
xnoremap < <gv
xnoremap > >gv

" You Complete Me improvements found on
" http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

let g:ycm_confirm_extra_conf = 1

" Disable default mappings
let g:EasyMotion_do_mapping = 0 
" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-s)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-s2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" Configure spell check to auto start 
set spell
" Change the highlight mode to underline
hi clear SpellBad
hi SpellBad cterm=underline

" Add a 81-character warning line
set colorcolumn=81
highlight ColorColumn ctermbg=235

" YouCompleteMe extra configuration options. 
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_always_populate_location_list = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_semantic_triggers = {
 \ 'c' : ['->', '.'],
 \   'cpp,objcpp' : ['->', '.', '::'],
 \   'roslaunch' : ['="', '$(', '/'],
 \   'rosmsg,rossrv,rosaction' : ['re!^', '/'],
\ }

" Open vim-links in an existing tab (if possible) or a new tab (otherwise)
set switchbuf+=usetab,newtab

" Tell vim-ros to use catkin-tools
let g:ros_build_system='catkin-tools'

" Git gutter settings
let g:gitgutter_sign_column_always = 1
let g:gitgutter_max_signs = 200

" FZF binding for fuzzy search.
set rtp+=~/.fzf

" Remap git-gutteri hunk traversal to more semantic keys i.e. ]h and [h
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

" Enable the use of a mouse
set mouse=a

" Use ctrl+k to invoke the auto-formatter
map <C-K> :Autoformat<CR>
imap <C-K> <c-o>:Autoformat<CR>

highlight LineNr ctermfg=grey

" Remove trailing white spaces from source code
autocmd FileType c,cpp,h,hpp,python autocmd BufWritePre <buffer> :%s/\s\+$//e

" Use the old regex engine for vim. The new one in 7.0 causes slow downs in
" Python. See https://bugs.archlinux.org/task/35616
set regexpengine=1

