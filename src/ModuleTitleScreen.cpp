/*
	STARFLIGHT - THE LOST COLONY
	ModuleTitleScreen.cpp
	Author: J.Harbour
	Date: Dec,2007

    menu: 311,461
*/

#include "env.h"
#include <exception>
#include <allegro.h>
#include "Util.h"
#include "ModuleTitleScreen.h"
#include "GameState.h"
#include "Game.h"
#include "ModeMgr.h"
#include "DataMgr.h"
#include "Button.h"
#include "Events.h"
//#include "TexturedSphere.h"
using namespace std;

ModuleTitleScreen::ModuleTitleScreen()
{
	m_rotationAngle = 0;
	m_background = NULL;
	btnTitle=NULL;
	btnNewGame = NULL;
	btnLoadGame = NULL;
	btnSettings = NULL;
	btnCredits = NULL;
	btnQuit = NULL;
	title_mode = 690;
}

ModuleTitleScreen::~ModuleTitleScreen(){}

bool ModuleTitleScreen::Init()
{
	const int mainmenu_x=392;
	const int mainmenu_y=450;

	//game-time frozen in this module. Call is necessary since there are multiple paths
	//to this module in the game:
	g_game->SetTimePaused(true);

    m_background = (BITMAP*)load_bitmap("data/titlescreen/TITLE_BACKGROUND.BMP",NULL);
	if (!m_background) {
		g_game->fatalerror("Titlescreen: Error loading background");
		return 0;
	}

	//create buttons
	BITMAP *imgNormal=NULL, *imgMouseOver=NULL;

	//create title button
	imgNormal = (BITMAP*)load_bitmap("data/titlescreen/title_normal.tga",NULL);
    imgMouseOver = (BITMAP*)load_bitmap("data/titlescreen/title_over.tga",NULL);
	if (!imgNormal || !imgMouseOver) {
		g_game->message("TitleScreen: error loading button images");
		return false;
	}
	btnTitle = new Button(imgNormal,imgMouseOver,NULL,0,100,0,0);

	//create new game button
    imgNormal = (BITMAP*)load_bitmap("data/titlescreen/title_newgame_normal.tga",NULL);
    imgMouseOver = (BITMAP*)load_bitmap("data/titlescreen/title_newgame_over.tga",NULL);
	if (!imgNormal || !imgMouseOver) {
		g_game->message("TitleScreen: error loading button images");
		return false;
	}
	btnNewGame = new Button(imgNormal,imgMouseOver,NULL,mainmenu_x,mainmenu_y,0,700);

	//create load button
	imgNormal = (BITMAP*)load_bitmap("data/titlescreen/title_loadgame_normal.tga",NULL);
	imgMouseOver = (BITMAP*)load_bitmap("data/titlescreen/title_loadgame_over.tga",NULL);
	if (!imgNormal || !imgMouseOver) {
		g_game->message("TitleScreen: error loading button images");
		return false;
	}
	btnLoadGame = new Button(imgNormal, imgMouseOver,NULL,mainmenu_x,mainmenu_y+60,0,701);

	//create settings button
	imgNormal = (BITMAP*)load_bitmap("data/titlescreen/title_settings_normal.tga",NULL);
	imgMouseOver = (BITMAP*)load_bitmap("data/titlescreen/title_settings_over.tga",NULL);
	if (!imgNormal || !imgMouseOver) {
		g_game->message("TitleScreen: error loading button images");
		return false;
	}
	btnSettings = new Button(imgNormal,imgMouseOver,NULL,mainmenu_x,mainmenu_y+120,0,702);

	//create credits button
	imgNormal = (BITMAP*)load_bitmap("data/titlescreen/title_credits_normal.tga",NULL);
	imgMouseOver = (BITMAP*)load_bitmap("data/titlescreen/title_credits_over.tga",NULL);
	if (!imgNormal || !imgMouseOver) {
		g_game->message("TitleScreen: error loading button images");
		return false;
	}
	btnCredits = new Button(imgNormal,imgMouseOver,NULL,mainmenu_x,mainmenu_y+180,0,703);

	//create quit button
	imgNormal = (BITMAP*)load_bitmap("data/titlescreen/title_quit_normal.tga",NULL);
	imgMouseOver = (BITMAP*)load_bitmap("data/titlescreen/title_quit_over.tga",NULL);
	if (!imgNormal || !imgMouseOver) {
		g_game->message("TitleScreen: error loading button images");
		return false;
	}
	btnQuit = new Button(imgNormal,imgMouseOver,NULL,mainmenu_x,mainmenu_y+240,0,704);

	return true;
}

void ModuleTitleScreen::Update(){}

void ModuleTitleScreen::Draw()
{
	string text;
	stretch_blit( m_background, g_game->GetBackBuffer(), 0, 0, m_background->w, m_background->h, 0, 0, g_game->GetBackBuffer()->w, g_game->GetBackBuffer()->h );
	btnTitle->Run(g_game->GetBackBuffer(),true);
	btnNewGame->Run(g_game->GetBackBuffer(),true);
	btnLoadGame->Run(g_game->GetBackBuffer(),true);
	btnSettings->Run(g_game->GetBackBuffer(),true);
	btnCredits->Run(g_game->GetBackBuffer(),true);
	btnQuit->Run(g_game->GetBackBuffer(),true);

	switch(title_mode)
	{
		case 690:	//welcome message if needed
			//g_game->ShowMessageBoxWindow(text, 500, 300, YELLOW);
			title_mode = 1;
		break;

		case 700: //clicked New Game
			title_mode = 1;
			g_game->modeMgr->LoadModule(MODULE_CAPTAINCREATION);
			return;
			break;

		case 701: //clicked Load Game
			title_mode = 1;
			g_game->modeMgr->LoadModule(MODULE_CAPTAINSLOUNGE);
			return;
			break;

		case 702: //clicked Settings
			title_mode = 1;
			g_game->modeMgr->LoadModule(MODULE_SETTINGS);
			return;
			break;

		case 703: //clicked Credits
			title_mode = 1;
			g_game->modeMgr->LoadModule(MODULE_CREDITS);
			return;
			break;

		case 704: //QUIT GAME
			title_mode = 705;
			break;

		case 705:
			g_game->shutdown();
			break;

	}
}

void ModuleTitleScreen::OnKeyPress(int keyCode)
{
}

void ModuleTitleScreen::OnKeyPressed(int keyCode)
{
}

void ModuleTitleScreen::OnKeyReleased(int keyCode)
{
	if (keyCode == KEY_ESC)
		title_mode = 704;
}

void ModuleTitleScreen::OnMouseMove(int x, int y)
{
	btnTitle->OnMouseMove(x,y);
	btnNewGame->OnMouseMove(x,y);
	btnLoadGame->OnMouseMove(x,y);
	btnSettings->OnMouseMove(x,y);
	btnCredits->OnMouseMove(x,y);
	btnQuit->OnMouseMove(x,y);
}

void ModuleTitleScreen::OnMouseClick(int button, int x, int y)
{
}

void ModuleTitleScreen::OnMousePressed(int button, int x, int y)
{
}

void ModuleTitleScreen::OnMouseReleased(int button, int x, int y)
{
	btnTitle->OnMouseReleased(button,x,y);
	btnNewGame->OnMouseReleased(button,x,y);
	btnLoadGame->OnMouseReleased(button,x,y);
	btnSettings->OnMouseReleased(button,x,y);
	btnCredits->OnMouseReleased(button,x,y);
	btnQuit->OnMouseReleased(button,x,y);
}

void ModuleTitleScreen::OnEvent(Event *event)
{
	Module::OnEvent(event);

	switch(event->getEventType()) {
		case 700: //new game
			title_mode = 700;
			break;
		case 701: //load game
			title_mode = 701;
			break;
		case 702: //settings
			title_mode = 702;
			break;
		case 703: //credits
			title_mode = 703;
			break;
		case 704: //exit game
			title_mode = 704;
			break;
	}
}

void ModuleTitleScreen::Close()
{
	try {
		delete btnTitle;
        delete btnNewGame;
		delete btnLoadGame;
		delete btnSettings;
		delete btnCredits;
		delete btnQuit;

	}
	catch(std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in TitleScreen::Close\n");
	}
}



