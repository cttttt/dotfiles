# OSX tcpdump is a little broken when handling files from other operarting
# systems
#
# See
# https://apple.stackexchange.com/questions/152682/why-does-tcpdump-not-recognise-piped-input

tcpdump_oss () {
  for possible_path in \
    /usr/local/bin \
    /usr/local/sbin \
    /opt/homebrew/Cellar/tcpdump/*/bin
  do
    tcpdump_path="$possible_path/tcpdump"

    if [[ -e $tcpdump_path ]]; then
      "$tcpdump_path" "$@"
      return "$?"
    fi
  done
}

tcpdump_from_router () {
  if [[ $# < 1 ]]; then
    echo "usage: $0 user@remote_host > dump.pcap"
    return 1
  fi

  local host="$1"
  shift

  ssh "$host" tcpdump -i br0 -s0 -U -w - "$@"
}
