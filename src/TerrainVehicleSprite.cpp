/*
	STARFLIGHT - THE LOST COLONY
	TerrainVehicleSprite.cpp
	Author: J.Harbour
	Date: Nov, 2007
*/

#include "env.h"
#include "Game.h"
#include "TerrainVehicleSprite.h"

/*  
 *  TERRAINVEHICLESPRITE CLASS
 */

TerrainVehicleSprite::TerrainVehicleSprite()
{
	//initialize and load the vehicle sprite
	vehicle = new Sprite();
	vehicle->load("data/tv.bmp");
	if (!vehicle) {
		g_game->message("Error loading terrain vehicle");
		return;
	}
	vehicle->setFrameWidth(64);
	vehicle->setFrameHeight(64);
	vehicle->setAnimColumns(1);
	vehicle->setTotalFrames(1);
	vehicle->setX(512-32);
	vehicle->setY(256-32);

	//vehicle movement variables
	forward_thrust = g_game->getGlobalNumber("TV_FORWARD_THRUST");
	reverse_thrust = g_game->getGlobalNumber("TV_REVERSE_THRUST");
	turnrate = g_game->getGlobalNumber("TV_TURN_RATE");

}

TerrainVehicleSprite::~TerrainVehicleSprite()  {
	destroy();
	delete vehicle;
}

void TerrainVehicleSprite::destroy() {
	delete vehicle;
}

void TerrainVehicleSprite::turnleft()
{
	vehicle->setFaceAngle(vehicle->getFaceAngle() - turnrate);
	if (vehicle->getFaceAngle() < 0) vehicle->setFaceAngle(359);
}

void TerrainVehicleSprite::turnright()
{
	vehicle->setFaceAngle(vehicle->getFaceAngle() + turnrate);
	if (vehicle->getFaceAngle() > 359) vehicle->setFaceAngle(0);
}

void TerrainVehicleSprite::limitvelocity()
{
	if (vehicle->getVelX() > 3.0) vehicle->setVelX(3.0);
	else if (vehicle->getVelX() < -3.0) vehicle->setVelX(-3.0);
	if (vehicle->getVelY() > 3.0) vehicle->setVelY(3.0);
	else if (vehicle->getVelY() < -3.0) vehicle->setVelY(-3.0);
}


void TerrainVehicleSprite::applythrust()
{
	vehicle->setMoveAngle(vehicle->getFaceAngle() - 90);
	if (vehicle->getMoveAngle() < 0) vehicle->setMoveAngle(359 + vehicle->getMoveAngle() );
	vehicle->setVelX(vehicle->getVelX() + vehicle->calcAngleMoveX((double)vehicle->getMoveAngle() ) * forward_thrust);
	vehicle->setVelY(vehicle->getVelY() + vehicle->calcAngleMoveY((double)vehicle->getMoveAngle() ) * forward_thrust);
	limitvelocity();
}

void TerrainVehicleSprite::reversethrust()
{
	vehicle->setMoveAngle(vehicle->getFaceAngle() - 270);
	if (vehicle->getMoveAngle() < 0) vehicle->setMoveAngle(359 + vehicle->getMoveAngle() );
	vehicle->setVelX(vehicle->getVelX() + vehicle->calcAngleMoveX((double)vehicle->getMoveAngle() ) * reverse_thrust);
	vehicle->setVelY(vehicle->getVelY() + vehicle->calcAngleMoveY((double)vehicle->getMoveAngle() ) * reverse_thrust);
	limitvelocity();
}

void TerrainVehicleSprite::cruise() 
{ 
	vehicle->setCurrFrame(0);
}

void TerrainVehicleSprite::allstop()
{
	vehicle->setVelX(0.0);
	vehicle->setVelY(0.0);
}

#define STOP_THRESHOLD 0.1
#define BRAKE_VALUE    0.025

void TerrainVehicleSprite::applybraking()
{
	double vx = vehicle->getVelX();
	double vy = vehicle->getVelY();

	if ((vx == 0) && (vy == 0)) {
		vehicle->setCurrFrame(0);
		return;
	}

	double speed = sqrt(vx*vx + vy*vy);
	double dir = atan2(vy,vx);

	if (fabs(speed) < STOP_THRESHOLD)
		speed = 0;
	else
		speed -= (speed > 0 ? BRAKE_VALUE : -BRAKE_VALUE);

	vx = speed * cos(dir);
	vy = speed * sin(dir);

	vehicle->setVelX(vx);
	vehicle->setVelY(vy);
}

void TerrainVehicleSprite::draw(BITMAP *dest) 
{ 
	vehicle->drawframe_rotate(dest, vehicle->getFaceAngle() ); 
}

float TerrainVehicleSprite::getVelocityX() 
{ 
	return vehicle->getVelX(); 
}

float TerrainVehicleSprite::getVelocityY() 
{ 
	return vehicle->getVelY(); 
}

float TerrainVehicleSprite::getRotationAngle() 
{
	return vehicle->getFaceAngle(); 
}

void TerrainVehicleSprite::reset()
{
	allstop();
	vehicle->setCurrFrame(0);
}
