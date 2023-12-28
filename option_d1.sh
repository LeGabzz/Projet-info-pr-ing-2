#!/bin/bash
cut -d ';' -f1,6 data.csv > extracted_columns.csv
awk -F ';' '!seen[$1,$2]++ {count[$2]++} END {for (person in count) {print count[person], person}}' extracted_columns.csv > counted_unique_lines.csv
sort -rn counted_unique_lines.csv | head -n 10 > sorted_top10.csv
rm counted_unique_lines.csv extracted_columns.csv
