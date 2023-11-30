#!/bin/bash

NAME="subvar"
LASTUPDATE="qui 30 nov 2023 20:45:15 -03"
TIMESTAMP="1701387915"
VERSION="0.0.1-dev.$TIMESTAMP"
AUTHOR="Jackson Bicalho <jacksonbicalho@gmail.com>"
HOMEPAGE="https://github.com/jacksonbicalho/subvar.sh"

REQUIRES=("VARIABLE" "SIGN" "NEW" "FILE")

#################
# display_header
#################
display_header() {
    echo
    echo "---------------"
    echo "-- $NAME --"
    echo "---------------"
}

#################
# Help                                                     #
#################

help() {
    display_header
    echo "Usage: $(basename $0) --variable enabled --sign = --new 1 --file /path/to/file.txt"
    echo
    echo "options:"
    echo "-h --help      Print this Help."
    echo "-V --version   Display version"
    echo
    echo "arguments:"
    echo "-v --variable  variable_name"
    echo "-s --sign      [:, =, ?]"
    echo "-n --new       new_value"
    echo "-f --file      /path/to/file.txt"
    echo
}

#################
# display_version
#################
display_version() {
    display_header
    echo "Version: $VERSION"
    echo "Last update: $LASTUPDATE"
    echo "Homepage: $HOMEPAGE"
    echo "Author: $AUTHOR"
    echo
}

OPTIONS=("--version" "-V" "-h" "--help")
ARGUMENTS=("--variable" "-v" "--sign" "-s" "--new" "-n" "--file" "-f")
for var in "$@"; do
    if [[ ${OPTIONS[@]} =~ $var ]]; then
        case $var in
        -h | --help)
            help
            exit
            ;;
        -V | --version)
            display_version
            exit
            ;;
        esac
    fi

    if [[ ${ARGUMENTS[@]} =~ $var ]]; then
        case $var in
        --variable | -v)
            VARIABLE=$2
            shift 2
            ;;
        --sign | -s)
            SIGN=$2
            shift 2
            ;;
        --new | -n)
            NEW=$2
            shift 2
            ;;
        --file | -f)
            FILE=$2
            shift 2
            ;;
        esac
    fi
done

for REQUIRE in ${REQUIRES[@]}; do
    if [[ ! -v $REQUIRE ]]; then
        if [ $REQUIRE == "FILE" ] && [ -e "$1" ]; then
            FILE=$1
            continue
        fi
        echo "$NAME: $REQUIRE must be informed"
        help
        exit
    fi
done

sed -i "s/^\($VARIABLE\)[[:blank:]]*${SIGN}.*/\1${SIGN}${NEW}/" ${FILE}
