#include "MessageBoxWindow.h"
#include "Button.h"
#include "Label.h"
#include "Game.h"
#include "Events.h"
#include "ModeMgr.h"

BITMAP *MessageBoxWindow::bg = NULL;
BITMAP *MessageBoxWindow::bar = NULL;
Button *MessageBoxWindow::button1 = NULL;
Button *MessageBoxWindow::button2 = NULL;


MessageBoxWindow::MessageBoxWindow(
    std::string initheading,
	std::string initText,
	int initX, int initY, 
	int initWidth, int initHeight, 
	int initTextColor, 
	bool initCentered) : 
        heading(initheading),
		text(initText),
		x(initX), 
		y(initY), 
		width(initWidth), 
		height(initHeight),
		textColor(initTextColor),
		centered(initCentered), 
		visible(true)
{
	if (bg == NULL)
		bg = load_bitmap("data/gui/trans_bg.tga", NULL);
	
	if (bar == NULL)
		bar = load_bitmap("data/gui/messagebox_bar.bmp", NULL);

	if (button1 == NULL)
	{
		button1 = new Button(
			"data/gui/generic_exit_btn_norm.bmp", 
			"data/gui/generic_exit_btn_over.bmp", 
			"data/gui/generic_exit_btn_over.bmp", 
			x, y,
			0xDEADBEEF,0xDEADBEEF + 1,
			g_game->font24,
			"Ok",
			WHITE);
	}

    int left = x - width/2;
    int top = y - height/2;
    int right = x + width/2;
    int bottom = y + height/2;


	if (centered)
	{
		button1->SetX(x - button1->GetWidth()/2);
		button1->SetY((y + height/2) - (button1->GetHeight() + 7));
		labelText = new Label(text, (x - width/2) + 20, top + 60, width - 34, height - 20, initTextColor, g_game->font24);
	    labelHeading = new Label(heading, (x - width/2) + 20, top + 20, width - 34, height - 20, initTextColor, g_game->font24);
	}
	else
	{
		button1->SetX((x + width/2) - (button1->GetWidth()/2));
		button1->SetY((y + height) - (button1->GetHeight() + 7));
		labelText = new Label(text, x + 20, y + 30, width - 34, height - 20, initTextColor, g_game->font24);
	    labelHeading = new Label(heading, x + 20, y + 10, width - 34, height - 20, initTextColor, g_game->font24);
	}

    labelText->Refresh();
    labelHeading->Refresh();

}

MessageBoxWindow::~MessageBoxWindow()
{
	if(labelText)
		delete labelText;
    if (labelHeading)
        delete labelHeading;
}

//accessors
std::string MessageBoxWindow::GetText()						const { return text; }
int MessageBoxWindow::GetX()								const { return x; }
int MessageBoxWindow::GetY()								const { return y; }
int MessageBoxWindow::GetWidth()							const { return width; }
int MessageBoxWindow::GetHeight()							const { return height; }
int MessageBoxWindow::GetTextColor()						const { return textColor; }
bool MessageBoxWindow::IsCentered()							const { return centered; }
bool MessageBoxWindow::IsVisible()							const { return visible; }


//mutators
void MessageBoxWindow::SetText(std::string initText)		{ text = initText; labelText->SetText(text); labelText->Refresh(); }
void MessageBoxWindow::SetX(int initX)						{ x = initX; labelText->SetX(x); labelText->Refresh(); }
void MessageBoxWindow::SetY(int initY)						{ y = initY; labelText->SetY(y); labelText->Refresh(); }
void MessageBoxWindow::SetWidth(int initWidth)				{ width = initWidth; }
void MessageBoxWindow::SetHeight(int initHeight)			{ height = initHeight; }
void MessageBoxWindow::SetTextColor(int initTextColor)		{ textColor = initTextColor; }
void MessageBoxWindow::SetCentered(bool initCentered)		{ centered = initCentered; }
void MessageBoxWindow::SetVisible(bool visibility)			{ visible = visibility; }


//other funcs
bool MessageBoxWindow::OnMouseMove(int x, int y)
{
	bool result = false;

	if(button1)
		result = button1->OnMouseMove(x, y);

	if(button2 && !result)
		result = button2->OnMouseMove(x, y);

	return result;
}
bool MessageBoxWindow::OnMouseReleased(int button, int x, int y)
{
	bool result = false;

	if(button1)
		result = button1->OnMouseReleased(button, x, y);

	if(button2 && !result)
		result = button2->OnMouseReleased(button, x, y);

	return result;
}

bool MessageBoxWindow::OnMouseClick(int button, int x, int y)
{
	bool result = false;

	if(button1)
		result = button1->PtInBtn(x, y);

	if(button2 && !result)
		result = button2->PtInBtn(x, y);

	return result;
}

bool MessageBoxWindow::OnMousePressed(int button, int x, int y)
{
	bool result = false;

	if(button1)
		result = button1->PtInBtn(x, y);

	if(button2 && !result)
		result = button2->PtInBtn(x, y);

	return result;
}

bool MessageBoxWindow::OnKeyPress(int keyCode)
{
	if (keyCode == KEY_ENTER) 
	{
		Event e(0xDEADBEEF + 1);
		Game::modeMgr->BroadcastEvent(&e);
		return true;
	}
	return false;
}


void MessageBoxWindow::Update(){}

void MessageBoxWindow::Draw()
{

	BITMAP *backBuffer = g_game->GetBackBuffer();

	int left;
	int right;
	int top;
	int bottom;

	if(centered)
	{
		left = x - width/2;
		top = y - height/2;
		right = x + width/2;
		bottom = y + height/2;
	}
	else
	{
		left = x;
		top = y;
		right = x + width;
		bottom = y + height;
	}

	BITMAP *temp = create_bitmap(width, height);
	stretch_blit(bg, temp, 0, 0, bg->w, bg->h, 0, 0, width, height);
	draw_trans_sprite(backBuffer, temp, left, top); 

	if(button1)	button1->Run(backBuffer);
	if(button2)	button2->Run(backBuffer);

	masked_stretch_blit(bar, backBuffer, 0, 0, bar->w, bar->h, left, top, temp->w, bar->h);
	masked_stretch_blit(bar, backBuffer, 0, 0, bar->w, bar->h, left, top + temp->h - bar->h, temp->w, bar->h);

	destroy_bitmap(temp);

    if (labelHeading)
        labelHeading->Draw(backBuffer);
	if(labelText)
		labelText->Draw(backBuffer);

}
