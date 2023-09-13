clone_usage() {
    cat >&2 <<USAGE
usage: clone [ -d DEPTH ] (USER@[HOST:[ORG/[SLUG]]])

Clones the provided repo and changes to its working directory.

Options:

  -d DEPTH  How many commits deep should be cloned
USAGE
}

clone () {
  local user=git
  local host=github.com
  local org=cttttt
  local slug=
  declare -a depth

  while getopts ':d:' curopt; do
    case $curopt in
      d)
        depth_option=( --depth $OPTARG )
        ;;
      *)
        clone_usage
        return 1
        ;;
    esac
  done

  shift $((OPTIND - 1))

  if [[ $# != 1 ]]; then
    clone_usage
    return 1
  fi

  local repo=$1

  while true; do
    if [[ "$repo" =~ ^.+?@.+?:.+?/.+$ ]]; then
      user="${repo%%@*}"
      repo="${repo#*@}"
    elif [[ "$repo" =~ ^.+?:.+?/.+$ ]]; then
      host="${repo%%:*}"
      repo="${repo#*:}"
    elif [[ "$repo" =~ ^.+/.+$ ]]; then
      org="${repo%%/*}"
      repo="${repo#*/}"
    else
      slug="$repo"
      break
    fi
  done

  local repo="$user@$host:$org/$slug"
  local path="$HOME/src/$host/$org/$slug"

  if [[ -d "$path" ]]; then
    if [[ -d "$path/.git" ]]; then
      local existing_origin=$(git -C "$path" remote get-url origin)

      if [[ $? != 0 ]]; then
        echo "could not determine existing origin in the existing repo in $path" >&2
        return 1
      fi

      if [[ ! ( $existing_origin == $repo || $existing_origin == "$repo.git" ) ]]; then
        { cat | fold -w 80 -s; }  >&2 <<DONE

Changing to the existing repo in ~${path#$HOME}

NOTE: This repo's origin upstream is currently set to $existing_origin.

Run the following to set the origin to $repo:

git remote set-url origin '$repo'

DONE
      fi
    else
      echo "$path already exists and is not a repo" >&2
      return 1
    fi
  else
    if ! git clone "${depth_option[@]}" "$repo" "$path"; then
      echo "could not clone $1" >&2
      return 1
    fi
  fi

  cd "$path"
}
