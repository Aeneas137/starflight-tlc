#pragma once

#include "env.h"
#include <allegro.h>
#include "Module.h"
#include "Stardate.h"
#include "Button.h"
#include "Events.h"
#include "ModeMgr.h"
#include "GameState.h"
#include "Game.h"

/*
current problem is that the default button has some overlapping problems
It isn't showing up, or if the order is changed another button doesn't show.
*/
class ModuleSettings : public Module
{
public:
	ModuleSettings(void);
	virtual ~ModuleSettings(void);
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
    bool SaveConfigurationFile();

private:
	BITMAP	*background;
	Button	*btn_exit,
            *btn_fullscreen,
			*btn_controls[11],
			*btn_defaults,
			*btn_save;

    ScrollBox::ScrollBox *resScrollbox;
    std::string chosenResolution;
	int cmd_selected, button_selected;
};
