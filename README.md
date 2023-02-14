# Unicode character mappings for VIM

### Description
Quick and dirty solution to write unicode in vim, that allows you to edit the end result by mapping predefined set of unicode characters back to original keywords.

### Key Mappings

Normal mode mappings:
  - `<leader>u` - map all `keywords` to corresponding `unicode` characters
  - `<leader>k` - map all `unicode` characters to their corresponding `keywords`
  - `<leader>lu` - map current line from `keywords` to `unicode`
  - `<leader>lk` - map current line to `keywords` from `unicode`

Visual mode mappings:
  - `<leader>u` - map `keywords` on selected lines to `unicode`
  - `<leader>k` - map `unicode` on selected lines to `keywords`

### Usage
- Type some keywords, then press `<leader>u` to map them all globally,
- or select lines with `keywords` that you want to map and press `<leader>u`
- or go to line with `keywords` that you want to map an press `<leader>lu`
- same logic applies for mapping the `unicode` back to `keywords`, but instead of `u` part of the command you type `k`

### Keyword mapping list
The full list of mappings from `keywords` to `unicode` can be accessed by `:h txt2utf.txt`.

To introduce a new mapping, or edit the existing one, you'll simply need to edit the documentation file for `txt2utf` plugin. It's path will approximately be something like: `~/.vim/plugins/txt2utf/doc/txt2utf.txt`. After that you need to regenerate the mapping functions by issuing the `./tblgen.sh > txt2utf.vim` which is placed within the plugin directory `txt2utf/plugin/tblgen.sh`.
