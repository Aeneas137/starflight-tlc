/*
	STARFLIGHT - THE LOST COLONY
	ModuleGameOver.h 
	Date: October, 2007
*/

#ifndef GAMEOVER_H
#define GAMEOVER_H

#include "env.h"
#include <allegro.h>
#include <alfont.h>
#include "Module.h"

class ModuleGameOver : public Module
{
private:

public:
	ModuleGameOver(void);
	~ModuleGameOver(void);
	bool Init();
	void Update();
	void Draw();
	void OnKeyPress(int keyCode);
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

	bool bQuickShutdown;
};

#endif
