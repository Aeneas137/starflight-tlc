/*
	STARFLIGHT - THE LOST COLONY
	ModuleTopGUI.cpp 
	Author: Keith Patch
	Date: April 2008
*/

#include "env.h"
#include <allegro.h>
#include "Util.h"
#include "GameState.h"
#include "Game.h"
#include "Events.h"
#include "Script.h"
#include "ModuleTopGUI.h"
#include "DataMgr.h"
#include "ModeMgr.h"

int ggx = 0;
int ggy = 0;


ModuleTopGUI::ModuleTopGUI() {}
ModuleTopGUI::~ModuleTopGUI(){}

bool ModuleTopGUI::Init()
{
	//canvas = g_game->GetBackBuffer();

	ggx = (int)g_game->getGlobalNumber("GUI_GAUGES_POS_X");
	ggy = (int)g_game->getGlobalNumber("GUI_GAUGES_POS_Y");

	//load the gauges gui
	img_gauges = load_bitmap("data/topgui/topgauge.tga", NULL);
	img_fuel_gauge = load_bitmap("data/topgui/Element_Gauge_Orange.bmp", NULL);
	img_hull_gauge = load_bitmap("data/topgui/Element_Gauge_Green.bmp", NULL);
	img_shield_gauge = load_bitmap("data/topgui/Element_Gauge_Blue.bmp", NULL);
	img_armor_gauge = load_bitmap("data/topgui/Element_Gauge_Red.bmp", NULL);

	return true;
}

void ModuleTopGUI::Close()
{
	try {
		destroy_bitmap(img_gauges);
		destroy_bitmap(img_fuel_gauge);
		destroy_bitmap(img_armor_gauge);
		destroy_bitmap(img_hull_gauge);
		destroy_bitmap(img_shield_gauge);
	}
	catch(std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in ModuleTopGUI::Close\n");
	}
}
	
void ModuleTopGUI::Update(){}

void ModuleTopGUI::Draw()
{
	float fuel_percent = g_game->gameState->getShip().getFuel();
	float hull_percent = g_game->gameState->getShip().getHullIntegrity() / 100;
	float armor_percent = 0; 
	float shield_percent = 0;
	
	if(g_game->gameState->getShip().getMaxArmorIntegrity() <= 0)
	{
		armor_percent = 0;
	}
	else{
		armor_percent = g_game->gameState->getShip().getArmorIntegrity() / g_game->gameState->getShip().getMaxArmorIntegrity();
	}

	if (g_game->gameState->getShip().getMaxShieldCapacity() <= 0)
	{
		shield_percent = 0;
	}
	else{
		shield_percent = g_game->gameState->getShip().getShieldCapacity() / g_game->gameState->getShip().getMaxShieldCapacity();
	}
	/*
	 * draw top gauge gui
	 */
	draw_trans_sprite(g_game->GetBackBuffer(), img_gauges, ggx, ggy);
	//masked_blit(img_gauges, g_game->GetBackBuffer(), 0, 0, ggx, ggy, img_gauges->w, img_gauges->h);
	masked_blit(img_hull_gauge, g_game->GetBackBuffer(), 0, 0, ggx+89, ggy+15, img_hull_gauge->w * hull_percent, img_hull_gauge->h);
	masked_blit(img_armor_gauge, g_game->GetBackBuffer(), 0, 0, ggx+273, ggy+15, img_armor_gauge->w * armor_percent, img_armor_gauge->h);
	masked_blit(img_shield_gauge, g_game->GetBackBuffer(), 0, 0, ggx+464, ggy+15, img_shield_gauge->w * shield_percent, img_shield_gauge->h);
	masked_blit(img_fuel_gauge, g_game->GetBackBuffer(), 0, 0, ggx+630, ggy+14, img_fuel_gauge->w * fuel_percent, img_fuel_gauge->h);

}

void ModuleTopGUI::OnKeyPressed(int keyCode){}
void ModuleTopGUI::OnKeyPress( int keyCode ){}
void ModuleTopGUI::OnKeyReleased(int keyCode){}
void ModuleTopGUI::OnMouseMove(int x, int y){}
void ModuleTopGUI::OnMouseClick(int button, int x, int y){}
void ModuleTopGUI::OnMousePressed(int button, int x, int y){}
void ModuleTopGUI::OnMouseReleased(int button, int x, int y){}
void ModuleTopGUI::OnMouseWheelUp(int x, int y){}
void ModuleTopGUI::OnMouseWheelDown(int x, int y){}
void ModuleTopGUI::OnEvent(Event *event){}
