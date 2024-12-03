#include <stdio.h>
#include <stdlib.h>

typedef struct node{
  int id;
  long capacity;
  long consumption;
  int weight;
  struct node *left, *right;
}AVL, *pAVL;

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

void freeAvl(pAVL station){
  if(station == NULL){
    return;
  }
  
  freeAvl(station->left);
  freeAvl(station->right);

  free(station);
}

int main() {


  return 0;
}