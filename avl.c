#include <stdio.h>
#include <stdlib.h>
#include "avl.h"

pAVL createNode(long id, long capacity, long consumption){
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

  station->weight = station->weight - 1 - (new->weight > 0 ? new->weight : 0);
  new->weight = new->weight - 1 + (station->weight < 0 ? station->weight : 0);

  return new;
}

pAVL rotateRight(pAVL station){
  pAVL new = station->left;
  station->left = new->right;
  new->right = station;

  station->weight = station->weight + 1 - (new->weight < 0 ? new->weight : 0);
  new->weight = new->weight + 1 + (station->weight > 0 ? station->weight : 0);

  return new;
}

pAVL doubleRotateLeft(pAVL station){
  station->right = rotateRight(station->right);
  return rotateLeft(station);
}

pAVL doubleRotateRight(pAVL station){
  station->left = rotateLeft(station->left);
  return rotateRight(station);
}

pAVL balanceAvl(pAVL station){
  if(station == NULL){
    printf("station vide");
    return NULL;
  }
  if(station->weight == 2){
    if(station->right->weight >= 0){
      return rotateLeft(station);
    }
    else{
      return doublerotationGauche(station);
    }
  }
  else if (station->weight == -2){
    if(station->left->weight <= 0){
      return rotateRight(station);
    }
    else{
      return doublerotationDroite(station);
    }
  }

  return station;
}

pAVL insertAvl(pAVL station, long id, long capacity, long consumption){
  if (station == NULL) {
    return createNode(id, capacity, consumption);
  }
  
  if (id < station->id) {
    station->left = insertAvl(station->left, id, capacity, consumption);
    station->weight -= 1;
  } else if (id > station->id) {
    station->right = insertAvl(station->right, id, capacity, consumption);
    station->weight += 1;
  } else {
    printf("ID %d alredy exist\n", id);
    return station;
  }

  return balanceAvl(station);
}

void printAvl(pAVL station){
  if(!station) return;
  printAvl(station->left);
  printf("ID : %d| Capacity : %ld| Consumption : %ld", station->id, station->capacity, station->consumption);
  printAvl(station->right);
}

void freeAvl(pAVL station){
  if(!station) return;
  
  freeAvl(station->left);
  freeAvl(station->right);

  free(station);
}