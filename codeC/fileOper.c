#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "avl.h"
#include "fileOper.h"

// Read a CSV file and create AVL tree
pAVL fileToAVL(pAVL root, FILE *file) {
  int h;
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
  return root;
}

// Write in CSV file with AVL tree
void printToFile(pAVL station, FILE *file) {
  if (!station) return;
  printToFile(station->left, file);
  fprintf(file, "%ld:%ld:%ld\n", station->id, station->capacity, station->consumption);
  printToFile(station->right, file);
}