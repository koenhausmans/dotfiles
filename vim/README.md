Vim Script - Keyboard shortcuts:
================================

`<leader>` key has been defined as `,`

File open/close:
----------------
`<leader>w`: Saves a file<br/>
`<leader>wq`: Saves a file and closes it<br/>
`<leader>W`: Saves a file with sudo rights<br/>
`<leader>q`: Close the file<br/>

Buffer shortcuts:
-----------------
`<leader>b`: Shows buffer list and allows for quick navigation to another buffer<br/>
`<leader>bn`: Go to the next buffer<br/>
`<leader>bp`: Go to the previous buffer<br/>
`<leader>bd`: Delete the current buffer without screwing up window layout<br/>
`<leader>ba`: Delete all loaded buffers<br/>
`<C-6>`: Go to previous buffer

Tab shortcuts:
--------------
`<leader>tn`: Open a new tab<br/>
`<leader>tc`: Close a new tab<br/>

Spell checking:
---------------

`<leader>ss`: Toggle spell checking<br/>
`<leader>sn`: Move to the next misspelled word<br/>
`<leader>sp`: Move to the previous misspelled word<br/>
`<leader>sa`: Add word under cursor as a good word<br/>
`<leader>s?`: Suggest correctly spelled word<br/>

NERDTree: Tree File Explorer:
-----------------------------

`<leader>nn`: Open NERDTree<br/>
`<leader>nf`: Open NERDTree and find the currently opened file in the tree<br/>

[https://www.cheatography.com/stepk/cheat-sheets/vim-nerdtree/]

TODO: Add additional shortcuts for NERDTree

Ctags: Tag support in vim:
--------------------------

### Easytags: Tag generation:
To recursively generate tags from the CWD down, press `<leader>ut`.

### CTags Shortcuts:

`<C-]>`: Jump to the tag underneath the cursor<br/>
`<C-t>`: Jump back up in the tag stack<br/>


FZF: Fuzzy finder:
------------------

The following shortcuts are allowed in Normal mode:

`<C-p>`: Open FZF with multiple select mode enabled<br/>
`<leader>ff`: Open FZF from (git) project root<br/>
`<leader>ff`: Open FZF for previously opened files<br/>
`<leader>bb`: Open FZF for buffers<br/>
`<leader>ll`: Open FZF for all lines in opened buffers<br/>
`<leader>lb`: Open FZF for all lines in current file<br/>
`<leader>tt`: Open FZF for all tags in project<br/>
`<leader>bt`: Open FZF for all tags in current file<br/>
`<leader>mm`: Open FZF for all marks<br/>
`<leader>ch`: Open FZF for command history<br/>

In a fzf window, the following shortcuts are supported:

`<C-p>`: Go to the previous result<br/>
`<C-n>`: Go to the next result<br/>

`<C-t>`: Open result in new tab<br/>
`<C-x>`: Open result in a horizontal split<br/>
`<C-v>`: Open result in a vertical split<br/>

Goyo: Distraction free editing:
-------------------------------

To enable distraction free editing, press `<leader>z`.

