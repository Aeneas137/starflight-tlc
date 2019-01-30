/*
	STARFLIGHT - THE LOST COLONY
	ModuleStarmap.h - The Starmap module.
	Author: Keith "Daikaze" Patch
	Date: ??-??-2007
*/	

#ifndef MODULESTARMAP_H
#define MODULESTARMAP_H

#include "Module.h"
#include "Sprite.h"
#include "Flux.h"
#include "Label.h"
#include "DataMgr.h"

class ModuleStarmap : public Module
{
public:
	ModuleStarmap();
	virtual ~ModuleStarmap();
	virtual bool Init();
	void Update();
	virtual void Draw();
	virtual void OnKeyPress( int keyCode );
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
	bool map_active, dest_active, m_bOver_Star;
	float FUEL_PER_UNIT, ratioX, ratioY;
	int	 VIEWER_WIDTH,
		 VIEWER_HEIGHT,
		 MAP_WIDTH,
		 MAP_HEIGHT,
		 X_OFFSET,
		 Y_OFFSET,
		 MAP_POS_X,
		 MAP_POS_Y,
		 VIEWER_TARGET_OFFSET,
		 VIEWER_MOVE_RATE,
		 viewer_offset_y;

	Sprite *stars;
	BITMAP *starview;
	BITMAP *gui_starmap;
	BITMAP *text;
	BITMAP *flux_view;

	Point2D cursorPos;
	Point2D m_destPos;

	Label* star_label;
	CoordValue star_x;
	CoordValue star_y;
};

#endif
