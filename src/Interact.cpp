
#include "env.h"
#include "Interact.h"
#include "Game.h"
#include "DataMgr.h"

using namespace std;

Interact::Interact(): Requirement(),
	interactid(0)
{
	
};	
	
Interact::Interact(TiXmlElement *rootElement): Requirement(),
	interactid(0)
{
	TiXmlHandle reqHandle(rootElement);

	TiXmlText * text;

	text = reqHandle.FirstChild("InteractID").FirstChild().Text();
	if (text != NULL)
	{
		this->interactid = atoi(text->Value());
	}

	text = reqHandle.FirstChild("InteractDescription").FirstChild().Text();
	if (text != NULL)
	{
		this->interactDescription = text->Value();
	}
};


Interact::~Interact()
{
	
}


void Interact::RegisterSelf()
{
	Game::questMgr->InteractEventMgr.Register(this);
}

void Interact::UnregisterSelf()
{
	Game::questMgr->InteractEventMgr.Unregister(this);
}

bool Interact::Check()
{
	return completed;
}

void Interact::OnInteract(int interactid)
{
	if (interactid == this->interactid)
	{
		completed = true;
		//UnregisterSelf();
	}
	else
	{
		completed = false;
	}
}

std::string Interact::ToString()
{
	return interactDescription;
}
