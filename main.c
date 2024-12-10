#include <stdio.h>
#include "avl.h"

<<<<<<< HEAD
int main(int argc, char* argv[]) {
  char buffer[1024]; // Buffer for the reading

  if(argc<2){
    printf("Error: file not found\n");
    return 0;
  }
  File* file = fopen(argv[1], "rb");  // Reading..
  if(file==NULL){
    printf("Error: opening file\n");
    return 0;
  }

  if(argc<3){
    printf("Error: target not found\n");
    return 0;
  }
  File* target = fopen(argv[2], "wb");  // Writing..
  if(target==NULL){
    printf("Error: opening file\n");
    return 0;
  }


=======
#define MAX_LINE_LENGTH 1024
#define MAX_FIELDS 20

// Function to read and parse the CSV file
void read_csv_file(FILE* file) {
    char line[MAX_LINE_LENGTH];
    int line_number = 0;

    while (fgets(line, MAX_LINE_LENGTH, file)) {
        line_number++;

        // Remove the newline character at the end of the line
        line[strcspn(line, "\n")] = 0;

        // Split the line into fields
        char *fields[MAX_FIELDS];
        int field_count = 0;
        char *token = strtok(line, ";");

        while (token && field_count < MAX_FIELDS) {
            fields[field_count++] = token;
            token = strtok(NULL, ";");
        }

        // Process each field
        printf("Line %d:\n", line_number);
        for (int i = 0; i < field_count; i++) {
            if (strcmp(fields[i], "-") == 0) {
                printf("  Field %d: (empty)\n", i + 1);
            } else {
                printf("  Field %d: %s\n", i + 1, fields[i]);
            }
        }
        printf("\n");
    }

    fclose(file);
}

char* read_csv_file_BIS(FILE* file){
  char line[MAX_LINE_LENGTH];
  fgets(line, MAX_LINE_LENGTH, file);
  return line;
}



int main(int argc, char* argv[]) {

  // Reading File
  if(argc<2){
    printf("Error: file not found\n");
    return 0;
  }
  FILE* file = fopen(argv[1], "r");  
  if(file==NULL){
    printf("Error: opening file\n");
    return 0;
  }

  char line[MAX_LINE_LENGTH] = read_csv_file_BIS(file);

  // Writing File
  if(argc<3){
    printf("Error: target not found\n");
    return 0;
  }
  FILE* target = fopen(argv[2], "w"); 
  if(target==NULL){
    printf("Error: opening file\n");
    return 0;
  }

>>>>>>> 97fb191 (.)
  fclose(file);
  fclose(target);
  return 0;
}