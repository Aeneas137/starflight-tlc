#include "env.h"
#include "allegro.h"
#include "MiniWindow.h"


MiniWindow::MiniWindow() 
{
	SetPos(0,0);
	SetDimensions(200, 100);
	mwCorner = NULL;
	mwSide = NULL;
	mwInterior = NULL;
}

MiniWindow::MiniWindow(int width, int height) 
{
	SetPos(0,0);
	SetDimensions(width, height);
	mwCorner = NULL;
	mwSide = NULL;
	mwInterior = NULL;
}

MiniWindow::MiniWindow(int x, int y, int width, int height) 
{
	SetPos(x,y);
	SetDimensions(width, height);
	mwCorner = NULL;
	mwSide = NULL;
	mwInterior = NULL;
}

MiniWindow::MiniWindow(int x, int y, int width, int height, std::string cornerFilename, std::string sideFilename, std::string interiorFilename) 
{
	SetPos(x,y);
	SetDimensions(width, height);
	LoadCornerImage(cornerFilename.c_str());
	LoadSideImage(sideFilename.c_str());
	LoadInteriorImage(interiorFilename.c_str());
}

void MiniWindow::LoadCornerImage(std::string filename) 
{ 
	mwCorner = load_bitmap(filename.c_str(), mwPalette); 
}

void MiniWindow::LoadSideImage(std::string filename) 
{ 
	mwSide = load_bitmap(filename.c_str(), mwPalette); 
}

void MiniWindow::LoadInteriorImage(std::string filename)
{
	mwInterior = load_bitmap(filename.c_str(), mwPalette);
}

void MiniWindow::SetPos(int x, int y) 
{ 
	mwX = x; 
	mwY = y; 
}

void MiniWindow::SetDimensions(int width, int height) 
{ 
	mwWidth = width; 
	mwHeight = height; 
}


//Draws the box at the stored x/y position
void MiniWindow::Draw(BITMAP *destination)
{
	Draw(destination, mwX, mwY);
}

//Draws the box at the specified x/y position
void MiniWindow::Draw(BITMAP *destination, int x, int y)
{
	int PINK = makecol(255,0,255);
	if (mwCorner == NULL || mwSide == NULL || mwInterior == NULL)
	{
		textout_ex(destination, font, "Bitmaps not established", x, y, PINK, 01);
		return;
	}

	//create scratch pad
	BITMAP *buffer = create_bitmap(mwWidth, mwHeight);
	clear_to_color(buffer, PINK);
	
	//draw top/bottom sides
	for (int a = mwCorner->w; a < mwWidth; a += mwSide->w)
	{
		draw_sprite(buffer, mwSide, a, 0);
		draw_sprite_v_flip(buffer, mwSide, a, mwHeight - mwSide->h);
	}

	//draw left/right sides
	for (int a = mwCorner->h; a < mwHeight; a += mwSide->h)
	{
		rotate_sprite(buffer, mwSide, 0, a, itofix(-64));
		rotate_sprite(buffer, mwSide, mwWidth - mwSide->w, a, itofix(64));
	}
	
	//upper left corner
	rectfill(buffer, 0, 0, mwCorner->w-1, mwCorner->h-1, PINK);
	draw_sprite(buffer, mwCorner, 0, 0);
	
	//upper right corner
	rectfill(buffer, mwWidth - mwCorner->w, 0, mwWidth-1, mwCorner->h-1, PINK);
	draw_sprite_h_flip(buffer, mwCorner, mwWidth - mwCorner->w, 0);
	//rotate_sprite(buffer, mwCorner, mwWidth - mwCorner->h, 0, itofix(64));
	
	//lower left corner
	rectfill(buffer, 0,  mwHeight - mwCorner->w, mwCorner->h-1, mwHeight-1, PINK);
	//rotate_sprite(buffer, mwCorner, 0, mwHeight - mwCorner->h, itofix(192));
	draw_sprite_v_flip(buffer, mwCorner, 0, mwHeight - mwCorner->h);
	
	//lower right corner
	rectfill(buffer, mwWidth - mwCorner->w, 0 + mwHeight - mwCorner->h, mwWidth-1, mwHeight-1, PINK);
	//rotate_sprite(buffer, mwCorner, mwWidth - mwCorner->w, mwHeight - mwCorner->h, itofix(128));
	draw_sprite_vh_flip(buffer, mwCorner, mwWidth - mwCorner->w, mwHeight - mwCorner->h);

	//draw interior tiles
	for (int a = mwSide->w; a < mwWidth - mwSide->w; a += mwInterior->w)
	{
		for (int b = mwSide->h; b < mwHeight - mwSide->h; b += mwInterior->h)
		{
			draw_sprite(buffer, mwInterior, a, b);
		}
	}



	//draw scratchpad to destination
	draw_sprite(destination, buffer, x, y);
	
	//delete scratchpad
	destroy_bitmap(buffer);
}
