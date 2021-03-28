/*
	LUA script wrapper class by J.Harbour.
	Note: LUA does not throw exceptions.
*/

#include "env.h"		//for TRACE calls.
#include <exception>
#include <iostream>
#include <string>
#include <allegro.h>
#include "Script.h"
#include "Game.h"
using namespace std;

static jmp_buf custom_lua_panic_jump;

static int custom_lua_atpanic(lua_State *lua)
{
    TRACE("custom_lua_atpanic\n");
    longjmp(custom_lua_panic_jump, 1);
    return 0;
}


Script::~Script()
{
	lua_close(luaState);
}

Script::Script()
{
	errorMessage = "";
	luaState = luaL_newstate();
	luaL_openlibs(luaState);
    lua_atpanic(luaState, &custom_lua_atpanic);
}

bool Script::load(std::string scriptfile)
{
	int ret = luaL_dofile(luaState, scriptfile.c_str() );
	if (ret > 0) {
		//get lua error message from the stack
		string luaError = lua_tostring(luaState, -1);
		lua_pop(luaState, 1);
		errorMessage = luaError.c_str();
		TRACE("Script load error: return= %d, message= %s.\n", ret, errorMessage.c_str());
		return false;
	}

	errorMessage = "";
	return true;
}


std::string Script::getGlobalString(std::string name)
{
	string value = "";
    string luaError="";

    if (setjmp(custom_lua_panic_jump) == 0) {
      /* interact with Lua VM */
        lua_getglobal(luaState, name.c_str());
    } else {
      /* recovered from panic. log and return */
    }	

    value = lua_tostring(luaState, -1);
    lua_pop(luaState, 1);
	return value;
}


void Script::setGlobalString(std::string name, std::string value)
{
	lua_pushstring(luaState, value.c_str());
	lua_setglobal(luaState, name.c_str());
}

double Script::getGlobalNumber(std::string name)
{
	double value = 0.0;
	lua_getglobal(luaState, name.c_str());			//TAG - debug spot
	value = lua_tonumber(luaState, -1);
	lua_pop(luaState, 1);
	return value;
}

void Script::setGlobalNumber(std::string name, double value)
{
	lua_pushnumber(luaState, (int)value);
	lua_setglobal(luaState, name.c_str());
}

bool Script::getGlobalBoolean(std::string name)
{

	bool value = false;
    string luaError="";
	lua_getglobal(luaState, name.c_str());
    value = lua_toboolean(luaState, -1) != 0;
    lua_pop(luaState, 1);
	return value;
}

void Script::setGlobalBoolean(std::string name, bool value)
{
	lua_pushboolean(luaState, (int)value);
	lua_setglobal(luaState, name.c_str());
}

bool Script::runFunction(std::string name)
{
	//call script function, 0 args, 0 retvals
	string luaError="";
	lua_getglobal(luaState, name.c_str());
	int result = lua_pcall(luaState, 0, 0, 0);
	if (result != 0) {
		luaError = lua_tostring(luaState, -1);
		TRACE("Script run error:  Lua error message= %s\n", errorMessage.c_str());
		lua_pop(luaState, 1);
		errorMessage = luaError;
		return false;
	}
	errorMessage = "";
	return true;
}
