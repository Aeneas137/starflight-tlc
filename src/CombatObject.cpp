
#include <iostream>
#include <math.h>
#include "CombatObject.h"
#include "ModuleEncounter.h"
#include "Sprite.h"
#include "Game.h"
#include "GameState.h"
#include "Events.h"

CombatObject::CombatObject() : Sprite()
{
	expireStartTime = g_game->globalTimer.getTimer();
	expireDuration = 0;
	id = 0;
	name = "";
	damage = 0.0;
	mass = 1.0;
	turnrate = 1.0;
	health = 0;
	UseAlpha = false;
	rotation = 0.0;
	maxVelocity = 0.0;
	collisionRadius = 0.0;
	behavior = BEHAVIOR_WANDER;
	laserFiringRate = 0;
	laserFiringTimer = 0;
	laserDamage = 0;
	missileFiringRate = 0;
	missileFiringTimer = 0;
	missileDamage = 0;
}


CombatObject::~CombatObject()
{
}

void CombatObject::Update()
{
	//check velocity
	//if (velX > maxVelocity) velX = maxVelocity;
	//if (velY > maxVelocity) velY = maxVelocity;
	

	//update expiration timer
	if (expireDuration > 0)
	{
		if (g_game->globalTimer.getTimer() > expireStartTime + expireDuration) {
			this->setAlive(false);
		}
	}
	

}

void CombatObject::TimedUpdate()
{
	//move the sprite
	this->move();
	this->animate();
	
	if (this->rotation != 0)
	{
		this->faceAngle += this->rotation;
		if (this->getFaceAngle() < 0.0) this->setFaceAngle(360 - this->getFaceAngle());
		if (this->getFaceAngle() > 359.0) this->setFaceAngle(0);
	}
}


bool CombatObject::CheckCollision(CombatObject *other)
{
	/*JH 09/08
	  there is a strange bug in the BR collision function that ignores collision if first
	  sprite is larger than the second one. need a more  generic Rect-based collision routine.
	  for combat let's just stick with distance-based collision.
    */

	//if bounding rectangle is true, then compare distance
	//if ( this->collided( other ) )
	//{
		return (this->collidedD( other ));
	//}

	//return false;
}

void CombatObject::ApplyImpact(CombatObject *incoming)
{
	static double bump = 0.8;
	double vx,vy,x1,y1,x2,y2;

	//first, move the objects off each other
	while (this->CheckCollision( incoming )) 
	{
		x1 = this->getX() + this->getFrameWidth()/2;
		y1 = this->getY() + this->getFrameHeight()/2;
		x2 = incoming->getX() + incoming->getFrameWidth()/2;
		y2 = incoming->getY() + incoming->getFrameHeight()/2;

		if ( x1 < x2 ) {
			this->setX( this->getX() - bump );
			incoming->setX( incoming->getX() + bump );
		}
		else {
			this->setX( this->getX() + bump );
			incoming->setX( incoming->getX() - bump );
		}

		if ( y1 < y2 ) {
			this->setY( this->getY() - bump );
			incoming->setY( incoming->getY() + bump );
		}
		else {
			this->setY( this->getY() + bump );
			incoming->setY( incoming->getY() - bump );
		}

	}


	//second, affect velocity based on mass
	double mass_factor = 1.0;
	double modifier = 0.005;

	//calculate mass ratio
	if (this->mass > 0.0)
		mass_factor = incoming->mass / this->mass;

	double angle = incoming->getFaceAngle() - 90.0;
	vx = calcAngleMoveX( (int)angle ) * mass_factor * modifier;
	vy = calcAngleMoveY( (int)angle ) * mass_factor * modifier;

    this->setVelX( this->getVelX() + vx );
    this->setVelY( this->getVelY() + vy );

}

void CombatObject::TurnLeft()
{
	this->setFaceAngle(this->getFaceAngle() - this->turnrate);
	if (this->getFaceAngle() < 0) this->setFaceAngle(360 + this->getFaceAngle());
}

void CombatObject::TurnRight()
{
	this->setFaceAngle(this->getFaceAngle() + turnrate);
	if (this->getFaceAngle() > 359) this->setFaceAngle(360 - this->getFaceAngle());
}

double CombatObject::getRelativeSpeed()
{
	double vx = this->getVelX();
	double vy = this->getVelY();
	return sqrt(vx*vx + vy*vy);
}

void CombatObject::ApplyBraking()
{
	static int stop_threshold = 0.1;
	static int brake_value = 0.025;

	//get current velocity
	double vx = this->getVelX();
	double vy = this->getVelY();

	//if done braking, then exit
	if ((vx == 0) && (vy == 0)) return;

    speed = sqrt(vx*vx + vy*vy);
    double dir = atan2(vy,vx);
	if (abs(speed) < stop_threshold) {
		speed = 0.0;
	}
	else {
        if (speed > 0)
            speed -= brake_value;
        else
            speed += brake_value;
	}
    vx = speed * cos(dir);
    vy = speed * sin(dir);
	
	//set new velocity
	this->setVelX(vx);
	this->setVelY(vy);

}
void CombatObject::LimitVelocity()
{
	//get current velocity values
	double vx = this->getVelX();
	double vy = this->getVelY();
	double dir = atan2(vy,vx);
	double speed = this->getRelativeSpeed();
	    
	if (speed > maxVelocity){
		speed = maxVelocity;
	}else if(speed < -maxVelocity){
		speed = -maxVelocity;
	}

	//set x,y velocities based on overall speed
	vx = speed * cos(dir);
	vy = speed * sin(dir);
	this->setVelX(vx);
	this->setVelY(vy);
}
void CombatObject::ApplyThrust()
{
	this->setMoveAngle(this->getFaceAngle() - 90); 
	if (this->getMoveAngle() < 0) this->setMoveAngle(359 + this->getMoveAngle() );
	this->setVelX(this->getVelX() + this->calcAngleMoveX( this->getMoveAngle() )  * this->getAcceleration());
	this->setVelY(this->getVelY() + this->calcAngleMoveY( this->getMoveAngle() ) * this->getAcceleration());
	this->LimitVelocity();
}
