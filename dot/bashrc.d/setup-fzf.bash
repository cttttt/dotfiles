if which fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude ".git" .'
elif which ag >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
else 
    export FZF_DEFAULT_COMMAND='find . -name .git -prune -o -print'
fi

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview='test -d {} || bat --style=numbers --color=always {}'"

fzf_shell_setup_scripts=(
  ~/.config/nvim/plugged/fzf/shell/{key-bindings.bash,completion.bash}
  ~/.local/share/nvim/site/pack/packer/start/fzf/shell/{key-bindings.bash,completion.bash}
  /etc/bash_completion
  /usr/share/doc/fzf/examples/key-bindings.bash
  /opt/homebrew/Cellar/fzf/*/shell/*.bash
)

for fzf_shell_setup_script in "${fzf_shell_setup_scripts[@]}"; do
  if [[ -f $fzf_shell_setup_script ]]; then
    source "$fzf_shell_setup_script"
  fi
done
