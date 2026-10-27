# fzf installer

`install.sh` downloads the latest Debian package and verifies its SHA-256
checksum before installation. It skips installation only when dpkg reports fzf
fully installed at the same version. The old `~/.fzf` checkout is not managed.
