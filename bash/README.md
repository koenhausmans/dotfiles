# Bash configuration

`install.sh` links the Bash configuration and manages the `z` checkout at
`~/.local/share/z`. Existing checkouts are updated only when they are clean Git
roots with the expected `origin` and an `origin`-tracking branch; updates use
fast-forward-only pulls. Keep custom checkouts outside this managed path. If
validation or updating fails, the installer leaves the checkout in place and
stops.
