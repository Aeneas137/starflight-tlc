/*
	STARFLIGHT - THE LOST COLONY
	ModuleInterstellarTravel.h - Handles interstellar travel on the main viewscreen
	Author: J.Harbour
	Date: January, 2007

	Flux system: Keith Patch
*/

#ifndef INTERSTELLARTRAVEL_H
#define INTERSTELLARTRAVEL_H

#include "env.h"
#include <vector>
#include <typeinfo>
#include <allegro.h>
#include <alfont.h>
#include <math.h>
#include "Module.h"
#include "TileScroller.h"
#include "Flux.h"
#include "Sprite.h"
#include "Timer.h"
#include "Util.h"
#include "GameState.h"
#include "DataMgr.h"
#include "PlayerShipSprite.h"
#include "ScrollBox.h"
#include "ModeMgr.h"

using namespace std;

class ModuleInterstellarTravel : public Module
{
private:

	TileScroller	*scroller;

	int				controlKey;
	int				shiftKey;
	int				starFound;

	Officer* tempOfficer;

	DATAFILE *isdata;
	Flux* flux;
	Sprite *shield;

	bool flag_Shields;
	bool flag_Weapons;
	bool flag_Engaged;
	Timer timerEngaged;
	string alienRaceText,alienRaceTextPlural,depth;
	AlienRaces alienRace;
	double roll,proximity,odds;
	int movement_counter;

	int currentStar;
	float ratiox;
	float ratioy;
	Star *starSystem;
	PlayerShipSprite *ship;
	ScrollBox::ScrollBox *text;
	bool flag_DoNormalSpace;
	bool flag_FoundFlux;
	bool flag_nav;
	bool flag_thrusting;
	bool flag_launchEncounter;


	//shortcuts to crew last names to simplify code
	string cap;
	string com;
	string sci;
	string nav;
	string tac;
	string eng;
	string doc;

	BITMAP *img_gui;

	void loadGalaxyData();
	void createGalaxy();
	void identifyStar();
	void calculateEnemyFleetSize();
	int getFleetSizeByRace( bool small_fleet );
	void load_flux();
	void place_flux_exits();
	void check_flux_scanner();
	void place_flux_tile(bool visible, int tile);
	void identify_flux();
	void doFluxTravel();
	void AugmentFuel(float percentage);
	bool RollEncounter(AlienRaces forceThisRace = ALIEN_NONE);
	void EnterStarSystem();
	double getPlayerGalacticX();
	double getPlayerGalacticY();
	double Distance( double x1,double y1,double x2,double y2 );

public:
	ModuleInterstellarTravel(void);
	~ModuleInterstellarTravel(void);
	bool Init();
	void Update();
	void Draw();
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
};

#endif
