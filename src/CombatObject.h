#pragma once

#include "env.h"
#include <allegro.h>
#include <string>
#include "DataMgr.h"
#include "Sprite.h"
#include "Timer.h"

const short BEHAVIOR_WANDER = 0;
const short BEHAVIOR_FLEE = 1;
const short BEHAVIOR_ATTACK = 2;

class CombatObject : public Sprite
{
public:
	CombatObject();
	~CombatObject();

	void Update();
	void TimedUpdate();
	bool CheckCollision(CombatObject * otherPSO);
	void ApplyImpact(CombatObject *incoming);
	void AllStop() { velX = 0.0; velY = 0.0; }
	void TurnLeft();
	void TurnRight();
	void LimitVelocity();
	void ApplyThrust();
	void ApplyBraking();
	double getRelativeSpeed();


	//accessors
	int getID()					const { return id; }
	std::string getName()		const { return name; }
	double getDamage()			const { return damage; }
	int getHealth()				const { return health; }
	bool UsesAlpha()			const { return UseAlpha; }
	int getExpireDuration()		{ return expireDuration; }
	double getMass()			{ return mass; }
	double getRotation()		{ return rotation; }
	double getAngle()			{ return rotateAngle; }
	double getMaxVelocity()		{ return maxVelocity; }
	double getCollisionRadius()	{ return collisionRadius; }
	double getTurnRate()		{ return turnrate; }
	double getAcceleration()	{ return accel; }
	int getBehavior()			{ return behavior; }
	int getLaserFiringRate()	{ return laserFiringRate; }
	int getLaserFiringTimer()	{ return laserFiringTimer; }
	int getLaserDamage()		{ return laserDamage; }
	int  getLaserModifier()		{ return laserModifier; }
	int getMissileFiringRate()	{ return missileFiringRate; }
	int getMissileFiringTimer() { return missileFiringTimer; }
	int getMissileDamage()		{ return missileDamage; }
	int getMissileModifier()	{ return missileModifier; }
	int getShieldStrength()		{ return shieldStrength; }
	int getArmorStrength()		{ return armorStrength; }

	//mutators
	void setID(int initID)					{ id = initID; }
	void setName(std::string initName)		{ name = initName; }
	void setDamage(double initDamage)		{ damage = initDamage; }
	void setHealth(int initHealth)			{ health = initHealth; }
	void setAlpha(bool initAlpha)			{ UseAlpha = initAlpha; }
	void setExpireDuration(int time)		{ expireDuration = time; }
	void setMass(double value)				{ mass = value; }
	void setRotation(double value)			{ rotation = value; }
	void setAngle(double value)				{ rotateAngle = value; }
	void setMaxVelocity(double value)		{ maxVelocity = value; }
	void setCollisionRadius(double value)	{ collisionRadius = value; }
	void setTurnRate(double value)			{ turnrate = value; }
	void setAcceleration(double value)		{ accel = value; }
	void setBehavior(int value)				{ behavior = value; }
	void setLaserFiringRate(int value)		{ laserFiringRate = value; }
	void setLaserFiringTimer(int value)		{ laserFiringTimer = value; }
	void setLaserDamage(int value)			{ laserDamage = value; }
	void setLaserModifier(int value)		{ laserModifier = value; }
	void setMissileFiringRate(int value)	{ missileFiringRate = value; }
	void setMissileFiringTimer(int value)   { missileFiringTimer = value; }
	void setMissileDamage(int value)		{ missileDamage = value; }
	void setMissileModifier(int value)		{ missileModifier = value; }
	void setShieldStrength(int value)		{ shieldStrength = value; }
	void setArmorStrength(int value)		{ armorStrength = value; }
	
protected:
	int			behavior;
	int			id;
	std::string name;
	double		damage;
	double		mass;
	int			health;
	bool		UseAlpha;
	int			expireStartTime;
	int			expireDuration;
	double		rotation;
	double		rotateAngle;
	double		maxVelocity;
	double		collisionRadius;
	double		turnrate;
	double		accel;
	int			laserFiringRate;
	int			laserDamage;
	int			laserModifier;
	int			laserFiringTimer;
	int			missileFiringRate;
	int			missileDamage;
	int			missileModifier;
	int			missileFiringTimer;
	int			shieldStrength;
	int			armorStrength;


};
