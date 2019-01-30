/*
	STARFLIGHT - THE LOST COLONY
	ModeMgr.h - A mode consists of a tree of modules.  Multiple modes are configured at application startup.  
	One mode is active at any given time.  The modules in the active mode are the ones which are run.  
	Switching modes will deactivate all modules in the current mode and then activate all modules in 
	the new mode and begin running them.

	Author: ?
	Date: ?

*/
 
#ifndef MODEMGR_H
#define MODEMGR_H

#include <string>
#include <map>
#include "AudioSystem.h"

// mode names defined here
const std::string MODULE_STARTUP			= "STARTUP";
const std::string MODULE_TITLESCREEN		= "TITLESCREEN";
const std::string MODULE_CREDITS			= "CREDITS";
const std::string MODULE_CAPTAINCREATION	= "CAPTAINCREATION";
const std::string MODULE_CAPTAINSLOUNGE		= "CAPTAINSLOUNGE";
const std::string MODULE_STARMAP			= "STARMAP";
const std::string MODULE_HYPERSPACE			= "HYPERSPACE";
const std::string MODULE_INTERPLANETARY		= "INTERPLANETARY";
const std::string MODULE_ORBIT				= "PLANETORBIT";
const std::string MODULE_SURFACE			= "PLANETSURFACE";
const std::string MODULE_PORT				= "STARPORT";
const std::string MODULE_SHIPCONFIG			= "SHIPCONFIG";
const std::string MODULE_STARPORT			= "STARPORT";
const std::string MODULE_CREWBUY			= "CREWHIRE";
const std::string MODULE_BANK				= "BANK";
const std::string MODULE_TRADEDEPOT			= "TRADEDEPOT";
const std::string MODULE_GAMEOVER			= "GAMEOVER";
const std::string MODULE_CANTINA  			= "CANTINA";
const std::string MODULE_RESEARCHLAB		= "RESEARCHLAB";
const std::string MODULE_MILITARYOPS		= "MILITARYOPS";
const std::string MODULE_ENCOUNTER			= "ENCOUNTER";
const std::string MODULE_AUXILIARYDISPLAY	= "AUXILIARYDISPLAY";
const std::string MODULE_SETTINGS			= "SETTINGS";
const std::string MODULE_MESSAGEGUI			= "MESSAGEGUI";

class Module;
class GameState;
struct BITMAP;
class Game;
class Event;

class Mode
{
	public:
		Mode(Module *module, std::string path);

	private:
		Module *rootModule;
		std::string musicPath;

	friend class ModeMgr;
};

class ModeMgr
{
public:

	ModeMgr(Game *game);

	virtual ~ModeMgr();

	void AddMode(std::string modeName, Module *rootModule, std::string musicPath);
	bool LoadModule(std::string moduleName);
	void CloseCurrentModule();

	std::string GetCurrentModuleName() { return currentModeName; }
	std::string GetPrevModuleName() { return prevModeName; }

	void Update();
	void Draw();

	//void BlitToParent(BITMAP *parent);

	void EndGame();

	// call to broadcast the specified event to all modules which are part
	// of the active mode
	void BroadcastEvent(Event * event);

	void OnKeyPress(int keyCode);
	void OnKeyPressed(int keyCode);
	void OnKeyReleased(int keyCode);

	void OnMouseMove(int x, int y);
	void OnMouseClick(int button, int x, int y);
	void OnMousePressed(int button, int x, int y);
	void OnMouseReleased(int button, int x, int y);
	
	void OnMouseWheelUp(int x, int y);
	void OnMouseWheelDown(int x, int y);

private:

	Module *m_activeRootModule;
	Sample *currentMusic;

	std::string prevModeName;
	std::string currentModeName;

	//this is the list of game modes in the game
	std::map<std::string,Mode*> m_modes;
};

#endif
