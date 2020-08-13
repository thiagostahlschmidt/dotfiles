"require: curl, git and npm/node for coc
set autoindent
set belloff=all
set background=dark
set cindent
set clipboard=unnamed
set cmdheight=2
set colorcolumn=120
set complete+=kspell
set encoding=utf-8
set expandtab
set hidden
set ignorecase
set incsearch
set listchars=tab:→\ ,trail:␣,precedes:«,extends:»,eol:␤
set mouse=a
set nobackup
set nocompatible
set nohlsearch
set noshowmatch
set noswapfile
set nowrap
set nowritebackup
set nu
set path+=**
set relativenumber
set scrolloff=8
set shiftwidth=4
set shortmess+=c
set signcolumn=number
set smartcase
set smartindent
set spell
silent! set spelllang=en_us,pt_br
set tabstop=4 softtabstop=4
set updatetime=300
set viminfo+='1000,n~/.vim/viminfo
set wildignore+=**/.git/**
set wildmenu
set wildmode=list:full

syntax enable
filetype plugin on

if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " block in normal mode
    setlocal t_RB= t_RF= t_RV= t_u7=
endif

if has('termguicolors')
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !echo 'first run - this may take some time, please wait...'
  silent !mkdir -p ~/.vim/undodir
  silent !curl  --create-dirs -sfLo ~/.vim/spell/pt.utf-8.spl
    \ http://ftp.vim.org/pub/vim/runtime/spell/pt.utf-8.spl
  silent !curl  --create-dirs -sfLo ~/.vim/autoload/plug.vim
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
call plug#end()

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_right_alt_sep = '⮃'
let g:airline_branch_prefix = '⭠'
let g:airline_readonly_symbol = '⭤'
let g:airline_linecolumn_prefix = '⭡'

silent! colorscheme gruvbox

let g:loaded_matchparen = 1
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_liststyle = 3
let g:netrw_list_hide = netrw_gitignore#Hide()
let g:netrw_list_hide .= ',\(^\|\s\s\)\zs\.\S\+'

if executable('rg')
    let g:rg_derive_root='true'
endif

if has("persistent_undo")
    set undodir=~/.vim/undodir
    set undofile
endif

let g:undotree_SplitWidth=30
let g:undotree_SetFocusWhenToggle=1
let g:undotree_WindowLayout=2

let mapleader = " "
nnoremap <leader>n :set rnu! nu!<cr>:set rnu? nu?<cr>
nnoremap <leader>bd :bdel<cr>
nnoremap <leader>bn :bnext<cr>
nnoremap <leader>bo :BufferOnly<cr>
nnoremap <leader>bp :bprev<cr>
nnoremap <leader>1 :b1<cr>
nnoremap <leader>2 :b2<cr>
nnoremap <leader>3 :b3<cr>
nnoremap <leader>4 :b4<cr>
nnoremap <leader>5 :b5<cr>
nnoremap <leader>h :wincmd h<cr>
nnoremap <leader>j :wincmd j<cr>
nnoremap <leader>k :wincmd k<cr>
nnoremap <leader>l :wincmd l<cr>
nnoremap <leader>c :wincmd c<cr>
nnoremap <leader>o :wincmd o<cr>
nnoremap <leader>v :windo wincmd H<cr>
nnoremap <leader>u :UndotreeToggle<cr>
nnoremap <leader>fx :wincmd v<bar> :Ex <bar> :vertical resize 30<cr>
nnoremap <leader>gw :Rg <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>+ :vertical resize +5<cr>
nnoremap <leader>- :vertical resize -5<cr>
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv
noremap x "_x
vnoremap p "_dP
nnoremap p p=`]
inoremap <c-c> <esc>

if !exists('*Preserve')
    function! Preserve(command)
        try
            let l:win_view = winsaveview()
            let l:old_query = getreg('/')
            silent! execute 'keeppatterns keepjumps ' . a:command
         finally
            call winrestview(l:win_view)
            call setreg('/', l:old_query)
         endtry
    endfunction
endif

command! BufferOnly call Preserve("exec '%bd|e#|bd#'")
cab bo BufferOnly

nmap <leader>gb :Gedit HEAD<cr>
nmap <leader>gc :Gclog -- %<cr>
nmap <leader>gf :GFiles<cr>
nmap <leader>gh :diffget //2<cr>
nmap <leader>gj :cnext<cr>
nmap <leader>gk :cprev<cr>
nmap <leader>gl :diffget //3<cr>
nmap <leader>gs :Gstatus<cr>

fun! TouchBarMap()
   silent! !fish -ic __fish_apple_touchbar_vim_view
   if v:shell_error == 0
       autocmd VimLeave * silent! !fish -ic $caller_view
       map <f1> :qa!<cr>
       map <f2> :Buffers<cr>
       map <f3> :Files<cr>
       map <f4> :Rg<cr>
       map <f5> :Tags<cr>
       map <f6> :UndotreeToggle<cr>
   endif
endfun

let g:coc_start_at_startup = 0
let g:coc_global_extensions = [
  \ 'coc-go',
  \ 'coc-java',
  \ 'coc-json',
  \ 'coc-sh',
  \ 'coc-yaml'
  \ ]

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! s:coc_start() abort
    let g:coc_user_config = {}
    if empty(glob('~/.vim/lombok.jar'))
       silent !curl -sfLo ~/.vim/lombok.jar https://projectlombok.org/downloads/lombok.jar
    endif
    let g:coc_user_config['coc.preferences.jumpCommand'] = 'drop'
    let g:coc_user_config['diagnostic.checkCurrentLine'] = "true"
    let g:coc_user_config['java.jdt.ls.vmargs'] = "-javaagent:".$HOME."/.vim/lombok.jar -Xbootclasspath/a:".$HOME."/.vim/lombok.jar"
    let g:coc_user_config['languageserver'] = {
      \  "golang": {
      \    "command": "gopls",
      \    "rootPatterns": ["go.mod"],
      \    "filetypes": ["go"]
      \  }
      \}
    let g:coc_user_config['yaml.schemas'] = { "kubernetes": "/*.yaml" }
    CocStart
endfunction

nmap <leader>ca <Plug>(coc-codeaction)
nmap <leader>cd <Plug>(coc-definition)
nmap <leader>cf <Plug>(coc-fix-current)
nmap <leader>cy <Plug>(coc-type-definition)
nmap <leader>ci <Plug>(coc-implementation)
nmap <leader>cr <Plug>(coc-references)
nmap <leader>cn <Plug>(coc-rename)
nmap <leader>c[ <Plug>(coc-diagnostic-prev)
nmap <leader>c] <Plug>(coc-diagnostic-next)

inoremap <silent><expr> <c-space> coc#refresh()
nnoremap <silent> K :call <SID>show_documentation()<CR>
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

command! -nargs=0 Ff :call CocAction('format')
command! -nargs=0 Oi :call CocAction('runCommand', 'editor.action.organizeImport')

autocmd BufRead,BufNewFile *.tpl setlocal ts=2 sts=2 sw=2 expandtab
autocmd BufWritePre * call Preserve(":%s/\\s\\+$//e")
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd VimEnter * :call TouchBarMap()
autocmd VimEnter * call s:coc_start()
