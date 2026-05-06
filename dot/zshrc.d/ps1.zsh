kube_context () {
  local context
  local docker_glyph=''
  context=$(kubectl config current-context 2>/dev/null)

  if [[ $? == 0 ]]; then
    context="[${docker_glyph} ${context}] "
  else
    context=""
  fi

  echo "$context"
}

git_branch () {
  local branch
  local git_nerd_glyph=''

  branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  
  if [[ $? == 0 ]]; then
    branch="[${git_nerd_glyph} ${branch}]"
  else
    branch=""
  fi

  echo "$branch"
}

setopt PROMPT_SUBST

NEWLINE=$'\n'
PROMPT='${debian_chroot:+($debian_chroot)}$USERNAME@%m:%/ $(kube_context)$(git_branch)$NEWLINE\$ '

preexec () {
  echo -n "\\x1b]133;A\\x1b\\"
}
