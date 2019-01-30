
#include "Label.h"
#include "GameState.h"
#include "Game.h"
#include "Util.h"

//Label::Label(std::string Text, int X, int Y, int Width, int Height) :
//	text(Text),
//	xPos(X),
//	yPos(Y),
//	width(Width),
//	height(Height)
//{
//	alFont = Game::gameState->font;
//	image = create_bitmap(Width, Height);
//}

Label::Label(std::string Text, int X, int Y, int Width, int Height, int Color, ALFONT_FONT *Font) :
	text(Text),
	xPos(X),
	yPos(Y),
	width(Width),
	height(Height),
	color(Color),
	alFont(Font)
{
	image = create_bitmap(Width, Height);
}

Label::~Label()
{
	if (image != NULL)
	{
		destroy_bitmap(image);
		image = NULL;
	}
}

void Label::Refresh()
{
	clear_to_color(image, makecol(255,0,255));

    //handle wrapping
	if (alfont_text_length(alFont, text.c_str()) > width)
	{
		int startpos = 0, a = 0, h = 0;
		std::list<int> spacePos;
		std::string::iterator stringIt;
		for (stringIt = text.begin(); stringIt != text.end(); stringIt++)
		{
			if ((*stringIt) == ' ')
				spacePos.push_back(a);
			a++;
		}
		spacePos.push_back(a);
		std::list<int>::iterator myIt = spacePos.begin();
		while (myIt != spacePos.end())
		{
			while (myIt != spacePos.end() && alfont_text_length(alFont, text.substr(startpos, (*myIt) - startpos).c_str()) < width)
			{
				myIt++;
			}
			if (myIt != spacePos.begin())
				myIt--;

			alfont_textprintf_ex(image, alFont, 0, h, color,-1,(text.substr(startpos, (*myIt) - startpos)).c_str());
			h += alfont_get_font_height(alFont);
			
			if (h > height) break;

			startpos = (*myIt)+1;
			myIt++;
		}
	}
	else
	{
        //print entire message on one line
		alfont_textprintf_ex(image, alFont, 0, 0, color, -1, text.c_str());
	}
}

void Label::Draw(BITMAP *Canvas)
{
	draw_sprite(Canvas, image, xPos, yPos);
}

void Label::SetWidth(int Width)
{
	width = Width;
}

void Label::SetHeight(int Height)
{
	height = Height;
}

void Label::SetColor(int Color)
{
	color = Color;
}

void Label::SetText(std::string Text)
{
	text = Text;
}

void Label::SetFont(ALFONT_FONT *Font)
{
	alFont = Font;
}

void Label::Append(double Value, int Size)
{
	text += Util::ToString((int)Value);
}

void Label::Append(int Value, int Size)
{
	text += Util::ToString(Value);
}

void Label::Append(float Value, int Size)
{
	text += Util::ToString((int)Value);
}

