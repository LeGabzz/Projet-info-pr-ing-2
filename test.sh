 #!/bin/bash
time awk -F';' '{count[$1,$6]++} END {for (key in count) {split(key, data, SUBSEP); if (!seen[data[2]]) {print data[2] "; " count[key] " trajets uniques"; seen[data[2]]=1}}}' data.csv | sort -t';' -k2nr | head -n 10

