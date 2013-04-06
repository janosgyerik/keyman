#!/bin/sh
#
# SCRIPT: extract-keys.sh
# AUTHOR: Janos Gyerik <info@titan2x.com>
# DATE:   2012-07-01
# REV:    1.0.D (Valid are A, B, D, T and P)
#               (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: Not platform dependent
#
# PURPOSE: Extract public keys from an authorized_keys file to separate files
#
# set -n   # Uncomment to check your syntax, without execution.
#          # NOTE: Do not forget to put the comment back in or
#          #       the shell script will not execute!
# set -x   # Uncomment to debug this shell script (Korn shell only)
#

usage() {
    test $# = 0 || echo $@
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

args=
#arg=
#flag=off
#param=
dir=
force=off
while [ $# != 0 ]; do
    case $1 in
    -h|--help) usage ;;
#    -f|--flag) flag=on ;;
#    --no-flag) flag=off ;;
#    -p|--param) shift; param=$1 ;;
    -d|--dir) shift; dir=$1 ;;
    -f|--force) force=on ;;
    --no-force) force=off ;;
#    --) shift; while [ $# != 0 ]; do args="$args \"$1\""; shift; done; break ;;
    -) usage "Unknown option: $1" ;;
    -?*) usage "Unknown option: $1" ;;
    *) args="$args \"$1\"" ;;  # script that takes multiple arguments
#    *) test "$arg" && usage || arg=$1 ;;  # strict with excess arguments
#    *) arg=$1 ;;  # forgiving with excess arguments
    esac
    shift
done

eval "set -- $args"  # save arguments in $@. Use "$@" in for loops, not $@ 

test $# -gt 0 || usage
test "$dir" || usage 'Error: specify the target directory using -d or --dir'

for authorized_keys_file; do
    while read line; do
        name=$(echo $line | awk '{print $NF}')
        target="$dir/$name.pub"
        if test -s $target -a $force = off; then
            echo '* file exists, skipping:' $target
        else
            echo '* writing public key to '$target
            echo $line > $target
        fi
    done < "$authorized_keys_file"
done

# eof
