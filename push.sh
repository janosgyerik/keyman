#!/usr/bin/env bash
#
# Create authorized_keys file and push to specified hosts
#

set -euo pipefail

usage() {
    test $# = 0 || echo "$@"
    echo "Usage: $0 [OPTION]... [HOST]..."
    echo
    echo Create authorized_keys file and push to specified hosts
    echo
    echo Options:
    echo
    echo "      --all      Push to all configured hosts (be careful!)"
    echo
    echo "  -h, --help     Print this help"
    echo
    exit 1
}

args=()
all=off
while [ $# != 0 ]; do
    case $1 in
    -h|--help) usage ;;
    --all) all=on ;;
    --no-all) all=off ;;
    -) usage "Unknown option: $1" ;;
    -?*) usage "Unknown option: $1" ;;
    *) args+=("$1") ;;
    esac
    shift
done

set -- "${args[@]}"

private=./private
authorizations=$private/authorizations

cd $(dirname "$0")

test $all = on && set -- $(ls $authorizations)

for remote; do
    echo "* preparing authorized_keys file for remote: $remote"
    cat "$authorizations/$remote"/*.pub > "$authorizations/$remote/authorized_keys"

    cmdfile=$authorizations/$remote/sftp.cmd
    echo "* pushing authorized_keys file to remote: $remote"
    echo "put $authorizations/$remote/authorized_keys .ssh/" > "$cmdfile"
    sftp -b "$cmdfile" "$remote"
    rm -f "$cmdfile"
done
