#!/usr/bin/env/bash

# Set up helper functions for outputting to the command line
info () {
    printf '\r  [ \033[00;34m..\033[0m ] %b\n' "$1"
}

user () {
    printf '\r  [ \033[0;33m??\033[0m ] %b\n' "$1"
}

success () {
    printf '\r\033[2K  [ \033[00;32mOK\033[0m ] %b\n' "$1"
}

fail () {
    printf '\r\033[2K  [\033[0;31mFAIL\033[0m] %b\n\n' "$1" >&2
    exit 1
}
