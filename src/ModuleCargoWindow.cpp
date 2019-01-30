/*
	ModuleCargoWindow.cpp
	By Dave Calkins
	Extensive cleanup by Vincent Cappe

	Changelog:
	*	2009/10/08: vcap: Removed old changelog since it is not meaningful anymore.

*/

#include "env.h"
#include "DataMgr.h"
#include "ModeMgr.h"
#include "ModuleCargoWindow.h"
#include "Button.h"
#include "Events.h"
#include "ScrollBox.h"
#include "Game.h"
#include "GameState.h"
#include "AudioSystem.h"
#include <sstream>
#include "Label.h"
#include "Util.h"
#include "ModuleControlPanel.h"

//borders for the jettison button from data/cargohold/cargohold.dat
//NOTE: static.tga is not used anymore.
#define CARGO_BTN_BMP                 0         /* BMP  */
#define CARGO_BTN_MO_BMP              1         /* BMP  */

//the cargo window "skin" from data/cargohold/sideviewer.dat
#define GUI_VIEWER_BMP                0         /* BMP  */

//gui elements positioning, fonts settings...
#define PLAYERLIST_X                108
#define PLAYERLIST_Y                 52
#define PLAYERLIST_WIDTH            294
#define PLAYERLIST_HEIGHT           335
#define PLAYERLIST_NUMITEMS_WIDTH    50
#define PLAYERLIST_VALUE_WIDTH       80

#define CARGO_LIST_FONT_HEIGHT       18
#define CARGO_BUTTONS_FONT_HEIGHT    20
#define CARGO_JETTISON_X            315
#define CARGO_JETTISON_Y            390
#define CARGO_EXIT_X                115
#define CARGO_EXIT_Y                390

#define CARGO_SPACESTATUS_X         230
#define CARGO_SPACESTATUS_Y         390
#define CARGO_SPACESTATUS_HEIGHT     31
#define CARGO_SPACESTATUS_WIDTH      87

//events we generate (and handle)
#define PLAYERLIST_EVENT            501      /* player clicked on an item line */
#define CARGO_EVENT_JETTISON        502      /* player clicked on the jettison button */
//external events we handle
//	* EVENT_CAPTAIN_CARGO                    /* player asked the CargoWindow to show on/hide away */
//	* CARGO_EVENT_UPDATE                     /* inventory changed */


ModuleCargoWindow::ModuleCargoWindow()
{
	//from data/globals.lua (left=-440 right=-40 speed=12)
	gui_viewer_left = (int) g_game->getGlobalNumber("GUI_VIEWER_LEFT");
	gui_viewer_right = (int) g_game->getGlobalNumber("GUI_VIEWER_RIGHT");
	gui_viewer_speed = (int) g_game->getGlobalNumber("GUI_VIEWER_SPEED");

	initialized = false;

	cwdata                  = NULL;
	svdata                  = NULL;
	img_viewer              = NULL;

	m_items                 = NULL;
	m_playerItemsFiltered   = NULL;
	m_playerList            = NULL;
	m_playerListNumItems    = NULL;
	m_playerListValue       = NULL;

	m_jettisonButton        = NULL;
	m_sndButtonClick        = NULL;

	spaceStatus             = NULL;
}

ModuleCargoWindow::~ModuleCargoWindow()
{
}

bool ModuleCargoWindow::Init()
{
	TRACE("  ModuleCargoWindow: initializing...\n");

	//load the window "skin"
	svdata = load_datafile("data/cargohold/sideviewer.dat");
	if (!svdata) {
		g_game->message("CargoWindow: Error loading data/cargohold/sideviewer.dat");
		return false;
	}

	img_viewer = (BITMAP*)svdata[GUI_VIEWER_BMP].dat;
	if (img_viewer == NULL) {
		g_game->message("CargoWindow: Error loading gui_viewer.bmp from data/cargohold/sideviewer.dat");
		return false;
	}

	//jettison button
	cwdata = load_datafile("data/cargohold/cargohold.dat");
	if (!cwdata) {
		g_game->message("CargoWindow: Error loading data/cargohold/cargohold.dat");
		return false;
	}

	BITMAP *btnNorm, *btnOver;
	btnNorm = (BITMAP*)cwdata[CARGO_BTN_BMP].dat;
	btnOver = (BITMAP*)cwdata[CARGO_BTN_MO_BMP].dat;
	if (btnNorm == NULL || btnOver == NULL) {
		g_game->message("CargoWindow: Error loading button borders from data/cargohold/cargohold.dat");
		return false;
	}

	m_jettisonButton = new Button(
		btnNorm, btnOver, NULL,
		CARGO_JETTISON_X, CARGO_JETTISON_Y,
		EVENT_NONE, CARGO_EVENT_JETTISON,
		g_game->font20, "JETTISON", LTGREEN, "", true, false);
	
	if (!m_jettisonButton || !m_jettisonButton->IsInitialized())
		return false;


	//cargo capacity indicator
	maxSpace = g_game->gameState->m_ship.getTotalSpace();
	spaceStatus = new Label("", CARGO_SPACESTATUS_X, CARGO_SPACESTATUS_Y, CARGO_SPACESTATUS_WIDTH, CARGO_SPACESTATUS_HEIGHT, LTGREEN, g_game->font20);
	if (spaceStatus == NULL)
		return false;


	//the items list
	//NOTE: these three scrollboxes are linked. what this means among other things
	// is that calling the OnMouse* of one will call the other two. in our case we
	// are only interested in getting one and only one PLAYERLIST_EVENT when the
	// user click on an item line, hence the need to pass EVENT_NONE for the other
	// two.
	m_playerList = new ScrollBox::ScrollBox(
		g_game->font20,ScrollBox::SB_LIST,
		0, 0, PLAYERLIST_WIDTH, PLAYERLIST_HEIGHT,
		PLAYERLIST_EVENT);
	if (m_playerList == NULL)
		return false;

	m_playerListNumItems = new ScrollBox::ScrollBox(
		g_game->font20, ScrollBox::SB_LIST,
		0, 0, PLAYERLIST_VALUE_WIDTH+PLAYERLIST_NUMITEMS_WIDTH, PLAYERLIST_HEIGHT,
		EVENT_NONE);
	if (m_playerListNumItems == NULL)
		return false;

	m_playerListValue = new ScrollBox::ScrollBox(
		g_game->font20, ScrollBox::SB_LIST,
		0, 0, PLAYERLIST_VALUE_WIDTH, PLAYERLIST_HEIGHT,
		EVENT_NONE);
	if (m_playerListValue == NULL)
		return false;

	m_playerListNumItems->LinkBox(m_playerList);
	m_playerListValue->LinkBox(m_playerListNumItems);

	m_items = &g_game->gameState->m_items;
	m_playerItemsFiltered = new Items;
	
	//load audio files
	m_sndButtonClick = g_game->audioSystem->Load("data/cargohold/buttonclick.ogg");
	if (!m_sndButtonClick) {
		g_game->message("CargoWindow: Error loading buttonclick");
		return false;
	}

	//NOTE: initialized==true will tell UpdateLists() its data are properly set up.
	// This protection is necessary because some inventory changes can happen before
	// CargoWindow is initialized (e.g. encounter scripts Initialize function)
	initialized=true;

	//NOTE: This will call UpdateLists() among others, so all must be properly
	// initialized when calling this.
	this->InitViewer();

	TRACE("  ModuleCargoWindow: initialized\n");

	return true;
}

//NOTE: Right now, InitViewer() do the same thing as ResetViewer().
// The difference is that InitViewer() is private and intented to be called
// as part of our own Init(), while ResetViewer() is public and intented for
// use by others (e.g. our parent module).
void ModuleCargoWindow::InitViewer()
{
	this->ResetViewer();
}

/* Force the window into its starting (hidden) state */ 
void ModuleCargoWindow::ResetViewer()
{
	//start hidden
	m_x = gui_viewer_left;
	m_y = 10;
	sliding = false;
	sliding_offset = -gui_viewer_speed;

	if (initialized) {
		// update the content of the scrollbox to match current gamestate
		this->UpdateLists();
		//unselect previously selected line (if any)
		m_playerList->SetSelectedIndex(-1);
	}

	//hide the jettison button
	if (m_jettisonButton && m_jettisonButton->IsInitialized())
		m_jettisonButton->SetVisible(false);
}

/* Update the content of the scrollbox to match current gamestate */
void ModuleCargoWindow::UpdateLists()
{
	//update the lists only if between Init() and Close()
	if (!initialized) return;

	m_playerItemsFiltered->Reset();
	for (int i = 0; i < m_items->GetNumStacks(); i++)
	{
		Item item;
		int numItems;
		m_items->GetStack(i,item,numItems);
		m_playerItemsFiltered->AddItems(item.id,numItems);
	}

	m_playerList->Clear();
	m_playerList->setLines(m_playerItemsFiltered->GetNumStacks());
	m_playerListNumItems->Clear();
	m_playerListNumItems->setLines(m_playerItemsFiltered->GetNumStacks());
	m_playerListValue->Clear();
	m_playerListValue->setLines(m_playerItemsFiltered->GetNumStacks());
	for (int i = 0; i < m_playerItemsFiltered->GetNumStacks(); i++)
	{
		Item item;
		int numItems;
		m_playerItemsFiltered->GetStack(i,item,numItems);

		m_playerList->Write(item.name);
		m_playerListNumItems->Write(Util::ToString(numItems));
		m_playerListValue->Write(Util::ToString((int) item.value));
	}

	std::string space;
	int occupiedSpace = g_game->gameState->m_ship.getOccupiedSpace();
	space = Util::ToString(occupiedSpace) +"/"+ Util::ToString(maxSpace);

	spaceStatus->SetText(space);
	spaceStatus->Refresh();
}

void ModuleCargoWindow::OnEvent(Event * event)
{
	int ev = event->getEventType();
	//NOTE: uncommenting the following line can help a great deal when tracking bugs.
	//TRACE("CargoWindow: got event %d (0x%X)\n", ev, (unsigned int) ev);

	switch(ev)
	{

		//player asked the window to show on/hide away
		case EVENT_CAPTAIN_CARGO :
		{
			if (!sliding)
				sliding = true;
			sliding_offset = -sliding_offset;
			break;
		}

		//player clicked on an item line
		case PLAYERLIST_EVENT:
		{
			g_game->audioSystem->Play(m_sndButtonClick);

			if (m_playerList->GetSelectedIndex() >= 0)
				m_jettisonButton->SetVisible(true);
			else
				m_jettisonButton->SetVisible(false);
			break;
		}

		//player clicked on the jettison button
		case CARGO_EVENT_JETTISON:
		{
			g_game->audioSystem->Play(m_sndButtonClick);
			m_jettisonButton->SetVisible(false);

			int itemIdx = m_playerList->GetSelectedIndex();
			m_playerList->SetSelectedIndex(-1);
			Item item;
			int numItems;
			m_playerItemsFiltered->GetStack(itemIdx,item,numItems);
			m_items->RemoveItems(item.id,numItems);

			//notify everybody (include ourselves) that the inventory changed
			Event e(CARGO_EVENT_UPDATE);
			g_game->modeMgr->BroadcastEvent(&e);
			break;
		}

		//inventory changed due to either the jettison button or an external factor
		case CARGO_EVENT_UPDATE:
			this->UpdateLists();
			break;

		default:
		//NOTE: even after Close(), we still will get at least 0xDEADBEEF+3 and
		// 0xDEADBEEF+4 (Load/Quit) events, so be careful with what you put here.
		// Generally speaking, it's probably not a good idea to act upon events
		// you don't know anything about.
			break;
	}
}

void ModuleCargoWindow::Update()
{
	//shut off the window if not in "Captain mode"
	if( isVisible() &&
	    g_game->gameState->getCurrentSelectedOfficer() != OFFICER_CAPTAIN )
	{
		if (!sliding)
			sliding = true;
		if (sliding_offset != -gui_viewer_speed)
			sliding_offset = -gui_viewer_speed;
	}
}

void ModuleCargoWindow::Draw()
{
	//sliding the window
	if (sliding)
	{
		m_x += sliding_offset;

		//hitting the edges
		if (m_x < gui_viewer_left)
		{
			m_x = gui_viewer_left;
			sliding = false;
		}
		else if (m_x > gui_viewer_right)
		{
			m_x = gui_viewer_right;
			sliding = false;
		}
	}

	//return early since we are not visible
	if (!isVisible())
		return;

	//drawing the window
	masked_blit(img_viewer, g_game->GetBackBuffer(), 0, 0, m_x, m_y, img_viewer->w, img_viewer->h);

	//draw items list header
	g_game->Print20(g_game->GetBackBuffer(),108+m_x,32+m_y,"ITEM",LTGREEN,true);
	g_game->Print20(g_game->GetBackBuffer(),273+m_x,32+m_y,"QTY",LTGREEN,true);
	g_game->Print20(g_game->GetBackBuffer(),324+m_x,32+m_y,"VALUE",LTGREEN,true);

	//draw items list content
	m_playerList->SetX(PLAYERLIST_X+m_x);
	m_playerList->SetY(PLAYERLIST_Y+m_y);
	m_playerListNumItems->SetX(PLAYERLIST_X+m_x+PLAYERLIST_WIDTH-PLAYERLIST_VALUE_WIDTH-PLAYERLIST_NUMITEMS_WIDTH);
	m_playerListNumItems->SetY(PLAYERLIST_Y+m_y);
	m_playerListValue->SetX(PLAYERLIST_X+m_x+PLAYERLIST_WIDTH-PLAYERLIST_VALUE_WIDTH);
	m_playerListValue->SetY(PLAYERLIST_Y+m_y);
	m_playerListValue->Draw(g_game->GetBackBuffer());

	//draw jettison button
	int relX = m_jettisonButton->GetX();
	int relY = m_jettisonButton->GetY();
	m_jettisonButton->SetX(m_x+relX);
	m_jettisonButton->SetY(m_y+relY);
	m_jettisonButton->Run(g_game->GetBackBuffer());
	m_jettisonButton->SetX(relX);
	m_jettisonButton->SetY(relY);
 
	//draw capacity indicator
	int relX2 = spaceStatus->GetX();
	int relY2 = spaceStatus->GetY();
	spaceStatus->SetX(m_x + relX2);
	spaceStatus->SetY(m_y + relY2);
	spaceStatus->Draw(g_game->GetBackBuffer());
	spaceStatus->SetX(relX2);
	spaceStatus->SetY(relY2);
}

void ModuleCargoWindow::OnKeyPress( int keyCode ){}
void ModuleCargoWindow::OnKeyPressed(int keyCode){}
void ModuleCargoWindow::OnKeyReleased(int keyCode){}

void ModuleCargoWindow::OnMouseMove(int x, int y)
{
	if (!isVisible()) return;

	m_playerListValue->OnMouseMove(x+m_x, y+m_y);

	int relX = m_jettisonButton->GetX();
	int relY = m_jettisonButton->GetY();
	m_jettisonButton->SetX(m_x+relX);
	m_jettisonButton->SetY(m_y+relY);
	m_jettisonButton->OnMouseMove(x+m_x ,y+m_y);
	m_jettisonButton->SetX(relX);
	m_jettisonButton->SetY(relY);
}

void ModuleCargoWindow::OnMouseClick(int button, int x, int y)
{
	if (!isVisible()) return;
	m_playerListValue->OnMouseClick(button, x+m_x, y+m_y);
}

void ModuleCargoWindow::OnMousePressed(int button, int x, int y)
{
	if (!isVisible()) return;
	m_playerListValue->OnMousePressed(button, x+m_x, y+m_y);
}

void ModuleCargoWindow::OnMouseReleased(int button, int x, int y)
{
	if (!isVisible()) return;

	m_playerListValue->OnMouseReleased(button, x+m_x, y+m_y);

	int relX = m_jettisonButton->GetX();
	int relY = m_jettisonButton->GetY();
	m_jettisonButton->SetX(m_x+relX);
	m_jettisonButton->SetY(m_y+relY);
	m_jettisonButton->OnMouseReleased(button, x+m_x, y+m_y);
	m_jettisonButton->SetX(relX);
	m_jettisonButton->SetY(relY);
}

void ModuleCargoWindow::OnMouseWheelUp(int x, int y)
{
}

void ModuleCargoWindow::OnMouseWheelDown(int x, int y)
{
}

void ModuleCargoWindow::Close()
{
	TRACE("*** ModuleCargoWindow: closing...\n");

	//NOTE: this is needed to prevent some sort of race condition which will
	// cause the game to crash when leaving PlanetSurface for PlanetOrbit when
	// the CargoWindow is shown. I did not dig into it much yet but it probably
	// is related to Draw() (not event related in any case).
	// strictly speaking this is not needed anymore. the check for `initialized'
	// in IsVisible() will protect us against it, but i let this for documentation.
	this->ResetViewer();

	//will tell UpdateLists() the data it needs are not available.
	initialized = false;

	if (svdata != NULL) {
		//unload the data file (thus freeing all resources at once)
		unload_datafile(svdata);
		svdata = NULL;
	}

	if (cwdata != NULL) {
		//unload the data file (thus freeing all resources at once)
		unload_datafile(cwdata);
		cwdata = NULL;
	}

	m_items = NULL;

	if (m_playerItemsFiltered != NULL) {
		delete m_playerItemsFiltered;
		m_playerItemsFiltered = NULL;
	}

	if (m_playerListValue != NULL) {
		//this will destroy the other m_playerList* too, since they are linked.
		delete m_playerListValue;
		m_playerListValue = NULL;
	}

	if (m_jettisonButton != NULL) {
		delete m_jettisonButton;
		m_jettisonButton = NULL;
	}

	if (m_sndButtonClick != NULL) {
		delete m_sndButtonClick;
		m_sndButtonClick = NULL;
	}

	if ( spaceStatus != NULL) {
		delete spaceStatus;
		spaceStatus = NULL;
	}

	TRACE("*** ModuleCargoWindow: closed\n");
}
