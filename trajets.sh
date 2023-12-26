#!/bin/bash

L() {
    if [ $# -eq 0 ]; then
        echo "Veuillez fournir un fichier en argument."
        exit 1
    fi

    /usr/bin/time -p cat "$1" | awk -F';' '{distance[$1] += $5} END {for (id in distance) print id, distance[id], $6}' | sort -k2 -nr | head -n 10
}

L "data.csv"



