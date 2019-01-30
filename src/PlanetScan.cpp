
#include "env.h"
#include "PlanetScan.h"
#include "Game.h"
#include "DataMgr.h"

using namespace std;

PlanetScan::PlanetScan(): Requirement(),
	planetid(0),
	starid(0)
{
	
};	
	
PlanetScan::PlanetScan(TiXmlElement *rootElement): Requirement()
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


PlanetScan::~PlanetScan()
{
	
}


void PlanetScan::RegisterSelf()
{
	Game::questMgr->PlanetScanEventMgr.Register(this);
}

void PlanetScan::UnregisterSelf()
{
	Game::questMgr->PlanetScanEventMgr.Unregister(this);
}

bool PlanetScan::Check()
{
	completed = Game::gameState->PlanetsBeenScanned(planetid);
	return completed;
}

void PlanetScan::OnPlanetScan(int planetid)
{
	if (planetid == this->planetid)
	{
		completed = true;
		//UnregisterSelf();
	}
}

std::string PlanetScan::ToString()
{
	Star *star = g_game->dataMgr->GetStarByID(starid);
	Planet *planet = NULL;
	if (star != NULL)
		planet = star->GetPlanetByID(planetid);

	std::string str = "Scan Planet ";
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
