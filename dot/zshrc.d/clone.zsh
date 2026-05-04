function clone () {
  local repo_type=''

  if [[ $# < 1 ]]; then
    cat <<'END'
Usage: clone REPO

Clones the provided repo to the appropriate location in ~/src/ and changes to
its directory.

Examples:

# Clones to ~/src/gitlab.com/gitlab-org/api/client-go/
#
$ clone git@gitlab.com:gitlab-org/api/client-go.git

# Clones to ~/src/github.com/cttttt/dotfiles/
#
$ clone git@github.com:ctttt/dotfiles
END
  fi

  local repo_url=$1

  if [[ ! $repo_url =~ 'git@.*:.*' ]]; then
    echo "$0: $repo_url: unknown repo url type.  Consider using the git command directly." >&2
    return 1
  fi

  local repo_host=$(sed -E 's/^git@([^:]+):.*$/\1/' <<<$repo_url)
  local repo_path=$(sed -E -e 's/^[^:]+:(.*)$/\1/' -e 's/\.git//' <<<$repo_url)

  local local_repo_dir=~/src/$repo_host/$repo_path

  if [[ -d "$local_repo_dir/.git" ]]; then
    cd "$local_repo_dir"
    return 0
  fi

  if ! mkdir -p "$local_repo_dir"; then
    echo "$0: $repo_url: could not create local repo directory" >&2
    return 1
  fi

  if ! git clone "$repo_url" "$local_repo_dir"; then
    echo "$0: $repo_url: could not clone repo" >&2
    return 1
  fi

  cd "$local_repo_dir"
}
