#ifndef FACTIONSTANDING_H
#define FACTIONSTANDING_H
#pragma once

#include <string>
#include <vector>
#include <utility>
#include "tinyxml/tinyxml.h"
#include "Requirement.h"
#include "GameState.h"

class FactionStanding : public Requirement
{
public:
	FactionStanding();
	FactionStanding(TiXmlElement *rootElement);
	virtual ~FactionStanding();
	virtual void RegisterSelf();
	virtual void UnregisterSelf();
	virtual bool Check();
	virtual std::string ToString();

	virtual const Faction GetFaction() const { return faction; };
	virtual const int GetLowValue() const { return lowvalue; };
	virtual const int GetHighValue() const { return highvalue; };


protected:
	Faction faction;
	int lowvalue;
	int highvalue;

private:


};

#endif

