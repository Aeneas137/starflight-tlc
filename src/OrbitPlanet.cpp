
#include "env.h"
#include "OrbitPlanet.h"
#include "Game.h"
#include "DataMgr.h"

using namespace std;

OrbitPlanet::OrbitPlanet(): Requirement(),
	planetid(0),
	starid(0)
{
	
};	
	
OrbitPlanet::OrbitPlanet(TiXmlElement *rootElement): Requirement()
{
	//Set default values
	planetid = 0;
	starid = 0;

	TiXmlHandle reqHandle(rootElement);

	TiXmlText * text;

	text = reqHandle.FirstChild("StarID").FirstChild().Text();
	if (text != NULL)
	{
		this->starid = atoi(text->Value());
	}

	text = reqHandle.FirstChild("PlanetID").FirstChild().Text();
	if (text != NULL)
	{
		this->planetid = atoi(text->Value());
	}
};


OrbitPlanet::~OrbitPlanet()
{
	
}


void OrbitPlanet::RegisterSelf()
{
	Game::questMgr->OrbitPlanetEventMgr.Register(this);
}

void OrbitPlanet::UnregisterSelf()
{
	Game::questMgr->OrbitPlanetEventMgr.Unregister(this);
}

bool OrbitPlanet::Check()
{
	return completed;
}

void OrbitPlanet::OnOrbitPlanet(int planetid)
{
	if (planetid == this->planetid)
	{
		completed = true;
		//UnregisterSelf(); - You can't unregister in this function call because the caller is iterating with a foreach
	}
}

std::string OrbitPlanet::ToString()
{
	Star *star = g_game->dataMgr->GetStarByID(starid);
	Planet *planet = NULL;
	if (star != NULL)
		planet = star->GetPlanetByID(planetid);

	std::string str = "Orbit Planet ";
	if (planet != NULL)
		str += planet->name;
	else
		str += "Bad Planet ID";
	str += " in the ";
	if (star != NULL)
		str += star->name;
	else
		str += "Bad Star ID";

	return str;
}
