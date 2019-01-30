#ifndef BUTTON_H
#define BUTTON_H
#pragma once

#include "env.h"
#include <allegro.h>
#include <alfont.h>
#include "AudioSystem.h"
#include "Game.h"
#include <string>

/**
 * re-usable button class
 */
class Button
{
public:

	//ctors
	Button(
		std::string initImgFileNormal, 
		std::string initImgFileMouseOver, 
		std::string initImgFileDisabled, 
		int initX, 
		int initY, 
		int initMouseOverEvent, 
		int initClickEvent, 
		std::string initButtonSound = "", 
		bool initEnabled = true, 
		bool initVisible = true);

	Button(
		std::string initImgFileNormal, 
		std::string initImgFileMouseOver, 
		std::string initImgFileDisabled,
		int initX, 
		int initY, 
		int initMouseOverEvent, 
		int initClickEvent, 
		ALFONT_FONT *initFontPtr, 
		std::string initButtonText, 
		int initTextColor, 
		std::string initButtonSound = "", 
		bool initEnabled = true, 
		bool initVisible = true);

	Button(
		BITMAP *initImgBMPNormal, 
		BITMAP *initImgBMPMouseOver, 
		BITMAP *initImgBMPDisabled, 
		int initX, 
		int initY, 
		int initMouseOverEvent, 
		int initClickEvent, 
		std::string initButtonSound = "", 
		bool initEnabled = true, 
		bool initVisible = true);

	Button(
		BITMAP *initImgBMPNormal, 
		BITMAP *initImgBMPMouseOver, 
		BITMAP *initImgBMPDisabled, 
		int initX, 
		int initY, 
		int initMouseOverEvent, 
		int initClickEvent, 
		ALFONT_FONT *initFontPtr, 
		std::string initButtonText,
		int initTextColor, 
		std::string initButtonSound = "", 
		bool initEnabled = true, 
		bool initVisible = true);

	virtual ~Button();

	//accessors
	BITMAP * GetImgNormal() const;
	BITMAP * GetImgMouseOver() const;
	BITMAP * GetImgDisabled() const;
	std::string GetButtonSound() const;
	int	GetX() const;
	int	GetY() const;
	int	GetMouseOverEvent() const;
	int	GetClickEvent() const;
	bool IsEnabled() const;
	bool IsVisible() const;
	std::string GetButtonText() const;
	int	GetTextColor() const;
	bool IsInitialized() const;
	int	GetWidth() const;
	int	GetHeight() const;
	bool GetHighlight() const;

	//mutators
	void SetImgNormal(BITMAP *initImgNormal);
	void SetImgMouseOver(BITMAP *initImgMouseOver);
	void SetImgDiabled(BITMAP *initImgDisabled);
	void SetButtonSound(std::string initButtonSound);
	void SetX(int initX);
	void SetY(int initY);
	void SetMouseOverEvent(int initMouseOverEvent);	
	void SetClickEvent(int initClickEvent);
	void SetEnabled(bool enabled);
	void SetVisible(bool visible);	
	void SetButtonText(std::string initButtonText);	
	void SetTextColor(int initTextColor);  	
	void SetHighlight(bool initHighlight);	

	//functions
	void Destroy();

	bool Run(BITMAP *canvas, bool trans=false);
	bool OnMouseMove(int initX, int initY);
	bool OnMouseReleased(int button, int initX, int initY);
	bool PtInBtn(int initX, int initY);

private:

	BITMAP			*imgNormal;
	BITMAP			*imgMouseOver;
	BITMAP			*imgDisabled;
	std::string		buttonSound;
	int				x;
	int				y;
	int				mouseOverEvent;
	int				clickEvent;
	bool			enabled;
	bool			visible;
	std::string		buttonText;
	bool			initialized;
	bool			deleteBitmaps;
	bool			highlight;
	int				lastMouseX;
	int				lastMouseY;
	ALFONT_FONT		*fontPtr;
	int				textColor;

	//private functions

};

#endif
