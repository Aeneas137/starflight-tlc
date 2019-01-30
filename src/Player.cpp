/*
	STARFLIGHT - THE LOST COLONY
	Player.cpp - Handles global player data
	Author: J.Harbour
	Date: Feb, 2007
*/


#include "Player.h"

/*  
 *  PLAYERSHIP CLASS
 */

PlayerShip::PlayerShip()
{
	//initialize and load the ship sprite
	this->ship = new Sprite();
	this->ship->load("data/is_ship.bmp");
	if (!this->ship) {
		allegro_message("Error loading is_ship");
	}
	this->ship->setWidth(64);
	this->ship->setHeight(64);
	this->ship->setAnimColumns(7);
	this->ship->setTotalFrames(7);
	this->ship->setCurrFrame(0);
	this->ship->setX(1024/2 - this->ship->getWidth()/2);
	this->ship->setY(768/2 - 128 - this->ship->getHeight()/2);

	//ship movement variables
	this->forward_thrust = SHIP_FORWARD_THRUST;
	this->reverse_thrust = SHIP_REVERSE_THRUST;
	this->lateral_thrust = SHIP_LATERAL_THRUST;
	this->turnrate = SHIP_TURN_RATE;


}

PlayerShip::~PlayerShip()  {
	this->destroy();
}

void PlayerShip::destroy() {
}

void PlayerShip::turnleft()
{
	this->ship->setFaceAngle(this->ship->getFaceAngle() - this->turnrate);
	if (this->ship->getFaceAngle() < 0) this->ship->setFaceAngle(359);
	this->ship->setCurrFrame(4);
}

void PlayerShip::turnright()
{
	this->ship->setFaceAngle(this->ship->getFaceAngle() + this->turnrate);
	if (this->ship->getFaceAngle() > 359) this->ship->setFaceAngle(0);
	this->ship->setCurrFrame(3);
}

void PlayerShip::limitvelocity()
{
	if (this->ship->getVelX() > 2.0) this->ship->setVelX(2.0);
	else if (this->ship->getVelX() < -2.0) this->ship->setVelX(-2.0);
	if (this->ship->getVelY() > 2.0) this->ship->setVelY(2.0);
	else if (this->ship->getVelY() < -2.0) this->ship->setVelY(-2.0);
}


/*
 * Both side thrusters fire to move ship toward the starboard (right)
 */
void PlayerShip::starboard()
{
	//move angle is already 90 degrees clockwise from facing angle
	this->ship->setMoveAngle(this->ship->getFaceAngle() );

	//adjust ship's velocity based on angle
	this->ship->setVelX(this->ship->getVelX() + this->ship->calcAngleMoveX(this->ship->getMoveAngle() ) * this->lateral_thrust);
	this->ship->setVelY(this->ship->getVelY() + this->ship->calcAngleMoveY(this->ship->getMoveAngle() ) * this->lateral_thrust);
	this->limitvelocity();
	this->ship->setCurrFrame(5);
}

/*
 * Both side thrusters fire together to move ship toward the port (left)
 */
void PlayerShip::port()
{
	//move angle should be 180 degrees clockwise from face angle
	this->ship->setMoveAngle(this->ship->getFaceAngle() - 180);

	//adjust ship's velocity based on angle
	this->ship->setVelX(this->ship->getVelX() + this->ship->calcAngleMoveX(this->ship->getMoveAngle() ) * this->lateral_thrust);
	this->ship->setVelY(this->ship->getVelY() + this->ship->calcAngleMoveY(this->ship->getMoveAngle() ) * this->lateral_thrust);
	this->limitvelocity();
	this->ship->setCurrFrame(6);
}

void PlayerShip::applythrust()
{
	//shift 0-degree orientation from right-face to up-face
	this->ship->setMoveAngle(this->ship->getFaceAngle() - 90);
	if (this->ship->getMoveAngle() < 0) this->ship->setMoveAngle(359 + this->ship->getMoveAngle() );

	//adjust ship's velocity based on angle
	//eventually the engine class will affect acceleration as well
	this->ship->setVelX(this->ship->getVelX() + this->ship->calcAngleMoveX(this->ship->getMoveAngle() ) * this->forward_thrust);
	this->ship->setVelY(this->ship->getVelY() + this->ship->calcAngleMoveY(this->ship->getMoveAngle() ) * this->forward_thrust);
	this->limitvelocity();
	this->ship->setCurrFrame(1);
}

void PlayerShip::reversethrust()
{
	//shift 0-degree orientation from right-face to up-face
	this->ship->setMoveAngle(this->ship->getFaceAngle() - 270);
	if (this->ship->getMoveAngle() < 0) this->ship->setMoveAngle(359 + this->ship->getMoveAngle() );

	//adjust ship's velocity based on angle
	//eventually the engine class will affect acceleration as well
	this->ship->setVelX(this->ship->getVelX() + this->ship->calcAngleMoveX(this->ship->getMoveAngle() ) * this->reverse_thrust);
	this->ship->setVelY(this->ship->getVelY() + this->ship->calcAngleMoveY(this->ship->getMoveAngle() ) * this->reverse_thrust);
	this->limitvelocity();
	this->ship->setCurrFrame(2);
}

void PlayerShip::cruise() { this->ship->setCurrFrame(0); }

void PlayerShip::allstop()
{
	this->ship->setVelX(0.0);
	this->ship->setVelY(0.0);
}

void PlayerShip::draw(BITMAP *dest) { this->ship->drawframe(dest, this->ship->getFaceAngle() ); }
