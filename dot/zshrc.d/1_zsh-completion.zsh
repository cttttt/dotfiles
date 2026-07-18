[[ -d ~/.zsh/zsh-completions/src ]] && fpath=(~/.zsh/zsh-completions/src $fpath)

if (( $+commands[brew] )); then
  fpath=("$(brew --prefix)/share/zsh-completions" $fpath)
fi

autoload -Uz compinit
compinit
