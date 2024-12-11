#include <stdio.h>
#include "fileOper.h"

// Fonction to read the CSV file and 
char* read_csv_file_BIS(FILE* file){
  char line[MAX_LINE_LENGTH];
  fgets(line, MAX_LINE_LENGTH, file);
  return line;
}