#!/bin/bash

function usage {
    cat << EOF
Usage: $0 [-h] rootdir

Create directory structure and copy files.

Positional arguments:
 rootdir     The root directory to create the target directory in.

Optional arguments:
 -h          Print this help message.
EOF
}

while getopts ":h" opt; do
    case ${opt} in
        h )
            usage
            exit 0
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 1
            ;;
        : )
            echo "Invalid option: -$OPTARG requires an argument" >&2
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

if [ $# -eq 0 ]
then
    echo "Error: root directory not specified"
    exit 1
fi

rootdir=$1

mkdir -p $rootdir/target/purge-backups/DEBIAN
mkdir -p $rootdir/target/purge-backups/usr/bin

cp $rootdir/src/bash/purge-backups $rootdir/target/purge-backups/usr/bin
cp $rootdir/src/debian/control $rootdir/target/purge-backups/DEBIAN
