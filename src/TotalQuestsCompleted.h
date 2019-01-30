#ifndef TOTALQUESTSCOMPLETED_H
#define TOTALQUESTSCOMPLETED_H
#pragma once

#include <string>
#include <vector>
#include <utility>
#include "tinyxml/tinyxml.h"
#include "QuestMgr.h"
#include "GameState.h"

class TotalQuestsCompleted : public Requirement
{
public:
	TotalQuestsCompleted();
	TotalQuestsCompleted(TiXmlElement *rootElement);
	virtual ~TotalQuestsCompleted();
	virtual void RegisterSelf();
	virtual void UnregisterSelf();
	virtual bool Check();
	virtual std::string ToString();

	virtual const int GetTotalQuestsNeeded() const { return totalQuests; };

protected:
	int totalQuests;

private:


};

#endif

