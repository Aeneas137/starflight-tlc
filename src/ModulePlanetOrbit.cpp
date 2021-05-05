#pragma region HEADER
/*
	STARFLIGHT - THE LOST COLONY
	ModulePlanetOrbit.cpp - Handles planet orbit
	Author: J.Harbour
	Date: January, 2007

	This module needs to allow the player to scan the planet (via Science Officer), and choose to land
	or break orbit. The planet surface is displayed in the Aux Window and the player chooses a location
	for the landing, then the landing sequence is displayed. When landing is complete, transfer controls
	to the planet surface module.
*/


#include <exception>
#include "env.h"

#include "PerlinTL.h"
#include "ModulePlanetOrbit.h"
#include "AudioSystem.h"
#include "QuestMgr.h"
#include "ModeMgr.h"
#include "GameState.h"
#include "Game.h"
#include "Events.h"
#include "ModuleControlPanel.h"
#include "Util.h"
#include "QuestMgr.h"
#include "PauseMenu.h"
using namespace std;

//sprite *planetImg;
float m_rotationAngle;
int starid = -1;
int planetid = -1;
int planetRadius;
double planetRotationSpeed, planetRotation;
int lightmapOffsetX, lightmapOffsetY;
std::string lightmapFilename;

BITMAP *planet_topography, *planet_scanner_map, *planet_texture;
bool flag_DoDock = false;

ModulePlanetOrbit::ModulePlanetOrbit(void)
{
    audio_scan = NULL;
}

ModulePlanetOrbit::~ModulePlanetOrbit(void){}

#pragma endregion


#pragma region INPUT

void ModulePlanetOrbit::OnKeyPress(int keyCode){}
void ModulePlanetOrbit::OnKeyPressed(int keyCode){}
void ModulePlanetOrbit::OnKeyReleased(int keyCode){}

void ModulePlanetOrbit::OnMouseMove(int x, int y)
{
	text->OnMouseMove(x,y);
}

void ModulePlanetOrbit::OnMouseClick(int button, int x, int y)
{
	text->OnMouseClick(button,x,y);
}

void ModulePlanetOrbit::OnMousePressed(int button, int x, int y)
{
	text->OnMousePressed(button,x,y);
}

void ModulePlanetOrbit::OnMouseReleased(int button, int x, int y)
{
	text->OnMouseReleased(button,x,y);
}

void ModulePlanetOrbit::OnMouseWheelUp(int x, int y)
{
	text->OnMouseWheelUp(x,y);
}

void ModulePlanetOrbit::OnMouseWheelDown(int x, int y)
{
	text->OnMouseWheelDown(x,y);
}

#pragma endregion


void ModulePlanetOrbit::OnEvent(Event *event)
{
	string escape;
	switch(event->getEventType())
	{
        //pause menu events
		case 0xDEADBEEF + 2: //save game
			g_game->gameState->AutoSave();
			g_game->printout(text, "<Game Saved>", WHITE, 5000);
			return;
			break;
		case 0xDEADBEEF + 3: //load game
			g_game->gameState->AutoLoad();
			return;//this must come after any LoadModule call
			break;
		case 0xDEADBEEF + 4: //quit game
			g_game->setVibration(0);
			escape = g_game->getGlobalString("ESCAPEMODULE");
			g_game->modeMgr->LoadModule(escape);
			return;//this must come after any LoadModule call
			break;

		case EVENT_CAPTAIN_LAUNCH:
			g_game->printout(text, nav + "Yes, sir, leaving planet orbit...", ORANGE);
			g_game->modeMgr->LoadModule(MODULE_INTERPLANETARY);
			return;//this must come after any LoadModule call
			break;

        case EVENT_CAPTAIN_DESCEND:
			//if this is a homeworld or restricted world, prevent landing
			if (planet->landable == false) {
				(g_game->gameState->player->currentPlanet == 429)?       //planet #429 is Cermait VI, in Cermait system (247,218)
					g_game->printout(text, nav + "Sir, a force field is repelling the ship and preventing us from entering the gravity well!", RED, 5000) :	
				g_game->printout(text, nav + "Sir, we are prohibited from landing on this protected world!", RED, 5000);
				return;
			}

			if(planet->type != PT_GASGIANT )
			{
				//fuel must be > 10% to land on a planet
				if (g_game->gameState->m_ship.getFuel() >= 0.1f)
				{
                    g_game->gameState->m_ship.ConsumeFuel(100);
					g_game->modeMgr->LoadModule(MODULE_SURFACE);
					return;//this must come after any LoadModule call
				}
                else{
                    g_game->printout(text, nav + "We do not have enough fuel to land and return to orbit.", RED,5000);
				}
			}else{
                g_game->printout(text, nav + "Sir, we cannot survive the atmospheric entry of this planet!", RED,5000);
			}
			break;

        case EVENT_CAPTAIN_CARGO :
            g_game->printout(text, "Please break orbit before visiting the cargo hold", YELLOW, -1);
            break;

        case EVENT_CAPTAIN_QUESTLOG :
            g_game->printout(text, "Please break orbit before viewing the mission log", YELLOW, -1);
            break;

		//case EVENT_CAPTAIN_LOG:
			//g_game->printout(text, "This planet cannot be logged for colonization.", YELLOW, 5000);
			//break;

		case EVENT_SCIENCE_SCAN:
			if ((planetScan == 0 || planetScan == 3) && planetAnalysis == 0) {
				//clear the message window only when user clicks the scan button
        		text->Clear();
				g_game->printout(text, sci + "Affirmative, Captain. Scanning planet...", LTGREEN, 2000);
				scanplanet();
			}
			break;

		case EVENT_SCIENCE_ANALYSIS:
			if(planetScan == 3 && planetAnalysis == 0) {
				g_game->printout(text, sci + "Affirmative, Captain. Analyzing sensor data...", LTGREEN, 2000);
				analyzeplanet();
			}
			break;

		case EVENT_NAVIGATOR_STARMAP:
			g_game->printout(text, nav + "Starmap not available while orbiting a planet.", YELLOW, -1);
			break;

		case EVENT_NAVIGATOR_DOCK:
			//planet id #8 = Myrrdan in the database
			if (g_game->gameState->player->currentPlanet == 8){
				g_game->printout(text, nav + "Yes, sir! Docking with Starport.", ORANGE, 5000);
				flag_DoDock = true;
			}else{
				g_game->printout(text, nav + "Sorry sir! There are no Starports in the vicinity.", YELLOW, -1);
				flag_DoDock = false;
			}
            break;

        case EVENT_NAVIGATOR_ORBIT :
            g_game->printout(text, nav + "We are already orbiting a planet!", YELLOW, -1);
            break;

        case EVENT_NAVIGATOR_HYPERSPACE :
            g_game->printout(text, nav + "We can't enter hyperspace while in orbit!", YELLOW, -1);
            break;

        case EVENT_TACTICAL_SHIELDS :
            g_game->printout(text, tac + "We are not in combat", YELLOW, -1);
            break;

        case EVENT_TACTICAL_WEAPONS :
            g_game->printout(text, tac + "We are not in combat", YELLOW, -1);
            break;

        case EVENT_TACTICAL_COMBAT :
            g_game->printout(text, tac + "With WHOM shall we engage in combat, sir?", YELLOW, -1);
            break;

        case EVENT_ENGINEER_REPAIR :
            g_game->printout(text, eng + "Please break orbit to access damage control", YELLOW, -1);
            break;

        case EVENT_ENGINEER_INJECT : 
            g_game->gameState->getShip().injectEndurium();
            break;

        case EVENT_COMM_HAIL :
            g_game->printout(text, com + "There are no other ships in the vicinity", YELLOW, -1);
            break;

        case EVENT_COMM_DISTRESS : 
            g_game->printout(text, "<This feature won't be installed until Tuesday>", YELLOW, -1);
            break;

        case EVENT_COMM_STATEMENT :
            g_game->printout(text, com + "We are not in contact with any other ship", YELLOW, -1);
            break;

        case EVENT_COMM_QUESTION :
            g_game->printout(text, com + "We are not in contact with anyone", YELLOW, -1);
            break;

        case EVENT_COMM_POSTURE : 
            g_game->printout(text, "<This feature won't be installed until Tuesday>", YELLOW, -1);
            break;

        case EVENT_COMM_TERMINATE :
            g_game->printout(text, com + "We are not engaged in communication", YELLOW, -1);
            break;

        case EVENT_DOCTOR_EXAMINE :
            g_game->printout(text, doc + "Please break orbit to access the crew's medical status", YELLOW, -1);
            break;

        case EVENT_DOCTOR_TREAT :
            g_game->printout(text, doc + "Please break orbit to set crew treatment priorities", YELLOW, -1);
            break;
    }
}

bool ModulePlanetOrbit::CreatePlanetTexture()
{
	//these cannot change: just noted for reference
    static int TEX_SIZE_ORBIT = 256; 
	static int TEX_SIZE_SURFACE = 500;
	std::string orbitFilename="";
	std::string surfaceFilename="";

	//use starid and planetid for random seed
	int randomness = starid * 1000 + planetid;

	//planet textures are stored in data/planetorbit using the starid and planetid as a random seed
	//once created they are re-used
	//two textures are required for each planet as a result of replacing the OpenGL with a software renderer

    ostringstream os;
    os << "data/planetorbit/planet_" << randomness << "_256.bmp";
    orbitFilename = os.str();
    TRACE("Planet orbit filename: %s\n", orbitFilename.c_str());

	os.str("");
	os << "data/planetorbit/planet_" << randomness << "_500.bmp";
	surfaceFilename = os.str();
	TRACE("Planet surface filename: %s\n", surfaceFilename.c_str());

    //try to find planet texture previously generated
	planet_texture=NULL;
    planet_texture = (BITMAP*)load_bitmap(orbitFilename.c_str(), NULL);
	if (!planet_texture) 
    {
	    //generate planet texture for ORBIT render 256x256
	    createPlanetSurface(TEX_SIZE_ORBIT, TEX_SIZE_ORBIT, randomness, planetType, orbitFilename);

	    //generate planet texture for SURFACE tilemap 500x500 (used in ModulePlanetSurface)
	    createPlanetSurface(TEX_SIZE_SURFACE, TEX_SIZE_SURFACE, randomness, planetType, surfaceFilename);

        //load newly generated planet texture
        planet_texture = (BITMAP*)load_bitmap(orbitFilename.c_str(), NULL);
	    if (!planet_texture) {
		    g_game->message("PlanetOrbit: Error loading planet texture");
		    return false;
	    }
    }


	//get AUX_SCREEN gui values from globals
	static int asw = (int)g_game->getGlobalNumber("AUX_SCREEN_WIDTH");
	static int ash = (int)g_game->getGlobalNumber("AUX_SCREEN_HEIGHT");

    //create planet topography bitmap for minimap
	planet_topography = create_bitmap(asw, ash);
	clear_bitmap(planet_topography);

	//scale planet texture onto topography, cutting skewed N/S poles (drop 10 pixels from top/bottom)
 	stretch_blit(planet_texture, planet_topography, 
        0, 10, planet_texture->w, planet_texture->h-20, 
        1, 1, planet_topography->w-2, planet_topography->h-2);

	//now create a scratch image as a duplicate of topography used for sensor scans
	planet_scanner_map = create_bitmap(asw, ash);
    draw_sprite(planet_scanner_map, planet_topography, 0, 0);


    //create texture-mapped sphere of the planet
    texsphere = new TexturedSphere(TEX_SIZE_ORBIT);
    if (!texsphere->SetTexture(planet_texture))
    {
        g_game->fatalerror("PlanetOrbit: error loading planet_texture");
        return false;
    }

    return true;
}

void ModulePlanetOrbit::Close()
{
	TRACE("PlanetOrbit Destroy\n");

	try {
        if (lightmap_overlay) {
            destroy_bitmap(lightmap_overlay);
            lightmap_overlay=NULL;
        }
		if (planet_topography) {
            destroy_bitmap(planet_topography);
            planet_topography=NULL;
        }
        if (planet_scanner_map) {
            destroy_bitmap(planet_scanner_map);
            planet_scanner_map=NULL;
        }
        if (planet_texture) {
            destroy_bitmap(planet_texture);
            planet_texture = NULL;
        }
        if (background) {
            destroy_bitmap(background);
            background=NULL;
        }
        //if (img_viewer) {
        //    destroy_bitmap(img_viewer);
        //    img_viewer=NULL;
        //}

        if (audio_scan) {
            delete audio_scan;
            audio_scan = NULL;
        }

		if (text != NULL)
		{
		  delete text;
		  text = NULL;
		}

	}
	catch(std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in PlanetOrbit::Close\n");
	}
}


//Init is a good place to load resources
bool ModulePlanetOrbit::Init()
{
	g_game->SetTimePaused(false);	//game-time normal in this module.
	TRACE("  PlanetOrbit Initialize\n");

#ifdef DEBUGMODE
    if (g_game->getGlobalString("STARTUPMODULE") == "PLANETORBIT")
    {
        starid = g_game->gameState->player->currentStar = 2;
        planetid = g_game->gameState->player->currentPlanet = 8;
    }
#endif
    
	//enable the Pause Menu
	g_game->pauseMenu->setEnabled(true);

	planetScan = 0;
	planetAnalysis = 0;
	flag_DoDock = false;

	//clear screen
	//rectfill(g_game->GetBackBuffer(), 0, 0, SCREEN_W-1, SCREEN_H-1, BLACK);

    //load the background
    background = (BITMAP*)load_bitmap("data/planetorbit/STARFIELD.tga",NULL);
    if (!background) {
        g_game->fatalerror("PlanetOrbit: Error loading background");
        return false;
    }

	//load the viewer gui
	/*static int gvl = (int)g_game->getGlobalNumber("GUI_VIEWER_LEFT");
	static int gvs = (int)g_game->getGlobalNumber("GUI_VIEWER_SPEED");
	gui_viewer_x = gvl;
	gui_viewer_y = 10;
	gui_viewer_dir = gvs;
	gui_viewer_sliding = false;
	img_viewer = (BITMAP*)load_bitmap("data/spacetravel/GUI_VIEWER.BMP",NULL);*/

	//create the ScrollBox for message window
	static int gmx = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_X");
	static int gmy = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_Y");
	static int gmw = (int)g_game->getGlobalNumber("GUI_MESSAGE_WIDTH");
	static int gmh = (int)g_game->getGlobalNumber("GUI_MESSAGE_HEIGHT");
	text = new ScrollBox::ScrollBox(g_game->font20, ScrollBox::SB_TEXT,
		gmx + 38, gmy + 18, gmw - 38, gmh - 32, 999);
	text->DrawScrollBar(false);
    
    //point global scrollbox to local one in this module for access by sub-modules
    g_game->g_scrollbox = text;

    //set default text size
	//alfont_set_font_size(g_game->font10, 20);


	//get current star data
	Star *star = g_game->dataMgr->GetStarByID(g_game->gameState->player->currentStar);
	if (star)
		starid = star->id;
	else
		starid = -1;


	//read planet data
	if (g_game->gameState->player->currentPlanet > -1)
	{
		planet = star->GetPlanetByID(g_game->gameState->player->currentPlanet);
		if (planet) {
			planetid = planet->id;
			planetType = planet->type;

			switch(planet->size) {
				case PS_HUGE:
					planetRadius = 240;
                    planetRotationSpeed = 0.14;
                    lightmapOffsetX = -250;
                    lightmapOffsetY = -250;
                    lightmapFilename = "lightmap_planet_500.tga";
					break;
				case PS_LARGE:
					planetRadius = 192;
                    planetRotationSpeed = 0.17;
                    lightmapOffsetX = -200;
                    lightmapOffsetY = -200;
                    lightmapFilename = "lightmap_planet_400.tga";
					break;
				case PS_MEDIUM:
					planetRadius = 144;
                    planetRotationSpeed = 0.20;
                    lightmapOffsetX = -150;
                    lightmapOffsetY = -150;
                    lightmapFilename = "lightmap_planet_300.tga";
					break;
				case PS_SMALL:
					planetRadius = 96;
                    planetRotationSpeed = 0.23;
                    lightmapOffsetX = -100;
                    lightmapOffsetY = -100;
                    lightmapFilename = "lightmap_planet_200.tga";
					break;
				default: //asteroid
					planetRadius = 48;
                    planetRotationSpeed = 0.26;
                    lightmapOffsetX = -50;
                    lightmapOffsetY = -50;
                    lightmapFilename = "lightmap_planet_100.tga";
			}
		}
		else
			planetid = -1;
	}

	if (starid != -1 && planetid != -1) 
    {
		if (!CreatePlanetTexture()) return false;
	}

    //load planet lightmap overlay
    lightmapFilename = "data/planetorbit/" + lightmapFilename;
    lightmap_overlay=NULL;
    lightmap_overlay = (BITMAP*)load_bitmap(lightmapFilename.c_str(),NULL);
    if (!lightmap_overlay) {
        g_game->fatalerror("PlanetOrbit: error loading lightmap_overlay");
        return false;
    }



	//shortcuts to crew last names to simplify code
	com = "Comm. Off. " + g_game->gameState->getCurrentCom()->getLastName() + "-> ";
	sci = "Sci. Off. " + g_game->gameState->getCurrentSci()->getLastName() + "-> ";
	nav = "Nav. Off. " + g_game->gameState->getCurrentNav()->getLastName() + "-> ";
	tac = "Tac. Off. " + g_game->gameState->getCurrentTac()->getLastName() + "-> ";
	eng = "Eng. Off. " + g_game->gameState->getCurrentEng()->getLastName() + "-> ";
	doc = "Med. Off. " + g_game->gameState->getCurrentDoc()->getLastName() + "-> ";


	//tell questmgr that orbit event has occurred
	g_game->questMgr->raiseEvent(12, g_game->gameState->player->currentPlanet);


	//load audio
	if ( g_game->getGlobalBoolean("AUDIO_GLOBAL") )
	{
		audio_scan = g_game->audioSystem->Load("data/spacetravel/audio_scan.wav");
		if (!audio_scan) {
			g_game->fatalerror("PlanetOrbit: Error loading audio_scan.wav");
			return false;
		}
		//audio_scan->SetVolume(0.5f);
	}

	return true;
}


void ModulePlanetOrbit::Update()
{
	std::string temp;
	std::ostringstream ostr;
	Officer *currentSci = g_game->gameState->getCurrentSci();

	if (planetScan == 1)
	{
        //get size of planet to determine scan time
        int scantime = 0;
        switch(planet->size)
        {
        case PS_SMALL:  scantime = 2000; break;
        case PS_MEDIUM: scantime = 4000; break;
        case PS_LARGE:  scantime = 6000; break;
        case PS_HUGE:   scantime = 8000; break;
        default: scantime = 4000;
        }

		//show scanning process for short duration
		if ( Util::ReentrantDelay(scantime) )
		{
			//done scanning
			planetScan++;
		}
	}
	else if (planetScan == 2)
	{
        //roll on crewman's skill with this operation
        if (g_game->gameState->SkillCheck(SKILL_SCIENCE))
        {
    		g_game->printout(text, sci + "Planetary scan complete. Ready for analysis.", LTGREEN,1000);
            //after success, increase skill
            if (Util::Random(1,100) > 50) //50% of the time
            {
                if (currentSci->SkillUp(SKILL_SCIENCE)) {
                    g_game->printout(text, sci + "I think I'm getting the hang of this (SKILL UP).", PURPLE,1000);
                }
            }
        }
        planetScan++;

	}
	else if (planetAnalysis == 1)
	{
	    if ( Util::ReentrantDelay(2000) )   
        {
		    //done analyzing
   		    planetAnalysis++;

             if (g_game->gameState->SkillCheck(SKILL_SCIENCE))
             {
                if (Util::Random(1,100) > 50 && currentSci->SkillUp(SKILL_SCIENCE))
                    g_game->printout(text, sci + "I think I'm getting better at this (SKILL UP).", PURPLE,1000);
             }
        }
	}
	else if (planetAnalysis > 1)
	{
		if (planet->id == HOMEWORLD_ID) {
			temp = "This is our beautiful home world Myrrdan. ";
		}
		else {
			//start building the description based on planet type
			temp = "Astronomy records indicate this ";
			if (planet->type == PT_ASTEROID)
				temp += "asteroid ";
			else
				temp += Planet::PlanetTypeToString(planet->type) + " planet ";
			temp += "is called " + Util::ToUpper(planet->name) + ". ";
		}

		//build size and gravity description
		temp += "It is " + Planet::PlanetSizeToString(planet->size) +
			" in size, and gravity is " + Planet::PlanetGravityToString(planet->gravity) + ". ";

		//build the atmosphere description
		switch(planet->atmosphere) {
			case PA_ACIDIC:		temp += "The atmosphere is ACIDIC";			break;
			case PA_BREATHABLE:	temp += "The atmosphere is BREATHABLE";		break;
			case PA_FIRESTORM:	temp += "The atmosphere is a FIRESTORM";	break;
			case PA_TOXIC:		temp += "The atmosphere is TOXIC";			break;
			case PA_TRACEGASES:	temp += "The atmosphere has only TRACE GASES";	break;
			default:			temp += "There is NO ATMOSPHERE";		break;
		}

		//build temperature description
		temp += ", and the temperature is ";
		switch (planet->temperature) {
			case PTMP_SUBARCTIC:	temp += "SUB-ARCTIC";	break;
			case PTMP_ARCTIC:		temp += "ARCTIC";		break;
			case PTMP_TROPICAL:		temp += "TROPICAL";		break;
			case PTMP_TEMPERATE:	temp += "TEMPERATE";	break;
			case PTMP_SEARING:		temp += "SEARING";		break;
			case PTMP_INFERNO:		temp += "INFERNO";	    break;
			default:				temp += "UNKNOWN";	    break;
		}
        temp += ".";

		//build weather description
		temp += "The weather is ";
		switch (planet->weather) {
            case PW_NONE:	        temp += "NONEXISTENT";  break;
            case PW_CALM:			temp += "CALM";			break;
			case PW_MODERATE:		temp += "MODERATE";		break;
			case PW_VIOLENT:		temp += "VIOLENT";		break;
			case PW_VERYVIOLENT:	temp += "VERY VIOLENT";	break;
            case PW_INVALID:
			default:				temp += "UNKNOWN";	    break;
		}
		temp += ".";

        g_game->printout(text, sci + "Sensor analysis is complete.", WHITE,1000);
		g_game->printout(text, temp, STEEL,1000);


		//detect artifacts and ruins on surface
		for (int n=0; n<g_game->dataMgr->GetNumItems(); n++)
		{
			Item *item = g_game->dataMgr->GetItem(n);

			//is this item an artifact?
			if (item->itemType == IT_ARTIFACT || item->itemType == IT_RUIN)			//jjh
			{
				//artifact located on this planet?
				if (item->planetid == planetid)
				{
                    //due to the -1 repeat code, this will only print once followed by one or more objects in a list
                    ostringstream os;
					os <<  "I'm detecting an odd energy signature on the surface. ";
                    
					
                    if (item->itemType == IT_ARTIFACT)
                       os << "It appears to be an Artifact.";
                    else
                        os << "It appears to be an ancient Ruin.";

					 if (g_game->getGlobalBoolean("DEBUG_OUTPUT") == true) {
					// Reporting position of artifacts/ruins disabled because we don't want to give them away too easily!
                    // But this could be used in a future upgrade by giving the player a planet scanner device.  REACTIVATED UNDER DEBUG BY JJH
						int lat = item->x;
						os << "  " << abs(lat);
						if (lat < 0) os << "N";
						else if (lat > 0) os << "S";
						int lng = item->y;
						os << " X " << abs(lng);
						if (lng < 0) os << "W";
						else if (lng > 0) os << "E";
					 }
    				g_game->printout(text, sci + os.str(), YELLOW, 1000);

                    //stop searching items
                    break;
				}
			}
		}

        //reset analysis flag to break out of this block of code 
        planetAnalysis = 0;

	}

	else {
        //normal orbit message
		g_game->printout(text, nav + "Orbit established.", LTGREEN,-1);
		switch(planet->size) 
        {
			case PS_SMALL:  temp = sci + "Captain, this planetoid is tiny. Shall I perform a full sensor scan?";	    break;
			case PS_MEDIUM: temp = sci + "Captain, this looks like an average planet. Want a full sensor scan?";	break;
			case PS_LARGE:  temp = sci + "Captain, we've got a large planet here. Sensors?";	                    break;
			case PS_HUGE:   temp = sci + "It's huge! We have to scan it! Er, on your command, of course.";		break;
            default:        temp = sci + "Our sensors can't measure the planet's size for some reason!";		    break;
		}
		g_game->printout(text, temp, ORANGE, -1);
	}

	//planet scan?
	if (planetScan == 1) 
    {
        int pw = planet_topography->w-7;
        int ph = planet_topography->h-7;

        //draw a bunch of random sensor blips
        for (int n=0; n<8; n++)
        {
		    Rect r;
		    r.left = rand() % pw;;
		    r.top = rand() % ph;
		    r.right = r.left + 4;
		    r.bottom = r.top + 4;
		    int color = makecol(100+rand() % 155, 0, 100+rand() % 155);
		    rectfill(planet_topography, r.left, r.top, r.right, r.bottom, color);
        }

        g_game->audioSystem->Play( audio_scan );

	}
	else {
		//restore original topography
		blit(planet_scanner_map,planet_topography,0,0,0,0,planet_topography->w,planet_topography->h);
	}


	//trying to dock with starport
	if (flag_DoDock) {
		if (Util::ReentrantDelay(2000)) {
			g_game->modeMgr->LoadModule(MODULE_STARPORT);
			return;
		}
	}


    //update message list
	text->ScrollToBottom();
}


void ModulePlanetOrbit::Draw()
{
	//blit(background, g_game->GetBackBuffer(), 0, 0, 0, 0, background->w, background->h-200);
    draw_trans_sprite(g_game->GetBackBuffer(), background, 0, 0);

	//draw gui viewer
	//static int gvl = (int)g_game->getGlobalNumber("GUI_VIEWER_LEFT");
	//static int gvr = (int)g_game->getGlobalNumber("GUI_VIEWER_RIGHT");
	//if (gui_viewer_sliding) 
    //{
	//	gui_viewer_x += gui_viewer_dir;
	//	if (gui_viewer_x <= gvl || gui_viewer_x >= gvr)
	//		gui_viewer_sliding = false;
	//}
	//masked_blit(img_viewer, g_game->GetBackBuffer(), 0, 0, gui_viewer_x, gui_viewer_y, img_viewer->w, img_viewer->h);

    //clear aux window
	static int asx = (int)g_game->getGlobalNumber("AUX_SCREEN_X");
	static int asy = (int)g_game->getGlobalNumber("AUX_SCREEN_Y");
	static int asw = (int)g_game->getGlobalNumber("AUX_SCREEN_WIDTH");
	static int ash = (int)g_game->getGlobalNumber("AUX_SCREEN_HEIGHT");
	rectfill(g_game->GetBackBuffer(), asx, asy, asx + asw, asy + ash, makecol(0,0,0));

    
    //draw topography map of planet in the aux window
    blit(planet_topography, g_game->GetBackBuffer(), 0, 0, asx, asy, planet_topography->w, planet_topography->h);


	//draw message window
	text->Draw(g_game->GetBackBuffer());

    //draw rotating planet as textured sphere
    static double rot = 0.0;
    int rotation = (int) Util::Round( rot );
    int cx = SCREEN_WIDTH/2;
    int cy = 250;
    planetRotation += planetRotationSpeed;
    texsphere->Draw(g_game->GetBackBuffer(), 0, 0, (int)planetRotation, planetRadius, cx, cy);
    rot += 0.2;
    rot = Util::WrapValue(rot, 0.0, 256.0);

    //draw planet lightmap overlay 
    draw_trans_sprite(g_game->GetBackBuffer(), lightmap_overlay, cx+lightmapOffsetX, cy+lightmapOffsetY);


#ifdef DEBUGMODE
	int y = 0;
	g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "planetScan: " + Util::ToString(planetScan));
	y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 850, y, "planetAnalysis: " + Util::ToString(planetAnalysis));
#endif


}

void ModulePlanetOrbit::scanplanet()
{
	if (planetScan != 1)
	{
		//begin scanning
		planetScan = 1;
		planetAnalysis = 0;

		//notify quest manager of planet scan event
		g_game->questMgr->raiseEvent(14, planet->id);
	}
}

void ModulePlanetOrbit::analyzeplanet()
{
	if (planetScan == 3)
	{
        planetScan = 0;
		planetAnalysis = 1;
	}

}

