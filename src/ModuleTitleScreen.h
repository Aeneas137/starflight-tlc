/*
	STARFLIGHT - THE LOST COLONY
	ModuleTitleScreen.h - 
	Author: J.Harbour
	Date: Dec,2007
*/
 
#ifndef MODULETITLESCREEN_H
#define MODULETITLESCREEN_H

#include "env.h"
#include "Module.h"

class Button;

class ModuleTitleScreen : public Module
{
public:
	ModuleTitleScreen();
	virtual ~ModuleTitleScreen();

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
	void OnEvent(Event *event);
	void Close();

private:
	float m_rotationAngle;
	BITMAP *m_background;
	Button *btnTitle;
	Button *btnNewGame;
	Button *btnLoadGame;
	Button *btnSettings;
	Button *btnCredits;
	Button *btnQuit;
	int title_mode;


};

#endif
