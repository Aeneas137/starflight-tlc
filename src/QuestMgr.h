// don't create new instances of this class, use the instance provided in the Game class

#pragma once

#include <string>
#include "QuestMgr.h"
#include "Script.h"

#define QUEST_EVENT_ORBIT 100
#define QUEST_EVENT_PLANETSCAN 101


class QuestMgr
{
public:
	QuestMgr();
	virtual ~QuestMgr();

	bool Initialize();
	bool getNextQuest();
    bool getQuestByID(int id);
	bool getActiveQuest();

	void raiseEvent(int eventid, int param1=-1, int param2=-1);

	int getId() { return questId; }
	std::string getName() { return questName; }
	std::string getShort() { return questShort; }
	std::string getLong() { return questLong; }
	std::string getDebrief() { return questDebrief; }

	void getScriptGlobals();
	void setScriptGlobals();
	void setStoredValue(int value);
	void VerifyRequirements(int reqCode = -1, int reqType = -1, int reqAmt = -1);
	void giveReward();


	int questReqCode, questReqType;
	float questReqAmt;
	int questRewCode, questRewType;
	float questRewAmt;

	//int storedValue;		//moved into GameState with the others to avoid
							//assignment conflicts during game loading.

private:
	//active_quest is maintained by GameState and stored in savegame file
	//all functions in QuestMgr utilize the GameState variable 
	//int active_quest;

	Script *script;

	int questId;
	std::string questName;
	std::string questShort;
	std::string questLong;
	std::string questDebrief;
	int debriefStatus;

};

