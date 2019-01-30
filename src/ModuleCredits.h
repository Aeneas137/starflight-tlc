/*
	STARFLIGHT - THE LOST COLONY
	ModuleCredits.h - ?
	Author: Justin Sargent
	Date: 9/21/07
*/

#ifndef MODULECREDITS_H
#define MODULECREDITS_H

#include "env.h"
#include "Module.h"
#include "GameState.h"
#include "EventMgr.h"

class ModuleCredits : public Module
{
public:
	ModuleCredits();
	virtual ~ModuleCredits();
	virtual bool Init();
	void Update();
	virtual void Draw();
	virtual void OnKeyPress(int keyCode);
	virtual void OnKeyPressed(int keyCode);
	virtual void OnKeyReleased(int keyCode);
	virtual void OnMouseMove(int x, int y);
	virtual void OnMouseClick(int button, int x, int y);
	virtual void OnMousePressed(int button, int x, int y);
	virtual void OnMouseReleased(int button, int x, int y);
	void OnMouseWheelUp(int x, int y);
	void OnMouseWheelDown(int x, int y);
	virtual void OnEvent(Event *event);
	virtual void Close();

private:
	BITMAP *background;
	DATAFILE *datafile;
};



#endif
