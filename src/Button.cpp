#include "env.h"
#include "Button.h"
#include "Events.h"
#include "Game.h"
#include "ModeMgr.h"

Button::Button(std::string initImgFileNormal, std::string initImgFileMouseOver, std::string initImgFileDisabled, int initX, 
	int initY, int initMouseOverEvent, int initClickEvent, std::string initButtonSound /*= ""*/, bool initEnabled /*= true*/, bool initVisible /*= true*/)
: initialized(false)
, deleteBitmaps(true)
, x(initX)
, y(initY)
, mouseOverEvent(initMouseOverEvent)
, clickEvent(initClickEvent)
, fontPtr(NULL)
, buttonText("")
, textColor(0)
, buttonSound(initButtonSound)
, enabled(initEnabled)
, visible(initVisible)
, imgNormal(NULL)
, imgMouseOver(NULL)
, imgDisabled(NULL)
, lastMouseX(0)
, lastMouseY(0)
, highlight(false)
{
	imgNormal = load_bitmap(initImgFileNormal.c_str(), NULL);
	imgMouseOver = load_bitmap(initImgFileMouseOver.c_str(), NULL);
	imgDisabled = load_bitmap(initImgFileDisabled.c_str(), NULL);

	if(imgNormal != NULL /*&& imgMouseOver != NULL && imgDisabled != NULL*/)
		initialized = true;
}

Button::Button(std::string initImgFileNormal, std::string initImgFileMouseOver, std::string initImgFileDisabled,
		int initX, int initY, int initMouseOverEvent, int initClickEvent, ALFONT_FONT *initFontPtr, std::string initButtonText,
		int initTextColor, std::string initButtonSound /*= ""*/, bool initEnabled /*= true*/, bool initVisible /*= true*/)
: initialized(false)
, deleteBitmaps(true)
, x(initX)
, y(initY)
, mouseOverEvent(initMouseOverEvent)
, clickEvent(initClickEvent)
, fontPtr(initFontPtr)
, buttonText(initButtonText)
, textColor(initTextColor)
, buttonSound(initButtonSound)
, enabled(initEnabled)
, visible(initVisible)
, imgNormal(NULL)
, imgMouseOver(NULL)
, imgDisabled(NULL)
, lastMouseX(0)
, lastMouseY(0)
, highlight(false)
{
	imgNormal = load_bitmap(initImgFileNormal.c_str(), NULL);
	imgMouseOver = load_bitmap(initImgFileMouseOver.c_str(), NULL);
	imgDisabled = load_bitmap(initImgFileDisabled.c_str(), NULL);

	if(imgNormal != NULL /*&& imgMouseOver != NULL && imgDisabled != NULL*/)
		initialized = true;
}

Button::Button(BITMAP *initImgBMPNormal, BITMAP *initImgBMPMouseOver, BITMAP *initImgBMPDisabled, int initX, int initY, 
	int initMouseOverEvent, int initClickEvent, std::string initButtonSound /*= ""*/, bool initEnabled /*= true*/, bool initVisible /*= true*/)
: initialized(false)
, deleteBitmaps(false)
, x(initX)
, y(initY)
, mouseOverEvent(initMouseOverEvent)
, clickEvent(initClickEvent)
, fontPtr(NULL)
, buttonText("")
, textColor(0)
, buttonSound(initButtonSound)
, enabled(initEnabled)
, visible(initVisible)
, imgNormal(initImgBMPNormal)
, imgMouseOver(initImgBMPMouseOver)
, imgDisabled(initImgBMPDisabled)
, lastMouseX(0)
, lastMouseY(0)
, highlight(false)
{
	if(imgNormal != NULL /*&& imgMouseOver != NULL && imgDisabled != NULL*/)
		initialized = true;
}

Button::Button(BITMAP *initImgBMPNormal, BITMAP *initImgBMPMouseOver, BITMAP *initImgBMPDisabled, int initX, int initY, 
	int initMouseOverEvent, int initClickEvent, ALFONT_FONT *initFontPtr, std::string initButtonText, int initTextColor, 
	std::string initButtonSound /*= ""*/, bool initEnabled /*= true*/, bool initVisible /*= true*/)
: initialized(false)
, deleteBitmaps(false)
, x(initX)
, y(initY)
, mouseOverEvent(initMouseOverEvent)
, clickEvent(initClickEvent)
, fontPtr(initFontPtr)
, buttonText(initButtonText)
, textColor(initTextColor)
, buttonSound(initButtonSound)
, enabled(initEnabled)
, visible(initVisible)
, imgNormal(initImgBMPNormal)
, imgMouseOver(initImgBMPMouseOver)
, imgDisabled(initImgBMPDisabled)
, lastMouseX(0)
, lastMouseY(0)
, highlight(false)
{
	if(imgNormal != NULL /*&& imgMouseOver != NULL && imgDisabled != NULL*/)
		initialized = true;
}

Button::~Button() { Destroy(); }

	//accessors
BITMAP * Button::GetImgNormal()			const { return imgNormal; }
BITMAP * Button::GetImgMouseOver()		const { return imgMouseOver; }
BITMAP * Button::GetImgDisabled()		const { return imgDisabled; }
std::string Button::GetButtonSound()	const { return buttonSound; }
int	Button::GetX()						const { return x; }
int	Button::GetY()						const { return y; }
int	Button::GetMouseOverEvent()			const { return mouseOverEvent; }
int	Button::GetClickEvent()				const { return clickEvent; }
bool Button::IsEnabled()				const { return enabled; }
bool Button::IsVisible()				const { return visible; }
std::string Button::GetButtonText()		const { return buttonText; }
int	Button::GetTextColor()				const { return textColor; }
bool Button::IsInitialized()			const { return initialized; }
int	Button::GetWidth()					const { if(initialized) return imgNormal->w; return 0; }
int	Button::GetHeight()					const { if(initialized) return imgNormal->h; return 0; }
bool Button::GetHighlight()				const { return highlight; }

//mutators
void Button::SetImgNormal(BITMAP *initImgNormal) 
{ 
	if(deleteBitmaps && imgNormal) delete imgNormal; imgNormal = initImgNormal; 
}
void Button::SetImgMouseOver(BITMAP *initImgMouseOver) 
{ 
	if(deleteBitmaps && imgMouseOver) delete imgMouseOver; imgMouseOver = initImgMouseOver; 
}
void Button::SetImgDiabled(BITMAP *initImgDisabled) 
{ 
	if(deleteBitmaps && imgDisabled) delete imgDisabled; imgDisabled = initImgDisabled; 
}
void Button::SetButtonSound(std::string initButtonSound){ buttonSound = initButtonSound; }
void Button::SetX(int initX)							{ x = initX; }
void Button::SetY(int initY)							{ y = initY; }
void Button::SetMouseOverEvent(int initMouseOverEvent)	{ mouseOverEvent = initMouseOverEvent; }
void Button::SetClickEvent(int initClickEvent)			{ clickEvent = initClickEvent; }
void Button::SetEnabled(bool initEnabled)				{ enabled = initEnabled; }
void Button::SetVisible(bool initVisible)				{ visible = initVisible; }
void Button::SetButtonText(std::string initButtonText)	{ buttonText = initButtonText; }
void Button::SetTextColor(int initTextColor)			{ textColor = initTextColor; }
void Button::SetHighlight(bool initHighlight)			{ highlight = initHighlight; }

void Button::Destroy()
{
	if(deleteBitmaps)
	{
		if (imgNormal != NULL)
		{
		  destroy_bitmap(imgNormal);
		  imgNormal = NULL;
		}

		if (imgMouseOver != NULL)
		{
		  destroy_bitmap(imgMouseOver);
		  imgMouseOver = NULL;
		}

		if (imgDisabled != NULL)
		{
		  destroy_bitmap(imgDisabled);
		  imgDisabled = NULL;
		}
	}
	initialized = false;
}

bool Button::Run(BITMAP *canvas, bool trans)
{
   if (!initialized)
	  return false;

   if (!visible)
	  return false;

   BITMAP *imgToDraw = imgNormal;

   bool mouseIsOverButton = PtInBtn(lastMouseX,lastMouseY);

   if (!enabled && (imgDisabled != NULL))
	  imgToDraw = imgDisabled;
	else if (enabled && mouseIsOverButton && (imgMouseOver != NULL))
	  imgToDraw = imgMouseOver;
   else if (enabled && highlight && (imgMouseOver != NULL))
	  imgToDraw = imgMouseOver;

	if (!trans)
		draw_sprite(canvas, imgToDraw, x, y);
	else
		draw_trans_sprite(canvas, imgToDraw, x, y);

	if(fontPtr != NULL && buttonText.length() > 0)
	{
		//get center of the button
		int textX = x + GetWidth()/2;
		int textY = y + GetHeight()/2 - alfont_get_font_height(fontPtr)/2;

		alfont_textout_centre_ex(canvas, fontPtr, buttonText.c_str(), textX, textY, textColor, -1);
	}

   if (mouseIsOverButton)
   {
	  Event e(mouseOverEvent);
	  Game::modeMgr->BroadcastEvent(&e);
   }
   return true;
}

bool Button::OnMouseMove(int initX, int initY)
{
   lastMouseX = initX;
   lastMouseY = initY;
	
   return PtInBtn(initX,initY);
}

bool Button::OnMouseReleased(int button, int initX, int initY)
{
	if (!this) return false;

   if (!initialized)
	  return false;

   if (!visible)
	  return false;

   if (!enabled)
	  return false;

   if (!PtInBtn(initX,initY))
	  return false;

   //make sure button sound isnt playing
   if(buttonSound != "")
   {
	   if(Game::audioSystem->IsPlaying(buttonSound) )
		   Game::audioSystem->Stop(buttonSound);

	   //play button sound
	   Game::audioSystem->Play(buttonSound);
   }

   Event e(clickEvent);
   Game::modeMgr->BroadcastEvent(&e);

   return true; //success
}

bool Button::PtInBtn(int initX, int initY)
{
	try {	
		if ((initX >= x) && (initX < (x + imgNormal->w)) && (initY >= y) && (initY < (y + imgNormal->h) ) )
			return true;
	}
	catch(...) { }

   return false;
}


