#ifndef ORBITPLANET_H
#define ORBITPLANET_H
#pragma once

#include <string>
#include <vector>
#include <utility>
#include "tinyxml/tinyxml.h"
#include "QuestMgr.h"
#include "GameState.h"

class OrbitPlanet : public Requirement, public IOrbitPlanetEvent
{
public:
	OrbitPlanet();
	OrbitPlanet(TiXmlElement *rootElement);
	virtual ~OrbitPlanet();
	virtual void RegisterSelf();
	virtual void UnregisterSelf();
	virtual bool Check();
	virtual std::string ToString();

	virtual const int GetPlanetID() const { return planetid; };
	virtual const int GetStarID() const { return starid; };

	virtual void OnOrbitPlanet(int planetid);

protected:
	int planetid;
	int starid;


private:


};

#endif

