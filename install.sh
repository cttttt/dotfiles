#!/bin/sh

SCRIPT_DIR=$(dirname "$0")
BACKUP_DIR=~/.dotfiles.backup
TARGET_DIR=~

main () {
    mkdir -p "$BACKUP_DIR"

    if ! cd "$SCRIPT_DIR/dot"; then
	echo "$SCRIPT_DIR: Could not locate this script's install dir." >&2
	exit 1
    fi

    find * -name '[^.]*' -type f | while read srcFile; do
	targetPath=$TARGET_DIR/.$srcFile
	backupPath=$BACKUP_DIR/.$srcFile

	if [ -e "$targetPath" ]; then
	    mkdir -p "$(dirname "$backupPath")"
	    mv "$targetPath" "$backupPath" || continue
	fi

	mkdir -p "$(dirname "$targetPath")"
	ln -sf "$PWD/$srcFile" "$targetPath"
    done

    cat <<DONE
All done!

Remember: 

- To install VIM plugins, run:

vim +PluginInstall +qa

- You should install Powerline fonts or the status line will look all messed
  up. See https://github.com/powerline/fonts
DONE
}

main "$@"
