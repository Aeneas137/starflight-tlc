/*
	STARFLIGHT - THE LOST COLONY
	PlayerShipSprite.h
	Author: J.Harbour
	Date: 2007
*/

#ifndef PLAYERSHIPSPRITE_H
#define PLAYERSHIPSPRITE_H

#include "env.h"
#include <allegro.h>
#include <string>
#include "Sprite.h"
#include "Script.h"
#include "Timer.h"

class PlayerShipSprite {
private:
	Sprite	*ship;
	double maximum_velocity;
	double	forward_thrust;
	double	reverse_thrust;
	double	lateral_thrust;
	double	turnrate;
	
	//lua_State *L;

	Timer timer, braking_timer;

public:
	~PlayerShipSprite();
	PlayerShipSprite();
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
	void applybraking();

	void draw(BITMAP *dest);
	double getX() { return ship->getX(); }
	double getY() { return ship->getY(); }
	void setX(double value) { ship->setX(value); }
	void setX(int value)    { ship->setX(value); }
	void setY(double value) { ship->setY(value); }
	void setY(int value)    { ship->setY(value); }
	float getVelocityX();
	float getVelocityY();
	void setVelocityX(float value);
	void setVelocityY(float value);
	float getRotationAngle();
	double getCurrentSpeed();

	void reset();
	
	double getMaximumVelocity();
	double getForwardThrust();
	double getReverseThrust();
	double getLateralThrust();
	double getTurnRate();
	
	Sprite *getSprite() { return ship; }

};


#endif
