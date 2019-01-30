/*
	STARFLIGHT - THE LOST COLONY
	ModuleGameOver.cpp 
	Date: October, 2007
*/


#include "env.h"
#include "ModuleGameOver.h"
#include "ModeMgr.h"
#include "Game.h"

ModuleGameOver::ModuleGameOver(void)
{
	bQuickShutdown = true;
}

ModuleGameOver::~ModuleGameOver(void)
{
}

void ModuleGameOver::OnKeyPress(int keyCode)
{
	//Module::OnKeyPress(keyCode);

	/*switch (keyCode) {
	}*/
}


void ModuleGameOver::OnKeyPressed(int keyCode)
{
	//Module::OnKeyPressed(keyCode);

	//switch (keyCode) {
	//}
}

void ModuleGameOver::OnKeyReleased(int keyCode)
{
	//Module::OnKeyReleased(keyCode);

	if (keyCode == KEY_ESC) {
		rest(500);
		g_game->modeMgr->LoadModule(MODULE_TITLESCREEN);
		return;
	}
}

void ModuleGameOver::OnMouseMove(int x, int y)
{
	//Module::OnMouseMove(x,y);
}

void ModuleGameOver::OnMouseClick(int button, int x, int y)
{
	//Module::OnMouseClick(button,x,y);
}

void ModuleGameOver::OnMousePressed(int button, int x, int y)
{
	//Module::OnMousePressed(button, x, y);
}

void ModuleGameOver::OnMouseReleased(int button, int x, int y)
{
	//Module::OnMouseReleased(button, x, y);
}

void ModuleGameOver::OnMouseWheelUp(int x, int y)
{
	//Module::OnMouseWheelUp(x, y);
}

void ModuleGameOver::OnMouseWheelDown(int x, int y)
{
	//Module::OnMouseWheelDown(x, y);
}

void ModuleGameOver::OnEvent(Event *event)
{
	//Module::OnEvent(event);
}


bool ModuleGameOver::Init()
{
	//Module::Init();
	return true;
}

void ModuleGameOver::Close()
{
	//Module::Close();
}


void ModuleGameOver::Update()
{
	//Module::Update();


	if (bQuickShutdown)
	{
		g_game->shutdown();
	}
}

void ModuleGameOver::Draw()
{
	//Module::Draw();

	clear(g_game->GetBackBuffer());
	
	//g_game->setFontSize(120);
	g_game->Print32(g_game->GetBackBuffer(), 400, 300, "G A M E  O V E R", RED);

}

