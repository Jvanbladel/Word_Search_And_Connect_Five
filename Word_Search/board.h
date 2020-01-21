
#ifndef BOARD_H
#define BOARD_H

struct board{

int height;
int width;
char** matrix;

};

void printBoard(struct board myboard);
int findAndChangeWordOnBoard(struct board myboard, char word[]);
int checkLocation(struct board myboard, char word[], int h, int w);
char* reverseString(char word[]);

#endif
