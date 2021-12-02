call plug#begin()
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/syntastic'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'OmniSharp/omnisharp-vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'AndrewRadev/splitjoin.vim'
Plug 'fatih/molokai'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'thanthese/Tortoise-Typing'
Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-lion'
Plug 'wincent/terminus'
Plug 'tpope/vim-dadbod'
Plug 'junegunn/goyo.vim'
Plug 'dracula/vim'
call plug#end()

" Basic Settings -------------------------------------{{{
set nocompatible
set number
set shiftwidth=2
set softtabstop=2
set autoindent
set expandtab
set colorcolumn=121
set backspace=indent,eol,start
set laststatus=2          " Always show statusline
set statusline=%f         " Path to the file
set statusline+=%=        " Switch to the right side
set statusline+=%l        " Current line
set statusline+=/         " Separator
set statusline+=%L        " Total lines
set statusline+=\ -\      " Separator
set statusline+=%c
set foldlevelstart=0
set incsearch
set hlsearch

syntax on
filetype plugin indent on

" Temporary fix for bug in 8.2
set t_TI= t_TE=

" Hack for a problem I've encountered in xterm
nmap <c-u> <c-u><c-l>

augroup general
    autocmd!
    autocmd BufNewFile,BufRead *.proto setfiletype proto
augroup END

let g:local_db = 'postgresql://postgres:postgres@localhost:5432/web_db'
let g:test_db = 'postgresql://postgres:postgres@localhost:5432/test_web_db'

" }}}

" Basic Mappings ---------------------------------------------{{{
let mapleader = "\<space>"
let maplocalleader = "-"

noremap H 0
noremap L $

" Make window navigation easier by not using Control
nnoremap <TAB>j <c-w>j
nnoremap <TAB>h <c-w>h
nnoremap <TAB>k <c-w>k
nnoremap <TAB>l <c-w>l

" Fast navigation of quickfixes
nnoremap <leader>h :cp<cr>
nnoremap <leader>l :cn<cr>

" Start all searches with very-magic (under consideration)
nnoremap / /\v

" Unhighlight search results
nnoremap <leader>nh :nohlsearch<cr>

" Quick opening/sourcing of .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Quick command for opening the previous buffer in a new vsplit
nnoremap <leader>ep :execute "rightbelow vsplit " . bufname('#')<cr>

" Detect end-of-line whitespace
nnoremap <leader>w :match Error /\v\s+$/<cr>
nnoremap <leader>W :match Error none<cr>

" Add empty lines without leaving normal mode
nnoremap <leader>o o<esc>k
nnoremap <leader>O O<esc>k

" Grep for word under cursor. TODO: Make this use ripgrep/fzf instead
" nnoremap <leader>g :silent execute \"grep! -R \" . shellescape(expand("<cWORD>")) . \" .\"<cr>:copen<cr>:redraw!<cr>

" Wrap words or selections in quotes
vnoremap <leader>" <esc>`<i"<esc>`>la"<esc>
vnoremap <leader>' <esc>`<i'<esc>`>la'<esc>
vnoremap <leader>` <esc>`<i`<esc>`>la`<esc>
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
nnoremap <leader>` viw<esc>a`<esc>bi`<esc>lel

" Toggle quickfix window open and closed
nnoremap <leader>q :call <SID>QuickfixToggle()<cr>
let g:quickfix_is_open = 0

function! s:QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction
" }}}

" Mappings of dubious usefulness to me ------------------------------------{{{
" An interesting mapping for collapsing html by tags, but I don't write much html
" at the moment
" augroup filetype_html
"     autocmd!
"     autocmd FileType html nnoremap <buffer> <localleader>f Vatzf
" augroup END
"
"
" Text objects for markdown headings; which I don't use much
augroup filetype_markdown
    autocmd!
    autocmd FileType markdown onoremap <buffer> ah :<c-u>execute "normal! ?^\\(=\\\\|-\\)\\1\\+$\r:nohlsearch\rg_vk0"<cr>
    autocmd FileType markdown onoremap <buffer> ih :<c-u>execute "normal! ?^\\(=\\\\|-\\)\\1\\+$\r:nohlsearch\rkg_v0"<cr>
augroup END

" Text objects for emails (probably won't see much use, consider removing)
onoremap al@ :<c-u>execute "normal! ?\\s\\S*@\r:nohlsearch\rlvf.e"<cr>
onoremap an@ :<c-u>execute "normal! /\\s\\S*@\r:nohlsearch\rlvf.e"<cr>
onoremap il@ :<c-u>execute "normal! ?\\s\\S*@\r:nohlsearch\rlviw"<cr>
onoremap in@ :<c-u>execute "normal! /\\s\\S*@\r:nohlsearch\rlviw"<cr>

" Toggle foldcolumn (I can't evaluate how useful this is until I start using
" more folds
nnoremap <leader>F :call FoldColumnToggle()<cr>

function! FoldColumnToggle()
    if &foldcolumn
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=4
    endif
endfunction

" }}}

" Minimap.vim Settings ------------------------------{{{
nnoremap <leader>mm :MinimapToggle<CR>
"}}}

" Vimscript file settings----------------------------------------{{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" SQL file settings----------------------------------------{{{
augroup filetype_sql
    autocmd!
    autocmd FileType sql nnoremap <leader>sq :DB g:local_db<cr>
    autocmd FileType sql vnoremap <leader>sq :DB g:local_db<cr>
augroup END
" }}}

" vim-go Settings ------------------------------------------------------{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autowrite
let g:go_fmt_command = "goimports"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_build_constraints = 1
let g:go_metalinter_autosave_enabled = ['vet']
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
set updatetime=100

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

augroup filetype_go
    autocmd!
    autocmd FileType go nmap <leader>t  <Plug>(go-test)
    autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
    autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
    autocmd FileType go nmap <Leader>i <Plug>(go-info)
    autocmd FileType go nmap <Leader>ti :GoBuildTag integration<CR>
    autocmd FileType go nmap <Leader>gr :GoReferrers <CR>
    autocmd FileType go nmap \af vaf\
    autocmd FileType go nmap \if vif\
    autocmd FileType go nnoremap <Leader>mv :! go mod vendor<CR>
    autocmd FileType go nnoremap <buffer> <silent> gb :<C-U>call go#def#StackPop(v:count1)<cr>
    autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
    autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    autocmd Filetype go set noexpandtab
    autocmd Filetype go set shiftwidth=8
    autocmd Filetype go set softtabstop=8
augroup END
" }}}

" Theme Settings-----------------------------------------------------------{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:rehash256 = 1
" let g:molokai_original = 1
" colorscheme molokai
colorscheme dracula
" }}}

" NERDTree Settings -----------------------------------------------------{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>r :NERDTreeFind<cr>

augroup nerdtree
    autocmd!
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
" }}}

" FZF Settings --------------------------------------------------{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <C-z> :FZF<CR>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
noremap <leader>f :Rg<CR>
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
let g:fzf_preview_window = 'right:60%'
" }}}

" Commentary Settings --------------------------------------{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap \ :Commentary<CR>
" }}}

" Ruby Settings ----------------------------------------------------{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup filetype_ruby
    autocmd!
    autocmd FileType ruby setlocal commentstring=#\ %s
    autocmd FileType ruby noremap gd <C-]>
    autocmd FileType ruby noremap gb <C-t>
    autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
    autocmd FileType ruby onoremap nab :<c-u>execute "normal! /\\vdo(\\_.{-}(begin\|case\|class\|def\|do\|for\|if\|module\|unless\|until\|while)\\_.{-}end)\*\\_.{-}end\r:nohlsearch\rgn"<cr>
    autocmd FileType ruby onoremap nib :<c-u>execute "normal! /\\vdo\\zs(\\_.{-}(begin\|case\|class\|def\|do\|for\|if\|module\|unless\|until\|while)\\_.{-}end)\*\\_.{-}\\ze\\n\\s\*end\r:nohlsearch\rgn"<cr>
    autocmd FileType eruby setlocal expandtab shiftwidth=2 tabstop=2
augroup END
" }}}

" Python Settings ----------------------------------------------------{{{
autocmd FileType python iabbrev ifmain if __name__ == "__main__":
autocmd FileType python nnoremap <leader>; $a:<esc>
" }}}

" Protobuf Settings --------------------------------------------------{{{
augroup filetype_protobuf
    autocmd!
    autocmd FileType proto setlocal expandtab shiftwidth=2 tabstop=2
augroup END
"}}}

" Syntastic Settings ----------------------------------------------{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cs_checkers = ['code_checker']
" }}}

" Coc.nvim Settings -------------------------------------------------{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:coc_disable_startup_warning = 1

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
" }}}

" C# Settings ---------------------------------------------{{{
augroup filetype_csharp
    autocmd!
    autocmd FileType cs nnoremap <expr> <leader>; getline('.') =~ ';$' ? '' : "mqA;\<esc>`q"
augroup END
" }}}

" OmniSharp Settings -----------------------------------{{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview', 'popup'
" and 'popuphidden' if you don't want to see any documentation whatsoever.
" Note that neovim does not support `popuphidden` or `popup` yet:
" https://github.com/neovim/neovim/issues/10996
if has('patch-8.1.1880')
  set completeopt=longest,menuone,popuphidden
  " Highlight the completion documentation popup background/foreground the same as
  " the completion menu itself, for better readability with highlighted
  " documentation.
  set completepopup=highlight:Pmenu,border:off
else
  set completeopt=longest,menuone,preview
  " Set desired preview window height for viewing documentation.
  set previewheight=5
endif

augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nnoremap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nnoremap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nnoremap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nnoremap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nnoremap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nnoremap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nnoremap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)
  autocmd FileType cs nnoremap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nnoremap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nnoremap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs inoremap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field
  autocmd FileType cs nnoremap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nnoremap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nnoremap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
  " Contextual code actions (uses fzf, CtrlP or unite.vim when available)
  autocmd FileType cs nnoremap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xnoremap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)

  autocmd FileType cs nnoremap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)

  autocmd FileType cs nnoremap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)

  autocmd FileType cs nnoremap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
  autocmd FileType cs nnoremap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
  autocmd FileType cs nnoremap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)
augroup END
" }}}
