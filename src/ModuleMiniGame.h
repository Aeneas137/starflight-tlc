/*
	STARFLIGHT - THE LOST COLONY
	ModuleMiniGame.h
	Author: J.Harbour
	Date: Jan, 2008
*/

#ifndef _MINIGAME_H
#define _MINIGAME_H

#include "env.h"
#include <allegro.h>
#include "Module.h"

class ModuleMiniGame : public Module
{
private:
	~ModuleMiniGame(void);

	BITMAP *window;

public:
	ModuleMiniGame(void);
	bool Init();
	void Update();
	void Draw();
	void Draw3D();
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
};

#endif
