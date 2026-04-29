eval "$(zoxide init zsh)"

# adds commonly accessed directories to zoxide's database
# 
# perhaps a better alternative to the cd function, that will
# encourage me to use zoxide more.
#
# note: to use `fzf` to search through zoxide, use `zi`

zoxide add ~/src

fd --hidden --no-ignore-vcs --glob '.git' ~/src | \
  sed 's|/\.git.*||' | \
  xargs -n1 zoxide add
