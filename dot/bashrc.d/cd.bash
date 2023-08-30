find_project_dir_helper () {
  if [[ -d '.git' ]]; then
    pwd
    return
  fi

  if [[ $PWD == '/' ]]; then
    return
  fi

  command cd ..
  find_project_dir
}

find_project_dir () {
  ( find_project_dir_helper; )
}

cd () {
  local project_dir

  if [[ $# == 0 || $1 =~ ^/+ ]]; then
    command cd "$@"
    return "$?"
  fi

  if [[ "$#" == 1 && "$1" == '...' ]]; then
    project_dir=$(find_project_dir)

    if [[ $project_dir ]]; then
      cd "$project_dir"
    fi

    return
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
