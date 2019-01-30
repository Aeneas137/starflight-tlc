#include "env.h"	//added for TRACE support.
#include <string>
#include "Game.h"
#include "QuestMgr.h"
#include "GameState.h"
#include "Util.h"
#include "DataMgr.h"
using namespace std;


QuestMgr::QuestMgr()
{
	script = 0;
	questId = -1;
	questName = "";
	questShort = "";
	questLong = "";
}


QuestMgr::~QuestMgr()
{
	delete script;
}

bool QuestMgr::Initialize()
{
	debriefStatus = 0;

	if (script != NULL) delete script;

	//load quest script file
	script = new Script();
	if (!script->load("data/quests.lua")) {
		return false;
	}

	std::string prof = g_game->gameState->getProfessionString();
	script->setGlobalString("profession", prof );

	if (!script->runFunction("Initialize")) return false;

	if (!getActiveQuest()) return false;

	return true;
}

void QuestMgr::getScriptGlobals()
{
	questName = script->getGlobalString("quest_name");
	questShort = script->getGlobalString("quest_short");
	questLong = script->getGlobalString("quest_long");
	questDebrief = script->getGlobalString("quest_debrief");
	questReqCode = script->getGlobalNumber("requirement_code");
	questReqType = script->getGlobalNumber("requirement_type");
	questReqAmt = script->getGlobalNumber("requirement_amount");
	questRewCode = script->getGlobalNumber("reward_code");
	questRewType = script->getGlobalNumber("reward_type");
	questRewAmt = script->getGlobalNumber("reward_amount");

	int active_quest = script->getGlobalNumber("active_quest");
	g_game->gameState->setActiveQuest( active_quest );

	int plot_stage = script->getGlobalNumber("plot_stage");
	g_game->gameState->setPlotStage( plot_stage );
}

void QuestMgr::setScriptGlobals()
{
}

bool QuestMgr::getQuestByID(int id)
{
    script->setGlobalNumber("active_quest", id);
    getScriptGlobals();
    return true;
}

bool QuestMgr::getNextQuest()
{
	if (!script->runFunction("getNextQuest")) {
		return false;
	}
	getScriptGlobals();

	return true;
}

bool QuestMgr::getActiveQuest()
{
	//set active quest (especially important when coming from a savegame file)
	//otherwise script uses it's own numbering
	int active = g_game->gameState->getActiveQuest();
	if (active > 0)
		script->setGlobalNumber("active_quest", active );

	if (!script->runFunction("getActiveQuest")) {
		return false;
	}
	getScriptGlobals();

	return true;
}

void QuestMgr::setStoredValue(int value)
{
	g_game->gameState->setStoredValue(value);
	//storedValue = value;
}

void QuestMgr::raiseEvent(int eventid, int param1, int param2)
{
	//perform test of current quest requiremenets

	//prevent new tests from overwriting an existing completion state
	if (g_game->gameState->getQuestCompleted() == false)
	{
		//is this event the one we're looking for?
		if (eventid == questReqCode)
		{
			//handle simple events without parameters
			if (param1 == -1)  {
				param1 = eventid;
				g_game->gameState->setStoredValue(param1);
				//setStoredValue( param1 );
			} else
				g_game->gameState->setStoredValue(questReqType);
				//setStoredValue( questReqType );

			//test the quest conditions
			VerifyRequirements( eventid, param1, param2 );
		}
	}
}

void QuestMgr::VerifyRequirements(int reqCode, int reqType, int reqAmt)
{
	Item newitem;
	int id, amt;
	int starSystem;
	bool req = false;

	int storedValue= g_game->gameState->getStoredValue();
	switch(	reqCode )
	{ 
	// 2 = item
	case 2:	 
		id = reqType;
		g_game->gameState->m_items.Get_Item_By_ID(id, newitem, amt);
		req = (amt >= reqAmt);
		break;

	//10 = explore star system
	case 10: 
		starSystem = reqType;
		if (starSystem == storedValue) req = true; 
		break;

	//12 = orbit planet
	case 12: 
		if (reqType == storedValue) req = true; 
		break;

	//14 = scan planet
	case 14: 
		if (reqType == storedValue) req = true;
		break;

	//16 = land on planet
	case 16: 
		if (reqType == storedValue) req = true;
		break;

	//18 = enter personnel 
	case 18:
		//dont need to do anything special here
		if (reqCode == storedValue) req = true;
		break;

	//20 = enter trade depot
	case 20:
		if (reqCode == storedValue) req = true;
		break;

	//22 = enter docking bay
	case 22:
		if (reqCode == storedValue) req = true;
		break;

	//24 = enter bank
	case 24:
		if (reqCode == storedValue) req = true;
		break;

	}

	//set global quest_completed state
	g_game->gameState->setQuestCompleted(req);
}

void QuestMgr::giveReward()
{
	string reward = "Error: Reward is invalid";
	Item *item;
	int id, amt;

	switch ( g_game->questMgr->questRewCode )
	{
	//0 = YOU WIN
	case 0:
		reward = "GAME OVER... YOU SAVED THE GALAXY!";
		break;

	//1 = money
	case 1:
		amt = g_game->questMgr->questRewAmt;
		g_game->gameState->augCredits( amt );
		reward = "You received " + Util::ToString(amt) + " credits.";
		break;

	//2 = item
	case 2:
		amt = g_game->questMgr->questRewAmt;
		id = g_game->questMgr->questRewType;
		item = g_game->dataMgr->GetItemByID( id );

		//check for available cargo space. artifacts take no space (not that we should ever give artifact here).
		if (!item->IsArtifact()){
			int freeSpace = g_game->gameState->m_ship.getAvailableSpace();

			if ( freeSpace <= 0 ){
				reward = "You received nothing. Remember to make free space in your hold next time!";
				break;
			}

			//do not pick up more than available cargo space
			if (amt > freeSpace) amt = freeSpace;
		}
		
		g_game->gameState->m_items.AddItems( id, amt );
		reward = "You received " + Util::ToString( amt, 1, 1 ) + " cubic meters of " + item->name + ".";
		break;
	}

	//show message
	g_game->ShowMessageBoxWindow("", reward, 350, 300, YELLOW, 650, 440, false );


    /**
	    reset stored value
        Note: this is crucial to the functioning of the QuestMgr since storedvalue represents the 
        completion status of the current quest.
    **/
	g_game->gameState->setStoredValue(-1);
	//storedValue = -1;
}
