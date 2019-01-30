#ifndef GAMETIME_H
#define GAMETIME_H
#pragma once

#include <string>
#include <vector>
#include <utility>
#include "tinyxml/tinyxml.h"
#include "Requirement.h"
#include "GameState.h"

class GameTime : public Requirement
{
public:
	GameTime();
	GameTime(TiXmlElement *rootElement);
	virtual ~GameTime();
	virtual void RegisterSelf();
	virtual void UnregisterSelf();
	virtual bool Check();
	virtual std::string ToString();

	virtual const int GetRequiredGameTime() const { return gametime; };


protected:
	int gametime;

private:


};

#endif

