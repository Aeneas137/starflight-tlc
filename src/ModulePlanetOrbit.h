/*
	STARFLIGHT - THE LOST COLONY
	ModulePlanetOrbit.h - Handles planet orbiting
	Author: J.Harbour
	Date: March, 2007
*/

#ifndef _PLANETORBIT_H
#define _PLANETORBIT_H

#include "env.h"
#include <allegro.h>
#include "ScrollBox.h"
#include "Module.h"
#include "DataMgr.h"
#include "AudioSystem.h"
#include "TexturedSphere.h"

const int HOMEWORLD_ID = 8;

class ModulePlanetOrbit : public Module
{
private:
	~ModulePlanetOrbit(void);

	bool CreatePlanetTexture();
	
	//BITMAP *img_viewer;
	BITMAP *background;
    Sample *audio_scan;

	//shortcuts to crew last names to simplify code
	std::string com;
	std::string sci;
	std::string nav;
	std::string tac;
	std::string eng;
	std::string doc;

	ScrollBox::ScrollBox *text;

	int gui_viewer_x;
	int gui_viewer_y;
	int gui_viewer_dir;
	bool gui_viewer_sliding;

	int planetScan;
	int planetAnalysis;

	PlanetType planetType;
	Planet *planet;

    BITMAP *lightmap_overlay;

    TexturedSphere *texsphere;


public:
	ModulePlanetOrbit(void);
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

	void doorbit();
	void dosurface();
	void scanplanet();
	void analyzeplanet();
};

#endif
