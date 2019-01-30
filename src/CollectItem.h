#ifndef COLLECTITEM_H
#define COLLECTITEM_H
#pragma once

#include <string>
#include <vector>
#include <utility>
#include "tinyxml/tinyxml.h"
#include "Requirement.h"
#include "GameState.h"
#include "QuestMgr.h"

class CollectItem : public Requirement, public ICollectedItemEvent
{
public:
	CollectItem();
	CollectItem(TiXmlElement *rootElement);
	virtual ~CollectItem();
	virtual void RegisterSelf();
	virtual void UnregisterSelf();
	virtual bool Check();
	virtual std::string ToString();

	void OnCollectedItem(int itemid);

	virtual const int GetItemID() const { return itemid; };
	virtual const int GetRequiredAmount() const { return amount; };


protected:
	int itemid;
	int amount;


private:


};

#endif

