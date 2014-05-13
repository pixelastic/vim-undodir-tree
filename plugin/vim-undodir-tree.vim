" vim-undodir-tree.vim - Saving undo file in a tree folder
" Maintainer:   Tim Carry <tim at pixelastic dot com>
"
" The main aim of this plugin is to circumvent the "File name too long" error
" one can get when trying to auto save undo files with very long filepaths.
" Instead of a unique file with a very long filepath, it will instead mirror
" the filepath of the file in the `undodir` directory.

if exists("g:loaded_vim_undodir_tree")
  finish
endif
let g:loaded_vim_undodir_tree = 1

" We stop if we don't want undodir at all
if !&undofile
  finish
endif

" We disable the default saving of undo file as we're overwriting it
set noundofile

" Short-circuit undo read/write as noted in `:help wundo`
augroup vim_undodir_tree
  autocmd!
  autocmd BufWritePost * call s:WriteUndoFile()
  autocmd BufReadPost * call s:ReadUndoFile()
augroup END

" Returns the full path where to save the undo file
" This will replace any "%" in the original filepath with "/" to create
" a proper tree
function! s:GetUndoFile(filepath)
  let undofile = undofile(a:filepath)
  let undofile = substitute(undofile, '%', '/', 'g')
  let undofile = substitute(undofile, '//', '/', 'g')
  return undofile
endfunction

" Saves the undo file
function! s:WriteUndoFile()
  set noundofile
  let undofile = s:GetUndoFile(expand('%:p'))
  let undodir = fnamemodify(undofile, ":h")
  if !isdirectory(undodir)
    call mkdir(undodir, "p")
  endif
  execute 'wundo ' . undofile
endfunction

" Read the undo file
function s:ReadUndoFile()
  let undofile = s:GetUndoFile(expand('%:p'))
  if filereadable(undofile)
    silent! execute 'rundo ' . undofile
  endif
endfunction

