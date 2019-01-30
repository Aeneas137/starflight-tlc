#ifndef MODULECAPTAINCREATION_H
#define MODULECAPTAINCREATION_H
#pragma once

#include "env.h"
#include <allegro.h>
#include <alfont.h>
#include <fmod.hpp>
#include "Module.h"
#include "GameState.h"
#include "AudioSystem.h"

class Button;
class Label;

class ModuleCaptainCreation : public Module
{
public:
	ModuleCaptainCreation(void);
	virtual ~ModuleCaptainCreation(void);
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

	void chooseFreelance();
	void chooseMilitary();
	void chooseScience();
	
	typedef enum
	{
		WP_NONE = 0,
		WP_PROFESSION_CHOICE = 1,
		WP_DETAILS = 2
	} WizPage;

	WizPage			m_wizPage;

	BITMAP			*m_professionChoiceBackground;
	
	BITMAP 			*m_scientificBtn;
	BITMAP 			*m_scientificBtnMouseOver;
	BITMAP 			*m_freelanceBtn;
	BITMAP 			*m_freelanceBtnMouseOver;
	BITMAP 			*m_militaryBtn;
	BITMAP 			*m_militaryBtnMouseOver;

	Label 			*m_profInfoScientific;
	Label 			*m_profInfoFreelance;
	Label 			*m_profInfoMilitary;

	Label 			*m_profInfoBox;

	BITMAP 			*m_detailsBackground;

	BITMAP 			*m_plusBtn;
	BITMAP 			*m_plusBtnMouseOver;

	BITMAP 			*m_resetBtn;
	BITMAP 			*m_resetBtnMouseOver;

	Button			*m_finishBtn;

	BITMAP			*m_cursor[2];
	int				m_cursorIdx;
	int				m_cursorIdxDelay;

	BITMAP			*m_backBtn;
	BITMAP			*m_backBtnMouseOver;

	BITMAP			*m_mouseOverImg;
	int				m_mouseOverImgX;
	int				m_mouseOverImgY;

	Sample *m_sndBtnClick;
	Sample *m_sndClick;
	Sample *m_sndErr;

	// in progress captain vars; once finished with creation, these
	// get stored to the game state
	ProfessionType	m_profession;
	std::string		m_name;
	Attributes		m_attributes;

	// intermediate captain vars used while creating the captain
	Attributes		m_attributesMax;
	Attributes		m_attributesInitial;
	int				m_availPts;
	int				m_availProfPts;

	Button*			m_minusBtns[8];
};

#endif

