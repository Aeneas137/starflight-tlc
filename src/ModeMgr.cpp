/*
	STARFLIGHT - THE LOST COLONY
	ModeMgr.cpp - ?
	Author: ?
	Date: ?
*/

#include "env.h"		//for TRACE calls
#include <allegro.h>	//for TRACE calls

#include "ModeMgr.h"
#include "Module.h"
#include "GameState.h"
#include "Game.h"
#include "MessageBoxWindow.h"
#include "PauseMenu.h"
#include "AudioSystem.h"


using namespace std;

Mode::Mode(Module *module, std::string path) : rootModule(module), musicPath(path)
{}

ModeMgr::ModeMgr(Game *game):
	m_activeRootModule(NULL),
	currentMusic(NULL)
{
	prevModeName = "";
	currentModeName = "";
}

ModeMgr::~ModeMgr()
{
	TRACE("[DESTROYING MODULES]\n");
	try {
		map<string,Mode *>::iterator i;
		i = m_modes.begin(); 

		bool isOperationsRoom, operationsRoomDeleted= false; //needed!! (cannot delete same object 3x)
		while ( i != m_modes.end() )
		{
			if (i->first.length() > 0) {
				if (  (strcmp(i->first.c_str(), "CANTINA") == 0)
					||(strcmp(i->first.c_str(), "RESEARCHLAB") == 0)
					||(strcmp(i->first.c_str(), "MILITARYOPS") == 0))
					isOperationsRoom= true;
				else
					isOperationsRoom= false;
					
				if ((!isOperationsRoom) || (!operationsRoomDeleted)) {
					if (isOperationsRoom) operationsRoomDeleted= true;
					TRACE("  Destroying %s\n", i->first.c_str());
					delete i->second;
				}
				else {
					TRACE("  Module %s was previously deleted (object assigned 3x)\n", i->first.c_str());
				}
			}
			++i;
		}
	}
	catch(std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in ~ModeMgr\n");
	}
}

void ModeMgr::EndGame() 
{ 
	g_game->shutdown();
}

void ModeMgr::AddMode(string modeName, Module *rootModule, std::string musicPath) 
{
	if ( musicPath.compare("") != 0 && !file_exists(musicPath.c_str(),FA_ALL,NULL) ){
		std::string error = "ModeMgr::AddMode: [ERROR] file " + musicPath + " does not exist";
		g_game->fatalerror(error);
	}

	Mode *newmode = new Mode(rootModule, musicPath);
	m_modes[modeName] = newmode;
}

void ModeMgr::CloseCurrentModule()
{
	ASSERT(m_activeRootModule || !g_game->IsRunning());
	if ( m_activeRootModule == NULL) return;

	m_activeRootModule->Close();
	m_activeRootModule = NULL;
}

bool ModeMgr::LoadModule(std::string newModeName)
{
	bool result = false;

	//disable the Pause Menu
	g_game->pauseMenu->setEnabled(false);

	// search the current and new modes in the m_modes associative array
	map<string,Mode*>::iterator icurr = m_modes.find(currentModeName);
	map<string,Mode*>::iterator inew = m_modes.find(newModeName);

	if ( inew == m_modes.end() ) {
		g_game->message( "Error '" + newModeName + "' is not a valid mode name");
		return false;
	}

	//save module name
	this->prevModeName = this->currentModeName;
	this->currentModeName = newModeName;

	//store module name in gamestate
	g_game->gameState->setCurrentModule(newModeName);

	//the following will always be true except exactly once, at game start
	if ( icurr != m_modes.end() ){
		//close active module
		TRACE("ModeMgr: closing module '%s'\n", this->prevModeName.c_str());
		CloseCurrentModule();
		TRACE("ModeMgr: module '%s' closed\n\n", this->prevModeName.c_str());
	}

	//launch new module 
	TRACE("ModeMgr: initializing module '%s'\n", newModeName.c_str());
	m_activeRootModule = inew->second->rootModule;
	result = m_activeRootModule->Init();
	TRACE("ModeMgr: module '%s' Init(): %s\n", newModeName.c_str(), result? "SUCCESS" : "FAILURE");

	if (!result) return false;


	//handle background music

	//if we don't want music, we are done
	if ( !g_game->getGlobalBoolean("AUDIO_MUSIC") ) return true;

	std::string currentMusicPath = (icurr==m_modes.end())? "" : icurr->second->musicPath;
	std::string newMusicPath = inew->second->musicPath;


	//if new music == current music, we do nothing (iow: we let it play)
	if ( newMusicPath.compare(currentMusicPath) == 0 ) return true;
	//if new music == "", we do nothing either (iow: we let the new module handle it all by itself)
	if ( newMusicPath.compare("") == 0 ) return true;


	//stop the current music, unless we were told not to deal with it.
	if ( currentMusicPath.compare("") != 0 && currentMusic != NULL ){ 
		TRACE("ModeMgr: stop playing music %s\n", currentMusicPath.c_str());
		g_game->audioSystem->Stop(currentMusic);
		delete currentMusic;
		currentMusic = NULL;
	}


	TRACE("ModeMgr: start playing music %s\n", newMusicPath.c_str());
	currentMusic = g_game->audioSystem->LoadMusic(newMusicPath);
	if ( currentMusic == NULL ){
		g_game->message("Error loading music from " + newMusicPath);
		return false;
	}

	if ( !g_game->audioSystem->PlayMusic(currentMusic) ){
		g_game->message("Error playing music from " + newMusicPath);
		return false;
	}

	return true;
}

void ModeMgr::Update()
{
	ASSERT(m_activeRootModule || !g_game->IsRunning());
	if (m_activeRootModule==NULL) return;

	m_activeRootModule->Update();
}

void ModeMgr::Draw()
{
	ASSERT(m_activeRootModule || !g_game->IsRunning());
	if (m_activeRootModule==NULL) return;

	m_activeRootModule->Draw();
}

void ModeMgr::BroadcastEvent(Event *event)
{
	ASSERT(m_activeRootModule || !g_game->IsRunning());

	//determine if messagebox or pausemenu need to be removed
	//0xDEADBEEF are events related to these pop-up controls
	//0xDEADBEEF+1 is always a close event for the control
	int evtype = event->getEventType();
	if ( (unsigned int) evtype >= 0xDEADBEEF+1 && (unsigned int) evtype <= 0xDEADBEEF+4)
	{
		//hide the pause menu
		if ( g_game->pauseMenu->isShowing() )
			g_game->TogglePauseMenu();

		//hide the messagebox
		if (g_game->messageBox != NULL)
			g_game->messageBox->SetVisible(false);
	}

	if (m_activeRootModule==NULL) return;

	//if this is not a close event, pass it on
	if ( (unsigned int) evtype != 0xDEADBEEF+1)
		m_activeRootModule->OnEvent(event);
}
 
void ModeMgr::OnKeyPress(int keyCode) 
{
	ASSERT(m_activeRootModule || !g_game->IsRunning());
	if (m_activeRootModule==NULL) return;

	m_activeRootModule->OnKeyPress(keyCode);
}

void ModeMgr::OnKeyPressed(int keyCode)
{
	ASSERT(m_activeRootModule || !g_game->IsRunning());
	if (m_activeRootModule==NULL) return;

	m_activeRootModule->OnKeyPressed(keyCode);
}

void ModeMgr::OnKeyReleased(int keyCode)
{
	ASSERT(m_activeRootModule || !g_game->IsRunning());
	if (m_activeRootModule==NULL) return;

	m_activeRootModule->OnKeyReleased(keyCode);
}

void ModeMgr::OnMouseMove(int x, int y)
{
	ASSERT(m_activeRootModule || !g_game->IsRunning());
	if (m_activeRootModule==NULL) return;

	m_activeRootModule->OnMouseMove(x,y);
}

void ModeMgr::OnMouseClick(int button, int x, int y)
{
	ASSERT(m_activeRootModule || !g_game->IsRunning());
	if (m_activeRootModule==NULL) return;

	m_activeRootModule->OnMouseClick(button,x,y);
}

void ModeMgr::OnMousePressed(int button, int x, int y)
{
	ASSERT(m_activeRootModule || !g_game->IsRunning());
	if (m_activeRootModule==NULL) return;

	m_activeRootModule->OnMousePressed(button, x, y);
}

void ModeMgr::OnMouseReleased(int button, int x, int y)
{
	ASSERT(m_activeRootModule || !g_game->IsRunning());
	if (m_activeRootModule==NULL) return;

	m_activeRootModule->OnMouseReleased(button, x, y);
}

void ModeMgr::OnMouseWheelUp(int x, int y)
{
	ASSERT(m_activeRootModule || !g_game->IsRunning());
	if (m_activeRootModule==NULL) return;

	m_activeRootModule->OnMouseWheelUp(x, y);
}

void ModeMgr::OnMouseWheelDown(int x, int y)
{
	ASSERT(m_activeRootModule || !g_game->IsRunning());
	if (m_activeRootModule==NULL) return;

	m_activeRootModule->OnMouseWheelDown(x, y);
}
