/*
	STARFLIGHT - THE LOST COLONY
	ModuleStarmap.h - The QuestLog Module
	Author: Justin Sargent
	Date: Nov-24-2007
*/	

#ifndef MODULEQUESTLOG_H
#define MODULEQUESTLOG_H

#include "Module.h"
#include <allegro.h>
#include "GameState.h"
#include "EventMgr.h"
#include "Label.h"

class ModuleQuestLog : public Module
{
public:
	ModuleQuestLog();
	virtual ~ModuleQuestLog();
	virtual bool Init();
	void Update();
	virtual void Draw();
	virtual void OnKeyPress( int keyCode );
	virtual void OnKeyPressed(int keyCode);
	virtual void OnKeyReleased(int keyCode);
	virtual void OnMouseMove(int x, int y);
	virtual void OnMouseClick(int button, int x, int y);
	virtual void OnMousePressed(int button, int x, int y);
	virtual void OnMouseReleased(int button, int x, int y);
	virtual void OnMouseWheelUp(int x, int y);
	virtual void OnMouseWheelDown(int x, int y);
	virtual void OnEvent(Event *event);
	virtual void Close();

private:
	bool log_active;
	int viewer_offset_x, viewer_offset_y;

	BITMAP *questDataWindow;
	BITMAP *window;

	Label *questName;
	Label *questDesc;

};

#endif
