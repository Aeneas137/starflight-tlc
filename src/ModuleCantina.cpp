///*
//	STARFLIGHT - THE LOST COLONY
//	ModuleCantina.cpp - ??
//	Author: Justin Sargent
//	Date: 11/17/07
//*/

#include "env.h"
#include "Util.h"
#include "ModuleCantina.h"
#include "AudioSystem.h"
#include "QuestMgr.h"
#include "Events.h"
#include "Game.h"
#include "DataMgr.h"
#include "ModeMgr.h"
#include "QuestMgr.h"
#include "Label.h"
using namespace std;


#define CANTINA_BACKGROUND_BMP           0        /* BMP  */
#define CANTINA_BTN_BMP                  1        /* BMP  */
#define CANTINA_BTN_DIS_BMP              2        /* BMP  */
#define CANTINA_BTN_HOV_BMP              3        /* BMP  */
#define CANTINA_EXIT_BTN_NORM_BMP        4        /* BMP  */
#define CANTINA_EXIT_BTN_OVER_BMP        5        /* BMP  */
#define MILITARYOPS_BACKGROUND_BMP       6        /* BMP  */
#define RESEARCHLAB_BACKGROUND_BMP       7        /* BMP  */

DATAFILE *candata;


#define EXITBTN_X 16
#define EXITBTN_Y 698

#define TURNINBTN_X EXITBTN_X + 176 + 40
#define TURNINBTN_Y EXITBTN_Y

#define WINDOW_X 198
#define WINDOW_Y 148
#define WINDOW_W 628
#define WINDOW_H 474

#define TITLE_X WINDOW_X
#define TITLE_Y WINDOW_Y
#define TITLE_H 60
#define TITLE_W WINDOW_W

#define REWARD_X WINDOW_X
#define REWARD_Y TITLE_Y + TITLE_H  //DETAIL_Y + DETAIL_H
#define REWARD_W WINDOW_W
#define REWARD_H 75

#define LONG_X WINDOW_X
#define LONG_Y REWARD_Y + REWARD_H
#define LONG_H 300
#define LONG_W WINDOW_W


#define EVENT_NONE 0
#define EVENT_EXIT_CLICK 1
#define EVENT_TURNIN_CLICK 7


ModuleCantina::ModuleCantina(void) {}

ModuleCantina::~ModuleCantina(void) 
{
	TRACE("ModuleCantina Dead\n");
}

void ModuleCantina::OnKeyPress(int keyCode)	{ }
void ModuleCantina::OnKeyPressed(int keyCode){}
void ModuleCantina::OnKeyReleased(int keyCode)
{
	switch (keyCode) 
	{
		case KEY_LCONTROL:
			break;

		case KEY_ESC: 
			//g_game->modeMgr->LoadModule(MODULE_STARPORT);
			//return;
			break;
	}
}
void ModuleCantina::OnMouseMove(int x, int y)					
{ 
	m_exitBtn->OnMouseMove(x,y);
	m_turninBtn->OnMouseMove(x,y);
}
void ModuleCantina::OnMouseClick(int button, int x, int y)	{ }
void ModuleCantina::OnMousePressed(int button, int x, int y){ }
void ModuleCantina::OnMouseReleased(int button, int x, int y)	
{ 
	m_turninBtn->OnMouseReleased(button,x,y);
	m_exitBtn->OnMouseReleased(button,x,y);
}
void ModuleCantina::OnMouseWheelUp(int x, int y){ }
void ModuleCantina::OnMouseWheelDown(int x, int y)	{}

void ModuleCantina::OnEvent(Event *event)
{
	switch (event->getEventType())
	{
		case EVENT_EXIT_CLICK:
			g_game->modeMgr->LoadModule(MODULE_STARPORT); return;
			break;

		case EVENT_TURNIN_CLICK:
			selectedQuestCompleted = true;
			break;
	}
}

void ModuleCantina::Close()
{
	try {
		if (m_exitBtn != NULL)
		{
			delete m_exitBtn;
			m_exitBtn = NULL;
		}
		if (m_turninBtn != NULL)
		{
			delete m_turninBtn;
			m_turninBtn = NULL;
		}

		//unload the data file (thus freeing all resources at once)
		unload_datafile(candata);
		candata = NULL;	
	}
	catch(std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in TitleScreen::Close\n");
	}
}

bool ModuleCantina::Init()
{
	TRACE("  Cantina/Research Lab/Military Ops Initialize\n");
	
	//load the datafile
	candata = load_datafile("data/cantina/cantina.dat");
	if (!candata) {
		g_game->message("Cantina: Error loading datafile");		
		return false;
	}
	
	selectedQuestCompleted = false;

	g_game->audioSystem->Load("data/cantina/buttonclick.ogg", "click");


	//Create and initialize the ESC button for the module
	BITMAP *btnNorm, *btnOver, *btnDis;
	
	btnNorm = (BITMAP*)candata[CANTINA_EXIT_BTN_NORM_BMP].dat;
	btnOver = (BITMAP*)candata[CANTINA_EXIT_BTN_OVER_BMP].dat;	
	m_exitBtn = new Button(btnNorm, btnOver, NULL,
		EXITBTN_X,EXITBTN_Y,EVENT_NONE,EVENT_EXIT_CLICK, g_game->font24, "Exit", BLACK,"click");
	if (m_exitBtn == NULL) return false;
	if (!m_exitBtn->IsInitialized()) return false;

	//load button images
	btnNorm = (BITMAP*)candata[CANTINA_BTN_BMP].dat;
	btnOver = (BITMAP*)candata[CANTINA_BTN_HOV_BMP].dat;	
	btnDis = (BITMAP*)candata[CANTINA_BTN_DIS_BMP].dat;

	//Create and initialize the TURNIN button for the module
	m_turninBtn = new Button(btnNorm, btnOver, btnDis, 
		TURNINBTN_X,TURNINBTN_Y,EVENT_NONE,EVENT_TURNIN_CLICK, 
		g_game->font24, "SUBMIT", BLACK, "click");
	if (m_turninBtn == NULL) return false;
	if (!m_turninBtn->IsInitialized()) return false;
	m_turninBtn->SetEnabled(true);


	//Load the background image based on profession
	switch (g_game->gameState->getProfession())
	{
		case PROFESSION_SCIENTIFIC:
			m_background = (BITMAP*)candata[RESEARCHLAB_BACKGROUND_BMP].dat;			
			m_turninBtn->SetButtonText("Breakthrough!");
			m_exitBtn->SetButtonText("Terminate");
			label1 = "PROJECT TITLE";
			label2 = "DESCRIPTION";
			//label3 = "REQUIREMENTS";
			label4 = "REWARD";
			labelcolor = LTBLUE;
			textcolor = DODGERBLUE;
			break;
		case PROFESSION_MILITARY:
			m_background = (BITMAP*)candata[MILITARYOPS_BACKGROUND_BMP].dat;			
			m_turninBtn->SetButtonText("Accomplished!");
			m_exitBtn->SetButtonText("Dismissed");
			label1 = "MISSION CODENAME";
			label2 = "DESCRIPTION";
			//label3 = "REQUIREMENTS";
			label4 = "REWARD";
			labelcolor = ORANGE;
			textcolor = DKORANGE;
			break;
		default:
			m_background = (BITMAP*)candata[CANTINA_BACKGROUND_BMP].dat;			
			m_turninBtn->SetButtonText("Pay Up!");
			m_exitBtn->SetButtonText("Scram");
			label1 = "JOB NAME";
			label2 = "DESCRIPTION";
			//label3 = "REQUIREMENTS";
			label4 = "REWARD";
			labelcolor = LTYELLOW;
			textcolor = YELLOW;
			break;
	}
	if (!m_background) {
		g_game->message("Error loading cantina background");
		return false;
	}


	//create labels
	questTitle = new Label("" , TITLE_X, TITLE_Y+23, TITLE_W, TITLE_H, textcolor, g_game->font22);
	questTitle->Refresh();

	questLong = new Label("", LONG_X, LONG_Y+23, LONG_W, LONG_H, textcolor, g_game->font22);
	questLong->Refresh();

	//questDetails = new Label("", DETAIL_X, DETAIL_Y+23, DETAIL_W, DETAIL_H, textcolor, g_game->font22);
	//questDetails->Refresh();

	questReward = new Label("", REWARD_X, REWARD_Y+23, REWARD_W, REWARD_H, textcolor, g_game->font22);
	questReward->Refresh();


	return true;
}


void ModuleCantina::Update()
{
	static int debriefStatus = 0;

    
    //HACK!!!!!
    //if player acquires Hypercube, then skip to the 25th quest as a shortcut
    //note: this is dangerous since the quest script could change the quest numbering

    //if already at quest 25, then skip the hypercube check again...
    if (g_game->questMgr->getId() != 25)
    {
        Item newitem;
        int amt;
	    g_game->gameState->m_items.Get_Item_By_ID( 2 /* Hypercube */, newitem, amt);
        if (amt > 0) {
            g_game->questMgr->getQuestByID(25);
            g_game->gameState->m_items.RemoveItems( 2, 1 );
            selectedQuestCompleted = true;
        }
    }

	g_game->questMgr->getActiveQuest();
	questTitle->SetText( g_game->questMgr->getName() );
	questTitle->Refresh();
	string desc = g_game->questMgr->getLong();
	int len = (int)desc.length();

	//dynamically change font size for long descriptions

	//1175 chars is absolute limit for this font
	if (len > 1175) {
		desc = desc.substr(0, 1172) + "...";
	}

	if (len > 1000) {
		questLong->SetFont( g_game->font18 );
	}
	else if (len > 800) {
			questLong->SetFont( g_game->font20 );
		}
	else
		questLong->SetFont( g_game->font22 );
	
	questLong->SetText( desc );
	questLong->Refresh();


	//show requirement status
    if (!selectedQuestCompleted)
    {
        int reqAmt= (int) g_game->questMgr->questReqAmt;
	    g_game->questMgr->VerifyRequirements( g_game->questMgr->questReqCode, g_game->questMgr->questReqType, reqAmt );
    }
	if (g_game->gameState->getQuestCompleted())
	{
		requirementLabel = "(COMPLETE)";
		requirementColor = GREEN;
		m_turninBtn->SetEnabled(true);
	}
	else {
		requirementLabel = "(INCOMPLETE)";
		requirementColor = RED;
		m_turninBtn->SetEnabled(false);
	}

	//do we need to show the debriefing and reward?
	if (selectedQuestCompleted) debriefStatus = 1;
	if (debriefStatus == 1) 
	{
		if (g_game->questMgr->getDebrief().length() > 0) 
		{
			g_game->ShowMessageBoxWindow("", g_game->questMgr->getDebrief(), 350, 300, WHITE, 650, 440, false);
		}
		selectedQuestCompleted = false;
		debriefStatus = 2;
	}
	else if (debriefStatus == 2)
	{
        g_game->questMgr->giveReward();
		debriefStatus = 3;
	}
	else if (debriefStatus == 3)
	{
		g_game->gameState->setQuestCompleted(false);
		g_game->questMgr->getNextQuest();
		debriefStatus = 0;
	}

}

void ModuleCantina::Draw()
{
	Item *item=NULL;
	int id;

	//draw background
	blit(m_background, g_game->GetBackBuffer(), 0, 0, 0, 0, m_background->w, m_background->h);

	//draw buttons
	m_exitBtn->Run(g_game->GetBackBuffer());
	m_turninBtn->Run(g_game->GetBackBuffer());

	//draw labels
	//title
	g_game->Print24(g_game->GetBackBuffer(), TITLE_X, TITLE_Y, label1, labelcolor);
	questTitle->Draw(g_game->GetBackBuffer());
	g_game->Print24(g_game->GetBackBuffer(), TITLE_X + 470, TITLE_Y, requirementLabel, requirementColor);

	//description
	g_game->Print24(g_game->GetBackBuffer(), LONG_X, LONG_Y, label2, labelcolor);
	questLong->Draw(g_game->GetBackBuffer());

	//rewards
	g_game->Print24(g_game->GetBackBuffer(), REWARD_X, REWARD_Y, label4, labelcolor);
	questReward->Draw(g_game->GetBackBuffer());

	//display reward info
	string reward = "";
	int amt = 0;
	switch ( g_game->questMgr->questRewCode )
	{
	//1 = money
	case 1:
		amt = (int) g_game->questMgr->questRewAmt;
		reward = Util::ToString(amt, 1, 0) + " MU";
		break;

	//2 = item
	case 2:
		amt = (int) g_game->questMgr->questRewAmt;
		id = g_game->questMgr->questRewType;
		item = g_game->dataMgr->GetItemByID( id );
		if (item) {
			reward = item->name + " - " + Util::ToString( amt, 1, 2 ) + " cubic meters" ;
		}
		else reward = "";
		break;
	}
	
	questReward->SetText(reward);
	questReward->Refresh();
}

