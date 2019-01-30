#include "env.h"
#include "Game.h"
#include "Events.h"
#include "ScrollBox.h"
#include "ModeMgr.h"

ScrollBox::ScrollBox::ScrollBox(ALFONT_FONT *Font, ScrollBoxType initScrollBoxType, 
    int X, int Y,	int Width, int Height, int EventID) :
		sbScrollBoxType(initScrollBoxType),
		sbX(X),
		sbY(Y),
		sbWidth(Width),
		sbHeight(Height),
		sbFont(Font),
		sbLines(20),
		sbNormal(NULL),
		sbHover(NULL),
		sbSelected(NULL),
		sbScrollBar(NULL),
		sbStickToBottom(true),
		sbSelectedItem(-1),
		sbScrollSpeed(5),
		sbCurrentLine(0),
		sbDragging(false),
		sbDrawBar(true),
		sbIsOverUp(false),
		sbIsOverDown(false),
		sbIsOverBar(false),
		sbWindowClipY(0),
		sbListItemSelected(false),
		sbLinkedBox(NULL),
		sbParent(NULL),
		sbLeftPad(0),
		sbTopPad(0),
		sbRedraw(true),
		sbHighlight(false),
		eventID(EventID)
{
	sbUpRect = AREA(Width - 16, 0, Width-1, 15);
	sbDownRect = AREA(Width - 16, Height - 16, Width-1, Height-1);
	sbScrollRect = AREA(Width - 16, 16, Width-1, 31);
	sbTrackRect = AREA(Width - 16, 0, Width-1, Height-1);
	sbScrollAreaRect = AREA(sbUpRect.left, sbUpRect.top, sbDownRect.right, sbDownRect.bottom);
	sbTextAreaRect = AREA(0, 0, Width - 16, Height);
	sbTextAreaWidth = sbWidth - 16;
	sbScrollBarPos = sbScrollRect.top;
	sbScrollBarMin = sbScrollRect.top;
	sbScrollBarMax = Height - (sbDownRect.bottom - sbDownRect.top) - (sbScrollRect.bottom - sbScrollRect.top) - 2;
	sbScrollBarHeight = sbScrollRect.bottom - sbScrollRect.top;
	sbScrollStart = sbScrollBarPos;
	sbFontHeight = alfont_text_height(sbFont);
	if (sbLines * sbFontHeight < sbHeight)
		sbBuffer = create_bitmap(sbWidth, sbHeight);
	else
		sbBuffer = create_bitmap(sbWidth, sbLines * sbFontHeight);

    ColorControls = makecol(64, 64, 64);
	ColorBackground = makecol(32, 32, 32);
	ColorHover = makecol(128, 128, 128);
	ColorSelectedHighlight = makecol(64, 64, 128);
	ColorSelectedBackground = makecol(32, 32, 64);

	sbScrollIncrement = (float)((sbLines * sbFontHeight)-sbHeight) / (sbScrollBarMax - sbScrollBarMin);

	if (sbScrollBoxType == SB_LIST)
	{
		sbNormal = create_bitmap(sbWidth - 16, sbFontHeight);
		sbHover = create_bitmap(sbWidth - 16, sbFontHeight);
		sbSelected = create_bitmap(sbWidth - 16, sbFontHeight);
        PaintNormalImage();
        PaintHoverImage();
        PaintSelectedImage();
		ListBoxItem tempLBI;
		tempLBI.bHover = sbHover;
		tempLBI.bNormal = sbNormal;
		tempLBI.bSelected = sbSelected;
		tempLBI.selected = false;
		tempLBI.hover = false;
		tempLBI.text.String = "";
		tempLBI.text.Color = makecol(0,0,0);
		for (int a = 0; a < sbLines; a++)
		{
			sbListBoxItems.push_back(tempLBI);
		}
	}
	else if (sbScrollBoxType == SB_TEXT)
	{
		ColoredString temp;
		temp.Color = makecol(0, 0, 0);
		temp.String = "";
		for (int a = 0; a < sbLines; a++)
		{
			sbTextLines.push_front(temp);
		}
	}
}

void ScrollBox::ScrollBox::PaintNormalImage()
{
    clear_bitmap(sbNormal);
	rect(sbNormal, 0, 0, sbNormal->w-1, sbNormal->h-1, ColorItemBorder);
	rectfill(sbNormal, 1, 1, sbNormal->w - 2, sbNormal->h - 2, ColorBackground);
}

void ScrollBox::ScrollBox::PaintHoverImage()
{
    clear_bitmap(sbHover);
	rect(sbHover, 0, 0, sbHover->w-1, sbHover->h-1, ColorItemBorder);
	rectfill(sbHover, 1, 1, sbHover->w - 2, sbHover->h - 2, ColorControls);
}

void ScrollBox::ScrollBox::PaintSelectedImage()
{
    clear_bitmap(sbSelected);
	rect(sbSelected, 0, 0, sbSelected->w-1, sbSelected->h-1, ColorSelectedHighlight);
	rectfill(sbSelected, 1, 1, sbSelected->w - 2, sbSelected->h - 2, ColorSelectedBackground);
}

ScrollBox::ScrollBox::~ScrollBox()
{
	sbTextLines.clear();
	sbListBoxItems.clear();

	if (sbLinkedBox != NULL)
	{
		delete sbLinkedBox;
		sbLinkedBox = NULL;
	}
	if (sbNormal != NULL)
	{
		destroy_bitmap(sbNormal);
		sbNormal = NULL;
	}
	if (sbHover != NULL)
	{
		destroy_bitmap(sbHover);
		sbHover = NULL;
	}
	if (sbSelected != NULL)
	{
		destroy_bitmap(sbSelected);
		sbSelected = NULL;
	}
	if (sbScrollBar != 0)
	{
		destroy_bitmap(sbScrollBar);
		sbScrollBar = NULL;
	}
	if (sbBuffer != 0)
	{
		destroy_bitmap(sbBuffer);
		sbBuffer = NULL;
	}
}


std::string ScrollBox::ScrollBox::GetSelectedItem()
{
    std::string text="";
	for(std::list<ListBoxItem>::iterator myIt = sbListBoxItems.begin(); myIt != sbListBoxItems.end(); myIt++)
	{
		if ((*myIt).selected)
		{
            text = (*myIt).text.String;
            break;
        }
    }
    return text;
}

void ScrollBox::ScrollBox::Draw(BITMAP *buffer)
{
	if (sbLinkedBox != NULL)
		sbLinkedBox->Draw(buffer);
	//Draw strings
	if (sbRedraw)
	{
		//Clear buffer
		clear_to_color(sbBuffer, BLACK);
		int a = 0;
		if (sbScrollBoxType == SB_TEXT)
		{
			for(std::list<ColoredString>::iterator myIt = sbTextLines.begin(); myIt != sbTextLines.end(); myIt++)
			{
				alfont_textprintf_ex(sbBuffer, sbFont, sbLeftPad, sbFontHeight * a + sbTopPad, 
                    (*myIt).Color,-1,(*myIt).String.c_str());
				a++;
			}
		}
		else if (sbScrollBoxType == SB_LIST)
		{
            int color;
			for(std::list<ListBoxItem>::iterator myIt = sbListBoxItems.begin(); myIt != sbListBoxItems.end(); myIt++)
			{
				if ((*myIt).selected)
                {
					blit((*myIt).bSelected, sbBuffer, 0, 0, 0, sbFontHeight * a, sbWidth, sbHeight);
                    color = ColorSelectedText;
                }
				else if ((*myIt).hover)
                {
					blit((*myIt).bHover, sbBuffer, 0, 0, 0, sbFontHeight * a, sbWidth, sbHeight);
                    color = (*myIt).text.Color;
                }
				else
                {
					blit((*myIt).bNormal, sbBuffer, 0, 0, 0, sbFontHeight * a, sbWidth, sbHeight);
                    color = (*myIt).text.Color;
                }

				alfont_textprintf_ex(sbBuffer, sbFont, sbLeftPad, sbFontHeight * a + sbTopPad, 
                    color,-1,(*myIt).text.String.c_str());
				a++;
			}
		}
		sbRedraw = false;
	}
	//Draw buffer to screen
	blit(sbBuffer, buffer, 0, sbWindowClipY, sbX, sbY, sbWidth - 16, sbHeight);
	//Draw buttons to buffer
	if (sbDrawBar)
	{
		drawTrack(buffer);
		drawUpArrow(buffer);
		drawDownArrow(buffer);
		drawScrollBar(buffer);
	}
}

void ScrollBox::ScrollBox::OnMouseClick(int button, int x, int y)
{
	if (sbLinkedBox != NULL)
		sbLinkedBox->OnMouseClick(button, x, y);
	if (isInsideOffset(x, y, sbUpRect) && sbScrollBarPos > sbScrollBarMin)
	{
		sbScrollBarPos--;
		sbScrollRect.top = sbScrollBarPos;
		sbScrollRect.bottom = sbScrollRect.top + sbScrollBarHeight;
		sbWindowClipY = sbScrollIncrement * ((100 * (sbScrollBarPos-sbUpRect.bottom)) / (sbScrollBarMax-sbUpRect.bottom));
		sbRedraw = true;
	}
	else if (isInsideOffset(x, y, sbDownRect) && sbScrollBarPos < sbScrollBarMax)
	{
		sbScrollBarPos++;
		sbScrollRect.top = sbScrollBarPos;
		sbScrollRect.bottom = sbScrollRect.top + sbScrollBarHeight;
		sbWindowClipY = sbScrollIncrement * ((100 * (sbScrollBarPos-sbUpRect.bottom)) / (sbScrollBarMax-sbUpRect.bottom));
		sbRedraw = true;
	}
	else if (sbScrollBoxType == SB_LIST)
	{
		int clickedIndex = (sbWindowClipY + y - sbY)/sbFontHeight;
		bool insideScrollBox = false;
		if (isInsideOffset(x, y, sbTextAreaRect) && !isInsideOffset(x, y, sbScrollAreaRect))
		{
			insideScrollBox = true;
			sbRedraw = true;
		}
		int a = 0;

		/*
		 * Converted to a while because items can be removed from the list in mid-loop by other processes
		 * causing an assert crash.
		 */
		//for(std::list<ListBoxItem>::iterator myIt = sbListBoxItems.begin(); myIt != sbListBoxItems.end(); myIt++)
		std::list<ListBoxItem>::iterator myIt = sbListBoxItems.begin();
		while ( myIt != sbListBoxItems.end() )
		{
			if (insideScrollBox && clickedIndex == a)
			{
				if((*myIt).selected)//if the one we clicked on is already selected...
				{
					//...deselect it
					(*myIt).selected = false;
					sbListItemSelected = false;
					sbSelectedItem = -1;
					Event e(eventID);
					Game::modeMgr->BroadcastEvent(&e);
					break;
				}
				else//if the one we clicked on isn't selected
				{
					(*myIt).selected = true;
					if (sbListItemSelected)
					{
						int holder = a;
						if (sbSelectedItem > a)
						{
							while (sbSelectedItem > a)
							{
								myIt++;
								a++;
							}
							(*myIt).selected = false;
						}
						else
						{
							while (sbSelectedItem < a)
							{
								myIt--;
								a--;
							}
							(*myIt).selected = false;
						}
						a = holder;
					}
					sbSelectedItem = a;
					sbListItemSelected = true;
					Event e(eventID);
					Game::modeMgr->BroadcastEvent(&e);
					break;
				}
			}

			//a is the selected item
			a++;

			//go to next item in list
			myIt++;
		}
	}
}

void ScrollBox::ScrollBox::OnMouseMove(int x, int y)
{
	mouseX = x;
	mouseY = y;
	if (sbLinkedBox != NULL)
		sbLinkedBox->OnMouseMove(x, y);
	if (isInsideOffset(x, y, sbUpRect))
	{
		if (!sbIsOverUp)
		{
			sbIsOverUp = true;
			sbRedraw = true;
		}
	}
	else
	{
		if (sbIsOverUp)
		{
			sbIsOverUp = false;
			sbRedraw = true;
		}
	}
	if (isInsideOffset(x, y, sbDownRect))
	{
		if (!sbIsOverDown)
		{
			sbIsOverDown = true;
			sbRedraw = true;
		}
	}
	else
	{
		if (sbIsOverDown)
		{
			sbIsOverDown = false;
			sbRedraw = true;
		}
	}
	if (isInsideOffset(x, y, sbScrollRect))
	{
		if (!sbIsOverBar)
		{
			sbIsOverBar = true;
			sbRedraw = true;
		}
	}
	else
	{
		if (sbIsOverBar)
		{
			sbIsOverBar = false;
			sbRedraw = true;
		}
	}

	if (sbScrollBoxType == SB_LIST)
	{
		int temp = (sbWindowClipY + y - sbY)/sbFontHeight;
		bool temp2 = false;
		if (isInsideOffset(x, y, sbTextAreaRect) && !isInsideOffset(x, y, sbScrollAreaRect))
		{
			temp2 = true;
			sbRedraw = true;
			sbHighlight = true;
		}
		int a = 0;
		for(std::list<ListBoxItem>::iterator myIt = sbListBoxItems.begin(); myIt != sbListBoxItems.end(); myIt++)
		{
			if (temp2 && temp == a)
			{
				(*myIt).hover = true;
				//if (sbParent)
				//	sbParent->setHover(a, true);
				//if (sbLinkedBox)
				//	sbLinkedBox->setHover(a, true);
			}
			else
			{
				(*myIt).hover = false;
				if (sbParent)
					sbParent->setHover(a, false);
				if (sbLinkedBox)
					sbLinkedBox->setHover(a, false);
			}
			a++;
		}
		if (sbHighlight && !temp2)
		{
			sbHighlight = false;
			sbRedraw = true;
		}
	}

	if (sbDragging)
	{
		sbScrollBarPos -= sbScrollStart - y;
		sbScrollStart = y;
		if (sbScrollBarPos < sbScrollBarMin)
			sbScrollBarPos = sbScrollBarMin;
		else if (sbScrollBarPos > sbScrollBarMax)
			sbScrollBarPos = sbScrollBarMax;
		sbScrollRect.top = sbScrollBarPos;
		sbScrollRect.bottom = sbScrollRect.top + sbScrollBarHeight;
		sbWindowClipY = sbScrollIncrement * (sbScrollBarPos-sbScrollBarMin);
		sbRedraw = true;
	}
}

void ScrollBox::ScrollBox::OnMousePressed(int button, int x, int y)
{
	if (sbLinkedBox != NULL)
		sbLinkedBox->OnMousePressed(button, x, y);

	//clicked scroll button?
	if (isInsideOffset(x, y, sbScrollRect))
	{
		sbScrollStart = y;
		sbDragging = true;
		sbRedraw = true;
		if (sbLinkedBox)
		{
			sbLinkedBox->sbScrollStart = y;
			sbLinkedBox->sbDragging = true;
			sbLinkedBox->sbRedraw = true;
		}
	}

}

void ScrollBox::ScrollBox::OnMouseReleased(int button, int x, int y)
{
	if (sbLinkedBox != NULL)
		sbLinkedBox->OnMouseReleased(button, x, y);
	sbDragging = false;
}

void ScrollBox::ScrollBox::OnMouseWheelDown(int x, int y)
{
	if (sbLinkedBox != NULL)
		sbLinkedBox->OnMouseWheelDown(x, y);

	//clicked scroll button?
	if (isInsideOffset(x, y, sbTextAreaRect))
	{
		sbScrollBarPos += 10;

		if (sbScrollBarPos < sbScrollBarMin) sbScrollBarPos = sbScrollBarMin;
		if (sbScrollBarPos > sbScrollBarMax) sbScrollBarPos = sbScrollBarMax;

		sbWindowClipY = sbScrollIncrement * (sbScrollBarPos-sbScrollBarMin);

		sbScrollRect.top = sbScrollBarPos;
		sbScrollRect.bottom = sbScrollRect.top + sbScrollBarHeight;

		if (sbLinkedBox)
		{
			sbLinkedBox->sbScrollBarPos = sbScrollBarPos;
			sbLinkedBox->sbWindowClipY = sbWindowClipY;
		}

		sbRedraw = true;
	}
}

void ScrollBox::ScrollBox::OnMouseWheelUp(int x, int y)
{
	if (sbLinkedBox != NULL)
		sbLinkedBox->OnMouseWheelUp(x, y);

	//clicked scroll button?
	if (isInsideOffset(x, y, sbTextAreaRect))
	{
		sbScrollBarPos -= 10;

		if (sbScrollBarPos < sbScrollBarMin) sbScrollBarPos = sbScrollBarMin;
		if (sbScrollBarPos > sbScrollBarMax) sbScrollBarPos = sbScrollBarMax;

		sbWindowClipY = sbScrollIncrement * (sbScrollBarPos-sbScrollBarMin);

		sbScrollRect.top = sbScrollBarPos;
		sbScrollRect.bottom = sbScrollRect.top + sbScrollBarHeight;

		if (sbLinkedBox)
		{
			sbLinkedBox->sbScrollBarPos = sbScrollBarPos;
			sbLinkedBox->sbWindowClipY = sbWindowClipY;
		}

		sbRedraw = true;
	}
}

bool ScrollBox::ScrollBox::isInside(int x, int y, AREA area)
{
	if (x >= area.left && x <= area.right && y >= area.top && y <= area.bottom)
		return true;
	else
		return false;
}

bool ScrollBox::ScrollBox::isInsideOffset(int x, int y, AREA area)
{
	if (sbLinkedBox)
	{
		x -= sbLinkedBox->getLinkedX();
		y -= sbLinkedBox->getLinkedY();
	}
	else
	{
		x -= sbX;
		y -= sbY;
	}
	if (x >= area.left && x <= area.right && y >= area.top && y <= area.bottom)
		return true;
	else
		return false;
}

void ScrollBox::ScrollBox::Write(std::string text, int color)
{
	ColoredString output = {text, color};

	ScrollBox::Write(output);
}

void ScrollBox::ScrollBox::Write(ColoredString text)
{
	if (sbScrollBoxType == SB_TEXT)
	{
        //wrap to the next line if text won't fit
		if (alfont_text_length(sbFont, text.String.c_str()) > sbTextAreaWidth)
		{
			int startpos = 0, a = 0;
			std::list<int> spacePos;
			std::string::iterator stringIt;
			for (stringIt = text.String.begin(); stringIt != text.String.end(); stringIt++)
			{
				if ((*stringIt) == ' ')
					spacePos.push_back(a);
				a++;
			}
			spacePos.push_back(a);
			std::list<int>::iterator myIt = spacePos.begin();
			while (myIt != spacePos.end())
			{
				while (myIt != spacePos.end() && alfont_text_length(sbFont, text.String.substr(startpos, (*myIt) - startpos).c_str()) < sbTextAreaWidth)
				{
					myIt++;
				}
				if (myIt != spacePos.begin())
					myIt--;
				ColoredString tempCS;
				tempCS.Color = text.Color;
				tempCS.String = text.String.substr(startpos, (*myIt) - startpos);
				sbTextLines.push_back(tempCS);
				startpos = (*myIt)+1;
				myIt++;
			}
            		
		}
		else
			sbTextLines.push_back(text);
		while(sbTextLines.size() > (unsigned int)sbLines)
			sbTextLines.pop_front();
	}
	else if (sbScrollBoxType == SB_LIST)
	{
		std::list<ListBoxItem>::iterator myIt = sbListBoxItems.begin();
		std::string tempString;
		while (myIt != sbListBoxItems.end())
		{
			if ((*myIt).text.String == "")
			{
				(*myIt).text = text;
				break;
			}
			myIt++;
		}
	}

	sbRedraw = true;
}

void ScrollBox::ScrollBox::drawDownArrow(BITMAP *buffer)
{
	int highlightColor;
	if (sbIsOverDown && !sbDragging)
		highlightColor = ColorHover;
	else
		highlightColor = ColorControls;

	rect(buffer, getLinkedX() + sbDownRect.left, getLinkedY() + sbDownRect.top, getLinkedX() + sbDownRect.right, getLinkedY() + sbDownRect.bottom, highlightColor);
	rectfill(buffer, getLinkedX() + sbDownRect.left+1, getLinkedY() + sbDownRect.top+1, getLinkedX() + sbDownRect.right-1, getLinkedY() + sbDownRect.bottom-1, ColorBackground);
	line(buffer, getLinkedX() + sbDownRect.left + (sbDownRect.right-sbDownRect.left)/2,
		getLinkedY() + sbDownRect.bottom - (sbDownRect.bottom - sbDownRect.top)/4, getLinkedX() + sbDownRect.left + (sbDownRect.right - sbDownRect.left)/4,
		getLinkedY() + sbDownRect.top + (sbDownRect.bottom - sbDownRect.top)/4, highlightColor);
	line(buffer, getLinkedX() + sbDownRect.left + (sbDownRect.right - sbDownRect.left)/4,
		getLinkedY() + sbDownRect.top + (sbDownRect.bottom - sbDownRect.top)/4, getLinkedX() + sbDownRect.right - (sbDownRect.right - sbDownRect.left)/4,
		getLinkedY() + sbDownRect.top + (sbDownRect.bottom - sbDownRect.top)/4, highlightColor);
	line(buffer, getLinkedX() + sbDownRect.right - (sbDownRect.right - sbDownRect.left)/4,
		getLinkedY() + sbDownRect.top + (sbDownRect.bottom - sbDownRect.top)/4, getLinkedX() + sbDownRect.left + (sbDownRect.right-sbDownRect.left)/2,
		getLinkedY() + sbDownRect.bottom - (sbDownRect.bottom - sbDownRect.top)/4, highlightColor);
}

void ScrollBox::ScrollBox::drawScrollBar(BITMAP *buffer)
{
	int highlightColor;
	if (sbIsOverBar || sbDragging)
		highlightColor = ColorHover;
	else
		highlightColor = ColorControls;

	int half = (sbScrollRect.right - sbScrollRect.left)/2;
	int third = (sbScrollRect.right - sbScrollRect.left)/3;
	rect(buffer, getLinkedX() + sbScrollRect.left, getLinkedY() + sbScrollRect.top, 
        getLinkedX() + sbScrollRect.right, getLinkedY() + sbScrollRect.bottom, highlightColor);
	rectfill(buffer, getLinkedX() + sbScrollRect.left + 1, getLinkedY() + sbScrollRect.top + 1,
		getLinkedX() + sbScrollRect.right - 1, getLinkedY() + sbScrollRect.bottom - 1, ColorBackground);
	line(buffer, getLinkedX() + sbScrollRect.left + third, getLinkedY() + sbScrollRect.top + half - 2,
		getLinkedX() + sbScrollRect.right - third, getLinkedY() + sbScrollRect.top + half - 2, highlightColor);
	line(buffer, getLinkedX() + sbScrollRect.left + third, getLinkedY() + sbScrollRect.top + half,
		getLinkedX() + sbScrollRect.right - third, getLinkedY() + sbScrollRect.top + half , highlightColor);
	line(buffer, getLinkedX() + sbScrollRect.left + third, getLinkedY() + sbScrollRect.top + half + 2,
		getLinkedX() + sbScrollRect.right - third, getLinkedY() + sbScrollRect.top + half + 2, highlightColor);
}

void ScrollBox::ScrollBox::drawTrack(BITMAP *buffer)
{
	int half = (sbTrackRect.right - sbTrackRect.left)/2;
	rect(buffer, getLinkedX() + sbTrackRect.left, getLinkedY() + sbTrackRect.top, getLinkedX() + sbTrackRect.right, getLinkedY() + sbTrackRect.bottom, ColorControls);
	rectfill(buffer, getLinkedX() + sbTrackRect.left + 1, getLinkedY() + sbTrackRect.top + 1, getLinkedX() + sbTrackRect.right - 1, getLinkedY() + sbTrackRect.bottom - 1, ColorBackground);
	//line(buffer, getLinkedX() + sbTrackRect.left + half, getLinkedY() + sbTrackRect.top, getLinkedX() + sbTrackRect.left + half,
	//	getLinkedY() + sbTrackRect.bottom, ColorControls);
}

void ScrollBox::ScrollBox::drawUpArrow(BITMAP *buffer)
{
	int highlightColor;
	if (sbIsOverUp && !sbDragging)
		highlightColor = ColorHover;
	else
		highlightColor = ColorControls;

	rect(buffer, getLinkedX() + sbUpRect.left, getLinkedY() + sbUpRect.top, getLinkedX() + sbUpRect.right, getLinkedY() + sbUpRect.bottom, highlightColor);
	rectfill(buffer, getLinkedX() + sbUpRect.left+1, getLinkedY() + sbUpRect.top+1, getLinkedX() + sbUpRect.right-1, getLinkedY() + sbUpRect.bottom-1, ColorBackground);
	line(buffer, getLinkedX() + sbUpRect.left + (sbUpRect.right-sbUpRect.left)/2,
		getLinkedY() + sbUpRect.top + (sbUpRect.bottom - sbUpRect.top)/4, getLinkedX() + sbUpRect.left + (sbUpRect.right - sbUpRect.left)/4,
		getLinkedY() + sbUpRect.bottom - (sbUpRect.bottom - sbUpRect.top)/4, highlightColor);
	line(buffer, getLinkedX() + sbUpRect.left + (sbUpRect.right - sbUpRect.left)/4,
		getLinkedY() + sbUpRect.bottom - (sbUpRect.bottom - sbUpRect.top)/4, getLinkedX() + sbUpRect.right - (sbUpRect.right - sbUpRect.left)/4,
		getLinkedY() + sbUpRect.bottom - (sbUpRect.bottom - sbUpRect.top)/4, highlightColor);
	line(buffer, getLinkedX() + sbUpRect.right - (sbUpRect.right - sbUpRect.left)/4,
		getLinkedY() + sbUpRect.bottom - (sbUpRect.bottom - sbUpRect.top)/4, getLinkedX() + sbUpRect.left + (sbUpRect.right-sbUpRect.left)/2,
		getLinkedY() + sbUpRect.top + (sbUpRect.bottom - sbUpRect.top)/4, highlightColor);
}

void ScrollBox::ScrollBox::ScrollToBottom()
{
	if (sbLinkedBox != NULL)
		sbLinkedBox->ScrollToBottom();
	sbScrollBarPos = sbScrollBarMax;
	sbScrollRect.top = sbScrollBarPos;
	sbScrollRect.bottom = sbScrollRect.top + sbScrollBarHeight;
	sbWindowClipY = sbScrollIncrement * (sbScrollBarPos-sbScrollBarMin);
}

void ScrollBox::ScrollBox::ScrollToTop()
{
	if (sbLinkedBox != NULL)
		sbLinkedBox->ScrollToTop();
	sbScrollBarPos = sbScrollBarMin;
	sbScrollRect.top = sbScrollBarPos;
	sbScrollRect.bottom = sbScrollRect.top + sbScrollBarHeight;
	sbWindowClipY = sbScrollIncrement * (sbScrollBarPos-sbScrollBarMin);
}

void ScrollBox::ScrollBox::LinkBox(ScrollBox *scrollBox)
{
	if (sbLinkedBox == NULL)
	{
		sbLinkedBox = scrollBox;
		scrollBox->DrawScrollBar(false);
		scrollBox->SetParent(this);
		sbTextAreaRect = AREA(0, 0, scrollBox->getLinkedWidth() - 16, scrollBox->getLinkedHeight());
		sbUpRect = AREA(scrollBox->getLinkedWidth() - 16, 0, scrollBox->getLinkedWidth()-1, 15);
		sbDownRect = AREA(scrollBox->getLinkedWidth() - 16, scrollBox->getLinkedHeight() - 16, scrollBox->getLinkedWidth()-1, scrollBox->getLinkedHeight()-1);
		sbScrollRect = AREA(scrollBox->getLinkedWidth() - 16, 16, scrollBox->getLinkedWidth()-1, 31);
		sbTrackRect = AREA(scrollBox->getLinkedWidth() - 16, 0, scrollBox->getLinkedWidth()-1, scrollBox->getLinkedHeight()-1);
		sbScrollAreaRect = AREA(sbUpRect.left, sbUpRect.top, sbDownRect.right, sbDownRect.bottom);
	}
	else
		sbLinkedBox->LinkBox(scrollBox);

}

void ScrollBox::ScrollBox::setLines(int lines)
{
   if (sbLinkedBox != NULL)
      sbLinkedBox->setLines(lines);

	sbLines = lines;
	destroy_bitmap(sbBuffer);
	if (sbLines * sbFontHeight < sbHeight)
		sbBuffer = create_bitmap(sbWidth, sbHeight);
	else
		sbBuffer = create_bitmap(sbWidth, sbLines * sbFontHeight);
	sbScrollIncrement = (float)((sbLines * sbFontHeight)-sbHeight) / (sbScrollBarMax - sbScrollBarMin);
	if (sbScrollBoxType == SB_LIST)
	{
		sbListBoxItems.clear();
		ListBoxItem tempLBI;
		tempLBI.bHover = sbHover;
		tempLBI.bNormal = sbNormal;
		tempLBI.bSelected = sbSelected;
		tempLBI.selected = false;
		tempLBI.hover = false;
		tempLBI.text.String = "";
		tempLBI.text.Color = makecol(0,0,0);
		for (int a = 0; a < sbLines; a++)
		{
			sbListBoxItems.push_back(tempLBI);
		}
	}
	else if (sbScrollBoxType == SB_TEXT)
	{
		sbTextLines.clear();
		ColoredString temp;
		temp.Color = makecol(0, 0, 0);
		temp.String = "";
		for (int a = 0; a < sbLines; a++)
		{
			sbTextLines.push_front(temp);
		}
	}
	else
		sbTextLines.clear();
   sbRedraw = true;
}

void ScrollBox::ScrollBox::Clear()
{
   if (sbLinkedBox != NULL)
      sbLinkedBox->Clear();

       if (sbScrollBoxType == SB_LIST)
       {
               sbListBoxItems.clear();
               ListBoxItem tempLBI;
               tempLBI.bHover = sbHover;
               tempLBI.bNormal = sbNormal;
               tempLBI.bSelected = sbSelected;
               tempLBI.selected = false;
               tempLBI.hover = false;
               tempLBI.text.String = "";
               tempLBI.text.Color = makecol(0,0,0);
               for (int a = 0; a < sbLines; a++)
               {
                       sbListBoxItems.push_back(tempLBI);
               }
			   sbSelectedItem = -1;
			   sbListItemSelected = false;
       }
       else if (sbScrollBoxType == SB_TEXT)
       {
               sbTextLines.clear();
               ColoredString temp;
               temp.Color = makecol(0, 0, 0);
               temp.String = "";
               for (int a = 0; a < sbLines; a++)
               {
                       sbTextLines.push_front(temp);
               }
       }
	   else
	   {
		   sbTextLines.clear();
	   }

       sbRedraw = true;
}

int ScrollBox::ScrollBox::GetX()
{
	return sbX;
}

void ScrollBox::ScrollBox::SetX(int x)
{
	sbX = x;
}

int ScrollBox::ScrollBox::GetY()
{
	return sbY;
}

void ScrollBox::ScrollBox::SetY(int y)
{
	sbY = y;
}

void ScrollBox::ScrollBox::SetSelectedIndex(int index)
{
   if (sbLinkedBox != NULL)
      sbLinkedBox->SetSelectedIndex(index);

   sbSelectedItem = index;

   if (sbSelectedItem < -1)
      sbSelectedItem = -1;

   if (sbSelectedItem >= sbLines)
      sbSelectedItem = -1;

   if (index < 0)
   {
      // clear any selected items
		for(std::list<ListBoxItem>::iterator myIt = sbListBoxItems.begin(); myIt != sbListBoxItems.end(); myIt++)
		{
			if((*myIt).selected)
			{
				(*myIt).selected = false;
				sbListItemSelected = false;
            sbRedraw = true;
         }
      }
   }
}

void ScrollBox::ScrollBox::SetParent(ScrollBox *parent)
{
	sbParent = parent;
}

void ScrollBox::ScrollBox::setHover(int index, bool TrueOrFalse)
{
	int a = 0;
	for(std::list<ListBoxItem>::iterator myIt = sbListBoxItems.begin(); myIt != sbListBoxItems.end(); myIt++)
	{
		if (index == a)
		{
			(*myIt).hover = TrueOrFalse;
			if (sbParent)
				sbParent->setHover(index, TrueOrFalse);
			return;
		}
		a++;
	}
}
