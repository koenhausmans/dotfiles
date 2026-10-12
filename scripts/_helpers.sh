#!/usr/bin/env/bash

# Set up helper functions for outputting to the command line
# A single message keeps the original %b formatting; a format plus arguments
# lets callers print paths as literal %s values without interpreting escapes.
_log_message () {
    if (( $# == 1 )); then
        printf '%b' "$1"
    else
        printf "$@"
    fi
}

info () {
    printf '\r  [ \033[00;34m..\033[0m ] '
    _log_message "$@"
    printf '\n'
}

user () {
    printf '\r  [ \033[0;33m??\033[0m ] '
    _log_message "$@"
    printf '\n'
}

success () {
    printf '\r\033[2K  [ \033[00;32mOK\033[0m ] '
    _log_message "$@"
    printf '\n'
}

fail () {
    {
        printf '\r\033[2K  [\033[0;31mFAIL\033[0m] '
        _log_message "$@"
        printf '\n\n'
    } >&2
    exit 1
}
