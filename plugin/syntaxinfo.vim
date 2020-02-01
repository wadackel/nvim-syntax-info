if exists('g:syntaxinfo_loaded')
  finish
endif
let g:syntaxinfo_loaded = 1

command! -nargs=0 -bar SyntaxInfo call syntaxinfo#show()
command! -nargs=0 -bar SyntaxInfoClear call syntaxinfo#clear()
command! -nargs=0 -bar SyntaxInfoEnable call syntaxinfo#enable()
command! -nargs=0 -bar SyntaxInfoDisable call syntaxinfo#disable()
command! -nargs=0 -bar SyntaxInfoToggle call syntaxinfo#toggle()

nnoremap <silent><Plug>(syntax-info) :<C-u>SyntaxInfo<CR>
nnoremap <silent><Plug>(syntax-info-clear) :<C-u>SyntaxInfoClear<CR>
nnoremap <silent><Plug>(syntax-info-enable) :<C-u>SyntaxInfoEnable<CR>
nnoremap <silent><Plug>(syntax-info-disable) :<C-u>SyntaxInfoDisable<CR>
nnoremap <silent><Plug>(syntax-info-toggle) :<C-u>SyntaxInfoToggle<CR>

highlight link SyntaxInfo Comment
