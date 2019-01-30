/*
	STARFLIGHT - THE LOST COLONY
	ModuleStarmap.cpp - The QuestLog Module
	Author: Justin Sargent
	Date: Nov-24-2007
*/

#include "env.h"
#include <allegro.h>
#include "ModuleQuestLog.h"
#include "GameState.h"
#include "Game.h"
#include "QuestMgr.h"
#include "Events.h"
#include "DataMgr.h"
#include "Label.h"
#include "ModuleControlPanel.h"
using namespace std;

#define VIEWER_MOVE_RATE 16

#define NAME_X 36
#define NAME_Y 36
#define NAME_H 48
#define NAME_W 290

#define DESC_X NAME_X
#define DESC_Y NAME_Y + NAME_H + 8
#define DESC_H 190
#define DESC_W NAME_W

#define QUEST_VIEWER_BMP                 0        /* BMP  */

DATAFILE *qldata;


ModuleQuestLog::ModuleQuestLog() 
{
	log_active = false;
}

ModuleQuestLog::~ModuleQuestLog()
{
}

void ModuleQuestLog::OnKeyPressed(int keyCode){}
void ModuleQuestLog::OnKeyPress( int keyCode ){}
void ModuleQuestLog::OnKeyReleased(int keyCode){}
void ModuleQuestLog::OnMouseMove(int x, int y){}
void ModuleQuestLog::OnMouseClick(int button, int x, int y){}
void ModuleQuestLog::OnMousePressed(int button, int x, int y){}
void ModuleQuestLog::OnMouseReleased(int button, int x, int y){}
void ModuleQuestLog::OnMouseWheelUp(int x, int y){}
void ModuleQuestLog::OnMouseWheelDown(int x, int y){}
void ModuleQuestLog::OnEvent(Event *event)
{
	switch(event->getEventType()) 
	{
		case EVENT_CAPTAIN_QUESTLOG:
			if(!log_active){
				log_active = true;
			}else{
				log_active = false;
			}
			break;
	}
}

void ModuleQuestLog::Close()
{
	try {
		//close the datafile
		unload_datafile(qldata);
		qldata = NULL;
	}
	catch(std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in QuestLog::Close\n");
	}
}

bool ModuleQuestLog::Init()
{
	TRACE("ModuleQuestLog Initialize\n");
	
	//load the datafile
	qldata = load_datafile("data/questviewer/questviewer.dat");
	if (!qldata) {
		g_game->message("QuestLog: Error loading datafile");	
		return false;
	}
	

	viewer_offset_x = SCREEN_WIDTH;
	viewer_offset_y = 90;

	log_active = false;

	//create quest name label
	int questTitleColor = makecol(255,84,0);
	questName = new Label(g_game->questMgr->getName(), 
		viewer_offset_x+NAME_X, viewer_offset_y+NAME_Y, NAME_W, NAME_H, questTitleColor, g_game->font22);
	questName->Refresh();

	//create quest description label
	int questTextColor = makecol(255,255,255);
	questDesc = new Label(g_game->questMgr->getShort(), 
		viewer_offset_x+DESC_X, viewer_offset_y+DESC_Y, DESC_W, DESC_H, questTextColor, g_game->font22);
	questDesc->Refresh();


	//load window GUI
	window = (BITMAP*)qldata[QUEST_VIEWER_BMP].dat;
	if (!window) {
		g_game->message("Error loading quest log window");
		return 0;
	}

	return true;
}

void ModuleQuestLog::Update()
{
	if(log_active){
		if(g_game->gameState->getCurrentSelectedOfficer() != OFFICER_CAPTAIN){
			log_active = false;
		}
	}
}


void ModuleQuestLog::Draw()
{
	//is quest viewer visible?
	if(viewer_offset_x < SCREEN_WIDTH)
	{
		//draw background
		masked_blit(window,g_game->GetBackBuffer(),0,0,viewer_offset_x,viewer_offset_y,window->w,window->h);

		//draw quest title
		questName->SetX(NAME_X + viewer_offset_x);
		questName->Draw(g_game->GetBackBuffer());

		//draw quest description
		questDesc->SetX(DESC_X + viewer_offset_x);
		questDesc->Draw(g_game->GetBackBuffer());	


		//display quest completion status
		string metstr;
		int metcolor;
		if (g_game->gameState->getQuestCompleted()) {
			metstr = "(COMPLETE)";
			metcolor = GREEN;
		}
		else {
			metstr = "(INCOMPLETE)";
			metcolor = RED;
		}
		g_game->Print20(g_game->GetBackBuffer(), viewer_offset_x + NAME_X, viewer_offset_y+DESC_Y+DESC_H, metstr, metcolor);


	}

	if(log_active)
	{
		if(viewer_offset_x > 620) {
			viewer_offset_x -= VIEWER_MOVE_RATE;
		}
	}else{
		if(viewer_offset_x < SCREEN_WIDTH) {
			viewer_offset_x += VIEWER_MOVE_RATE;
		}
	}
}

