/*
#ifndef QUEST_H
#define QUEST_H
#pragma once

#include <string>
#include <vector>
#include <map>
#include <utility>
#include "tinyxml/tinyxml.h"
#include "DataMgr.h"

class Item;
struct QuestScript;

struct QuestItem
{
	int ItemID;
	int Amount;

	QuestItem()
	{
		ItemID = -1;
		Amount = -1;
	}
};

class Quest
{
public:
	Quest();
	Quest(TiXmlElement *rootElement);
	virtual ~Quest();

	bool CheckPrerequisites();
	void Activate();
	void Deactivate();
	void Complete();
	bool CheckCompletion();

	// Accessors
	const int GetID()					const { return id; };
	const int GetState()				const { return state; };
	const std::string GetTitleStr()		const { return title; };
	const char* GetTitleChar()			const { return title.c_str(); };
	const int GetCashReward()			const { return cashReward; };
	const int GetCashStarting()			const { return cashStarting; };
	const int StartingItemsAmount()		const { return (int)itemsStarting.size(); };

	const std::vector<QuestItem*>* GetItemRewardList()				const { return &itemsReward; };
	const std::vector<QuestItem*>* GetItemStartingList()			const { return &itemsStarting; };
	//const std::vector<Requirement*>* GetPrerequisiteList()			const { return &prerequisites; };
	//const std::vector<Requirement*>* GetRequirementList()			const { return &requirements; };
	//const std::vector<std::string>* GetPlanetSurfaceEventsList()	const { return &planetsurfaceEvents; };

	const int GetBriefingTextID()		const { return briefingText; };
	const int GetDebriefingTextID()		const { return debriefingText; };


	//Mutators
	void SetState(int newState) { state = newState; };

protected:
	void GiveReward();
	

private:
	//Variables
	int id;
	int state;
	std::string title;

	int cashReward;
	int cashStarting;

	std::vector<QuestItem*> itemsReward;
	std::vector<QuestItem*> itemsStarting;
	
	//std::vector<Requirement*> prerequisites;
	//std::vector<Requirement*> requirements;

	std::vector<std::string> planetsurfaceEvents;
	
	int briefingText;
	int debriefingText;

	//Methods
	//void LoadRequirements(TiXmlElement *rootElement, std::vector<Requirement*> *list);
	//Requirement* LoadRequirement(TiXmlElement *rootElement);
	//void LoadEvents(TiXmlElement *rootElement, std::vector<std::string> *list);
	//void LoadRewards(TiXmlElement *rootElement);
	//void LoadStartings(TiXmlElement *rootElement);
	//void LoadText(TiXmlElement *rootElement);
};


#endif
*/
