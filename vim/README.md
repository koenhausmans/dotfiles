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

Editing shortcuts:
------------------
`guu`: Entire line to lower case<br/>
`gUU`: Entire line to UPPER case<br/>
`U`: Undo all changes on line<br/>
`C`: Change to end of line<br/>
`[<space>`: Add blank lines above the cursor (Provided by tpope/vim-unimpaired)<br/>
`]<space>`: Add blank lines below the cursor (Provided by tpope/vim-unimpaired)<br/>

Movement shortcuts:
-------------------
`(`: Move sentence backward<br/>
`)`: Move sentence forward<br/>
`{`: Move paragraph backward<br/>
`}`: Move paragraph forward<br/>
`]]`: Move section forward or until the next '{' in the first column<br/>
`][`: Move section forward or until the next '}' in the first column<br/>
`[[`: Move section backward or until the next '{' in the first column<br/>
`[]`: Move section backward or until the next '}' in the first column<br/>
`gi`: Goto last insert position<br/>
`gv`: Reselect last selection<br/>
`;`: Repeat last `f{char}` command<br/>
`,`: Repeat last `f{char}` command (reverse)<br/>
`o`: In visual mode, change cursor to opposite end<br/>
`'.`: Jump to last modification line<br/>
`\`.`: Jump to last modification position<br/>
`'<`: Jump to the first char of the visual selection<br/>
`'>`: Jump to the last char of the visual selection<br/>
`g-`: Go to older text state<br/>
`''`: Moves to previous edit line<br/>
`\`\``: Moves to previous edit position<br/>
`<C-t>`: Jump back up in the tag stack<br/>
`<C-I>`: Jump back down in the jumplist<br/>
`<C-O>`: Jump back up in the jumplist<br/>
`<g;>`: Jump back up in the changelist<br/>
`<g,>`: Jump back up in the changelist<br/>
`zt`: Redraw current line at top
`zz`: Redraw current line at center
`zb`: Redraw current line at bottom
`H`: Move cursor to the top
`M`: Move cursor to the center
`L`: Move cursor to the bottom

Window shortcuts:
-----------------
`<C-W>r`: Rotate window downwards/rightwards<br/>
`<C-W>R`: Rotate window upwards/leftwards<br/>
`<C-W>J`: Move window to the top<br/>
`<C-W>K`: Move window to the bottom<br/>
`<C-W>H`: Move window to the left<br/>
`<C-W>L`: Move window to the right<br/>
`<C-W>_`: Maximize height of window<br/>
`<C-W>|`: Maximize width of window<br/>
`<C-W>=`: All windows equal widths/heights<br/>
`<C-W>o`: Make the current window the only window<br/>
`<C-W>x`: Swap neighbouring windows<br/>

Register shortcuts:
-------------------
`<C-R><C-W>`: Copy current word in command mode<br/>
`<C-R>x`: Copy register x in command mode<br/>

List shortcuts (Provided by tpope/vim-unimpaired):
--------------------------------------------------
`]b`: Go to next buffer<br/>
`[b`: Go to previous buffer<br/>
`]B`: Go to the first buffer<br/>
`[B`: Go to the last buffer<br/>
`]t`: Go to next tag<br/>
`[t`: Go to previous tag<br/>
`]l`: Go to next location list result<br/>
`[l`: Go to previous location list result<br/>
`]<C-L>`: Go to next location list result in another file<br/>
`[<C-L>`: Go to previous location list in another file<br/>
`]q`: Go to next quickfix result<br/>
`[q`: Go to previous quickfix result<br/>
`]<C-Q>`: Go to next quickfix result in another file<br/>
`[<C-Q>`: Go to previous quickfix result in another file<br/>

Option toggling (Provided by tpope/vim-unimpaired):
---------------------------------------------------
`[on`: Enable line numbers</br>
`]on`: Disable line numbers</br>

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
`<C-X><C-L>`: Completion for entire line<br/>

Spell checking:
---------------
`[os`: Enable spell checking<br/>
`]os`: Disable spell checking<br/>
`<leader>ss`: Toggle spell checking<br/>
`]s`: Move to the next misspelled word<br/>
`[s`: Move to the previous misspelled word<br/>
`zg`: Add word under cursor as a good word<br/>
`z=`: Suggest correctly spelled word<br/>

Tag shortcuts:
--------------
`gf`: Go to file<br/>
`<C-W>f`: Go to file in new window<br/>
`<C-]>`: Jump to the tag under the cursor<br/>
`g]`: Show multiple tag matches<br/>
`<C-W>}`: Open tag under cursor and open a preview window<br/>
`<C-W>z`: Close any open "Preview" window<br/>

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

`K`: Open FZF for an Ag search looking for the current word under the cursor<br/>

In a fzf window, the following shortcuts are supported:

`<C-p>`: Go to the previous result<br/>
`<C-n>`: Go to the next result<br/>

`<C-t>`: Open result in new tab<br/>
`<C-x>`: Open result in a horizontal split<br/>
`<C-v>`: Open result in a vertical split<br/>

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

