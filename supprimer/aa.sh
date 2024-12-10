#!/bin/bash

# Paramètres d'entrée
INPUT_FILE=$1   # Chemin du fichier d'entrée CSV
TYPE=$2         # Type de station (lv, hva, hvb)
CONSUMER=$3     # Type de consommateur (comp, indiv, all)
TEMP_DIR="tmp"  # Dossier temporaire

# Vérifications initiales
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Erreur : Le fichier $INPUT_FILE n'existe pas."
    exit 1
fi

if [[ -z "$TYPE" || -z "$CONSUMER" ]]; then
    echo "Erreur : Type de station ou consommateur non spécifié."
    echo "Usage : $0 <input_file> <type (lv, hva, hvb)> <consumer (comp, indiv, all)>"
    exit 1
fi

# Création du dossier temporaire s'il n'existe pas
mkdir -p "$TEMP_DIR"

# Vérifications des actions interdites
if [[ "$TYPE" == "hvb" && ("$CONSUMER" == "all" || "$CONSUMER" == "indiv") ]]; then
    echo "Erreur : Les actions 'hvb all' et 'hvb indiv' sont interdites."
    exit 1
fi

if [[ "$TYPE" == "hva" && ("$CONSUMER" == "all" || "$CONSUMER" == "indiv") ]]; then
    echo "Erreur : Les actions 'hva all' et 'hva indiv' sont interdites."
    exit 1
fi

# Définir le fichier temporaire de sortie
TEMP_FILE="$TEMP_DIR/${TYPE}_${CONSUMER}_filtered.csv"

# Filtrage des données
if [[ "$TYPE" == "lv" ]]; then
    awk -F";" -v consumer="$CONSUMER" '
    BEGIN {
        OFS=":" # Séparateur de sortie
    }
    {
        # Lignes des postes LV avec leur capacité
        if ($4 != "-" && $5 == "-" && $6 == "-") {
            print $1, "-", "-", $4, "-", "-", $7, "-" # Station LV avec capacité
        }
        # Consommateurs LV (entreprises ou particuliers)
        else if ($4 != "-") {
            if (consumer == "comp" && $5 != "-") {
                print $1, "-", "-", $4, $5, "-", "-", $8 # Entreprises connectées
            } 
            else if (consumer == "indiv" && $6 != "-") {
                print $1, "-", "-", $4, "-", $6, "-", $8 # Particuliers connectés
            }
            else if (consumer == "all") {
                print $1, "-", "-", $4, $5, $6, "-", $8 # Tous les consommateurs
            }
        }
    }' "$INPUT_FILE" > "$TEMP_FILE"

elif [[ "$TYPE" == "hva" ]]; then
    awk -F";" -v consumer="$CONSUMER" '
    BEGIN {
        OFS=":" # Séparateur de sortie
    }
    {
        # Lignes des stations HV-A avec leur capacité
        if ($3 != "-" && $4 == "-" && $5 == "-" && $6 == "-") {
            print $1, $2, $3, "-", "-", "-", $7, "-" # Station HV-A avec capacité
        }
        # Consommateurs HV-A (entreprises uniquement)
        else if ($3 != "-" && consumer == "comp" && $5 != "-") {
            print $1, "-", $3, "-", $5, "-", "-", $8 # Entreprises connectées
        }
    }' "$INPUT_FILE" > "$TEMP_FILE"

elif [[ "$TYPE" == "hvb" ]]; then
    awk -F";" -v consumer="$CONSUMER" '
    BEGIN {
        OFS=":" # Séparateur de sortie
    }
    {
        # Lignes des stations HV-B avec leur capacité
        if ($2 != "-" && $3 == "-" && $4 == "-" && $5 == "-" && $6 == "-") {
            print $1, $2, "-", "-", "-", "-", $7, "-" # Station HV-B avec capacité
        }
        # Consommateurs HV-B (entreprises uniquement)
        else if ($2 != "-" && consumer == "comp" && $5 != "-") {
            print $1, $2, "-", "-", $5, "-", "-", $8 # Entreprises connectées
        }
    }' "$INPUT_FILE" > "$TEMP_FILE"

else
    echo "Erreur : Type de station invalide (valeurs possibles : lv, hva, hvb)."
    exit 1
fi

# Résultat
echo "Filtrage terminé. Les données ont été sauvegardées dans $TEMP_FILE."
