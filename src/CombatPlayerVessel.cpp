
#include "CombatPlayerVessel.h"

CombatPlayerVessel::CombatPlayerVessel(lua_State *LuaVM, std::string ScriptName) : CombatObject(LuaVM, ScriptName),
	forwardThrust(0),
	reverseThrust(0),
	turnRight(0),
	turnLeft(0)
{
	
}

CombatPlayerVessel::~CombatPlayerVessel() {}


void CombatPlayerVessel::Move()
{
	///* the function name */
	//lua_getglobal(luaVM, this->GetScriptName().append("Move").c_str());

	//// call the function 
	//lua_call(luaVM, 0, 0);

	CombatObject::Move();
}

void CombatPlayerVessel::Draw(BITMAP *Canvas)
{
	CombatObject::Draw(Canvas);

}
