/*
	STARFLIGHT - THE LOST COLONY
	ModuleMedical.cpp 
	Author: Keith Patch
	Date: April 2008
*/	

#ifndef _MODULEMEDICAL_H
#define _MODULEMEDICAL_H

#include "Module.h"
#include "Button.h"
#include "GameState.h"

class ModuleMedical : public Module
{
private:
	BITMAP* img_right_viewer;
	BITMAP* img_right_bg;
	BITMAP* img_left_viewer; //shows stat bars for examining officers
	BITMAP* img_left_viewer2; //shows health readout.
	BITMAP* img_left_bg;
	BITMAP	*img_health_bar,  *img_science_bar,  *img_nav_bar, 
			*img_medical_bar, *img_engineer_bar, *img_dur_bar, 
			*img_learn_bar,   *img_comm_bar,	 *img_tac_bar;
	BITMAP *img_button_crew, *img_button_crew_hov, *img_button_crew_dis;
	BITMAP *img_treat, *img_treat_hov, *img_treat_dis;
	bool viewer_active, b_examine;
	Button*	HealBtns[7];
	Button* OfficerBtns[7];

	Officer* selected_officer;

	void disable_others(int officer);
	void cease_healing();
public:
	ModuleMedical();
	~ModuleMedical();
	bool Init();
	void Update();
	void MedicalUpdate();
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
