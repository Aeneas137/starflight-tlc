/*
	STARFLIGHT - THE LOST COLONY
	ModuleInterstellarTravel.cpp - Handles interstellar space travel in the main window
	Author: J.Harbour
	Date: January, 2007
*/

#pragma region HEADER

#include <sstream>
#include <string>
#include <exception>
#include "env.h"
#include "ModuleInterplanetaryTravel.h"
#include "Button.h"
#include "ModeMgr.h"
#include "GameState.h"
#include "Util.h"
#include "Events.h"
#include "Game.h"
#include "ModuleControlPanel.h"
#include "Label.h"
#include "QuestMgr.h"
#include "PauseMenu.h"

using namespace std;

#define GUI_AUX_BMP                      0        /* BMP  */
#define GUI_VIEWER_BMP                   1        /* BMP  */
#define IP_TILES_BMP                     2        /* BMP  */
#define IS_TILES_BMP                     3        /* BMP  */
#define SHIELD_TGA                       4        /* BMP  */
#define STARFIELD_BMP                    5        /* BMP  */


//scroller properties
#define PLANET_SCROLL_X		0
#define PLANET_SCROLL_Y		0
#define PLANET_SCROLL_WIDTH	SCREEN_WIDTH
#define PLANET_SCROLL_HEIGHT SCREEN_HEIGHT
#define PLANETTILESIZE 256
#define PLANETTILESACROSS 100
#define PLANETTILESDOWN 100

const int FlyingHoursBeforeSkillUp = 168;

ModuleInterPlanetaryTravel::ModuleInterPlanetaryTravel(void){}
ModuleInterPlanetaryTravel::~ModuleInterPlanetaryTravel(void){}

#pragma endregion

#pragma region INPUT

void ModuleInterPlanetaryTravel::OnKeyPress(int keyCode)
{
    //Note: fuel consumption in a star system should be negligible since its the impulse engine
    //whereas we're using the hyperspace engine outside the system
	switch (keyCode) {
		case KEY_RIGHT:
			flag_nav = false;
			ship->turnright();
			break;
		case KEY_LEFT:
			flag_nav = false;
			ship->turnleft();
			break;
		case KEY_DOWN:
			flag_nav = false;
			ship->applybraking();
			break;
		case KEY_UP:
			flag_nav = flag_thrusting = true;
			ship->applythrust();
			g_game->gameState->m_ship.ConsumeFuel();
			break;
		case KEY_Q:
			flag_nav = true;
			if (!flag_thrusting) ship->applybraking();
			ship->starboard();
			g_game->gameState->m_ship.ConsumeFuel();
			break;
		case KEY_E:
			flag_nav = true;
			if (!flag_thrusting) ship->applybraking();
			ship->port();
			g_game->gameState->m_ship.ConsumeFuel();
			break;

	}
}


void ModuleInterPlanetaryTravel::OnKeyPressed(int keyCode)
{
}

void ModuleInterPlanetaryTravel::OnKeyReleased(int keyCode)
{
	Module::OnKeyReleased(keyCode);

	switch (keyCode) {

		//reset ship anim frame when key released
		case KEY_LEFT:
		case KEY_RIGHT:
		case KEY_DOWN:
			flag_nav = false;
            ship->cruise();
			break;

		case KEY_UP:
			flag_nav = flag_thrusting = false;
			ship->applybraking();
			ship->cruise();
			break;

		case KEY_Q:
		case KEY_E:
			flag_nav = false;
			ship->applybraking();
			ship->cruise();	
			break;

	}
}

void ModuleInterPlanetaryTravel::OnMouseMove(int x, int y)
{
	Module::OnMouseMove(x,y);
	text->OnMouseMove(x,y);

	//*** need to add a flag that skips all this time consuming code unless mouse is actually in
	// the aux window for the planet name tooltip to be useful

	//check if mouse is over a planet

//debug
	
	std::string dian4 = "";

	for (int i = 0; i < star->GetNumPlanets(); i++)  {
		int planet = planets[i].tilenum;
		if (planet > 0) {
			//the various negative offsets after the parenthetised expressions are mere empirical tweaks, so don't expect too much of them
			if(x > (asx + planets[i].tilex * 2.3)-4 - planets[i].radius  && x < (asx + planets[i].tilex * 2.3)-2 + planets[i].radius
			&& y > (asy + planets[i].tiley * 2.3)-2 - planets[i].radius &&  y < (asy + planets[i].tiley * 2.3) + planets[i].radius){
				planet_label->SetX( x + 10);
				planet_label->SetY( y );
				planet_label->SetText( star->GetPlanetByID(planets[i].planetid)->name );	//jjh

				dian4 = star->GetPlanetByID(planets[i].planetid)->name ;

				m_bOver_Planet = true;
				break;
			}else{
				m_bOver_Planet = false;
			}
		}
	}
	//check if mouse is over a star
	if(m_bOver_Planet == false){
		int systemCenterTileX = scroller->getTilesAcross() / 2;
		int systemCenterTileY = scroller->getTilesDown() / 2;
		if(x > (asx + systemCenterTileX * 2.3)-6  && x < (asx + systemCenterTileX * 2.3)+6
		&& y > (asy + systemCenterTileY * 2.3)-6 &&  y < (asy + systemCenterTileY * 2.3)+6){
			planet_label->SetX( x + 10);
			planet_label->SetY( y );
			planet_label->SetText( star->name );
			m_bOver_Planet = true;
		}else{
			m_bOver_Planet = false;
		}
	}
}

void ModuleInterPlanetaryTravel::OnMouseClick(int button, int x, int y)
{
	Module::OnMouseClick(button,x,y);
	text->OnMouseClick(button,x,y);
}

void ModuleInterPlanetaryTravel::OnMousePressed(int button, int x, int y)
{
	Module::OnMousePressed(button, x, y);
	text->OnMousePressed(button,x,y);
}

void ModuleInterPlanetaryTravel::OnMouseReleased(int button, int x, int y)
{
	Module::OnMouseReleased(button, x, y);
	text->OnMouseReleased(button,x,y);
}

void ModuleInterPlanetaryTravel::OnMouseWheelUp(int x, int y)
{
	Module::OnMouseWheelUp(x, y);
	text->OnMouseWheelUp(x,y);
}

void ModuleInterPlanetaryTravel::OnMouseWheelDown(int x, int y)
{
	Module::OnMouseWheelDown(x, y);
	text->OnMouseWheelDown(x,y);
}

#pragma endregion

void ModuleInterPlanetaryTravel::OnEvent(Event * event)
{
	Ship ship;
	std::string escape = "";

	int evtype = event->getEventType();
	switch(evtype) {
		case 0xDEADBEEF + 2: //save game
			g_game->gameState->AutoSave();
			g_game->printout(text, "<Game Saved>", WHITE, 5000);
			break;
		case 0xDEADBEEF + 3: //load game
			g_game->gameState->AutoLoad();
			break;
		case 0xDEADBEEF + 4: //quit game
			g_game->setVibration(0);
			escape = g_game->getGlobalString("ESCAPEMODULE");
			g_game->modeMgr->LoadModule(escape);
			break;

		case EVENT_CAPTAIN_LAUNCH:   g_game->printout(text, nav + "Sir, we are not on a planet.",       BLUE,8000); break;
		case EVENT_CAPTAIN_DESCEND:  g_game->printout(text, nav + "Sir, we are not orbiting a planet.", BLUE,8000); break;
		//case EVENT_CAPTAIN_LOG:      g_game->printout(text, "<Log planet not yet implemented>", YELLOW,8000);       break;
		case EVENT_CAPTAIN_QUESTLOG: break;

		case EVENT_SCIENCE_SCAN:     g_game->printout(text, sci + "Sir, we are not near any planets or vessels.", BLUE,8000); break;
		case EVENT_SCIENCE_ANALYSIS: g_game->printout(text, sci + "Sir, I have not scanned anything.",            BLUE,8000); break;

		case EVENT_NAVIGATOR_ORBIT:      flag_DoOrbit      = true; break;
		case EVENT_NAVIGATOR_DOCK:       flag_DoDock       = true; break;
		case EVENT_NAVIGATOR_HYPERSPACE: flag_DoHyperspace = true; break;

		case EVENT_TACTICAL_COMBAT:  g_game->printout(text, tac + "Sir, we are not in range of any other ships.", BLUE,8000); break;
		case EVENT_TACTICAL_SHIELDS: g_game->printout(text, tac + "Sir, we are not in combat.", BLUE,8000); break;
		case EVENT_TACTICAL_WEAPONS: g_game->printout(text, tac + "Sir, we are not in combat.", BLUE,8000); break;

		case EVENT_ENGINEER_REPAIR:  break;
		case EVENT_ENGINEER_INJECT:  g_game->gameState->getShip().injectEndurium(); break;

		case EVENT_COMM_HAIL:        g_game->printout(text, com + "We are not in range of any other ships.", BLUE,8000); break;
		case EVENT_COMM_STATEMENT:   g_game->printout(text, com + "We are not communicating with anyone!",   BLUE,8000); break;
		case EVENT_COMM_QUESTION:    g_game->printout(text, com + "We are not communicating with anyone!",   BLUE,8000); break;
		case EVENT_COMM_POSTURE:     g_game->printout(text, com + "We are not communicating with anyone!",   BLUE,8000); break;
		case EVENT_COMM_TERMINATE:   g_game->printout(text, com + "We are not communicating with anyone!",   BLUE,8000); break;
		case EVENT_COMM_DISTRESS:    g_game->gameState->m_ship.SendDistressSignal(); break;

		case EVENT_DOCTOR_EXAMINE:	break;
		case EVENT_DOCTOR_TREAT:	break;

		default: break;
	}
}

#pragma region INIT_CLOSE

void ModuleInterPlanetaryTravel::Close()
{
	TRACE("*** Interplanetary Closing\n\n");

	try {
		if (text != NULL){
		  delete text;
		  text = NULL;
		}
		delete scroller;
		delete ship;

		if (planet_label != NULL){
			delete planet_label;
			planet_label = NULL;
		}

		//unload the data file (thus freeing all resources at once)
		unload_datafile(ipdata);
		ipdata = NULL;
	}
	catch(std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in InterplanetaryTravel::Close\n");
	}

}

bool ModuleInterPlanetaryTravel::Init()
{
	g_game->SetTimePaused(false);	//game-time normal in this module.

	TRACE("  Interplanetary Initialize\n");


	//enable the Pause Menu
	g_game->pauseMenu->setEnabled(true);


	//load the datafile
	ipdata = load_datafile("data/spacetravel/spacetravel.dat");
	if (!ipdata) {
		g_game->message("Interplanetary: Error loading datafile");
		return false;
	}


	//reset flags
	flag_nav = flag_thrusting = false;

	planetFound = 0;
	distance = 0.0f;
	flag_DoOrbit = false;
	flag_DoHyperspace = false;
	flag_DoDock = false;
	asx = 0; asy = 0;
	distressSignal = false;
	burning = 0;
	g_game->setVibration(0);
	m_bOver_Planet = false;
	planet_label = new Label("",0,0,100,22,ORANGE,g_game->font18);


	//create the ScrollBox for message window
	static int gmx = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_X");
	static int gmy = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_Y");
	static int gmw = (int)g_game->getGlobalNumber("GUI_MESSAGE_WIDTH");
	static int gmh = (int)g_game->getGlobalNumber("GUI_MESSAGE_HEIGHT");

	text = new ScrollBox::ScrollBox(g_game->font20, ScrollBox::SB_TEXT,
		gmx + 38, gmy + 18, gmw - 38, gmh - 32, 999);
	text->DrawScrollBar(false);

	//point global scrollbox to local one in this module for sub-module access
	g_game->g_scrollbox = text;


	//create tile scroller object
	scroller = new TileScroller();
	scroller->setTileSize(PLANETTILESIZE,PLANETTILESIZE);
	scroller->setTileImageColumns(9);
	scroller->setRegionSize(PLANETTILESACROSS,PLANETTILESDOWN);

	BITMAP *tileImage = (BITMAP*)ipdata[IP_TILES_BMP].dat;
	if (!tileImage) {
		g_game->message("***Interplanetary: Error loading ip_tiles.bmp");
		return false;
	}
	scroller->setTileImage(tileImage);

	if (!scroller->createScrollBuffer(PLANET_SCROLL_WIDTH, PLANET_SCROLL_HEIGHT)) {
		g_game->message("Interplanetary: Error creating scroll buffer");
		return false;
	}

	//create the ship sprite
	ship = new PlayerShipSprite();
	ship->allstop();


	//try to read star system data...
	star = g_game->dataMgr->GetStarByID(g_game->gameState->player->currentStar);
	if (!star) {
		g_game->message("Interplanetary: Error locating star system!");
		return false;
	}

	//create a tile map of this star system
	loadStarSystem(g_game->gameState->player->currentStar);

	//set player's location
	scroller->setScrollPosition( g_game->gameState->player->posSystem);


	//notify questmgr that star system has been entered
	g_game->questMgr->raiseEvent(10, g_game->gameState->player->currentStar);

	//shortcuts to crew last names to simplify code
	com = "Com. Off. " + g_game->gameState->getCurrentCom()->getLastName() + "-> ";
	sci = "Sci. Off. " + g_game->gameState->getCurrentSci()->getLastName() + "-> ";
	nav = "Nav. Off. " + g_game->gameState->getCurrentNav()->getLastName() + "-> ";
	tac = "Tac. Off. " + g_game->gameState->getCurrentTac()->getLastName() + "-> ";
	eng = "Eng. Off. " + g_game->gameState->getCurrentEng()->getLastName() + "-> ";
	doc = "Med. Off. " + g_game->gameState->getCurrentDoc()->getLastName() + "-> ";

	return true;
}

#pragma endregion

bool ModuleInterPlanetaryTravel::checkSystemBoundary(int x,int y)
{
	int leftEdge = 0;
	int rightEdge = scroller->getTilesAcross() * scroller->getTileWidth();
	int topEdge = 0;
	int bottomEdge = scroller->getTilesDown() * scroller->getTileHeight();

	//if ship reaches edge of system, exit to interstellar space
	if (x < leftEdge || x > rightEdge || y < topEdge || y > bottomEdge) return false;

	return true;
}

void ModuleInterPlanetaryTravel::Update()
{
	static Timer timerHelp;
	std::ostringstream s;

	//update the ship's position based on velocity
	float fx = g_game->gameState->player->posSystem.x + (ship->getVelocityX() * 6);
	float fy = g_game->gameState->player->posSystem.y + (ship->getVelocityY() * 6);

	//exit star system when edge is reached
	if (!checkSystemBoundary((int)fx,(int)fy))
	{
		ship->allstop();
		flag_DoHyperspace = true;
		return;
	}

	//store ship position
	g_game->gameState->player->posSystem.x = fx;
	g_game->gameState->player->posSystem.y = fy;

	//update scrolling and draw tiles on the scroll buffer
	scroller->setScrollPosition(fx, fy);
	scroller->updateScrollBuffer();

	//check if any planet is located near ship
	checkShipPosition();


	//display some text
	//text->Clear();
	//alfont_set_font_size(g_game->font10, 20);

	//reset vibration danger value
	g_game->setVibration(0);

	//display any planet under ship
	if (planetFound) {
		if (planet->name.length() > 0)
		{
			s << nav << "Captain, we are in orbital range of " << planet->name << ".";
		}
		else
		{
			s << nav << "Captain, planet " << planet->name << " is not in our data banks.";
		}
		g_game->printout(text, s.str() + " Awaiting order to establish orbit.", ORANGE, 15000);
	}
	//getting too close to the star?
	else if (burning) {
		if (burning > 240) {
			g_game->setVibration(20);
			g_game->printout(text, "AAARRRRRGGGGHHHHH!!!", YELLOW,500);
			ship->allstop();
			if ( Util::ReentrantDelay(2000)) {
				g_game->setVibration(0);
				g_game->modeMgr->LoadModule(MODULE_GAMEOVER);
				return;
			}
		}
		else if (burning > 160) {
			g_game->setVibration(14);
			g_game->printout(text, sci + "Hull temperature is critical!", RED,8000);
		}
		else if (burning > 80) {
			g_game->setVibration(10);
			g_game->printout(text, sci + "Hull temperature is rising!", ORANGE,8000);
		}
		else if (burning > 2) {
			g_game->setVibration(6);
			g_game->printout(text, sci + "Captain! We're getting too close!", ORANGE,8000);
		}
		else if (burning == 2) {
			g_game->setVibration(4);
			g_game->printout(text, nav + "Sir, we must keep our distance from the sun.", LTGREEN,8000);
		}
		else {
			g_game->setVibration(2);
			g_game->printout(text, nav + "Captain, we should steer clear of the sun.", LTGREEN,8000);
		}

	}


	//when player tells navigator to orbit planet, we want to display a message before immediately
	//launching the planet orbit module. this displays the message and pauses for 2 seconds.
	if (flag_DoOrbit) {
      checkShipPosition();
      if (!planetFound) {
		   g_game->printout(text, nav + "Unable to comply. Nothing to orbit here.", ORANGE,8000);
		   if ( Util::ReentrantDelay(2000)) {
			   flag_DoOrbit = false;
		   }
      } else {
		   g_game->printout(text, nav + "Aye, captain.", ORANGE,8000);
		   text->ScrollToBottom();
		   if ( Util::ReentrantDelay(2000)) {
			   g_game->printout(text, nav + "Entering orbital trajectory.", ORANGE,2000);
			   g_game->modeMgr->LoadModule(MODULE_ORBIT);
				return;
		   }
      }
	}


	//player orders navigator to exit system back into hyperspace   
	//use delay mechanism to show message before lauching module
    //this also occurs if player reaches edge of star system
	if (flag_DoHyperspace)
	{
		Ship ship = g_game->gameState->getShip();    
		//float fuelUsage = 0.025;

		if(g_game->gameState->player->hasHyperspacePermit() == false){
			g_game->printout(text, nav + "Captain, we can't enter hyperspace without a hyperspace permit.", ORANGE,30000);
			if (Util::ReentrantDelay(2000)) {
				flag_DoHyperspace = false;
			}
		}else if (planetFound) {
			g_game->printout(text, nav + "Captain, we can't enter hyperspace due to the nearby planet's gravity well.", ORANGE,8000);
			if (Util::ReentrantDelay(2000)) {
				flag_DoHyperspace = false;
			}
		} else if (ship.getFuel() <= 0.0f)
		{
			g_game->printout(text, nav + "Sir, we do not have enough fuel to enter hyperspace!", ORANGE, 10000);
			if (Util::ReentrantDelay(2000)) {
				flag_DoHyperspace = false;
			}
		}else {
			//okay we're not near a planet
			g_game->printout(text, nav + "Yes, sir! Engaging hyperspace engine.", ORANGE,8000);
			if (Util::ReentrantDelay(2000))
			{
                if (g_game->gameState->getShip().getFuel() >= 0.01f) //1% of fuel required
                {
				    g_game->gameState->m_ship.ConsumeFuel(20); //hyperspace engine consumes 20 units    
				    g_game->modeMgr->LoadModule(MODULE_HYPERSPACE);
				    return;
                }
                else
                {
                    g_game->printout(text, nav + "We do not have enough fuel to enter hyperspace!", RED, 8000);
                }
			}
		}
	}

	if (flag_DoDock)
	{
		//display any planet under ship
		if (planetFound) {
			//planet id #8 = Myrrdan in the database
			if (g_game->gameState->player->currentPlanet == 8){
				//okay we're near myredan - however it's spelled
				g_game->printout(text, nav + "Yes, sir! Docking with Starport.", ORANGE,8000);
				text->ScrollToBottom();
				if (Util::ReentrantDelay(1000)) 
				{
					g_game->modeMgr->LoadModule(MODULE_STARPORT);
					return;
				}
			}
			else
			{
				//okay we're near a planet without a starport
				g_game->printout(text, nav + "Sorry sir! There are no Starports in the vicinity.", ORANGE,8000);
				text->ScrollToBottom();
				flag_DoDock = false;
			}
		}
		else
		{
			//okay we're not near a planet
			g_game->printout(text, nav + "Sorry sir! We are not close enough to a planet to scan for Starports.", ORANGE,8000);
			text->ScrollToBottom();
			flag_DoDock = false;
		}
	}

    //check fuel level
	if(g_game->gameState->getShip().getFuel() <= 0.00f)
	{
        g_game->gameState->m_ship.injectEndurium();
	}

	//increase navigation skill every FlyingHoursBeforeSkillUp hours spent in space (the speed check is there to prevent the obvious abuse)
	Officer *currentNav = g_game->gameState->getCurrentNav();
	if (currentNav->CanSkillCheck() && ship->getCurrentSpeed() > 0.0){

		currentNav->FakeSkillCheck();
		currentNav->attributes.extra_variable++;

		if (currentNav->attributes.extra_variable >= FlyingHoursBeforeSkillUp) {
			currentNav->attributes.extra_variable = 0;
			if(currentNav->SkillUp(SKILL_NAVIGATION))
				g_game->printout(text, nav + "I think I'm getting better at this.", PURPLE, 5000);
		}
	}

	//slow down the ship automatically
	if (!flag_nav)	ship->applybraking();

	//refresh messages
	text->ScrollToBottom();

}

void ModuleInterPlanetaryTravel::Draw()
{
	static bool help1 = true;

	//draw the scrolling view
	scroller->drawScrollWindow(g_game->GetBackBuffer(), PLANET_SCROLL_X, PLANET_SCROLL_Y, PLANET_SCROLL_WIDTH, PLANET_SCROLL_HEIGHT);

	//draw the ship
	ship->draw(g_game->GetBackBuffer());

	//draw message window gui
	text->Draw(g_game->GetBackBuffer());

	//redraw the mini map
	updateMiniMap();

	//display tutorial help messages for beginners
	if ( (!g_game->gameState->firstTimeVisitor || g_game->gameState->getActiveQuest() > 10) ) help1 = false;
	if ( help1 )
	{
		help1 = false;
		string str = "You are now travelling in the star system. To move the ship use the same keys you used in the starport.";
		g_game->ShowMessageBoxWindow("",  str, 400, 300, YELLOW, 10, 200, false);
	}

    if (g_game->getGlobalBoolean("DEBUG_OUTPUT") == true)
    {
	    int y = 90;
	    g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "flag_nav: " + Util::ToString(flag_nav));
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "flag_thrusting: " + Util::ToString(flag_thrusting));
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "velocity: " + Util::ToString(ship->getVelocityX()) + "," + Util::ToString(ship->getVelocityY()));
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "speed: " + Util::ToString(ship->getCurrentSpeed()));
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "planetFound: " + Util::ToString(planetFound));
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "navcounter: " + Util::ToString(g_game->gameState->getCurrentNav()->attributes.extra_variable));
		//JJH - added CrossModuleAngle so that ship's heading stays consistent between entering/leaving systems. 
		//same mod in ModuleInterstellarTravel and some changes in PlayerShipSprite.  
		y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "angle: " + Util::ToString(ship->getRotationAngle()));   
		g_game->CrossModuleAngle = ship->getRotationAngle();	

    }
}


void ModuleInterPlanetaryTravel::checkShipPosition()
{

	//break up window into an evenly-divisible grid of tiles
	//note the height is based on top of GUI, since that is where scroller stops
	int windowWidth = (SCREEN_WIDTH / scroller->getTileWidth()) * scroller->getTileWidth();
	int windowHeight = (540 / scroller->getTileHeight()) * scroller->getTileHeight();

	//adjust for ship's position at center of main window
	int actualx = (int)(g_game->gameState->player->posSystem.x + windowWidth / 2);
	int actualy = (int)(g_game->gameState->player->posSystem.y + windowHeight / 2);

	//get tile based on ship's coordinates
	tilex = actualx / scroller->getTileWidth();
	tiley = actualy / scroller->getTileHeight();
	tilenum = scroller->getTile(tilex,tiley);


	//is ship burning up in the star?
	if (scroller->getTile(tilex,tiley) == 1)
	{
		burning++;
	}
	else {
		//calculate distance from ship to star
		int starTileX = scroller->getTilesAcross() / 2;
		int starTileY = scroller->getTilesDown() / 2;
		distance = sqrt( (float) pow( (float)(starTileX - tilex), 2) + (float) pow( (float)(starTileY - tiley), 2) );
		if (distance > 2.0f)
			burning = 0;
		else if (distance > 1.5f)
			burning = 1;
		else if (distance > 0.5f)
			burning = 2;
	}


	//see if ship is over planet tile
	planetFound = 0;
	for (int i=0; i<10; i++) {

		if (planetFound) break;

		//check tilex,tiley,and tilenum for a planet match
		if (tilex == planets[i].tilex && tiley == planets[i].tiley && tilenum == planets[i].tilenum)
		{
			planet = star->GetPlanetByID(planets[i].planetid);
			if (planet) {
				planetFound = 1;

				//store current planet in global player object
				g_game->gameState->player->currentPlanet = planets[i].planetid;

			}
		}

	}
	if (!planetFound)
		g_game->gameState->player->currentPlanet = -1;
}

void ModuleInterPlanetaryTravel::updateMiniMap()
{
	//get AUX_SCREEN gui values from globals
	asx = (int)g_game->getGlobalNumber("AUX_SCREEN_X");
	asy = (int)g_game->getGlobalNumber("AUX_SCREEN_Y");
	static int asw = (int)g_game->getGlobalNumber("AUX_SCREEN_WIDTH");
	static int ash = (int)g_game->getGlobalNumber("AUX_SCREEN_HEIGHT");

	//clear aux window
	rectfill(g_game->GetBackBuffer(), asx, asy, asx + asw, asy + ash , makecol(0,0,0));

	//draw ellipses representing planetary orbits
	int rx,ry,cx,cy;
	for (int i = 0; i < star->GetNumPlanets(); i++)  
    {
		planet = star->GetPlanet(i);
		if (planet) {
			cx = asx + asw / 2;
			cy = asy + ash / 2;
			rx = (int)( (2 + i) * 8.7 );
			ry = (int)( (2 + i) * 8.7 );
			ellipse(g_game->GetBackBuffer(), cx, cy, rx, ry, makecol(12,12,24));
		}
	}

	//draw the star in aux window
	int systemCenterTileX = scroller->getTilesAcross() / 2;
	int systemCenterTileY = scroller->getTilesDown() / 2;

	int color;
	switch(star->spectralClass) {
		case SC_A: color = WHITE; break;
		case SC_B: color = LTBLUE; break;
		case SC_F: color = LTYELLOW; break;
		case SC_G: color = YELLOW; break;
		case SC_K: color = ORANGE; break;
		case SC_M: color = RED; break;
		case SC_O: color = BLUE; break;
		default: color = ORANGE; break;
	}

	float starx = (int)(asx + systemCenterTileX * 2.3);
	float stary = (int)(asy + systemCenterTileY * 2.3);
	circlefill(g_game->GetBackBuffer(), starx, stary, 6, color);

	//draw planets in aux window
	color = 0;
	int planet=-1, px=0, py=0;
	for (int i = 0; i < star->GetNumPlanets(); i++)  {
			planet = planets[i].tilenum;
			if (planet > 0) {
				switch(planet) {
					case 1: color = makecol(255,182,0);	planets[i].radius = 6;		break; //sun
					case 2: color = makecol(100,0,100);	planets[i].radius = 4;		break; //gas giant
					case 3: color = makecol(160,12,8);	planets[i].radius = 3;		break; //molten
					case 4: color = makecol(200,200,255); planets[i].radius = 3;	break; //ice
					case 5: color = makecol(30,100,240); planets[i].radius = 3;		break; //oceanic
					case 6: color = makecol(134,67,30);	planets[i].radius = 2;		break; //rocky
					case 7: color = makecol(95,93,93);	planets[i].radius = 1;		break; //asteroid
					case 8: color = makecol(55,147,84);	planets[i].radius = 3;		break; //acidic
					default: color = makecol(90,90,90);	planets[i].radius = 1;		break; //none
				}
				px = (int)(asx + planets[i].tilex * 2.27);
				py = (int)(asy + planets[i].tiley * 2.27);
				circlefill(g_game->GetBackBuffer(), px, py, planets[i].radius, color);
			}
		}

	//draw text
	if(m_bOver_Planet == true){
		planet_label->Refresh();
		planet_label->Draw(g_game->GetBackBuffer());		
	}

	//draw player's location on minimap
	float fx = asx + g_game->gameState->player->posSystem.x / 256 * 2.3;
	float fy = asy + g_game->gameState->player->posSystem.y / 256 * 2.3;
	rect(g_game->GetBackBuffer(), (int)fx-1, (int)fy-1, (int)fx+2, (int)fy+2, BLUE);
}

int ModuleInterPlanetaryTravel::loadStarSystem(int id)
{
	int i;

	TRACE("  Loading star system %i.\n", id);
	srand(time(NULL));


	//save current star id in global player object
	g_game->gameState->player->currentStar = id;

	//clear the temp array of planets (used to simplify searches)
	for (i=0; i<10; i++) {
		planets[i].tilex = -1;
		planets[i].tiley = -1;
		planets[i].tilenum = -1;
		planets[i].planetid = -1;
	}

	//clear the tile map
	scroller->resetTiles();

	//calculate center of tile map
	int systemCenterTileX = scroller->getTilesAcross() / 2;
	int systemCenterTileY = scroller->getTilesDown() / 2;


	//position star tile image at center
	scroller->setTile(systemCenterTileX, systemCenterTileY, 1);

	//read starid passed over by the interstellar module
	star = g_game->dataMgr->GetStarByID(id);
	if (!star) {
		g_game->message("Interplanetary: Error loading star info");
		return 0;
	}

	//add planets to the solar system from the planet database
	if (star->GetNumPlanets() == 0) return 0;

	//seed random number generator with star id #
	srand(id);

	//calculate position of each planet in orbit around the star
	float radius,angle;
	int rx,ry;
	for (i = 0; i < star->GetNumPlanets(); i++)  {

		planet = star->GetPlanet(i);
		if (planet) {

			planets[i].planetid = planet->id;

			radius = (2 + i) * 4;
			angle = rand() % 360;
			rx = (int)( cos(angle) * radius );
			ry = (int)( sin(angle) * radius );
			planets[i].tilex = systemCenterTileX + rx;
			planets[i].tiley = systemCenterTileY + ry;

			switch(planet->type) {
			case PT_GASGIANT:	planets[i].tilenum = 2;	break;
			case PT_MOLTEN:		planets[i].tilenum = 3;	break;
			case PT_FROZEN:		planets[i].tilenum = 4;	break;
			case PT_OCEANIC:	planets[i].tilenum = 5;	break;
			case PT_ROCKY:		planets[i].tilenum = 6;	break;
			case PT_ASTEROID:	planets[i].tilenum = 7;	break;
			case PT_ACIDIC:		planets[i].tilenum = 8;	break;
			default:
				planets[i].tilenum = 2; //this bug needs to be fixed
                TRACE("loadStarSystem: Unknown planet type: %d\n",planet->type);
			}
			scroller->setTile(planets[i].tilex, planets[i].tiley, planets[i].tilenum);
		}
	}

	return 1;
}
