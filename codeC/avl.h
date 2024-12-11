#ifndef AVL_H
#define AVL_H

// Structure for AVL Tree node
typedef struct node{
  long id;
  long capacity; //(in kWh)
  long consumption; //(in kWh)
  int weight;
  struct node *left, *right;
}AVL, *pAVL;

// Fonctions 
pAVL createNode(long id, long capacity, long consumption);
pAVL rotateLeft(pAVL station);
pAVL rotateRight(pAVL station);
pAVL doubleRotateLeft(pAVL station);
pAVL doubleRotateRight(pAVL station);
pAVL balanceAvl(pAVL station);
pAVL insertAvl(pAVL station, long id, long capacity, long consumption);
void printAvl(pAVL station);
void freeAvl(pAVL station);

#endif