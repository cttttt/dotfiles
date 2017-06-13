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

    cat <<'DONE'
All done!

Remember: 

- Before installing plugins, install Vundle:

  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

- To install VIM plugins, run:

  vim +PlugInstall +qa

- You should install Powerline fonts or the status line will look all messed
  up. See [Meslo NerdFonts](https://nerdfonts.com).

- You should also install [editorconfig-core](https://github.com/editorconfig/editorconfig-core-c).

- You should install fzf using either brew or the directions [here](https://github.com/junegunn/fzf#using-git).

- You should add the following to your ~/.bash_profile or ~/.bashrc:

```
if which ag >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
else 
    export FZF_DEFAULT_COMMAND='find . -name .git -prune -o -print'
fi

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
```

- You should, do other interesting things.

- As a final step, say hi to someone today.

- For real.  A final step.
DONE
}

main "$@"
