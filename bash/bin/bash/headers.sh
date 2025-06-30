#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# pipefail http://redsymbol.net/articles/unofficial-bash-strict-mode/
# https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425


# Sometimes programs can fail with SIGPIPE which breaks pipefail
# but || true will not work!
igpipe() {
  case $- in
    *e*) set +e; (set -e; "$@"); set -e -- $? ;;
    *) ("$@"); set -- $? ;;
  esac
  [ "$1" -ge 128 ] || return "$1"
  [ "$(kill -l "$1")" = PIPE ] || return "$1"
}
