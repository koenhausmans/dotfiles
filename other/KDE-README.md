KDE Readme:
===========

Using KDE Wallet for ssh keys:
------------------------------
Source: https://wiki.archlinux.org/index.php/KDE_Wallet#Using_the_KDE_Wallet_to_store_ssh_keys

Install the `ksshaskpass` package.

Create a `ssh-add.sh` script under `~/.config/autostart-scripts/` with the following contents:

```
#!/bin/sh
ssh-add $HOME/.ssh/id_rsa* < /dev/null
```

Add the following to `.bashrc.local` and `.zshrc.local`:

```
export SSH_ASKPASS="/usr/bin/ksshaskpass"
```

