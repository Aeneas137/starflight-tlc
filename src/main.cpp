/*
	STARFLIGHT - THE LOST COLONY
	main.cpp - main function that launches the game class
	Author: Coder
	Date:
*/

#include <iostream>
#include "env.h"
#include <allegro.h>
#include "Game.h"

//global engine object
Game *g_game;

int main(int argc, char **argv)
{
	g_game = new Game();
	g_game->Run();
	g_game = NULL;

   return 0;
}
END_OF_MAIN()
