cf_curl () {
  if [[ -z ${CF_TOKEN} ]]; then
    echo "Set CF_TOKEN envvar to your Cloudflare Access Token" >&2
    return 1
  fi

  curl -H "Authorization: Bearer ${CF_TOKEN}" -H 'Content-Type: application/json' "$@"
}
