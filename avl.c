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
/*
pAVL insert_station(pAVL station, int id, long capacity, long consumption) {
    if (!station) return create_station(id, capacity, consumption);

    if (id < station->id)
        station->left = insert_station(station->left, id, capacity, consumption);
    else if (id > station->id)
        station->right = insert_station(station->right, id, capacity, consumption);
    else {
        station->consumption += consumption; // Mise à jour si station déjà existante
        return station;
    }

    // Mettre à jour la hauteur
    station->height = 1 + (height(station->left) > height(station->right) ? height(station->left) : height(station->right));

    // Vérifier et corriger le déséquilibre
    int balance = balance_factor(station);

    // Rotation nécessaire
    if (balance > 1 && id < station->left->id)
        return rotate_right(station);

    if (balance < -1 && id > station->right->id)
        return rotate_left(station);

    if (balance > 1 && id > station->left->id) {
        station->left = rotate_left(station->left);
        return rotate_right(station);
    }

    if (balance < -1 && id < station->right->id) {
        station->right = rotate_right(station->right);
        return rotate_left(station);
    }

    return station;
}
*/

void freeAvl(pAVL station){
  if(!station) return;
  
  freeAvl(station->left);
  freeAvl(station->right);

  free(station);
}

void printAvl(pAVL station){
  if(!station) return;
  printAvl(station->left);
  printf("ID : %d| Capacity : %ld| Consumption : %ld", station->id, station->capacity, station->consumption);
  printAvl(station->right);
}