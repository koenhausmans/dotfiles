Vim Script - Keyboard shortcuts:
================================

`<leader>` key has been defined as `,`

File open/close:
----------------
`<leader>w`: Saves a file<br/>
`<leader>W`: Saves a file with sudo rights<br/>
`<leader>wq`: Saves a file and closes it<br/>
`<leader>Wq`: Saves a file with sudo rights and closes it<br/>
`<leader>q`: Close the file<br/>
`<leader>Q`: Close the file without warning<br/>

Buffer shortcuts:
-----------------
`<leader>b`: Shows buffer list and allows for quick navigation to another buffer<br/>
`<leader>c`: Delete the current buffer without screwing up window layout<br/>
`<C-6>`: Go to previous buffer

List shortcuts:
---------------
`]b`: Go to next buffer<br/>
`[b`: Go to previous buffer<br/>
`]t`: Go to next tab<br/>
`[t`: Go to previous tab<br/>
`]l`: Go to next location list result<br/>
`[l`: Go to previous location list result<br/>
`]<C-L>`: Go to next location list result in another file<br/>
`[<C-L>`: Go to previous location list in another file<br/>
`]q`: Go to next quickfix result<br/>
`[q`: Go to previous quickfix result<br/>
`]<C-Q>`: Go to next quickfix result in another file<br/>
`[<C-Q>`: Go to previous quickfix result in another file<br/>

Fold shortcuts:
---------------

`zf`: To create a fold<br/>
`zd`: To delete a fold<br/>
`zo`: To open one fold under the cursor<br/>
`zO`: To open all folds under the cursor<br/>
`zc`: To close one fold under the cursor<br/>
`zC`: To close all folds under the cursor<br/>
`za`: Toggle one fold under the cursor<br/>
`zA`: Toggle all folds under the cursor<br/>

Insert Completion:
------------------

`<C-X><C-O>`: Omni-completion, guess what kind of item is in front and show the match<br/>
`<C-X><C-N>`: Completion for keywords in the current file<br/>
`<C-X><C-F>`: Completion for file names<br/>
`<C-X><C-J>`: Completion for tags<br/>

Preview Window:
---------------

`<C-W>z`: Close any open "Preview" window<br/>
`<C-W>}`: Open tag under cursor and open a preview window<br/>

Spell checking:
---------------

`<leader>ss`: Toggle spell checking<br/>
`<leader>sn`: Move to the next misspelled word<br/>
`<leader>sp`: Move to the previous misspelled word<br/>
`<leader>sa`: Add word under cursor as a good word<br/>
`<leader>s?`: Suggest correctly spelled word<br/>

NERDTree: Tree File Explorer:
-----------------------------

`<F1>`: Open NERDTree and find the currently opened file in the tree<br/>
`<F2>`: Open NERDTree<br/>

[https://www.cheatography.com/stepk/cheat-sheets/vim-nerdtree/]

Ctags: Tag support in vim:
--------------------------

### Easytags: Tag generation:
To recursively generate tags from the CWD down, press `<leader>ut`.

### CTags Shortcuts:

`<C-]>`: Jump to the tag underneath the cursor<br/>
`<C-t>`: Jump back up in the tag stack<br/>
`<C-I>`: Jump back down in the tag stack<br/>
`<C-O>`: Jump back up in the tag stack<br/>



FZF: Fuzzy finder:
------------------

The following shortcuts are allowed in Normal mode:

`<C-p>`: Open FZF with multiple select mode enabled<br/>
`<leader>f`: Open FZF<br/>
`<leader>g`: Open FZF from (git) project root<br/>
`<leader>G`: Open FZF for all files in the current git repository<br/>
`<leader>?`: Open FZF for previously opened files<br/>
`<leader>b`: Open FZF for buffers<br/>
`<leader>t`: Open FZF for all tags in project<br/>
`<leader>m`: Open FZF for all marks<br/>
`<leader>/`: Open FZF for an Ag search<br/>
`<leader>.`: Open FZF for an Ag search under a directory<br/>

`K`: Open FZF for an Ag search lookign for the current word under the cursor<br/>

In a fzf window, the following shortcuts are supported:

`<C-p>`: Go to the previous result<br/>
`<C-n>`: Go to the next result<br/>

`<C-t>`: Open result in new tab<br/>
`<C-x>`: Open result in a horizontal split<br/>
`<C-v>`: Open result in a vertical split<br/>

Goyo: Distraction free editing:
-------------------------------

To enable distraction free editing, press `<leader>z`.

Commentary.vim: Comment stuff out:
----------------------------------

`gcc`: To comment out a line<br/>
`gc`: To comment out the target of motion (e.g. `gcap` to comment out a paragraph)<br/>

Surround.vim: Quoting/Parenthesizing made simple:
-------------------------------------------------

`cs"'`: To change the `"` quotes to `'`<br/>
`ds"`: To remove the `"` quotes<br/>
`ysiw]`: To add `[]` quotes around current word<br/>
`S"`: To add `"` quotes around selection<br/>

Adding `()`-brackets (and `{}`-brackets) can be done by `(` to add a space or by `)` to add without a space<br/>

