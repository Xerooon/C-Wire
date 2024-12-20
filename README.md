# README - Projet C-Wire

## Description du Projet

Le projet **C-Wire** consiste à développer un système capable d'analyser les données de distribution d'énergie en France. À partir d'un fichier CSV volumineux contenant des informations sur les producteurs, distributeurs et consommateurs d'énergie, le programme permet :

1. De filtrer les données en fonction des paramètres sélectionnés.
2. De traiter ces données pour évaluer les capacités et consommations des stations.
3. D'exporter les résultats sous forme de fichiers CSV structurés.

## Organisation des Fichiers

Le projet est structuré comme suit :

- `input/` : Contient le fichier CSV d'entrée (exemple : `data.csv`).
- `codeC/` : Contient le code source C, le Makefile, et l'exécutable généré.
- `graphs/` : Contient les graphiques générés (bonus).
- `tmp/` : Contient les fichiers temporaires générés pendant le traitement.
- `tests/` : Contient les fichiers de sortie pour validation et tests.
- `c-wire.sh` : Script Shell principal pour lancer le traitement.

## Fonctionnalités Principales

### Script Shell : `c-wire.sh`

Ce script Shell gère les étapes suivantes :

1. **Filtrage des Données :**
   - Filtre les lignes du fichier CSV selon :
     - Le type de station (`hvb`, `hva`, `lv`).
     - Le type de consommateur (`comp`, `indiv`, `all`).
     - Un identifiant spécifique de centrale.

2. **Préparation des Données :**
   - Crée des fichiers temporaires pour les stations et les consommateurs.

3. **Exécution du Programme C :**
   - Compile et exécute le programme C pour calculer les sommes de consommation par station.

4. **Export des Résultats :**
   - Génère un fichier CSV structuré contenant les résultats (triés par capacité croissante).
   - Génère des fichiers spécifiques pour les postes LV avec les 10 plus chargés et les 10 moins chargés (bonus).

### Programme C

Le programme C réalise :

- L'agrégation des données de consommation par station.
- L'utilisation d'un arbre AVL pour optimiser le traitement des données volumineuses.
- La gestion des erreurs pour garantir la robustesse du programme.

## Utilisation

### Prérequis

- Système d'exploitation : Linux/Unix.
- Logiciels nécessaires :
  - `gcc` pour compiler le code C.
  - `awk` pour le filtrage des données.
  - `gnuplot` (optionnel) pour les graphiques.

### Commande

```bash
./c-wire.sh <input_csv> <type_station> <type_consumer> [<central_id>] [-h]
```

#### Paramètres

- `<input_csv>` : Chemin vers le fichier CSV d'entrée.
- `<type_station>` : Type de station à analyser : `hvb`, `hva`, `lv`.
- `<type_consumer>` : Type de consommateur : `comp` (entreprises), `indiv` (particuliers), `all` (tous).
- `[<central_id>]` : (Optionnel) Identifiant de la centrale à filtrer.
- `-h` : Affiche l'aide du script.

#### Exemple

```bash
./c-wire.sh input/data.csv lv all
```

### Résultats

Les fichiers générés seront disponibles dans le dossier `tests/`. Exemple :

- `lv_all.csv` : Résultats complets pour tous les postes LV.
- `lv_all_minmax.csv` : Liste des 10 postes LV les plus et les moins chargés.

## Bonus

- **Graphiques :**
  - Les 10 postes LV les plus et les moins chargés sont représentés sous forme de graphique en barres dans le dossier `graphs/`.
- **Robustesse :**
  - Le programme gère les cas d'erreur tels que les fichiers manquants ou les paramètres invalides.

## Auteurs

- **Eva Ansermin** (eva.ansermin@cyu.fr)
- **Romuald Grignon** (romuald.grignon@cyu.fr)

## Réalisateurs 

- **Groupe : MI-5_B** 
  - **Illya Liganov** (illya.liganov@etu.cyu.fr)
  - **Bruno Rocha** (bruno.rocha@etu.cyu.fr)
  - **Alexis Beau** (alexis.beau@etu.cyu.fr)


**Note :** Ce projet est un exercice académique pour apprendre à manipuler des fichiers volumineux et à structurer un code robuste et modulaire.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
