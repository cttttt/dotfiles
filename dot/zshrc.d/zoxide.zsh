eval "$(zoxide init zsh)"

# adds commonly accessed directories to zoxide's database
# 
# perhaps a better alternative to the cd function, that will
# encourage me to use zoxide more.
#
# note: to use `fzf` to search through zoxide, use `zi`

zoxide add ~/src

precmd_functions+=('add_git_repos_to_zoxide')

add_git_repos_to_zoxide_list_cloned_git_repos () {
  fd --hidden --no-ignore-vcs --glob '.git' --prune ~/src
}

add_git_repos_to_zoxide () {
  add_git_repos_to_zoxide_list_cloned_git_repos | \
    sed 's|/\.git.*||' | \
    xargs -n1 zoxide add
}
