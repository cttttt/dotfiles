load_chruby () {
  local chruby_scripts=(
    /opt/homebrew/opt/chruby/share/chruby/chruby.sh
    /opt/homebrew/opt/chruby/share/chruby/auto.sh
    /usr/local/share/chruby/auto.sh
    /usr/local/share/chruby/chruby.sh
  )

  for script in "${chruby_scripts[@]}"; do 
    if [ -f "$script" ]; then
      source "$script"
    fi
  done
}

load_chruby
