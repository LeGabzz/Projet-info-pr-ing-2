#!/bin/bash

# Enregistrer le temps de début de l'exécution
start_time=$(date +%s)

# Extraction des colonnes 1 et 6 séparées par des points-virgules
cut -d ';' -f1,6 data.csv > extracted_columns.csv

# Suppression des doublons de la colonne 1 et comptage des lignes uniques par personne (colonne 6)
awk -F ';' '!seen[$1,$2]++ {count[$2]++} END {for (person in count) {print count[person], person}}' extracted_columns.csv > counted_unique_lines.csv

# Tri par ordre décroissant en fonction du nombre de trajets et conservation des 10 premières lignes
sort -rn counted_unique_lines.csv | head -n 10 > sorted_top10.csv

# Affichage des 10 premières lignes du fichier résultant
cat sorted_top10.csv

# Suppression des fichiers temporaires
rm extracted_columns.csv counted_unique_lines.csv sorted_top10.csv

# Enregistrer le temps de fin de l'exécution
end_time=$(date +%s)

# Calcul du temps total d'exécution
execution_time=$((end_time - start_time))

# Affichage du temps d'exécution
echo "Temps d'exécution total : $execution_time secondes."
