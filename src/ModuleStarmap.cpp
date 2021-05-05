/*
	STARFLIGHT - THE LOST COLONY
	ModuleStarmap.cpp - The Starmap module.
	Author: Keith "Daikaze" Patch
	Date: ??-??-????
*/

#include "env.h"
#include <allegro.h>
#include "Util.h"
#include "ModuleStarmap.h"
#include "GameState.h"
#include "Game.h"
#include "AudioSystem.h"
#include "Events.h"
#include "DataMgr.h"
#include "Script.h"
#include "PlayerShipSprite.h"

#define FLUX_TILE_TRANS_BMP              0        /* BMP  */
#define IS_TILES_TRANS_BMP               1        /* BMP  */
#define STARMAP_VIEWER_BMP               2        /* BMP  */
Sprite flux_sprite;
DATAFILE *smdata;


ModuleStarmap::ModuleStarmap() {
	map_active = false;
	ratioX = 0;
	ratioY = 0;
	cursorPos.y = 0;
	cursorPos.x = 0;
	dest_active = false;
	m_destPos.y = 0;
	m_destPos.x = 0;
	star_label = NULL;
	m_bOver_Star = false;
	star_x = 0;
	star_y = 0;
}

ModuleStarmap::~ModuleStarmap()
{
}

void ModuleStarmap::OnKeyPressed(int keyCode)
{
	Module::OnKeyPressed(keyCode);
}

void ModuleStarmap::OnKeyPress( int keyCode )
{
	Module::OnKeyPress( keyCode );
}

void ModuleStarmap::OnKeyReleased(int keyCode){
	Module::OnKeyReleased(keyCode);
}

void ModuleStarmap::OnMouseMove(int x, int y)
{
	Module::OnMouseMove(x,y);
	if(y > MAP_POS_Y && y < MAP_POS_Y+MAP_HEIGHT
	&& x > MAP_POS_X && x < MAP_POS_X+MAP_WIDTH){
		cursorPos.y = (float)(y-MAP_POS_Y)/ratioY;
		cursorPos.x = (float)(x-MAP_POS_X)/ratioX;

		//if the mouse pointer is over a starsystem, we need to remember that
		//starsystem name and coordinates to display them later at Draw() time.
		Star* starSystem = NULL;
		for(int _y = -1; _y <= 1; _y++){
			if(starSystem){break;}
			for(int _x = -1; _x <= 1; _x++){
				//because of the way starsystems are positionned on the starmap we need +1 to the x, and +2 to y here
				starSystem = g_game->dataMgr->GetStarByLocation((int)(cursorPos.x+_x +1),(int)(cursorPos.y-+_y +2));
				if (starSystem) {
					star_x = starSystem->x;
					star_y = starSystem->y;
					star_label->SetText( starSystem->name );
					m_bOver_Star = true;
					break;
				}else {
					m_bOver_Star = false;
				}
			}
		}
	}
}

void ModuleStarmap::OnMouseClick(int button, int x, int y)
{
	Module::OnMouseClick(button,x,y);
	if(map_active == true){
		if(y > MAP_POS_Y && y < MAP_POS_Y+MAP_HEIGHT
		&& x > MAP_POS_X && x < MAP_POS_X+MAP_WIDTH){
			if(cursorPos.y > m_destPos.y - 2 && cursorPos.y < m_destPos.y + 2
			&& cursorPos.x > m_destPos.x - 2 && cursorPos.x < m_destPos.x + 2 
			&& dest_active == true){
				dest_active = false;
			}else{
				m_destPos.y = (float)(y-MAP_POS_Y)/ratioY;
				m_destPos.x = (float)(x-MAP_POS_X)/ratioX;
				dest_active = true;
			}
		}
	}
}

void ModuleStarmap::OnMousePressed(int button, int x, int y)
{
	Module::OnMousePressed(button, x, y);
}

void ModuleStarmap::OnMouseReleased(int button, int x, int y)
{
	Module::OnMouseReleased(button, x, y);
}

void ModuleStarmap::OnMouseWheelUp(int x, int y)
{
	Module::OnMouseWheelUp(x, y);
}

void ModuleStarmap::OnMouseWheelDown(int x, int y)
{
	Module::OnMouseWheelDown(x, y);
}

void ModuleStarmap::OnEvent(Event *event)
{
	Module::OnEvent(event);
	switch(event->getEventType()) {
		case 3001:
			if(!map_active){
				map_active = true;
			}else{
				map_active = false;
			}
			break;
	}
}


bool ModuleStarmap::Init()
{
	//if (!Module::Init()) return false;
	TRACE("  ModuleStarmap Initialize\n");

	//load the datafile
	smdata = load_datafile("data/starmap/starmap.dat");
	if (!smdata) {
		g_game->message("Starmap: Error loading datafile");	
		return false;
	}


	//initialize constants
	Script *lua = new Script();
	lua->load("data/starmap/starmap.lua");
	FUEL_PER_UNIT = (float)lua->getGlobalNumber("FUEL_PER_UNIT");
	VIEWER_WIDTH = (int)lua->getGlobalNumber("VIEWER_WIDTH");
	VIEWER_HEIGHT = (int)lua->getGlobalNumber("VIEWER_HEIGHT");
	MAP_WIDTH = (int)lua->getGlobalNumber("MAP_WIDTH");
	MAP_HEIGHT = (int)lua->getGlobalNumber("MAP_HEIGHT");
	X_OFFSET = (int)lua->getGlobalNumber("X_OFFSET");
	Y_OFFSET = (int)lua->getGlobalNumber("Y_OFFSET");
	MAP_POS_X = (int)lua->getGlobalNumber("MAP_POS_X");
	MAP_POS_Y = (int)lua->getGlobalNumber("MAP_POS_Y");
	VIEWER_TARGET_OFFSET = (int)lua->getGlobalNumber("VIEWER_TARGET_OFFSET");
	viewer_offset_y = -VIEWER_TARGET_OFFSET;
	VIEWER_MOVE_RATE = (int)lua->getGlobalNumber("VIEWER_MOVE_RATE");
	delete lua;

	//load starmap GUI
	gui_starmap = (BITMAP*)smdata[STARMAP_VIEWER_BMP].dat;
	if (!gui_starmap) {
		g_game->message("Starmap: Error loading background");
		return 0;
	}

	m_bOver_Star = false;
	star_label = new Label("",0,0,100,22,ORANGE,g_game->font18);

	starview = create_bitmap(MAP_WIDTH, MAP_HEIGHT);
	clear_to_color(starview,BLACK);

	flux_view = create_bitmap(MAP_WIDTH, MAP_HEIGHT);
	clear_to_color(flux_view,makecol(255,0,255));

	text = create_bitmap(VIEWER_WIDTH, VIEWER_HEIGHT);
	clear_to_color(text,makecol(255,0,255));

	ratioX = (float)MAP_WIDTH / 250.0f;
	ratioY = (float)MAP_HEIGHT / 220.0f;

	clear_to_color(starview,makecol(0,0,0));


	//flux_sprite = new Sprite();

	flux_sprite.setImage( (BITMAP*)smdata[FLUX_TILE_TRANS_BMP].dat );
	if (!flux_sprite.getImage()) {
		g_game->message("Starmap: Error loading flux_sprite");	
		return false;
	}

	flux_sprite.setAnimColumns(1);
	flux_sprite.setTotalFrames(1);
	flux_sprite.setWidth(8);
	flux_sprite.setHeight(8);
	flux_sprite.setFrameWidth(8);
	flux_sprite.setFrameHeight(8);

	/*	flux_iter i = g_game->dataMgr->flux.begin();
		while(i != g_game->dataMgr->flux.end() ){
			//if((*i)->VISIBLE() == true && (*i)->DRAWN() == false){
				//if((*i)->PATH_VISIBLE() == true){
					line(flux_view, 
						(int)( (*i)->TILE().X * ratioX ),
						(int)( (*i)->TILE().Y * ratioY),
						(int)( (*i)->TILE_EXIT().X * ratioX + 2 ),
						(int)( (*i)->TILE_EXIT().Y * ratioY + 2),
						makecol(0,170,255));
				//}
				flux_sprite.setX((*i)->TILE().X * ratioX - 4);
				flux_sprite.setY((*i)->TILE().Y * ratioY - 4);
				flux_sprite.drawframe(flux_view);
				(*i)->rDRAWN() = true;
		//	}
			i++;
		}*/
	//delete flux_sprite;

	//load star tile image
	stars = new Sprite();
	
	stars->setImage( (BITMAP*)smdata[IS_TILES_TRANS_BMP].dat );
	if (!stars->getImage()) {
		g_game->message("Starmap: Error loading stars");
		return false;
	}

	stars->setAnimColumns(8);
	stars->setTotalFrames(8);
	stars->setFrameWidth(8);
	stars->setFrameHeight(8);
	int spectral = -1;
	Star *star;

	for (int i = 0; i < g_game->dataMgr->GetNumStars(); i++)  {
		star = g_game->dataMgr->GetStar(i);

		//these numbers match the ordering of the images in is_tiles.bmp
		switch (star->spectralClass ) {
			case SC_O: spectral = 7; break;		//blue
			case SC_M: spectral = 6; break;		//red
			case SC_K: spectral = 5; break;		//orange
			case SC_G: spectral = 4; break;		//yellow
			case SC_F: spectral = 3; break;		//lt yellow
			case SC_B: spectral = 2; break;		//lt blue
			case SC_A: spectral = 1; break;		//white
			default: ASSERT(0);
		}
		//draw star image on starmap
		stars->setCurrFrame(spectral);
		stars->setX(star->x * ratioX - 3);//-4 due to the star's width, and +1 for compensation reasons
		stars->setY(star->y * ratioY - 3);//-4 due to the star's width, and +1 for compensation reasons
		stars->drawframe(starview); 
	}
	delete stars;
	return true;
}

void ModuleStarmap::Close()
{
	//Module::Close();
	
	try {
		if (starview != NULL){
			destroy_bitmap(starview);
			starview = NULL;
		}
		//if (gui_starmap != NULL){
		//	destroy_bitmap(gui_starmap);
		//	temp = NULL;
		//}
		if (text != NULL){
			destroy_bitmap(text);
			text = NULL;
		}

		if (flux_view != NULL){
			destroy_bitmap(flux_view);
			flux_view = NULL;
		}

		if (star_label != NULL){
			delete star_label;
			star_label = NULL;
		}
		
		smdata = NULL;

		flux_iter i = g_game->dataMgr->flux.begin();
		while(i != g_game->dataMgr->flux.end() ){
			(*i)->rDRAWN() = false;
			(*i)->rLINE_DRAWN() = false;
			i++;
		}
		//unload the data file (thus freeing all resources at once)
		unload_datafile(smdata);
	}
	catch (std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in Starmap::Close\n");
	}

}

void ModuleStarmap::Update(){
	Module::Update();
	if(map_active){
		if(g_game->gameState->getCurrentSelectedOfficer() != OFFICER_NAVIGATION){
			map_active = false;
		}
	}
}

void ModuleStarmap::Draw()
{
	Module::Draw();	
	if(viewer_offset_y > -VIEWER_TARGET_OFFSET){
		masked_blit(gui_starmap,g_game->GetBackBuffer(),0,0,120,viewer_offset_y,VIEWER_WIDTH,VIEWER_HEIGHT);	
	#pragma region Draw Flux
		flux_iter i = g_game->dataMgr->flux.begin();
		while(i != g_game->dataMgr->flux.end() ){
			if((*i)->VISIBLE() == true){
				if((*i)->PATH_VISIBLE() && (*i)->LINE_DRAWN() == false){
					line(flux_view, 
						(int)( (*i)->TILE().X * ratioX - 2 ),
						(int)( (*i)->TILE().Y * ratioY - 4 ),
						(int)( (*i)->TILE_EXIT().X * ratioX + 4 ),
						(int)( (*i)->TILE_EXIT().Y * ratioY + 4 ),
						makecol(0,170,255));
					(*i)->rLINE_DRAWN() = true;
				}
				if((*i)->DRAWN() == false){
					flux_sprite.setX((*i)->TILE().X * ratioX - 4);
					flux_sprite.setY((*i)->TILE().Y * ratioY - 4);
					flux_sprite.drawframe(flux_view);
					(*i)->rDRAWN() = true;
				}
			}
			i++;
		}
	#pragma endregion
	#pragma region Draw Starmap
		int new_x_offset = 120+X_OFFSET;
		int new_y_offset = Y_OFFSET+viewer_offset_y;
		int text_y = 480;
		int fontColor = makecol(0,0,0);
		clear_to_color(text,makecol(255,0,255));

		masked_blit(starview,g_game->GetBackBuffer(),0,0,new_x_offset, new_y_offset,MAP_WIDTH,MAP_HEIGHT);
		masked_blit(flux_view,g_game->GetBackBuffer(),0,0,new_x_offset, new_y_offset,MAP_WIDTH,MAP_HEIGHT);

		//display status info
		if(g_game->gameState->player->isLost() == false){
			Point2D playerPos;
			playerPos.x = 4 + g_game->gameState->player->posHyperspace.x / 128; //offset of 4 tiles
			playerPos.y = 2 + g_game->gameState->player->posHyperspace.y / 128; //offset of 2 tiles

			PlayerShipSprite shipSprite;
			float distance = Point2D::Distance( playerPos, cursorPos );

			if(dest_active == true){distance = Point2D::Distance( playerPos, m_destPos );}
			float max_vel = shipSprite.getMaximumVelocity();
			float fuel = distance * max_vel / 100 / g_game->gameState->getShip().getEngineClass();
			
			// position
			textprintf_centre_ex(text, font, 115, text_y, fontColor, -1, "%.0f", playerPos.x );
			textprintf_centre_ex(text, font, 189, text_y, fontColor, -1, "%.0f", playerPos.y );

			// distance
			textprintf_centre_ex(text, font, 505, text_y, fontColor, -1, "%.1f", distance );

			// fuel
			textprintf_centre_ex(text, font, 620, text_y, fontColor, -1, "%.2f", fuel );
		

			circle(g_game->GetBackBuffer(), (int)(playerPos.x * ratioX + new_x_offset), 
			 (int)(new_y_offset + (playerPos.y) * ratioY), 4, makecol(0,255,0));
		}

		// destination
		
		//if player selected a spot, print the coordinates of that spot
		if (dest_active){
/*
	This next stmt is for debuggng only. Set/unset red circle on starmap to move player. JJH
*/
			if (g_game->getGlobalBoolean("DEBUG_OUTPUT") == true) g_game->gameState->player->set_galactic_pos(m_destPos.x * 128,m_destPos.y * 128);

			textprintf_centre_ex(text, font, 310, text_y, fontColor, -1, "%.0f", m_destPos.x );
			textprintf_centre_ex(text, font, 380, text_y, fontColor, -1, "%.0f", m_destPos.y );
			circle(g_game->GetBackBuffer(), (int)(m_destPos.x * ratioX + new_x_offset), 
			(int)(new_y_offset + (m_destPos.y) * ratioY), 4, makecol(255,0,0));
		}
		//else if the mouse cursor is near a starsystem, we want to print the coordinates 
		//of that starsystem instead of the actual coordinates under the mouse pointer
		else if(m_bOver_Star == true){
			// we want "%i" here rather than "%.0f" since star_x, star_y are integers
			textprintf_centre_ex(text, font, 310, text_y, fontColor, -1, "%i", star_x );
			textprintf_centre_ex(text, font, 380, text_y, fontColor, -1, "%i", star_y );
			star_label->Refresh();
			star_label->SetX((int)(cursorPos.x * ratioX + new_x_offset + 10));
			star_label->SetY((int)(cursorPos.y * ratioY + new_y_offset));
			star_label->Draw(g_game->GetBackBuffer());
			}
		//else print the the coordinate under mouse pointer
			else{
				textprintf_centre_ex(text, font, 310, text_y, fontColor, -1, "%.0f", cursorPos.x);
				textprintf_centre_ex(text, font, 380, text_y, fontColor, -1, "%.0f", cursorPos.y);
			}
		}
		//draw generated text
		masked_blit(text,g_game->GetBackBuffer(),0,0,120+X_OFFSET/2,viewer_offset_y,VIEWER_WIDTH,VIEWER_HEIGHT);
	
	#pragma endregion
	if(map_active){
		if(viewer_offset_y < -30){
			viewer_offset_y += VIEWER_MOVE_RATE;
		}
	}else{
		if(viewer_offset_y > -VIEWER_TARGET_OFFSET){
			viewer_offset_y -= VIEWER_MOVE_RATE;
		}
	}
}
