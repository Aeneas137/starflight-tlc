
#include "env.h"
#include "CargoSize.h"
#include "Game.h"


using namespace std;

CargoSize::CargoSize(): Requirement(),
	size(0)
{
	
};

CargoSize::CargoSize(TiXmlElement *rootElement): Requirement(),
	size(0)
{
	TiXmlHandle reqHandle(rootElement);

	TiXmlText * text;

	text = reqHandle.FirstChild("Size").FirstChild().Text();
	if (text != NULL)
	{
		this->size = atoi(text->Value());
	}
};


CargoSize::~CargoSize()
{

}

void CargoSize::RegisterSelf()
{
	//This one doesn't get an event call
}

void CargoSize::UnregisterSelf()
{
	//This one doesn't get an event call
}

bool CargoSize::Check()
{
	if (Game::gameState->CalculateCargoStacks() < size)
		completed = false;
	else
		completed = true;

	return completed;
}

std::string CargoSize::ToString()
{
	std::string str = "You must have ";
	char *sizeStr = new char[10];
	_itoa(size, sizeStr, 10);
	str += sizeStr;
	str += " Cargo Pods";
	delete [] sizeStr;

	return str;
}
