/*
	STARFLIGHT - THE LOST COLONY
	Script.h
	Author: J.Harbour
	Date: 2007

	This wrapper helps with repetitive use of LUA library.
	Add new functionality as needed.
*/

#pragma once

#include <vector>
#include <lua.hpp>

class Script
{
	private:
		lua_State *luaState;
		
	public:
		Script();
		virtual ~Script();

		bool load(std::string scriptfile);

		std::string getGlobalString(std::string name);
		void setGlobalString(std::string name, std::string value);

		double getGlobalNumber(std::string name);
		void setGlobalNumber(std::string name, double value);

		bool getGlobalBoolean(std::string name);
		void setGlobalBoolean(std::string name, bool value);

		bool runFunction(std::string name);

		std::string errorMessage;
		lua_State *getState() { return luaState; }
};
