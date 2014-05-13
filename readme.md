# vim-undodir-tree

The main goal of this plugin is to avoid the `E828` error one can get in vim
when trying to save a file with a very long file path and `undofile` enabled.

As vim saves undo files in `undodir` with a name equal to the original
filepath, with all `/` replaced with `%`, one can hit the OS maximum length for
files. If this happens, vim won't be able to save the undo file and will throw
the `E828` error.

# What does this plugin do ?

Well, instead of saving undo files as `%original%path%of%the%file`, it will
create the `original/path/of/the/` folder structure inside of `undodir`, and
save the undo file in it.

This way, we avoid the length limit on filenames, and as an added bonus it
makes pruning the undo folder much more easier.
