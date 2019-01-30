
#include "env.h"
#include "CaptainType.h"

using namespace std;

CaptainType::CaptainType(): Requirement(),
	requiredCapType(PROFESSION_NONE)
{
	
};

CaptainType::CaptainType(TiXmlElement *rootElement): Requirement(),
	requiredCapType(PROFESSION_NONE)
{
	TiXmlHandle reqHandle(rootElement);

	TiXmlText * text;

	text = reqHandle.FirstChild("Type").FirstChild().Text();
	if (text != NULL)
	{
		this->requiredCapType = (ProfessionType)atoi(text->Value());
	}
};


CaptainType::~CaptainType()
{

}

void CaptainType::RegisterSelf()
{

}

void CaptainType::UnregisterSelf()
{

}

bool CaptainType::Check()
{
	if (Game::gameState->getProfession() == requiredCapType)
		completed = true;
	else
		completed = false;

	return completed;
}

std::string CaptainType::ToString()
{
	std::string str = "You must become a ";

	switch (requiredCapType)
	{
	case PROFESSION_NONE:
		str = "";
		break;

	case PROFESSION_SCIENTIFIC:
		str += "Science Officer";
		break;

	case PROFESSION_FREELANCE:
		str += "Freelancer";
		break;

	case PROFESSION_MILITARY:
		str += "Military Officer";
		break;

	default:
		str = "";
		break;
	}

	return str;
}
