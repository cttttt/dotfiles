load_bash_completion () {
  for bash_completion_loader in \
    /usr/local/etc/bash_completion \
    /opt/homebrew/etc/profile.d/bash_completion.sh \
    /usr/share/bash_completion/bash_completion \
    /etc/bash_completion
  do
    if [[ -r "$bash_completion_loader" ]]; then
      source "$bash_completion_loader"
      return
    fi
  done

  complete -o default -o bashdefault helm
}

load_bash_completion
