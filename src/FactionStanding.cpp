
#include "env.h"
#include "FactionStanding.h"

using namespace std;

FactionStanding::FactionStanding(): Requirement(),
	faction(Myrrdan),
	lowvalue(0),
	highvalue(0)
{
	
};	
	
FactionStanding::FactionStanding(TiXmlElement *rootElement): Requirement(),
	faction(Myrrdan),
	lowvalue(0),
	highvalue(0)
{
	//Set default values
	faction = Myrrdan;
	lowvalue = 0;
	highvalue = 0;

	TiXmlHandle reqHandle(rootElement);

	TiXmlText * text;

	text = reqHandle.FirstChild("Faction").FirstChild().Text();
	if (text != NULL)
	{
		this->faction = (Faction)atoi(text->Value());
	}

	text = reqHandle.FirstChild("LowValue").FirstChild().Text();
	if (text != NULL)
	{
		this->lowvalue = atoi(text->Value());
	}

	text = reqHandle.FirstChild("HighValue").FirstChild().Text();
	if (text != NULL)
	{
		this->highvalue = atoi(text->Value());
	}
};


FactionStanding::~FactionStanding()
{

}

void FactionStanding::RegisterSelf()
{

}

void FactionStanding::UnregisterSelf()
{

}

bool FactionStanding::Check()
{
	return true;
}

std::string FactionStanding::ToString()
{
	std::string str = "You must increase your reputation";

	return str;
}
