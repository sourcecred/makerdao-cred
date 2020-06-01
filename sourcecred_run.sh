#!/bin/sh

set -eu

# requires that the user has set a SC_REPO_DIR environment variable
# and it points to a repository containing sourcecred, where `yarn backend`
# has been run to build the CLI.
# requires that this script be run from the root of the makerdao-cred repo

main() {
  DEMO_DIR=$(pwd)
  SITE_DIR="$DEMO_DIR/docs"
  if ! [ -d "${SITE_DIR}" ]; then
    die "Can't find site dir; probably running script from wrong location"
  fi

  SOURCECRED_CLI="$SC_REPO_DIR/bin/sourcecred.js"
  if ! [ -f "${SOURCECRED_CLI}" ]; then
    die "Can't find sourcecred CLI"
  fi
  export SOURCECRED_DIRECTORY="$DEMO_DIR/sourcecred_data"

  node "$SOURCECRED_CLI" discourse https://forum.makerdao.com

  (cd "$SC_REPO_DIR" && yarn build --output-path "$SITE_DIR")
  mkdir -p "$SITE_DIR/api/v1"
  cp -r "$SOURCECRED_DIRECTORY" "$SITE_DIR/api/v1/data"
  rm -rf "$SITE_DIR/api/v1/data/cache"
  cp "$DEMO_DIR/CNAME" "$SITE_DIR"
}

die() {
    printf >&2 'fatal: %s\n' "$@"
    exit 1
}

main
