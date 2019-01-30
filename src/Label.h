#pragma once

#include "env.h"
#include <allegro.h>
#include <string>
#include <alfont.h>
#include <vector>
#include <list>

class Label
{
public:
	//Label(std::string Text, int X, int Y, int Width, int Height);
	Label(std::string Text, int X, int Y, int Width, int Height, int Color, ALFONT_FONT *Font);

	~Label();

	void Refresh();
	void Draw(BITMAP *Canvas);

	//accessors
	int GetX()							const { return xPos; }
	int GetY()							const { return yPos; }
	int GetWidth()						const { return width; }
	int GetHeight()						const { return height; }
	int GetColor()						const { return color; }
	std::string GetText()				const { return text; }
	ALFONT_FONT* GetFont()				const { return alFont; }
	
	//mutators
	void SetX(int X)					{ xPos = X; }
	void SetY(int Y)					{ yPos = Y; }
	void Append(std::string Text)		{ text += Text; }
	void Append(double Value, int Size);
	void Append(int Value, int Size);
	void Append(float Value, int Size);


	//These are in the cpp so they may be easily changed to automatically call the Refresh function when used
	void SetWidth(int Width);
	void SetHeight(int Height);
	void SetColor(int Color);
	void SetText(std::string Text);
	void SetFont(ALFONT_FONT *Font);


protected:
	


private: 

	int					xPos;
	int					yPos;
	int					width;
	int					height;
	int					color;
	std::string			text;
	ALFONT_FONT			*alFont;
	BITMAP				*image;


};
