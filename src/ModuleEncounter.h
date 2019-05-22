/*
	STARFLIGHT - THE LOST COLONY
	ModuleEncounter.h - Handles alien encounters
	Author: J.Harbour
	Date: December, 2007
*/

#ifndef ENCOUNTER_H
#define ENCOUNTER_H

#include <sstream>
#include <string>
#include <map>
#include <cmath>
#include <lua.hpp>
#include "env.h"
#include <typeinfo>
#include <allegro.h>
#include <alfont.h>
#include "Module.h"
#include "ScrollBox.h"
#include "Script.h"
#include "PlayerShipSprite.h"
#include "CombatObject.h"
#include "Sprite.h"
#include "AudioSystem.h"
#include "Util.h"

using namespace std;
class CombatObject;
class TileScroller;
enum AlienRaces;

const int NormalScreenHeight = 512;
const int FullScreenHeight = SCREEN_HEIGHT;

class ModuleEncounter : public Module
{
private:
	DATAFILE *encdata;

	enum PostureStates {
		POSTURE_NONE = 0,
		POSTURE_OBSEQUIOUS,
		POSTURE_FRIENDLY,
		POSTURE_HOSTILE,
	};
	enum CommModes {
		COMM_NONE = 0,
		COMM_STATEMENT,
		COMM_QUESTION,
		COMM_POSTURE
	};
	struct DropType {
		int id;
		int rate;
		int quantity;
	};
	DropType dropitems[10];


	CommModes commMode;
	PostureStates commPosture;
	int shipcount;
	bool alienHailingUs;

	Point2D playerGlobal, playerScreen;


	BITMAP *img_messages;
	BITMAP *img_socket;
	BITMAP *img_aux;
	BITMAP *img_viewer;
	BITMAP *img_rightviewer;
	Sprite *shield;

	int asw;
	int ash;
	int asx;
	int asy;

	std::string alienName;

	BITMAP *img_alien_portrait;
	BITMAP *img_alien_schematic;
	BITMAP *img_alien_ship;
	BITMAP *img_plasma;
	BITMAP *img_redbolt;
	BITMAP *img_laserbeam;
	BITMAP *img_bigexplosion;
	BITMAP *img_medexplosion;
	BITMAP *img_smlexplosion;
	BITMAP *img_bigasteroid;
	BITMAP *img_smlasteroid;
	BITMAP *img_powerup_health;
	BITMAP *img_powerup_shield;
	BITMAP *img_powerup_armor;
	BITMAP *img_powerup_mineral;

	Sprite *spr_statusbar_shield;

	Sample *snd_player_laser;
	Sample *snd_player_missile;
	Sample *snd_explosion;
	Sample *snd_laserhit;

	Script *script;

	ScrollBox::ScrollBox *text;
	ScrollBox::ScrollBox *dialogue;
	bool bFlagDialogue; //used to draw either message output or scrollbox input

	bool bFlagLastStatementSuccess; //continue showing current statement until player uses it
	bool bFlagLastQuestionSuccess;  //continue showing current question until player uses it
	bool bFlagDoResponse;			//handle alien response
	bool bFlagDoAttack;				//handle attack action
	bool bFlagChatting;				//tracks whether player is chatting with alien or not

	void DrawMinimap();
	std::string replaceKeyWords(string input);
	void applyDamageToShip(int damage, bool hullonly = false);

	//Sent into the GameState for standardized access from other code (scripts & more):
	//AlienRaces getCurrentAlien();
	//string getCurrentAlienName();
	//int getAlienAttitude();
	//void setAlienAttitude(int value);

	int getShipCount();
	void damageAlienAttitude();

	bool Encounter_Init();
	bool Combat_Init();
	void Encounter_Close();
	void Combat_Close();
	void Encounter_Update();
	void Combat_Update();
	void Encounter_Draw();
	void Combat_Draw();
	void combatDoCollision(CombatObject *first, CombatObject *second);
	void combatDoBigExplosion(CombatObject *victim);
	void combatDoMedExplosion(CombatObject *victim);
	void combatDoSmlExplosion(CombatObject *victim,CombatObject *source);
	void combatDoBreakAsteroid(CombatObject *victim);
	void combatDoPowerup(CombatObject *victim);
	void combatTestPlayerCollision(CombatObject *other);
	void pickupRandomDropItem();
	void pickupAsteroidMineral();
	void ImpactPlayer(CombatObject *player,CombatObject *other);
	void DoAlienShipCombat(CombatObject *ship);
	Rect getBoundary();
	void enemyFireLaser(CombatObject *ship);
	void enemyFireMissile(CombatObject *ship);
	CombatObject *GetFirstAlienShip();

	void createLaser(CombatObject *laser, double x, double y, float velx, float vely, int angle, int laserDamage);
	void createMissile(CombatObject *missile, double x, double y, float velx, float vely, int angle, int missileDamage);

	//shortcuts to crew last names to simplify code
	string com;
	string sci;
	string nav;
	string tac;
	string eng;
	string doc;

	bool flag_DoHyperspace;
	int hyperspaceCountdown;
	int deathState;
	bool playerAttacked;
	bool flag_greeting;
	int scanStatus;
	Timer scanTimer;

	int number_of_actions; //question counter
	int goto_question; // if not 0, jump to this question number overriding other logic

	bool firingLaser, firingMissile;
    bool flag_thrusting;

public:
	ModuleEncounter(void);
	~ModuleEncounter(void);
	bool Init();
	void Update();
	void Draw();
	void Print(string text, int color, long delay);
	void OnKeyPress(int keyCode);
	void OnKeyPressed(int keyCode);
	void OnKeyReleased(int keyCode);
	void OnMouseMove(int x, int y);
	void OnMouseClick(int button, int x, int y);
	void OnMousePressed(int button, int x, int y);
	void OnMouseReleased(int button, int x, int y);
	void OnMouseWheelUp(int x, int y);
	void OnMouseWheelDown(int x, int y);
	void OnEvent(Event *event);
	void Close();
	void commInitStatement();
	void commInitQuestion();
	void commInitPosture();
	void commDoStatement(int index);
	void commDoQuestion(int index);
	void commDoPosture(int index);
	void commDoGreeting();
	void commCheckCurrentAction();
	std::string commGetAction();
	void commDoAlienResponse();
	void commDoAlienAttack();
	void fireLaser();
	void fireMissile();
	void setMissileProperties(CombatObject *ship, int missileclass);
	void setLaserProperties(CombatObject *ship, int laserclass);
	void setArmorProperties(CombatObject *ship, int armorclass);
	void setShieldProperties(CombatObject *ship, int shieldclass);
	void setEngineProperties(CombatObject *ship, int engineclass);
	void sendGlobalsToScript();
	void readGlobalsFromScript();

	int effectiveScreenHeight() 
    { 
        return g_game->doShowControls()? NormalScreenHeight : FullScreenHeight; 
        //return FullScreenHeight;
    }

	void adjustVerticalCoords(int delta);

	PlayerShipSprite *playerShip;

	int										module_mode; // 0=encounter; 1=combat
	lua_State								*LuaVM;/* the Lua interpreter */

	std::vector<CombatObject*>				combatObjects;
	std::vector<CombatObject*>::iterator	objectIt;
	TileScroller							*scroller;

	BITMAP									*minimap;

	void AddCombatObject(CombatObject *CObject);
	void RemoveCombatObject(CombatObject *CObject);

	map<string,string> dialogCensor;
};


/*******************************************************
 *
 * LUA functions
 *
 *******************************************************/

//NOTE: L_Debug is defined in ModulePlanetSurface.cpp
int L_Debug(lua_State* luaVM);       //usage: L_Debug("this is a debug message")
int L_Terminate(lua_State* luaVM);   //usage: L_Terminate()
int L_Attack(lua_State* luaVM);      //usage: L_Attack()

#endif
