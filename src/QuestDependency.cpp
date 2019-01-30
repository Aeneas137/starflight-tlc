
#include "env.h"
#include "QuestDependency.h"

using namespace std;

QuestDependency::QuestDependency(): Requirement()
{
	questIDs.clear();
};	
	
QuestDependency::QuestDependency(TiXmlElement *rootElement): Requirement()
{
	//Set default values
	questIDs.clear();

	TiXmlHandle reqHandle(rootElement);
	TiXmlElement *questID = rootElement->FirstChildElement("QuestID");

	TiXmlText * text;
	text = questID->FirstChild()->ToText();

	while (text != NULL)
	{
		this->questIDs.push_back(atoi(text->Value()));
		questID = questID->NextSiblingElement("QuestID");
		text = NULL;
		if (questID != NULL)
			text = questID->FirstChild()->ToText();
	}
};


QuestDependency::~QuestDependency()
{

}

void QuestDependency::RegisterSelf()
{

}

void QuestDependency::UnregisterSelf()
{

}

bool QuestDependency::Check()
{
	bool result = true;

	for (int i=0; i < (int)questIDs.size(); ++i)
	{
		if (!Game::gameState->QuestCompleted(questIDs[i]))
		{
			result = false;
			break;
		}
	}

	return result;
}

std::string QuestDependency::ToString()
{
	std::string str = "You need to complete previous quests first!";

	return str;
}
