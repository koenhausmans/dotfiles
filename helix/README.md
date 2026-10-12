# Helix configuration

Install Helix first. Then link the configuration in this directory. Choose one installation method below.

## Option 1: Install the Debian package (Ubuntu/Debian)

The release provides an `amd64` Debian package. Use the source method below for other architectures.

1. Download the `.deb` from the [official Helix releases](https://github.com/helix-editor/helix/releases/latest).
2. Run this command in the directory with the downloaded package:

   ```sh
   sudo apt install ./helix_*_amd64.deb
   ```

The package installs `hx` and its `runtime` directory. You do not need a separate runtime link.

## Option 2: Build from source with Cargo

Install [Rust and Cargo](https://www.rust-lang.org/tools/install), Git, and a C++14 compiler first.
On Ubuntu/Debian, install Git and the compiler with `sudo apt install git build-essential`.

1. Clone Helix and install `hx`:

   ```sh
   mkdir -p ~/src
   git clone https://github.com/helix-editor/helix.git ~/src/helix
   cd ~/src/helix
   cargo install --path helix-term --locked
   ```

2. Link the source checkout's `runtime` directory to the Helix configuration directory:

   ```sh
   mkdir -p ~/.config/helix
   ln -sT "$PWD/runtime" "$HOME/.config/helix/runtime"
   ```

   If `~/.config/helix/runtime` already exists, check it before you create the link.
   Do not replace an existing runtime without checking its contents.
   Keep the source checkout at `~/src/helix` while this link points to it.

Cargo installs `hx` in `~/.cargo/bin`. Make sure that directory is on your `PATH`.
The build creates grammar files in the checkout's `runtime` directory.
`hx` needs that directory for syntax highlighting and themes.

## Link this configuration

From this dotfiles repository, run:

```sh
./helix/install.sh
```

This script links `config.toml`, `languages.toml`, and the `sonokai_shusia` theme into `~/.config/helix`.
It does not install `hx` or its runtime. Check existing files at those paths first. The script does not replace them.

Verify the installation with `hx --health`. Helix reports missing language servers separately.
Install the servers and formatters used by `languages.toml` if you want those features.

See the [Helix installation guide](https://docs.helix-editor.com/install.html) and [source-build guide](https://docs.helix-editor.com/building-from-source.html) for other platforms and runtime locations.
