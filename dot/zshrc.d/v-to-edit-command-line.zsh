# load the underlying function for the a zle (Zsh Line Editor) widget that
# allows the current line to be edited in an external editor.
#
# this function comes bundled with zsh, but needs to be loaded.
#
autoload -z edit-command-line

# "install" the widget into zle
#
zle -N edit-command-line

# bind this widget to the `v` key while in vi command mode (normal mode, while
# editing a command).
#
bindkey -M vicmd v edit-command-line
