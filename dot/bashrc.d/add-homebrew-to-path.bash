# Use path array in zsh, but standard PATH export in bash
if [[ -n $ZSH_VERSION ]]; then
  typeset -U path
  path=($path /opt/homebrew/sbin /opt/homebrew/bin)
else
  export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:$PATH"
fi
