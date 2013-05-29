#!/bin/sh
#
# SCRIPT: push.sh
# AUTHOR: Janos Gyerik <info@titan2x.com>
# DATE:   2012-07-01
# REV:    1.0.D (Valid are A, B, D, T and P)
#               (For Alpha, Beta, Dev, Test and Production)
#
# PLATFORM: Not platform dependent
#
# PURPOSE: Create authorized_keys file and push to specified hosts
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

args=
#arg=
#flag=off
#param=
all=off
while [ $# != 0 ]; do
    case $1 in
    -h|--help) usage ;;
#    -f|--flag) flag=on ;;
#    --no-flag) flag=off ;;
    --all) all=on ;;
    --no-all) all=off ;;
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

cd $(dirname "$0")

test $all = on && set -- $(ls authorizations)

for remote; do
    echo '* preparing authorized_keys file for remote:'$remote
    cat $authorizations/$remote/*.pub > $authorizations/$remote/authorized_keys

    cmdfile=$authorizations/$remote/sftp.cmd
    echo '* pushing authorized_keys file to remote:'$remote
    echo put $authorizations/$remote/authorized_keys .ssh/ > $cmdfile
    sftp -b $cmdfile $remote
    rm -f $cmdfile
done

# eof
