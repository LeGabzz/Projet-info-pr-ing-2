#!/bin/bash

# Define functions
print_help() {
    echo "Help function executed."
    echo "Usage: $0 data_path [options]"
    echo "Options:"
    echo "  -h    Show this help message and exit."
    echo "  -d    Execute the 'exec_d' function with argument '1' or '2'."
    echo "  -l    Execute the 'exec_l' function."
    echo "  -t    Execute the 'exec_t' function."
    echo "  -s    Execute the 'exec_s' function."
}


exec_d1() {
    # Enregistrer le temps de début de l'exécution
    start_time=$(date +%s)

    echo "Conducteurs avec le plus trajets"

    cut -d ';' -f1,6 data.csv > extracted_columns.csv

    # Suppression des doublons de la colonne 1 et comptage des lignes uniques par personne (colonne 6)
    awk -F ';' '!seen[$1,$2]++ {count[$2]++} END {for (person in count) {print count[person], person}}' extracted_columns.csv > counted_unique_lines.csv

    # Tri par ordre décroissant en fonction du nombre de trajets et conservation des 10 premières lignes
    sort -rn counted_unique_lines.csv | head -n 10 > sorted_top10.csv

    # Affichage des 10 premières lignes du fichier résultant
    cat sorted_top10.csv > output_d1.txt

    # Suppression des fichiers temporaires
    rm extracted_columns.csv counted_unique_lines.csv sorted_top10.csv

    # Enregistrer le temps de fin de l'exécution
    end_time=$(date +%s)

    # Calcul du temps total d'exécution
    execution_time=$((end_time - start_time))

    # Affichage du temps d'exécution
    echo "Temps d'exécution total : $execution_time secondes."

    # Exécuter les commandes Gnuplot
    gnuplot -persist <<-PLOT
set terminal png size 900,700
set output 'images/conducteurs_d1_histogramme.png'
set ylabel 'TOP 10 CONDUCTEURS AVEC LE PLUS DE TRAJETS'
set y2label 'NB ROUTES' offset 3,0
set xtics font "Arial, 11" 
set xlabel 'DRIVERS NAMES' rotate by  180 offset character 0, -11, 0
set style data histograms
set xtic rotate by 90 scale 0 offset character 0, -11, 0
set style fill solid 0.5 border -1
set boxwidth 0.5
set ytics rotate by 90 
set grid ytics
set yrange [0:*]
set size 0.6, 1
set datafile separator " "
set lmargin 10
set bmargin 15
set rmargin 0
set tmargin 5
plot "/home/Projet_info/output_d1.txt" using 1:xticlabels(sprintf("%s %s", stringcolumn(3), stringcolumn(2))) notitle lc rgb "blue" with boxes
PLOT
convert images/conducteurs_d1_histogramme.png -rotate 90 images/conducteurs_d1_histogramme.png
}

exec_d2() {

    # Enregistrer le temps de début de l'exécution
    start_time=$(date +%s)

    echo "Conducteurs avec la plus grande distance"

    # Extraction des colonnes 5 et 6 (distances et noms)
    cut -d ';' -f5,6 data.csv > distances_and_names.csv

    # Somme des distances par personne
    awk -F ';' '{sum[$2]+=$1} END {for (person in sum) print sum[person], person}' distances_and_names.csv > summed_distances.csv

    # Trier par ordre décroissant et garder les 10 premiers résultats
    sort -rn summed_distances.csv | head -n 10 > top_10_distances.csv

    # Affichage des 10 distances les plus grandes par personne
    cat top_10_distances.csv > outputd2.txt

    # Suppression des fichiers temporaires
    rm distances_and_names.csv summed_distances.csv top_10_distances.csv

    # Enregistrer le temps de fin de l'exécution
    end_time=$(date +%s)

    # Calcul du temps total d'exécution
    execution_time=$((end_time - start_time))

    # Affichage du temps d'exécution
    echo "Temps d'exécution total : $execution_time secondes."
    
    echo ""
    gnuplot -persist <<-PLOT
set terminal png size 900,700
set output 'images/conducteurs_d2_histogramme.png'
set ylabel 'TOP 10 Conducteurs avec le plus de trajets'
set y2label 'NB Routes' offset 3,0
set xtics font "Times New Roman, 12"
set ytics font "Times New Roman, 6" 
set xlabel 'DRIVERS NAMES' rotate by  180 offset character 0, -11, 0
set style data histograms
set xtic rotate by 90 scale 0 offset character 0, -11, 0
set style fill solid 0.5 border -1
set boxwidth 0.5
set ytics rotate by 90 
set grid ytics
set yrange [0:*]
set size 0.6, 1
set datafile separator " "
set lmargin 10
set bmargin 15
set rmargin 0
set tmargin 5
plot "/home/Projet_info/outputd2.txt" using 1:xticlabels(sprintf("%s %s", stringcolumn(3), stringcolumn(2))) notitle lc rgb "blue" with boxes
PLOT
convert images/conducteurs_d2_histogramme.png -rotate 90  images/conducteurs_d2_histogramme.png
}

exec_l() {
    start_time=$(date +%s)
    echo "10 trajets les plus longs
    "
    
    awk -F';' 'NR > 1 { distances[$1]+=$5 } END { for (route in distances) print route, distances[route] }' data.csv \
    | sort -t' ' -k2,2nr \
    | head -n 10 \
    | awk '{ print $1, $2 }'> outputl.txt
    end_time=$(date +%s)
    execution_time=$((end_time - start_time))
    echo "Temps d'exécution total : $execution_time secondes."
    echo "
    "
    gnuplot -persist <<-PLOT

set terminal png
set output 'images/Trajet_Distance.png'
set ylabel 'Distance (en km)'
set xlabel 'ROUTE ID'
set title 'Top 10 trajets les plus long'
set style data histograms
set style fill solid 1.0 border -1
set boxwidth 1
set grid ytics
set xtics rotate by -45
set yrange [0:*]
set datafile separator " "
plot '/home/Projet_info/outputl.txt' using 2:xtic(1) notitle lc rgb "green"
PLOT
}

build_c() {
    cd "./progc"
    if [ ! -d "./build" ]; then
        mkdir "./build"
    fi
    cd "./build"

    rm -r ./*

    cmake ..
    cmake --build .

    chmod +x projetG

    cd "../../"
}

exec_t() {
    build_c
    ./progc/build/projetG $data_path T
    gnuplot -persist <<-EOF
    set terminal png size 1000,800  
    set output 'images/option_t_graph.png'
    set ylabel 'NB Routes'
    set xlabel 'Noms des villes'
    set title 'OPTION-T'
    set style data histograms
    set style histogram cluster gap 1
    set style fill solid 1.0 border -1
    set boxwidth 1 relative
    set datafile separator ";"
    set xtics rotate by -50 font ",12"  # Adjust font size if necessary
    set lmargin 10 
    set rmargin 10  
    set tmargin 5  
    set bmargin 9   
    set grid y
    set yrange [0:3500]  # Set y-axis range
    plot '/home/Projet_info/output.txt' using 2:xticlabels(1) title 'Town Routes' lc rgb "blue", '' using 3 title 'First Town' lc rgb "skyblue"
EOF

exit 0
}

exec_s() {
	chmod +x output.txt
	chmod +x outputT.txt
  build_c
  ./progc/build/projetG $data_path S
  # Script Gnuplot

  awk -F ';' '{print $0, $1, $2, $3 }' output.txt > outputT.txt
if [ ! -s outputT.txt ]; then
    echo "Erreur : Le fichier de données est vide ou n'existe pas."
    exit 2
fi

gnuplot -persist <<-EOF
    set terminal png size 1400, 600
    set output 'images/option_s_graph.png'
    set ylabel 'Distance (km)'
    set xlabel 'ROUTE ID'
    set title 'Option -s: Distance f(Route)'
    set xtics rotate by -90
    set key outside
    set style data lines
    set yrange [0:*]
    unset xrange
    set datafile separator " "
    plot 'outputT.txt' using 2:xtic(1) title 'Distance average (Km)' with lines, \
         'outputT.txt' using 3:xtic(1) title 'Distances Max (Km)' with lines, \
         'outputT.txt' using 4:xtic(1) title 'Distances Min (Km)' with lines
EOF

exit 0
}

if [ $# -lt 1 ]; then
  echo "Error: Missing mandatory argument 'data_path'."
  echo "Usage: $0 data_path [options]"
  exit 1
fi

for arg in "$@"; do
  if [ "$arg" = "-h" ]; then
    print_help
    exit 0
  fi
done

data_path=$1
echo "Data path set to: $data_path"

if [ ! -d "./temp" ]; then
    mkdir "./temp"
#elif [ -z "$(ls -A ./temp)" ]; then
 #   rm -r ./temp/*
fi

if [ ! -d "./images" ]; then
    mkdir "./images"
fi

if [ ! -d "./progc" ]; then
    exit 0
fi

shift

while getopts "hd:lts" opt; do
    case $opt in
        d)
            if [ "$OPTARG" = "1" ]; then
                exec_d1
            elif [ "$OPTARG" = "2" ]; then
                exec_d2
            else
                echo "Invalid argument for -d: $OPTARG"
            fi
            ;;
        l)
            exec_l
            ;;
        t)
            exec_t
            ;;
        s)
            exec_s
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            ;;
    esac
done

