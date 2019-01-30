#include <exception>
#include "env.h"
#include "ModuleCaptainsLounge.h"
#include "Button.h"
#include "AudioSystem.h"
#include "Events.h"
#include "ModeMgr.h"
#include "Game.h"
#include "GameState.h"
#include "Util.h"

#include <string>
#include <sstream>
using namespace std;

#define TEXTHEIGHT_TITLES 60
#define TEXTHEIGHT_GAME_NAME 30
#define TEXTHEIGHT_GAME_PROFESSION 20
#define TEXTHEIGHT_BTN_TITLES 30
#define TEXTCOL makecol(0,255,255)

#define BACKBTN_X 52
#define BACKBTN_Y 698

#define EVENT_NONE 0
#define EVENT_BACK_CLICK 1
#define EVENT_LAUNCH_CLICK 2
#define EVENT_NEWCAPTAIN_SLOT0 100
#define EVENT_DELCAPTAIN_SLOT0 (EVENT_NEWCAPTAIN_SLOT0+CAPTAINSLOUNGE_NUMSLOTS)
#define EVENT_SELCAPTAIN_SLOT0 (EVENT_DELCAPTAIN_SLOT0+CAPTAINSLOUNGE_NUMSLOTS)
#define EVENT_SAVECAPTAIN_SLOT0 (EVENT_SELCAPTAIN_SLOT0+CAPTAINSLOUNGE_NUMSLOTS)

#define EVENT_CONFIRMDELCAPTAIN_YES 200
#define EVENT_CONFIRMDELCAPTAIN_NO  201

#define EVENT_CONFIRMSELCAPTAIN_YES 300
#define EVENT_CONFIRMSELCAPTAIN_NO  301

#define EVENT_CONFIRMSAVECAPTAIN_YES 400
#define EVENT_CONFIRMSAVECAPTAIN_NO  401

#define BTN_BASE_Y 200
#define BTN_DELTA_Y 96

#define BTN_NEWCAPTAIN_X 361
#define BTN_DELCAPTAIN_X 425
#define BTN_SELCAPTAIN_X 489
#define BTN_SAVECAPTAIN_X 577

#define SAVEFILE_FMT_STRING "saves/savegame-%d.dat"

#define GAME_BASE_Y 192
#define GAME_DELTA_Y 97
#define GAME_X 36

#define GAMES_TITLE_X 64
#define GAMES_TITLE_Y 100
#define TEXTHEIGHT_GAMES_TITLE 50

#define CURGAME_TITLE_X 690
#define CURGAME_TITLE_Y 192

#define YES_X 317
#define YES_Y 533
#define NO_X  620
#define NO_Y  533
#define EVENT_YES 1000
#define EVENT_NO  1001
#define TEXTHEIGHT_MODALPROMPT 40
#define MODALPROMPT_START_Y 230

#define MODALPROMPT_BG_X 69
#define MODALPROMPT_BG_Y 157


#define CAPTAINSLOUNGE_BACKGROUND_BMP    0        /* BMP  */
#define CAPTAINSLOUNGE_DEL_DISABLED_TGA  1        /* BMP  */
#define CAPTAINSLOUNGE_DEL_MOUSEOVER_TGA 2        /* BMP  */
#define CAPTAINSLOUNGE_DEL_TGA           3        /* BMP  */
#define CAPTAINSLOUNGE_MODALPROMPT_BACKGROUND_BMP 4        /* BMP  */
#define CAPTAINSLOUNGE_NO_BMP            5        /* BMP  */
#define CAPTAINSLOUNGE_NO_MOUSEOVER_BMP  6        /* BMP  */
#define CAPTAINSLOUNGE_PLUS_DISABLED_TGA 7        /* BMP  */
#define CAPTAINSLOUNGE_PLUS_MOUSEOVER_TGA 8        /* BMP  */
#define CAPTAINSLOUNGE_PLUS_TGA          9        /* BMP  */
#define CAPTAINSLOUNGE_SAVE_BMP          10       /* BMP  */
#define CAPTAINSLOUNGE_SAVE_MOUSEOVER_BMP 11       /* BMP  */
#define CAPTAINSLOUNGE_SEL_DISABLED_TGA  12       /* BMP  */
#define CAPTAINSLOUNGE_SEL_MOUSEOVER_TGA 13       /* BMP  */
#define CAPTAINSLOUNGE_SEL_TGA           14       /* BMP  */
#define CAPTAINSLOUNGE_YES_BMP           15       /* BMP  */
#define CAPTAINSLOUNGE_YES_MOUSEOVER_BMP 16       /* BMP  */
#define GENERIC_EXIT_BTN_NORM_BMP        17       /* BMP  */
#define GENERIC_EXIT_BTN_OVER_BMP        18       /* BMP  */

DATAFILE *cldata;



ModuleCaptainsLounge::ModuleCaptainsLounge(void)
{
  	m_requestedCaptainCreation = false;
	m_requestedCaptainCreationSlotNum = 0;
}

ModuleCaptainsLounge::~ModuleCaptainsLounge(void){}

bool ModuleCaptainsLounge::Init()
{

	BITMAP *btnNorm, *btnOver, *btnDis;

	g_game->SetTimePaused(true);	//game-time frozen in this module.

	//load the datafile
	cldata = load_datafile("data/captainslounge/captainslounge.dat");
	if (!cldata) {
		g_game->message("CaptainsLounge: Error loading datafile");
		return false;
	}


	//load the background
	m_background = (BITMAP*)cldata[CAPTAINSLOUNGE_BACKGROUND_BMP].dat;
	if (m_background == NULL) {
		g_game->message("Error loading captainslounge_background.bmp");
		return false;
	}

	btnNorm = (BITMAP*)cldata[GENERIC_EXIT_BTN_NORM_BMP].dat;
	btnOver = (BITMAP*)cldata[GENERIC_EXIT_BTN_OVER_BMP].dat;
	
    //create exit button
    m_backBtn = new Button(btnNorm, btnOver,NULL,
		BACKBTN_X,BACKBTN_Y,EVENT_NONE,EVENT_BACK_CLICK, g_game->font32, "Exit", BLACK);
	if (m_backBtn == NULL) return false;
	if (!m_backBtn->IsInitialized()) return false;

    //create launch button
    m_launchBtn = new Button(btnNorm, btnOver, NULL,
        BACKBTN_X+180, BACKBTN_Y,EVENT_NONE,EVENT_LAUNCH_CLICK, g_game->font32, "Launch", BLACK);
    if (m_launchBtn == NULL) return false;
    if (!m_launchBtn->IsInitialized()) return false;

	int y = BTN_BASE_Y;
	for (int i = 0; i < CAPTAINSLOUNGE_NUMSLOTS; i++)
	{
		btnNorm = (BITMAP*)cldata[CAPTAINSLOUNGE_PLUS_TGA].dat;
		btnOver = (BITMAP*)cldata[CAPTAINSLOUNGE_PLUS_MOUSEOVER_TGA].dat;
		btnDis = (BITMAP*)cldata[CAPTAINSLOUNGE_PLUS_DISABLED_TGA].dat;
		m_newCaptBtns[i] = new Button(btnNorm,btnOver,btnDis,
			BTN_NEWCAPTAIN_X,y,EVENT_NONE,EVENT_NEWCAPTAIN_SLOT0+i);
		if (m_newCaptBtns[i] == NULL) return false;
		if (!m_newCaptBtns[i]->IsInitialized()) return false;

		btnNorm = (BITMAP*)cldata[CAPTAINSLOUNGE_DEL_TGA].dat;
		btnOver = (BITMAP*)cldata[CAPTAINSLOUNGE_DEL_MOUSEOVER_TGA].dat;
		btnDis = (BITMAP*)cldata[CAPTAINSLOUNGE_DEL_DISABLED_TGA].dat;
		m_delCaptBtns[i] = new Button(btnNorm,btnOver,btnDis,
			BTN_DELCAPTAIN_X,y,EVENT_NONE,EVENT_DELCAPTAIN_SLOT0+i);
		if (m_delCaptBtns[i] == NULL) return false;
		if (!m_delCaptBtns[i]->IsInitialized()) return false;

		btnNorm = (BITMAP*)cldata[CAPTAINSLOUNGE_SEL_TGA].dat;
		btnOver = (BITMAP*)cldata[CAPTAINSLOUNGE_SEL_MOUSEOVER_TGA].dat;
		btnDis = (BITMAP*)cldata[CAPTAINSLOUNGE_SEL_DISABLED_TGA].dat;
		m_selCaptBtns[i] = new Button(btnNorm,btnOver,btnDis,
			BTN_SELCAPTAIN_X,y,EVENT_NONE,EVENT_SELCAPTAIN_SLOT0+i);
		if (m_selCaptBtns[i] == NULL)
			return false;
		if (!m_selCaptBtns[i]->IsInitialized())
			return false;

		btnNorm = (BITMAP*)cldata[CAPTAINSLOUNGE_SAVE_BMP].dat;
		btnOver = (BITMAP*)cldata[CAPTAINSLOUNGE_SAVE_MOUSEOVER_BMP].dat;
		m_saveCaptBtns[i] = new Button(btnNorm,btnOver,NULL,
			BTN_SAVECAPTAIN_X,y,EVENT_NONE,EVENT_SAVECAPTAIN_SLOT0+i);
		if (m_saveCaptBtns[i] == NULL)
			return false;
		if (!m_saveCaptBtns[i]->IsInitialized())
			return false;

		m_games[i] = NULL;

		y += BTN_DELTA_Y;
	}

	btnNorm = (BITMAP*)cldata[CAPTAINSLOUNGE_YES_BMP].dat;
	btnOver = (BITMAP*)cldata[CAPTAINSLOUNGE_YES_MOUSEOVER_BMP].dat;
	m_yesBtn = new Button(btnNorm, btnOver, NULL,YES_X,YES_Y,EVENT_NONE,EVENT_YES);
	if (!m_yesBtn->IsInitialized())	return false;


	btnNorm = (BITMAP*)cldata[CAPTAINSLOUNGE_NO_BMP].dat;
	btnOver = (BITMAP*)cldata[CAPTAINSLOUNGE_NO_MOUSEOVER_BMP].dat;
	m_noBtn = new Button(btnNorm, btnOver, NULL,NO_X,NO_Y,EVENT_NONE,EVENT_NO);
	if (!m_noBtn->IsInitialized()) return false;

	m_backBtn->OnMouseMove(0,0);
    m_launchBtn->OnMouseMove(0,0);
	for (int i = 0; i < CAPTAINSLOUNGE_NUMSLOTS; i++)
	{
		m_newCaptBtns[i]->OnMouseMove(0,0);
		m_delCaptBtns[i]->OnMouseMove(0,0);
		m_selCaptBtns[i]->OnMouseMove(0,0);
		m_saveCaptBtns[i]->OnMouseMove(0,0);
	}
	m_yesBtn->OnMouseMove(0,0);
	m_noBtn->OnMouseMove(0,0);

	if (m_requestedCaptainCreation)
	{
        string newcaptainfile = "saves/newcaptain.dat";
		if (exists(newcaptainfile.c_str()))
		{
			char buf[1024];
			sprintf(buf, SAVEFILE_FMT_STRING, m_requestedCaptainCreationSlotNum);
			string gameFile = buf;

			if (exists(gameFile.c_str()))
            {
			    delete_file(gameFile.c_str());
            }

			GameState * gs = GameState::LoadGame(newcaptainfile);
			if (gs != NULL)
			{
			    gs->SaveGame(gameFile);
			}

			delete_file(newcaptainfile.c_str());
		}

		m_requestedCaptainCreation = false;
	}


	//load audio files
	m_sndBtnClick = g_game->audioSystem->Load("data/captainslounge/buttonclick.ogg");
	if (!m_sndBtnClick) {
		g_game->message("Lounge: Error loading buttonclick");
		return false;
	}


	m_modalPromptActive = false;

	m_modalPromptBackground = (BITMAP*)cldata[CAPTAINSLOUNGE_MODALPROMPT_BACKGROUND_BMP].dat;
	if (m_modalPromptBackground == NULL) {
		g_game->message("Lounge: Error loading modelprompt background");
	    return false;
     }

	LoadGames();

	for (int i = 0; i < CAPTAINSLOUNGE_NUMSLOTS; i++)
	{
		m_saveCaptBtns[i]->SetVisible( g_game->gameState->m_captainSelected);
	}

	return true;
}

void ModuleCaptainsLounge::Close()
{
	//continue the stardate updates
	//g_game->gameState->stardate.paused = false;


	try {
		if (m_sndBtnClick != NULL)
		{
			m_sndBtnClick = NULL;
		}

		if (m_backBtn != NULL)
		{
			delete m_backBtn;
			m_backBtn = NULL;
		}
        if (m_launchBtn != NULL)
        {
            delete m_launchBtn;
            m_launchBtn = NULL;
        }

		for (int i = 0; i < CAPTAINSLOUNGE_NUMSLOTS; i++)
		{
			if (m_newCaptBtns[i] != NULL)
			{
				delete m_newCaptBtns[i];
				m_newCaptBtns[i] = NULL;
			}

			if (m_delCaptBtns[i] != NULL)
			{
				delete m_delCaptBtns[i];
				m_delCaptBtns[i] = NULL;
			}

			if (m_selCaptBtns[i] != NULL)
			{
				delete m_selCaptBtns[i];
				m_selCaptBtns[i] = NULL;
			}

			if (m_saveCaptBtns[i] != NULL)
			{
				delete m_saveCaptBtns[i];
				m_saveCaptBtns[i] = NULL;
			}

			if (m_games[i] != NULL)
			{
				delete m_games[i];
				m_games[i] = NULL;
			}
		}

		if (m_yesBtn != NULL)
		{
			delete m_yesBtn;
			m_yesBtn = NULL;
		}

		if (m_noBtn != NULL)
		{
			delete m_noBtn;
			m_noBtn = NULL;
		}

		//unload the data file (thus freeing all resources at once)
		unload_datafile(cldata);
		cldata = NULL;
	}
	catch(std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in CaptainsLounge::Close\n");
	}


}

void ModuleCaptainsLounge::Update(){}

void ModuleCaptainsLounge::Draw()
{
	static bool displayHelp = true;

	//draw background
	blit(m_background,g_game->GetBackBuffer(),0,0,0,0,screen->w,screen->h);

	m_backBtn->Run(g_game->GetBackBuffer());
    m_launchBtn->Run(g_game->GetBackBuffer());

	int x= CURGAME_TITLE_X, y= CURGAME_TITLE_Y;

	//alfont_set_font_size(m_font,TEXTHEIGHT_GAMES_TITLE);
	g_game->Print24(g_game->GetBackBuffer(), x,y-40,"SELECTED CAPTAIN",TEXTCOL);

	if ( g_game->gameState->m_captainSelected)
	{
		g_game->Print32(g_game->GetBackBuffer(), x,y, g_game->gameState->officerCap->name.c_str(),TEXTCOL);

		ostringstream str;
		str << "Profession: ";

		if ( g_game->gameState->m_profession == PROFESSION_SCIENTIFIC)
			str << "Scientific";
		else if ( g_game->gameState->m_profession == PROFESSION_FREELANCE)
			str << "Freelance";
		else if ( g_game->gameState->m_profession == PROFESSION_MILITARY)
			str << "Military";

		y += TEXTHEIGHT_GAME_NAME + 2;
		g_game->Print20(g_game->GetBackBuffer(),x,y,str.str().c_str(),TEXTCOL);

		y += TEXTHEIGHT_GAME_PROFESSION + 2;
		{
			y += TEXTHEIGHT_GAME_PROFESSION + 2;
			g_game->Print20(g_game->GetBackBuffer(),x,y,
							"Stardate: " + g_game->gameState->stardate.GetFullDateString(), TEXTCOL);
		}

		{
			ostringstream str;
			str << "Credits: " << g_game->gameState->m_credits;
			y += TEXTHEIGHT_GAME_PROFESSION + 2;
			g_game->Print20(g_game->GetBackBuffer(),x,y,str.str().c_str(),TEXTCOL);
		}

		{
			string str= g_game->gameState->getSavedModule();
			if (str == MODULE_CAPTAINCREATION)		str= "Captain Creation";
			else if (str == MODULE_CAPTAINSLOUNGE)	str= "Captain's Lounge";
			else if (str == MODULE_HYPERSPACE)		str= "Hyperspace";
			else if (str == MODULE_INTERPLANETARY)	str= "Interplanetary space";
			else if (str == MODULE_ORBIT)			str= "Planet Orbit";
			else if (str == MODULE_SURFACE)			str= "Planet Surface";
			else if (str == MODULE_PORT)			str= "Starport";
			else if (str == MODULE_STARPORT)		str= "Starport";

			str= "Current location: " +str;			y+= TEXTHEIGHT_GAME_PROFESSION +2;
			g_game->Print20(g_game->GetBackBuffer(), x,y, str.c_str(), TEXTCOL);
		}

		y += TEXTHEIGHT_GAME_PROFESSION + 4;
		{
			ostringstream str;
			str << "Ship: " << "MSS " << g_game->gameState->m_ship.getName();
			y += TEXTHEIGHT_GAME_PROFESSION + 2;
			g_game->Print20(g_game->GetBackBuffer(),x,y,str.str().c_str(),TEXTCOL);
		}

		{
			ostringstream str;
			str << "Cargo Pods: " << Util::ToString( g_game->gameState->m_ship.getCargoPodCount() );
			y += TEXTHEIGHT_GAME_PROFESSION + 2;
			g_game->Print20(g_game->GetBackBuffer(),x,y, str.str().c_str(),TEXTCOL);
		}

		{
			ostringstream str;
			str << "Engine: " << g_game->gameState->m_ship.getEngineClassString();
			//y += TEXTHEIGHT_GAME_PROFESSION + 2;
			g_game->Print20(g_game->GetBackBuffer(),x+150,y,str.str().c_str(),TEXTCOL);
		}

		{
			ostringstream str;
			str << "Armor: " << g_game->gameState->m_ship.getArmorClassString();
			y += TEXTHEIGHT_GAME_PROFESSION + 2;
			g_game->Print20(g_game->GetBackBuffer(),x,y,str.str().c_str(),TEXTCOL);
		}

		{
			ostringstream str;
			str << "Shields: " << g_game->gameState->m_ship.getShieldClassString();
			//y += TEXTHEIGHT_GAME_PROFESSION + 2;
			g_game->Print20(g_game->GetBackBuffer(),x+150,y,str.str().c_str(),TEXTCOL);
		}

		{
			ostringstream str;
			str << "Laser: " << g_game->gameState->m_ship.getLaserClassString();
			y += TEXTHEIGHT_GAME_PROFESSION + 2;
			g_game->Print20(g_game->GetBackBuffer(),x,y,str.str().c_str(),TEXTCOL);
		}

		{
			ostringstream str;
			str << "Missile: " << g_game->gameState->m_ship.getMissileLauncherClassString();
			//y += TEXTHEIGHT_GAME_PROFESSION + 2;
			g_game->Print20(g_game->GetBackBuffer(),x+150,y,str.str().c_str(),TEXTCOL);
		}

		{
			int dy= TEXTHEIGHT_GAME_PROFESSION +2;
			string str= g_game->gameState->officerSci->name;	y+= 2*dy;
			g_game->Print20(g_game->GetBackBuffer(), x,y, "Science: ", TEXTCOL);
			g_game->Print20(g_game->GetBackBuffer(), x+140,y, str.c_str(), TEXTCOL);

			str= g_game->gameState->officerNav->name;			y+= dy;
			g_game->Print20(g_game->GetBackBuffer(), x,y, "Navigation: ", TEXTCOL);
			g_game->Print20(g_game->GetBackBuffer(), x+140,y, str.c_str(), TEXTCOL);

			str= g_game->gameState->officerTac->name;			y+= dy;
			g_game->Print20(g_game->GetBackBuffer(), x,y, "Tactical: ", TEXTCOL);
			g_game->Print20(g_game->GetBackBuffer(), x+140,y, str.c_str(), TEXTCOL);

			str= g_game->gameState->officerEng->name;			y+= dy;
			g_game->Print20(g_game->GetBackBuffer(), x,y, "Engineering: ", TEXTCOL);
			g_game->Print20(g_game->GetBackBuffer(), x+140,y, str.c_str(), TEXTCOL);

			str= g_game->gameState->officerCom->name;			y+= dy;
			g_game->Print20(g_game->GetBackBuffer(), x,y, "Communications: ", TEXTCOL);
			g_game->Print20(g_game->GetBackBuffer(), x+140,y, str.c_str(), TEXTCOL);

			str= g_game->gameState->officerDoc->name;			y+= dy;
			g_game->Print20(g_game->GetBackBuffer(), x,y, "Medical: ", TEXTCOL);
			g_game->Print20(g_game->GetBackBuffer(), x+140,y, str.c_str(), TEXTCOL);
		}

		alfont_textout_centre(g_game->GetBackBuffer(),g_game->font24,"SAVE",BTN_SAVECAPTAIN_X+(m_selCaptBtns[0]->GetWidth()/2),BTN_BASE_Y-TEXTHEIGHT_BTN_TITLES-18,TEXTCOL);
	}
	else
	{
		g_game->Print32(g_game->GetBackBuffer(),x+62,y,"( None )",TEXTCOL);

		y += TEXTHEIGHT_GAME_NAME + 2;

		y += TEXTHEIGHT_GAME_PROFESSION + 2;
		g_game->Print20(g_game->GetBackBuffer(),x-33,y,"You may load an existing captain by",TEXTCOL);
		y += TEXTHEIGHT_GAME_PROFESSION + 2;
		g_game->Print20(g_game->GetBackBuffer(),x-33,y,"clicking on the target (load) button",TEXTCOL);
		y += TEXTHEIGHT_GAME_PROFESSION + 2;
		g_game->Print20(g_game->GetBackBuffer(),x-33,y,"beside a slot which contains an",TEXTCOL);
		y += TEXTHEIGHT_GAME_PROFESSION + 2;
		g_game->Print20(g_game->GetBackBuffer(),x-33,y,"existing captain.",TEXTCOL);

		y += TEXTHEIGHT_GAME_PROFESSION + 2;
		y += TEXTHEIGHT_GAME_PROFESSION + 2;
		g_game->Print20(g_game->GetBackBuffer(),x-33,y,"Or, you may create a new captain by",TEXTCOL);
		y += TEXTHEIGHT_GAME_PROFESSION + 2;
		g_game->Print20(g_game->GetBackBuffer(),x-33,y,"clicking on the + (new) button beside",TEXTCOL);
		y += TEXTHEIGHT_GAME_PROFESSION + 2;
		g_game->Print20(g_game->GetBackBuffer(),x-33,y,"an empty slot.",TEXTCOL);
	}

	y = GAME_BASE_Y;
	for (int i = 0; i < CAPTAINSLOUNGE_NUMSLOTS; i++)
	{
		m_newCaptBtns[i]->Run(g_game->GetBackBuffer());
		m_delCaptBtns[i]->Run(g_game->GetBackBuffer());
		m_selCaptBtns[i]->Run(g_game->GetBackBuffer());
		m_saveCaptBtns[i]->Run(g_game->GetBackBuffer());

		if (m_games[i] != NULL)
		{
			g_game->Print32(g_game->GetBackBuffer(),GAME_X,y,m_games[i]->officerCap->name.c_str(),TEXTCOL);

			string profName;
			if (m_games[i]->m_profession == PROFESSION_SCIENTIFIC)
				profName = "Scientific";
			else if (m_games[i]->m_profession == PROFESSION_FREELANCE)
				profName = "Freelance";
			else if (m_games[i]->m_profession == PROFESSION_MILITARY)
				profName = "Military";

			g_game->Print20(g_game->GetBackBuffer(),GAME_X,y + TEXTHEIGHT_GAME_NAME + 2,profName.c_str(),TEXTCOL);
		}
		else
		{
			g_game->Print32(g_game->GetBackBuffer(),GAME_X,y,"( EMPTY )",TEXTCOL);
		}

		y += GAME_DELTA_Y;
	}

	//modules should not be calling alfont functions directly--use the engine

	alfont_textout_centre(g_game->GetBackBuffer(),g_game->font24,"NEW",BTN_NEWCAPTAIN_X+(m_newCaptBtns[0]->GetWidth()/2),BTN_BASE_Y-TEXTHEIGHT_BTN_TITLES-18,TEXTCOL);
	alfont_textout_centre(g_game->GetBackBuffer(),g_game->font24,"DEL",BTN_DELCAPTAIN_X+(m_delCaptBtns[0]->GetWidth()/2),BTN_BASE_Y-TEXTHEIGHT_BTN_TITLES-18,TEXTCOL);
	alfont_textout_centre(g_game->GetBackBuffer(),g_game->font24,"LOAD",BTN_SELCAPTAIN_X+(m_selCaptBtns[0]->GetWidth()/2),BTN_BASE_Y-TEXTHEIGHT_BTN_TITLES-18,TEXTCOL);

	if (m_modalPromptActive)
	{
		blit(m_modalPromptBackground,g_game->GetBackBuffer(),0,0,MODALPROMPT_BG_X,MODALPROMPT_BG_Y,m_modalPromptBackground->w,m_modalPromptBackground->h);

		int y = MODALPROMPT_START_Y;
		for (vector<string>::iterator i = m_modalPromptStrings.begin(); i != m_modalPromptStrings.end(); ++i)
		{
			alfont_textout_centre(g_game->GetBackBuffer(),g_game->font32,(*i).c_str(),screen->w/2,y,TEXTCOL);
			y += TEXTHEIGHT_MODALPROMPT + 2;
		}

		m_yesBtn->Run(g_game->GetBackBuffer());
		m_noBtn->Run(g_game->GetBackBuffer());

		return;
	}

	//display tutorial help messages for beginners
	if ( displayHelp )
	{
    	if ( (g_game->gameState->firstTimeVisitor && g_game->gameState->getActiveQuest() <= 1) ) 
        {
		    displayHelp = false;
		    string str = "Welcome to the lounge, captain! This is where you can load and save your game. The panel on the right shows information about the game currently in play.";
		    g_game->ShowMessageBoxWindow("",  str, 400, 300, WHITE, 600, 400 );
        }
	}
}

void ModuleCaptainsLounge::OnKeyPress(int keyCode){}
void ModuleCaptainsLounge::OnKeyPressed(int keyCode){}
void ModuleCaptainsLounge::OnKeyReleased(int keyCode){}
void ModuleCaptainsLounge::OnMouseMove(int x, int y)
{
	if (m_modalPromptActive)
	{
		m_yesBtn->OnMouseMove(x,y);
		m_noBtn->OnMouseMove(x,y);

		return;
	}

	m_backBtn->OnMouseMove(x,y);
    m_launchBtn->OnMouseMove(x,y);

	for (int i = 0; i < CAPTAINSLOUNGE_NUMSLOTS; i++)
	{
		m_newCaptBtns[i]->OnMouseMove(x,y);
		m_delCaptBtns[i]->OnMouseMove(x,y);
		m_selCaptBtns[i]->OnMouseMove(x,y);
		m_saveCaptBtns[i]->OnMouseMove(x,y);
	}
}

void ModuleCaptainsLounge::OnMouseClick(int button, int x, int y){}
void ModuleCaptainsLounge::OnMousePressed(int button, int x, int y){}
void ModuleCaptainsLounge::OnMouseReleased(int button, int x, int y)
{

	if (m_modalPromptActive)
	{
		m_yesBtn->OnMouseReleased(button,x,y);
		m_noBtn->OnMouseReleased(button,x,y);

		return;
	}

	//heinous anus - avoiding -> on bad variables after leaving the module
	for (int i = 0; i < CAPTAINSLOUNGE_NUMSLOTS; i++)
	{
		m_delCaptBtns[i]->OnMouseReleased(button,x,y);
		m_selCaptBtns[i]->OnMouseReleased(button,x,y);
		m_saveCaptBtns[i]->OnMouseReleased(button,x,y);
		if(m_newCaptBtns[i]->OnMouseReleased(button,x,y) )
			return;
	}
	m_backBtn->OnMouseReleased(button,x,y);
    m_launchBtn->OnMouseReleased(button,x,y);
}

void ModuleCaptainsLounge::OnMouseWheelUp(int x, int y){}
void ModuleCaptainsLounge::OnMouseWheelDown(int x, int y){}
void ModuleCaptainsLounge::OnEvent(Event *event)
{
	bool playBtnClick = false;
	bool exitToStarportCommons = false;
    bool launchSavedModule = false;
	bool exitToCaptCreation = false;

	switch (event->getEventType())
	{
	case EVENT_BACK_CLICK:
		playBtnClick = true;
		exitToStarportCommons = true;
		break;
    case EVENT_LAUNCH_CLICK:
        playBtnClick = true;
        launchSavedModule = true;
        break;
	}

	if ((event->getEventType() >= EVENT_NEWCAPTAIN_SLOT0) &&
		(event->getEventType() < (EVENT_NEWCAPTAIN_SLOT0 + CAPTAINSLOUNGE_NUMSLOTS)))
	{
		// NEW captain
		m_requestedCaptainCreation = true;
		m_requestedCaptainCreationSlotNum = event->getEventType() - EVENT_NEWCAPTAIN_SLOT0;

		playBtnClick = true;
		exitToCaptCreation = true;
	}

	if ((event->getEventType() >= EVENT_DELCAPTAIN_SLOT0) &&
		(event->getEventType() < (EVENT_DELCAPTAIN_SLOT0 + CAPTAINSLOUNGE_NUMSLOTS)))
	{
		// DEL captain
		playBtnClick = true;

		// activate the confirmation modal prompt
		m_modalPromptActive = true;
		m_modalPromptStrings.clear();
		m_modalPromptStrings.push_back("Are you sure you want to delete this Captain?");
		m_modalPromptStrings.push_back("");
		m_modalPromptStrings.push_back(m_games[event->getEventType() - EVENT_DELCAPTAIN_SLOT0]->officerCap->name);
		m_modalPromptYesEvent = EVENT_CONFIRMDELCAPTAIN_YES;
		m_modalPromptNoEvent = EVENT_CONFIRMDELCAPTAIN_NO;
		m_modalPromptSlotNum = event->getEventType() - EVENT_DELCAPTAIN_SLOT0;

		m_yesBtn->OnMouseMove(0,0);
		m_noBtn->OnMouseMove(0,0);
	}

	// modal prompt responses
	if (event->getEventType() == EVENT_YES)
	{
		m_modalPromptActive = false;
		playBtnClick = true;
		Event e(m_modalPromptYesEvent);
		g_game->modeMgr->BroadcastEvent(&e);

		m_backBtn->OnMouseMove(0,0);
        m_launchBtn->OnMouseMove(0,0);
		for (int i = 0; i < CAPTAINSLOUNGE_NUMSLOTS; i++)
		{
			m_newCaptBtns[i]->OnMouseMove(0,0);
			m_delCaptBtns[i]->OnMouseMove(0,0);
			m_selCaptBtns[i]->OnMouseMove(0,0);
		}
	}

	if (event->getEventType() == EVENT_NO)
	{
		m_modalPromptActive = false;
		playBtnClick = true;
		Event e(m_modalPromptNoEvent);
		g_game->modeMgr->BroadcastEvent(&e);

		m_backBtn->OnMouseMove(0,0);
        m_launchBtn->OnMouseMove(0,0);
		for (int i = 0; i < CAPTAINSLOUNGE_NUMSLOTS; i++)
		{
			m_newCaptBtns[i]->OnMouseMove(0,0);
			m_delCaptBtns[i]->OnMouseMove(0,0);
			m_selCaptBtns[i]->OnMouseMove(0,0);
		}
	}

	if (event->getEventType() == EVENT_CONFIRMDELCAPTAIN_YES)
	{
		char buf[1024];
		sprintf(buf,SAVEFILE_FMT_STRING,m_modalPromptSlotNum);
		delete_file(buf);
		LoadGames();
	}

	if (event->getEventType() == EVENT_CONFIRMDELCAPTAIN_NO)
	{
		// user cancelled captain deletion request
	}

	if ((event->getEventType() >= EVENT_SELCAPTAIN_SLOT0) &&
		(event->getEventType() < (EVENT_SELCAPTAIN_SLOT0 + CAPTAINSLOUNGE_NUMSLOTS)))
	{
		// SEL captain
		playBtnClick = true;

		//activate the confirmation modal prompt if needed:
		//game state becomes dirty when we leave the captain's lounge
		//(and potentially go anywhere).
		if (g_game->gameState->dirty == true) {
			m_modalPromptActive = true;
			m_modalPromptStrings.clear();
			m_modalPromptStrings.push_back("Select this Captain?");
			m_modalPromptStrings.push_back("Progress in the Current Game will be lost.");
			m_modalPromptStrings.push_back("");
			m_modalPromptStrings.push_back(m_games[event->getEventType() - EVENT_SELCAPTAIN_SLOT0]->officerCap->name);
			m_modalPromptYesEvent = EVENT_CONFIRMSELCAPTAIN_YES;
			m_modalPromptNoEvent = EVENT_CONFIRMSELCAPTAIN_NO;
			m_modalPromptSlotNum = event->getEventType() - EVENT_SELCAPTAIN_SLOT0;

			m_yesBtn->OnMouseMove(0,0);
			m_noBtn->OnMouseMove(0,0);
		}
		else {
			m_modalPromptSlotNum = event->getEventType() - EVENT_SELCAPTAIN_SLOT0;
			event->setEventType(EVENT_CONFIRMSELCAPTAIN_YES);
		}
	}

	if (event->getEventType() == EVENT_CONFIRMSELCAPTAIN_YES)
	{
		char buf[1024];
		sprintf(buf,SAVEFILE_FMT_STRING,m_modalPromptSlotNum);
		GameState *lgs= GameState::LoadGame(buf);			//(lgs just a reference (testing) pointer)
		if (lgs == NULL) {g_game->message("CaptainsLounge: Error loading game save file."); }
		else {

            for (int i = 0; i < CAPTAINSLOUNGE_NUMSLOTS; i++)	
            {
				m_saveCaptBtns[i]->SetVisible(true);
            }

		}
	}

	if (event->getEventType() == EVENT_CONFIRMSELCAPTAIN_NO)
	{
		// user cancelled captain selection request
	}

	if ((event->getEventType() >= EVENT_SAVECAPTAIN_SLOT0) &&
		(event->getEventType() < (EVENT_SAVECAPTAIN_SLOT0 + 4 /*CAPTAINSLOUNGE_NUMSLOTS*/ )))
        /* prevent saving to the auto-save slot at the 5th position */
	{
		// SEL captain
		playBtnClick = true;

		// activate the confirmation modal prompt
		m_modalPromptActive = true;
		m_modalPromptStrings.clear();
		m_modalPromptStrings.push_back("Save this Captain?");
		m_modalPromptStrings.push_back("Existing Captain will be overwritten");
		m_modalPromptStrings.push_back("");
		m_modalPromptStrings.push_back( g_game->gameState->officerCap->name);
		m_modalPromptYesEvent = EVENT_CONFIRMSAVECAPTAIN_YES;
		m_modalPromptNoEvent = EVENT_CONFIRMSAVECAPTAIN_NO;
		m_modalPromptSlotNum = event->getEventType() - EVENT_SAVECAPTAIN_SLOT0;

		m_yesBtn->OnMouseMove(0,0);
		m_noBtn->OnMouseMove(0,0);
	}

	if (event->getEventType() == EVENT_CONFIRMSAVECAPTAIN_YES)
	{
		char buf[1024];
		sprintf(buf,SAVEFILE_FMT_STRING,m_modalPromptSlotNum);
		delete_file(buf);
		g_game->gameState->SaveGame(buf);
		LoadGames();
	}

	if (event->getEventType() == EVENT_CONFIRMSAVECAPTAIN_NO)
	{
		// user cancelled captain save request
	}

	if (playBtnClick)
	{
		g_game->audioSystem->Play(m_sndBtnClick);
	}

    //issue 181 resolved
    //this launches the module where the game was saved
    if (launchSavedModule)
    {
		//return player to previous saved mode:
		if (g_game->gameState->m_captainSelected == true) 
        {
			g_game->gameState->dirty = true;
			if (g_game->gameState->getSavedModule() == MODULE_CAPTAINSLOUNGE)
				g_game->modeMgr->LoadModule(MODULE_STARPORT);
			else
				g_game->modeMgr->LoadModule(g_game->gameState->getSavedModule());
		}
    }

    //issue 181 problem
    //this exits to the starport or the title screen
	else if (exitToStarportCommons) 
    {
		if (g_game->gameState->m_captainSelected == true) 
        {
			g_game->gameState->dirty = true;
            g_game->modeMgr->LoadModule(MODULE_STARPORT);
        }
		else 
			g_game->modeMgr->LoadModule(MODULE_TITLESCREEN);

		return;
	}
	else if (exitToCaptCreation) {
		g_game->modeMgr->LoadModule(MODULE_CAPTAINCREATION);
		return;
	}
}

void ModuleCaptainsLounge::LoadGames()
{
	for (int i = 0; i < CAPTAINSLOUNGE_NUMSLOTS; i++)
	{
		if (m_games[i] != NULL)
		{
			delete m_games[i];
			m_games[i] = NULL;
		}

		char buf[1024];
		sprintf(buf,SAVEFILE_FMT_STRING,i);
		string gameFile = buf;

		GameState *loadedGame= GameState::ReadGame(gameFile);
		m_games[i] = loadedGame;

		if (m_games[i] != NULL)
		{
			m_newCaptBtns[i]->SetEnabled(false);
			m_delCaptBtns[i]->SetEnabled(true);
			m_selCaptBtns[i]->SetEnabled(true);
		}
		else
		{
			m_newCaptBtns[i]->SetEnabled(true);
			m_delCaptBtns[i]->SetEnabled(false);
			m_selCaptBtns[i]->SetEnabled(false);
		}
	}
}

