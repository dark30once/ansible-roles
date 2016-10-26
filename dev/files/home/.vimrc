syntax on
call pathogen#infect()
call pathogen#helptags()

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_python_python_exec = 'python3'
let g:syntastic_python_pyflakes_exec = 'pyflakes3'
let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_check_on_open = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1


set nowrap
filetype plugin indent on
set autoindent
hi BadWhitespace ctermbg=red guibg=red
au! Syntax myghty source $VIM/syntax/myghty.vim
au BufRead,BufNewFile *.myt set filetype=myghty
au BufRead,BufNewFile *.theme set filetype=php
au BufRead,BufNewFile *.module set filetype=php
au BufRead,BufNewFile *.prt set filetype=sql
au BufRead,BufNewFile *.tex,*.R,*,Snw,*.php,*.zcml,*.pt,*.py,*pyw set shiftwidth=4
au BufRead,BufNewFile *.tex,*.R,*,Snw,*.php,*.zcml,*.pt,*.py,*pyw set expandtab
au BufRead,BufNewFile *.tex,*.R,*,Snw,*.php,*.zcml,*.pt,*.py,*pyw set tabstop=4
au VimEnter *.py,*.html,*.js NERDTree
au VimEnter *.py,*.html,*.js TlistOpen
au BufWritePost *.py,*.js :TlistUpdate
au BufRead,BufNewFile *.py,*.js SyntasticCheck
au BufRead,BufNewFile *.py set colorcolumn=80
au BufRead,BufNewFile *.py hi ColorColumn ctermbg=grey
au BufRead,BufNewFile *.py set mouse=a
au BufRead,BufNewFile *.md,*.markdown set wrap


au BufNewFile *.kid,*.myt,*.zcml,*.pt,*.rb,*.rhtml,*.py,*.pyw,*.c,*.h set fileformat=unix
let python_highlight_all=1
au BufRead,BufNewFile *.kid,*.theme,*.myt,*.css,*.html,*.rb,*.rhtml,*.scss set shiftwidth=2
au BufRead,BufNewFile *.kid,*.theme,*.myt,*.css,*.html,*.rb,*.rhtml,*.scss set expandtab
au BufRead,BufNewFile *.kid,*.theme,*.myt,*.css,*.html,*.rb,*.rhtml,*.scss set tabstop=2
au BufRead,BufNewFile *.md set spell spelllang=en_us
let ruby_highlight_all=1
set backspace=indent,eol,start

" NERD_tree config
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\.vim$', '\~$', '\.pyc$', '\.swp$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\~$']
let NERDTreeShowBookmarks=1
map <F3> :NERDTreeToggle<CR>

" TagList Plugin Configuration
let Tlist_GainFocus_On_ToggleOpen = 0 
let Tlist_Close_On_Select = 0
let Tlist_Use_Right_Window = 1
let Tlist_File_Fold_Auto_Close = 0
map <F7> :TlistToggle<CR>

" Viewport Controls
" ie moving between split panes
map <silent><C-left> <C-w>h
map <silent><C-right> <C-w>l
map <silent><C-up> <C-w>k
map <silent><C-down> <C-w>j
"nnoremap <silent><C-up> :exe "vertical resize +10"<CR>
"nnoremap <silent><C-down> :exe "vertical resize-10"<CR>

" Other general key mappings
nnoremap :Q :qall

map <C-y> "+y
vmap <C-p> "+gp
map <C-p> "+gp
map <C-S-a> +ggVG
exe 'inoremap <script> <C-y>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-p>' paste#paste_cmd['v']
exe 'inoremap <C-Left> <C-O>b'
exe 'inoremap <C-Right> <C-O>w'
set number


"delete the buffer; keep windows; create a scratch buffer if no buffers left
function s:Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! Kwbd call s:Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>

" Create a mapping (e.g. in your .vimrc) like this:
nmap <C-W>! <Plug>Kwbd

map <Leader>vip :call VimuxIpy()<CR>
vmap <silent> <Leader>e :python run_visual_code()<CR>
noremap <silent> <Leader>c :python run_cell(save_position=False, cell_delim='###')<CR>
let VimuxOrientation = "h"
