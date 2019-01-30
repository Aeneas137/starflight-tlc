/*
	STARFLIGHT - THE LOST COLONY
	PlayerShipSprite.cpp
*/

#include "env.h"
#include "Game.h"
#include "GameState.h"
#include "PlayerShipSprite.h"
#include "Timer.h"
#include "Util.h"

using namespace std;

/*  
 *  PLAYERSHIPSPRITE CLASS
 */

const int TIMER_RATE = 20;

PlayerShipSprite::PlayerShipSprite()
{
	//initialize and load the ship sprite
	ship = new Sprite();
	switch(g_game->gameState->getProfession())
	{
		case PROFESSION_FREELANCE:
			ship->load("data/spacetravel/ship_freelance.bmp");
			break;
		
		case PROFESSION_MILITARY:
			ship->load("data/spacetravel/ship_military.bmp");
			break;
		
		case PROFESSION_SCIENTIFIC:
		default:
			ship->load("data/spacetravel/ship_science.bmp");
			break;
	}
	if (!ship) {
		g_game->message("Error loading player ship image");
		return;
	}
	ship->setFrameWidth(64);
	ship->setFrameHeight(64);
	ship->setAnimColumns(8);
	ship->setTotalFrames(8);
	ship->setCurrFrame(0);
	ship->setX(SCREEN_WIDTH/2 - ship->getFrameWidth()/2);
	ship->setY(SCREEN_HEIGHT/2 - 128 - ship->getFrameHeight()/2);
	ship->setFaceAngle( Util::Random(1,359) );

	//ship movement variables
	maximum_velocity = getMaximumVelocity();
	forward_thrust = getForwardThrust();
	reverse_thrust = getReverseThrust();
	lateral_thrust = getLateralThrust();
	turnrate = getTurnRate();
	//reset ship control timer
	timer.reset(); braking_timer.reset();
	
}

PlayerShipSprite::~PlayerShipSprite()  {
	destroy();
	ship = NULL;
	//lua_close(L);
}

void PlayerShipSprite::destroy() {
	delete ship;
}

void PlayerShipSprite::turnleft()
{
	//slow down ship rotation to 60 fps
	if (timer.stopwatch(TIMER_RATE)) {
		ship->setFaceAngle(ship->getFaceAngle() - turnrate);
		if (ship->getFaceAngle() < 0) ship->setFaceAngle(360+ship->getFaceAngle());
	}

	ship->setCurrFrame(4);
}

void PlayerShipSprite::turnright()
{
	//slow down ship rotation to 60 fps
	if (timer.stopwatch(TIMER_RATE)) {
		ship->setFaceAngle(ship->getFaceAngle() + turnrate);
		if (ship->getFaceAngle() > 359) ship->setFaceAngle(360-ship->getFaceAngle());
	}

	ship->setCurrFrame(3);
}

// Retrieve maximum_velocity variable 
double PlayerShipSprite::getMaximumVelocity()
{
	double topspeed = 1.0;

	int engine = g_game->gameState->getShip().getEngineClass();
	if (engine < 1 || engine > 6) {
		engine = 1;
		TRACE("*** Error in PlayerShipSprite::getMaximumVelocity: Engine class is invalid");
	}

	switch(engine) {
		case 1: topspeed = g_game->getGlobalNumber("ENGINE1_TOPSPEED"); break;
		case 2: topspeed = g_game->getGlobalNumber("ENGINE2_TOPSPEED"); break;
		case 3: topspeed = g_game->getGlobalNumber("ENGINE3_TOPSPEED"); break;
		case 4: topspeed = g_game->getGlobalNumber("ENGINE4_TOPSPEED"); break;
		case 5: topspeed = g_game->getGlobalNumber("ENGINE5_TOPSPEED"); break;
		case 6: topspeed = g_game->getGlobalNumber("ENGINE6_TOPSPEED"); break;
	}

	return topspeed;
}

// Read forward thrust from script
double PlayerShipSprite::getForwardThrust()
{
	double accel = 1.0;

	int engine = g_game->gameState->getShip().getEngineClass();
	if (engine < 1 || engine > 6) {
		engine = 1;
		TRACE("*** Error in PlayerShipSprite::getForwardThrust: Engine class is invalid");
	}

	switch(engine) {
		case 1: accel = g_game->getGlobalNumber("ENGINE1_ACCEL"); break;
		case 2: accel = g_game->getGlobalNumber("ENGINE2_ACCEL"); break;
		case 3: accel = g_game->getGlobalNumber("ENGINE3_ACCEL"); break;
		case 4: accel = g_game->getGlobalNumber("ENGINE4_ACCEL"); break;
		case 5: accel = g_game->getGlobalNumber("ENGINE5_ACCEL"); break;
		case 6: accel = g_game->getGlobalNumber("ENGINE6_ACCEL"); break;
	}

	return accel;
}

// Read reverse thrust from script
double PlayerShipSprite::getReverseThrust()
{
	return getForwardThrust() * 0.5;
}

// Read lateral thrust from script
double PlayerShipSprite::getLateralThrust()
{
	return getForwardThrust() * 0.5;
}

// Read turning rate from script
double PlayerShipSprite::getTurnRate()
{
	double turnrate = 1.0;

	int engine = g_game->gameState->getShip().getEngineClass();
	if (engine < 1 || engine > 6) {
		engine = 1;
		TRACE("*** Error in PlayerShipSprite::getTurnRate: Engine class is invalid");
	}

	switch(engine) {
		case 1: turnrate = g_game->getGlobalNumber("ENGINE1_TURNRATE"); break;
		case 2: turnrate = g_game->getGlobalNumber("ENGINE2_TURNRATE"); break;
		case 3: turnrate = g_game->getGlobalNumber("ENGINE3_TURNRATE"); break;
		case 4: turnrate = g_game->getGlobalNumber("ENGINE4_TURNRATE"); break;
		case 5: turnrate = g_game->getGlobalNumber("ENGINE5_TURNRATE"); break;
		case 6: turnrate = g_game->getGlobalNumber("ENGINE6_TURNRATE"); break;
	}

	return turnrate;
}

void PlayerShipSprite::limitvelocity()
{
	double vx = 0;
	double vy = 0;

	//get current velocity	
	vx = ship->getVelX();
	vy = ship->getVelY();

    double speed = sqrt(vx*vx + vy*vy);
    double dir = atan2(vy,vx);
        
    if (speed > maximum_velocity){
	    speed = maximum_velocity;
    }else if(speed < -maximum_velocity){
	    speed = -maximum_velocity;
    }

    vx = speed * cos(dir);
    vy = speed * sin(dir);

	//set new velocity	
	ship->setVelX(vx);
	ship->setVelY(vy);
}


/*
 * Both side thrusters fire to move ship toward the starboard (right)
 */
void PlayerShipSprite::starboard()
{
	//slow down ship movement to 60 fps
	if (timer.stopwatch(TIMER_RATE)) {
		ship->setMoveAngle(ship->getFaceAngle() );
		ship->setVelX(ship->getVelX() + ship->calcAngleMoveX( ship->getMoveAngle() ) * lateral_thrust);
		ship->setVelY(ship->getVelY() + ship->calcAngleMoveY( ship->getMoveAngle() ) * lateral_thrust);
		limitvelocity();
	}

	ship->setCurrFrame(5);
}

/*
 * Both side thrusters fire together to move ship toward the port (left)
 */
void PlayerShipSprite::port()
{
	//slow down ship movement to 60 fps
	if (timer.stopwatch(TIMER_RATE)) {
		//move angle should be 180 degrees clockwise from face angle
		ship->setMoveAngle(ship->getFaceAngle() - 180);
		ship->setVelX(ship->getVelX() + ship->calcAngleMoveX( ship->getMoveAngle() ) * lateral_thrust);
		ship->setVelY(ship->getVelY() + ship->calcAngleMoveY( ship->getMoveAngle() ) * lateral_thrust);
		limitvelocity();
	}

	ship->setCurrFrame(6);
}

void PlayerShipSprite::applythrust()
{
	//slow down ship thrust to 60 fps
	if (timer.stopwatch(TIMER_RATE)) {
		ship->setMoveAngle(ship->getFaceAngle() - 90); 
		if (ship->getMoveAngle() < 0) ship->setMoveAngle(359 + ship->getMoveAngle() );
		ship->setVelX(ship->getVelX() + ship->calcAngleMoveX( ship->getMoveAngle() )  * forward_thrust);
		ship->setVelY(ship->getVelY() + ship->calcAngleMoveY( ship->getMoveAngle() ) * forward_thrust);
		limitvelocity();
	}

	ship->setCurrFrame(1);
}

void PlayerShipSprite::reversethrust()
{
	//slow down ship thrust to 60 fps
	if (timer.stopwatch(TIMER_RATE)) {
		ship->setMoveAngle(ship->getFaceAngle() - 270);
		if (ship->getMoveAngle() < 0) ship->setMoveAngle(359 + ship->getMoveAngle() );
		ship->setVelX(ship->getVelX() + ship->calcAngleMoveX( ship->getMoveAngle() ) * reverse_thrust);
		ship->setVelY(ship->getVelY() + ship->calcAngleMoveY( ship->getMoveAngle() ) * reverse_thrust);
		limitvelocity();
	}

	ship->setCurrFrame(2);
}

void PlayerShipSprite::cruise() 
{ 
	ship->setCurrFrame(0);
}

void PlayerShipSprite::allstop()
{
	ship->setVelX(0.0);
	ship->setVelY(0.0);
	ship->setCurrFrame(0);
}

void PlayerShipSprite::applybraking()
{
	//slow down ship braking to 60 fps
	if (!braking_timer.stopwatch(TIMER_RATE)) return;

	//get current velocity
	double velx = ship->getVelX();
	double vely = ship->getVelY();

	//if done braking, then exit
	if ((velx == 0) && (vely == 0)) {
		ship->setCurrFrame(0);
		return;
	}

    double stop_threshold = 0.02;
    double brake_value = 0.08;
    double speed =  sqrt(velx*velx + vely*vely);
    double dir = atan2(vely,velx);
    if (fabs(speed) < stop_threshold)
		speed = 0.0;
    else {
        if (speed > 0.0)
            speed -= brake_value;
        else
            speed += brake_value;
    }
    velx = speed * cos(dir);
    vely = speed * sin(dir);
	
	//set new velocity
	ship->setVelX(velx);
	ship->setVelY(vely);
	ship->setCurrFrame(0);

}

void PlayerShipSprite::draw(BITMAP *dest) 
{
	ship->drawframe_rotate(dest, (int)ship->getFaceAngle() ); 
}

float PlayerShipSprite::getVelocityX() 
{ 
	return ship->getVelX(); 
}

float PlayerShipSprite::getVelocityY() 
{ 
	return ship->getVelY(); 
}

void PlayerShipSprite::setVelocityX(float value)
{
	ship->setVelX( value );
}

void PlayerShipSprite::setVelocityY(float value)
{
	ship->setVelY( value );
}

float PlayerShipSprite::getRotationAngle() 
{
	return ship->getFaceAngle(); 
}

void PlayerShipSprite::reset()
{
	allstop();
	ship->setCurrFrame(0);
}

double PlayerShipSprite::getCurrentSpeed()
{
	double vx = getVelocityX();
	double vy = getVelocityY();
	double speed = sqrt(vx*vx + vy*vy);
	return speed;
}


