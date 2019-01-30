/*
	STARFLIGHT - THE LOST COLONY
	ModuleCredits.cpp - 
	Author: 
	Date: 
*/

#include "env.h"
#include "ModuleCredits.h"
#include "Game.h"
#include "DataMgr.h"
#include "ModeMgr.h"
using namespace std;


#define BACKGROUND_TGA                   0        /* BMP  */



/*
  This is not elegant or data driven but it meets our needs. The credit list for this game
  is not large so we can update this as needed without exposing a data file to end-user manipulation.
  Roles ended up being printed on left, with names of the right; but i left the array as is.
 */
const int numcredits = 36;
string credits[numcredits][2] = {
{"ARTWORK","Ronald Conley"},
{"","Andrew Chason"},
{"",""},
{"MUSIC","Chris Hurn"},
{"",""},
{"PROGRAMMING","David Calkins"},
{"","Jon Harbour"},
{"","Steven Wirsz"},
{"",""},
{"GAME DESIGN","Jon Harbour"},
{"","David Calkins"},
{"",""},
{"STORY WRITING","Steve Wirsz"},
{"","Jon Harbour"},
{"",""},
{"INSPIRATION","Rod McConnell"},
{"","Alec Kercso"},
{"","Greg Johnson"},
{"","T.C. Lee"},
{"","Bob Gonsalves"},
{"","Evan Robinson"},
{"",""},
{"SPECIAL THANKS",""},
{"",""},
{"Steve Heyer","Justin Sargent"},
{"Nick Busby","Jonathan Ray"},
{"Jonathan Verrier","Matthew Klausmeier"},
{"David Guardalabene","Keith Patch"},
{"Jakob Medlin","Scott Idler"},
{"Vincent Cappe","Steven Kottke"},
{"Michael Drotar","Wascal Wabbit"},
{"Donnie Jason","Jeff Price"},
{"Michael Madrio","William Sherwin"},
{"Nathan Wright","Vince Converse"},
{"Ed Wolinski","Sophia Wolinski"},

};




ModuleCredits::ModuleCredits(void)
{
	background = NULL;
}
ModuleCredits::~ModuleCredits(void) {}
void ModuleCredits::OnKeyPress(int keyCode)	{ }
void ModuleCredits::OnKeyPressed(int keyCode) { }
void ModuleCredits::OnKeyReleased(int keyCode)
{
	g_game->modeMgr->LoadModule(MODULE_TITLESCREEN);
	return;
}
void ModuleCredits::OnMouseMove(int x, int y){ }
void ModuleCredits::OnMouseClick(int button, int x, int y) { }
void ModuleCredits::OnMousePressed(int button, int x, int y) { }
void ModuleCredits::OnMouseReleased(int button, int x, int y)
{ 
	g_game->modeMgr->LoadModule(MODULE_TITLESCREEN);
	return;
}
void ModuleCredits::OnMouseWheelUp(int x, int y){ }
void ModuleCredits::OnMouseWheelDown(int x, int y){}
void ModuleCredits::OnEvent(Event *event) {}
void ModuleCredits::Close()
{
	TRACE("Credits Close\n");

	//unload the data file 
	unload_datafile(datafile);
	datafile = NULL;

}

bool ModuleCredits::Init()
{
	TRACE("  ModuleCredits Initialize\n");

	//load the datafile
	datafile = load_datafile("data/credits/credits.dat");
	if (!datafile) {
		g_game->message("Credits: Error loading datafile");	
		return false;
	}

	//Load background
	//background = load_bitmap("data/credits/background.tga",NULL);
	background = (BITMAP*)datafile[BACKGROUND_TGA].dat;
	if (!background) {
		g_game->message("Credits: Error loading background");
		return false;
	}

	g_game->Print32(background, 390, 10, "CONTRIBUTORS", STEEL, true);

	//print credit lines onto background
	for (int n=0; n < numcredits; n++) 
	{
		g_game->Print24(background, 250, 70 + n*19, credits[n][0], ORANGE, true);
		g_game->Print24(background, 580, 70 + n*19, credits[n][1], ORANGE, true);
	}

	return true;
}

void ModuleCredits::Update()
{
}

void ModuleCredits::Draw()
{
	//draw background
	blit(background, g_game->GetBackBuffer(), 0, 0, 0, 0, background->w, background->h);


}

