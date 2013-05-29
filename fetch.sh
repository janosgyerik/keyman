#!/bin/sh -e
#
# SCRIPT: fetch.sh
# AUTHOR: Janos Gyerik <info@titan2x.com>
# DATE:   2012-07-01
# REV:    1.0.D (Valid are A, B, D, T and P)
#               (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: Not platform dependent
#
# PURPOSE: Download .ssh/authorized_keys from specified or configured
#          accounts and extract public keys.
#
# set -n   # Uncomment to check your syntax, without execution.
#          # NOTE: Do not forget to put the comment back in or
#          #       the shell script will not execute!
# set -x   # Uncomment to debug this shell script (Korn shell only)
#

usage() {
    test $# = 0 || echo $@
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

args=
#arg=
#flag=off
#param=
all=off
force=off
while [ $# != 0 ]; do
    case $1 in
    -h|--help) usage ;;
#    -f|--flag) flag=on ;;
#    --no-flag) flag=off ;;
    --all) all=on ;;
    --no-all) all=off ;;
    -f|--force) force=on ;;
    --no-force) force=off ;;
#    -p|--param) shift; param=$1 ;;
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

authorizations=./authorizations
keys=./keys

cd $(dirname "$0")
mkdir -p $authorizations

test $all = on && set -- $(ls $authorizations)

for remote; do
    target=$authorizations/$remote/authorized_keys
    if test -s $target -a $force = off; then
        echo '* file exists, skipping:' $target
        continue
    else
        echo '* downloading authorized_keys from remote:'$remote
        targetdir=$(dirname "$target")
        mkdir -p $targetdir
        sftp $remote:.ssh/authorized_keys $target
        rm -f $targetdir/*.pub
        ./extract-keys.sh $target -d $targetdir
        ./extract-keys.sh $target -d $keys
    fi
done

# eof
