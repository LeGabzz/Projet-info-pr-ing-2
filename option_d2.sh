#!/bin/bash

# Enregistrer le temps de début de l'exécution
start_time=$(date +%s)

# Extraction des colonnes 5 et 6 (distances et noms)
cut -d ';' -f5,6 data.csv > distances_and_names.csv

# Somme des distances par personne
awk -F ';' '{sum[$2]+=$1} END {for (person in sum) print sum[person], person}' distances_and_names.csv > summed_distances.csv

# Trier par ordre décroissant et garder les 10 premiers résultats
sort -rn summed_distances.csv | head -n 10 > top_10_distances.csv

# Affichage des 10 distances les plus grandes par personne
cat top_10_distances.csv

# Suppression des fichiers temporaires
rm distances_and_names.csv summed_distances.csv top_10_distances.csv

# Enregistrer le temps de fin de l'exécution
end_time=$(date +%s)

# Calcul du temps total d'exécution
execution_time=$((end_time - start_time))

# Affichage du temps d'exécution
echo "Temps d'exécution total : $execution_time secondes."
