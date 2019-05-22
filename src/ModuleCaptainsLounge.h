#ifndef MODULECAPTAINSLOUNGE_H
#define MODULECAPTAINSLOUNGE_H
#pragma once

#include "env.h"
#include <allegro.h>
#include <alfont.h>
#include <fmod.hpp>
#include "Module.h"
#include "AudioSystem.h"

class Button;

#include <vector>

#define CAPTAINSLOUNGE_NUMSLOTS 5

class ModuleCaptainsLounge : public Module{
public:
	ModuleCaptainsLounge(void);
	virtual ~ModuleCaptainsLounge(void);
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
	virtual void OnMouseWheelUp(int x, int y);
	virtual void OnMouseWheelDown(int x, int y);
	virtual void OnEvent(Event *event);
	virtual void Close();

private:
	BITMAP						*m_background;
	BITMAP                  *m_modalPromptBackground;

	Sample *m_sndBtnClick;

	Button						*m_backBtn;
    Button                      *m_launchBtn;
	Button 						*m_newCaptBtns[CAPTAINSLOUNGE_NUMSLOTS];
	Button 						*m_delCaptBtns[CAPTAINSLOUNGE_NUMSLOTS];
	Button 						*m_selCaptBtns[CAPTAINSLOUNGE_NUMSLOTS];
	Button 						*m_saveCaptBtns[CAPTAINSLOUNGE_NUMSLOTS];

	GameState					*m_games[CAPTAINSLOUNGE_NUMSLOTS];	
	Button						*m_yesBtn;
	Button						*m_noBtn;

	bool						m_requestedCaptainCreation;
	int							m_requestedCaptainCreationSlotNum;

	bool						m_modalPromptActive;
	std::vector<std::string>	m_modalPromptStrings;
	int							m_modalPromptYesEvent;
	int							m_modalPromptNoEvent;
	int							m_modalPromptSlotNum;

	void LoadGames();

	long frozenTimeStamp;
	bool displayHelp; 
	// If the player has at least one saved game file, then the tutorial message will 
	// not display in ModuleCaptainsLounge when the player goes to load a saved game. 
};

#endif

