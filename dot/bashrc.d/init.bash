init () {
  local repo_base_dir="$HOME/src/github.com/cttttt"

  if [[ $# != 1 ]]; then
    cat >&2 <<USAGE
usage: init SLUG

Initialize a Git repo under $repo_base_dir/.git, creating it if it doesn't
already exist.  To change to it, run "cd SLUG".

To run the real init, run "command init".
USAGE
    return 1
  fi

  slug="$1"

  git init "$repo_base_dir/$slug" 
  cd "$_"
}
