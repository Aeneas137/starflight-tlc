/*
	STARFLIGHT - THE LOST COLONY
	ModuleInterstellarTravel.cpp - Handles interstellar space travel in the main window
	Author: J.Harbour
	Date: January, 2007
*/

// consume fuel code
const int EVENT_INJECT_FUEL		= 100;
const int ITEM_ENDURIUM			= 54;


#pragma region HEADER

#include <sstream>
#include <exception>
#include "env.h"
#include "ModuleInterstellarTravel.h"
#include "Button.h"
#include "AudioSystem.h"
#include "Events.h"
#include "ModuleControlPanel.h"
#include "PauseMenu.h"

using namespace std;

#define GUI_AUX_BMP                      0        /* BMP  */
#define GUI_VIEWER_BMP                   1        /* BMP  */
#define IP_TILES_BMP                     2        /* BMP  */
#define IS_TILES_BMP                     3        /* BMP  */
#define SHIELD_TGA                       4        /* BMP  */
#define STARFIELD_BMP                    5        /* BMP  */

//scroller properties
#define GALAXY_SCROLL_X		0
#define GALAXY_SCROLL_Y		0
#define GALAXY_SCROLL_WIDTH	SCREEN_WIDTH
#define GALAXY_SCROLL_HEIGHT 650
#define GALAXYTILESIZE 128
#define GALAXYTILESACROSS (250 * 10)
#define GALAXYTILESDOWN (220 * 10)

const int FlyingHoursBeforeSkillUp = 168;

/* In the interest of completing this game, which is a higher priority than
being data driven and moddable, this alien race data is being hard coded.
A good improvement would be to move it into a data file and use an editor.
http://starflightgame.com/smf/index.php?topic=233.msg1682#msg1682
*/
struct PoliticalBoundary
{
	enum AlienRaces race;
	double x, y;
	int radius;
	int density; //1-50%
};

PoliticalBoundary boundaries[] = {
	//RACE				X		Y		RADIUS	DENSITY
	{ALIEN_NONE,		0,		0,		0,		0  },
	{ALIEN_ELOWAN,		66,		30,		30,		30 },
	{ALIEN_SPEMIN,		30,		137,	40,		40 },
	{ALIEN_THRYNN,		5,		66,		50,		50 },
	{ALIEN_BARZHON,		225,	120,	60,		50 },
	{ALIEN_NYSSIAN,		183,	192,	20,		40 },
	{ALIEN_TAFEL,		135,	30,		35,		50 },
	{ALIEN_MINEX,		58,		212,	50,		40 },
	{ALIEN_COALITION,	212,	3,		50,		30 },
	{ALIEN_PIRATE,		125,	110,	20,		20 }
};


#pragma endregion

#pragma region STATIC EVENTS

ModuleInterstellarTravel::ModuleInterstellarTravel(void){}
ModuleInterstellarTravel::~ModuleInterstellarTravel(void){}


void ModuleInterstellarTravel::OnMouseMove(int x, int y)
{
	text->OnMouseMove(x,y);
}

void ModuleInterstellarTravel::OnMouseClick(int button, int x, int y)
{
	text->OnMouseClick(button,x,y);
}

void ModuleInterstellarTravel::OnMousePressed(int button, int x, int y)
{
	text->OnMousePressed(button,x,y);
}

void ModuleInterstellarTravel::OnMouseReleased(int button, int x, int y)
{
	text->OnMouseReleased(button,x,y);
}

void ModuleInterstellarTravel::OnMouseWheelUp(int x, int y)
{
	text->OnMouseWheelUp(x,y);
}

void ModuleInterstellarTravel::OnMouseWheelDown(int x, int y)
{
	text->OnMouseWheelDown(x,y);
}

void ModuleInterstellarTravel::Draw()
{
	std::ostringstream s;

	// draw tile scroller
	scroller->drawScrollWindow(g_game->GetBackBuffer(), GALAXY_SCROLL_X, GALAXY_SCROLL_Y, GALAXY_SCROLL_WIDTH, GALAXY_SCROLL_HEIGHT);

	//draw the ship
	ship->draw(g_game->GetBackBuffer());

	//draw message window gui
	//blit(img_messages, g_game->GetBackBuffer(), 0, 0, gmx, gmy, gmw, gmh);
	text->Draw(g_game->GetBackBuffer());

    if (g_game->getGlobalBoolean("DEBUG_OUTPUT") == true)
    {
	    //DEBUG CODE -- do not delete
	    int y = 90;
	    g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "flag_nav: " + Util::ToString(flag_nav));
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "flag_thrusting: " + Util::ToString(flag_thrusting));
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "velocity: " + Util::ToString(ship->getVelocityX()) + "," + Util::ToString(ship->getVelocityY()));
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "speed: " + Util::ToString(ship->getCurrentSpeed()));
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "navcounter: " + Util::ToString(g_game->gameState->getCurrentNav()->attributes.extra_variable));
    }
}


#pragma endregion

#pragma region KEYBOARD

void ModuleInterstellarTravel::OnKeyPress(int keyCode)
{
	switch (keyCode) {
        case KEY_D:
		case KEY_RIGHT:
			flag_nav = false;
			ship->turnright();
			if (!flag_thrusting) ship->applybraking();
			break;

        case KEY_A:
		case KEY_LEFT:
			flag_nav = false;
			ship->turnleft();
			if (!flag_thrusting) ship->applybraking();
			break;

        case KEY_S:
		case KEY_DOWN:
			flag_nav = false;
			ship->applybraking();
        	g_game->gameState->m_ship.ConsumeFuel(2);
			break;

        case KEY_W:
		case KEY_UP:
			flag_nav = flag_thrusting = true;
			ship->applythrust();
			g_game->gameState->m_ship.ConsumeFuel(4);
			break;

		case KEY_Q:
			flag_nav = true;
			if (!flag_thrusting) ship->applybraking();
			ship->starboard();
			g_game->gameState->m_ship.ConsumeFuel(2);
			break;

		case KEY_E:
			flag_nav = true;
			if (!flag_thrusting) ship->applybraking();
			ship->port();
			g_game->gameState->m_ship.ConsumeFuel(2);
			break;
			
	}
}

void ModuleInterstellarTravel::OnKeyPressed(int keyCode){}

void ModuleInterstellarTravel::OnKeyReleased(int keyCode)
{
	switch (keyCode) {

#ifdef DEBUGMODE		
        //test encounters:
		case FORCE_ENCOUNTER_PIRATE:
			RollEncounter(ALIEN_PIRATE); break;
		case FORCE_ENCOUNTER_ELOWAN:
			RollEncounter(ALIEN_ELOWAN); break;
		case FORCE_ENCOUNTER_SPEMIN:
			RollEncounter(ALIEN_SPEMIN); break;
		case FORCE_ENCOUNTER_THRYNN:
			RollEncounter(ALIEN_THRYNN); break;
		case FORCE_ENCOUNTER_BARZHON:
			RollEncounter(ALIEN_BARZHON); break;
		case FORCE_ENCOUNTER_NYSSIAN:
			RollEncounter(ALIEN_NYSSIAN); break;
		case FORCE_ENCOUNTER_TAFEL:
			RollEncounter(ALIEN_TAFEL); break;
		case FORCE_ENCOUNTER_MINEX:
			RollEncounter(ALIEN_MINEX); break;
		case FORCE_ENCOUNTER_COALITION:
			RollEncounter(ALIEN_COALITION); break;

		case IST_QUEST_PLUS: {
			int questnum = g_game->gameState->getActiveQuest();
			g_game->gameState->setActiveQuest( questnum + 1 );
			break;
		}
		case IST_QUEST_MINUS: {
			int questnum = g_game->gameState->getActiveQuest();
			g_game->gameState->setActiveQuest( questnum - 1 );
			break;
		}

		case IST_STAGE_PLUS: {
			int plotStage = g_game->gameState->getPlotStage();
			g_game->gameState->setPlotStage(plotStage+1);
			break;
		}
		case IST_STAGE_MINUS: {
			int plotStage = g_game->gameState->getPlotStage();
			g_game->gameState->setPlotStage(plotStage-1);
			break;
		}

#endif

		//reset ship frame when key released
        case KEY_A:
        case KEY_LEFT:
        case KEY_D:
        case KEY_RIGHT:
        case KEY_S:
        case KEY_DOWN:
			flag_nav = false;
			ship->cruise();
			break;

        case KEY_W:
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

		case KEY_PGUP:
			//tactical options only enabled during combat (design decision)
			break;
		case KEY_PGDN:
			//tactical options only enabled during combat (design decision)
			break;

		case KEY_ESC:
			break;
	}
}

#pragma endregion

void ModuleInterstellarTravel::OnEvent(Event *event)
{
	//bool shieldStatus, weaponStatus;
	Ship ship;
	std::string escape;
	string name;

	int evtype = event->getEventType();
	switch(evtype) {
		case 0xDEADBEEF + 2: //save game
			g_game->gameState->AutoSave();
			g_game->printout(text, "<Game Saved>", WHITE, 5000);
			return;
			break;
		case 0xDEADBEEF + 3: //load game
			g_game->gameState->AutoLoad();
			return;
			break;
		case 0xDEADBEEF + 4: //quit game
			g_game->setVibration(0);
			escape = g_game->getGlobalString("ESCAPEMODULE");
			g_game->modeMgr->LoadModule(escape);
			return;
			break;


		case EVENT_ENGINEER_INJECT: g_game->gameState->getShip().injectEndurium(); break;

		case EVENT_CAPTAIN_LAUNCH:  g_game->printout(text, nav + "Sir, we are not on a planet.",BLUE,2000);       break;
		case EVENT_CAPTAIN_DESCEND: g_game->printout(text, nav + "Sir, we are not orbiting a planet.",BLUE,2000); break;
		//case EVENT_CAPTAIN_LOG:     g_game->printout(text, "<Log planet not yet implemented>",YELLOW,2000);       break;

		case EVENT_SCIENCE_SCAN:     g_game->printout(text, sci + "Sir, we are not near any planets or vessels.",BLUE,2000); break;
		case EVENT_SCIENCE_ANALYSIS: g_game->printout(text, sci + "Sir, I have not scanned anything.",BLUE,2000);            break;

		case EVENT_NAVIGATOR_ORBIT:      g_game->printout(text, nav + "But sir, we are in hyperspace!",BLUE,2000);           break;
		case EVENT_NAVIGATOR_DOCK:       g_game->printout(text, nav + "The starport is nowhere in sight, sir!",BLUE,2000);   break;
		case EVENT_NAVIGATOR_HYPERSPACE: if (starFound) flag_DoNormalSpace = true;                                           break;


		case EVENT_TACTICAL_COMBAT:  g_game->printout(text, tac + "Sir, we are not in range of any other ships.",BLUE,2000); break;
		case EVENT_TACTICAL_SHIELDS: g_game->printout(text, tac + "Sir, we are not in combat.", BLUE,2000); break;
		case EVENT_TACTICAL_WEAPONS: g_game->printout(text, tac + "Sir, we are not in combat.", BLUE,2000); break;

		case EVENT_COMM_HAIL:        g_game->printout(text, com + "We are not in range of any other ships.",BLUE,2000); break;
		case EVENT_COMM_STATEMENT:   g_game->printout(text, com + "We are not communicating with anyone!",  BLUE,2000); break;
		case EVENT_COMM_QUESTION:    g_game->printout(text, com + "We are not communicating with anyone!",  BLUE,2000); break;
		case EVENT_COMM_POSTURE:     g_game->printout(text, com + "We are not communicating with anyone!",  BLUE,2000); break;
		case EVENT_COMM_TERMINATE:   g_game->printout(text, com + "We are not communicating with anyone!",  BLUE,2000); break;
		case EVENT_COMM_DISTRESS:    g_game->gameState->m_ship.SendDistressSignal();                                    break;
	}
}


#pragma region INIT_CLOSE

bool ModuleInterstellarTravel::Init()
{
	g_game->SetTimePaused(false);	//game-time normal in this module.

	TRACE("  Hyperspace Initialize\n");

	movement_counter = 0;
	flag_nav = flag_thrusting = false;

	flag_DoNormalSpace = false;
	flag_FoundFlux = false;
	flag_Engaged = false;


	//enable the Pause Menu
	g_game->pauseMenu->setEnabled(true);

	//load the datafile
	isdata = load_datafile("data/spacetravel/spacetravel.dat");
	if (!isdata) {
		g_game->message("Hyperspace: Error loading datafile");
		return false;
	}

	//load sound effects
	if (!g_game->audioSystem->Load("data/spacetravel/klaxon.wav","klaxon")) {
		g_game->message("Hyperspace: Error loading audio files");
		return false;
	}


	//if navigator is out of commission, use captain
	tempOfficer = g_game->gameState->getCurrentNav();


	//get AUX_SCREEN gui values from globals
	static int asw = (int)g_game->getGlobalNumber("AUX_SCREEN_WIDTH");
	static int ash = (int)g_game->getGlobalNumber("AUX_SCREEN_HEIGHT");


	flag_DoNormalSpace = false;

   //create the ScrollBox for message window
	int gmx = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_X");
	int gmy = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_Y");
	int gmw = (int)g_game->getGlobalNumber("GUI_MESSAGE_WIDTH");
	int gmh = (int)g_game->getGlobalNumber("GUI_MESSAGE_HEIGHT");
	text = new ScrollBox::ScrollBox(g_game->font20, ScrollBox::SB_TEXT,
		gmx + 38, gmy + 18, gmw - 38, gmh - 32, 999);
	text->DrawScrollBar(false);

    //point global scrollbox to local one in this module for sub-module access
    g_game->g_scrollbox = text;


	//set ratios for displaying stars in the 250/-220 galaxy
	ratiox = (float)asw / 250.0f;
	ratioy = (float)ash / 220.0f;


	//create and configure the tile scroller
	createGalaxy();
	loadGalaxyData();
	load_flux();
	for (flux_iter i = g_game->dataMgr->flux.begin(); (i != g_game->dataMgr->flux.end()); i++){
		if((*i)->VISIBLE_SPACE() == true){
			scroller->setTile((*i)->TILE().X, (*i)->TILE().Y, 8);
		}
	}

	//create the ship
	ship = new PlayerShipSprite();
	controlKey = 0;
	shiftKey = 0;
	starFound = 0;
	flag_launchEncounter = false;
	ship->allstop();


	//shortcuts to crew last names to simplify code
	cap = g_game->gameState->officerCap->getLastName() + "-> ";
	com = g_game->gameState->getCurrentCom()->getLastName() + "-> ";
	sci = g_game->gameState->getCurrentSci()->getLastName() + "-> ";
	nav = g_game->gameState->getCurrentNav()->getLastName() + "-> ";
	tac = g_game->gameState->getCurrentTac()->getLastName() + "-> ";
	eng = g_game->gameState->getCurrentEng()->getLastName() + "-> ";
	doc = g_game->gameState->getCurrentDoc()->getLastName() + "-> ";


    //set player to galactic position from gamestate
	scroller->setScrollPosition(g_game->gameState->player->get_galactic_pos());
	return true;
}

void ModuleInterstellarTravel::Close()
{
	TRACE("*** Hyperspace closing\n\n");

	try {
		//delete shield;
		delete text;
		delete scroller;
		delete ship;

		//unload the data file (thus freeing all resources at once)
		unload_datafile(isdata);
		isdata = NULL;
	}
	catch(std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in InterstellarTravel::Close\n");
	}
}

#pragma endregion



#pragma region ENCOUNTER CODE


bool ModuleInterstellarTravel::RollEncounter(AlienRaces forceThisRace)
{
	static AlienRaces lastAlien = ALIEN_NONE;
	static Timer timerEncounter;
	static ostringstream os;
	static string str;
	static double x,y,radius,density;
	static double px,py,dist;
	static AlienRaces forcedRace= ALIEN_NONE;	//private variable triggered by input parameter, allows
												//use of normal call path triggered by encounters.
	string name;
	int attitude =0;
	int fleetSize =0;

	if (forceThisRace != ALIEN_NONE) {forcedRace= forceThisRace; return true;}	//next call triggers encounter.

	//the forcedRace parameter allows us to trigger an encounter with this specific race regardless of the region we're in
	if (forcedRace != ALIEN_NONE)
	{
		alienRaceText = g_game->gameState->player->getAlienRaceName(forcedRace);
		alienRaceTextPlural = g_game->gameState->player->getAlienRaceNamePlural(forcedRace);

		os.str("");	os << nav << "(waves smoke from console) Transient axion flux phase-lock loss! I can't locate us!";
		g_game->printout(text, os.str(),BRTORANGE,30000);

		os.str("");	os << com << "(muttered) Is that even a sentence?";
		g_game->printout(text, os.str(),ROYALBLUE,30000);

		os.str("");	os << nav << "(under breath) freak.";
		g_game->printout(text, os.str(),KHAKI,30000);

		os.str("");	os << nav << "Captain we seem to be in " << alienRaceText << " space. And they've found us!";
		g_game->printout(text, os.str(),KHAKI,30000);

		g_game->audioSystem->Play("klaxon");
		g_game->printout(text, sci + "Encounter Alert!",RED,5000);
		text->ScrollToBottom();

		g_game->gameState->player->setGalacticRegion(forcedRace);
		g_game->gameState->player->setAlienFleetSize(0);	//reset fleet size for next calculation
		alienRace = forcedRace;	// added so Forced (F1 thru F9) encounters correctly calculate enemy fleet sizes 
		calculateEnemyFleetSize();							//calculate alien fleet size

		flag_launchEncounter= true;
		forcedRace= ALIEN_NONE;		//reset the private flag.
		alienRace = forcedRace;
		return true;
	}

	//reduce frequency of encounter test
	if (!timerEncounter.stopwatch(1000)) return true;

	{
		//clear galactic region (alien space)
		alienRace = ALIEN_NONE;
		g_game->gameState->player->setGalacticRegion(ALIEN_NONE);

		//get number of races in boundaries array
		int num_races = sizeof(boundaries) / sizeof(PoliticalBoundary);

		//scan alien space to see if we're invading
		for (int n = 1; n < num_races; n++)
		{
			alienRace = boundaries[n].race;
			x = boundaries[n].x;
			y = boundaries[n].y;
			radius = (double)boundaries[n].radius;
			density = (double)boundaries[n].density / 100.0;

			//get distance from player to alien homeworld
			px = getPlayerGalacticX() / GALAXYTILESIZE;
			py = getPlayerGalacticY() / GALAXYTILESIZE;
			dist = Distance(px,py,x,y);

			//determine if player is inside alien space
			if (dist < radius) {
				g_game->gameState->player->setGalacticRegion( alienRace );
				break;
			}
		}

		//did search determine that we're in alien space?
		if (alienRace != ALIEN_NONE)
		{
			//calculate odds of running into alien ship based on alien radius and density
			//as a percentage of the player's distance from the core of the alien sphere
			proximity = 1.0 - dist / radius;
			odds = proximity * density * 100.0;

			//determine how far player is in alien space
			if (proximity > 0.6) depth = "deep inside";
			else if (proximity > 0.3) depth = "well within";
			else if (proximity > 0.1) depth = "in";
			else if (proximity > 0.0) depth = "on the outskirts of";

			/**
			 * Roll the odds of an encounter. Note: the frequency is once per second and should only
			   result in an encounter every 15 secs (at most--i.e. at center of alien sphere, much
			   less on the outskirts).
			 */
			roll = (double)(rand() % 200);
			if ( roll < odds )
			{
				//trigger an encounter
				movement_counter++;
				//flag_Engaged = true;
				timerEngaged.reset();
			}
		}

		/*
		 * notify player when we are in alien space
		 */

		if (alienRace == ALIEN_NONE) return true;

		os.str("");
		alienRaceText = g_game->gameState->player->getAlienRaceName( alienRace );
		alienRaceTextPlural = g_game->gameState->player->getAlienRaceNamePlural( alienRace );

		if (alienRace != lastAlien) {
			if (alienRace != ALIEN_PIRATE)
				os << nav << "We have entered " << alienRaceText << " space." ;
			g_game->printout(text, os.str(),GREEN,30000);
			lastAlien = alienRace;
		}
		else {
			if (alienRace == ALIEN_PIRATE) {
				os << sci << "Captain, we must be cautious as many freelancers and pirates frequent this area of space." ;
				g_game->printout(text, os.str(),BRTORANGE,-1);
			}
			else {
				os << nav << "Captain, we are " << depth << " " << alienRaceText << " space." ;
				g_game->printout(text, os.str(),BRTORANGE,30000);
			}
		}
	}


	if (movement_counter > 0)
	{
		os.str("");

		//actual encounter occurs after third random trigger
		switch(movement_counter)
		{
		case 1: //first encounter "hit"
			//reset fleet size for next calculation
			g_game->gameState->player->setAlienFleetSize(0);

			//encounterText[1] = ColorString("SCI->Captain, long-range sensors are picking up movement.",GREEN);
			g_game->printout(text, sci + "Captain, long-range sensors are picking up movement.",GREEN,8000);
			break;

		case 2: //second "hit" generates size of fleet

			//calculate alien fleet size
			calculateEnemyFleetSize();
			fleetSize = g_game->gameState->player->getAlienFleetSize();

			os.str("");
			if (fleetSize == 1) {
				os << sci << "Captain, short-range sensors detect a " << alienRaceText << " ship.";
			}
			else if (fleetSize < 6) {
				os << sci << "Captain, short-range scan shows a small fleet of " << alienRaceText << " ships.";
			}
			else if (fleetSize < 12) {
				os << sci << "Sir! Sensors picking up a large fleet of " << alienRaceText << " ships!";
			}
			else {
				os << sci << "Sir, a huge " << alienRaceText << " fleet is closing on our position!!";
			}

			//encounterText[2] = ColorString(os.str(), YELLOW);
			g_game->printout(text, os.str(),YELLOW,8000);
			break;

		case 3: //third "hit" could randomly reset the counter
			if (rand() % 100 < 5) {
				movement_counter = 0;
				//encounterText[3] = ColorString("SCI->The contact is now out of sensor range.",STEEL);
				g_game->printout(text, sci + "The contact is now out of sensor range.",STEEL,8000);
				break;
			}

			attitude = g_game->gameState->alienAttitudes[alienRace];
			if (attitude > 90) {
				os << com << "Sir, the " << alienRaceText << " basically love us.";
				g_game->printout(text, os.str(),GREEN,8000);
			}
			else if (attitude > 74) {
				os << com << "Sir, we have a friendly relationship with the " << alienRaceText << ".";
				g_game->printout(text, os.str(),GREEN,8000);
			}
			else if (attitude > 50) {
				os << com << "Sir, we have a neutral relationship with the " << alienRaceText << ".";
				g_game->printout(text, os.str(),GREEN,8000);
			}
			else if (attitude > 24) {
				os << com << "Sir, the " << alienRaceText << " are not friendly.";
				g_game->printout(text, os.str(),YELLOW,8000);
			}
			else {
				os << com << "Sir, be careful, these " << alienRaceTextPlural << " are extremely hostile!";
				g_game->printout(text, os.str(),YELLOW,8000);

				//inject comment about shields
				Ship ship = g_game->gameState->getShip();
				if (ship.getShieldClass() == 0)
				{
					//no shields installed--random freak out
					if (rand() % 100 < 20) {
						//encounterText[4] = ColorString("TAC->Arghh!! We have no shields!!", RED);
						name = g_game->gameState->officerTac->getLastName() + "-> ";
						g_game->printout(text, name + "Argh! We have no shields!!",RED,8000);

						//random criticism from another crew
						if (rand() % 100 < 20) {
							name = g_game->gameState->officerSci->getLastName() + "-> ";
							os.str("");
							os << name << g_game->gameState->officerTac->getFirstName() << ", please control your emotions.";
							g_game->printout(text, os.str(),YELLOW,8000);
						}
					}
				}
			}

			break;

		case 4: //fourth hit triggers the encounter
			g_game->audioSystem->Play("klaxon");
			g_game->printout(text, sci + "Encounter Alert!",RED,5000);
			text->ScrollToBottom();
			flag_launchEncounter = true;
			break;
		}

	}

	return true;
}

void ModuleInterstellarTravel::calculateEnemyFleetSize()
{
	int fleetSize = g_game->gameState->player->getAlienFleetSize();
	if (fleetSize <= 0)
	{
		//give newbie players a break..
		//if player's ship sucks, reduce the enemy fleet
		Ship ship = g_game->gameState->m_ship;
		float average_class = (float)ship.getLaserClass()
			+ (float)ship.getMissileLauncherClass()
			+ (float)ship.getArmorClass()
			+ (float) ship.getShieldClass()
			+ (float)ship.getEngineClass();
		average_class /= 5.0f;

		//is player's ship weak?
		if (average_class <= 4.0f)
		{
			fleetSize = (int)average_class;
			if (fleetSize < 1) fleetSize = 1;
		}
		//no, use normal fleet size calculations
		else {
			//70% of the time fleet is small (1-5)
			if (rand() % 100 < 70) {
				fleetSize = getFleetSizeByRace(true);
			}
			else {
				//30% of the time fleet is large (5-20)
				fleetSize = getFleetSizeByRace(false);
			}
		}
		//debugging---very large
		//fleetSize = 10;
		g_game->gameState->player->setAlienFleetSize( fleetSize );
	}
}


#pragma endregion

int ModuleInterstellarTravel::getFleetSizeByRace(bool small_fleet)
{
	switch(alienRace)
	{
	case ALIEN_PIRATE:
		//TRACE( "ALIEN_PIRATE fleet size calculation...\n" );
		if( small_fleet )
			return ( 1 + rand() % 3 );	// 1-3
		else
			return ( 5 + rand() % 5 );	// 5-10
		break;

	case ALIEN_ELOWAN:
		//TRACE( "ALIEN_ELOWAN fleet size calculation...\n" );
		if( small_fleet )
			return ( 1 + rand() % 3 ); // 1-3
		else
			return ( 4 + rand() % 4 );	// 4-8
		break;

	case ALIEN_SPEMIN:
		//TRACE( "ALIEN_SPEMIN fleet size calculation...\n" );
		if( small_fleet )
			return ( 1 + rand() % 2 );	//1-2
		else
			return ( 40 + rand() % 10 );	// 40-50
		break;

	case ALIEN_THRYNN:
		//TRACE( "ALIEN_THRYNN fleet size calculation...\n" );
		if( small_fleet )
			return ( 1 + rand() % 3 );	//1-3
		else
			return ( 3 + rand() % 5 );	// 3-8
		break;

	case ALIEN_BARZHON:
		//TRACE( "ALIEN_BARZHON fleet size calculation...\n" );
		if( small_fleet )
			return ( rand() % 3 );	// 1-3
		else
			return ( 5 + rand() % 15 );	// 5-20
		break;

	case ALIEN_NYSSIAN:
		//TRACE( "ALIEN_NYSSIAN fleet size calculation...\n" );
		return 1;
		break;

	case ALIEN_TAFEL:
		//TRACE( "ALIEN_TAFEL fleet size calculation...\n" );
		if( small_fleet )
			return ( 1 + rand() % 2 );	// 1-2
		else
			return ( rand() % 70 );	// 1-70
		break;

	case ALIEN_MINEX:
		//TRACE( "ALIEN_MINEX fleet size calculation...\n" );
		return ( 4 + rand() % 16 );	//4-20
		break;

	case ALIEN_COALITION:
		//TRACE( "ALIEN_COALITION fleet size calculation...\n" );
		if( small_fleet )
			return ( 1 );	// 1
		else
			return ( 3 + rand() % 7 );	// 3-10
		break;

	default:
		TRACE("  ERROR: Alien race not known, calculateFleetSizeByRace()");
		if( small_fleet )
			return ( 1 + rand() % 2 );	// 1-2
		else
			return ( 5 + rand() % 1 );	// 5-6
		break;
	}
}

void ModuleInterstellarTravel::Update()
{
	static Timer timerHelp;
	static bool flag_MiscComment = false;
	static string miscComment = "";
	ostringstream os;

	//if encounter triggered, then launch it
	if (flag_launchEncounter)
	{
		//pause for encounter sound clip
		rest(2500);
		g_game->modeMgr->LoadModule(MODULE_ENCOUNTER);
		return;
	}

	//update the ship's position based on velocity
	float multiplier = 1.0;
	//if (controlKey) multiplier = 10.0;
	//if (shiftKey)	multiplier = 20.0;

	float fx = getPlayerGalacticX() + (ship->getVelocityX() * multiplier);
	float fy = getPlayerGalacticY() + (ship->getVelocityY() * multiplier);

	//keep ship position within the bounds of the galaxy
	//account for negative position since ship is in center of viewport
	if (fx < -6) fx = -6;
	else if (fx > GALAXYTILESIZE * 256) fx = GALAXYTILESIZE * 256;
	if (fy < 0) fy = 0;
	else if (fy > GALAXYTILESIZE * 220) fy = GALAXYTILESIZE * 220;

	//store ship position in global data object
	g_game->gameState->player->set_galactic_pos(fx,fy);//123,203


	/*
	 * Important: Store ship's velocity in gamestate for use in other modules (particularly the aux window)
	 */
	g_game->gameState->player->setCurrentSpeed( ship->getCurrentSpeed() );


	//update scroll position and buffer
	scroller->setScrollPosition(fx, fy);
	scroller->updateScrollBuffer();

	//clear message window
	//text->Clear();

	//set ScrollBox font--move to init
	alfont_set_font_size(g_game->font10, 20);

	//locate any stars at ship position
	identifyStar();
	if (starFound)
	{
		os.str("");
		if (starSystem->name.length() > 0)
			os << nav << "Captain, we are in range of the " << starSystem->name << " system. ";
		else
			os << nav << "Captain, this is strange--the star is not in our data banks. ";

		if (starSystem->GetNumPlanets() > 6)
			os << "This is a large star system with " << starSystem->GetNumPlanets() << " planets!";
		else  if (starSystem->GetNumPlanets() > 1)
			os << "This is a small star system with " << starSystem->GetNumPlanets() << " planets.";
		else if (starSystem->GetNumPlanets() == 1)
			os << "I'm detecting only 1 planet.";
		else
			os << "It's empty--no planets.";

		os << " Awaiting order to exit hyperspace.";
		g_game->printout(text, os.str(), ORANGE, 20000);


		g_game->gameState->player->isLost(false);
	}
	else if(g_game->gameState->getShip().getFuel() <= 0.00f)
	{
        g_game->gameState->m_ship.injectEndurium();
	}
	else if(g_game->gameState->player->isLost())
	{
		g_game->printout(text, nav + "Sir, I think we are lost...", ORANGE,8000);
		g_game->printout(text, cap + "...Oh no.", LTGREEN,4000);

		if(tempOfficer->CanSkillCheck() == true
		&& g_game->gameState->SkillCheck(SKILL_NAVIGATION) == true)
		{
			g_game->gameState->player->isLost(false);
			//text->Clear();
			g_game->printout(text, nav + "Oh, wait... I've got our position now!", ORANGE,8000);
			g_game->printout(text, cap + "...", LTGREEN,1000);
			flux->PATH_VISIBLE(true);
		}
	}

	//locate any flux at players position
	identify_flux();
	if (flag_FoundFlux)
	{
		g_game->printout(text, nav + "I'm detecting a FLUX nearby!", ORANGE,5000);
		flag_FoundFlux = false;
	}


	/*
	 * Random alien encounters are based on player's location in the galaxy
	 * Return value causes break when encounter module is launched
	 */
	if (!RollEncounter()) return;


	//enter star system
	if (flag_DoNormalSpace)
	{
		g_game->printout(text, nav + "Aye, dropping out of hyperspace...", ORANGE,4000);
		EnterStarSystem();
		return;
	}

	//arm or disarm weapons
	if (flag_Weapons)
	{
		if (g_game->gameState->getWeaponStatus())
		{
			g_game->printout(text, tac + "Sir, yes sir! Arming weapons.", ORANGE,2000);
			if (rand()%10 == 1)
			{
				os.str(""); os << com + "Geez, " << g_game->gameState->officerTac->getFirstName()
					<< ", are you itching to blow something up?";
				miscComment = os.str();
				flag_MiscComment = true;
			}
		}
		else
			//g_game->printout(text, tac + "...(Sigh)...Disarming weapons.", ORANGE,2000);
			
			//  Since this message appears often when weapons are already disarmed, rewording it slightly
			g_game->printout(text, tac + "...Verifying weapon optics as depolarized and secured...", ORANGE,2000);

		flag_Weapons = false;
	}

	//misc comments from crew
	if (flag_MiscComment)
	{
		g_game->printout(text, miscComment, GREEN,10000);
		flag_MiscComment = false;
	}

	//increase navigation skill every FlyingHoursBeforeSkillUp hours spent in space (the speed check is there to prevent the obvious abuse)
	//NOTE: this must be after the flux detection and isLost() check; they will always fail in CanSkillCheck() otherwise
	Officer *currentNav = g_game->gameState->getCurrentNav();
	if (currentNav->CanSkillCheck() && ship->getCurrentSpeed() > 0.0 ){

		currentNav->FakeSkillCheck();
		currentNav->attributes.extra_variable++;

		if (currentNav->attributes.extra_variable >= FlyingHoursBeforeSkillUp) {
			currentNav->attributes.extra_variable = 0;
			if(currentNav->SkillUp(SKILL_NAVIGATION))
				g_game->printout(text, nav + "I think I'm getting better at this.", PURPLE, 5000);
		}
	}

	//slow ship down automatically
	if (!flag_nav) ship->applybraking();

	//refresh text list
	text->ScrollToBottom();

}



#pragma region FLUX STUFF
void ModuleInterstellarTravel::doFluxTravel()
{
	//g_game->gameState->player->set_galactic_pos((*i)->TILE_EXIT().X * scroller->getTileWidth(), (*i)->TILE_EXIT().Y * scroller->getTileHeight());
}

void ModuleInterstellarTravel::identify_flux()
{
	//adjust for ship's location at center of window
	int actualx = (int)(g_game->gameState->player->get_galactic_x() + GALAXY_SCROLL_WIDTH / 2);
	int actualy = (int)(g_game->gameState->player->get_galactic_y() + GALAXY_SCROLL_HEIGHT / 2);

	//get tile number based on ship position
	int tilex = actualx / scroller->getTileWidth();
	int tiley = actualy / scroller->getTileHeight();
	//int tilenum = scroller->getTile(tilex,tiley);

	flag_FoundFlux = false;
	if(g_game->gameState->player->isLost() == false){
		for (flux_iter i = g_game->dataMgr->flux.begin(); (i != g_game->dataMgr->flux.end()); i++){
			if((*i)->VISIBLE()){ //if #1
				if(tilex == (*i)->TILE().X && tiley == (*i)->TILE().Y){
					//entering a flux
					g_game->gameState->player->set_galactic_pos((*i)->TILE_EXIT().X * scroller->getTileWidth(), (*i)->TILE_EXIT().Y * scroller->getTileHeight());
					flux = (*i);
					tempOfficer->SkillUp(SKILL_NAVIGATION, 10);
					(*i)->rTRAVELED() = true;
					if(g_game->gameState->SkillCheck(SKILL_NAVIGATION)){//if #5
						(*i)->rPATH_VISIBLE() = true;
					}else{
						g_game->gameState->player->isLost(true);
						(*i)->rPATH_VISIBLE() = false;
					}//end if #5
				}
			}//end if #1
			if((*i)->distance_check(tilex, tiley, 10)){ //if #2
				if((*i)->VISIBLE_SPACE() == false){
					if(tempOfficer->CanSkillCheck() == true
					&& g_game->gameState->SkillCheck(SKILL_NAVIGATION) == true){ //if #3
							//detecting a flux
							(*i)->rVISIBLE_SPACE() = true;
							(*i)->rVISIBLE() = true;
							scroller->setTile((*i)->TILE().X, (*i)->TILE().Y, 8);
							tempOfficer->SkillUp(SKILL_NAVIGATION, 2);
					}
				}//end if #3
				if((*i)->VISIBLE_SPACE() == true){ //if #4
					flag_FoundFlux = true;
				}//end if #4
			}//end if #2
		}//end for
	}
}

void ModuleInterstellarTravel::check_flux_scanner()
{
	//static int fx = (int)g_game->getGlobalNumber("GUI_SOCKET_POS_X");
	//static int fy = (int)g_game->getGlobalNumber("GUI_SOCKET_POS_Y");

	//no point in doing anything if there aren't any flux
	if(!g_game->dataMgr->flux.empty()){
		Item flux_scanner;
		int num = -1;
		g_game->gameState->m_items.Get_Item_By_ID(FLUX_SCANNER_ID,flux_scanner,num);//find the scanner
		//do I have the scanner?
		if(flux_scanner.id == FLUX_SCANNER_ID && !g_game->gameState->player->prev_scanner_state()){
			g_game->gameState->player->set_flux_scanner(true);
			//textprintf_ex(g_game->GetBackBuffer(), font, x+45, y+25, WHITE, -1, flux_scanner.name.c_str());
		}else if(flux_scanner.id != FLUX_SCANNER_ID && g_game->gameState->player->has_flux_scanner()){
			g_game->gameState->player->set_flux_scanner(false);
		}

		//I have acquired the flux scanner
		if(g_game->gameState->player->has_flux_scanner() && !g_game->gameState->player->prev_scanner_state()){
			place_flux_tile(true, 9);
		}//I used to have the scanner, and now I don't...
		else if(!g_game->gameState->player->has_flux_scanner() && g_game->gameState->player->prev_scanner_state()){
			place_flux_tile(false, 1);
		}
	}
}

void ModuleInterstellarTravel::place_flux_tile(bool visible, int tile){
	for(flux_iter i = g_game->dataMgr->flux.begin(); i != g_game->dataMgr->flux.end(); i++){
		(*i)->rVISIBLE() = visible;
		scroller->setTile((*i)->TILE().X, (*i)->TILE().Y, tile);
	}
}


void ModuleInterstellarTravel::load_flux()
{
	if(g_game->dataMgr->flux.empty() == true){
		//srand(g_game->gameState->get_fluxSeed());
		srand(42); // remove game randomization - sw 

		int i_start = 0,
			_infinite_loop_prevention = 0,
			a = 0,
			i_increment = 5,
			i_radius = i_increment,
			i_distance = 3;
		Point2D i_origin;
		i_origin.x = (scroller->getTilesAcross()/10)/2;
		i_origin.y = (scroller->getTilesDown()/10)/2;

		Star *star;

		for(int n=0; n< MAX_FLUX; n++){
			flux = new Flux();
			flux->rVISIBLE() = true;
			flux->rID() = n;
			if(rand()%2){
				flux->rTILE().Y = (int)(i_origin.y + i_start + rand()%i_radius);
			}else{
				flux->rTILE().Y = (int)(i_origin.y - (i_start + rand()%i_radius));
			}
			if(rand()%2){
				flux->rTILE().X = (int)(i_origin.x + i_start + rand()%i_radius);
			}else{
				flux->rTILE().X = (int)(i_origin.x - (i_start + rand()%i_radius));
			}

			i_start = i_radius;
			i_radius += i_distance + rand()%i_increment;

			_infinite_loop_prevention = 0;
			a = 0;
			while(a < g_game->dataMgr->GetNumStars() && _infinite_loop_prevention < 5){
				star = g_game->dataMgr->GetStar(a);
				if(flux->distance_check(star->x, star->y, i_distance)){
					if(flux->rTILE().Y - star->y < i_distance && flux->rTILE().Y > star->y){
						flux->rTILE().Y++;
					}else if(star->y - flux->rTILE().Y < i_distance && flux->rTILE().Y < star->y){
						flux->rTILE().Y--;
					}
					if(flux->rTILE().X - star->x < i_distance && flux->rTILE().X > star->x){
						flux->rTILE().X++;
					}else if(star->x - flux->rTILE().X < i_distance && flux->rTILE().X < star->x){
						flux->rTILE().X--;
					}
					a--;
				}
				a++;
				_infinite_loop_prevention++;
			}

			if(flux->rTILE().Y > 10 && flux->rTILE().Y < scroller->getTilesDown()/10 - 10 ){
				if(flux->rTILE().X > 10 && flux->rTILE().X < scroller->getTilesAcross()/10 - 10){
					a = 0;
					while(a < g_game->dataMgr->GetNumStars() && flux->ID() != -1){
						star = g_game->dataMgr->GetStar(a);
						if(flux->rTILE().X == star->x && flux->rTILE().Y == star->y){
							flux->rID() = -1;
						}
						a++;
					}
					if(flux->ID() != -1){
						g_game->dataMgr->flux.push_back(flux);
					}
				}
			}
		}
		if(!g_game->dataMgr->flux.empty()){
			place_flux_exits();
		}
	}
}


void ModuleInterstellarTravel::place_flux_exits(){
	//srand(g_game->gameState->get_fluxSeed());
	srand(42);
	int scroller_tilesDown = scroller->getTilesDown()/10,
		scroller_tilesAcross = scroller->getTilesAcross()/10,
		exit_x = 0,
		exit_y = 0,
		max_distance = 60,
		flux_y = 0,
		flux_x = 0,
		min_distance = 20;
	flux_iter i = g_game->dataMgr->flux.begin();
	while(i != g_game->dataMgr->flux.end()){
		flux_x = (*i)->TILE().X;
		flux_y = (*i)->TILE().Y;

		if(rand()%2){
			exit_y = (*i)->rTILE_EXIT().Y = flux_y + (min_distance + rand()%max_distance);
		}else{
			exit_y = (*i)->rTILE_EXIT().Y = flux_y - (min_distance + rand()%max_distance);
		}
		if(rand()%2){
			exit_x = (*i)->rTILE_EXIT().X = flux_x + (min_distance + rand()%max_distance);
		}else{
			exit_x = (*i)->rTILE_EXIT().X = flux_x - (min_distance + rand()%max_distance);
		}

		if((*i)->TILE_EXIT().X < 10){
			(*i)->rTILE_EXIT().X = 10;
		}else if((*i)->TILE_EXIT().X > scroller_tilesAcross - 10){
			(*i)->rTILE_EXIT().X = scroller_tilesAcross - 10;
		}
		if((*i)->TILE_EXIT().Y < 10){
			(*i)->rTILE_EXIT().Y = 10;
		}else if((*i)->TILE_EXIT().Y > scroller_tilesDown - 10){
			(*i)->rTILE_EXIT().Y = scroller_tilesDown - 10;
		}
		i++;
	}
}

#pragma endregion


#pragma region GALAXY STUFF

double ModuleInterstellarTravel::getPlayerGalacticX()
{
	return g_game->gameState->player->get_galactic_x();
}

double ModuleInterstellarTravel::getPlayerGalacticY()
{
	return g_game->gameState->player->get_galactic_y();
}

double ModuleInterstellarTravel::Distance( double x1,double y1,double x2,double y2 )
{
    double deltaX = (x2-x1);
    double deltaY = (y2-y1);
    return sqrt(deltaX*deltaX + deltaY*deltaY);
}


void ModuleInterstellarTravel::identifyStar()
{
	//adjust for ship's location at center of window
	int actualx = (int)(g_game->gameState->player->posHyperspace.x + GALAXY_SCROLL_WIDTH / 2);
	int actualy = (int)(g_game->gameState->player->posHyperspace.y + GALAXY_SCROLL_HEIGHT / 2 - 64);

	//get tile number based on ship position
	int tilex = actualx / scroller->getTileWidth();
	int tiley = actualy / scroller->getTileHeight();

	//look for star at tile location
	starFound = 0;
	starSystem = g_game->dataMgr->GetStarByLocation(tilex,tiley);
	if (starSystem) {
		starFound = 1;
		currentStar = starSystem->id;
	}

}


 void ModuleInterstellarTravel::createGalaxy()
{
	//create tile scroller object for interstellar space
	scroller = new TileScroller();
	scroller->setTileSize(GALAXYTILESIZE,GALAXYTILESIZE);
	scroller->setTileImageColumns(5);
	scroller->setTileImageRows(2);
	scroller->setRegionSize(GALAXYTILESACROSS,GALAXYTILESDOWN);

	if (!scroller->createScrollBuffer(GALAXY_SCROLL_WIDTH, GALAXY_SCROLL_HEIGHT)) {
		g_game->message("Hyperspace: Error creating scroll buffer");
		return;
	}

	BITMAP *img = (BITMAP*)isdata[IS_TILES_BMP].dat;
	if (!img) {
		g_game->message("InterstellarTravel: Error loading is_tiles");
		return;
	}
	scroller->setTileImage(img);

	scroller->setScrollPosition(g_game->gameState->player->posHyperspace);
}



 void ModuleInterstellarTravel::loadGalaxyData()
{
	TRACE("  Loading galaxy data...\n");
	Star *star;
	int spectral = -1;

	//set specific tiles in the scrolling tilemap with star data from DataMgr
	for (int i = 0; i < g_game->dataMgr->GetNumStars(); i++)
	{
		star = g_game->dataMgr->GetStar(i);

		//these numbers match the ordering of the images in is_tiles.bmp and are not in astronomical order
		switch (star->spectralClass ) {
			case SC_O: spectral = 7; break;		//blue
			case SC_M: spectral = 6; break;		//red
			case SC_K: spectral = 5; break;		//orange
			case SC_G: spectral = 4; break;		//yellow
			case SC_F: spectral = 3; break;		//lt yellow
			case SC_B: spectral = 2; break;		//lt blue
			case SC_A: spectral = 1; break;		//white
			default: ASSERT(0); break;
		}

		//set tile number in tile scroller to star sprite number
		scroller->setTile(star->x, star->y, spectral);
	}
}


 void ModuleInterstellarTravel::EnterStarSystem()
{
	ship->allstop();
	g_game->gameState->player->currentStar = currentStar;

	// THIS SEEMS TO NOT WORK
	// NEED TO DROP PLAYER OUT OF HYPERSPACE INTO SOME RANDOM LOCATION
	// IN THE STAR SYSTEM BUT THIS JUST GOES TO THE SAME PLACE EVERY TIME

	//set starting location for player
	int w = 100 * 256; // planet tiles across x planet tile width
	int h = 100 * 256; // planet tiles down x planet tile height

	//keep player out of the center near the sun
	Rect *r = new Rect(w/2 - 500, h/2 - 500, w/2 + 500, h/2 + 500);

	//choose random but valid location
	int px = (int)g_game->gameState->player->posSystem.x;
	int py = (int)g_game->gameState->player->posSystem.y;
	px = Util::Random(w/5, w-w/5);
	py = Util::Random(h/5, h-h/5);
	while (r->contains(px,py)) {
		px = Util::Random(w/5, w-w/5);
		py = Util::Random(h/5, h-h/5);
	}
	delete r;
	g_game->gameState->player->posSystem.x = px;
	g_game->gameState->player->posSystem.y = py;

	//enter star system
	g_game->setVibration(0);

    //dropping out of hyperspace consumes fuel
    //we'll always allow player to enter a star system regardless of fuel, but not leave
    //that star system without sufficient fuel
    g_game->gameState->m_ship.ConsumeFuel(20); 

	g_game->modeMgr->LoadModule(MODULE_INTERPLANETARY);

}

#pragma endregion
