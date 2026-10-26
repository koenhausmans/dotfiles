# bat

Install Ubuntu's `bat` package, then select `bat` in `./install.sh`.
The installer links Ubuntu's `batcat` binary as `~/.local/bin/bat` when no
`bat` command exists, and links `config` to `$XDG_CONFIG_HOME/bat/config`, or
`~/.config/bat/config` when `XDG_CONFIG_HOME` is unset or empty.

## Display and previews

Defaults show line numbers and Git-change markers, with automatic paging for
long terminal output. `cat` and the global pager are unchanged.

With `bat` or `batcat` available, fzf's **Ctrl-T** picker in Bash, Zsh, and Fish
previews the first 300 lines with syntax highlighting. Directories show a listing.
History and directory pickers are unchanged. Vim and Neovim use fzf.vim's built-in
bat detection for their existing previews.

## Customize

Existing `FZF_CTRL_T_OPTS` values are kept. Set it in your local shell config to
customize the preview, or set it to an empty string to disable it.

Bat's `BAT_THEME`, `BAT_STYLE`, and `BAT_CONFIG_PATH` variables customize normal
bat invocations. Shell file previews use a fixed style and never open a pager.
