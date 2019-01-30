/*
	STARFLIGHT - THE LOST COLONY
	ModuleEngineer.h - The Engineering module.
	Author: Keith "Daikaze" Patch
	Date: 5-27-2008
*/	

#ifndef MODULEENGINEER_H
#define MODULEENGINEER_H

#include "Module.h"
#include "Button.h"
#include "ScrollBox.h"
#include "GameState.h"

class ModuleEngineer : public Module
{
public:
	ModuleEngineer();
	virtual ~ModuleEngineer();
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
	bool useMineral(Ship &ship);
	bool module_active;
	BITMAP* img_window;
	BITMAP* img_bar_base;
	BITMAP* text;
	BITMAP* img_bar_laser ;
	BITMAP* img_bar_missile;
	BITMAP* img_bar_hull;
	BITMAP* img_bar_armor;
	BITMAP* img_bar_shield;
	BITMAP* img_bar_engine;
	BITMAP* img_ship;
	BITMAP* img_button_repair;
	BITMAP* img_button_repair_over;
	Button* button[5];
	int	 VIEWER_WIDTH,
		 VIEWER_HEIGHT,
		 VIEWER_TARGET_OFFSET,
		 VIEWER_MOVE_RATE,
		 viewer_offset_y;
};

#endif
