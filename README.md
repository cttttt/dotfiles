# My Dotfiles

My `.vimrc`, `.screenrc` and other miscellaneous configuration files.

# Installation

- Run `rake`
- On Windows or OSX, install the [FuraMono NerdFont](https://nerdfonts.com).
- Optionally, install [editorconfig-core](https://github.com/editorconfig/editorconfig-core-c).
- Enjoy!


# Maintaining

- After installing, editing files in `dotfiles/` will edit dotfiles under `~`.
- Added files to `dotfiles/`?  Rerun `rake`.

# Testing

- To test, run `docker run -ti "$(docker build -q .)"`.  The resulting
  container will have `vim`, `fzf`, and gang installed and configured.
