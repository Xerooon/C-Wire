#include <stdio.h>
#include "avl.h"

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


  fclose(file);
  fclose(target);
  return 0;
}