#ifndef KILLANIMAL_H
#define KILLANIMAL_H
#pragma once

#include <string>
#include <vector>
#include <utility>
#include "tinyxml/tinyxml.h"
#include "QuestMgr.h"
#include "GameState.h"

class KillAnimal : public Requirement, public IKillAnimalEvent
{
public:
	KillAnimal();
	KillAnimal(TiXmlElement *rootElement);
	virtual ~KillAnimal();
	virtual void RegisterSelf();
	virtual void UnregisterSelf();
	virtual bool Check();
	virtual std::string ToString();

	virtual const int GetAnimalID() const { return animalid; };
	virtual const int GetStarID() const { return amount; };

	virtual void OnKillAnimal(int animalid);

protected:
	int animalid;
	int amount;
	int count;

private:


};

#endif

