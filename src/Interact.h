#ifndef INTERACT_H
#define INTERACT_H
#pragma once

#include <string>
#include <vector>
#include <utility>
#include "tinyxml/tinyxml.h"
#include "QuestMgr.h"
#include "GameState.h"

class Interact : public Requirement, public IInteractEvent
{
public:
	Interact();
	Interact(TiXmlElement *rootElement);
	virtual ~Interact();
	virtual void RegisterSelf();
	virtual void UnregisterSelf();
	virtual bool Check();
	virtual std::string ToString();

	virtual const int GetInteractID() const { return interactid; };

	virtual void OnInteract(int animalid);

protected:
	int interactid;
	std::string interactDescription;

private:


};

#endif

