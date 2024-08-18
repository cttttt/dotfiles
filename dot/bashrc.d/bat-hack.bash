bat () {
  if which batcat >/dev/null; then
    batcat "$@"
  fi

  command bat "$@"
}
