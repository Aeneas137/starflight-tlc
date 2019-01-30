
#include "env.h"
#include "KillAnimal.h"
#include "Game.h"
#include "DataMgr.h"

using namespace std;

KillAnimal::KillAnimal(): Requirement(),
	animalid(0),
	amount(0),
	count(0)
{
	
};	
	
KillAnimal::KillAnimal(TiXmlElement *rootElement): Requirement(),
	animalid(0),
	amount(0),
	count(0)
{
	TiXmlHandle reqHandle(rootElement);

	TiXmlText * text;

	text = reqHandle.FirstChild("AnimalID").FirstChild().Text();
	if (text != NULL)
	{
		this->animalid = atoi(text->Value());
	}

	text = reqHandle.FirstChild("Amount").FirstChild().Text();
	if (text != NULL)
	{
		this->amount = atoi(text->Value());
	}
};


KillAnimal::~KillAnimal()
{
	
}


void KillAnimal::RegisterSelf()
{
	Game::questMgr->KillAnimalEventMgr.Register(this);
}

void KillAnimal::UnregisterSelf()
{
	Game::questMgr->KillAnimalEventMgr.Unregister(this);
}

bool KillAnimal::Check()
{
	if (count >= amount)
		completed = true;
	else
		completed = false;

	return completed;
}

void KillAnimal::OnKillAnimal(int animalid)
{
	if (!completed)
	{
		if (animalid == this->animalid)
		{
			++count;
		}
		if (count >= amount)
		{
			completed = true;
			//UnregisterSelf(); //we can't unregister here!!
		}
	}
}

std::string KillAnimal::ToString()
{
	Item *item = g_game->dataMgr->GetItemByID(animalid);
	char *amountstr = new char[10];
	itoa(amount, amountstr, 10);
	char *countstr = new char[10];
	itoa(count, countstr, 10);

	std::string str = "Exterminate ";
	str += amountstr;
	str += " ";
	str += item->name;
	str += " - ";
	str += countstr;
	str += "/";
	str += amountstr;

	delete [] amountstr;
	delete [] countstr;

	return str;
}
