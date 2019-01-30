
#include "PlanetSurfacePlayerVessel.h"

PlanetSurfacePlayerVessel::PlanetSurfacePlayerVessel(lua_State *LuaVM, std::string ScriptName) : PlanetSurfaceObject(LuaVM, ScriptName),
	forwardThrust(0),
	reverseThrust(0),
	turnRight(0),
	turnLeft(0)
{
	
}

PlanetSurfacePlayerVessel::~PlanetSurfacePlayerVessel() {}


void PlanetSurfacePlayerVessel::Move()
{
	///* the function name */
	//lua_getglobal(luaVM, this->GetScriptName().append("Move").c_str());

	//// call the function 
	//lua_call(luaVM, 0, 0);

	PlanetSurfaceObject::Move();
}

void PlanetSurfacePlayerVessel::Draw(BITMAP *Canvas)
{
	PlanetSurfaceObject::Draw(Canvas);

}
