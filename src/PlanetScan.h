#ifndef PLANETSCAN_H
#define PLANETSCAN_H
#pragma once

#include <string>
#include <vector>
#include <utility>
#include "tinyxml/tinyxml.h"
#include "QuestMgr.h"
#include "GameState.h"

class PlanetScan : public Requirement, public IPlanetScanEvent
{
public:
	PlanetScan();
	PlanetScan(TiXmlElement *rootElement);
	virtual ~PlanetScan();
	virtual void RegisterSelf();
	virtual void UnregisterSelf();
	virtual bool Check();
	virtual std::string ToString();

	virtual const int GetPlanetID() const { return planetid; };
	virtual const int GetStarID() const { return starid; };

	virtual void OnPlanetScan(int planetid);

protected:
	int planetid;
	int starid;

private:


};

#endif

