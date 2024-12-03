FILE="test.dat"

centrales=$(awk -F';' '$1 != "-" && $2 == "-" && $3 == "-" && $4 == "-" && $5 == "-" && $6 == "-" && $7 != "-" {count++} END {print count}' "$FILE")
stations_hvb=$(awk -F';' '$1 != "-" && $2 != "-" && $3 == "-" && $4 == "-" && $5 == "-" && $6 == "-" && $7 != "-" {count++} END {print count}' "$FILE")
consommateurs_hvb=$(awk -F';' '$1 != "-" && $2 != "-" && $3 == "-" && $4 == "-" && $5 != "-" && $6 == "-" && $8 != "-" {count++} END {print count}' "$FILE")
stations_hva=$(awk -F';' '$1 != "-" && $2 != "-" && $3 != "-" && $4 == "-" && $5 == "-" && $6 == "-" && $7 != "-" {count++} END {print count}' "$FILE")
consommateurs_hva=$(awk -F';' '$1 != "-" && $2 == "-" && $3 != "-" && $4 == "-" && $5 != "-" && $6 == "-" && $8 != "-" {count++} END {print count}' "$FILE")
postes_lv=$(awk -F';' '$1 != "-" && $2 == "-" && $3 != "-" && $4 != "-" && $5 == "-" && $6 == "-" && $7 != "-" {count++} END {print count}' "$FILE")
consommateurs_lv_entreprises=$(awk -F';' '$1 != "-" && $2 == "-" && $3 == "-" && $4 != "-" && $5 != "-" && $6 == "-" && $8 != "-" {count++} END {print count}' "$FILE")
consommateurs_lv_particuliers=$(awk -F';' '$1 != "-" && $2 == "-" && $3 == "-" && $4 != "-" && $5 == "-" && $6 != "-" && $8 != "-" {count++} END {print count}' "$FILE")

echo "Nombre de centrales électriques (Power Plants): $centrales"
echo "Nombre de stations HV-B: $stations_hvb"
echo "Nombre de consommateurs HV-B (entreprises): $consommateurs_hvb"
echo "Nombre de stations HV-A: $stations_hva"
echo "Nombre de consommateurs HV-A (entreprises): $consommateurs_hva"
echo "Nombre de postes LV: $postes_lv"
echo "Nombre de consommateurs LV (entreprises): $consommateurs_lv_entreprises"
echo "Nombre de consommateurs LV (particuliers): $consommateurs_lv_particuliers"
