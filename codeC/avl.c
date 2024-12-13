#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include "avl.h"

// Function to create a new AVL tree node
pAVL createNode(long id, long capacity, long consumption){
  pAVL newNode = (pAVL)malloc(sizeof(AVL));
  // Check if memory allocation succeeded
  if(!newNode){
    fprintf(stderr, "Error allocating memory : %s\n", strerror(errno));
    exit(EXIT_FAILURE);
  }

  newNode->id = id;
  newNode->capacity = capacity;
  newNode->consumption = consumption;
  newNode->weight = 0;
  newNode->left = NULL;
  newNode->right = NULL;

  return newNode;
}

// Function to perform a left rotation
pAVL rotateLeft(pAVL station){
  pAVL newNode = station->right;
  station->right = newNode->left;
  newNode->left = station;

  // Update balance factors
  station->weight = station->weight - 1 - (newNode->weight > 0 ? newNode->weight : 0);
  newNode->weight = newNode->weight - 1 + (station->weight < 0 ? station->weight : 0);

  return newNode;
}

// Function to perform a right rotation
pAVL rotateRight(pAVL station){
  pAVL newNode = station->left;
  station->left = newNode->right;
  newNode->right = station;

  // Update balance factors
  station->weight = station->weight + 1 - (newNode->weight < 0 ? newNode->weight : 0);
  newNode->weight = newNode->weight + 1 + (station->weight > 0 ? station->weight : 0);

  return newNode;
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
    printf("station not allocated in memory\n");
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
pAVL insertAVL(pAVL station, long id, long capacity, long consumption, int *h){
  if(station == NULL){
    *h = 1;
    return createNode(id, capacity, consumption);
  }

  if(id < station->id){
    station->left = insertAVL(station->left, id, capacity, consumption, h);
    if(*h) station->weight--;
  }
  else if(id > station->id){
    station->right = insertAVL(station->right, id, capacity, consumption, h);
    if(*h) station->weight++;
  } 
  // Duplicate ID case: ignore the new node
  else {
    *h = 0;
    return station;
  }

  // Balancing weight
  if(station->weight < -1 || station->weight > 1){
    station = balanceAvl(station);
    *h = 0;
  }
  else if(station->weight == 0){
    *h = 0;
  }
  
  return station;
}

// Function to print the AVL tree in-order
void printAvl(pAVL station){
  if(!station) return;
  printAvl(station->left);
  printf("ID : %ld| Capacity : %ld| Consumption : %ld\n", station->id, station->capacity, station->consumption);
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
  fprintf(outputFile, "%ld:%ld:%ld\n", tree->id, tree->capacity, tree->consumption);
  calculateAndPrint(tree->right, outputFile);
}