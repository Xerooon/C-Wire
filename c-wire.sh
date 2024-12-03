INPUT_FILE="c-wire_v00.dat"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Fichier $INPUT_FILE introuvable."
    exit 1
fi

echo "Choisissez la colonne de tri :"
echo "1. Power plant"
echo "2. HV-B Station"
echo "3. HV-A Station"
echo "4. LV Station"
echo "5. Company"
echo "6. Individual"
echo "7. Capacity"
echo "8. Load"

read -p "Entrez le numéro de la colonne (1-8) : " COLUMN_CHOICE

if ! [[ "$COLUMN_CHOICE" =~ ^[1-8]$ ]]; then
    echo "Choix invalide. Entrez un nombre entre 1 et 8."
    exit 1
fi

COLUMN_SORT=$((COLUMN_CHOICE))

OUTPUT_FILE="sorted_data.csv"
echo "Tri des données en cours..."

sort -t ';' -k "$COLUMN_SORT" "$INPUT_FILE" > "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Les données ont été triées avec succès et enregistrées dans $OUTPUT_FILE."
else
    echo "Une erreur est survenue lors du tri des données."
fi
