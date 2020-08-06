nnoremap <leader>pg :set operatorfunc=<SID>PostgreSQLFormatter<cr>g@
vnoremap <leader>pg :<c-u>call <SID>PostgreSQLFormatter(visualmode())<cr>

function! s:PostgreSQLFormatter(type)
    let save_unnamed_register = @@

    if a:type ==# 'v'
        execute "normal! `<v`>y"
        let @@ = system('echo ' . shellescape(@@) . ' | pg_format --comma-break -')
        execute "normal! `<v`>p"
    elseif a:type ==# 'char'
        " Save marks for last visual selection in `a and `b
        execute "normal! `<ma`>mb"
        execute "normal! `[yv`]"
        let @@ = system('echo ' . shellescape(@@) . ' | pg_format --comma-break -')
        execute "normal! `[v`]p"
        " Restore marks
        execute "normal! `am<`bm>"
    else
        return
    endif

    let @@ = save_unnamed_register
endfunction
