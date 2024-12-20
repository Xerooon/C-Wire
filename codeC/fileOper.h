#ifndef FILEOPER_H
#define FILEOPER_H
#include "avl.h"


#define MAX_LINE_LENGTH 1024
#define MAX_FIELDS 20

// Fonctions
pAVL fileToAVL(pAVL root, FILE *file);
void printToFile(pAVL station, FILE *file);

#endif