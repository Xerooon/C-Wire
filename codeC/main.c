#include "avl.h"
#include "fileOper.h"
#include <stdio.h>

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

  fclose(file);
  fclose(target);
  return 0;
}