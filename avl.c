#include <stdio.h>
#include <stdlib.h>
#include "avl.h"

// Function to create a new AVL tree node
pAVL createNode(long id, long capacity, long consumption){
  pAVL new = (pAVL)malloc(sizeof(AVL));
  // Check if memory allocation succeeded
  if(new == NULL){
    printf("Error malloc");
    exit(EXIT_FAILURE);
  }

  new->id = id;
  new->capacity = capacity;
  new->consumption = consumption;
  new->weight = 0;
  new->left = NULL;
  new->right = NULL;

  return new;
}

// Function to perform a left rotation
pAVL rotateLeft(pAVL station){
  pAVL new = station->right;
  station->right = new->left;
  new->left = station;

  // Update balance factors
  station->weight = station->weight - 1 - (new->weight > 0 ? new->weight : 0);
  new->weight = new->weight - 1 + (station->weight < 0 ? station->weight : 0);

  return new;
}

// Function to perform a right rotation
pAVL rotateRight(pAVL station){
  pAVL new = station->left;
  station->left = new->right;
  new->right = station;

  // Update balance factors
  station->weight = station->weight + 1 - (new->weight < 0 ? new->weight : 0);
  new->weight = new->weight + 1 + (station->weight > 0 ? station->weight : 0);

  return new;
}

// Function to perform a double left rotation (right rotation followed by left rotation)
pAVL doubleRotateLeft(pAVL station){
  station->right = rotateRight(station->right);
  return rotateLeft(station);
}

// Function to perform a double right rotation (left rotation followed by right rotation)
pAVL doubleRotateRight(pAVL station){
  station->left = rotateLeft(station->left);
  return rotateRight(station);
}

// Function to balance an AVL tree nodes
pAVL balanceAvl(pAVL station){
  if(station == NULL){
    printf("Station empty\n");
    return NULL;
  }

  if(station->weight == 2){
    if(station->right->weight >= 0){
      return rotateLeft(station);
    }
    else{
      return doubleRotateLeft(station);
    }
  }
  else if (station->weight == -2){
    if(station->left->weight <= 0){
      return rotateRight(station);
    }
    else{
      return doubleRotateRight(station);
    }
  }

  return station;
}

// Function to insert a new node into the AVL tree
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
    printf("ID %d alredy exists\n", id);
    return station;
  }

  return balanceAvl(station);
}

// Function to print the AVL tree in-order
void printAvl(pAVL station){
  if(!station) return;
  printAvl(station->left);
  printf("ID : %d| Capacity : %ld| Consumption : %ld\n", station->id, station->capacity, station->consumption);
  printAvl(station->right);
}

// Function to free the memory used by the AVL tree
void freeAvl(pAVL station){
  if(!station) return;
  
  freeAvl(station->left);
  freeAvl(station->right);

  free(station);
}

void calculateConsumption(pAVL tree, FILE* outputFile){
  if(!tree) return;
  calculateConsumption(tree->left, outputFile);
  fprintf(outputFile, "%d:%ld:%ld\n", tree->id, tree->capacity, tree->consumption);
  calculateAndPrint(tree->right, outputFile);
}