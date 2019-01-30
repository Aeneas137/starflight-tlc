/*
	STARFLIGHT - THE LOST COLONY
	ModuleMessageGUI.cpp 
	Author: 
	Date: 
*/	

#ifndef _ModuleMessageGUI_H
#define _ModuleMessageGUI_H

#include "Module.h"
#include "Button.h"

class ModuleMessageGUI : public Module
{
private:
	BITMAP *img_message;
	BITMAP *img_socket;

	DATAFILE *data;

public:
	ModuleMessageGUI();
	~ModuleMessageGUI();
	bool Init();
	void Update();
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
