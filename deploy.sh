#!/bin/sh -e
#
# SCRIPT: deploy.sh
# AUTHOR: Janos Gyerik <info@titan2x.com>
# DATE:   2012-06-10
# REV:    1.0.D (Valid are A, B, D, T and P)
#               (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: Not platform dependent
#
# PURPOSE: Deploy specified profile directory on specified remote hosts
#
# set -n   # Uncomment to check your syntax, without execution.
#          # NOTE: Do not forget to put the comment back in or
#          #       the shell script will not execute!
# set -x   # Uncomment to debug this shell script (Korn shell only)
#

usage() {
    test $# = 0 || echo $@
    echo "Usage: $0 -d PROFILEDIR [OPTION]... [HOST]..."
    echo
    echo Deploy specified profile directory on specified remote hosts
    echo
    echo Options:
    echo
    echo "  -h, --help     Print this help"
    echo
    exit 1
}

args=
#arg=
#flag=off
#param=
profiledir=
while [ $# != 0 ]; do
    case $1 in
    -h|--help) usage ;;
#    -f|--flag) flag=on ;;
#    --no-flag) flag=off ;;
    -d|--profile) shift; profiledir=$1 ;;
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

test "$profiledir" || usage 'Error: specify PROFILEDIR using the -d flag'
test -d "$profiledir" || usage 'Error: directory does not exist:' $profiledir

msg() {
    echo '*' $*
}

for remote; do
    msg updating remote:$remote ...
    ls -a "$profiledir"/ | tail -n +3 | tar cp -C "$profiledir" -T- | ssh $remote tar xpv
    echo
done

# eof
