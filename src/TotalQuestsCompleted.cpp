
#include "env.h"
#include "TotalQuestsCompleted.h"
#include "Game.h"
#include "DataMgr.h"

using namespace std;

TotalQuestsCompleted::TotalQuestsCompleted(): Requirement(),
	totalQuests(0)
{
	
};	
	
TotalQuestsCompleted::TotalQuestsCompleted(TiXmlElement *rootElement): Requirement(),
	totalQuests(0)
{
	TiXmlHandle reqHandle(rootElement);

	TiXmlText * text;

	text = reqHandle.FirstChild("TotalQuests").FirstChild().Text();
	if (text != NULL)
	{
		this->totalQuests = atoi(text->Value());
	}
};


TotalQuestsCompleted::~TotalQuestsCompleted()
{
	
}


void TotalQuestsCompleted::RegisterSelf()
{
	//This requirement doesn't have an event
}

void TotalQuestsCompleted::UnregisterSelf()
{
	//This requirement doesn't have an event
}

bool TotalQuestsCompleted::Check()
{
	int count = 0;
	for (int i=0; i < 400; ++i)
	{
		if (Game::gameState->QuestCompleted(i))
		{
			++count;
		}
	}

	if (count >= totalQuests)
		completed = true;
	else
		completed = false;

	return completed;
}

std::string TotalQuestsCompleted::ToString()
{
	char *amountstr = new char[10];
	itoa(totalQuests, amountstr, 10);

	std::string str = "You must have already completed ";
	str += amountstr;
	str += " missions";

	delete [] amountstr;

	return str;
}
