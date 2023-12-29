#!/bin/bash


if [ ! -f "data.csv" ]; then
    echo "Le fichier data.csv n'existe pas."
    exit 1
fi
start_time=$(date +%s) 

awk -F';' 'NR > 1 { distances[$1]+=$5 } END { for (route in distances) print route, distances[route] }' data.csv \
    | sort -t' ' -k2,2nr \
    | head -n 10 \
    | awk '{ print "Route ID: " $1, "Distance totale: " $2 }'

end_time=$(date +%s)
execution_time=$((end_time - start_time))
echo "Temps d'exécution total : $execution_time secondes."

