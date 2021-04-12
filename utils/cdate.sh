#!/bin/bash

function print_help() {
    cat ../docs/cdate.txt
}

if [ "$1" = 'iso_timestamp' ]; then
    iso_date=$2
    python3 <<HEREDOC
import datetime
datefromiso = datetime.datetime.fromisoformat('$iso_date')
print(datefromiso.timestamp())
HEREDOC
fi

if [  "$#" -lt 1 ] ; then
    print_help
fi
