/*
	STARFLIGHT - THE LOST COLONY
	ModuleInterplanetaryTravel.h - Handles space travel in a star system among the planets
	Author: J.Harbour
	Date: Feb, 2007
*/

#ifndef INTERPLANETARYTRAVEL_H
#define INTERPLANETARYTRAVEL_H

#include "env.h"
#include <math.h>
#include <string>
#include <alfont.h>
#include "Module.h"
#include "TileScroller.h"
#include "ScrollBox.h"
#include "PlayerShipSprite.h"
#include "GameState.h"
#include "DataMgr.h"
#include "Label.h"

class ModuleInterPlanetaryTravel : public Module
{
private:
	PlayerShipSprite		*ship;
	TileScroller	*scroller;
	float			acceleration;

	int				planetFound;
	bool			distressSignal;

	BITMAP *miniMap; 
	ScrollBox::ScrollBox *text;

	int loadStarSystem(int id);
	void updateMiniMap();
	void checkShipPosition();
	bool checkSystemBoundary(int x,int y);
	void Print(std::string str, int color, int delay);

	//this struct helps to simplify searches when ship moves over a planet
	struct planet_t {
		int tilex;
		int tiley;
		int tilenum;
		int planetid;
		int radius;
	};

	planet_t planets[10];

	DATAFILE *ipdata;
	int tilex, tiley, tilenum;
	bool flag_DoOrbit;
	bool flag_DoDock;
	bool flag_DoHyperspace;
	int burning;
	float distance;
	bool m_bOver_Planet;
	int asx, asy;
	Star *star;
	Planet *planet;
	Label* planet_label;
	bool flag_nav;
	bool flag_thrusting;

	//shortcuts to crew last names to simplify code
	std::string com;
	std::string sci;
	std::string nav;
	std::string tac;
	std::string eng;
	std::string doc;

public:
	ModuleInterPlanetaryTravel(void);
	~ModuleInterPlanetaryTravel(void);
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
