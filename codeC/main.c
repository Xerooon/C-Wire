#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "avl.h"


void printToFile(pAVL station, FILE *file) {
  if (!station) return;
  printToFile(station->left, file);
  fprintf(file, "%ld:%ld:%ld\n", station->id, station->capacity, station->consumption);
  printToFile(station->right, file);
}

// Main fonction
int main(int argc, char *argv[]) {
  if (argc < 3) {
    fprintf(stderr, "Usage: %s <input_csv>\n", argv[0]);
    return 1;
  }

  pAVL root = NULL;
  int h;

  // Open CSV files
  FILE* file = fopen(argv[1], "r");
  if (file == NULL) {
    perror("Error trying open file");
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

  // Write in the delivery file
  FILE* delivery = fopen(argv[2], "a");
  if (delivery == NULL) {
    perror("Error trying open file");
  return 1;
  }

  printToFile(root, delivery);
  fclose(delivery);

  freeAvl(root);
  return 0;
}