open() {
  local subcommand=$1

  case "$subcommand" in
    pr)
      open_pr "$@"
      ;;
    *)
      command open "$@"
      ;;
  esac
}

open_pr() {
  local tracking_branch
  tracking_branch=$(tracking_branch)

  if [[ $? != 0 ]]; then
    cat >&2 <<MSG
Could not determine the tracking branch

- are you in a git working directory?
- has this branch been pushed to Github?
MSG
    return 1
  fi

  local remote=${tracking_branch%/*}

  local remote_url
  remote_url=$(git remote get-url "$remote")

  if [[ $? != 0 ]]; then
    echo "Could not determine the git remote url" >&2
    return 1
  fi

  local branch
  branch=$(git rev-parse --abbrev-ref --symbolic-full-name HEAD)

  if [[ $? != 0 ]]; then
    echo "Could not determine the name of the current branch" >&2
    return 1
  fi

  local repo_slug=

  case "$remote_url" in
    git@github.com:*/*)
      repo_slug=${remote_url#git@github.com:}
      ;;
    http://github.com/*/*)
      repo_slug=${remote_url#http://github.com/}
      repo_slug=${repo_slug%/}
      ;;
    https://github.com/*/*)
      repo_slug=${remote_url#https://github.com/}
      repo_slug=${repo_slug%/}
      ;;
    *)
      echo "Not sure how to open a pr on the remote, $remote_url" >&2
      return 1
  esac

  local repo_url="https://github.com/$repo_slug/pull/new/$branch"

  if which open >/dev/null 2>&1; then
    open "$repo_url"
  else
    echo "$repo_url"
  fi
}

tracking_branch() {
  git rev-parse --abbrev-ref --symbolic-full-name @{u}
}
