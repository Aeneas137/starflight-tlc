/*
	STARFLIGHT - THE LOST COLONY
	ModuleStartup.cpp - Handles opening sequences, videos, copyrights, prior to titlescreen.
	The purpose of this module is to free up resources and reduce the logic in titlescreen
	which was having to deal with the startup sequence. This is just easier.
	Author: J.Harbour
	Date: Jan,2008
*/

#include "env.h"
#include <exception>
#include <allegro.h>
#include "Game.h"
#include "ModeMgr.h"
#include "DataMgr.h"
#include "Events.h"
#include "Util.h"
#include "ModuleStartup.h"
#include <string>

void showOpeningStory(int page);
int storypage = 0;

ModuleStartup::ModuleStartup()
{
	display_mode = 3;
}

ModuleStartup::~ModuleStartup(){}


bool ModuleStartup::Init()
{
    m_background = (BITMAP*)load_bitmap("data/startup/space_1280.bmp",NULL);


	//load copyright screen
	copyright = (BITMAP*)load_bitmap("data/startup/STARTUP_COPYRIGHTS.BMP",NULL);
	if (!copyright) {
		g_game->message("Startup: Error loading startup_copyrights");
		return false;
	}

	//create fader scratch pad
	fader = create_bitmap(SCREEN_W, SCREEN_H);

	return true;
}

void ModuleStartup::Close()
{
	try {
		destroy_bitmap(fader);
		destroy_bitmap(scratchpad);
        destroy_bitmap(copyright);
        destroy_bitmap(m_background);
	}
	catch(std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in Startup::Close\n");
	}
}


int ModuleStartup::fadein(BITMAP *dest, BITMAP *source, int speed)
{
	int retval = 0;
	static int loop = 0;
	
	if (loop < 256-speed)
	{
		loop += speed;
		clear(fader);
		set_trans_blender(0,0,0,loop);
		draw_trans_sprite(fader, source, 0, 0);
		blit(fader, dest, 0,0, 0,0, source->w, source->h);
	}
	else {
		loop = 0;
		retval = 1;
	}

	return retval;
}

int ModuleStartup::fadeout(BITMAP *dest, BITMAP *source, int speed)
{
	int retval = 0;
	static int loop = 255;

	if (loop > speed)
	{
		loop -= speed;
		clear(fader);
		set_trans_blender(0,0,0,loop);
		draw_trans_sprite(fader, source, 0, 0);
		blit(fader, dest, 0,0, 0,0, source->w, source->h);
	}
	else {
		rectfill(dest, 0,0, source->w, source->h, makecol(0,0,0));
		loop = 255;
		retval = 1;
	}

	return retval;
}

void ModuleStartup::Update(){}

void ModuleStartup::Draw()
{
	static bool title_done = false;

    blit(m_background, g_game->GetBackBuffer(), 0, 0, 0, 0, g_game->GetBackBuffer()->w, g_game->GetBackBuffer()->h);

	switch (display_mode) {

    case 0: //initial blank period to slow down the intro
        if (Util::ReentrantDelay(4000)) 
            display_mode = 1;
        break;

	case 1: //copyright fadein
		if (!title_done) {
			if (fadein(g_game->GetBackBuffer(), copyright, 1)) {
				title_done = true;
			}

		} else {
			blit(copyright, g_game->GetBackBuffer(), 0, 0, 0, 0, copyright->w, copyright->h);
			if (Util::ReentrantDelay(4000))
				display_mode = 2;
		}
		break;
		
	case 2: //copyright fadeout
		title_done = false;
		if (fadeout(g_game->GetBackBuffer(), copyright, 2)) {
			display_mode = 3;
		}
		break;


    case 3: //opening story
        showOpeningStory(storypage);
        break;

	case 100: //done, transition to TitleScreen
		if (Util::ReentrantDelay(1000))
        {
		    g_game->modeMgr->LoadModule(MODULE_TITLESCREEN);
		    return;
        }
		break;
		
	}
}

#pragma region INPUT

void ModuleStartup::OnKeyPress(int keyCode){}
void ModuleStartup::OnKeyPressed(int keyCode){}

void ModuleStartup::OnKeyReleased(int keyCode)
{
	switch (display_mode) {
	
	//pressing any key will fast forward the slideshow
	case 1: //fade in copyright
		display_mode = 2;
		break;

	case 2: //fade out copyright
		display_mode = 3;
		break;

    case 3: //opening story
        storypage++;
        if (storypage > 4)
            display_mode = 100;
        break;

	case 100: //done
		break;
	}
}

void ModuleStartup::OnMouseMove(int x, int y){}
void ModuleStartup::OnMouseClick(int button, int x, int y){}
void ModuleStartup::OnMousePressed(int button, int x, int y){}
void ModuleStartup::OnMouseReleased(int button, int x, int y)
{
	switch (display_mode) {
	
	//mouse click to turn each page
	case 1: //fade in copyright
		display_mode = 2;
		break;

	case 2: //fade out copyright
		display_mode = 3;
		break;

    case 3: //opening story
        storypage++;
        if (storypage > 4)
            display_mode = 100;
        break;

	case 100: //done
		break;
	}
}

#pragma endregion


void ModuleStartup::OnEvent(Event *event){}


void showOpeningStory(int page)
{
 /*   g_game->Print18(g_game->GetBackBuffer(), 50, SCREEN_HEIGHT-40,
        "PAGE " + Util::ToString(page), YELLOW, true);
    g_game->Print18( g_game->GetBackBuffer(), SCREEN_WIDTH-350, SCREEN_HEIGHT-40, 
        "Press any key or mouse button to continue...", YELLOW, true);*/

    int y=50,x=100,spacing=28;
    for (int j=0; j<lines; j++) 
    {
        g_game->Print24( g_game->GetBackBuffer(), x, y, story[page][j] );
        y+=spacing;
    }

}

