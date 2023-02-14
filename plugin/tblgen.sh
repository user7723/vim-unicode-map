#! /bin/bash

seed=../doc/txt2utf.txt
table=utf8tbl.tmp

cat "$seed" |
sed '/^#\|^$\|^\*/d' > ./"$table"

function escape() {
  perl -pe 's/\\/\\\\/g' |      # \ -> \\
  perl -pe 's/\//\\\//g' |      # / -> \/
  perl -pe "s/'/\\\\'/g" |      # ' -> \'
  perl -pe 's/(\[|\]|~)/\\\1/g' # [|] -> \[ | \]
}

MAPTO='TXTtoUTF'
MAPFROM='UTFtoTXT'

printf 'nnoremap <leader>k :call  '$MAPFROM'(1,line("$"))<CR>\n'
printf 'vnoremap <leader>k :call  '$MAPFROM'(line("'\''<"),line("'\''>"))<CR>\n'
printf 'nnoremap <leader>u :call  '$MAPTO'(1,line("$"))<CR>\n'
printf 'vnoremap <leader>u :call  '$MAPTO'(line("'\''<"),line("'\''>"))<CR>\n'
printf 'nnoremap <leader>lu :call '$MAPTO'(line("."),line("."))<CR>\n'
printf 'nnoremap <leader>lk :call '$MAPFROM'(line("."),line("."))<CR>\n\n'

printf 'function! '$MAPFROM'(begin,end)
  let s:line = line(".")
  let s:column = col(".")
'

cat "$table" |
escape |
perl -pe "s/(.*?) (.*)/  execute 'silent ' . a:begin . ',' . a:end . 's\/\2\/\1\/eg'/"
printf '  call cursor(s:line,s:column)
endfunction

'

printf 'function! '$MAPTO'(begin,end)
  let s:line = line(".")
  let s:column = col(".")
'

cat "$table" |
escape |
perl -pe "s/(.*?) (.*)/  execute 'silent ' . a:begin . ',' . a:end . 's\/\1\/\2\/eg'/"
printf '  call cursor(s:line,s:column)
endfunction
'

rm ./"$table"
