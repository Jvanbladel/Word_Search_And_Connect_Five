#include "board.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

//Prints the board
void printBoard(struct board myboard)
{
    for(int h = 0; h < myboard.height; h++)
    {
	for(int w = 0; w < myboard.width;w++)
	{
	     printf("%c", myboard.matrix[h][w]);
	}
    }
    printf("\n");
}

//Finds and changes board for word entered
int findAndChangeWordOnBoard(struct board myboard, char word[])
{
	for(int h = 0; h < myboard.height; h++)
	{
		for(int w = 1; w < myboard.width;w++)
		{
	     		if(tolower(word[0]) == tolower(myboard.matrix[h][w]))
			{
				if(checkLocation(myboard, word, h, w))
					return 1;
			}
	        }
	}

	return 0;
}

int checkLocation(struct board myboard, char word[], int h, int w)
{
	
	int elements_in_word = strlen(word);
	
	//Horizontal Check for word
	if(w + elements_in_word-1 < myboard.width)
	{

		int found = 1;
		for(int i = 0; i < elements_in_word; i++)
		{
			if(tolower(word[i]) != tolower(myboard.matrix[h][w+i]))
				found = 0;
		}
		if(found)
		{
			
			for(int i = 0; i < elements_in_word; i++)
			{
				myboard.matrix[h][w+i] = toupper(myboard.matrix[h][w+i]);
			}
			return 1;
		}	

	}
	
	//Vertical Check for word
	if(h + elements_in_word-1 < myboard.height)
	{
		int found = 1;
		for(int i = 0; i < elements_in_word; i++)
		{
			if(tolower(word[i]) != tolower(myboard.matrix[h+i][w]))
				found = 0;
		}
		if(found)
		{
			for(int i = 0; i < elements_in_word; i++)
			{
				myboard.matrix[h+i][w] = toupper(myboard.matrix[h+i][w]);
			}
			return 1;
		}
	}
	
	//Diagonal incr col and incr row
	if(h + elements_in_word-1 < myboard.height && 
		w + elements_in_word-1 < myboard.width)
	{
		int found = 1;
		for(int i = 0; i < elements_in_word; i++)
		{
			if(tolower(word[i]) != tolower(myboard.matrix[h+i][w+i]))
				found = 0;
		}
		if(found)
		{
			for(int i = 0; i < elements_in_word; i++)
			{
				myboard.matrix[h+i][w+i] = toupper(myboard.matrix[h+i][w+i]);
			}
			return 1;
		}

	}

	//Diagonal incr col and dec row
	if(h - elements_in_word+1 >= 0 && 
		w + elements_in_word-1 < myboard.width)
	{
		int found = 1;
		for(int i = 0; i < elements_in_word; i++)
		{
			if(tolower(word[i]) != tolower(myboard.matrix[h-i][w+i]))
				found = 0;
		}
		if(found)
		{
			for(int i = 0; i < elements_in_word; i++)
			{
				myboard.matrix[h-i][w+i] = toupper(myboard.matrix[h-i][w+i]);
			}
			return 1;
		}

	}
	
	//printf("not found\n");
	return 0;
}

//Reverses the string given
char* reverseString(char word[])
{
  int l = strlen(word);
  char* r = (char*)malloc((l + 1) * sizeof(char));
  r[l] = '\0';
  int i;
  for(i = 0; i < l; i++) {
    r[i] = word[l - 1 - i];
  }
  return r;
}
