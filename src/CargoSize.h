#ifndef CARGOSIZE_H
#define CARGOSIZE_H
#pragma once

#include <string>
#include <vector>
#include <utility>
#include "tinyxml/tinyxml.h"
#include "Requirement.h"
#include "GameState.h"


class CargoSize : public Requirement
{
public:
	CargoSize();
	CargoSize(TiXmlElement *rootElement);
	virtual ~CargoSize();
	virtual void RegisterSelf();
	virtual void UnregisterSelf();
	virtual bool Check();
	virtual std::string ToString();

	virtual const int GetRequiredSize() const { return size; };


protected:
	int size;

private:


};

#endif

