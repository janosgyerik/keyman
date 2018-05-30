#!/usr/bin/env bash
#
# Download .ssh/authorized_keys from specified or configured accounts
# and extract public keys.
#

set -euo pipefail

usage() {
    test $# = 0 || echo "$@"
    echo "Usage: $0 [OPTION]... [HOST]..."
    echo
    echo Download .ssh/authorized_keys and extract public keys
    echo
    echo Options:
    echo
    echo "      --all      Download from all configured hosts (be careful!)"
    echo
    echo "  -h, --help     Print this help"
    echo
    echo "  -f, --force    Overwrite if local authorized_keys exists"
    echo
    exit 1
}

args=()
all=off
force=off
while [ $# != 0 ]; do
    case $1 in
    -h|--help) usage ;;
    --all) all=on ;;
    --no-all) all=off ;;
    -f|--force) force=on ;;
    --no-force) force=off ;;
    -) usage "Unknown option: $1" ;;
    -?*) usage "Unknown option: $1" ;;
    *) args+="$1" ;;
    esac
    shift
done

set -- "${args[@]}"

private=./private
authorizations=$private/authorizations
keys=$private/keys

cd $(dirname "$0")
mkdir -p "$authorizations"
mkdir -p "$keys"

test $all = on && set -- $(command ls $authorizations)

for remote; do
    target=$authorizations/$remote/authorized_keys
    if test -s "$target" -a $force = off; then
        echo "* file exists, skipping: $target"
        continue
    fi

    echo "* downloading authorized_keys from remote: $remote"
    targetdir=$(dirname "$target")
    mkdir -p "$targetdir"
    sftp "$remote:.ssh/authorized_keys" "$target"
    rm -f "$targetdir/"*.pub
    ./extract-keys.sh "$target" -d "$targetdir"
    ./extract-keys.sh "$target" -d "$keys"
done
