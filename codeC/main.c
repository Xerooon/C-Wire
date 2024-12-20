#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "avl.h"
#include "fileOper.h"

// Main fonction
int main(int argc, char *argv[]) {
  // The executable doesn't contain enough files
  if (argc < 3) {
    fprintf(stderr, "Usage: %s <input_csv>\n", argv[0]);
    return 1;
  }

  // Init
  pAVL root = NULL;

  // Open/Read CSV file
  FILE* file = fopen(argv[1], "r");
  if (file == NULL) {
    perror("Error trying open file");
    return 1;
  }
  root = fileToAVL(root, file);
  fclose(file);

  // Open/Write CSV file
  FILE* delivery = fopen(argv[2], "a");
  if (delivery == NULL) {
    perror("Error trying open file");
  return 1;
  }
  printToFile(root, delivery);
  fclose(delivery);

  // Free all memory
  freeAvl(root);
  return 0;
}