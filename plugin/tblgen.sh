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

# map from keyword to unicode
# k -> u
MAPTO='TXTtoUTF'

# map from unicode to keyword
# u -> k
MAPFROM='UTFtoTXT'

# u -> k is done linewise by default (because we probably want to translate
#     only those chars that appear to be on a line we are currently editing
#     but not on the entire document)
printf 'nnoremap <leader>k :call '$MAPFROM'(line("."),line("."))<CR>\n\n'

# u -> k is linewise in visual mode
printf 'vnoremap <leader>k :call  '$MAPFROM'(line("'\''<"),line("'\''>"))<CR>\n'

# u -> k is global if 'g' is prefixed
printf 'nnoremap <leader>gk :call  '$MAPFROM'(1,line("$"))<CR>\n'

# k -> u is global by default
printf 'nnoremap <leader>u :call  '$MAPTO'(1,line("$"))<CR>\n'

# k -> u is linewise in visual mode
printf 'vnoremap <leader>u :call  '$MAPTO'(line("'\''<"),line("'\''>"))<CR>\n'

# k -> u is linwise if 'l' is prefixed
printf 'nnoremap <leader>lu :call '$MAPTO'(line("."),line("."))<CR>\n'


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
