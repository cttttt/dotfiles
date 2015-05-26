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

    for srcFile in *; do
	targetPath=$TARGET_DIR/.$srcFile
	backupPath=$BACKUP_DIR/.$srcFile

	if [ -e "$targetPath" ]; then
	     mv "$targetPath" "$backupPath" || continue
	fi

	ln -sf "$PWD/$srcFile" "$targetPath"
    done

    cat <<DONE
All done!

Remember: To install VIM plugins, run:

vim +PluginInstall +qa
DONE
}

main "$@"
