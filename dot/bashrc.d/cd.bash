cd () {
  if [[ $# == 0 ]]; then
    command cd "$@"
    return "$?"
  fi

  local dir=$1

  local prefixes=( '.' "$HOME/src/github.com/cttttt" "$HOME/src/github.com" "$HOME/src/$dir" )

  for prefix in "${prefixes[@]}"; do
    local project_dir="$prefix/$dir"
    if [[ -d "$project_dir" ]]; then
      command cd "$project_dir"
      return "$?"
    fi
  done

  command cd "$@"
}
