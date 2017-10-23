set -e

MODE_ARGUMENT=${1:-}

# Install apprentice plugin when minimal version is required
if [[ "$MODE_ARGUMENT" == "minimal" ]] ; then
    echo "Installing apprentice colorscheme for vim..."

    mkdir -p ~/.vim/colors/
    pushd ~/.vim/colors/ > /dev/null
    wget --no-check-certificate --quiet https://raw.githubusercontent.com/romainl/Apprentice/master/colors/apprentice.vim
    popd > /dev/null
fi

