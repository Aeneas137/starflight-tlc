/*
	STARFLIGHT - THE LOST COLONY
	ModuleAuxiliaryWindow.cpp 
	Author: J.Harbour
	Date: Jan 2008
*/	

#ifndef _MODULEAUXILIARYDISPLAY_H
#define _MODULEAUXILIARYDISPLAY_H

#include "Module.h"
#include "TileScroller.h"

class ModuleAuxiliaryDisplay : public Module
{
private:
	int gax,gay,asx,asy,asw,ash;

	int cargoFillPercent;

	BITMAP *ship_icon_image;
	Sprite *ship_icon_sprite;
	BITMAP *img_aux;
	BITMAP *canvas;
	TileScroller* scroller;
	void medical_display(Officer* officer_data, int x, int y, std::string additional_data);
	void DrawBackground();
	void DrawContent();

public:
	ModuleAuxiliaryDisplay();
	~ModuleAuxiliaryDisplay();
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

	void init_nav();
	void updateCrew();
	void updateAll();
	void updateCap();
	void updateSci();
	void updateNav();
	void updateEng();
	void updateCom();
	void updateTac();
	void updateMed();
	void updateCargoFillPercent();
	void place_flux_tile(bool visible, int tile);
    void PrintSystemStatus(int x,int y,int value);

   	int HEADING_COLOR;


};

#endif
