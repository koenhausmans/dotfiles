Tmux - Keyboard Shortcuts:
==========================

General:
========
Run `tmux source-file ~/.tmux.conf` to reload the configuration; there is no reload shortcut.<br/>

Suspend:
========
`<F12>`: Suspend tmux key bindings; all keys go to the inner application (e.g. a nested/remote tmux). The mode indicator shows ` ---- `. Leaves copy mode and turns off pane sync.<br/>
`<F12>` (while suspended): Resume tmux key bindings<br/>

Windows:
========
`<C-a>*number*`: To go to the window with *number*<br/>
`<C-a>c`: Create a new window<br/>
`<C-a>n`: Next window<br/>
`<C-a><C-n>`: Next window<br/>
`<C-a>p`: Previous window<br/>
`<C-a><C-p>`: Previous window<br/>
`<C-a>a`: Switch to the last window<br/>
`<C-a><C-a>`: Send `<C-a>` to the current pane<br/>
`<C-a>&`: Kill the current window (tmux default)<br/>

`<C-a>,`: Rename window<br/>
`<C-a>:rename-window`: Rename window<br/>

Splits:
=======
`<C-a>v`: Splits window horizontally<br/>
`<C-a>|`: Splits window horizontally<br/>
`<C-a>s`: Splits window vertically<br/>
`<C-a>_`: Splits window vertically<br/><br/>

`<C-a>h`: Resize pane to the left with 1<br/>
`<C-a>j`: Resize pane down by 1<br/>
`<C-a>k`: Resize pane up by 1<br/>
`<C-a>l`: Resize pane to the right with 1<br/>

`<C-a>H`: Resize pane to the left with 5<br/>
`<C-a>J`: Resize pane down by 5<br/>
`<C-a>K`: Resize pane up by 5<br/>
`<C-a>L`: Resize pane to the right with 5<br/><br/>

Panes:
======
`<C-a>q`: Show pane numbers, type the key to goto that pane<br/>
`<C-a>o`: Swap panes<br/>
`<C-a><C-o>`: Rotate panes in current window<br/>
`<C-a>{`: Move pane to the left<br/>
`<C-a>}`: Move pane to the right<br/>
`<C-a>z`: Toggle pane zoom<br/>

Pane Layouts:
=============
`<C-a><space>`: Toggle between layouts<br/>
`<C-a><M-1>`: Evenly space all panes horizontally<br/>
`<C-a><M-2>`: Evenly space all panes vertically<br/>
