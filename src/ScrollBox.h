#ifndef _SCROLLBOX_H
#define _SCROLLBOX_H

#include "env.h"
#include <allegro.h>
#include <alfont.h>
#include <string>
#include <list>

namespace ScrollBox {

enum ScrollBoxType {
	SB_TEXT,
	SB_LIST
};

struct ColoredString {
	std::string String;
	int Color;
};

class ScrollBox
{
private:
	struct AREA {
		int left, top, right, bottom;
		AREA() : left(0), top(0), right(0), bottom(0) {}
		AREA(int X, int Y, int W, int H) : left(X), top(Y), right(W), bottom(H) {}
	};
	struct ListBoxItem {
		BITMAP *bNormal, *bHover, *bSelected;
		bool selected, hover;
		ColoredString text;
	};

//private:

	int							sbX;
	int 						sbY;
	int 						sbWidth;
	int 						sbHeight;
	int 						sbSelectedItem;
	int 						sbScrollSpeed;
	int							sbScrollBarPos;
	int 						sbScrollBarMin;
	int 						sbScrollBarMax;
	int 						sbLines;
	int 						sbTextAreaWidth;
	int							sbFontHeight;
	int 						sbCurrentLine;
	int 						sbScrollStart;
	int 						sbScrollBarYPos;
	int							sbScrollBarHeight;
	int 						sbWindowClipY;
	int 						sbLeftPad;
	int 						sbTopPad;
	int							eventID;
	float						sbScrollIncrement;
	ScrollBoxType				sbScrollBoxType;
	bool 						sbStickToBottom;
	bool 						sbDragging;
	bool 						sbDrawBar;
	bool 						sbIsOverUp;
	bool 						sbIsOverDown;
	bool 						sbIsOverBar;
	bool 						sbListItemSelected;
	bool 						sbRedraw;
	bool 						sbHighlight;
	BITMAP 						*sbNormal;
	BITMAP 						*sbHover;
	BITMAP 						*sbSelected;
	BITMAP 						*sbScrollBar;
	BITMAP 						*sbBuffer;
	AREA 						sbUpRect;
	AREA 						sbDownRect;
	AREA 						sbScrollRect;
	AREA 						sbTrackRect;
	AREA 						sbScrollAreaRect;
	AREA 						sbTextAreaRect;
	std::list<ColoredString>	sbTextLines;
	std::list<ListBoxItem>		sbListBoxItems;
	ALFONT_FONT					*sbFont;
	ScrollBox					*sbLinkedBox;
	ScrollBox					*sbParent;

	int							mouseX;
	int							mouseY;

private:

	bool isInside(int x, int y, AREA area);
	bool isInsideOffset(int x, int y, AREA area);
	void drawUpArrow(BITMAP *buffer);
	void drawDownArrow(BITMAP *buffer);
	void drawTrack(BITMAP *buffer);
	void drawScrollBar(BITMAP *buffer);
	void setHover(int index, bool TrueOrFalse);
	int getLinkedWidth() { return (sbLinkedBox)?sbLinkedBox->getLinkedWidth():sbWidth; }
	int getLinkedHeight() { return (sbLinkedBox)?sbLinkedBox->getLinkedHeight():sbHeight; }
	int getLinkedX() { return (sbLinkedBox)?sbLinkedBox->getLinkedX():sbX; }
	int getLinkedY() { return (sbLinkedBox)?sbLinkedBox->getLinkedY():sbY; }

public:
	ScrollBox(ALFONT_FONT *Font, ScrollBoxType initScrollBoxType = SB_TEXT, int X = 0, int Y = 0,
		int Width = 200, int Height = 200, int EventID = 66);
	~ScrollBox();
	void Clear();
	void Draw(BITMAP *buffer);
	void OnMousePressed(int button, int x, int y);
	void OnMouseReleased(int button, int x, int y);
	void OnMouseMove(int x, int y);
	void OnMouseWheelDown(int x, int y);
	void OnMouseWheelUp(int x, int y);
	void OnMouseClick(int button, int x, int y);
	void Write(std::string text, int  color = makecol(255,255,255));
	void Write(ColoredString String);
	void ScrollToBottom();
	void ScrollToTop();
	void LinkBox(ScrollBox *scrollBox);
	void SetLeftPad(int pad) {sbLeftPad = pad;};
	void SetTopPad(int pad) {sbTopPad = pad;};
	void DrawScrollBar(bool TrueOrFalse) {sbDrawBar = TrueOrFalse;};
	void setLines(int lines);
	int getLines() { return sbLines; }
	int GetSelectedIndex() { return sbSelectedItem; }
    std::string GetSelectedItem();
	void SetSelectedIndex(int index);
	void SetParent(ScrollBox *parent);

	int ColorControls;
	int ColorBackground;
    int ColorItemBorder;
	int ColorHover;
	int ColorSelectedBackground;
	int ColorSelectedHighlight;
    int ColorSelectedText;
    void SetColorBackground(int color) { ColorBackground = color; };
    void SetColorControls(int color) { ColorControls = color; };
    void SetColorHover(int color) { ColorHover = color; };
    void SetColorSelectedBackground(int color) { ColorSelectedBackground = color; };
    void SetColorSelectedHighlight(int color) { ColorSelectedHighlight = color; };
    void SetColorItemBorder(int color) { ColorItemBorder = color; };
    void SetColorSelectedText(int color) { ColorSelectedText = color; };
    void PaintNormalImage();
    void PaintHoverImage();
    void PaintSelectedImage();

	int GetX();
	void SetX(int x);
	int GetY();
	void SetY(int y);
}; //end class ScrollBox

} //end namespace ScrollBox


#endif /* _SCROLL_BOX_H */
