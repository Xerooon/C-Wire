#!/bin/bash

show_help(){
    echo""
    echo"Parametres obligatoire:"
    echo"   -chemin vers le fichier csv d'entree: <chemin_du_fichier_CSV"
    echo"   -type de station a traiter(hvb, hva, lv): <type_station>"
    echo"   -type de consommateur a traiter(comp, indiv, all): <type_consommateur>"
    echo""
    echo"Parametres optionnels:"
    echo"   -filtrer pour une centrale specifique: [numero_centrale]"
    exit 0
}

erreur(){
    echo"erreur"
    show_help
}

if echo "$@" | grep -q "\-h"; then
    show_help
fi

if [[ $# -lt 3 ]]; then
    echo" pas assez d'element "
    show_help
fi

csv_chemin=$1
station=$2
consommateur=$3
id_centrale=$4

Valid_station=("hvb", "hva", "lv")
Valid_consommateur=("comp", "indiv", "all")

if[[ ! " ${Valid_station[*]} " =~ " $station " ]]; then 
    echo"type de station invalide"
    show_help
fi

if[[ ! " ${Valid_consommateur[*]} " =~ " $consommateur " ]]; then
    echo"type de consommateur invalide"
    show_help
fi

if [[ -n "$id_centrale" && ! "$id_centrale" =~ ^[1-9][0-9]*$ ]]; then                    # -n pour voir si ca existe. pour les chiffres c'est pour avoir des nombres entier positif
    echo "Erreur car nombre soit pas entier soit pas positif."
    show_help
fi

if [[ "$station" == "hvb" && ("$consommateur" == "all" || "$consommateur" == "indiv") ]]; then
    echo "Erreur : Les combinaisons 'hvb all' et 'hvb indiv' sont interdites."
    show_help
fi

if [[ "$station" == "hva" && ("$consommateur" == "all" || "$consommateur" == "indiv") ]]; then
    echo "Erreur : Les combinaisons 'hva all' et 'hva indiv' sont interdites."
    show_help
fi

if [[ ! -f "$csv_chemin" ]]; then
    echo "Erreur : Le fichier CSV n'existe pas."
    exit 1
fi

awk 
