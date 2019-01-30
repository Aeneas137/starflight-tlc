#pragma once

#include "env.h"
#include <allegro.h>
#include <string>
#include <alfont.h>
#include <vector>
#include <list>
#include "CombatObject.h"

class CombatPlayerVessel : public CombatObject
{
public:
	CombatPlayerVessel(lua_State *LuaVM, std::string ScriptName);

	~CombatPlayerVessel();

	virtual void Draw(BITMAP *Canvas);
	virtual void Move();
	
	void ForwardThrust(bool active)		{ forwardThrust = active; }		
	void ReverseThrust(bool active)		{ reverseThrust = active; }			
	void TurnRight(bool active)			{ turnRight = active; }				
	void TurnLeft(bool active)			{ turnLeft = active; }	
	void ResetNav()						{ forwardThrust = reverseThrust = turnRight = turnLeft = false; }		

	bool ForwardThrust()				const { return forwardThrust; }		
	bool ReverseThrust()				const { return reverseThrust; }			
	bool TurnRight()					const { return turnRight; }				
	bool TurnLeft()						const { return turnLeft; }	

protected:
	bool forwardThrust;
	bool reverseThrust;
	bool turnRight;
	bool turnLeft;


private: 


};
