# bat

Select `bat` in `./install.sh` to link `config` to `$XDG_CONFIG_HOME/bat/config`
(or `~/.config/bat/config` when `XDG_CONFIG_HOME` is unset or empty).
The bat binary is managed by [mise](../mise/README.md).

## Display and previews

Defaults show line numbers and Git-change markers, with automatic paging for
long terminal output. `cat` and the global pager are unchanged.

With `bat` available, fzf's **Ctrl-T** picker in Bash, Zsh, and Fish
previews the first 300 lines with syntax highlighting. Directories show a listing.
History and directory pickers are unchanged. Vim and Neovim use fzf.vim's built-in
bat detection for their existing previews.

## Customize

Existing `FZF_CTRL_T_OPTS` values are kept. Set it in your local shell config to
customize the preview, or set it to an empty string to disable it.

Bat's `BAT_THEME`, `BAT_STYLE`, and `BAT_CONFIG_PATH` variables customize normal
bat invocations. Shell file previews use a fixed style and never open a pager.
