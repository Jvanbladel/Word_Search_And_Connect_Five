//Jason Van Bladel

//j_vanbladel@u.pacific.edu

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "board.h"

int main()
{
 
    FILE *fptr = NULL;
  
    printf("Welcome to Crossword!\n");
   
    //Loop for valid file input
    while (fptr == NULL) 
    { 
	printf("Please Enter the name of a file:\n");

	char input_file[100];
        fgets(input_file, 100, stdin);
        input_file[strlen(input_file) -1] = '\0';
	fptr = fopen(input_file, "r");
	if(fptr == NULL)
        	printf("Cannot open file \n"); 
    } 
    

    int h, w;
    fscanf(fptr, "%d %d", &h, &w);

    //Create Board
    struct board myboard;
    myboard.height = h;
    myboard.width = w+1;
    myboard.matrix = NULL;

    //Dynamic allocation of memory
    myboard.matrix = (char**)malloc(sizeof(char*)*myboard.height);
    int i;
    for(i = 0; i < myboard.height; i++)
    {
	myboard.matrix[i] = (char*)malloc(sizeof(char)*myboard.width);
    }
    
    //Putting values from text file to board
    for(int h = 0; h < myboard.height; h++)
    {
	char c;
	for(int w = 0; w < myboard.width;w++)
	{
	     if(c != EOF)
	     {
	         c = fgetc(fptr); 
	         myboard.matrix[h][w] = tolower(c);
             }
	}
    }
  
    //close file
    fclose(fptr); 


    //Game logic
    while(1)
    {
	printBoard(myboard);
	printf("\nEnter a word in the puzzle:\n");
        
	//takes in user input
	char user_input[100];
        fgets(user_input, 100, stdin);
        user_input[strlen(user_input) -1] = '\0';


	printf("The user has entered: '%s'\n", user_input);
	if(!strcmp(user_input, "exit"))
	{
		printf("Quiting Program\n");
		
		//Deallocating board
		for(int i = 0; i < myboard.height; i++)
		{
			free(myboard.matrix[h]);
		}
		free(myboard.matrix);
		
		return 0;
	}
		
	//Check for word entered
	if(!findAndChangeWordOnBoard(myboard, user_input))//forward
        {
	  char* reverse = reverseString(user_input);
	  if(findAndChangeWordOnBoard(myboard, reverse))//reverse
		printf("Found word: '%s'\n", user_input);
	  else 
		printf("Could not find word: '%s', please try again!\n", user_input);
	  free(reverse);
        }
	else
	    printf("Found word: '%s'\n", user_input);

    }

    //Deallocating board
    for(int i = 0; i < myboard.height; i++)
    {
	free(myboard.matrix[h]);
    }
    free(myboard.matrix);

    return 0; 
}


