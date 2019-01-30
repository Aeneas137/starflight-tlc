
#include "env.h"
#include "Quest.h"
#include "Game.h"


using namespace std;

/*
Quest::Quest() :
	id(-1),
	state(0),
	title(""),
	cashReward(0),
	cashStarting(0),
	briefingText(-1),
	debriefingText(-1)
{
	itemsReward.clear();
	itemsStarting.clear();
	prerequisites.clear();
	requirements.clear();
	planetsurfaceEvents.clear();
};

Quest::Quest(TiXmlElement *rootElement) :
	id(-1),
	state(0),
	title(""),
	cashReward(0),
	cashStarting(0),
	briefingText(-1),
	debriefingText(-1)
{
	itemsReward.clear();
	itemsStarting.clear();
	prerequisites.clear();
	requirements.clear();
	planetsurfaceEvents.clear();

	TiXmlHandle questHandle(rootElement);

	TiXmlText * text;

	text = questHandle.FirstChild("ID").FirstChild().Text();
	if (text != NULL)
	{
		this->id = atoi(text->Value());
	}

	text = questHandle.FirstChild("State").FirstChild().Text();
	if (text != NULL)
	{
		this->state = atoi(text->Value());
	}

	text = questHandle.FirstChild("Title").FirstChild().Text();
	if (text != NULL)
	{
		this->title = text->Value();
	}

	//LoadRequirements(questHandle.FirstChild("Prerequisites").ToElement(), &prerequisites);
	//LoadRequirements(questHandle.FirstChild("Requirements").ToElement(), &requirements);
	//LoadStartings(questHandle.FirstChild("Startings").ToElement());
	//LoadRewards(questHandle.FirstChild("Rewards").ToElement());
	//LoadText(questHandle.FirstChild("TextLog").ToElement());
	//LoadEvents(questHandle.FirstChild("PlanetSurfaceEvents").ToElement(), &planetsurfaceEvents);

};


Quest::~Quest()
{
	for (int i=0; i < (int)itemsReward.size(); i++)
		delete itemsReward[i];
	itemsReward.clear();

	for (int i=0; i < (int)itemsStarting.size(); i++)
		delete itemsStarting[i];
	itemsStarting.clear();

	for (int i=0; i < (int)prerequisites.size(); i++)
		delete prerequisites[i];
	prerequisites.clear();

	for (int i=0; i < (int)requirements.size(); i++)
		delete requirements[i];
	requirements.clear();

	planetsurfaceEvents.clear();
}

void Quest::LoadRequirements(TiXmlElement *rootElement, std::vector<Requirement*> *list)
{
	// load all Requirements
	TiXmlHandle Handle(rootElement);
	TiXmlElement *element = Handle.FirstChildElement("Requirement").ToElement();
	while (element != NULL)
	{
		Requirement *req = LoadRequirement(element);

		if (req != NULL)
			list->push_back(req);

		element = element->NextSiblingElement("Requirement");
	}
}

Requirement* Quest::LoadRequirement(TiXmlElement *rootElement)
{
	// Load the proper requirement
	Requirement *req = NULL;
	TiXmlAttribute *attr = rootElement->FirstAttribute();
	const std::string value = attr->ValueStr();

	if (value == "CaptainType")
	{
		req = new CaptainType(rootElement);
	}
	else if (value == "CargoSize")
	{
		req = new CargoSize(rootElement);
	}
	else if (value == "CollectItem")
	{
		req = new CollectItem(rootElement);
	}
	else if (value == "FactionStanding")
	{
		req = new FactionStanding(rootElement);
	}
	else if (value == "GameTime")
	{
		req = new GameTime(rootElement);
	}
	else if (value == "PlanetScan")
	{
		req = new PlanetScan(rootElement);
	}
	else if (value == "QuestDependency")
	{
		req = new QuestDependency(rootElement);
	}
	else if (value == "OrbitPlanet")
	{
		req = new OrbitPlanet(rootElement);
	}
	//else if (value == "KillAnimal")
	//{
	//	req = new KillAnimal(rootElement);
	//}
	else if (value == "TotalQuestsCompleted")
	{
		req = new TotalQuestsCompleted(rootElement);
	}
	else if (value == "Interact")
	{
		req = new Interact(rootElement);
	}

	return req;
}

void Quest::LoadEvents(TiXmlElement *rootElement, std::vector<std::string> *list)
{
	// load all Events
	TiXmlHandle Handle(rootElement);
	TiXmlElement *element = Handle.FirstChildElement("Event").ToElement();
	while (element != NULL)
	{
		list->push_back(element->GetText());

		element = element->NextSiblingElement("Event");
	}
}

void Quest::LoadRewards(TiXmlElement *rootElement)
{
	// load all Rewards
	TiXmlHandle Handle(rootElement);
	TiXmlElement *element = Handle.FirstChildElement("Reward").ToElement();
	while (element != NULL)
	{
		TiXmlAttribute *attr = element->FirstAttribute();
		const std::string value = attr->ValueStr();

		if (value == "Cash")
		{
			TiXmlText * text;
			text = element->FirstChild("Amount")->FirstChild()->ToText();
			if (text != NULL)
			{
				this->cashReward = atoi(text->Value());
			}
		}
		else if (value == "Item")
		{
			QuestItem *item = new QuestItem();

			TiXmlText * text;
			text = element->FirstChild("ItemID")->FirstChild()->ToText();
			if (text != NULL)
			{
				item->ItemID = atoi(text->Value());
			}
			
			text = NULL;
			text = element->FirstChild("Amount")->FirstChild()->ToText();
			if (text != NULL && item != NULL)
			{
				item->Amount = atoi(text->Value());
			}

			if (item->ItemID != -1 && item->Amount != -1)
				this->itemsReward.push_back(item);
		}

		element = element->NextSiblingElement("Reward");
	}
}


void Quest::LoadStartings(TiXmlElement *rootElement)
{
	// load all Rewards
	TiXmlHandle Handle(rootElement);
	TiXmlElement *element = Handle.FirstChildElement("Starting").ToElement();
	while (element != NULL)
	{
		TiXmlAttribute *attr = element->FirstAttribute();
		const std::string value = attr->ValueStr();

		if (value == "Cash")
		{
			TiXmlText * text;
			text = element->FirstChild("Amount")->FirstChild()->ToText();
			if (text != NULL)
			{
				this->cashStarting = atoi(text->Value());
			}
		}
		else if (value == "Item")
		{
			QuestItem *item = new QuestItem();

			TiXmlText * text;
			text = element->FirstChild("ItemID")->FirstChild()->ToText();
			if (text != NULL)
			{
				item->ItemID = atoi(text->Value());
			}
			
			text = NULL;
			text = element->FirstChild("Amount")->FirstChild()->ToText();
			if (text != NULL && item != NULL)
			{
				item->Amount = atoi(text->Value());
			}

			if (item->ItemID != -1 && item->Amount != -1)
				this->itemsStarting.push_back(item);
		}

		element = element->NextSiblingElement("Starting");
	}
}



void Quest::LoadText(TiXmlElement *rootElement)
{
	// load all TextBlob IDs
	TiXmlHandle Handle(rootElement);
	TiXmlElement *element = Handle.FirstChildElement("TextBlob").ToElement();
	while (element != NULL)
	{
		TiXmlAttribute *attr = element->FirstAttribute();
		const std::string value = attr->ValueStr();

		if (value == "Briefing")
		{
			TiXmlText * text;
			text = element->FirstChild("ID")->FirstChild()->ToText();
			if (text != NULL)
			{
				this->briefingText = atoi(text->Value());
			}
		}
		else if (value == "Debriefing")
		{
			TiXmlText * text;
			text = element->FirstChild("ID")->FirstChild()->ToText();
			if (text != NULL)
			{
				this->debriefingText = atoi(text->Value());
			}
		}

		element = element->NextSiblingElement("TextBlob");
	}
}



bool Quest::CheckPrerequisites()
{
	bool passed = true;

	for (int i=0; i < (int)prerequisites.size(); i++)
	{
		if (!prerequisites[i]->Check())
		{
			passed = false;
			break;
		}
	}

	return passed;
}

void Quest::Activate()
{
	for (int i=0; i < (int)this->requirements.size(); ++i)
	{
		requirements[i]->RegisterSelf();
	}

	//g_game->gameState->augCredits(cashStarting); -- ignore starting cash
	std::string msg = "";
	for (int i=0; i < (int)this->itemsStarting.size(); ++i)
	{
		g_game->gameState->m_items.AddItems(itemsStarting[i]->ItemID, itemsStarting[i]->Amount);

		if (i != 0) 
		{
			if (i+1 != (int)itemsStarting.size())
			{
				msg += ", ";
			}
			else if ((int)itemsStarting.size() > 1)
			{
				msg += " and ";
			}
		}
		
		char *amtStr = new char[10];
		itoa(itemsStarting[i]->Amount, amtStr, 10);
		msg += amtStr;
		msg += " ";
		delete [] amtStr;

		Item *item = g_game->dataMgr->GetItemByID(itemsStarting[i]->ItemID);
		msg += item->name;
	}

	if ((int)itemsStarting.size() > 0)
	{
		msg += " have been added to your ships cargo.";
		g_game->ShowMessageBoxWindow(msg);
	}

	for (int i=0; i < (int)this->planetsurfaceEvents.size(); ++i)
	{
		QuestScript *newScript = new QuestScript(planetsurfaceEvents[i], this);
		g_game->gameState->planetsurfaceEvents.push_back(newScript);
	}
	this->state = 1;
}

void Quest::Deactivate()
{
	for (int i=0; i < (int)this->requirements.size(); i++)
	{
		requirements[i]->UnregisterSelf();
	}

	for (int i=0; i < (int)this->planetsurfaceEvents.size(); ++i)
	{
		for (int j=0; j < (int) g_game->gameState->planetsurfaceEvents.size(); ++j)
		{
			if (this == g_game->gameState->planetsurfaceEvents[j]->parentQuest)
			{
				delete g_game->gameState->planetsurfaceEvents[j];
				g_game->gameState->planetsurfaceEvents.erase(g_game->gameState->planetsurfaceEvents.begin() + j);
				break;
			}
		}
	}

	//Take back all the items we gave them at the beginning of the quest.
	//If they don't have the items anymore we charge them for replacements.
	if ((int)this->itemsStarting.size() != 0)
	{
		int owe = 0;
		for (int i=0; i < (int)itemsStarting.size(); ++i)
		{
			Item item; int amount = 0; g_game->gameState->m_items.Get_Item_By_ID(itemsStarting[i]->ItemID, item, amount);
			if (amount < itemsStarting[i]->Amount)
			{
				int missing = itemsStarting[i]->Amount - amount;
				owe += (int)( (item.value + 300) * missing );
			}
			g_game->gameState->m_items.RemoveItems(itemsStarting[i]->ItemID, itemsStarting[i]->Amount);
		}
		if (owe != 0)
		{
			g_game->gameState->augCredits(-owe);

			char *oweStr = new char[20];
			itoa(owe, oweStr, 10);

			std::string msg = "Since you seem to have misplaced the cargo we gave you at the beginning of this mission we'll be charging you for new supplies.  Your total comes to ";
			msg += oweStr;
			msg += " MU. Next time I recommend you keep an eye on the cargo we give you for these missions.";
			g_game->ShowMessageBoxWindow(msg);
			delete [] oweStr;
		}
	}

	this->state = 0;
}


void Quest::Complete()
{
	this->GiveReward();
	state = 2;
	g_game->gameState->SetQuestCompleted(this->id, true);

	for (int i=0; i < (int)this->requirements.size(); i++)
	{
		requirements[i]->UnregisterSelf();
	}

	for (int i=0; i < (int)this->planetsurfaceEvents.size(); ++i)
	{
		for (int j=0; j < (int) g_game->gameState->planetsurfaceEvents.size(); ++j)
		{
			if (this == g_game->gameState->planetsurfaceEvents[j]->parentQuest)
			{
				delete g_game->gameState->planetsurfaceEvents[j];
				g_game->gameState->planetsurfaceEvents.erase(g_game->gameState->planetsurfaceEvents.begin() + j);
				break;
			}
		}
	}
}



void Quest::GiveReward()
{
	//Give Cash Reward
	Game::gameState->augCredits(this->cashReward);

	std::string msg = "Congratulations on a job well done! ";

	if (cashReward > 0)
	{
		char *amtStr = new char[10];
		itoa(cashReward, amtStr, 10);
		msg += amtStr;
		msg += " MU has added to your account. ";
		delete [] amtStr;
	}

	//Give them the Items
	for (int i=0; i < (int)itemsReward.size(); i++)
	{
		Game::gameState->m_items.AddItems(itemsReward[i]->ItemID, itemsReward[i]->Amount);

		if (i != 0) 
		{
			if (i+1 != (int)itemsReward.size())
			{
				msg += ", ";
			}
			else if ((int)itemsReward.size() > 1)
			{
				msg += " and ";
			}
		}
		
		char *amtStr = new char[10];
		itoa(itemsReward[i]->Amount, amtStr, 10);
		msg += amtStr;
		msg += " ";
		delete amtStr;

		Item *item = g_game->dataMgr->GetItemByID(itemsReward[i]->ItemID);
		msg += item->name;
	}

	if ((int)itemsReward.size() > 0)
	{
		msg += " have been added to your ships cargo, as well.";
	}

	g_game->ShowMessageBoxWindow(msg);
	
}

bool Quest::CheckCompletion()
{
	for (int i=0; i < (int)requirements.size(); i++)
	{
		if (!requirements[i]->Check())
			return false;
	}
	return true;
}
*/
