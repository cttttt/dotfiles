My Dotfiles
===========

My `.vimrc`, `.screenrc` and other miscellaneous configuration files.

Installation
============

- Install `vim`.
- Install `Vundle`:

```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

- Clone this repository somewhere.
- Install `tmux`.
- Run the `install.sh` script.
- Install the required bundles by running `vim +PlugClean! +PlugInstall
  +qa`.
- On Windows or OSX, install the [Meslo NerdFonts](https://nerdfonts.com).
- Optionally, install [editorconfig-core](https://github.com/editorconfig/editorconfig-core-c).
- Optionally, install fzf using either brew or the directions [here](https://github.com/junegunn/fzf#using-git).
- Add the following to `~/.bash_profile` or `~/.bashrc`:

```shell
if which ag >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
else 
    export FZF_DEFAULT_COMMAND='find . -name .git -prune -o -print'
fi

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
```

- Enjoy!


Maintaining
===========

- After installing, editing files in `dotfiles/` will edit dotfiles under `~`.
- Added files to `dotfiles/`?  Rerun `install.sh`.

<!--
:vim:tw:80
-->
