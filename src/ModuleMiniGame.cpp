/*
	STARFLIGHT - THE LOST COLONY
	ModuleMiniGame.cpp
	Author: J.Harbour
	Date: Jan, 2008
*/

#include "env.h"
#include "ModuleMiniGame.h"
#include "AudioSystem.h"
#include "ModeMgr.h"
#include "Game.h"
#include "Events.h"
#include "GameState.h"
#include "Util.h"


ModuleMiniGame::ModuleMiniGame(void)
{
}

ModuleMiniGame::~ModuleMiniGame(void)
{
}


void ModuleMiniGame::OnKeyPress(int keyCode)
{
	Module::OnKeyPress(keyCode);
}


void ModuleMiniGame::OnKeyPressed(int keyCode)
{
	Module::OnKeyPressed(keyCode);
}

void ModuleMiniGame::OnKeyReleased(int keyCode)
{
	Module::OnKeyReleased(keyCode);

	switch (keyCode) {
		case KEY_ESC:
			std::string escape = g_game->getGlobalString("ESCAPEMODULE");
			g_game->modeMgr->LoadModule(escape);
			return;
			break;
	}
}

void ModuleMiniGame::OnMouseMove(int x, int y)
{
	Module::OnMouseMove(x,y);
}

void ModuleMiniGame::OnMouseClick(int button, int x, int y)
{
	Module::OnMouseClick(button,x,y);
}

void ModuleMiniGame::OnMousePressed(int button, int x, int y)
{
	Module::OnMousePressed(button, x, y);
}

void ModuleMiniGame::OnMouseReleased(int button, int x, int y)
{
	Module::OnMouseReleased(button, x, y);
}

void ModuleMiniGame::OnMouseWheelUp(int x, int y)
{
	Module::OnMouseWheelUp(x, y);
}

void ModuleMiniGame::OnMouseWheelDown(int x, int y)
{
	Module::OnMouseWheelDown(x, y);
}

void ModuleMiniGame::OnEvent(Event *event)
{
	//switch(event->getEventType()) 
	//{
	//}
}

void ModuleMiniGame::Close()
{
	
	
}


bool ModuleMiniGame::Init()
{
	BITMAP *background = load_bitmap("data/minigame_background.bmp", NULL);
	blit(background, g_game->GetBackBuffer(), 0, 0, 0, 0, background->w, background->h);
	destroy_bitmap(background);
	
	window = create_sub_bitmap(g_game->GetBackBuffer(), 192, 144, 640, 480);

	return true;
}

void ModuleMiniGame::Draw3D()
{
	
}

void ModuleMiniGame::Update()
{
	
}

void ModuleMiniGame::Draw()
{
	textout_ex(window, font, "HELLO WORLD", 10, 10, WHITE, -1);
	
	
}

