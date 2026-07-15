function clone () {
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

  local parsed_repo_url
  parsed_repo_url=$(clone_parse_url "$1")

  if [[ $? != 0 ]]; then
    echo "$0: $1: Unknown repo url type.  Consider using the git command directly." >&2
    return 1
  fi

  local repo_host=$(jq -r .host <<<$parsed_repo_url)
  local repo_path=$(jq -r .path <<<$parsed_repo_url)
  local repo_url=$(jq -r .normalized_git_over_ssh_url <<<$parsed_repo_url)

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

function clone_parse_url () {
  # Emits a JSON object describing the provided Git repository URL
  #
  # {
  #   "host": "The repository host (e.g. github.com, gitlab.com)"
  #   "path": "The repository's canonical name (e.g. cttttt/dotfiles)"
  #   "normalized_git_over_ssh_url": "The repository's canonical remote URL"
  # }
  #
  # e.g.
  #
  # $ clone_parse_url https://github.com/cttttt/dotfiles
  # {
  #   "host": "github.com",
  #   "path": "cttttt/dotfiles",
  #   "normalized_git_over_ssh_url": "git@github.com:cttttt/dotfiles"
  # }
  #
  #
  local repo_url=$1
  
  ruby - "$repo_url" <<'DONE'
require 'json'

repo_url = ARGV[0]

repo = {}

GITHUB_HTTP_URL=%r{^https://(?<host>github.com)/(?<path>.*?/.*?)(.git)?(/|/blob.*)?$}

if match = GITHUB_HTTP_URL.match(repo_url)
  repo['host'] = match[:host]
  repo['path'] = match[:path]
end

GITLAB_HTTP_URL=%r{^https://(?<host>gitlab.com)/(?<path>.*?/.*?)(/?|/-/.*)$}

if match = GITLAB_HTTP_URL.match(repo_url)
  repo['host'] = match[:host]
  repo['path'] = match[:path]
end

GIT_OVER_SSH_URL=%r{^git@(?<host>.*?):(?<path>.*)$}

if match = GIT_OVER_SSH_URL.match(repo_url)
  repo['host'] = match[:host]
  repo['path'] = match[:path]
end

raise "Could not parse URL: #{ARGV[0]}" if repo.empty?

repo['normalized_git_over_ssh_url'] = 'git@%s:%s' % [repo['host'], repo['path']]

puts repo.to_json
DONE
}

