#!/bin/bash

IGNORE_FOLDERS=( \
	bin \
	scripts
)

source scripts/print.sh

SIMULATE=false

do_stow () {
	STOW_ARGUMENTS=""
	if [ $SIMULATE == true ] ; then
		STOW_ARGUMENTS="$STOW_ARGUMENTS -v -n"
	fi
	stow --ignore='.*\.swp' --ignore='.*\.md' --ignore='.*\.sh' $STOW_ARGUMENTS ${@:1}
}

is_a_valid_package () {
	for invalid_folder in ${IGNORE_FOLDERS[@]} ; do
		if [ "$1" == $invalid_folder ] ; then
			return `false`
		fi
	done
	return `true`
}

do_install () {
	# find the installers and run them iteratively
	info "Running all installers"
	find . -mindepth 2 -name install.sh | while read installer ; do sh -c "${installer}" ; done

	# find the installers and run them iteratively
	info "Starting to stow configuration files"

	for package in $(find * -maxdepth 0 -type d) ; do
		if is_a_valid_package $package ; then
			do_stow $package
		fi
	done

	#do_stow bash
	#do_stow screen
	#do_stow vim
}

do_uninstall () {
	# Unstows the installed packages
	info "Unstowing all configuration files"

	for package in $(find * -maxdepth 0 -type d) ; do
		if is_a_valid_package $package ; then
			do_stow -D $package
		fi
	done
	#do_stow -D bash
	#do_stow -D screen
	#do_stow -D vim
}


for arg in "$@"
do
case $arg in
    -h|--help)
        echo """
usage: $0 [-h] [-u] [-i]

Installs all the (dotfiles) configurations.

optional arguments
  -h, --help       Shows this help message
  -u, uninstall    Uninstalls the configuration files
  -s, simulate     Simulates the behavior, does not execute anything
        """
        exit
        ;;
    -u|uninstall)
        do_uninstall
	exit
        ;;
    -s|simulate)
	SIMULATE=true
	;;
    *)
	error "Invalid argument supplied: $arg"
	;;
esac
done

do_install

