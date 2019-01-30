/*
	STARFLIGHT - THE LOST COLONY
	ModuleControlPanel.h - control panel module, provides a tab for each officer.  Each of these tabs
	shows info about the officer and all the commands for that officer.  Individual commands may be
	enabled/disabled based on the current context.  When commands are used, events are broadcast to
	the other active modules, allowing them to handle the commands.
	
	Author: coder1024
	Date: April, 07
*/

#ifndef MODULECONTROLPANEL_H
#define MODULECONTROLPANEL_H
#pragma once

#include "env.h"
#include <allegro.h>
#include <fmod.hpp>
#include "Module.h"
#include "DataMgr.h"
#include "AudioSystem.h"

#include <string>
#include <vector>

#define EVENT_CAPTAIN_LAUNCH 1000
#define EVENT_CAPTAIN_DESCEND 1002
//#define EVENT_CAPTAIN_DISEMBARK 1003
#define EVENT_CAPTAIN_CARGO 1004
//#define EVENT_CAPTAIN_LOG 1005
#define EVENT_CAPTAIN_QUESTLOG 1007
#define EVENT_SCIENCE_SCAN 2000
#define EVENT_SCIENCE_ANALYSIS 2001
//#define EVENT_NAVIGATOR_MANEUVER 3000
#define EVENT_NAVIGATOR_STARMAP 3001
#define EVENT_NAVIGATOR_ORBIT 3002
#define EVENT_NAVIGATOR_HYPERSPACE 3003
#define EVENT_NAVIGATOR_DOCK 3005
#define EVENT_TACTICAL_SHIELDS 4000
#define EVENT_TACTICAL_WEAPONS 4002
#define EVENT_TACTICAL_COMBAT 4004
//#define EVENT_ENGINEER_DAMAGE 5000
#define EVENT_ENGINEER_REPAIR 5001
#define EVENT_ENGINEER_INJECT 5002
#define EVENT_COMM_HAIL 6000
#define EVENT_COMM_DISTRESS 6002
#define EVENT_COMM_STATEMENT 6003
#define EVENT_COMM_QUESTION 6004
#define EVENT_COMM_POSTURE 6005
#define EVENT_COMM_TERMINATE 6006
#define EVENT_DOCTOR_EXAMINE 7000
#define EVENT_DOCTOR_TREAT 7001



class ModuleControlPanel : public Module
{
public:
	ModuleControlPanel(void);
	virtual ~ModuleControlPanel(void);
	virtual bool Init();
	virtual void Update();
	virtual void Draw();
	virtual void OnKeyPress(int keyCode);
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

	void SetButton(int ButtonID, bool enabled);
	
private:

	bool bEnabled;
	BITMAP			*controlPanelBackgroundImg;

	Sample *sndOfficerSelected;
	Sample *sndOfficerCommandSelected;

	class CommandButton
	{
	public:
		CommandButton(ModuleControlPanel& outer, int datFileCmdIcon, std::string cmdName, int posX, int posY);
		virtual ~CommandButton();
		
		

		static bool InitCommon();
		bool InitButton();
		void DestroyButton();
		static void DestroyCommon();
		static int GetCommonWidth();
		static int GetCommonHeight();

		void RenderPlain(BITMAP	*canvas);
		void RenderDisabled(BITMAP *canvas);
		void RenderMouseOver(BITMAP	*canvas);
		void RenderSelected(BITMAP *canvas);

		bool IsInButton(int x, int y);

		void SetEnabled(bool enabled);
		bool GetEnabled();

		//JH 5/05
		int getEventID() { return eventID; }
		void setEventID(int value) { eventID = value; }

	private:
		ModuleControlPanel	&outer;
		
		//std::string			imgFileCmdIcon; //replaced with datafile
		int					datFileCmdIcon;
		
		std::string			cmdName;
		int					posX;
		int					posY;
		BITMAP				*imgCmdIcon;
		bool				enabled;

		//JH 5/05
		int					eventID;

		static BITMAP		*imgBackground;
		static BITMAP		*imgBackgroundDisabled;
		static BITMAP		*imgBackgroundMouseOver;
		static BITMAP		*imgBackgroundSelected;

		void Render(BITMAP *canvas, BITMAP *imgBackground, bool down = false);
	};

	class OfficerButton
	{
	public:
		//OfficerButton(ModuleControlPanel& outer, OfficerType officerType, std::string imgFileMouseOver, std::string imgFileSelected, int posX, int posY);
		OfficerButton(ModuleControlPanel& outer, OfficerType officerType, int datFileMouseOver, int datFileSelected, int posX, int posY);
		virtual ~OfficerButton();

		static bool InitCommon();
		bool InitButton();
		void DestroyButton();
		static void DestroyCommon();

		void RenderMouseOver(BITMAP *canvas);
		void RenderSelected(BITMAP *canvas);

		bool IsInButton(int x, int y);

		std::vector<CommandButton*> commandButtons;

		int					posX;
		int					posY;
		BITMAP				*imgMouseOver;

      OfficerType GetOfficerType() { return officerType; }

	private:
		ModuleControlPanel	&outer;
		OfficerType			officerType;
		
		//std::string			imgFileMouseOver;
		//std::string			imgFileSelected;
		int					datFileMouseOver;
		int					datFileSelected;
		
		BITMAP				*imgSelected;
		bool				isSelected;
		static BITMAP		*imgTipWindowBackground;

	};

	std::vector<OfficerButton*>		officerButtons;
	
	OfficerButton					*mouseOverOfficer;
	OfficerButton					*selectedOfficer;

	CommandButton					*mouseOverCommand;
	CommandButton					*selectedCommand;
};

#endif

