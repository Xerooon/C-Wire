#!/bin/bash

show_help(){
    echo ""
    echo "Parametres obligatoires:"
    echo "   - chemin vers le fichier csv d'entrée: <chemin_du_fichier_CSV>"
    echo "   - type de station à traiter (hvb, hva, lv): <type_station>"
    echo "   - type de consommateur à traiter (comp, indiv, all): <type_consommateur>"
    echo ""
    echo "Parametres optionnels:"
    echo "   - filtrer pour une centrale spécifique: [numero_centrale]"
    exit 0
}

erreur(){
    echo "Erreur"
    show_help
}

# Vérification de l'aide
if echo "$@" | grep -q "\-h"; then
    show_help
fi

# Vérification des paramètres requis
if [[ $# -lt 3 ]]; then
    echo "Pas assez d'éléments."
    show_help
fi

csv_chemin=$1
station=$2
consommateur=$3
id_centrale=$4

# Stations et consommateurs valides
Valid_station=("hvb" "hva" "lv")
Valid_consommateur=("comp" "indiv" "all")

# Validation des stations
if [[ ! " ${Valid_station[*]} " =~ " $station " ]]; then
    echo "Type de station invalide."
    show_help
fi

# Validation des consommateurs
if [[ ! " ${Valid_consommateur[*]} " =~ " $consommateur " ]]; then
    echo "Type de consommateur invalide."
    show_help
fi

# Validation de la centrale si fournie
if [[ -n "$id_centrale" && ! "$id_centrale" =~ ^[1-9][0-9]*$ ]]; then
    echo "Erreur : numéro de centrale invalide (doit être un entier positif)."
    show_help
fi

# Validation du fichier CSV
if [[ ! -f "$csv_chemin" ]]; then
    echo "Erreur : Le fichier CSV n'existe pas."
    exit 1
fi

# Définir le fichier temporaire de sortie
TEMP_FILE="filtered_${station}_${consommateur}.csv"

# Filtrage des données selon le type de station
if [[ "$station" == "lv" ]]; then
    awk -F";" -v consumer="$consommateur" '
    BEGIN { OFS=":" } 
    {
        if ($4 != "-" && $5 == "-" && $6 == "-") {
            print $1, "-", "-", $4, "-", "-", $7, "-"
        } else if ($4 != "-") {
            if (consumer == "comp" && $5 != "-") {
                print $1, "-", "-", $4, $5, "-", "-", $8
            } else if (consumer == "indiv" && $6 != "-") {
                print $1, "-", "-", $4, "-", $6, "-", $8
            } else if (consumer == "all") {
                print $1, "-", "-", $4, $5, $6, "-", $8
            }
        }
    }' "$csv_chemin" > "$TEMP_FILE"

elif [[ "$station" == "hva" ]]; then
    awk -F";" -v consumer="$consommateur" '
    BEGIN { OFS=":" } 
    {
        if ($3 != "-" && $4 == "-" && $5 == "-" && $6 == "-") {
            print $1, $2, $3, "-", "-", "-", $7, "-"
        } else if ($3 != "-" && consumer == "comp" && $5 != "-") {
            print $1, "-", $3, "-", $5, "-", "-", $8
        }
    }' "$csv_chemin" > "$TEMP_FILE"

elif [[ "$station" == "hvb" ]]; then
    awk -F";" -v consumer="$consommateur" '
    BEGIN { OFS=":" } 
    {
        if ($2 != "-" && $3 == "-" && $4 == "-" && $5 == "-" && $6 == "-") {
            print $1, $2, "-", "-", "-", "-", $7, "-"
        } else if ($2 != "-" && consumer == "comp" && $5 != "-") {
            print $1, $2, "-", "-", $5, "-", "-", $8
        }
    }' "$csv_chemin" > "$TEMP_FILE"

else
    echo "Erreur : Type de station invalide (valeurs possibles : lv, hva, hvb)."
    exit 1
fi

# Résultat
echo "Filtrage terminé. Les données ont été sauvegardées dans $TEMP_FILE."