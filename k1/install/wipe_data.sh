#!/bin/sh

if [ -n "$1" ]; then
    echo "$1" | nc -U /var/run/wipe.sock
else
    echo "Invalid argument"
fi

