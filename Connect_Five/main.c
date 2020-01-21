#include <stdio.h>
#include <stdlib.h>

int m_w = 20;    /* must not be zero */ 
int m_z = 689; /* must not be zero */

__uint32_t get_random();
void printBoard(char** board);
int isNotWinner(char** board);
int takeTurn(char** board, int playerTurn, int move);

int main()
{
	printf("Welcome to Connect Four, Five-in-a-Row variant!\n");
	printf("Version 1.0\n");
	printf("Implemented by Jason Van Bladel\n");
	printf("Enter two positive numbers to initialize the random number generator.\n");
	printf("Enter number 1: ");
	scanf("%d", &m_w);
	printf("Enter number 2: ");
	scanf("%d", &m_z);
	printf("\nHuman player (H)\n");
	printf("Computer player (C)\n");
	printf("Coin toss...");
	
	int toss = get_random();

	int playerTurn  = 0;
	if (toss%2 == 0)
	{
		playerTurn = 1;
		printf("Humans Turn!\n");
	}
	else
	{
		playerTurn = 0;
		printf("Computers Turn!\n");
	}
	
	int height = 6;
	int width = 7;
	char** board = (char**)malloc(sizeof(char*)*height);
   	for(int i = 0; i < height; i++)
        {
		board[i] = (char*)malloc(sizeof(char)*width);
     	}

	for(int h = 0; h < height; h++)
	{
		for(int w = 0; w < width; w++)
		{
			board[h][w] = '.';
		}
	}

	while(isNotWinner(board) == 1)
	{
		printBoard(board);

		if(playerTurn == 1)
		{
			printf("What column would you like to drop token into? Enter 1-7: ");
			int move;
			scanf("%d", &move);
			if(takeTurn(board, playerTurn, move) == 1)
				playerTurn = 0;
				
		}
		else
		{

			int madeMove = 0;
			int move;
			while(madeMove == 0)
			{
				move = (get_random()%7) + 1;
				if(takeTurn(board, playerTurn, move) == 1)
				{
					playerTurn = 1;
					madeMove = 1;
				}
					
			}
			printf("Computer player selected column %d\n", move);	
		}
	}

	printBoard(board);
	int outcome = isNotWinner(board);
	if(outcome == 2)
	{	
		printf("Sorry, the Computer Won!\n");
	}
	else if(outcome == 3)
	{
		printf("Congratulations, Human Winner!");
	}
	else 
	{
		printf("That's a tie!");
	}
}

void printBoard(char** board)
{
	int width = 7;
	int height = 6;
	printf("\n  1 2 3 4 5 6 7  \n");
	printf("-----------------\n");
	for(int h = 0; h < height; h++)
	{
		printf("| ");
		for(int w = 0; w < width; w++)
		{
			printf("%c ", board[h][w]);
		}
		printf("| \n");
	}
	printf("-----------------\n");
}

int isNotWinner(char** board)
{
	int width =  7;
	int height = 6;	

	for(int h = 0; h < height; h++)
	{
		char last = ' ';
		int count = 0;
		for(int w = 0; w < width; w++)
		{
			if(board[h][w] == last)
			{
				count++;
			}
			else if(board[h][w] != '.')
			{
				last =  board[h][w];
				count = 1;
			}
			else
			{
				last = ' ';
				count = 0;
			}

			if(count == 5)
			{
				if(last == 'C')
					return 2;
				return 3;
			}
		}
	}

	for(int w = 0; w < width; w++)
	{
		
		char last = ' ';
		int count = 0;
		for(int h = 0; h < height; h++)
		{
			if(board[h][w] == last)
			{
				count++;
			}
			else if(board[h][w] != '.')
			{
				last =  board[h][w];
				count = 1;
			}
			else
			{
				last = ' ';
				count = 0;
			}

			if(count == 5)
			{
				if(last == 'C')
					return 2;
				return 3;
			}
		}
	}


	for(int h = 0; h < height; h++)
	{
		for(int w = 0; w < width; w++)
		{
			char last = ' ';
			int count = 0;
			for(int i = 0; i < 5; i++)
			{
				if(h+i == height || w+i == width)
					break;
				if(board[h+i][w+i] == last)
				{
					count++;
				}
				else if(board[h+i][w+i] != '.')
				{
					last =  board[h+i][w+i];
					count = 1;
				}
				else
				{
					break;
				}
			}
			if(count == 5)
			{
				if(last == 'C')
					return 2;
				return 3;
			}
		}
	}

	for(int h = 0; h < height; h++)
	{
		for(int w = 0; w < width; w++)
		{
			char last = ' ';
			int count = 0;
			for(int i = 0; i < 5; i++)
			{
				if(h+i == height || w-i == -1)
					break;
				if(board[h+i][w-i] == last)
				{
					count++;
				}
				else if(board[h+i][w-i] != '.')
				{
					last =  board[h+i][w-i];
					count = 1;
				}
				else
				{
					break;
				}
			}
			
			if(count == 5)
			{
				if(last == 'C')
					return 2;
				return 3;
			}
		}
	}


	for(int h = 0; h < height; h++)
	{
		for(int w = 0; w < width; w++)
		{
			if(board[h][w] == '.')
				return 1; 
		}
	}

	return 4;
}

int takeTurn(char** board, int playerTurn, int move)
{
	int height = 6;
	for(int h = height-1; h >= 0; h--)  
	{
		if(board[h][move-1] == '.')
		{
			if(playerTurn == 1)
			{
				board[h][move-1] = 'H';
			}
			else
			{
				board[h][move-1] = 'C';
			}
				
			return 1;
		}
	}

	if(playerTurn == 1)
	{
		printf("Invalid Move. Try Again!\n");
	}

	return 0;
}

__uint32_t get_random()
{
  m_z = 36969 * (m_z & 65535) + (m_z >> 16);
  m_w = 18000 * (m_w & 65535) + (m_w >> 16);
  return (m_z << 16) + m_w; /* 32-bit result */
}
