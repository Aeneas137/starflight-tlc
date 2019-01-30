/*
	File:			MiniWindow.h
	Programmer:		Matt Klausmeier
	Date:			10/8/07
	Modified:		12/27/07
	Description:	This class represents a small sub-window that is drawn to your screen/buffer.  
	Pass it the corner, side, and interior bitmaps and the class automatically creates a border 
	around the MiniWindow. To work properly, all three tile bitmaps must be the same size and
	the whole window must be evenly divisible by the tile size. When you create a new MiniWindow,
	for the width and height pass a multiple of the tile size rather than a specific value.
	(e.g. 24*12, 24*10, to create a window that's 12x10 tiles in size).
*/

#ifndef _MINIWINDOW_H
#define _MINIWINDOW_H 1

#include "env.h"
#include "allegro.h"
#include <string>

class MiniWindow
{
private: 
	int mwY;
	int mwX;
	int mwWidth;
	int mwHeight;
	BITMAP *mwCorner;
	BITMAP *mwSide;
	BITMAP *mwInterior;
	PALETTE mwPalette;
public: 
	MiniWindow();
	MiniWindow(int width, int height);
	MiniWindow(int x, int y, int width, int height);
	MiniWindow(int x, int y, int width, int height, std::string cornerFilename, std::string sideFilename, std::string interiorFilename);
	virtual ~MiniWindow() { }
	void LoadCornerImage(std::string filename);
	void LoadSideImage(std::string filename);
	void LoadInteriorImage(std::string filename);
	void SetPos(int x, int y);
	void SetDimensions(int width, int height);
	void Draw(BITMAP *destination);
	void Draw(BITMAP *destination, int x, int y);
};

#endif
