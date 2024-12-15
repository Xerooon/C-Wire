#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "avl.h"

// Main fonction
int main(int argc, char *argv[]) {
  if (argc < 2) {
    fprintf(stderr, "Usage: %s <input_csv>\n", argv[0]);
    return 1;
  }

  const char *file_path = argv[1];
  pAVL root = NULL;
  int h;

  // Open the CSV file
  FILE *file = fopen(file_path, "r");
  if (file == NULL) {
    perror("Erreur d'ouverture du fichier");
    return 1;
  }

  char line[256];
  while (fgets(line, sizeof(line), file)) {
    char *token;
    long id = 0, capacity = 0, consumption = 0;
    int column = 0;

    token = strtok(line, ";");
    while (token != NULL) {
      switch (column) {
        // HV-B ID field
        case 1: 
          if (strcmp(token, "-") != 0) {
            id = atol(token);
          }
          break;
        // HV-A ID field
        case 2: 
          if (strcmp(token, "-") != 0) {
            id = atol(token);
          }
          break;
        // LV ID field
        case 3: 
          if (strcmp(token, "-") != 0) {
            id = atol(token);
          }
          break;
        // Capacity field
        case 6:
          if (strcmp(token, "-") != 0) {
            capacity = atol(token);
          }
          break;
        // Consumption field
        case 7:
          if (strcmp(token, "-") != 0) {
            consumption = atol(token);
          }
          break;
        default:
          break;
      }
      column++;
      token = strtok(NULL, ";");
    }

    // Insert into the AVL tree if the station ID is valid (non-zero)
    if (id != 0) {
      root = insertAvl(root, id, capacity, consumption, &h);
    }
  }

  fclose(file);

  printAvl(root);
  freeAvl(root);
  return 0;
}