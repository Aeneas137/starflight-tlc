#ifndef CAPTAINTYPE_H
#define CAPTAINTYPE_H
#pragma once

#include <string>
#include <vector>
#include <utility>
#include "tinyxml/tinyxml.h"
#include "Requirement.h"
#include "Game.h"
#include "GameState.h"


class CaptainType : public Requirement
{
public:
	CaptainType();
	CaptainType(TiXmlElement *rootElement);
	virtual ~CaptainType();
	virtual void RegisterSelf();
	virtual void UnregisterSelf();
	virtual bool Check();
	virtual std::string ToString();

	virtual const ProfessionType GetRequiredCaptainType() const { return requiredCapType; };


protected:
	ProfessionType requiredCapType;

private:

};

#endif
