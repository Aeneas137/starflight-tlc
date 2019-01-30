#ifndef REQUIREMENT_H
#define REQUIREMENT_H
#pragma once

#include <string>
#include <vector>
#include <utility>
#include "tinyxml/tinyxml.h"

class Requirement
{
public:
	Requirement();
	Requirement(TiXmlElement *rootElement);
	virtual ~Requirement();
	virtual void RegisterSelf() = 0;
	virtual void UnregisterSelf() = 0;
	virtual bool Check() = 0;

	virtual std::string ToString() = 0;
	virtual bool IsCompleted() const { return completed; };

protected:
	bool completed;

private:
	
};

#endif
