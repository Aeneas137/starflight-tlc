/*
	STARFLIGHT - THE LOST COLONY
	ModuleEncounter.cpp - Handles alien encounters
	Author: J.Harbour
	Date: December, 2007
*/

#pragma region HEADER

#include <exception>
#include <sstream>
#include <string>
#include <iostream>
#include <iomanip>
#include "env.h"
#include "ModuleEncounter.h"
#include "Button.h"
#include "AudioSystem.h"
#include "ModeMgr.h"
#include "Game.h"
#include "ScrollBox.h"
#include "Events.h"
#include "ModuleControlPanel.h"
#include "GameState.h"
#include "Util.h"
#include "MathTL.h"
#include "Script.h"
#include "Sprite.h"
#include "PlayerShipSprite.h"
#include "CombatObject.h"
#include "CombatPlayerVessel.h"
#include "TileScroller.h"
#include "PauseMenu.h"
#include "Timer.h"

using namespace std;

const int ENCOUNTER_DIALOGUE_EVENT         = 8000;
const int ENCOUNTER_CLOSECOMM_EVENT        = 8001;
const int ENCOUNTER_ALIENATTACK_EVENT      = 8002;

#define CLR_MSG		GRAY1			//color of info messages
#define CLR_TRANS	DODGERBLUE		//color of transmissions to/from aliens
#define CLR_LIST	STEEL			//color of list items
#define CLR_CANCEL	ORANGE			//color of cancel choice
#define CLR_ALERT	DKORANGE		//color of alert messages


#define OBJ_PLAYERSHIP  1
#define OBJ_EXPLOSION   5
#define OBJ_ALIENSHIP  10
#define OBJ_ASTEROID_BIG 20
#define OBJ_ASTEROID_MED 21
#define OBJ_PLAYERLASER     100
#define OBJ_PLAYERMISSILE   101
#define OBJ_ENEMYFIRE       102
#define OBJ_POWERUP_HEALTH 30
#define OBJ_POWERUP_SHIELD 31
#define OBJ_POWERUP_ARMOR  32
#define OBJ_POWERUP_MINERAL_FROM_SHIP     33
#define OBJ_POWERUP_MINERAL_FROM_ASTEROID 34

#define TILESIZE		256
#define TILESACROSS		64
#define TILESDOWN		64


/*
 * Paste defs here from dat_encounter.h after running dat_encounter.bat to build the data file
 */
//#define BIGASTEROID_BMP                  0        /* BMP  */
//#define EXPLOSION_30_128_TGA             1        /* BMP  */
//#define EXPLOSION_30_48_TGA              2        /* BMP  */
//#define EXPLOSION_30_64_TGA              3        /* BMP  */
//#define GUI_AUX_BMP                      4        /* BMP  */
//#define GUI_MESSAGEWINDOW_BMP            5        /* BMP  */
//#define GUI_SOCKET_BMP                   6        /* BMP  */
//#define GUI_VIEWER_BMP                   7        /* BMP  */
//#define GUI_VIEWER_RIGHT_BMP             8        /* BMP  */
//#define IP_TILES_BMP                     9        /* BMP  */
//#define LASER_BEAM_BMP                   10       /* BMP  */
//#define PORTRAIT_BARZHON_BMP             11       /* BMP  */
//#define PORTRAIT_COALITION_BMP           12       /* BMP  */
//#define PORTRAIT_ELOWAN_BMP              13       /* BMP  */
//#define PORTRAIT_MINEX_BMP               14       /* BMP  */
//#define PORTRAIT_NYSSIAN_BMP             15       /* BMP  */
//#define PORTRAIT_PIRATE_BMP              16       /* BMP  */
//#define PORTRAIT_SPEMIN_BMP              17       /* BMP  */
//#define PORTRAIT_TAFEL_BMP               18       /* BMP  */
//#define PORTRAIT_THRYNN_BMP              19       /* BMP  */
//#define POWERUP_ARMOR_TGA                20       /* BMP  */
//#define POWERUP_HEALTH_TGA               21       /* BMP  */
//#define POWERUP_MINERAL_TGA              22       /* BMP  */
//#define POWERUP_SHIELD_TGA               23       /* BMP  */
//#define RED_BOLT_BMP                     24       /* BMP  */
//#define SCHEMATIC_BARZHON_BMP            25       /* BMP  */
//#define SCHEMATIC_COALITION_BMP          26       /* BMP  */
//#define SCHEMATIC_ELOWAN_BMP             27       /* BMP  */
//#define SCHEMATIC_MINEX_BMP              28       /* BMP  */
//#define SCHEMATIC_NYSSIAN_BMP            29       /* BMP  */
//#define SCHEMATIC_PIRATE_BMP             30       /* BMP  */
//#define SCHEMATIC_SPEMIN_BMP             31       /* BMP  */
//#define SCHEMATIC_TAFEL_BMP              32       /* BMP  */
//#define SCHEMATIC_THRYNN_BMP             33       /* BMP  */
//#define SHIELD_TGA                       34       /* BMP  */
//#define SHIP_BARZHON_BMP                 35       /* BMP  */
//#define SHIP_COALITION_BMP               36       /* BMP  */
//#define SHIP_ELOWAN_BMP                  37       /* BMP  */
//#define SHIP_MINEX_BMP                   38       /* BMP  */
//#define SHIP_NYSSIAN_BMP                 39       /* BMP  */
//#define SHIP_PIRATE_BMP                  40       /* BMP  */
//#define SHIP_SPEMIN_BMP                  41       /* BMP  */
//#define SHIP_TAFEL_BMP                   42       /* BMP  */
//#define SHIP_THRYNN_BMP                  43       /* BMP  */
//#define SMLASTEROID_BMP                  44       /* BMP  */
//#define WEAPON_PLASMA_32_TGA             45       /* BMP  */



/*
 * This function tracks all printed messages, each containing a timestamp to prevent
 * messages from printing out repeatedly.
 * delay = 0 means always print.
 * delay =-1 means print only once.
 * otherwise delay is number of millisecond to wait between same message.
 */
void ModuleEncounter::Print(string str, int color, long delay)
{
	g_game->printout(text, str, color, delay);
}

ModuleEncounter::ModuleEncounter(void) :
	shield(NULL),
	spr_statusbar_shield(NULL),
	snd_player_laser(NULL),
	snd_player_missile(NULL),
	snd_explosion(NULL),
	snd_laserhit(NULL),
	script(NULL),
	text(NULL),
	dialogue(NULL)
{}

ModuleEncounter::~ModuleEncounter(void){}


#pragma endregion

#pragma region INPUT

void ModuleEncounter::OnKeyPress(int keyCode)
{
	if (module_mode == 1)  //if module_mode == combat
	{
		switch (keyCode)
		{
			case KEY_RIGHT:		
                playerShip->turnright();	
                break;

			case KEY_LEFT:		
                playerShip->turnleft();		
                break;

			case KEY_DOWN:		
                playerShip->applybraking();	
				break;

			case KEY_UP:			
                playerShip->applythrust();	
                flag_thrusting = true;
                break;

			case KEY_Q:	
                if (!flag_thrusting) playerShip->applybraking();
                playerShip->starboard();	
                break;

			case KEY_E:	
                if (!flag_thrusting) playerShip->applybraking();
                playerShip->port();			
                break;

			case KEY_ALT:
			case KEY_X:
				if (!firingMissile) {
					firingLaser = true;
					fireLaser();
				}
				break;

			case KEY_LCONTROL:
            case KEY_RCONTROL:
            case KEY_Z:
				if (!firingLaser) {
					firingMissile = true,
					fireMissile();
				}
				break;
			
			default:
				break;
		}
	}
   g_game->CrossModuleAngle = playerShip->getRotationAngle();	//JJH
}

void ModuleEncounter::OnKeyPressed(int keyCode){}
void ModuleEncounter::OnKeyReleased(int keyCode)
{
	//AlienRaces alien;

	switch (keyCode)
	{
		//reset ship anim frame when key released
		
		case KEY_LEFT:
		case KEY_RIGHT:
		case KEY_DOWN:
			playerShip->cruise();
			break;

		case KEY_UP:
            flag_thrusting = false;
			playerShip->applybraking();
			playerShip->cruise();
			break;

		case KEY_Q:
		case KEY_E:
            playerShip->applybraking();
			playerShip->cruise();
			break;

		case KEY_PGUP:
			//now only possible during combat (design decision)
			break;
		case KEY_PGDN:
			//now only possible during combat (design decision)
			break;

		case KEY_ESC:		//escape key opens pause menu
			//g_game->ShowPauseMenu();
			//return;
			break;

		case KEY_ALT:
			firingLaser = false;
			break;
		case KEY_LCONTROL:
			firingMissile = false;
			break;

#ifdef DEBUGMODE
		case ALIEN_ATTITUDE_PLUS:
        {
			int attitude = g_game->gameState->getAlienAttitude(); 
		    g_game->gameState->setAlienAttitude(++attitude);
        }
		break;

		case ALIEN_ATTITUDE_MINUS:
		{
			int attitude = g_game->gameState->getAlienAttitude();
			g_game->gameState->setAlienAttitude(--attitude);
		}
		break;

		case IST_QUEST_PLUS:
		{
			int questnum = g_game->gameState->getActiveQuest();
			g_game->gameState->setActiveQuest( questnum + 1 );
		}
		break;

		case IST_QUEST_MINUS:
		{
			int questnum = g_game->gameState->getActiveQuest();
			g_game->gameState->setActiveQuest( questnum - 1 );
		}
		case KEY_F:
			g_game->toggleShowControls();
			break;
#endif

	}
}

void ModuleEncounter::OnMouseMove(int x, int y)
{
	text->OnMouseMove(x,y);
	dialogue->OnMouseMove(x,y);
}

void ModuleEncounter::OnMouseClick(int button, int x, int y)
{
	text->OnMouseClick(button,x,y);
	dialogue->OnMouseClick(button,x,y);
}

void ModuleEncounter::OnMousePressed(int button, int x, int y)
{
	text->OnMousePressed(button,x,y);
	dialogue->OnMousePressed(button,x,y);
}

void ModuleEncounter::OnMouseReleased(int button, int x, int y)
{
	text->OnMouseReleased(button,x,y);
	dialogue->OnMouseReleased(button,x,y);
}

void ModuleEncounter::OnMouseWheelUp(int x, int y)
{
	text->OnMouseWheelUp(x,y);
	dialogue->OnMouseWheelUp(x,y);
}

void ModuleEncounter::OnMouseWheelDown(int x, int y)
{
	text->OnMouseWheelDown(x,y);
	dialogue->OnMouseWheelDown(x,y);
}

#pragma endregion

#pragma region INIT_CLOSE

bool ModuleEncounter::Init()
{
	TRACE("  Encounter Initialize\n");

	// 0=encounter; 1=combat
	module_mode = 1;
	alienHailingUs = false;
	flag_DoHyperspace = false;
	hyperspaceCountdown = 0;
    flag_thrusting = false;

	deathState = 0;
	shipcount = 0;
	playerAttacked = false;
	flag_greeting = false;
	scanStatus = 0;

	goto_question = 0;
	number_of_actions = 0;

	firingLaser = firingMissile = false;

	//enable the Pause Menu
	g_game->pauseMenu->setEnabled(true);

	//load the datafile
	/*encdata = load_datafile("data/encounter/encounter.dat");
	if (!encdata) {
		g_game->message("Encounter: Error loading datafile");
		return false;
	}*/

	scroller = new TileScroller();
	scroller->setTileSize(TILESIZE,TILESIZE);
	scroller->setTileImageColumns(5);
	scroller->setRegionSize(TILESACROSS,TILESDOWN);
	scroller->setScrollPosition((TILESACROSS/2) * TILESIZE, (TILESDOWN/2) * TILESIZE);
	g_game->gameState->player->posCombat.SetPosition((TILESACROSS/2) * TILESIZE, (TILESDOWN/2) * TILESIZE);

	if (!scroller->createScrollBuffer(SCREEN_WIDTH, SCREEN_HEIGHT)) {
		g_game->message("ModuleCombat: Error creating scroll buffer");
		return false;
	}

	//re-load images used in scroller
	scroller->loadTileImage("data/encounter/IP_TILES.bmp");
    
    //load the message gui
	img_messages = (BITMAP*)load_bitmap("data/encounter/GUI_MESSAGEWINDOW.bmp",NULL);
	if (!img_messages) {
		g_game->message("Encounter: error loading img_messages");
		return false;
	}

	//load the socket gui
	img_socket = (BITMAP*)load_bitmap("data/encounter/GUI_SOCKET.bmp",NULL);
	if (!img_socket) {
		g_game->message("Encounter: error loading img_socket");
		return false;
	}

	//load the aux gui
	img_aux = (BITMAP*)load_bitmap("data/encounter/GUI_AUX.bmp",NULL);
	if (!img_aux) {
		g_game->message("error loading img_aux");
		return false;
	}

	//load the gui viewer screen
	img_viewer = (BITMAP*)load_bitmap("data/encounter/GUI_VIEWER.bmp",NULL);
	if (!img_viewer) {
		g_game->message("error loading gui_viewer");
		return false;
	}

	//create the ScrollBar for messages
	static int gmx = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_X");
	static int gmy = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_Y");
	static int gmw = (int)g_game->getGlobalNumber("GUI_MESSAGE_WIDTH");
	static int gmh = (int)g_game->getGlobalNumber("GUI_MESSAGE_HEIGHT");
	text = new ScrollBox::ScrollBox(g_game->font20,ScrollBox::SB_TEXT,gmx+39,gmy+18,gmw-54,gmh-32,EVENT_NONE);
	text->DrawScrollBar(true);

	//create the ScrollBox for dialogue (same position as messages)
	dialogue = new ScrollBox::ScrollBox(g_game->font20,ScrollBox::SB_LIST,gmx+41,gmy+18,gmw-56,gmh-32,ENCOUNTER_DIALOGUE_EVENT);
	dialogue->DrawScrollBar(false);

	//point global scrollbox to local one in this module for access by external object
    g_game->g_scrollbox = text;


	//create the player ship
	playerShip = new PlayerShipSprite();

	//initialize the encounter sub-system
	if (!Encounter_Init()) {
		Close();
		return false;
	}

	//initialize the combat sub-system
	if (!Combat_Init()) {
		Close();
		return false;
	}

	//clear screen
	clear_to_color(g_game->GetBackBuffer(), BLACK);

	//shortcuts to crew last names to simplify code
	//FIXME: these will get stale when someone get killed
	com = "Com. Off. " + g_game->gameState->getCurrentCom()->getLastName() + "-> ";
	sci = "Sci. Off. " + g_game->gameState->getCurrentSci()->getLastName() + "-> ";
	nav = "Nav. Off. " + g_game->gameState->getCurrentNav()->getLastName() + "-> ";
	tac = "Tac. Off. " + g_game->gameState->getCurrentTac()->getLastName() + "-> ";
	eng = "Eng. Off. " + g_game->gameState->getCurrentEng()->getLastName() + "-> ";
	doc = "Med. Off. " + g_game->gameState->getCurrentDoc()->getLastName() + "-> ";

	//if we start in "fullscreen" mode, all objects vertical coords must be patched
	if ( !g_game->doShowControls() )
		adjustVerticalCoords( (SCREEN_HEIGHT-NormalScreenHeight)/2 ); //  (768-512)/2 == 128

	//force start in "show control" mode for the time being
	if (!g_game->doShowControls()) g_game->toggleShowControls();
	
	return true;
}

void ModuleEncounter::Close()
{
	TRACE("*** Encounter Close\n\n");

	//force weapons and shield off
	g_game->gameState->setWeaponStatus(false);
	g_game->gameState->setShieldStatus(false);

	delete playerShip;

	Encounter_Close();
	Combat_Close();

	//unload the data file - causes Unhandled exception at 0x0f35b3aa
	//unload_datafile(encdata); 
	encdata = NULL;

	if (scroller != NULL) {	delete scroller; scroller = NULL; }
}

bool ModuleEncounter::Encounter_Init()
{
	TRACE("  Encounter_Init\n");
	ostringstream os;
	string scriptFile = "";
	string portraitFile  = "";
	string schematicFile = "";
	string spriteFile    = "";
	bFlagDialogue = false;
	commMode = COMM_NONE;
	bFlagChatting = false;

	alienName = g_game->gameState->getCurrentAlienName();

	//fill the dialog "censor"
	dialogCensor.clear();
	string firstname = g_game->gameState->officerCap->getFirstName();
	string lastname = g_game->gameState->officerCap->getLastName();
	dialogCensor.insert( make_pair("[CAPTAIN_FIRST]", firstname) );
	dialogCensor.insert( make_pair("[CAPTAIN_LAST]", lastname) );
	dialogCensor.insert( make_pair("[CAPTAIN]", firstname + " " + lastname) );
	dialogCensor.insert( make_pair("[CAPTAIN_FULLNAME]", firstname + " " + lastname) );
	dialogCensor.insert( make_pair("[SHIPNAME]", g_game->gameState->getShip().getName() ) );
	dialogCensor.insert( make_pair("[ALIEN]", alienName) );

	//load the right gui viewer
	img_rightviewer = (BITMAP*)load_bitmap("data/encounter/GUI_VIEWER_RIGHT.bmp",NULL);
	if (!img_rightviewer) {
		g_game->message("Encounter: error loading gui_viewer_right");
		return false;
	}

	/*
	 * The alien in this encounter should be pre-determined before we reach this point.
	 */

	//get the current plot stage and create an append string
	/*string stage = "";
	switch(g_game->gameState->getPlotStage()) {
		case 1: stage = "initial"; break;
		case 2: stage = "virus"; break;
		case 3: stage = "war"; break;
		case 4: stage = "ancients"; break;
	}*/


	AlienRaces region = g_game->gameState->getCurrentAlien();
	switch(region)
	{
		case ALIEN_ELOWAN:
			scriptFile = "encounter_elowan";
			portraitFile = "PORTRAIT_ELOWAN.bmp";
			schematicFile = "SCHEMATIC_ELOWAN.bmp";
			spriteFile = "SHIP_ELOWAN.bmp";
			break;
		case ALIEN_SPEMIN:
			scriptFile = "encounter_spemin";
			portraitFile = "PORTRAIT_SPEMIN.bmp";
			schematicFile = "SCHEMATIC_SPEMIN.bmp";
			spriteFile = "SHIP_SPEMIN.bmp";
			break;
		case ALIEN_THRYNN:
			scriptFile = "encounter_thrynn";
			portraitFile = "PORTRAIT_THRYNN.bmp";
			schematicFile = "SCHEMATIC_THRYNN.bmp";
			spriteFile = "SHIP_THRYNN.bmp";
			break;
		case ALIEN_BARZHON:
			scriptFile = "encounter_barzhon";
			portraitFile = "PORTRAIT_BARZHON.bmp";
			schematicFile = "SCHEMATIC_BARZHON.bmp";
			spriteFile = "SHIP_BARZHON.bmp";
			break;
		case ALIEN_NYSSIAN:
			scriptFile = "encounter_nyssian";
			portraitFile = "PORTRAIT_NYSSIAN.bmp";
			schematicFile = "SCHEMATIC_NYSSIAN.bmp";
			spriteFile = "SHIP_NYSSIAN.bmp";
			break;
		case ALIEN_TAFEL:
			scriptFile = "encounter_tafel";
			portraitFile = "PORTRAIT_TAFEL.bmp";
			schematicFile = "SCHEMATIC_TAFEL.bmp";
			spriteFile = "SHIP_TAFEL.bmp";
			break;
		case ALIEN_MINEX:
			scriptFile = "encounter_minex";
			portraitFile = "PORTRAIT_MINEX.bmp";
			schematicFile = "SCHEMATIC_MINEX.bmp";
			spriteFile = "SHIP_MINEX.bmp";
			break;
		case ALIEN_COALITION:
			scriptFile = "encounter_coalition";
			portraitFile = "PORTRAIT_COALITION.bmp";
			schematicFile = "SCHEMATIC_COALITION.bmp";
			spriteFile = "SHIP_COALITION.bmp";
			break;
		case ALIEN_PIRATE:
			scriptFile = "encounter_pirate";
			portraitFile = "PORTRAIT_PIRATE.bmp";
			schematicFile = "SCHEMATIC_PIRATE.bmp";
			spriteFile = "SHIP_PIRATE.bmp";
			break;
		default:
			break;
	}

//append stage to alien script file
//	scriptFile += "_" + stage + ".lua";  Disabled loading multiple communication files

	scriptFile = "data/encounter/" + scriptFile + ".lua";

	TRACE("  Loading encounter script: %s\n", scriptFile.c_str());

	//load the script for this encounter
	script = new Script();
	lua_register(script->getState(), "L_Debug"    , L_Debug     );
	lua_register(script->getState(), "L_Terminate", L_Terminate );
	lua_register(script->getState(), "L_Attack"   , L_Attack    );
	script->load(scriptFile);

	//set globals prior to initializing dialogue
	sendGlobalsToScript();

	//run dialogue build function in script
	if (!script->runFunction("Initialize")) return false;
	readGlobalsFromScript();	//read globals too, in case Initialize changed anything.

#ifdef DEBUGMODE
	Print("Posture: " + g_game->gameState->playerPosture,WHITE,5000);      
#endif
	
    ostringstream filename;
    ostringstream filename2;
    ostringstream filename3;

	//load the alien's portrait image
    filename << "data/encounter/" << portraitFile;
	img_alien_portrait = (BITMAP*)load_bitmap(filename.str().c_str(),NULL);
	if (!img_alien_portrait) {
		g_game->message("Encounter: Error loading portrait " + portraitFile);
		return false;
	}

	//load the alien ship's schematic image
    filename2 << "data/encounter/" << schematicFile;
	img_alien_schematic = (BITMAP*)load_bitmap(filename2.str().c_str(),NULL);
	if (!img_alien_schematic) {
		g_game->message("Encounter: Error loading schematic " + schematicFile);
		return false;
	}

	//load the alien ship's animated sprite image
    filename3 << "data/encounter/" << spriteFile;
	img_alien_ship = (BITMAP*)load_bitmap(filename3.str().c_str(),NULL);
	if (!img_alien_ship) {
		g_game->message("Encounter: Error loading ship sprite " + spriteFile);
		return false;
	}

	//statements and questions are reused until player chooses them
	//to prevent cycling to the next item in the script when CANCEL is pressed
	bFlagLastStatementSuccess = true;
	bFlagLastQuestionSuccess = true;

	bFlagDoResponse = false;
	bFlagDoAttack = false;

	return true;
}

void ModuleEncounter::Encounter_Close()
{
	if (text     != NULL) { delete text; text = NULL; }
	if (dialogue != NULL) { delete dialogue; dialogue = NULL; }
	if (script   != NULL) { delete script; script = NULL; }
}

bool ModuleEncounter::Combat_Init()
{
	combatObjects.clear();

	//create the minimap
	asw = (int)g_game->getGlobalNumber("AUX_SCREEN_WIDTH");
	ash = (int)g_game->getGlobalNumber("AUX_SCREEN_HEIGHT");
	asx = (int)g_game->getGlobalNumber("AUX_SCREEN_X");
	asy = (int)g_game->getGlobalNumber("AUX_SCREEN_Y");
	minimap = create_bitmap(asw, ash);

	//load small asteroids
	img_smlasteroid = (BITMAP*)load_bitmap("data/encounter/SMLASTEROID.bmp",NULL);
	if (!img_smlasteroid) {
		g_game->message("error loading img_smlasteroid");
		return false;
	}
	img_bigasteroid = (BITMAP*)load_bitmap("data/encounter/BIGASTEROID.bmp",NULL);
	if (!img_bigasteroid) {
		g_game->message("error loading img_bigasteroid");
		return false;
	}

	//load weapon images
	img_laserbeam = (BITMAP*)load_bitmap("data/encounter/LASER_BEAM.bmp",NULL);
	if (!img_laserbeam) {
		g_game->message("error loading img_laserbeam");
		return false;
	}
	img_plasma = (BITMAP*)load_bitmap("data/encounter/WEAPON_PLASMA_32.tga",NULL);
	if (!img_plasma) {
		g_game->message("error loading weapon_player_primary");
		return false;
	}
	img_redbolt = (BITMAP*)load_bitmap("data/encounter/RED_BOLT.bmp",NULL);
	if (!img_redbolt) {
		g_game->message("error loading img_redbolt");
		return false;
	}

	//load explosions
	img_bigexplosion = (BITMAP*)load_bitmap("data/encounter/EXPLOSION_30_128.tga",NULL);
	if (!img_bigexplosion) {
		g_game->message("error loading img_bigexplosion");
		return false;
	}
	img_medexplosion = (BITMAP*)load_bitmap("data/encounter/EXPLOSION_30_64.tga",NULL);
	if (!img_medexplosion) {
		g_game->message("error loading img_medexplosion");
		return false;
	}
	img_smlexplosion = (BITMAP*)load_bitmap("data/encounter/EXPLOSION_30_48.tga",NULL);
	if (!img_smlexplosion) {
		g_game->message("error loading img_smlexplosion");
		return false;
	}

	//load sound effects
	snd_player_laser = g_game->audioSystem->Load("data/encounter/fire1.wav");
	snd_laserhit = g_game->audioSystem->Load("data/encounter/hit1.wav");
	snd_player_missile = g_game->audioSystem->Load("data/encounter/fire2.wav");
	snd_explosion = g_game->audioSystem->Load("data/encounter/hit2.wav");

	//load powerups
	img_powerup_health = (BITMAP*)load_bitmap("data/encounter/POWERUP_HEALTH.tga",NULL);
	if (!img_powerup_health) {
		g_game->message("error loading img_powerup_health");
		return false;
	}
	img_powerup_shield = (BITMAP*)load_bitmap("data/encounter/POWERUP_SHIELD.tga",NULL);
	if (!img_powerup_shield) {
		g_game->message("error loading img_powerup_shield");
		return false;
	}
	img_powerup_armor = (BITMAP*)load_bitmap("data/encounter/POWERUP_ARMOR.tga",NULL);
	if (!img_powerup_armor) {
		g_game->message("error loading img_powerup_armor");
		return false;
	}
	img_powerup_mineral = (BITMAP*)load_bitmap("data/encounter/POWERUP_MINERAL.tga",NULL);
	if (!img_powerup_mineral) {
		g_game->message("error loading img_powerup_mineral");
		return false;
	}

	//radius is center of battle arena
	int radius = TILESACROSS/2 * TILESIZE;

	//create alien fleet
	int fleetSize = g_game->gameState->player->getAlienFleetSize();
	if (fleetSize <= 0) fleetSize = 1; //this should not happen
	for (int n=0; n < fleetSize; n++)
	{
		CombatObject *temp = new CombatObject();
		temp->setImage(img_alien_ship);
		temp->setObjectType(OBJ_ALIENSHIP);
		temp->setTotalFrames(1);
		temp->setDamage(0);

		//get health property from script
		int health = script->getGlobalNumber("health");
		if (health < 1 || health > 10000) {
			TRACE("***Error in Combat_Init: health property is invalid\n");
			health = 100;
		}
		TRACE("Combat_Init: health=%d\n", health);
		temp->setHealth( health );

		//get mass property from script
		int mass = script->getGlobalNumber("mass");
		if (mass < 1 || mass > 100) {
			TRACE("***Error in Combat_Init: mass property is invalid\n");
			mass = 1;
		}
		TRACE("Combat_Init: mass=%d\n", mass);
		temp->setMass( mass );

		//get engine class property
		int engine = script->getGlobalNumber("engineclass");
		if (engine < 1 || engine > 6) {
			TRACE("***Error in Combat_Init: engineclass is invalid\n");
			engine = 1;
		}
		TRACE("Combat_Init: engineclass=%d\n", engine);
		setEngineProperties(temp, engine);

		//get shield props from script
		int shield = script->getGlobalNumber("shieldclass");
		if (shield < 0 || shield > 8) {
			TRACE("***Error in Combat_Init: shieldclass is invalid\n");
			shield = 0;
		}
		TRACE("Combat_Init: shieldclass=%d\n", shield);
		setShieldProperties(temp, shield);

		//get armor props from script
		int armor = script->getGlobalNumber("armorclass");
		if (armor < 0 || armor > 6) {
			TRACE("***Error in Combat_Init: armorclass is invalid\n");
			armor = 0;
		}
		TRACE("Combat_Init: armorclass=%d\n", armor);
		setArmorProperties(temp, armor);

		//get laser props from script
		int laser = script->getGlobalNumber("laserclass");
		if (laser < 0 || laser > 9) {
			TRACE("***Error in Combat_Init: laserclass is invalid\n");
			laser = 0;
		}
		TRACE("Combat_Init: laserclass=%d\n", laser);
		setLaserProperties(temp, laser);

		//get laser modifier from script
		int laserModifier = script->getGlobalNumber("laser_modifier");
		if (laserModifier < 0 || laserModifier > 100) {
			TRACE("***Error in Combat_Init: laser_modifier is invalid\n");
			laserModifier = 100;
		}
		TRACE("Combat_Init: laser modifier=%d\n", laserModifier);
		temp->setLaserModifier(laserModifier);

		//get missile props from script
		int missile = script->getGlobalNumber("missileclass");
		if (missile < 0 || missile > 9) {
			TRACE("***Error in Combat_Init: laserclass is invalid\n");
			missile = 0;
		}
		TRACE("Combat_Init: missileclass=%d\n", missile);
		setMissileProperties(temp, missile);

		//get missile modifier from script
		int missileModifier = script->getGlobalNumber("missile_modifier");
		if (missileModifier < 0 || missileModifier > 100) {
			TRACE("***Error in Combat_Init: missile_modifier is invalid\n");
			missileModifier = 100;
		}
		TRACE("Combat_Init: missile modifier=%d\n", missileModifier);
		temp->setMissileModifier(missileModifier);

		//set object to random location in battlespace (somewhat close to player)
		temp->setPos(radius/2 + Util::Random(0, radius), radius/2 + Util::Random(0, radius));
		temp->setFaceAngle( (float)Util::Random(1,359) );
		temp->ApplyThrust();
		AddCombatObject(temp);
	}

	//create big asteroids
	int num = rand() % 10 + 5;
	for (int a = 0; a < num; ++a)
	{
		CombatObject *temp = new CombatObject();
		temp->setImage(img_bigasteroid);
		temp->setObjectType(OBJ_ASTEROID_BIG);
		temp->setTotalFrames(1);
		temp->setDamage(0);
		temp->setHealth(100);
		temp->setMass(4);
		temp->setVelX( (double)Util::Random(0, 3) - 2 );
		temp->setVelY( (double)Util::Random(0, 3) - 2 );
		temp->setMaxVelocity( 4.0 );
		temp->setPos(Util::Random(0, radius*2),Util::Random(0, radius*2));
		temp->setRotation( Util::Random(0,6) - 3 );
		AddCombatObject(temp);
	}

	//load animated shield sprite
	shield = new Sprite();
	shield->load("data/encounter/SHIELD.tga");
	shield->setAnimColumns(7);
	shield->setTotalFrames(14);
	shield->setFrameWidth(96);
	shield->setFrameHeight(96);
	shield->setFrameDelay(2);
	shield->setPos(464,208);

	//validate ship condition before entering encounter
	if (g_game->gameState->m_ship.getHullIntegrity() == 0)
		g_game->gameState->m_ship.setHullIntegrity(100);

	//shield start at maximum possible capacity
	g_game->gameState->m_ship.setShieldCapacity(g_game->gameState->m_ship.getMaxShieldCapacity());

	//get drop items from script (5 must be defined)
	dropitems[0].id = script->getGlobalNumber("DROPITEM1");
	dropitems[0].rate = script->getGlobalNumber("DROPRATE1");
	dropitems[0].quantity = script->getGlobalNumber("DROPQTY1");
	dropitems[1].id = script->getGlobalNumber("DROPITEM2");
	dropitems[1].rate = script->getGlobalNumber("DROPRATE2");
	dropitems[1].quantity = script->getGlobalNumber("DROPQTY2");
	dropitems[2].id = script->getGlobalNumber("DROPITEM3");
	dropitems[2].rate = script->getGlobalNumber("DROPRATE3");
	dropitems[2].quantity = script->getGlobalNumber("DROPQTY3");
	dropitems[3].id = script->getGlobalNumber("DROPITEM4");
	dropitems[3].rate = script->getGlobalNumber("DROPRATE4");
	dropitems[3].quantity = script->getGlobalNumber("DROPQTY4");
	dropitems[4].id = script->getGlobalNumber("DROPITEM5");
	dropitems[4].rate = script->getGlobalNumber("DROPRATE5");
	dropitems[4].quantity = script->getGlobalNumber("DROPQTY5");

	return true;
}

void ModuleEncounter::Combat_Close()
{
	//Delete all the combatObjects
	for (objectIt = combatObjects.begin(); objectIt != combatObjects.end(); ++objectIt)
	{
		if (*objectIt != NULL) {
			delete *objectIt;
			*objectIt = NULL;
		}
	}
	combatObjects.clear();

	if (shield)             delete shield;

	if (snd_player_laser)   delete snd_player_laser;
	if (snd_laserhit)       delete snd_laserhit;
	if (snd_player_missile) delete snd_player_missile;
	if (snd_explosion)      delete snd_explosion;

	//fully regenerate shield
	g_game->gameState->m_ship.setShieldCapacity(g_game->gameState->m_ship.getMaxShieldCapacity());
}

void ModuleEncounter::setMissileProperties(CombatObject *ship, int missileclass)
{
	switch(missileclass) {
		case 1:
			ship->setMissileFiringRate( g_game->getGlobalNumber("MISSILE1_FIRERATE") );
			ship->setMissileDamage( g_game->getGlobalNumber("MISSILE1_DAMAGE") );
			break;
		case 2:
			ship->setMissileFiringRate( g_game->getGlobalNumber("MISSILE2_FIRERATE") );
			ship->setMissileDamage( g_game->getGlobalNumber("MISSILE2_DAMAGE") );
			break;
		case 3:
			ship->setMissileFiringRate( g_game->getGlobalNumber("MISSILE3_FIRERATE") );
			ship->setMissileDamage( g_game->getGlobalNumber("MISSILE3_DAMAGE") );
			break;
		case 4:
			ship->setMissileFiringRate( g_game->getGlobalNumber("MISSILE4_FIRERATE") );
			ship->setMissileDamage( g_game->getGlobalNumber("MISSILE4_DAMAGE") );
			break;
		case 5:
			ship->setMissileFiringRate( g_game->getGlobalNumber("MISSILE5_FIRERATE") );
			ship->setMissileDamage( g_game->getGlobalNumber("MISSILE5_DAMAGE") );
			break;
		case 6:
			ship->setMissileFiringRate( g_game->getGlobalNumber("MISSILE6_FIRERATE") );
			ship->setMissileDamage( g_game->getGlobalNumber("MISSILE6_DAMAGE") );
			break;
		default:
			ship->setMissileFiringRate( 0 );
			ship->setMissileDamage( 0 );
	}
}

void ModuleEncounter::setLaserProperties(CombatObject *ship, int laserclass)
{
	switch(laserclass) {
		case 1:
			ship->setLaserFiringRate( g_game->getGlobalNumber("LASER1_FIRERATE") );
			ship->setLaserDamage( g_game->getGlobalNumber("LASER1_DAMAGE") );
			break;
		case 2:
			ship->setLaserFiringRate( g_game->getGlobalNumber("LASER2_FIRERATE") );
			ship->setLaserDamage( g_game->getGlobalNumber("LASER2_DAMAGE") );
			break;
		case 3:
			ship->setLaserFiringRate( g_game->getGlobalNumber("LASER3_FIRERATE") );
			ship->setLaserDamage( g_game->getGlobalNumber("LASER3_DAMAGE") );
			break;
		case 4:
			ship->setLaserFiringRate( g_game->getGlobalNumber("LASER4_FIRERATE") );
			ship->setLaserDamage( g_game->getGlobalNumber("LASER4_DAMAGE") );
			break;
		case 5:
			ship->setLaserFiringRate( g_game->getGlobalNumber("LASER5_FIRERATE") );
			ship->setLaserDamage( g_game->getGlobalNumber("LASER5_DAMAGE") );
			break;
		case 6:
			ship->setLaserFiringRate( g_game->getGlobalNumber("LASER6_FIRERATE") );
			ship->setLaserDamage( g_game->getGlobalNumber("LASER6_DAMAGE") );
			break;
		default:
			ship->setLaserFiringRate( 0 );
			ship->setLaserDamage( 0 );
	}
}

void ModuleEncounter::setArmorProperties(CombatObject *ship, int armorclass)
{
	switch(armorclass) {
		case 1: ship->setArmorStrength( g_game->getGlobalNumber("ARMOR1_STRENGTH") ); break;
		case 2: ship->setArmorStrength( g_game->getGlobalNumber("ARMOR2_STRENGTH") ); break;
		case 3: ship->setArmorStrength( g_game->getGlobalNumber("ARMOR3_STRENGTH") ); break;
		case 4: ship->setArmorStrength( g_game->getGlobalNumber("ARMOR4_STRENGTH") ); break;
		case 5: ship->setArmorStrength( g_game->getGlobalNumber("ARMOR5_STRENGTH") ); break;
		case 6: ship->setArmorStrength( g_game->getGlobalNumber("ARMOR6_STRENGTH") ); break;
		default: ship->setArmorStrength( 0 );
	}
}

void ModuleEncounter::setShieldProperties(CombatObject *ship, int shieldclass)
{
	switch(shieldclass) {
		case 1: ship->setShieldStrength( g_game->getGlobalNumber("SHIELD1_STRENGTH") ); break;
		case 2: ship->setShieldStrength( g_game->getGlobalNumber("SHIELD2_STRENGTH") ); break;
		case 3: ship->setShieldStrength( g_game->getGlobalNumber("SHIELD3_STRENGTH") ); break;
		case 4: ship->setShieldStrength( g_game->getGlobalNumber("SHIELD4_STRENGTH") ); break;
		case 5: ship->setShieldStrength( g_game->getGlobalNumber("SHIELD5_STRENGTH") ); break;
		case 6: ship->setShieldStrength( g_game->getGlobalNumber("SHIELD6_STRENGTH") ); break;
		default: ship->setShieldStrength( 0 );
	}

}

void ModuleEncounter::setEngineProperties(CombatObject *ship, int engineclass)
{
	//set top speed, acceleration, and turn rate based on engine class
	//these props are pulled from globals.lua, not from alien script
	switch(engineclass) {
		case 1:
			ship->setMaxVelocity( g_game->getGlobalNumber("ENGINE1_TOPSPEED") );
			ship->setAcceleration( g_game->getGlobalNumber("ENGINE1_ACCEL") );
			ship->setTurnRate( g_game->getGlobalNumber("ENGINE1_TURNRATE") );
			break;
		case 2:
			ship->setMaxVelocity( g_game->getGlobalNumber("ENGINE2_TOPSPEED") );
			ship->setAcceleration( g_game->getGlobalNumber("ENGINE2_ACCEL") );
			ship->setTurnRate( g_game->getGlobalNumber("ENGINE2_TURNRATE") );
			break;
		case 3:
			ship->setMaxVelocity( g_game->getGlobalNumber("ENGINE3_TOPSPEED") );
			ship->setAcceleration( g_game->getGlobalNumber("ENGINE3_ACCEL") );
			ship->setTurnRate( g_game->getGlobalNumber("ENGINE3_TURNRATE") );
			break;
		case 4:
			ship->setMaxVelocity( g_game->getGlobalNumber("ENGINE4_TOPSPEED") );
			ship->setAcceleration( g_game->getGlobalNumber("ENGINE4_ACCEL") );
			ship->setTurnRate( g_game->getGlobalNumber("ENGINE4_TURNRATE") );
			break;
		case 5:
			ship->setMaxVelocity( g_game->getGlobalNumber("ENGINE5_TOPSPEED") );
			ship->setAcceleration( g_game->getGlobalNumber("ENGINE5_ACCEL") );
			ship->setTurnRate( g_game->getGlobalNumber("ENGINE5_TURNRATE") );
			break;
		case 6:
			ship->setMaxVelocity( g_game->getGlobalNumber("ENGINE6_TOPSPEED") );
			ship->setAcceleration( g_game->getGlobalNumber("ENGINE6_ACCEL") );
			ship->setTurnRate( g_game->getGlobalNumber("ENGINE6_TURNRATE") );
			break;
	}
}


#pragma endregion

#pragma region COMM_ACTIONS

std::string ModuleEncounter::commGetAction()
{
	std::string action = script->getGlobalString("ACTION");
	return action;
}

void ModuleEncounter::commCheckCurrentAction()
{
	//update engine with globals from script
	readGlobalsFromScript();

	std::string action = commGetAction();

	if (action == "terminate") {
		text->Write(com + "Comm channel has been terminated!",CLR_ALERT);
		module_mode = 1;
		bFlagDialogue = false;
		bFlagChatting = false;
	}
	else if (action == "attack") {
		text->Write(com + "Comm channel has been terminated!",CLR_ALERT);
		module_mode = 1;
		bFlagDialogue = false;
		bFlagChatting = false;
		bFlagDoAttack = true;
	}
}



/*
 * Responses to greetings, statements, and questions all handled here
 * This is called by Update with a timer slowdown
 */
void ModuleEncounter::commDoAlienResponse()			//jjh
{
	std::string out;
	static int randomDelay = 0;

	//update engine with globals from script
	//readGlobalsFromScript();		//wait until response is displayed.

	//alien response is delayed 1-4 sec
	if (randomDelay == 0) randomDelay = Util::Random(1000, 4000);
	if (!Util::ReentrantDelay(randomDelay))
	{
		//temporarily disable the control panel
		g_game->ControlPanelActivity = false;
	}
	else {
		//done waiting, now display alien response
		bFlagChatting = true;
		text->Write("");
		out = script->getGlobalString("RESPONSE");				
		text->Write(com + "Response received.", CLR_MSG);

		//replace keywords in dialog string with data values
		out = replaceKeyWords(out);
		Print(alienName + "->" + out, CLR_TRANS,1000);
		commCheckCurrentAction();
		text->ScrollToBottom();

		//reset flags
		bFlagLastStatementSuccess = true;
		bFlagLastQuestionSuccess = true;
		g_game->ControlPanelActivity = true;
		bFlagDoResponse = false; //done with response
		randomDelay = 0;
	}
}

void ModuleEncounter::commDoAlienAttack()
{
	std::string out;
	static int mode = 0;
	static int randomDelay = 0;

	switch (mode)
	{
		case 0: //first delay
			if (randomDelay == 0) randomDelay = Util::Random(2000, 4000);
			if (!Util::ReentrantDelay(randomDelay))
			{
				//temporarily disable the control panel
				g_game->ControlPanelActivity = false;
			}
			else {
				//done waiting, now display alien response
				Print("",WHITE,0);
				Print( tac + "Captain, they're arming weapons!",CLR_ALERT,0);
				Print("",WHITE,0);
				text->ScrollToBottom();
				//enable the CP
				g_game->ControlPanelActivity = true;
				//reset delay
				randomDelay = 0;
				//go to next delay mode
				mode = 1;
			}
			break;

		case 1: //second delay
			if (randomDelay == 0) randomDelay = Util::Random(2000, 4000);
			if (!Util::ReentrantDelay(randomDelay))
			{
				//temporarily disable the control panel
				g_game->ControlPanelActivity = false;
			}
			else {
				//reset flag
				bFlagDoAttack = false;
				//reset delay
				randomDelay = 0;
				//enable the CP
				g_game->ControlPanelActivity = true;
				//engage in combat!
				module_mode = 1;
			}
			break;
	}
}

void ModuleEncounter::commDoPosture(int index)
{
	switch(index)
	{
		case 1:
			bFlagDialogue = false;
			text->Write("");
			if (g_game->gameState->playerPosture == "obsequious") {
				text->Write(com + "Posture is still Obsequious.",CLR_MSG);
			} else {
				text->Write(com + "Posture set to Patheti... Er... Obsequious",CLR_MSG);
				g_game->gameState->playerPosture = "obsequious";
			}
			break;
		case 2:
			bFlagDialogue = false;
			text->Write("");
			if (g_game->gameState->playerPosture == "friendly") {
				text->Write(com + "Posture is still Friendly.",CLR_MSG);
			} else {
				text->Write(com + "Posture set to Friendly",CLR_MSG);
				g_game->gameState->playerPosture = "friendly";
			}
			break;
		case 3:
			bFlagDialogue = false;
			text->Write("");
			if (g_game->gameState->playerPosture == "hostile") {
				text->Write(com + "Posture is still Hostile.",CLR_MSG);
			} else {
				text->Write(com + "Posture set to Hostile. I hope you know what you're doing!",CLR_MSG);
				g_game->gameState->playerPosture = "hostile";
			}
			break;
		case 4:
			bFlagDialogue = false;
			text->Write("");
			text->Write(com + "Posture is " + g_game->gameState->playerPosture + ".",CLR_MSG);
			break;
	}

	//set script global and run the update function:
	script->setGlobalString("POSTURE", g_game->gameState->playerPosture);
	if (!script->runFunction("UpdatePosture")) {
		TRACE("ModuleEncounter::commDoPosture\tProblem updating script globals- exiting!\n");
		return;
	}
}


void ModuleEncounter::commDoGreeting()
{
	if (playerAttacked || flag_greeting) return;

	sendGlobalsToScript();
	if (!script->runFunction("Greeting")) return;
	std::string greeting = replaceKeyWords(script->getGlobalString("GREETING"));
	text->Clear();
	if (g_game->gameState->playerPosture != "hostile")
		Print(com + "Hailing frequencies open. Sending greeting...", CLR_MSG,5000);
	else
		Print(com + "Hailing frequencies open. Sending our demands...", CLR_MSG,5000);
	Print(greeting, CLR_TRANS,5000);
	text->ScrollToBottom();

	bFlagDoResponse = true;
	alienHailingUs  = false;
	flag_greeting   = true;
}

void ModuleEncounter::commInitStatement()
{
	//ignore message buttons while in combat
	if (module_mode == 1) return;

	bFlagDialogue = true;
	commMode = COMM_STATEMENT;

	//will succeed when player uses this statement
	if (bFlagLastStatementSuccess)
	{
		//since previous statement succeeded, we need a new one
		sendGlobalsToScript();
		if (!script->runFunction("Statement")) return;
		bFlagLastStatementSuccess = false;
	}
	std::string statement = replaceKeyWords(script->getGlobalString("STATEMENT"));

	dialogue->Clear();
	dialogue->setLines(2);
	dialogue->Write(statement, CLR_LIST);
	dialogue->Write("CANCEL", CLR_MSG);
	dialogue->ScrollToTop();
}

void ModuleEncounter::commDoStatement(int index)
{
	std::string out;
	switch(index)
	{
		case 0:
			bFlagDialogue = false; //done showing statement choices
			text->Clear();
			text->Write(com + "Sending statement...", CLR_MSG);
			out = com + "" + replaceKeyWords(script->getGlobalString("STATEMENT"));
			text->Write(out, CLR_TRANS);
			text->Write("Waiting for response", CLR_MSG);
			bFlagDoResponse = true; //ready to handle alien response
			break;
		default: //cancel
			bFlagDialogue = false;
			text->Write(com + "Statement cancelled");
			bFlagDoResponse = false;
			break;
	}
}

void ModuleEncounter::commInitQuestion()
{
	//ignore message buttons while in combat
	if (module_mode == 1) return;

	std::ostringstream os;
	std::string question;
	bFlagDialogue = true;
	commMode = COMM_QUESTION;

	//will succeed when player uses this question
	if (bFlagLastQuestionSuccess)
	{
		//since previous statement succeeded, we need a new one
		sendGlobalsToScript();
		if (!script->runFunction("Question")) return;
		bFlagLastStatementSuccess = false;
	}

	//look for a branch action
	if (script->getGlobalString("ACTION") == "branch")
	{
		dialogue->Clear();
		dialogue->setLines(7);

		int choices = (int)script->getGlobalNumber("CHOICES");

		for (int n=0; n<choices; n++)
		{
			os.str("");
			os << "QUESTION" << n+1 << "_TITLE";
			question = replaceKeyWords(script->getGlobalString(os.str()));
			dialogue->Write(question, CLR_LIST);
		}

		for (int n = choices; n<6; n++)
			dialogue->Write(" ");

		dialogue->Write("CANCEL", CLR_CANCEL);
		dialogue->ScrollToTop();

	} else {	//normal non-branching question
		dialogue->Clear();
		dialogue->setLines(7);

		string text= script->getGlobalString("QUESTION_TITLE");			//exception occurs in this stmt
		//use selected question text from branch if repeating text:
		if ((text == "[REPEAT]") || (text == "[AUTO_REPEAT]")) {
			int choice= (int) script->getGlobalNumber("CHOICE");
			os.str("");		os << "QUESTION" << choice << "_TITLE";
			//perform censor string swapping:
			question= replaceKeyWords(script->getGlobalString(os.str()));
			if (text == "[REPEAT]") dialogue->Write(question, CLR_TRANS);
			if (text == "[AUTO_REPEAT]") {commDoQuestion(0);  return; }		//proceed w/o waiting
		}
		else { //print out the question title:
			question= replaceKeyWords(script->getGlobalString("QUESTION_TITLE"));
			dialogue->Write(text, CLR_TRANS);
		}

		dialogue->Write("CANCEL", CLR_CANCEL);
		dialogue->ScrollToTop();
	}

}

void ModuleEncounter::commDoQuestion(int index)
{
	std::string out;

	if (script->getGlobalString("ACTION") == "branch")
	{
		if (index < 5) // any but cancel
		{
			//send chosen branch item number back to script
			script->setGlobalNumber("CHOICE", index+1);
			if (!script->runFunction("Branch")) return;

			//get next question--should now be from new branch location
			bFlagLastQuestionSuccess = true;
			commInitQuestion();
		}
	}
	else {
		if (module_mode == 1) return;

		//normal non-branching question
		switch(index)
		{
			case 0:
				out= script->getGlobalString("QUESTION");
				//use selected question text from branch if repeating text:
				if ((out == "[REPEAT]") || (out == "[AUTO_REPEAT]")) {
					std::ostringstream os;
					int choice= (int) script->getGlobalNumber("CHOICE");
					os.str("");		os << "QUESTION" << choice;
					//perform censor string swapping:
					out= com +"" +replaceKeyWords(script->getGlobalString(os.str()));
				}
				else
					out= com +"" +replaceKeyWords(script->getGlobalString("QUESTION"));

				text->Write(out, CLR_MSG);
				bFlagDoResponse = true;
				break;

			default: //cancel
				break;
		}

		bFlagDialogue = false;
	}
}


void ModuleEncounter::commInitPosture()
{

	bFlagDialogue = true;
	commMode = COMM_POSTURE;
	dialogue->setLines(5);
	dialogue->Clear();
	dialogue->Write("Choose new posture:",CLR_MSG);
	dialogue->Write("  OBSEQUIOUS", CLR_LIST);
	dialogue->Write("  FRIENDLY", CLR_LIST);
	dialogue->Write("  HOSTILE", CLR_LIST);
	dialogue->Write("  CANCEL", CLR_CANCEL);
	dialogue->ScrollToTop();
}

#pragma endregion

#pragma region ENCOUNTER_CORE


void ModuleEncounter::OnEvent(Event *event)
{
	std::string escape;
	bool shieldStatus, weaponStatus;
	Ship ship;
	int laser,missile;

	Officer* currentCom = g_game->gameState->getCurrentCom();
	com = currentCom->getLastName() + "-> ";

	switch(event->getEventType())
	{
	case EVENT_SCIENCE_SCAN:
		scanStatus = 1;
		scanTimer.reset();
		break;

	case EVENT_SCIENCE_ANALYSIS:
		//when scan is complete, scanStatus is set to 2
		if (scanStatus == 2) scanStatus = 3;
		break;

		case EVENT_TACTICAL_WEAPONS:
			//arm/disarm weapons
			ship = g_game->gameState->getShip();
			laser = ship.getLaserClass();
			missile = ship.getMissileLauncherClass();
			if (laser == 0 && missile == 0) {
				if (g_game->gameState->getWeaponStatus() == false) {  // trying to arm inexistent weapons

					Print(tac + "Sir, we have no weapons.",ORANGE,5000);
					//do random response
					if (Util::Random(1,5) == 1) {
						Print(nav + "Remember, you spent those credits at the Cantina instead?",GREEN,5000);
						//do random reaction
						if (Util::Random(1,5) == 1) {
							Print(sci + "Watch the attitude, " + nav + "!",YELLOW,5000);
						}
					}
				}

				else // weapons were destroyed during combat; force them down
					g_game->gameState->setWeaponStatus(false);
			}
			else {
				//toggle weapon status
				weaponStatus = !g_game->gameState->getWeaponStatus();
				g_game->gameState->setWeaponStatus(weaponStatus);
				if (weaponStatus) {
					if (laser > 0)
						Print(tac + "Laser capacitors charging",ORANGE,2000);
					if (missile > 0)
						Print(tac + "Missile launcher primed and ready",ORANGE,2000);
				}
				else {
					if (laser > 0)
						Print(tac + "Lasers disarmed",ORANGE,2000);
					if (missile > 0)
						Print(tac + "Missile launcher disarmed",ORANGE,2000);
				}
			}
			break;
		case EVENT_TACTICAL_SHIELDS:
			ship = g_game->gameState->getShip();
			if (ship.getShieldClass() == 0) {
				if (g_game->gameState->getShieldStatus() == false)
					Print(tac + "Sir, we have no shields.",ORANGE,2000);

				else // shield destroyed during combat; force them down
					g_game->gameState->setShieldStatus(false);
			}
			else {
				//toggle shield status
				shieldStatus = g_game->gameState->getShieldStatus();
				g_game->gameState->setShieldStatus( !shieldStatus );
				if (shieldStatus)
					Print(tac + "Dropping shields.",ORANGE,2000);
				else
					Print(tac + "Aye, sir; shields up.",ORANGE,2000);
			}
			break;
		case EVENT_SHOW_CONTROLS: adjustVerticalCoords(
			-(SCREEN_HEIGHT-NormalScreenHeight)/2 ); break; // -128
		case EVENT_HIDE_CONTROLS: adjustVerticalCoords(
			(SCREEN_HEIGHT-NormalScreenHeight)/2 );  break; // +128
		//Pause Screen events
		case 0xDEADBEEF + 2: //save game
			//g_game->gameState->AutoSave();
			Print("<Game Save is not available during encounters>", WHITE, -1);
			break;
		case 0xDEADBEEF + 3: //load game
			g_game->gameState->AutoLoad();
			//Print("<Game Load is not available during encounters>", WHITE, -1);
			break;
		case 0xDEADBEEF + 4: //quit game
			g_game->setVibration(0);
			escape = g_game->getGlobalString("ESCAPEMODULE");
			g_game->modeMgr->LoadModule(escape);
			break;

		case EVENT_NAVIGATOR_HYPERSPACE:
			flag_DoHyperspace = !flag_DoHyperspace;
			hyperspaceCountdown = 5;
			break;

		case EVENT_COMM_HAIL:
			if (getShipCount() == 0) {
				Print(com + "There are no alien ships to hail",YELLOW,2000);
				module_mode = 1;
			}
			else {
				if (alienHailingUs && !flag_greeting) {
					Print(com + "Responding...",CLR_MSG,5000);
					module_mode = 0;
					commDoGreeting();
				}
				else if (!flag_greeting)
				{
					Print(com + "Hailing...",CLR_MSG,2000);
					module_mode = 0;
					commDoGreeting();
				}
				else
					(module_mode == 0) ?
						Print(com + "Sir, communication channel is open already.",CLR_MSG,5000) :
						Print(com + "Sir, they are ignoring our hail.",CLR_MSG,5000);
			}
			break;

		case EVENT_COMM_DISTRESS:
			Print(com + "Interstellar communications are currently being jammed by nearby alien hyperspace sources.",YELLOW,5000);
			break;

		case EVENT_COMM_STATEMENT:
			commInitStatement();
			break;
		case EVENT_COMM_QUESTION:
			commInitQuestion();
			break;
		case EVENT_COMM_POSTURE:
			commInitPosture();
			break;
		case EVENT_COMM_TERMINATE:
			if (module_mode == 0) {
				text->Write(com + "Terminating...",CLR_MSG);
				module_mode = 1;
				bFlagDialogue = false;
				bFlagChatting = false;

				//since communication ended from player decision, we consider it a success
				//and therefore award one skill point for it.
				//if ( currentCom->SkillUp(SKILL_COMMUNICATION) )
				//	Print(com + "I think I'm getting better at this.", PURPLE,5000);
			}
			break;

		case ENCOUNTER_DIALOGUE_EVENT: {
			int index = dialogue->GetSelectedIndex();
			switch(commMode)
			{
				case COMM_STATEMENT:
					commDoStatement(index);
					break;
				case COMM_QUESTION:
					commDoQuestion(index);
					break;
				case COMM_POSTURE:
					commDoPosture(index);
					break;

				default: ASSERT(0);
			}
			break;
		}

		case ENCOUNTER_CLOSECOMM_EVENT: {
			if (module_mode == 0) {
				text->Write(com + "Comm channel has been terminated!",CLR_ALERT);
				module_mode = 1;
				bFlagDialogue = false;
				bFlagChatting = false;
			}
			break;
		}

		case ENCOUNTER_ALIENATTACK_EVENT: {
			if (module_mode == 0) {
				text->Write(com + "Comm channel has been terminated!",CLR_ALERT);
				module_mode = 1;
				bFlagDialogue = false;
				bFlagChatting = false;
			}

			bFlagDoAttack = true;

			break;
		}
	}
}

void ModuleEncounter::Update()
{
	static Timer countdown;
	static Timer update;
	ostringstream os;

	//update scrolling and draw tiles on the scroll buffer
	playerGlobal.x = g_game->gameState->player->posCombat.x + playerShip->getVelocityX();
	playerGlobal.y = g_game->gameState->player->posCombat.y + playerShip->getVelocityY();
	g_game->gameState->player->posCombat.x = playerGlobal.x;
	g_game->gameState->player->posCombat.y = playerGlobal.y;

	//does player want to bug out?
	if (flag_DoHyperspace)
	{
		if ( g_game->gameState->getShieldStatus() ) {
			Print(nav + "We can't enter hyperspace with our shields activated.", ORANGE, 5000);
			flag_DoHyperspace = false;
		} else if( g_game->gameState->getWeaponStatus() ){
			Print(nav + "We can't enter hyperspace with our weapons armed.", ORANGE, 5000);
			flag_DoHyperspace = false;
		}

		if (playerAttacked) {
			Print(nav + "Sir, the hyperspace field has failed!", RED, 5000);
			flag_DoHyperspace = false;
		}
	}
	//CAN the player bug out?
	if (flag_DoHyperspace)
	{
		Print(nav + "Engaging hyperspace engine...", ORANGE, -1);
		// SW force player to stop
		playerShip->applybraking();
		//wait for countdown
		if (countdown.stopwatch(750))
		{
			hyperspaceCountdown--;
			os << hyperspaceCountdown << "...";
			Print(os.str(), ORANGE, -1);
			if (hyperspaceCountdown == 0)
			{
				g_game->gameState->m_ship.ConsumeFuel();
				//g_game->modeMgr->LoadModule(MODULE_HYPERSPACE);
                string prev = g_game->modeMgr->GetPrevModuleName();
                g_game->modeMgr->LoadModule( prev );
				return;
			}
		}
	}

	//keep player on the combat area
	double sx = playerGlobal.x-SCREEN_WIDTH/2;
	if (sx < -5) {
		sx = -5;
		playerShip->applybraking();
	}
	else if (sx > TILESIZE * TILESACROSS) {
		sx = TILESIZE * TILESACROSS;
		playerShip->applybraking();
	}
	double sy = playerGlobal.y-effectiveScreenHeight()/2;
	if (sy < -5) {
		sy = -5;
		playerShip->applybraking();
	}
	else if (sy > TILESIZE * TILESDOWN) {
		sy = TILESIZE * TILESACROSS;
		playerShip->applybraking();
	}

	//update scroll position
	scroller->setScrollPosition(sx,sy);
	scroller->updateScrollBuffer();

	//calculate player's screen position
	playerScreen.x = playerGlobal.x / (TILESIZE * TILESACROSS) + SCREEN_WIDTH/2 - 32;
	playerScreen.y = playerGlobal.y / (TILESIZE * TILESDOWN) + effectiveScreenHeight()/2 - 32;


	//if this is a friendly alien, they will initiate conversation
	if (g_game->gameState->getAlienAttitude() > 60 && !bFlagChatting && !alienHailingUs && !flag_greeting && !playerAttacked) {
		alienHailingUs = true;
		Print(com + "Sir, we're being hailed", STEEL, 8000);
	}

	//update dialog and combat sections
	if (module_mode == 0)
		Encounter_Update();
	else
		Combat_Update();


	//update globals in script regularly
	if (update.stopwatch(1000)) {
		//set script globals and run the update function, if not in the middle of processing a
		//greeting, statement or question (when it might interfere):
	/*	if ((!bFlagDialogue) && (!bFlagDoResponse)) {
			sendGlobalsToScript();
			if (!script->runFunction("Update")) {
				TRACE("ModuleEncounter::Update\tProblem updating script globals- exiting!\n");
				return;
			}
			readGlobalsFromScript();
		}*/
	}

	//refresh text list
	text->ScrollToBottom();

}

void ModuleEncounter::Draw()
{
	//Module::Draw();
	std::ostringstream os;

	//draw space background
	scroller->drawScrollWindow(g_game->GetBackBuffer(), 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

	//draw player ship
	playerShip->draw(g_game->GetBackBuffer());

	//let encounter/combat draw their stuff
	(module_mode == 0)?  Encounter_Draw() : Combat_Draw();

	//draw minimap
	DrawMinimap();

	if (g_game->doShowControls()){
		//draw message window gui
		static int gmx = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_X");
		static int gmy = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_Y");
		static int gmw = (int)g_game->getGlobalNumber("GUI_MESSAGE_WIDTH");
		static int gmh = (int)g_game->getGlobalNumber("GUI_MESSAGE_HEIGHT");
		masked_blit(img_messages, g_game->GetBackBuffer(), 0, 0, gmx, gmy, gmw,  
gmh);

		//draw message and list boxes
		(bFlagDialogue)? dialogue->Draw(g_game->GetBackBuffer()) :  
text->Draw(g_game->GetBackBuffer());

		//draw socket gui
		static int gsx = (int)g_game->getGlobalNumber("GUI_SOCKET_POS_X");
		static int gsy = (int)g_game->getGlobalNumber("GUI_SOCKET_POS_Y");
		masked_blit(img_socket, g_game->GetBackBuffer(), 0, 0, gsx, gsy,  
img_socket->w, img_socket->h);

		// draw the aux gui
		static int gax = (int)g_game->getGlobalNumber("GUI_AUX_POS_X");
		static int gay = (int)g_game->getGlobalNumber("GUI_AUX_POS_Y");
		masked_blit(img_aux, g_game->GetBackBuffer(), 0, 0, gax, gay,  
img_aux->w, img_aux->h);
	}

    if (g_game->getGlobalBoolean("DEBUG_OUTPUT") == true)
    {
	    //DEBUG CODE
	    int y=90;
	    g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "# of actions: " + Util::ToString(number_of_actions) );
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "Alien: " + alienName );
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "Mode: " + Util::ToString(module_mode) );
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "Chatting? " + Util::ToString(bFlagChatting) );
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "Dialogue? " + Util::ToString(bFlagDialogue) );
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "Response? " + Util::ToString(bFlagDoResponse) );
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "Attack? " + Util::ToString(bFlagDoAttack) );
//-------
		int attitude = g_game->gameState->getAlienAttitude();
		y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "Attitude " + Util::ToString(attitude) );		//jjh - debugging Coalition encounter lua file
//-------
	    Ship ship = g_game->gameState->getShip();
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "Ship: ");
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, " Armor : " + Util::ToString(ship.getArmorIntegrity()) );
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, " Hull  : " + Util::ToString(ship.getHullIntegrity()) );
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, " Engine: " + Util::ToString(ship.getEngineIntegrity()) );
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, " Miss. : " + Util::ToString(ship.getMissileLauncherIntegrity()) );
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, " Laser : " + Util::ToString(ship.getLaserIntegrity()) );
	    y+=20;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, " Shields: ");
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "  Int. : " + Util::ToString(ship.getShieldIntegrity()) );
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "  Cap. : " + Util::ToString(ship.getShieldCapacity()) );
	    y+=20;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "Weapon Status: " + Util::ToString(g_game->gameState->getWeaponStatus()) );
	    y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "Shield Status: " + Util::ToString(g_game->gameState->getShieldStatus()) );
		y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 890, y, "Angle: " + Util::ToString(g_game->CrossModuleAngle) );  //JJH

    }

}

void ModuleEncounter::Encounter_Update()
{
	//stop the ship
	playerShip->applybraking();

	//see if alien response is ready
	if (bFlagDoResponse)
	{
		commDoAlienResponse();
	}

	//see if alien is attacking
	if (bFlagDoAttack)
	{
		commDoAlienAttack();
	}
}

/*
 * Draw the gui viewer window with alien portrait
 */
void ModuleEncounter::Encounter_Draw()
{
	//even when module_mode = 0, bFlagChatting determines whether communication is taking place
	if (bFlagChatting)
	{
		static int gvx = (int)g_game->getGlobalNumber("GUI_VIEWER_POS_X");
		static int gvy = (int)g_game->getGlobalNumber("GUI_VIEWER_POS_Y");
		masked_blit(img_viewer, g_game->GetBackBuffer(), 0, 0, gvx, gvy, img_viewer->w, img_viewer->h);
		blit(img_alien_portrait, g_game->GetBackBuffer(), 0, 0, gvx+108, gvy+34, img_alien_portrait->w, img_alien_portrait->h);

		//draw gui schematic window with ship schematic
		static int gvrx = (int)g_game->getGlobalNumber("GUI_RIGHT_VIEWER_POS_X");
		static int gvry = (int)g_game->getGlobalNumber("GUI_RIGHT_VIEWER_POS_Y");
		masked_blit(img_rightviewer, g_game->GetBackBuffer(), 0, 0, gvrx, gvry, img_rightviewer->w, img_rightviewer->h);
		blit(img_alien_schematic, g_game->GetBackBuffer(), 0, 0, gvrx+34, gvry+34, img_alien_schematic->w, img_alien_schematic->h);
	}
}


string ModuleEncounter::replaceKeyWords(string input)
{
	string key,value;
	string::size_type pos;

	map<string,string>::iterator iter;
	iter = dialogCensor.begin();
	while ( iter != dialogCensor.end() )
	{
		key = iter->first;
		value = iter->second;

		pos = input.find(key,0);
		if( pos != string::npos ) {
			input.replace(pos,key.length(),value);
		}
		++iter;
	}

	return input;
}
#pragma endregion

#pragma region COLLISIONS

void ModuleEncounter::ImpactPlayer(CombatObject *player,CombatObject *other)
{
	static double bump = 1.2;
	double vx,vy,x1,y1,x2,y2;

    try
    {
	    //first, move the objects off each other
	    while (player->CheckCollision( other ))
	    {
		    x1 = g_game->gameState->player->posCombat.x + 32;
		    y1 = g_game->gameState->player->posCombat.y + 32;
		    x2 = other->getX() + other->getFrameWidth()/2;
		    y2 = other->getY() + other->getFrameHeight()/2;

		    if ( x1 < x2 ) {
			    g_game->gameState->player->posCombat.x -= bump;
			    other->setX( other->getX() + bump );
		    }
		    else {
			    g_game->gameState->player->posCombat.x += bump;
			    other->setX( other->getX() - bump );
		    }

		    if ( y1 < y2 ) {
			    g_game->gameState->player->posCombat.y -= bump;
			    other->setY( other->getY() + bump );
		    }
		    else {
			    g_game->gameState->player->posCombat.y += bump;
			    other->setY( other->getY() - bump );
		    }
	    }


	    //second, velocity affected by mass
	    double mass_factor = 1.0;
	    double modifier = 0.005;

	    //calculate mass ratio
	    if (player->getMass() > 0.0)
		    mass_factor = other->getMass() / (player->getMass());

	    double angle = other->getFaceAngle() - 90.0;
	    vx = Sprite::calcAngleMoveX( (int)angle ) * mass_factor * modifier;
	    vy = Sprite::calcAngleMoveY( (int)angle ) * mass_factor * modifier;

        playerShip->setVelocityX( playerShip->getVelocityX() + vx );
        playerShip->setVelocityY( playerShip->getVelocityY() + vy );
    }
    catch(std::exception e)
    {
        g_game->fatalerror(e.what());
    }
}

void ModuleEncounter::pickupRandomDropItem()
{
	//add random mineral to the ship's cargo
	int rate,itemid,numitems;
	ostringstream os;

	//mineral IDs range from 30 to 54 (in case no random item drop is chosen)
	//FIXME: should use itemType instead of hardcoded IDs
	itemid = Util::Random(30,54);
	numitems = Util::Random(1,4);
	Item *item = g_game->dataMgr->GetItemByID( itemid );
	if (item == NULL) {
		TRACE("*** Error: pickupRandomDropItem generated invalid item id\n");
		return;
	}

	//use script drop item data
	for (int n=0; n<5; n++)
	{
		//get a random #
		rate = Util::Random(1,100);
		//is # within % drop rate?
		if (dropitems[n].rate <= rate)
		{
			//yes, set this itemid to scripted dropitem
			itemid = dropitems[n].id;

			//number of units to add
			numitems = Util::Random(1, dropitems[n].quantity );

			break;
		}
	}
	item = g_game->dataMgr->GetItemByID( itemid );
	if (item->IsArtifact()) numitems = 1;

	//special-casing for artifacts.
	if (item->IsArtifact()){
		Item itemInHold; int numInHold;
		g_game->gameState->m_items.Get_Item_By_ID(itemid, itemInHold, numInHold);

		//if the artifact is already in hold
		if (numInHold > 0) {
			Print(sci + "This stuff is useless!", RED, 1000);
			return;
		}

		//else we pick exactly one of that artifact
		g_game->gameState->m_items.AddItems(itemid, 1);
		Print (sci + "We found the " + item->name + "!", RED, 1000);

		//broadcast inventory change
		Event e(CARGO_EVENT_UPDATE);
		g_game->modeMgr->BroadcastEvent(&e);

		return;
	}

	//Not an artifact
	int freeSpace = g_game->gameState->m_ship.getAvailableSpace();

	if ( freeSpace <= 0 ){
		Print(eng + "Sir, we don't have any space left in the cargo hold!", RED, 1000);
		return;
	}

	//do not pick up more than available cargo space
	if (numitems > freeSpace) numitems = freeSpace;
	g_game->gameState->m_items.AddItems(itemid, numitems);

	//notify player
	os << sci << "We picked up ";
	(numitems > 1)? 
		os << numitems << " cubic meters of " << item->name << "." :
		os << "one cubic meter of " << item->name << ".";

	Print(os.str(), YELLOW, 1000);

	//broadcast inventory change
	Event e(CARGO_EVENT_UPDATE);
	g_game->modeMgr->BroadcastEvent(&e);
}

void ModuleEncounter::pickupAsteroidMineral()
{
	ostringstream os;
	int itemid, numitems;

	//mineral IDs range from 30 to 54.
	//FIXME: should use itemType instead of hardcoded IDs
	itemid = Util::Random(30,54);
	numitems = Util::Random(1,4);
	Item *item = g_game->dataMgr->GetItemByID( itemid );
	if (item == NULL) {
		TRACE("*** Error: pickupAsteroidMineral generated invalid item id\n");
		return;
	}

	int freeSpace = g_game->gameState->m_ship.getAvailableSpace();
	if ( freeSpace <= 0 ){
		Print(eng + "Sir, we don't have any space left in the cargo hold!", RED, 1000);
		return;
	}

	//do not pick up more than available cargo space
	if (numitems > freeSpace) numitems = freeSpace;
	g_game->gameState->m_items.AddItems(itemid, numitems);

	//notify player
	os << sci << "We picked up ";
	(numitems > 1)? 
		os << numitems << " cubic meters of " << item->name << "." :
		os << "one cubic meter of " << item->name << ".";

	Print(os.str(), YELLOW, 1000);

	//broadcast inventory change
	Event e(CARGO_EVENT_UPDATE);
	g_game->modeMgr->BroadcastEvent(&e);
}

void ModuleEncounter::applyDamageToShip(int damage, bool hullonly)
{
	//reduce player's shield, armor, hull
	Ship ship = g_game->gameState->getShip();
	int shield = ship.getShieldCapacity();
	int armor = ship.getArmorIntegrity();
	int hull = ship.getHullIntegrity();

    // This is only used for a collision which immediately damages ship systems regardless of a shield
	if (!hullonly) 
    {
		//reduce shield level
		//is shield equipped and raised?
		if (ship.getShieldClass() > 0 && g_game->gameState->getShieldStatus()) 
        {
			shield -= damage;
			ship.setShieldCapacity(shield);
			damage = 0 - shield;
			//there is still a small chance that ship systems get some damage when shields are raised
			ship.damageRandomSystemOrCrew(10,1,5);
		}
	}

    // Armor is part of the hull

	//if shield gone, then hit the armor
	if (damage > 0) 
    {
		if (ship.getArmorClass() > 0) 
        {
			//get remaining damage from negative shield value
			armor -= damage;
			ship.setArmorIntegrity(armor);
			damage = 0 - armor;

			//damage random ship system or crew 
			ship.damageRandomSystemOrCrew(10,1,5);
		}
	}

	//hit major systems
	if (damage > 0) 
    {
		//get remaining damage from negative armor value
        ship.damageRandomSystemOrCrew(100, damage, damage);
		//ship destroyed?
		if (hull <= 0.0f)
			g_game->gameState->player->setAlive(false);
	}

	//if both weapon systems were destroyed, force them down
	if ( ship.getLaserIntegrity() <= 1 && ship.getMissileLauncherIntegrity() <= 1 )
		g_game->gameState->setWeaponStatus(false);

	//if shields were damaged, force them down
	if ( ship.getShieldIntegrity() <= 1 )
		g_game->gameState->setShieldStatus(false);


	//save ship properties
	g_game->gameState->setShip(ship);
}

void ModuleEncounter::combatTestPlayerCollision(CombatObject *other)
{
	float shield,armor;//,hull;
	Ship ship;

	//create scratch object for player ship
	CombatObject *player = new CombatObject();
	player->setX( playerScreen.x );
	player->setY( playerScreen.y );
	player->setFrameWidth(64);
	player->setFrameHeight(64);
	player->setMass(1.0);

	//reset player hit flag
	playerAttacked = false;

	if ( player->CheckCollision(other) )
	{
		switch(other->getObjectType()) {
			case OBJ_ENEMYFIRE:
				Print(tac + "We're under attack!", RED, -1);
				player->ApplyImpact(other);
				ImpactPlayer(player,other);
				g_game->audioSystem->Play(snd_laserhit);
				other->setAlive(false);
				applyDamageToShip( other->getDamage() );
 				combatDoSmlExplosion(player,other);
				playerAttacked = true;
				break;

			case OBJ_ALIENSHIP:
				Print(nav + "Collision alert!", YELLOW, 5000);
				applyDamageToShip( 1, true );
				player->ApplyImpact(other);
				ImpactPlayer(player,other);
				playerAttacked = true;
				break;

			case OBJ_ASTEROID_BIG:
				Print(nav + "Major collision alert!", YELLOW, 5000);
				applyDamageToShip( 2, true );
				player->ApplyImpact(other);
				ImpactPlayer(player,other);
				playerAttacked = true;
				break;

			case OBJ_ASTEROID_MED:
				Print(nav + "Collision alert!", YELLOW, 5000);
				applyDamageToShip( 1, true );
				player->ApplyImpact(other);
				ImpactPlayer(player,other);
				playerAttacked = true;
				break;

			case OBJ_POWERUP_HEALTH: //fix hull
				Print(eng + "We got a Hull Powerup!", GREEN, 1000);
				other->setAlive(false);
				ship = g_game->gameState->getShip();
				//hull = ship.getHullIntegrity() + 20;
				//ship.setHullIntegrity(hull);
                ship.augHullIntegrity(20);
				g_game->gameState->setShip(ship);
				break;

			case OBJ_POWERUP_SHIELD: //fix shield
				Print(tac + "We got a Shield Powerup!", GREEN, 1000);
				other->setAlive(false);
				ship = g_game->gameState->getShip();
				shield = ship.getShieldCapacity() + 20 * g_game->gameState->getShip().getShieldClass();
				if (shield > ship.getMaxShieldCapacity()) shield = ship.getMaxShieldCapacity();
				ship.setShieldCapacity(shield);
				g_game->gameState->setShip(ship);
				break;

			case OBJ_POWERUP_ARMOR: //fix armor
				Print(eng + "We got an Armor Powerup!", GREEN, 1000);
				other->setAlive(false);
				ship = g_game->gameState->getShip();
				armor = ship.getArmorIntegrity() + 20 * g_game->gameState->getShip().getArmorClass();
				if (armor > ship.getMaxArmorIntegrity()) armor = ship.getMaxArmorIntegrity();
				ship.setArmorIntegrity(armor);
				g_game->gameState->setShip(ship);
				break;

			case OBJ_POWERUP_MINERAL_FROM_SHIP: //pickup mineral or artifact from ship
				other->setAlive(false);
				pickupRandomDropItem();
				break;

			case OBJ_POWERUP_MINERAL_FROM_ASTEROID: //pickup mineral from asteroid
				other->setAlive(false);
				pickupAsteroidMineral();
				break;
		}
	}

	delete player;
}

void ModuleEncounter::damageAlienAttitude()
{
	ostringstream os;

	//reduce attitude due to player's attack
	int attitude = g_game->gameState->getAlienAttitude() - 1;
	g_game->gameState->setAlienAttitude( attitude );

	//respond to the attack
	if (attitude < 30) {
		bFlagDoAttack = true;
		os.str("");
		os << com << "The " << alienName << " now despise us.";
		Print(os.str(), STEEL, -1);
	}
	else if (attitude < 50) {
		bFlagDoAttack = true;
		os.str("");
		os << com << "The " << alienName << " now hate us.";
		Print(os.str(), STEEL, -1);
	}
	else if (attitude < 60) {
		bFlagDoAttack = true;
		os.str("");
		os << com << "The " << alienName << " now distrust us.";
		Print(os.str(), STEEL, -1);
	}
	else if (attitude < 80) {
		os.str("");
		os << com << "What are you doing!? The " << alienName << " trust us!";
		Print(os.str(), STEEL, 5000);
	}
	else {
		os.str("");
		os << com << "Are you crazy!? The " << alienName << " are friendly!";
		Print(os.str(), STEEL, 5000);
	}
}

void ModuleEncounter::combatDoCollision(CombatObject *first, CombatObject *second)
{
	int h,d,a,s;
//	int attitude;
	double damage_modifier;

	switch(first->getObjectType())
	{
		case OBJ_ALIENSHIP:
		case OBJ_ASTEROID_BIG:
		case OBJ_ASTEROID_MED:
			switch(second->getObjectType()) {
				case OBJ_ALIENSHIP:
				case OBJ_ASTEROID_BIG:
				case OBJ_ASTEROID_MED:
					first->ApplyImpact(second);
					break;
			}
			break;

		case OBJ_PLAYERLASER:
		case OBJ_PLAYERMISSILE:
			switch(second->getObjectType()) {
				case OBJ_ALIENSHIP:
                    {
					//player's projectile hits alien ship
                    double d = Math::Distance(playerShip->getX(), playerShip->getY(), second->getX(), second->getY());
                    if (d < 500)
					    g_game->audioSystem->Play(snd_laserhit);

					combatDoSmlExplosion(first,second);
					first->setAlive(false);

					s = second->getShieldStrength();
					a = second->getArmorStrength();
					h = second->getHealth();
					(first->getObjectType() == OBJ_PLAYERLASER)?
						damage_modifier = second->getLaserModifier()/100.0 :
						damage_modifier = second->getMissileModifier()/100.0 ;
					d = (int) ( first->getDamage() * damage_modifier ); 

					//TRACE("Encounter: unmodified damage=%.2f, modifier=%.2f, modified damage=%d\n", first->getDamage(), damage_modifier, d);

                    //hit their shield
					if (d > 0 && s > 0) {
						second->setShieldStrength(s-d);
						d = 0 -(s-d);
					}
                    //hit their armor
					if (d > 0 && a > 0) {
						second->setArmorStrength(a-d);
						d = 0 -(a-d);
					}
                    //hit their hull
					if (d > 0)
						second->setHealth(h-d);

					if (second->getHealth() < 0)
					{
						//*** enemy ship destroyed--

						second->setAlive(false);
						combatDoBigExplosion(second);
						combatDoPowerup(second);

						//adjust attitude
                        damageAlienAttitude();

						//award a skill point to the tactical officer
						Officer *currentTac = g_game->gameState->getCurrentTac();
						if (currentTac->SkillUp(SKILL_TACTICAL))
							Print(currentTac->getLastName() + "-> I think I'm getting better at this.", PURPLE,5000);
					}

					//if alien doesn't realize it yet, tell them we're hostile
					damageAlienAttitude();
                    }

					break;

				case OBJ_ASTEROID_BIG:
					g_game->audioSystem->Play(snd_laserhit);
					combatDoSmlExplosion(first,second);
					first->setAlive(false);
					h = second->getHealth();
					d = (int)first->getDamage();
					second->setHealth(h-d);
					if (second->getHealth() < 0)
					{
						second->setAlive(false);
						combatDoMedExplosion(second);
						combatDoBreakAsteroid(second);
					}
					break;
				case OBJ_ASTEROID_MED:
					g_game->audioSystem->Play(snd_laserhit);
					combatDoSmlExplosion(first,second);
					first->setAlive(false);
					h = second->getHealth();
					d = (int)first->getDamage();
					second->setHealth(h-d);
					if (second->getHealth() < 0)
					{
						second->setAlive(false);
						combatDoMedExplosion(second);
						//launch random powerup/mineral
						combatDoPowerup(second);
					}
					break;

			}
			break;

		case OBJ_ENEMYFIRE:
			switch(second->getObjectType()) {
				case OBJ_ASTEROID_BIG:
					g_game->audioSystem->Play(snd_laserhit);
					combatDoSmlExplosion(first,second);
					first->setAlive(false);
					h = second->getHealth();
					d = (int)first->getDamage();
					second->setHealth(h-d);
					if (second->getHealth() < 0)
					{
						second->setAlive(false);
						combatDoMedExplosion(second);
						combatDoBreakAsteroid(second);
					}
					break;
				case OBJ_ASTEROID_MED:
					g_game->audioSystem->Play(snd_laserhit);
					combatDoSmlExplosion(first,second);
					first->setAlive(false);
					h = second->getHealth();
					d = (int)first->getDamage();
					second->setHealth(h-d);
					if (second->getHealth() < 0)
					{
						second->setAlive(false);
						combatDoMedExplosion(second);
					}
					break;
			}
			break;
	}
}


#pragma endregion

#pragma region COMBAT_CORE

void ModuleEncounter::DoAlienShipCombat(CombatObject *ship)
{
	double dist;
	double targetAngle;//,behindAngle;
	double x,y,pgx,pgy;

	//keep ship inside the arena
	Rect bounds = getBoundary();
	if (!bounds.contains(ship->getX(),ship->getY())) {
		ship->AllStop();
		//keep ship inside boundary--horizontal
		if (ship->getX() < bounds.left) {
			ship->setX( bounds.left );
			ship->setFaceAngle( Util::WrapValue( ship->getFaceAngle() + 180.0 ) );
		}
		else if (ship->getX() + ship->getFrameWidth() > bounds.right) {
			ship->setX( bounds.right - ship->getFrameWidth() );
			ship->setFaceAngle( Util::WrapValue( ship->getFaceAngle() + 180.0 ) );
		}
		//keep ship inside boundary--vertical
		if (ship->getY() < bounds.top) {
			ship->setY( bounds.top );
			ship->setFaceAngle( Util::WrapValue( ship->getFaceAngle() + 180.0 ) );
		}
		else if (ship->getY() + ship->getFrameHeight() > bounds.bottom) {
			ship->setY( bounds.bottom - ship->getFrameHeight() );
			ship->setFaceAngle( Util::WrapValue( ship->getFaceAngle() + 180.0 ) );
		}
	}

	//get current alien race attitude toward player
	AlienRaces region = g_game->gameState->player->getGalacticRegion();
	int attitude = g_game->gameState->alienAttitudes[region];

	//if alien is really angry or player starts attacking...
	if (attitude < 31 || bFlagDoAttack) {
		//flee if in danger
		//if (ship->getHealth() < 15)
		//	ship->setBehavior(BEHAVIOR_FLEE);
		//else
			ship->setBehavior(BEHAVIOR_ATTACK);
	}
	else {
		//this alien is friendly
		ship->setBehavior(BEHAVIOR_WANDER);
	}


	//get current positions
	x = ship->getX()+32;
	y = ship->getY()+32;
	pgx = playerGlobal.x+SCREEN_WIDTH/2+32;
	pgy = playerGlobal.y+effectiveScreenHeight()/2+32;

	int missileRange = (int)g_game->getGlobalNumber("ALIEN_MISSILE_RANGE");     // was 900
	int laserRange   = (int)g_game->getGlobalNumber("ALIEN_LASER_RANGE");       // was 500
	int safetyDistance = (int)g_game->getGlobalNumber("ALIEN_SAFETY_DISTANCE"); // was 600

	bool missileIsGreaterRange = missileRange > laserRange;
	int longRange = missileIsGreaterRange? missileRange : laserRange;
	int shortRange = missileIsGreaterRange? laserRange : missileRange;

	//move ship based on behavior
	switch(ship->getBehavior()) {
		case BEHAVIOR_WANDER:
			//normally just move at half speed
			if (ship->getRelativeSpeed() < ship->getMaxVelocity()-1.0)
				ship->ApplyThrust();
			break;
/*
		case BEHAVIOR_FLEE:
			//if in range, speed up and evade
			dist = Math::Distance(x,y,pgx,pgy);
 			if (dist < safetyDistance) {
				//attempt to flee away from player
				targetAngle = Math::AngleToTarget(x,y,pgx,pgy);
				targetAngle = Math::wrapAngleDegs(90.0 + Math::toDegrees(targetAngle) );
				behindAngle = Math::wrapAngleDegs( ship->getFaceAngle() + 180.0 );
				//flee to the right
				if (targetAngle <= behindAngle) {
					ship->TurnRight();
					ship->ApplyThrust();
				}
				//flee to the left
				else if (targetAngle > behindAngle) {
					ship->TurnLeft();
					ship->ApplyThrust();
				}
			}
			else {
				//out of danger, so start attacking again
				ship->setBehavior( BEHAVIOR_ATTACK );
			}
			break;
*/
		case BEHAVIOR_ATTACK:
			//attempt to turn toward player
			targetAngle = Math::AngleToTarget(x,y,pgx,pgy);
			targetAngle = Math::wrapAngleDegs(90.0 + Math::toDegrees(targetAngle) );
			//need to turn left
			if (targetAngle < Math::wrapAngleDegs( ship->getFaceAngle() - 1.0 )) {
				ship->TurnLeft();
			}
			//need to turn right
			else if (targetAngle > Math::wrapAngleDegs( ship->getFaceAngle() + 1.0 )) {
				ship->TurnRight();
			}
			//we're pointed at player, fire!
			else {
				//get distance to player
				dist = Math::Distance(x,y,pgx,pgy);

				//is target out of range?
				if (dist > longRange) {
					//close in to firing range
					ship->ApplyThrust();
				}
				//is target long range? fire long range weapon only
				else if (dist > shortRange) {
					missileIsGreaterRange? enemyFireMissile(ship): enemyFireLaser(ship);
				}
				//is target close range? fire both
 				else {
					ship->ApplyBraking();
					enemyFireLaser(ship);
					enemyFireMissile(ship);
				}
			}

			break;
	}
}

int ModuleEncounter::getShipCount()
{
	//count alien ships
	int ships = 0;

	//look thru entities for alien ships
	for (int i=0; i < (int)combatObjects.size(); i++)
	{
		//only look at active objects
		if (combatObjects[i]->isAlive())
		{
			//found an alien ship
			if (combatObjects[i]->getObjectType() == OBJ_ALIENSHIP) {
				ships++;
			}
		}
	}

	return ships;
}

Rect ModuleEncounter::getBoundary()
{
	Rect boundary(0,0,0,0);
	boundary.right = scroller->getTilesAcross() * scroller->getTileWidth();
	boundary.bottom = scroller->getTilesDown() * scroller->getTileHeight();
	return boundary;
}


//used by sensor scan to find an alien ship
CombatObject *ModuleEncounter::GetFirstAlienShip()
{
	CombatObject *alien=NULL;
	for (int i=0; i < (int)combatObjects.size(); ++i)
	{
		if (combatObjects[i]->isAlive())
		{
			if (combatObjects[i]->getObjectType() == OBJ_ALIENSHIP)
			{
				alien = combatObjects[i];
				break;
			}
		}
	}
	return alien;
}

void ModuleEncounter::Combat_Update()
{
	//player ship destroyed?
	if (!g_game->gameState->player->getAlive())
	{
		if (deathState == 0) {
			deathState++;
			text->Write("YOUR SHIP HAS BEEN DESTROYED!!", RED);
			g_game->ShowMessageBoxWindow("", "YOUR SHIP HAS BEEN DESTROYED!!", 400,200, RED);
		}
		else {
			//show pause menu since player has died
			g_game->TogglePauseMenu();
		}

		//break out of update function
		return;
	}

	double x,y;

	//keep player inside boundary
	Rect bounds = getBoundary();
	if ( playerGlobal.x < bounds.left ) {
		playerGlobal.x = bounds.left;
		playerShip->allstop();
	}
	else if ( playerGlobal.x > bounds.right ) {
		playerGlobal.x = bounds.right;
		playerShip->allstop();
	}

	if ( playerGlobal.y < bounds.top ) {
		playerGlobal.y = bounds.top;
		playerShip->allstop();
	}
	else if ( playerGlobal.y > bounds.bottom ) {
		playerGlobal.y = bounds.bottom;
		playerShip->allstop();
	}


	//update all combat objects
	for (int i=0; i < (int)combatObjects.size(); i++)
	{
		//fast/untimed update
		combatObjects[i]->Update();
		x = combatObjects[i]->getX();
		y = combatObjects[i]->getY();

		//perform fast updates as needed
		switch(combatObjects[i]->getObjectType())
		{
			case OBJ_ALIENSHIP:
				shipcount++;
				DoAlienShipCombat(combatObjects[i]);
				break;

			case OBJ_ASTEROID_BIG:
			case OBJ_ASTEROID_MED:
				//warp asteroid around edges of combat arena
				if (x < bounds.left)
					combatObjects[i]->setX( bounds.right-10 );
				if (x > bounds.right )
					combatObjects[i]->setX( bounds.left+10 );
				if (y < bounds.top )
					combatObjects[i]->setY( bounds.bottom-10 );
				if (y > bounds.bottom )
					combatObjects[i]->setY( bounds.top+10 );
				break;

			case OBJ_PLAYERLASER:
			case OBJ_PLAYERMISSILE:
			case OBJ_ENEMYFIRE:
				//remove bullet if it reaches boundary
				if (!bounds.contains( x,y ))
					combatObjects[i]->setAlive(false);
				break;
		}

		//perform collision testing
		for (int other=0; other < (int)combatObjects.size(); other++)
		{
			if (other != i && combatObjects[other]->isAlive())
			{
				if ( combatObjects[i]->CheckCollision(combatObjects[other]) )
				{
					combatDoCollision(combatObjects[i], combatObjects[other]);
				}
			}
		}

	}

	//enemy ships destroyed?
	if (shipcount == 0) {
		string tac = g_game->gameState->getCurrentTac()->getLastName() + "-> ";
		string nav = g_game->gameState->getCurrentNav()->getLastName() + "-> ";
		Print(tac + "All enemy ships have been destroyed!", STEEL, 10000);
		Print(nav + "Captain, we can return to hyperspace when you''re ready.", GREEN, 10000);
	}
	else {
		//check for sensor scan/analysis
		if (scanStatus == 1)  //scan
		{
			//find first alien ship in use
			CombatObject *alien = GetFirstAlienShip();
			if (alien != NULL)
			{
				g_game->printout(text,sci + "Scanning alien ship...", STEEL, 10000);
				if (scanTimer.stopwatch(4000)) {
					g_game->printout(text,sci + "Scan complete, ready for analysis.", STEEL, 10000);
					scanStatus = 2;
				}
			}
			else {
				g_game->printout(text,sci + "There are no alien ships to scan.", YELLOW, 10000);
				scanStatus = 0;
			}
		}
		else if (scanStatus == 3) //analysis
		{
			scanStatus = 0;

			//find first alien ship in use
			CombatObject *alien = GetFirstAlienShip();
			if (alien != NULL)
			{
				string analysis = "The ship is ";
				int mass = script->getGlobalNumber("mass");
				if (mass <= 2) analysis += "tiny";
				else if (mass <= 4) analysis += "small";
				else if (mass <= 6) analysis += "medium";
				else if (mass <= 8) analysis += "large";
				else analysis += "huge";
				analysis += " in size, with a ";

				int engine = script->getGlobalNumber("engineclass");
				if (engine <= 2) analysis += "slow engine";
				else if (engine <= 4) analysis += "medium engine";
				else analysis += "fast engine";
				analysis += ". The hull is ";

				int armor = script->getGlobalNumber("armorclass");
				if (armor == 0) analysis += "not armored";
				else if (armor <= 2) analysis += "lightly armored";
				else if (armor <= 4) analysis += "moderately armored";
				else analysis += "heavily armored";

				int shield = script->getGlobalNumber("shieldclass");
				if (shield == 0)
					analysis += ", but this ship is not equipped with ";
				else {
					analysis += " and it is equipped with ";
					if (shield <= 2) analysis += "light";
					else if (shield <= 4) analysis += "medium";
					else analysis += "heavy";
				}
				analysis += " shields. ";

				int laserModifier = script->getGlobalNumber("laser_modifier");
				int missileModifier = script->getGlobalNumber("missile_modifier");
				if (laserModifier < missileModifier)
					analysis+="Defensive capabilities are especially effective against laser beams.";
				else if (missileModifier < laserModifier)
					analysis+="Defensive capabalities are especially effective against missiles.";


				analysis += " Offensive capabilities include ";

				int laser = script->getGlobalNumber("laserclass");
				if (laser == 0) analysis += "no lasers";
				else if (laser <= 2) analysis += "light lasers";
				else if (laser <= 4) analysis += "medium lasers";
				else analysis += "heavy lasers";
				analysis += ", ";

				int missile = script->getGlobalNumber("missileclass");
				if (missile > 0) analysis += " and ";
				if (missile == 0) analysis += "but no missiles";
				else if (missile <= 2) analysis += "low-yield missiles";
				else if (missile <= 4) analysis += "medium-yield missiles";
				else analysis += "high-yield missiles";
				analysis += ". ";

				int alienPow = engine + armor + shield + laser + missile;
				int playerPow = g_game->gameState->m_ship.getEngineClass()
					+ g_game->gameState->m_ship.getArmorClass()
					+ g_game->gameState->m_ship.getShieldClass()
					+ g_game->gameState->m_ship.getLaserClass()
					+ g_game->gameState->m_ship.getMissileLauncherClass();
				if (alienPow > playerPow*2)
					analysis += "They greatly outclass us.";
				else if (alienPow > playerPow)
					analysis += "They moderately outclass us.";
				else if (alienPow == playerPow)
					analysis += "We're comparably equipped.";
				else if (alienPow*2 < playerPow)
					analysis += "We greatly outclass them.";
				else if (alienPow < playerPow)
					analysis += "We moderately outclass them.";

				g_game->printout(text,sci + "Here is my analysis of the alien ship:", STEEL, 10000);
				g_game->printout(text, analysis, WHITE, 10000);

			}
			else {
				g_game->printout(text,sci + "Sorry, Captain, I don't understand the sensor results.", STEEL, 10000);
			}

		}

	}


	//remove dead combat objects
	for (int i=0; i < (int)combatObjects.size(); i++)
	{
		if (!combatObjects[i]->isAlive())
		{
			RemoveCombatObject(combatObjects[i]);
		}
	}

	//slowly recharge ship's shield
	Ship ship = g_game->gameState->getShip();
	int shield = ship.getShieldClass();
	if (shield > 0) {
		//increase shield by 0.001 per frame
		float strength = ship.getShieldCapacity() + (float)shield / 100.0f;
		if (strength > ship.getMaxShieldCapacity()) strength = ship.getMaxShieldCapacity();
		ship.setShieldCapacity( strength );
		g_game->gameState->setShip( ship );
	}

}



//Combat_Draw functions as a timed update and draw routine
void ModuleEncounter::Combat_Draw()
{
	std::ostringstream ostr;
//	int x,y;
	double tx,ty;
	double rx,ry;
	float angle;

	//draw box around player
	//rect(g_game->GetBackBuffer(), playerScreen.x, playerScreen.y, playerScreen.x + 64, playerScreen.y + 64, BLUE);
	//textprintf_ex(g_game->GetBackBuffer(), font, playerScreen.x, playerScreen.y, WHITE, -1, "%i,%i", (int)playerGlobal.x, (int)playerGlobal.y);

	//Loop through all combat objects
	for (int i=0; i < (int)combatObjects.size(); ++i)
	{
		if (combatObjects[i]->isAlive())
		{
			//update sprite movement, animation
			combatObjects[i]->TimedUpdate();

			//save absolute position
			tx = combatObjects[i]->getX();
			ty = combatObjects[i]->getY();

			//calculate position relative to player
			rx = tx - g_game->gameState->player->posCombat.x;
			ry = ty - g_game->gameState->player->posCombat.y;

			//is this sprite in range of the screen?
			if (rx > 0 - combatObjects[i]->getFrameWidth() && rx < SCREEN_WIDTH && ry > 0 - combatObjects[i]->getFrameHeight() && ry < effectiveScreenHeight())
			{
				//set relative location to simplify collision code
				combatObjects[i]->setPos(rx,ry);

				//perform special collision test with player ship
				combatTestPlayerCollision(combatObjects[i]);

				//special handling for each object based on type
				switch(combatObjects[i]->getObjectType())
				{
					//draw objects requiring rotation
					case OBJ_ALIENSHIP:
					case OBJ_ASTEROID_BIG:
					case OBJ_ASTEROID_MED:
					case OBJ_PLAYERLASER:
					case OBJ_PLAYERMISSILE:
					case OBJ_ENEMYFIRE:
						angle = combatObjects[i]->getFaceAngle();
						combatObjects[i]->drawframe_rotate(g_game->GetBackBuffer(), (int)angle);
						break;

					//draw objects that do not require rotation
					case OBJ_POWERUP_HEALTH:
					case OBJ_POWERUP_SHIELD:
					case OBJ_POWERUP_ARMOR:
					case OBJ_POWERUP_MINERAL_FROM_SHIP:
					case OBJ_POWERUP_MINERAL_FROM_ASTEROID:
						combatObjects[i]->drawframe(g_game->GetBackBuffer(), true);
						break;

					//special case explosion only animates once
					case OBJ_EXPLOSION:
						combatObjects[i]->drawframe(g_game->GetBackBuffer(), true);

						//delete explosion when it reaches last frame
						if (combatObjects[i]->getCurrFrame() == combatObjects[i]->getTotalFrames()-1)
							combatObjects[i]->setAlive(false);
						break;
				}

				//restore absolute position
				combatObjects[i]->setX(tx);
				combatObjects[i]->setY(ty);
			}

		}
	}

	//draw the player's shield
	if (g_game->gameState->getShieldStatus())
	{
		if (g_game->gameState->getShip().getShieldCapacity() > 0.0) {
			shield->animate();
			shield->drawframe(g_game->GetBackBuffer(), true);
		}
		else {
			g_game->gameState->setShieldStatus( false );
			Print(tac + "Sir! Shields are depleted!", RED, 6000);
		}
	}

}

//in "show control" mode the player ship is centered on the upper 1024x512 part of the screen
//in "hide control" mode the player ship is centered on the whole 1024x768 screen
//we need to adjust the y coordinate of all the objects relatively to that of the player ship
void ModuleEncounter::adjustVerticalCoords(int delta)
{
	//adjust the player ship & shield sprites
	playerShip->setY( playerShip->getY()+delta );
	shield->setY( shield->getY()+delta );

	//adjust everything else
	for (int i=0; i < (int)combatObjects.size(); ++i)
	{
		if (combatObjects[i]->isAlive())
			combatObjects[i]->setY( combatObjects[i]->getY()+delta );
	}

}

void ModuleEncounter::DrawMinimap()
{
	clear_to_color(minimap, BLACK);

	for (int i=0; i < (int)combatObjects.size(); i++)
	{
		int x = (int)(combatObjects[i]->getX() ) / 78;// 39;
		int y = (int)(combatObjects[i]->getY() ) / 76;// 38;

		switch (combatObjects[i]->getObjectType())
		{
			case OBJ_ALIENSHIP:
				rect(minimap, x-1, y-1, x+1, y+1, STEEL);
				break;
			case OBJ_ASTEROID_BIG:
				circle(minimap, x, y, 3, KHAKI);
				break;
			case OBJ_ASTEROID_MED:
				circle(minimap, x, y, 2, DKKHAKI);
				break;
			//case OBJ_PLAYERLASER:
			case OBJ_PLAYERMISSILE:
			case OBJ_ENEMYFIRE:
				putpixel(minimap, x, y, RED);
				break;
			case OBJ_POWERUP_HEALTH:
			case OBJ_POWERUP_SHIELD:
			case OBJ_POWERUP_ARMOR:
				triangle(minimap, x, y-2, x-2,y+2, x+2,y+2, GREEN);
				break;
			case OBJ_POWERUP_MINERAL_FROM_SHIP:
			case OBJ_POWERUP_MINERAL_FROM_ASTEROID:
				triangle(minimap, x, y-2, x-2,y+2, x+2,y+2, YELLOW);
				break;
		}
	}

	//show player on minimap
	int px = (int)((g_game->gameState->player->posCombat.x + SCREEN_WIDTH/2 ) / 78);// 39);
	int py = (int)((g_game->gameState->player->posCombat.y + effectiveScreenHeight()/2 ) / 76);// 38);
	circle(minimap, px, py, 2, GREEN);


	//draw minimap
	blit(minimap, g_game->GetBackBuffer(), 0, 0, asx, asy, asw, ash);
}


void ModuleEncounter::AddCombatObject(CombatObject *CObject)
{
	combatObjects.push_back(CObject);
}

void ModuleEncounter::RemoveCombatObject(CombatObject *CObject)
{
	if (CObject != NULL)
	{
		for (objectIt = combatObjects.begin(); objectIt != combatObjects.end(); ++objectIt)
		{
			if (*objectIt == CObject)
			{
				combatObjects.erase(objectIt);
				break;
			}
		}
	}
}

#pragma endregion

#pragma region FIRING
void ModuleEncounter::enemyFireLaser(CombatObject *ship)
{
	static Timer timer;
	int laserDamage = ship->getLaserDamage();

	//make sure this ship has a primary weapon
	if (laserDamage == 0) return;

	//reloaded yet?
	int time = timer.getTimer();
	int rate = ship->getLaserFiringRate();
	int counter = ship->getLaserFiringTimer();
	if ( counter == 0 || time > counter + rate )
	{
		//reset reload timer
		ship->setLaserFiringTimer( time );
	}
	else return;

	//create the laser sprite
	CombatObject *laser = new CombatObject();
	laser->setObjectType(OBJ_ENEMYFIRE);

	double x = ship->getX() + ship->getFrameWidth()/2 - 8;
	double y = ship->getY() + ship->getFrameHeight()/2 - 8;
	float velx = playerShip->getVelocityX();
	float vely = playerShip->getVelocityY();
	int angle = (int)ship->getFaceAngle();
	createLaser(laser, x, y, velx, vely, angle, laserDamage);
}

void ModuleEncounter::enemyFireMissile(CombatObject *ship)
{
	static Timer timer;
	int missileDamage = ship->getMissileDamage();

	//bail if ship has no missiles
	if ( missileDamage == 0) return;

	//reloaded yet?
	int time = timer.getTimer();
	int rate = ship->getMissileFiringRate();
	int counter = ship->getMissileFiringTimer();
	if ( counter == 0 || time > counter + rate )
	{
		//reset reload timer
		ship->setMissileFiringTimer( time );
	}
	else return;

	//create the missile sprite
	CombatObject *missile = new CombatObject();
	missile->setObjectType(OBJ_ENEMYFIRE);

	double x = ship->getX() + ship->getFrameWidth()/2 - 8;
	double y = ship->getY() + ship->getFrameHeight()/2 - 8;
	float velx = ship->getVelX();
	float vely = ship->getVelY();
	int angle = (int)ship->getFaceAngle();
	createMissile(missile, x, y, velx, vely, angle, missileDamage);
}


//fire primary weapon
void ModuleEncounter::fireLaser()
{
	static int fireLast = 0;

	//get player's laser props
	int laserClass = g_game->gameState->getShip().getLaserClass();
	int laserDamage = g_game->gameState->getShip().getLaserDamage();
	int fireRate = g_game->gameState->getShip().getLaserFiringRate();

	if (laserClass == 0 || laserDamage == 0) {
		Print(tac + "We do not have a laser",YELLOW,-1);
		return;
	}

	//are weapons armed?
	if (!g_game->gameState->getWeaponStatus() ) {
		Print(tac + "The weapons are not armed yet!",YELLOW,5000);
		return;
	}

	//slow down firing rate
	if (g_game->globalTimer.getTimer() > fireLast + fireRate) {
		fireLast = g_game->globalTimer.getTimer();
	}
	else return;

	//create the laser sprite
	CombatObject *laser = new CombatObject();
	laser->setObjectType(OBJ_PLAYERLASER);

	double x = g_game->gameState->player->posCombat.x + SCREEN_WIDTH/2 - 8;
	double y = g_game->gameState->player->posCombat.y + effectiveScreenHeight()/2 - 8;
	float velx = playerShip->getVelocityX();
	float vely = playerShip->getVelocityY();
	int angle = (int)playerShip->getSprite()->getFaceAngle();
	createLaser(laser, x, y, velx, vely, angle, laserDamage);
}

//fire secondary weapon
void ModuleEncounter::fireMissile()
{
	static int fireLast = 0;

	//get player's missile props
	int missileClass = g_game->gameState->getShip().getMissileLauncherClass();
	int missileDamage = g_game->gameState->getShip().getMissileLauncherDamage();
	int fireRate = g_game->gameState->getShip().getMissileLauncherFiringRate(); //used to be 1000

	if (missileClass == 0 || missileDamage == 0) {
		Print(tac + "We have no missile launcher",YELLOW,-1);
		return;
	}

	//are weapons armed?
	if (!g_game->gameState->getWeaponStatus() ) {
		Print(tac + "The weapons are not armed!",YELLOW,5000);
		return;
	}

	//slow down firing rate
	if (g_game->globalTimer.getTimer() > fireLast + fireRate) {
		fireLast = g_game->globalTimer.getTimer();
	}
	else return;

	//create the missile sprite
	CombatObject *missile = new CombatObject();
	missile->setObjectType(OBJ_PLAYERMISSILE);

	double x = (int)g_game->gameState->player->posCombat.x + SCREEN_WIDTH/2 - 8;
	double y = (int)g_game->gameState->player->posCombat.y + effectiveScreenHeight()/2 - 8;
	float velx = playerShip->getVelocityX();
	float vely = playerShip->getVelocityY();
	int angle = (int)playerShip->getSprite()->getFaceAngle();
	createMissile(missile, x, y, velx, vely, angle, missileDamage);
}

void ModuleEncounter::createLaser(CombatObject *laser, double x, double y, float velx, float vely, int angle, int laserDamage)
{
	double duration = g_game->getGlobalNumber("LASER_DURATION");
	double speed = g_game->getGlobalNumber("LASER_SPEED");
	
	laser->setImage(img_laserbeam);
	laser->setTotalFrames(1); //was 4--too fast for animation
	laser->setAnimColumns(1); //was 4
	laser->setFrameWidth(16);
	laser->setFrameHeight(16);
	laser->setFrameDelay(0); //no animation
	laser->setMass(0.1);
	laser->setAlpha(true);
	laser->setExpireDuration( duration ); // was 800 for alien, 1000 for player
	laser->setDamage( laserDamage );

	//set projectile's direction and velocity
	laser->setFaceAngle( angle );
	laser->setVelX( velx + Sprite::calcAngleMoveX( Math::wrapAngleDegs(angle-90) ) * speed ); //alien laser used to have * 20.0, player laser used to not have +velx
	laser->setVelY( vely + Sprite::calcAngleMoveY( Math::wrapAngleDegs(angle-90) ) * speed ); //alien laser used to have * 20.0, player laser used to not have +vely

	//set projectile's starting position
	laser->setPos(x,y);

	AddCombatObject(laser);

	//missile sound effect
	g_game->audioSystem->Play(snd_player_laser);
}

void ModuleEncounter::createMissile(CombatObject *missile, double x, double y, float velx, float vely, int angle, int missileDamage)
{
	double duration = g_game->getGlobalNumber("MISSILE_DURATION");
	double speed = g_game->getGlobalNumber("MISSILE_SPEED");

	missile->setImage(img_redbolt);
	missile->setTotalFrames(30);
	missile->setAnimColumns(10);
	missile->setFrameWidth(16);
	missile->setFrameHeight(16);
	missile->setFrameDelay(2);
	missile->setMass(0.2);
	missile->setAlpha(true);
	missile->setExpireDuration( duration );
	missile->setDamage( missileDamage );

	//set projectile's direction and velocity
	missile->setFaceAngle( angle );
	missile->setVelX( velx + Sprite::calcAngleMoveX( Math::wrapAngleDegs(angle-90) ) * speed ); //was *20.0 for alien missiles
	missile->setVelY( vely + Sprite::calcAngleMoveY( Math::wrapAngleDegs(angle-90) ) * speed ); //was *20.0 for alien missiles

	//set projectile's starting position
	missile->setPos(x,y);

	AddCombatObject(missile);

	//missile sound effect
	g_game->audioSystem->Play(snd_player_missile);
}
#pragma endregion


#pragma region EXPLOSIONS_POWERUPS

void ModuleEncounter::combatDoBigExplosion(CombatObject *victim)
{
	//play explosion sound
	g_game->audioSystem->Play(snd_explosion);

	//create explosion sprite
	CombatObject *exp = new CombatObject();
	exp->setImage(img_bigexplosion);
	exp->setAlpha(true);
	exp->setObjectType(OBJ_EXPLOSION);
	exp->setTotalFrames(30);
	exp->setAnimColumns(6);
	exp->setFrameWidth(128);
	exp->setFrameHeight(128);
	exp->setFrameDelay(1);
	exp->setExpireDuration(2000);

	int x,y,x1,y1,w1,h1,w2,h2,Xoff,Yoff;
	x1 = (int)victim->getX();
	w1 = (int)victim->getFrameWidth();
	w2 = exp->getFrameWidth();
	Xoff = (w1 - w2) / 2;

	y1 = (int)victim->getY();
	h1 = victim->getFrameHeight();
	h2 = exp->getFrameHeight();
	Yoff = (h1 - h2) / 2;

	x = x1 + Xoff;
	y = y1 + Yoff;
	exp->setPos(x,y);

	AddCombatObject(exp);
}

void ModuleEncounter::combatDoMedExplosion(CombatObject *victim)
{
	//play explosion sound
	g_game->audioSystem->Play(snd_explosion);

	//create explosion sprite
	CombatObject *exp = new CombatObject();
	exp->setImage(img_medexplosion);
	exp->setAlpha(true);
	exp->setObjectType(OBJ_EXPLOSION);
	exp->setTotalFrames(30);
	exp->setAnimColumns(6);
	exp->setFrameWidth(64);
	exp->setFrameHeight(64);
	exp->setFrameDelay(1);
	exp->setExpireDuration(2000);

	int x,y,x1,y1,w1,h1,w2,h2,Xoff,Yoff;
	x1 = (int)victim->getX();
	w1 = (int)victim->getFrameWidth();
	w2 = exp->getFrameWidth();
	Xoff = (w1 - w2) / 2;

	y1 = (int)victim->getY();
	h1 = victim->getFrameHeight();
	h2 = exp->getFrameHeight();
	Yoff = (h1 - h2) / 2;

	x = x1 + Xoff;
	y = y1 + Yoff;
	exp->setPos(x,y);

	AddCombatObject(exp);
}

void ModuleEncounter::combatDoSmlExplosion(CombatObject *victim,CombatObject *source)
{
	//play explosion sound
	g_game->audioSystem->Play(snd_laserhit);

	//create explosion sprite
	CombatObject *exp = new CombatObject();
	exp->setImage(img_smlexplosion);
	exp->setAlpha(true);
	exp->setObjectType(OBJ_EXPLOSION);
	exp->setTotalFrames(30);
	exp->setAnimColumns(6);
	exp->setFrameWidth(48);
	exp->setFrameHeight(48);
	exp->setFrameDelay(1);
	exp->setExpireDuration(3000);

	//unlike med/big, small exp is for projectile impacts, so it's a bit random
	int vcx = (int)(victim->getX() + victim->getFrameWidth()/2);
	int vcy = (int)(victim->getY() + victim->getFrameHeight()/2);
	int ecx = exp->getFrameWidth()/2;
	int ecy = exp->getFrameHeight()/2;
	int rx = Util::Random(8,16) - 8;
	int ry = Util::Random(8,16) - 8;
	exp->setPos(vcx - ecx + rx, vcy - ecy + ry);

	//set explosion's velocity
	exp->setVelX( source->getVelX() );
	exp->setVelY( source->getVelY() );

	AddCombatObject(exp);
}

//when large asteroid is destroyed, it breaks up into smaller ones
//the small ones release powerups!
void ModuleEncounter::combatDoBreakAsteroid(CombatObject *victim)
{
	int r = Util::Random(4,9);

	for (int n = 0; n < r; n++)
	{
		//play explosion sound
		g_game->audioSystem->Play(snd_laserhit);

		//create explosion sprite
		CombatObject *exp = new CombatObject();
		exp->setImage(img_smlasteroid);
		exp->setObjectType(21); //sub-asteroids
		exp->setAnimColumns(8);
		exp->setTotalFrames(64);
		exp->setFrameWidth(60);
		exp->setFrameHeight(60);
		exp->setFrameDelay( Util::Random(1,4) );
		exp->setCurrFrame( Util::Random(1,60) );
		exp->setHealth(10);
		exp->setMass(3.0);

		double x = victim->getX();
		double y = victim->getY();
		exp->setPos(x,y);

		exp->setVelX( Util::Random(0,4) - 2 );
		exp->setVelY( Util::Random(0,4) - 2 );

		exp->setRotation( Util::Random(0,8) - 4 );

		AddCombatObject(exp);
	}

}

void ModuleEncounter::combatDoPowerup(CombatObject *victim)
{
	double vcx,vcy, velx,vely;

	//create new powerup sprite
	CombatObject *pow = new CombatObject();

	//set type of powerup
	int r = Util::Random(1,7);
	switch( r )
	{
		case 1: //health
			pow->setImage(img_powerup_health);
			pow->setObjectType(OBJ_POWERUP_HEALTH);
			pow->setAlpha(true);
			pow->setTotalFrames(9);
			pow->setAnimColumns(9);
			pow->setFrameWidth(32);
			pow->setFrameHeight(32);
			break;
		case 2: //shield
			pow->setImage(img_powerup_shield);
			pow->setObjectType(OBJ_POWERUP_SHIELD);
			pow->setAlpha(true);
			pow->setTotalFrames(9);
			pow->setAnimColumns(9);
			pow->setFrameWidth(32);
			pow->setFrameHeight(32);
			break;
		case 3: //armor
			pow->setImage(img_powerup_armor);
			pow->setObjectType(OBJ_POWERUP_ARMOR);
			pow->setAlpha(true);
			pow->setTotalFrames(9);
			pow->setAnimColumns(9);
			pow->setFrameWidth(32);
			pow->setFrameHeight(32);
			break;
		case 4: //mineral
        case 5:
        case 6:
        case 7:
			pow->setImage(img_powerup_mineral);
			(victim->getObjectType() == OBJ_ALIENSHIP)?
				pow->setObjectType(OBJ_POWERUP_MINERAL_FROM_SHIP) :
				pow->setObjectType(OBJ_POWERUP_MINERAL_FROM_ASTEROID);
			pow->setAlpha(false);
			pow->setTotalFrames(7);
			pow->setAnimColumns(7);
			pow->setFrameWidth(30);
			pow->setFrameHeight(24);
			break;

	}

	//set shared properties
	pow->setExpireDuration(45000);
	pow->setFrameDelay(3);

	//set position
	vcx = victim->getX() + victim->getFrameWidth()/2;
	vcy = victim->getY() + victim->getFrameHeight()/2;
	pow->setPos(vcx - 32, vcy - 32);

	//set velocity
	velx = (double) (Util::Random(1,3) - 2);
	vely = (double) (Util::Random(1,3) - 2);
	pow->setVelX(velx);
	pow->setVelY(vely);

	//add the powerup
	AddCombatObject(pow);
}

#pragma endregion

void ModuleEncounter::sendGlobalsToScript()
{
	script->setGlobalNumber("number_of_actions", number_of_actions);
	script->setGlobalNumber("goto_question", goto_question);
	script->setGlobalNumber("ATTITUDE", g_game->gameState->getAlienAttitude());
	script->setGlobalString("POSTURE", g_game->gameState->playerPosture);
	script->setGlobalNumber("player_money", g_game->gameState->getCredits());
	script->setGlobalNumber("plot_stage", g_game->gameState->getPlotStage() );
	script->setGlobalNumber("active_quest", g_game->gameState->getActiveQuest() );
	script->setGlobalString("player_profession", g_game->gameState->getProfessionString());
	script->setGlobalNumber("ship_engine_class", g_game->gameState->getShip().getEngineClass() );
	script->setGlobalNumber("ship_shield_class", g_game->gameState->getShip().getShieldClass() );
	script->setGlobalNumber("ship_armor_class", g_game->gameState->getShip().getArmorClass() );
	script->setGlobalNumber("ship_laser_class", g_game->gameState->getShip().getLaserClass() );
	script->setGlobalNumber("ship_missile_class", g_game->gameState->getShip().getMissileLauncherClass() );
	script->setGlobalNumber("max_engine_class", g_game->gameState->getShip().getMaxEngineClass() );
	script->setGlobalNumber("max_shield_class", g_game->gameState->getShip().getMaxShieldClass() );
	script->setGlobalNumber("max_armor_class", g_game->gameState->getShip().getMaxArmorClass() );
	script->setGlobalNumber("max_laser_class", g_game->gameState->getShip().getMaxLaserClass() );
	script->setGlobalNumber("max_missile_class", g_game->gameState->getShip().getMaxMissileLauncherClass() );
	script->setGlobalNumber("comm_skill", g_game->gameState->getCurrentCom()->attributes.communication);

	//set artifact numbers, other ship items (endurium, etc.)
	for (int n=0; n<g_game->dataMgr->GetNumItems(); n++){

		Item *pItem = g_game->dataMgr->GetItem(n);
		if (!pItem->IsArtifact() && !pItem->IsMineral())
			continue;

		std::string luaName; Item itemInHold; int numInHold;

		//artifact are known as "artifactN" in the scripts; minerals are known as "player_mineralName"
		pItem->IsArtifact()? luaName = "artifact" + Util::ToString(pItem->id) :
                             luaName = "player_" + pItem->name;

		//get number of that item currently in hold
		g_game->gameState->m_items.Get_Item_By_ID(pItem->id, itemInHold, numInHold);

		//TRACE("Encounter: Sending variable `%s' with value %d to lua\n", luaName.c_str(), numInHold);
		script->setGlobalNumber(luaName, numInHold);
	}
}

void ModuleEncounter::readGlobalsFromScript()
{
	goto_question = script->getGlobalNumber("goto_question");
	number_of_actions = script->getGlobalNumber("number_of_actions");

	g_game->gameState->setAlienAttitude( script->getGlobalNumber("ATTITUDE") );
	g_game->gameState->playerPosture= script->getGlobalString("POSTURE");			//added.
	g_game->gameState->setCredits( script->getGlobalNumber("player_money") );
	//this is a controversial setting...
	g_game->gameState->setPlotStage( script->getGlobalNumber("plot_stage") );
	g_game->gameState->setActiveQuest( script->getGlobalNumber("active_quest") );

	//see if script has increased communication skill
	Officer *currentCom = g_game->gameState->getCurrentCom();
	int current_skill = currentCom->attributes.communication;
	int new_skill = script->getGlobalNumber("comm_skill");

	if (new_skill > current_skill)
		if (currentCom->SkillUp(SKILL_COMMUNICATION, new_skill-current_skill))
			Print(com + "I think i am getting better at this", PURPLE, 5000);

	//see if script has upgraded any ship systems
	Ship ship = g_game->gameState->getShip();


	int engine = script->getGlobalNumber("ship_engine_class");
	if (engine > ship.getEngineClass()){
		if(engine <= ship.getMaxEngineClass()) {
			Print("Engines upgraded to class " + Util::ToString(engine) + "!", YELLOW, 1000);
			ship.setEngineClass( engine );
		}
		else Print("Engines already at maximum level!", RED, 1000);
	}

	int shield = script->getGlobalNumber("ship_shield_class");
	if (shield > ship.getShieldClass()){
		if (shield <= ship.getMaxShieldClass()) {
			Print("Shields upgraded to class " + Util::ToString(shield) + "!", YELLOW, 1000);
			ship.setShieldClass( shield );
		}
		else Print("Shields already at maximum level!", RED, 1000);
	}

	int armor = script->getGlobalNumber("ship_armor_class");
	if (armor > ship.getArmorClass()){
		if (armor <= ship.getMaxArmorClass()) {
			Print("Armor upgraded to class " + Util::ToString(armor) + "!", YELLOW, 1000);
			ship.setArmorClass( armor );
		}
		else Print("Armor already at maximum level!", RED, 1000);
	}

	int laser = script->getGlobalNumber("ship_laser_class");
	if (laser > ship.getLaserClass()){
		//if (laser <= ship.getMaxLaserClass()) { // Enforced in scripts, need for special class 9 weapons Quest #56
			Print("Lasers upgraded to class " + Util::ToString(laser) + "!", YELLOW, 1000);
			ship.setLaserClass( laser );
		//}
		//else Print("Lasers already at maximum level!", RED, 1000);
	}
	if (laser < ship.getLaserClass()){
		//        if (laser <= ship.getMaxLaserClass()) {
            Print("Lasers downgraded to class " + Util::ToString(laser) + "!", YELLOW, 1000);
            ship.setLaserClass( laser ); 
	}
	int missile = script->getGlobalNumber("ship_missile_class");
	if (missile > ship.getMissileLauncherClass()){
		//if (missile <= ship.getMaxMissileLauncherClass()) {
			Print("Missile launcher upgraded to class " + Util::ToString(missile) + "!", YELLOW, 1000);
			ship.setMissileLauncherClass( missile );
		//}
	//	else Print("Missile launcher already at maximum level!", RED, 1000);
	}
	if (missile < ship.getMissileLauncherClass()){
		//if (missile <= ship.getMaxMissileLauncherClass()) {
			Print("Missile launcher downgraded to class " + Util::ToString(missile) + "!", YELLOW, 1000);
			ship.setMissileLauncherClass( missile );
		//}
	//	else Print("Missile launcher already at maximum level!", RED, 1000);
	}
	g_game->gameState->setShip( ship );



	//get artifact cargo updates, other ship items (endurium, etc.)
	for (int n=0; n<g_game->dataMgr->GetNumItems(); n++){
		std::string luaName; Item itemInHold;
		int numInHold, newcount;

		Item *pItem = g_game->dataMgr->GetItem(n);
		//item is neither an artifact nor a mineral; next!
		if (!pItem->IsArtifact() && !pItem->IsMineral())
			continue;

		//get number of that item currently in hold
		g_game->gameState->m_items.Get_Item_By_ID(pItem->id, itemInHold, numInHold);

		//artifact are known as "artifactN" in the scripts;  minerals are known as "player_mineralName"
		pItem->IsArtifact()? luaName = "artifact" + Util::ToString(pItem->id) :
                             luaName = "player_" + pItem->name;

		newcount = script->getGlobalNumber(luaName);
		//TRACE("Encounter: Getting variable `%s' with value %d from lua\n", luaName.c_str(), newcount);

		//nothing changed for this item; next!
		if (newcount == numInHold) continue;

		//artifact
		if (pItem->IsArtifact()){
			if (newcount > numInHold){
				Print("We received the " + pItem->name + " from the " + alienName + ".", PURPLE, 1000);		//artifacts to/from aliens jjh 
				g_game->gameState->m_items.SetItemCount(pItem->id, 1);        //get exactly one
			} else {
				Print("We gave the " + pItem->name + " to the " + alienName + ".", PURPLE, 1000);
				g_game->gameState->m_items.RemoveItems(pItem->id, numInHold); //give all
			}

			//broacast inventory change
			Event e(CARGO_EVENT_UPDATE);
			g_game->modeMgr->BroadcastEvent(&e);

			//nothing more to do for this artifact; next!
			continue;
		}
		
		//not an artifact
		ostringstream msg;
		bool received = (newcount > numInHold);
		int delta = abs(newcount-numInHold);
		int freeSpace = g_game->gameState->m_ship.getAvailableSpace();

		if (received){

			if ( freeSpace <= 0 ){
				Print("We don't have any space left in the cargo hold!", RED, 1000);
				return;
			}
			
			//do not pick up more than available cargo space
			if (delta > freeSpace) delta = freeSpace;	

		} else {

			if ( numInHold <= 0 ){
				msg << "We did not give anything to the " + alienName + ".";
				msg << " We had no " + pItem->name + " in the hold.";
				Print(msg.str(), RED, 1000);
				return;
			}
			
			//do not give more than available in the hold
			if (delta > numInHold) delta = numInHold;
		}

		msg << (received? "We received " : "We gave ");

		(delta >= 2)?
			msg << delta << " cubic meters of " :
			msg << "one cubic meter of ";

		msg << pItem->name << (received? " from the " : " to the ") << alienName << ".";
		Print(msg.str(), PURPLE, 1000);

		//update the inventory
		received?
			g_game->gameState->m_items.AddItems(pItem->id, delta) :
			g_game->gameState->m_items.RemoveItems(pItem->id, delta);

		//broadcast inventory change
		Event e(CARGO_EVENT_UPDATE);
		g_game->modeMgr->BroadcastEvent(&e);
	}
}


/*******************************************************
 *
 *    LUA functions
 *
 *******************************************************/

//Alien will close the communication channel.
//usage: L_Terminate()
int L_Terminate(lua_State* luaVM)
{
	Event e(ENCOUNTER_CLOSECOMM_EVENT);
	g_game->modeMgr->BroadcastEvent(&e);

	return 0;
}

//Alien will close the communication channel and attack.
//usage: L_Attack()
int L_Attack(lua_State* luaVM)
{
	Event e(ENCOUNTER_ALIENATTACK_EVENT);
	g_game->modeMgr->BroadcastEvent(&e);

	return 0;
}
