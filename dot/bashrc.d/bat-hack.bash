bat () {
  if which batcat >/dev/null; then
    exec batcat "$@"
  fi

  exec bat "$@"
}
