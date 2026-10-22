#!/usr/bin/env bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
settings="$HOME/.gemini/antigravity-cli/settings.json"
display_settings='~/.gemini/antigravity-cli/settings.json'

source "$BASEDIR/../../lib/helpers.sh"

# Print the current colorScheme as JSON ("get") or set it to "terminal"
# ("set"), keeping all other settings.
color_scheme() {
    python3 -I - "$settings" "$1" <<'EOF'
import json
import os
import sys
import tempfile

path = os.path.realpath(sys.argv[1])
try:
    with open(path, encoding="utf-8") as file:
        settings = json.load(file)
except FileNotFoundError:
    settings = {}
except (OSError, ValueError) as error:
    sys.exit(f"Cannot read {sys.argv[1]}: {error}")
if not isinstance(settings, dict):
    sys.exit(f"Cannot read {sys.argv[1]}: expected a JSON object")

if sys.argv[2] == "get":
    print(json.dumps(settings.get("colorScheme")))
    sys.exit()

settings["colorScheme"] = "terminal"
directory = os.path.dirname(path)
os.makedirs(directory, exist_ok=True)
descriptor, temporary = tempfile.mkstemp(dir=directory, prefix=".settings.json.")
try:
    with os.fdopen(descriptor, "w", encoding="utf-8") as file:
        json.dump(settings, file, indent=2, ensure_ascii=False)
        file.write("\n")
    if os.path.exists(path):
        os.chmod(temporary, os.stat(path).st_mode & 0o7777)
    else:
        umask = os.umask(0)
        os.umask(umask)
        os.chmod(temporary, 0o666 & ~umask)
    os.replace(temporary, path)
except BaseException:
    os.unlink(temporary)
    raise
EOF
}

if ! command -v agy > /dev/null; then
    info 'Antigravity CLI is not installed, skipping its color scheme'
    exit 0
fi

current=$(color_scheme get) || fail 'Could not read Antigravity CLI settings'

case $current in
    '"terminal"')
        info 'Antigravity CLI already uses the terminal color scheme'
        exit 0
        ;;
    null) ;;
    *)
        if ! ( : </dev/tty ) 2>/dev/null; then
            fail 'Cannot replace Antigravity CLI color scheme %s without a terminal' "$current"
        fi
        while :; do
            user 'Antigravity CLI uses color scheme \e[1;36m%s\e[0m in %s' "$current" "$display_settings" > /dev/tty
            printf '       Replace it with "terminal"? \033[0;32m[y]\033[0mes  \033[0;34m[n]\033[0mo? ' > /dev/tty
            if ! IFS= read -r action < /dev/tty; then
                fail 'No choice received for the Antigravity CLI color scheme'
            fi
            case $action in
                y|n) break ;;
                *) user 'Enter y or n.' > /dev/tty ;;
            esac
        done
        if [[ $action == n ]]; then
            info 'Kept Antigravity CLI color scheme %s' "$current"
            exit 0
        fi
        ;;
esac

color_scheme set || fail 'Could not update Antigravity CLI settings'
success 'Set Antigravity CLI color scheme to "terminal" in %s' "$display_settings"
info 'Select a matching palette from themes/alacritty or themes/windows-terminal in your terminal'
