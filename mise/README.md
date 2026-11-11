# mise

[mise](https://mise.jdx.dev/) manages runtimes, CLI tools, and editor tooling.
Select `mise` in `./install.sh` to install the mise binary and all configured tools.

## Tools

Configured in [`config.toml`](config.toml), symlinked to `~/.config/mise/config.toml`:

| Category | Tools |
|---|---|
| Runtimes | Node.js LTS, Neovim, Rust stable (via rustup) |
| CLI | bat, fd, fzf, ripgrep, shellcheck, shfmt, stylua, zoxide |
| Editor | ruff, lua-language-server |
| npm | basedpyright, markdownlint-cli, opencode-ai, prettier, typescript, typescript-language-server, vscode-langservers-extracted |

For Rust components not included in the stable toolchain, run:

```sh
rustup component add rust-analyzer rust-src
```

## Shell activation

`mise activate` is added to Zsh, Bash, and Fish by their respective installers,
making all tools available on `PATH` in every new shell session.

## Add or update tools

Edit `mise/config.toml` and run `mise install` to pick up the change.
