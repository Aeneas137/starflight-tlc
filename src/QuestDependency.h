#ifndef QUESTDEPENDENCY_H
#define QUESTDEPENDENCY_H
#pragma once

#include <string>
#include <vector>
#include <utility>
#include "tinyxml/tinyxml.h"
#include "Requirement.h"
#include "Game.h"
#include "GameState.h"

class QuestDependency : public Requirement
{
public:
	QuestDependency();
	QuestDependency(TiXmlElement *rootElement);
	virtual ~QuestDependency();
	virtual void RegisterSelf();
	virtual void UnregisterSelf();
	virtual bool Check();
	virtual std::string ToString();

	virtual const std::vector<int> GetQuestIDs() const { return questIDs; };


protected:
	std::vector<int> questIDs;

private:


};

#endif

