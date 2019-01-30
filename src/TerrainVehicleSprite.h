/*
	STARFLIGHT - THE LOST COLONY
	TerrainVehicleSprite.h
	Author: J.Harbour
	Date: Nov, 2007
*/

#ifndef TERRAINVEHICLESPRITE_H
#define TERRAINVEHICLESPRITE_H

#include "env.h"
#include <allegro.h>
#include <string>
#include "Sprite.h"

class TerrainVehicleSprite {
private:
	Sprite	*vehicle;
	float	forward_thrust;
	float	reverse_thrust;
	float	turnrate;

public:
	~TerrainVehicleSprite();
	TerrainVehicleSprite();
	void destroy();
	void applythrust();
	void reversethrust();
	void limitvelocity();
	void cruise();
	void allstop();
	void turnleft();
	void turnright();
	void applybraking();

	void draw(BITMAP *dest);
	float getVelocityX();
	float getVelocityY();
	float getRotationAngle();

	void reset();

};


#endif



