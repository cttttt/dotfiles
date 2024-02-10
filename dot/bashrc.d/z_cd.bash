DEFAULT_GITHUB_ORG=${DEFAULT_GITHUB_ORG:-cttttt}

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

_cd_completion () {
  local bash_completion_exists

  if [[ $(type -t _cd) == function ]]; then
    bash_completion_exists=true
    _cd
  else
    bash_completion_exists=false
  fi

  local completing_word=${COMP_WORDS[$COMP_CWORD]}

  while read completion; do 
    if [[ $completion == $completing_word ]]; then
      return 0
    fi

    if [[ ! -n $completing_word || $completion == $completing_word* ]]; then
      COMPREPLY+=($completion)
    fi
  done < <(
    if ! $bash_completion_exists; then
      compgen -G '.*/'
    fi
    ( command cd "$HOME/src/github.com" && compgen -G '*/*/'; )
    ( command cd "$HOME/src/github.com/${DEFAULT_GITHUB_ORG}" && compgen -G '*/'; )
    ( command cd "$HOME/src" && compgen -G '*/'; )
  )
}

complete -o dirnames -o nospace -F _cd_completion cd

cd () {
  local project_dir

  if [[ $# == 0 || $1 =~ ^/+ ]]; then
    command cd "$@"
    return "$?"
  fi

  if [[ "$#" == 1 && "$1" == '...' ]]; then
    project_dir=$(find_project_dir)

    if [[ $project_dir ]]; then
      command cd "$project_dir"
    fi

    return
  fi

  local dir=$1

  local prefixes=( '.' "$HOME/src/github.com/${DEFAULT_GITHUB_ORG}" "$HOME/src/github.com" "$HOME/src" )

  for prefix in "${prefixes[@]}"; do
    local project_dir="$prefix/$dir"
    if [[ -d "$project_dir" ]]; then
      command cd "$project_dir"
      return "$?"
    fi
  done

  command cd "$@"
}
