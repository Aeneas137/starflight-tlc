/*
	STARFLIGHT - THE LOST COLONY
	ModuleTopGUI.cpp 
	Author: Keith Patch
	Date: April 2008
*/	

#ifndef _MODULETOPGUI_H
#define _MODULETOPGUI_H

#include "Module.h"
#include "Button.h"

class ModuleTopGUI : public Module
{
private:
	//BITMAP *img_aux;
	//BITMAP *canvas;
	BITMAP *img_gauges;
	BITMAP *img_fuel_gauge;
	BITMAP *img_hull_gauge;
	BITMAP *img_shield_gauge;
	BITMAP *img_armor_gauge;
	//Button* btn_inject_fuel;
public:
	ModuleTopGUI();
	~ModuleTopGUI();
	bool Init();
	void Update();
	void UpdateInjector();
	void Draw();
	void OnKeyPress( int keyCode );
	void OnKeyPressed(int keyCode);
	void OnKeyReleased(int keyCode);
	void OnMouseMove(int x, int y);
	void OnMouseClick(int button, int x, int y);
	void OnMousePressed(int button, int x, int y);
	void OnMouseReleased(int button, int x, int y);
	void OnMouseWheelUp(int x, int y);
	void OnMouseWheelDown(int x, int y);
	void OnEvent(Event *event);
	void Close();
};

#endif
