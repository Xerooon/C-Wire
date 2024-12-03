#include <stdio.h>
#include <stdlib.h>
#include "avl.h"

pAVL createNode(int id, long capacity, long consumption){
  pAVL new = (pAVL)malloc(sizeof(AVL));
  if(new == NULL){
    printf("Error malloc");
    exit(EXIT_FAILURE);
  }

  new->id = id;
  new->capacity = capacity;
  new->consumption = consumption;
  new->left = NULL;
  new->right = NULL;

  return new;
}

pAVL rotateLeft(pAVL station){
  pAVL new = station->right;
  station->right = new->left;
  new->left = station;

  station->weight = 
}

pAVL rotateRight(pAVL station){

}

void freeAvl(pAVL station){
  if(station == NULL){
    return;
  }
  
  freeAvl(station->left);
  freeAvl(station->right);

  free(station);
}