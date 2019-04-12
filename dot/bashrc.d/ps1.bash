kube_context () {
  local context
  context=$(kubectl config current-context 2>/dev/null)
  local docker_glyph=''

  if [[ $? == 0 ]]; then
    context="[${docker_glyph} ${context}]"
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

PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w $(kube_context) $(git_branch)\n\$ '
