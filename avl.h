#ifndef AVL_H
#define AVL_H

typedef struct node{
  int id;
  long capacity;
  long consumption;
  int weight;
  struct node *left, *right;
}AVL, *pAVL;

pAVL createNode(int id, long capacity, long consumption);
void freeAvl(pAVL station);

#endif