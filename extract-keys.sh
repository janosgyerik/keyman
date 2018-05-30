#!/usr/bin/env bash
#
# Extract public keys from an authorized_keys file to separate files
#

set -euo pipefail

usage() {
    test $# = 0 || echo "$@"
    echo "Usage: $0 [OPTION]... [ARG]..."
    echo
    echo Extract public keys from an authorized_keys file to separate files
    echo
    echo Options:
    echo "  -d, --dir DIR  default = $dir"
    echo
    echo "  -h, --help     Print this help"
    echo
    exit 1
}

args=()
dir=
force=off
while [ $# != 0 ]; do
    case "$1" in
    -h|--help) usage ;;
    -d|--dir) shift; dir=$1 ;;
    -f|--force) force=on ;;
    --no-force) force=off ;;
    -) usage "Unknown option: $1" ;;
    -?*) usage "Unknown option: $1" ;;
    *) args+="$1" ;;
    esac
    shift
done

set -- "${args[@]}"

test $# = 0 && usage
test "$dir" || usage 'Error: specify the target directory using -d or --dir'

unknown_counter=0
for authorized_keys_file; do
    while read line; do
        read _ _ name <<< "$line" || :
        if ! test "$name"; then
            unknown_counter=$((unknown_counter + 1))
            name=unknown$unknown_counter
        fi

        target="$dir/$name.pub"
        if test -s $target -a $force = off; then
            echo "* file exists, skipping: $target"
        else
            echo "* writing public key to $target"
            echo "$line" > "$target"
        fi
    done < "$authorized_keys_file"
done
