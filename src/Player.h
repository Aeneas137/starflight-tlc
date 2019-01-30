/*
	STARFLIGHT - THE LOST COLONY
	Player.h - Handles global player data
	Author: J.Harbour
	Date: Feb, 2007
*/

#ifndef _PLAYER_H
#define _PLAYER_H

#include "env.h"
#include <allegro.h>
#include "Events.h"
#include "Util.h"
#include "Game.h"
#include "DataMgr.h"
#include "ModeMgr.h"
#include "Point2D.h"
#include "Module.h"
#include "Sprite.h"

class Player {
	public:
		Player() { }
		~Player();

		void record_galactic_pos(int x, int y){gal_x = x; gal_y = y;}
		int get_galactic_x(){return gal_x;}
		int get_galactic_y(){return gal_y;}

		int				currentStar;
		int				currentPlanet;

		Point2D			posHyperspace;
		Point2D			posSystem;
		Point2D			posPlanet;
		int gal_x,gal_y;
};


class PlayerShip {
// PROPERTIES
private:
	Sprite	*ship;
	float	forward_thrust;
	float	reverse_thrust;
	float	lateral_thrust;
	float	turnrate;

public:
	~PlayerShip();
	PlayerShip();
	void destroy();
	void applythrust();
	void reversethrust();
	void limitvelocity();
	void cruise();
	void allstop();
	void turnleft();
	void turnright();
	void starboard();
	void port();

	void draw(BITMAP *dest);

	float getVelocityX() { return ship->getVelX(); }
	float getVelocityY() { return ship->getVelY(); }
	float getRotationAngle() { return ship->getFaceAngle(); }

};


#endif
