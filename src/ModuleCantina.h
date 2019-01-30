/*
	STARFLIGHT - THE LOST COLONY
	ModuleCrewHire.h - ?
	Author: ?
	Date: 9/21/07
*/

#ifndef MODULECANTINA_H
#define MODULECANTINA_H

#include "env.h"
#include <allegro.h>
#include "Module.h"
#include "GameState.h"
#include "Button.h"
#include "ScrollBox.h"
#include "EventMgr.h"
#include "Label.h"

class ModuleCantina : public Module
{
public:
	ModuleCantina();
	virtual ~ModuleCantina();
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
	BITMAP 					*m_background;
	Button 					*m_exitBtn;
	Button 					*m_turninBtn;

	Label *questTitle;
	Label *questLong;
	Label *questDetails;
	Label *questReward;

	std::string label1, label2, label3, label4;
	int labelcolor, textcolor;
	bool selectedQuestCompleted;
	std::string requirementLabel;
	int requirementColor;

};

#endif
