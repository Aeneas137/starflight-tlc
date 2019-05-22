/*
	STARFLIGHT - THE LOST COLONY
	Game.h -
	Author: D.Calkins
	Date: 2007

*/

#ifndef GAME_H
#define GAME_H 1

#include <iostream>
#include <string>
#include <vector>
#include <alfont.h>
#include "ScrollBox.h"
#include "Timer.h"
#include "Sprite.h"

#ifdef MSVC10_DEBUG
	#include "GameState.h"
#endif
///////////////////////////////////////////
// global constants
///////////////////////////////////////////

//DO NOT MODIFY THESE
#define SCREEN_WIDTH 1024  //1280
#define SCREEN_HEIGHT 768 //960

//COMMON RGB COLORS
//here's a good source of rgb colors: http://www.pitt.edu/~nisg/cis/web/cgi/rgb.html
#define BLACK			makecol(0,0,0)
#define GRAY1			makecol(232,232,232)
#define DGRAY           makecol(120,120,120)
#define WHITE			makecol(255,255,255)
#define BLUE			makecol(0,0,255)
#define LTBLUE			makecol(150,150,255)
#define SKYBLUE			makecol(0,216,255)
#define DODGERBLUE		makecol(30,144,255)
#define ROYALBLUE		makecol(39,64,139)
#define PURPLE			makecol(212, 72,255)
#define RED				makecol(255,0,0)
#define LTRED			makecol(255,150,150)
#define ORANGE			makecol(255,165,0)
#define DKORANGE		makecol(255,140,0)
#define BRTORANGE		makecol(255,120,0)
#define YELLOW			makecol(250,250,0)
#define LTYELLOW		makecol(255,255,0)
#define GREEN			makecol(0,255,0)
#define LTGREEN			makecol(150,255,150)
#define PINEGREEN		makecol(80,170,80)
#define STEEL			makecol(159,182,205)
#define KHAKI			makecol(238,230,133)
#define DKKHAKI			makecol(139,134,78)

#define GREEN2			makecol(71,161,91)
#define RED2			makecol(110,26,15)
#define YELLOW2			makecol(232,238,106)
#define GOLD			makecol(255,216,0)

#define FLUX_SCANNER_ID 2

struct BITMAP;
class Module;
class GameState;
class ModeMgr;
class DataMgr;
class AudioSystem;
class QuestMgr;
class Script;
class PauseMenu;

class ModulePlanetSurface;
class ModuleCargoWindow;
class MessageBoxWindow;
class ModuleEncounter;

enum MsgType {
	MSG_INFO=0,              //informative messages
	MSG_ALERT,               //messages printed in dangerous situations
	MSG_ERROR,               //command not allowed in that context and similar stuff
	MSG_ACK,                 //officer will try to execute the orders
	MSG_FAILURE,             //officer tried to execute the orders, but failed
	MSG_SUCCESS,             //officer tried to execute the orders, and succeeded
	MSG_TASK_COMPLETED,      //officer acknowledge completion of a long-running task (e.g. heal & repair)
	MSG_SKILLUP              //officer got a skill increase
};
#define NUM_MSGTYPES 8

class Game
{
public:
	Game();
	virtual ~Game();
	void Run();
	void shutdown();
	void fatalerror(std::string error);
	void message(std::string msg);
	BITMAP *GetBackBuffer() { return m_backbuffer; }
	void setVibration(int value) { vibration = value; }
	int getVibration() { return vibration; }

    MessageBoxWindow *messageBox;
	PauseMenu *pauseMenu;
	Sprite *cursor;

	void ShowMessageBoxWindow(
        std::string initHeading = "",
		std::string initText = "",
		int initWidth = 400,
		int initHeight = 300,
		int initTextColor = WHITE,
		int initX = SCREEN_WIDTH/2,
		int initY = SCREEN_HEIGHT/2,
		bool initCentered = true,
		bool pauseGame = true);
	void KillMessageBoxWindow();

	void TogglePauseMenu();
	void setPaused(bool value) { m_pause = value; }
	void SetTimePaused(bool v);
	void SetTimeRateDivisor(int v);
	bool getTimePaused() 	  {return timePause;}
	int  getTimeRateDivisor() {return timeRateDivisor;}

	static QuestMgr		*questMgr;
	static GameState	*gameState;
	static ModeMgr		*modeMgr;
	static DataMgr		*dataMgr;
	static AudioSystem	*audioSystem;

	ModulePlanetSurface *PlanetSurfaceHolder;

	ALFONT_FONT *font10;
	ALFONT_FONT *font12;
	ALFONT_FONT *font18;
	ALFONT_FONT *font20;
	ALFONT_FONT *font22;
	ALFONT_FONT *font24;
	ALFONT_FONT *font32;

	void PrintDefault(BITMAP *dest,int x,int y, std::string text,int color = WHITE);
	void Print(BITMAP *dest,ALFONT_FONT *_font, int x,int y,std::string text, int color = makecol(255,255,255), bool shadow = false);
	void Print12(BITMAP *dest, int x,int y,std::string text, int color = makecol(255,255,255), bool shadow=false);
	void Print18(BITMAP *dest, int x,int y,std::string text, int color = makecol(255,255,255), bool shadow=false);
	void Print20(BITMAP *dest, int x,int y,std::string text, int color = makecol(255,255,255), bool shadow=false);
	void Print22(BITMAP *dest, int x,int y,std::string text, int color = makecol(255,255,255), bool shadow=false);
	void Print24(BITMAP *dest, int x,int y,std::string text, int color = makecol(255,255,255), bool shadow=false);
	void Print32(BITMAP *dest, int x,int y,std::string text, int color = makecol(255,255,255), bool shadow=false);

	//shared print to ScrollBox in GUI modules
	struct TimedText
	{
		std::string text;
		int color;
		long delay;
	};
	std::vector<TimedText> messages;
    ScrollBox::ScrollBox *g_scrollbox;
	void printout(ScrollBox::ScrollBox *scroll, std::string text, int color=WHITE, long delay=0);
	int MsgColors[NUM_MSGTYPES];
	void PrintMsg(MsgType msgtype, OfficerType officertype, std::string msg, int delay);

   //used to retrieve global values from script file globals.lua
	void runGlobalFunction(std::string name);
	std::string getGlobalString(std::string name);
    void setGlobalString(std::string name, std::string value);
	double getGlobalNumber(std::string name);
	void setGlobalNumber(std::string name, double value);
	bool getGlobalBoolean(std::string name);

	int getFrameRate() { return frameRate; }
	Timer globalTimer;

	//used to enable/disable the control panel (when in use)
	bool ControlPanelActivity;

	//used by the ModeMgr sanity checks
	bool IsRunning() { return m_keepRunning; }

	//on/off toggle of some gui elements to reduce vertical visual clutter
	bool doShowControls() { return showControls; }
	void toggleShowControls();

    //used to itemize detected video modes reported by the DirectX driver for use in Settings
    struct VideoMode
    {
        int bpp,width,height;
    };
    std::vector<VideoMode> videomodes;
    typedef std::vector<VideoMode>::iterator VideoModeIterator;
    int desktop_width, desktop_height, desktop_colordepth;
    int actual_width, actual_height;
    bool Initialize_Graphics();


protected:
	void Stop();
	virtual bool InitGame();
	virtual void DestroyGame();
	virtual void RunGame();
	virtual void OnKeyPress(int keyCode);
	virtual void OnKeyPressed(int keyCode);
	virtual void OnKeyReleased(int keyCode);
	virtual void OnMouseMove(int x, int y);
	virtual void OnMouseClick(int button, int x, int y);
	virtual void OnMousePressed(int button, int x, int y);
	virtual void OnMouseReleased(int button, int x, int y);
	virtual void OnMouseWheelUp(int x, int y);
	virtual void OnMouseWheelDown(int x, int y);
    
private:

    void UpdateAlienRaceAttitudes();

	bool showControls;
	bool m_keepRunning;
	bool m_pause;
	bool timePause;			//set for modules in which game time should not update (starport, etc.)
	int  timeRateDivisor;	//was (static) 'update_interval' in Game::RunGame.
	int vibration;

	//primary drawing surface for all modules
	BITMAP *m_backbuffer;

	//the same as the primary surface, except it doesn't have a mouse on it
    //not to be rude but who is the idiot who came up with this solution?
	//BITMAP *m_backbufferWithoutMouse;

	//vars used for framerate calculation
	int frameCount, startTime, frameRate;
    double screen_scaling, scale_width, scale_height;

	int m_numMouseButtons;
	// array of bools which are true for pressed buttons, false otherwise
	bool *m_mouseButtons;

	// same as m_mouseButtons, but used to indicate the prior state
	bool *m_prevMouseButtons;

	// used to record the position at which a mouse button was pressed; used
	// to detect clicks (mouse pressed and released at the same location
	struct MousePos
	{
		int x;
		int y;
	};
	MousePos *m_mousePressedLocs;

	// previous mouse position
	int m_prevMouseX;
	int m_prevMouseY;
	int m_prevMouseZ;

	// holds the state of the keys in the previous loop; used to detect kb events
	char m_prevKeyState[256];

	void CalculateFramerate();
	void UpdateKeyboard();
	void UpdateMouse();
	bool InitializeModules();

	//LUA state object used to read global settings
	Script *globals;

	std::string p_title;
	std::string p_version;

};


extern Game *g_game;


#endif
