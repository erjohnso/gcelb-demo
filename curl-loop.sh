#!/bin/bash
# usage: curl-loop.sh GCELB-IPAddress

if [ -n "$1" ]; then
    while [ 1 ]
    do
        curl -s http://$1
        sleep .5
    done
fi

echo "usage: curl-loop.sh IP-address"
exit 1
