#pragma region HEADER
/*
	STARFLIGHT - THE LOST COLONY
	ModulePlanetSurface.cpp - Handles planetary surface
	Author: Justin Sargent
	Date: January, 2007

	This module handles only planetary excursions, not planet landing in the ship's gui, which
	is found in the planet orbit module. This module handles only the terrain vehicle.

	Referenced Scripts:
		PlanetSurfacePlayerShip.lua
		PlanetSurfacePlayerTV.lua
		stunprojectile.lua
		Functions.lua

		These add lifeforms and minerals to planet:
			PopAsteroid.lua
			PopRockyPlanet.lua
			PopOceanicPlanet.lua
			PopMoltenPlanet.lua
			PopFrozenPlanet.lua
            PopAcidicPlanet.lua

            mineral.lua
            artifact.lua
            ruin.lua
			basicLifeform.lua

	All other scripts in data/planetsurface come from quests and can be deleted

	New objects added to planet surface via: L_CreateNewPSObyItemID

*/


#include "env.h"
#include "ModulePlanetSurface.h"
#include "TileScroller.h"
#include "PlayerShipSprite.h"
#include "GameState.h"
#include "Game.h"
#include "ModeMgr.h"
#include "AudioSystem.h"
#include "DataMgr.h"
#include "Util.h"
#include "QuestMgr.h"
#include "PlanetSurfaceObject.h"
#include "PlanetSurfacePlayerVessel.h"
#include "ModuleCargoWindow.h"
#include "Button.h"
#include "Label.h"
#include "AdvancedTileScroller.h"
#include "PauseMenu.h"
#include "ModuleControlPanel.h"

using namespace std;

#define ARMOR_BAR_BMP                    0        /* BMP  */
#define CARGO_BAR_BMP                    1        /* BMP  */
#define CARGO_BAR_MO_BMP                 2        /* BMP  */
#define COMMAND_BIGBUTTON_BG_BMP         3        /* BMP  */
#define COMMAND_BIGBUTTON_BG_DISABLED_BMP 4        /* BMP  */
#define COMMAND_BIGBUTTON_BG_MO_BMP      5        /* BMP  */
#define COMMAND_BIGBUTTON_BG_SELECT_BMP  6        /* BMP  */
#define COMMAND_BUTTON_BG_BMP            7        /* BMP  */
#define COMMAND_BUTTON_BG_DISABLED_BMP   8        /* BMP  */
#define COMMAND_BUTTON_BG_MO_BMP         9        /* BMP  */
#define COMMAND_BUTTON_BG_SELECT_BMP     10       /* BMP  */
#define ELEMENT_BIGGAUGE_EMPTY_BMP       11       /* BMP  */
#define ELEMENT_BIGGAUGE_YELLOW_BMP      12       /* BMP  */
#define ELEMENT_GAUGE_GREEN_BMP          13       /* BMP  */
#define ELEMENT_GAUGE_ORANGE_BMP         14       /* BMP  */
#define ELEMENT_GAUGE_PURPLE_BMP         15       /* BMP  */
#define ELEMENT_GAUGE_RED_BMP            16       /* BMP  */
#define ELEMENT_SMALLGAUGE_GREEN_BMP     17       /* BMP  */
#define FUEL_BAR_BMP                     18       /* BMP  */
//#define GUI_AUX_BMP                      19       /* BMP  */
//#define GUI_CONTROLPANEL_BMP             20       /* BMP  */
#define GUI_GAUGES_BMP                   21       /* BMP  */
#define GUI_MESSAGEWINDOW_BMP            22       /* BMP  */
#define GUI_SOCKET_BMP                   23       /* BMP  */
#define HULL_BAR_BMP                     24       /* BMP  */
#define STATIC_TGA                       25       /* BMP  */
#define TILESET_ASH_TGA                  26       /* BMP  */
#define TILESET_DESERT_TGA               27       /* BMP  */
#define TILESET_DIRT_TGA                 28       /* BMP  */
#define TILESET_GAS_ACID_1_TGA           29       /* BMP  */
#define TILESET_GAS_ACID_2_TGA           30       /* BMP  */
#define TILESET_GAS_GRASS_TGA            31       /* BMP  */
#define TILESET_GAS_ROCK_1_TGA           32       /* BMP  */
#define TILESET_GAS_ROCK_2_TGA           33       /* BMP  */
#define TILESET_GLASS_TGA                34       /* BMP  */
#define TILESET_GRASS_DARK_TGA           35       /* BMP  */
#define TILESET_GRASS_DEAD_TGA           36       /* BMP  */
#define TILESET_GRASS_LIGHT_TGA          37       /* BMP  */
#define TILESET_ICE_TGA                  38       /* BMP  */
#define TILESET_LAVA_TGA                 39       /* BMP  */
#define TILESET_MAGMA_TGA                40       /* BMP  */
#define TILESET_MUD_TGA                  41       /* BMP  */
#define TILESET_ROCK_DARK_TGA            42       /* BMP  */
#define TILESET_ROCK_LIGHT_TGA           43       /* BMP  */
#define TILESET_SNOW_TGA                 44       /* BMP  */
#define TILESET_STARS_TGA                45       /* BMP  */
#define TILESET_WATER_DARK_TGA           46       /* BMP  */
#define TILESET_WATER_LIGHT_TGA          47       /* BMP  */
#define TILESET_WATER_MID_TGA            48       /* BMP  */


DATAFILE *psdata;


#define SCROLLEROFFSETX (SCREEN_WIDTH/2 - activeVessel->getFrameWidth()/2)
#define SCROLLEROFFSETY (SCREEN_HEIGHT/2 - 128 - activeVessel->getFrameHeight()/2)

#define BIGBTN1_CLICK 100
#define BIGBTN2_CLICK 101
// If you change the CARGO_CLICK make sure you change it in the Game.cpp also
#define CARGO_CLICK 102
#define BIGBTN1_HOVER 103
#define BIGBTN2_HOVER 104
#define CARGO_HOVER 105

#define TIMER_X 408
#define TIMER_Y 512

#define TIMERTEXT_X 408
#define TIMERTEXT_Y 512

#define TV_NONESELECTED_TEXT "Click on objects to interact with them"
#define SHIP_TEXT "Land your ship to explore the planet with your terrain vehicle"
#define TVOUTOFFUEL_TEXT "You can pick up your Terrain Vehicle by flying over it and pressing the Pick Up button"
#define OBJECT_NEEDS_SCANNED_TEXT "You can scan objects to learn how to interact with them"

#define SHOWPORTRAITLENGTH 200

#define TIMER_EXPIRED_EVENT 70196 /*0x0ddba11*/


ModulePlanetSurface::ModulePlanetSurface(void) :
	messages(NULL),
	selectedPSO(NULL),
	runPlanetLoadScripts(true),
	runPlanetPopulate(true),
	vibration(0),
	panCamera(false),
	timerOn(false),
	timerLength(0),
	label(NULL),
	activeButtons(0),
	cinematicShip(NULL),
	psObjectHolder(NULL),
	playerShip(NULL),
	playerTV(NULL),
	TVwasMoving(false),
	TVwasDamaged(false),
	activeVessel(NULL),
	panFocus(NULL),
	HullBar(NULL),
	Hull(NULL),
	ArmorBar(NULL),
	Armor(NULL),
	FuelBar(NULL),
	Fuel(NULL),
	TimerText(NULL),
	Timer_BarFill(NULL),
	CargoMouseOver(NULL),
	Cargo_BarFill(NULL),
	Cargo(NULL),
	Static(NULL),
	btnBigSelect(NULL),
	btnBigMouseOver(NULL),
	btnBigDisabled(NULL),
	btnBigNormal(NULL),
	btnSelect(NULL),
	btnMouseOver(NULL),
	btnDisabled(NULL),
	btnNormal(NULL),
	minimap(NULL),
	surface(NULL),
	img_control(NULL),
	img_aux(NULL),
	img_gauges(NULL),
	img_socket(NULL),
	img_messages(NULL),
	cargoBtn(NULL),
	LuaVM(NULL),
	scroller(NULL)
{
	g_game->PlanetSurfaceHolder = this;
}

ModulePlanetSurface::~ModulePlanetSurface(void){}


#pragma endregion

#pragma region INPUT
void ModulePlanetSurface::OnKeyPress(int keyCode)
{
	switch (keyCode)
	{
		case KEY_UP:			activeVessel->ForwardThrust(true);		break;
		case KEY_DOWN:			activeVessel->ReverseThrust(true);		break;
		case KEY_RIGHT:		activeVessel->TurnRight(true);			break;
		case KEY_LEFT:		activeVessel->TurnLeft(true);			break;
	}

}


void ModulePlanetSurface::OnKeyPressed(int keyCode){}

void ModulePlanetSurface::OnKeyReleased(int keyCode)
{
	switch (keyCode) {
		//reset ship anim frame when key released
		case KEY_LEFT:	activeVessel->TurnLeft(false); break;
		case KEY_RIGHT:	activeVessel->TurnRight(false); break;
		case KEY_UP:		activeVessel->ForwardThrust(false); break;
		case KEY_DOWN:		activeVessel->ReverseThrust(false); break;
		case KEY_ESC:
			//std::string escape = g_game->getGlobalString("ESCAPEMODULE");
			//g_game->modeMgr->LoadModule(escape);
			//return;
			break;
		//case KEY_L:
		//	g_game->modeMgr->LoadModule(MODULE_ORBIT);
		//	return;
		//	break;
	}

}

void ModulePlanetSurface::OnMouseMove(int x, int y)
{
	messages->OnMouseMove(x,y);

	for (int i=0; i < 2; ++i) BigBtns[i]->OnMouseMove(x,y);

	for (int i=0; i < activeButtons; ++i) Btns[i]->OnMouseMove(x,y);

	cargoBtn->OnMouseMove(x,y);

}

void ModulePlanetSurface::OnMouseClick(int button, int x, int y)
{
	messages->OnMouseClick(button,x,y);
}

void ModulePlanetSurface::OnMousePressed(int button, int x, int y)
{
	messages->OnMousePressed(button,x,y);
}

void ModulePlanetSurface::OnMouseReleased(int button, int x, int y)
{
	messages->OnMouseReleased(button,x,y);

	for (int i=0; i < 2; ++i) { if (BigBtns[i]->OnMouseReleased(button,x,y)) return; } //Stop passing on if click landed

	for (int i=0; i < activeButtons; ++i) { if (Btns[i]->OnMouseReleased(button,x,y)) return; }//Stop passing on if click landed

	if (cargoBtn->OnMouseReleased(button,x,y)) 
	{
		Event e(EVENT_CAPTAIN_CARGO);
		g_game->modeMgr->BroadcastEvent(&e);
		return;
	}

	if (y <= 540) //Make sure that the click was in the play area, otherwise ignore it
	{
		if (vessel_mode == 1)
		{
			x += (int)scroller->getScrollX();
			y += (int)scroller->getScrollY();
			for (int i=0; i < (int)surfaceObjects.size(); ++i)
			{
				if (surfaceObjects[i]->OnMouseReleased(button,x,y)) { return; } //Stop passing on if click landed
			}
		}
	}
}

void ModulePlanetSurface::OnMouseWheelUp(int x, int y)
{
	messages->OnMouseWheelUp(x,y);
}

void ModulePlanetSurface::OnMouseWheelDown(int x, int y)
{
	messages->OnMouseWheelDown(x,y);
}

#pragma endregion

#pragma region EVENTS
void ModulePlanetSurface::OnEvent(Event *event)
{

	if (selectedPSO != NULL)
		selectedPSO->OnEvent(event->getEventType());

	switch (event->getEventType())
	{
		case 0xDEADBEEF + 2: //save game
			g_game->gameState->AutoSave();
			break;
		case 0xDEADBEEF + 3: //load game
			g_game->gameState->AutoLoad();
			return;
			break;
		case 0xDEADBEEF + 4: //quit game
            {
				g_game->setVibration(0);
				string escape = g_game->getGlobalString("ESCAPEMODULE");
				g_game->modeMgr->LoadModule(escape);
				return;
            }
			break;

		case CARGO_EVENT_UPDATE:
		{
			updateCargoFillPercent();
			break;
		}

		case BIGBTN1_CLICK:
		{
			//Landing
			if (vessel_mode == 0)
			{
				//in some rare circumstances panCamera is not properly reset to false in Draw()
				//we need to force it here otherwise scrolling won't happen
				panCamera = false;

				if (!g_game->gameState->getShip().getHasTV()){
					g_game->ShowMessageBoxWindow("", "You can't land--no Terrain Vehicle! Acquire one at the Starport.");
					return;
				}

				//do a 4 point valid tile check
				if (!IsValidTile((int)playerShip->getX(), (int)playerShip->getY()) ||
					!IsValidTile((int)(playerShip->getX() + playerShip->getFrameWidth()), (int)playerShip->getY()) ||
					!IsValidTile((int)(playerShip->getX() + playerShip->getFrameWidth()), (int)(playerShip->getY()+ playerShip->getFrameHeight())) ||
					!IsValidTile((int)playerShip->getX(), (int)(playerShip->getY()+ playerShip->getFrameHeight())))
				{
					g_game->ShowMessageBoxWindow("", "You can't land here!", 400, 200);
					return;
				}

				//check that the player has enough fuel
				if(g_game->gameState->getShip().getFuel() <= 0.00f) 
                {
					int number_of_endurium = g_game->gameState->m_ship.getEnduriumOnBoard();
					if(number_of_endurium <= 0)
                    {
						g_game->ShowMessageBoxWindow("", "You can't land--no fuel!");
						return;
					}					
					else g_game->gameState->getShip().injectEndurium();
				}
				g_game->gameState->m_ship.ConsumeFuel(10);

				vessel_mode = 1;
				playerTV->setFaceAngle(playerShip->getFaceAngle());
				playerTV->setPosOffset( playerShip->getXOffset(), playerShip->getYOffset() );
				playerTV->setSpeed(8); //This gives the TV a little boost when it comes out of the ship
				activeButtons = 0;

				BigBtns[0]->SetButtonText("Dock");
				BigBtns[1]->SetButtonText("Scan");

				label->SetText(TV_NONESELECTED_TEXT);
				label->Refresh();

				//Clear any leftover movement residue
				playerTV->ResetNav();
				playerTV->setCounter3(100);
				activeVessel = playerTV;

				g_game->gameState->m_ship.setHasTV(false);

				if (g_game->audioSystem->SampleExists("launchtv"))
					g_game->audioSystem->Play("launchtv");
			}

			//Docking
			else if (vessel_mode == 1)
			{
				if (CalcDistance(playerTV, playerShip) < 80)
				{
					vessel_mode = 0;
					activeVessel = playerShip;
					activeButtons = 0;

					//Clear the selected PSO when docking
					if (selectedPSO != NULL)
					{
						selectedPSO->setSelected(false);
						selectedPSO = NULL;
					}

					playerShip->setSpeed(0); //This stops the ship from moving right after docking the TV
					playerShip->ResetNav();
					playerTV->setCounter3(100); //refuel the TV

					BigBtns[0]->SetButtonText("Land");
					BigBtns[1]->SetButtonText("Launch");

					label->SetText(SHIP_TEXT);
					label->Refresh();

					if (g_game->PlanetSurfaceHolder->timerOn)
					{
						g_game->PlanetSurfaceHolder->timerOn = false;
						g_game->PlanetSurfaceHolder->timerCount = 0;
						g_game->PlanetSurfaceHolder->timerLength = 0;

						//stop scan/pickuplifeform/mining sound effects
						g_game->audioSystem->Stop("scanning");
						g_game->audioSystem->Stop("pickuplifeform");
						g_game->audioSystem->Stop("mining");
					}

					g_game->gameState->m_ship.setHasTV(true);

					//stop the TV moving sound effects
					g_game->audioSystem->Stop("TVmove");
					g_game->audioSystem->Stop("damagedTV");
					TVwasMoving=false;

					if (g_game->audioSystem->SampleExists("dockingtv"))
						g_game->audioSystem->Play("dockingtv");
				}
				else
				{
					g_game->ShowMessageBoxWindow("", "You are not close enough to the ship yet to dock",400,200);
				}
			}

			//Picking Up TV
			else if (vessel_mode == 2)
			{
				if (CalcDistance(playerTV, playerShip) < 100)
				{
					vessel_mode = 0;
					activeVessel = playerShip;
					activeButtons = 0;

					//Clear the selected PSO when docking
					if (selectedPSO != NULL)
					{
						selectedPSO->setSelected(false);
						selectedPSO = NULL;
					}

					playerShip->setSpeed(0); //This stops the ship from moving right after docking the TV
					playerShip->ResetNav();
					playerTV->setCounter3(100); //Fill up the TV

					BigBtns[0]->SetButtonText("Land");
					BigBtns[1]->SetButtonText("Launch");

					label->SetText(SHIP_TEXT);
					label->Refresh();

					g_game->gameState->m_ship.setHasTV(true);

					if (g_game->audioSystem->SampleExists("dockingtv"))
						g_game->audioSystem->Play("dockingtv");

				}
				else
				{
					g_game->ShowMessageBoxWindow("", "You are not close enough to pick up the Terrain Vehicle",400,200);
				}
			}
			break;
		}

	case BIGBTN2_CLICK:
		{
		if (vessel_mode == 0){
			if(player_stranded == false)
			{
				if (!exitCinematicRunning)
				{
					//Leaving
					exitCinematicRunning = true;
					
                    //correction for ship getting stuck in corner of map when lifting off--issue 172
                    //see fix at exitCinematicRunning code
                    double x = playerShip->getX();
                    double y = playerShip->getY();
                    //if (x < 200) x = 200;
                    //else if (x > 31500) x = 31500;
                    //if (y < 200) y = 200;
                    //else if (y > 31500) y = 31500;
                    cinematicShip->setX(x);
					cinematicShip->setY(y);
					cinematicShip->setFaceAngle(playerShip->getFaceAngle());
					cinematicShip->setScale(playerShip->getScale());
					cinematicShip->setSpeed(4);

					PostMessage("Returning to Orbit", GREEN, 2, 6);
				}

			}
		}
		else if (vessel_mode == 1){
			//Scanning
			if (selectedPSO != NULL)
			{
				selectedPSO->setScanned(true);
				selectedPSO->Scan();
			}
			else
			{
				g_game->ShowMessageBoxWindow("", "You need to select something to scan first! You can select objects on the planet surface by clicking on them.");
			}
		}
		else if (vessel_mode == 2)
		{
			//Picking Up TV
			if (CalcDistance(playerTV, playerShip) < 100)
			{
				vessel_mode = 0;
				activeVessel = playerShip;
				activeButtons = 0;

				//Clear the selected PSO when docking
				if (selectedPSO != NULL)
				{
					selectedPSO->setSelected(false);
					selectedPSO = NULL;
				}

				playerShip->setSpeed(0); //This stops the ship from moving right after docking the TV
				playerShip->ResetNav();
				playerTV->setCounter3(100); //Fill up the TV

				BigBtns[0]->SetButtonText("Land");
				BigBtns[1]->SetButtonText("Launch");

				label->SetText(SHIP_TEXT);
				label->Refresh();

				g_game->gameState->m_ship.setHasTV(true);

				if (g_game->audioSystem->SampleExists("dockingtv"))
					g_game->audioSystem->Play("dockingtv");
			}
			else
			{
				g_game->ShowMessageBoxWindow("", "You are not close enough to pick up the Terrain Vehicle");
			}
		}
		break;
		}

	}
	//g_game->gameState->setShip(ship);
}
#pragma endregion


#pragma region INIT_CLOSE
void ModulePlanetSurface::Close()
{
	TRACE("PlanetSurface Destroy\n");

	try {

        destroy_bitmap(img_aux);
        destroy_bitmap(img_control);


		//unload the data file (thus freeing all resources at once)
		unload_datafile(psdata);
		psdata = NULL;

		PlanetSurfaceObject::EmptyGraphics();

		if (messages != NULL)
		{
			delete messages;
			messages = NULL;
		}

		if (BigBtns[0] != NULL)
		{
			delete BigBtns[0];
			BigBtns[0] = NULL;
		}
		if (BigBtns[1] != NULL)
		{
			delete BigBtns[1];
			BigBtns[1] = NULL;
		}
		if (cargoBtn != NULL)
		{
			delete cargoBtn;
			cargoBtn = NULL;
		}

		for (portraitsIt = portraits.begin(); portraitsIt != portraits.end(); ++portraitsIt)
		{
			destroy_bitmap(portraitsIt->second);
			portraitsIt->second = NULL;
		}
		portraits.clear();

		if (LuaVM != NULL)
		{
			lua_close(LuaVM);
		}

		if (playerTV != NULL)
		{
			delete playerTV;
			playerTV = NULL;
		}

		if (playerShip != NULL)
		{
			delete playerShip;
			playerShip = NULL;
		}

		if (cinematicShip != NULL)
		{
			delete cinematicShip;
			cinematicShip = NULL;
		}

		if (scroller != NULL)
		{
			delete scroller;
			scroller = NULL;
		}

		for (objectIt = surfaceObjects.begin(); objectIt != surfaceObjects.end(); ++objectIt)
		{
			delete *objectIt;
			*objectIt = NULL;
		}
		surfaceObjects.clear();

		for (int i=0; i < 9; ++i)
		{
			delete Btns[i];
			Btns[i] = NULL;
		}

		if (label != NULL)
		{
			delete label;
			label = NULL;
		}

		//force the looping sound effects to stop
		if (g_game->audioSystem->SampleExists("TVmove"))
			g_game->audioSystem->Stop("TVmove");
		if (g_game->audioSystem->SampleExists("damagedTV"))
			g_game->audioSystem->Stop("damagedTV");
		if (g_game->audioSystem->SampleExists("scanning"))
			g_game->audioSystem->Stop("scanning");
		if (g_game->audioSystem->SampleExists("pickuplifeform"))
			g_game->audioSystem->Stop("pickuplifeform");
		if (g_game->audioSystem->SampleExists("mining"))
			g_game->audioSystem->Stop("mining");
	}
	catch(std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in PlanetSurface::Close\n");
	}
}


//Init is a good place to load resources
bool ModulePlanetSurface::Init()
{
	g_game->SetTimePaused(false);	//game-time normal in this module.

	TRACE("  PlanetSurface Initialize\n");


	//enable the Pause Menu
	g_game->pauseMenu->setEnabled(true);

	//Set Misc Variables
	srand(time(NULL));
	vessel_mode = 0;
	activeButtons = 0;
	selectedPSO = NULL;
	panFocus = NULL;
	PlanetSurfaceObject::minX = 0;
	PlanetSurfaceObject::minY = 0;
	PlanetSurfaceObject::maxX = 64 * (500 - 4);
	PlanetSurfaceObject::maxY = 64 * (500 - 5);
	runPlanetLoadScripts = true;
	runPlanetPopulate = true;
	introCinematicRunning = true;
	exitCinematicRunning = false;
	player_stranded = false;
    badGravity = 0;
    deathState = 0;


    //get planet info
	Star *star = g_game->dataMgr->GetStarByID(g_game->gameState->player->currentStar);
	planet = star->GetPlanetByID(g_game->gameState->player->currentPlanet);

    //severely damage ship if this planet has very heavy gravity
    if (planet->gravity == PG_VERYHEAVY || planet->gravity == PG_CRUSHING)
    {
        //after a short delay the "you were crushed" message is displayed
        badGravity = 90;
    }


	//load the datafile
	psdata = load_datafile("data/planetsurface/planetsurface.dat");
	if (!psdata) {
		g_game->message("PlanetSurface: Error loading datafile");
		return false;
	}



	//player's starting position
	g_game->gameState->player->posPlanet.x = Util::Random(10 * 64, 490 * 64);
	g_game->gameState->player->posPlanet.y = Util::Random(10 * 64, 490 * 64);



	//load the sound effects
	if (!g_game->audioSystem->SampleExists("TVmove")) {
		if (!g_game->audioSystem->Load("data/planetsurface/TVmove.wav","TVmove",0.3)) {
			TRACE("PlanetSurface: Error loading data/planetsurface/TVmove.wav\n");
			//g_game->message("PlanetSurface: Error loading audio file scanning.wav");
			//return false;
		}
	}
	if (!g_game->audioSystem->SampleExists("damagedTV")) {
		if (!g_game->audioSystem->Load("data/planetsurface/damagedTV.wav","damagedTV",0.3)) {
			TRACE("PlanetSurface: Error loading data/planetsurface/damagedTV.wav\n");
			//g_game->message("PlanetSurface: Error loading audio file scanning.wav");
			//return false;
		}
	}
	if (!g_game->audioSystem->SampleExists("scanning")) {
		if (!g_game->audioSystem->Load("data/planetsurface/scanning.wav","scanning")) {
			TRACE("PlanetSurface: Error loading data/planetsurface/scanning.wav\n");
			//g_game->message("PlanetSurface: Error loading audio file scanning.wav");
			//return false;
		}
	}
	if (!g_game->audioSystem->SampleExists("pickuplifeform")) {
		if (!g_game->audioSystem->Load("data/planetsurface/pickuplifeform.wav","pickuplifeform")) {
			TRACE("PlanetSurface: Error loading data/planetsurface/pickuplifeform.wav\n");
			//g_game->message("PlanetSurface: Error loading audio file pickuplifeform.wav");
			//return false;
		}
	}
	if (!g_game->audioSystem->SampleExists("mining")) {
		if (!g_game->audioSystem->Load("data/planetsurface/mining.wav","mining")) {
			TRACE("PlanetSurface: Error loading data/planetsurface/mining.wav\n");
			//g_game->message("PlanetSurface: Error loading audio file mining.wav");
			//return false;
		}
	}
	if (!g_game->audioSystem->SampleExists("stunner")) {
		if (!g_game->audioSystem->Load("data/planetsurface/stunner.wav","stunner")) {
			TRACE("PlanetSurface: Error loading data/planetsurface/stunner.wav\n");
			//g_game->message("PlanetSurface: Error loading audio file stunner.wav");
			//return false;
		}
	}
	if (!g_game->audioSystem->SampleExists("launchtv")) {
		if (!g_game->audioSystem->Load("data/planetsurface/launchtv.wav","launchtv")) {
			TRACE("PlanetSurface: Error loading data/planetsurface/launchtv.wav\n");
			//g_game->message("PlanetSurface: Error loading audio file launchtv.wav");
			//return false;
		}
	}
	if (!g_game->audioSystem->SampleExists("dockingtv")) {
		if (!g_game->audioSystem->Load("data/planetsurface/dockingtv.wav","dockingtv")) {
			TRACE("PlanetSurface: Error loading data/planetsurface/dockingtv.wav\n");
			//g_game->message("PlanetSurface: Error loading audio file dockingtv.wav");
			//return false;
		}
	}
	if (!g_game->audioSystem->SampleExists("lifeformattack")) {
		if (!g_game->audioSystem->Load("data/planetsurface/lifeformattack.wav","lifeformattack")) {
			TRACE("PlanetSurface: Error loading data/planetsurface/lifeformattack.wav\n");
			//g_game->message("PlanetSurface: Error loading audio file lifeformattack.wav");
			//return false;
		}
	}
	if (!g_game->audioSystem->SampleExists("lifeformkilled")) {
		if (!g_game->audioSystem->Load("data/planetsurface/lifeformkilled.wav","lifeformkilled")) {
			TRACE("PlanetSurface: Error loading data/planetsurface/lifeformkilled.wav\n");
			//g_game->message("PlanetSurface: Error loading audio file lifeformkilled.wav");
			//return false;
		}
	}


	//clear screen
	rectfill(g_game->GetBackBuffer(), 0, 0, SCREEN_W-1, SCREEN_H-1, BLACK);

    //load the message gui
    img_messages = (BITMAP*)psdata[GUI_MESSAGEWINDOW_BMP].dat;
    if (!img_messages) {
		g_game->message("Planet: Error loading messagewindow");
		return false;
	}

	//load the socket gui
	img_socket = (BITMAP*)psdata[GUI_SOCKET_BMP].dat;
	if (!img_socket) {
		g_game->message("Planet: Error loading gui_socket");
		return false;
	}

	//load the gauges gui
	img_gauges = (BITMAP*)psdata[GUI_GAUGES_BMP].dat;
	if (!img_gauges) {
		g_game->message("Planet: Error loading gui_gauges");
		return false;
	}

	//load the aux gui
	img_aux = (BITMAP*)load_bitmap("data/spacetravel/GUI_AUX.BMP",NULL);
	if (!img_aux) {
		g_game->message("Planet: Error loading gui_aux");
		return false;
	}

	//load the control gui
	img_control = (BITMAP*)load_bitmap("data/controlpanel/GUI_CONTROLPANEL.BMP",NULL);
	if (!img_control) {
		g_game->message("Planet: Error loading gui_controlpanel");
		return false;
	}

	//load the static
	Static = (BITMAP*)psdata[STATIC_TGA].dat;
	if (!Static) {
		g_game->message("Planet: Error loading static.tga");
		return false;
	}

	//load the fuel graphic
	Fuel = (BITMAP*)psdata[FUEL_BAR_BMP].dat;
	if (!Fuel) {
		g_game->message("Planet: Error loading fuel_bar");
		return false;
	}

	//load the fuel graphic
	FuelBar = (BITMAP*)psdata[ELEMENT_GAUGE_ORANGE_BMP].dat;
	if (!FuelBar) {
		g_game->message("Planet: Error loading element_gauge_orange");
		return false;
	}

	//load the armor graphic
	Armor = (BITMAP*)psdata[ARMOR_BAR_BMP].dat;
	if (!Armor) {
		g_game->message("Planet: Error loading armor_bar");
		return false;
	}

	//load the armor graphic
	ArmorBar = (BITMAP*)psdata[ELEMENT_GAUGE_RED_BMP].dat;
	if (!ArmorBar) {
		g_game->message("Planet: Error loading element_gauge_red");
		return false;
	}

	//load the hull graphic
	Hull = (BITMAP*)psdata[HULL_BAR_BMP].dat;
	if (!Hull) {
		g_game->message("Planet: Error loading hull_bar");
		return false;
	}

	//load the hull graphic
	HullBar = (BITMAP*)psdata[ELEMENT_GAUGE_GREEN_BMP].dat;
	if (!HullBar) {
		g_game->message("Planet: Error loading element_gauge_green");
		return false;
	}

	//load timer bar fill
	Timer_BarFill = (BITMAP*)psdata[ELEMENT_BIGGAUGE_YELLOW_BMP].dat;
	if (!Timer_BarFill) {
		g_game->message("Planet: Error loading element_biggauge_yellow");
		return false;
	}

	//load timer bar empty
	Timer_BarEmpty = (BITMAP*)psdata[ELEMENT_BIGGAUGE_EMPTY_BMP].dat;
	if (!Timer_BarEmpty) {
		g_game->message("Planet: Error loading element_biggauge_empty");
		return false;
	}

	//load lifeforms HP bar
	HP_Bar = (BITMAP*)psdata[ELEMENT_SMALLGAUGE_GREEN_BMP].dat;
	if (!HP_Bar) {
		g_game->message("Planet: Error loading element_smallgauge_green");
		return false;
	}

	//create the label for the timer
	TimerText = new Label("",TIMERTEXT_X, TIMERTEXT_Y, 247, 19, BLACK, g_game->font18);

	//Load Cargo Images
	Cargo = (BITMAP*)psdata[CARGO_BAR_BMP].dat;
	if (!Cargo) {
		g_game->message("Planet: Error loading cargo_bar");
		return false;
	}

	CargoMouseOver = (BITMAP*)psdata[CARGO_BAR_MO_BMP].dat;
	if (!CargoMouseOver) {
		g_game->message("Planet: Error loading cargo_bar_mo");
		return false;
	}

	Cargo_BarFill = (BITMAP*)psdata[ELEMENT_GAUGE_PURPLE_BMP].dat;
	if (!Cargo_BarFill) {
		g_game->message("Planet: Error loading element_gauge_purple");
		return false;
	}

	//create the ScrollBox for message window
	static int gmx = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_X");
	static int gmy = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_Y");
	static int gmw = (int)g_game->getGlobalNumber("GUI_MESSAGE_WIDTH");
	static int gmh = (int)g_game->getGlobalNumber("GUI_MESSAGE_HEIGHT");
	messages = new ScrollBox::ScrollBox(g_game->font18, ScrollBox::SB_TEXT,
		gmx + 38, gmy + 18, gmw - 53, gmh - 32, 999);
	messages->DrawScrollBar(true);
	
    //point global scrollbox to local one in this module for access by external object
    g_game->g_scrollbox = messages;


	static int bx = (int)g_game->getGlobalNumber("GUI_CONTROLPANEL_POS_X");
	static int by = (int)g_game->getGlobalNumber("GUI_CONTROLPANEL_POS_Y");
	CMDBUTTONS_UL_X = bx + 18;
	CMDBUTTONS_UL_Y = by + 242;
	OFFICERICON_UL_X = bx + 45;
	OFFICERICON_UL_Y = by + 157;

	//Initialize cargo button
	CARGOFILL_X = OFFICERICON_UL_X + 47;
	CARGOFILL_Y = OFFICERICON_UL_Y - 38;

	cargoBtn = new Button(Cargo, CargoMouseOver, NULL, OFFICERICON_UL_X - 15, OFFICERICON_UL_Y - 43, CARGO_HOVER, CARGO_CLICK);

	updateCargoFillPercent();

	//Initialize label
	label = new Label(SHIP_TEXT, CMDBUTTONS_UL_X + 10, CMDBUTTONS_UL_Y + 10, 175, 200, BLACK, g_game->font24);
	label->Refresh();

	//Load command btn images
	btnNormal = (BITMAP*)psdata[COMMAND_BUTTON_BG_BMP].dat;
	if (!btnNormal) {
		g_game->message("Planet: Error loading command_button_bg");
		return false;
	}

	btnDisabled = (BITMAP*)psdata[COMMAND_BUTTON_BG_DISABLED_BMP].dat;
	if (!btnDisabled) {
		g_game->message("Planet: Error loading command_button_bg_disabled");
		return false;
	}

	btnMouseOver = (BITMAP*)psdata[COMMAND_BUTTON_BG_MO_BMP].dat;
	if (!btnMouseOver) {
		g_game->message("Planet: Error loading command_button_bg_mo");
		return false;
	}

	btnSelect = (BITMAP*)psdata[COMMAND_BUTTON_BG_SELECT_BMP].dat;
	if (!btnSelect) {
		g_game->message("Planet: Error loading command_button_bg_select");
		return false;
	}

	//Create command btns
	int cbx = CMDBUTTONS_UL_X; int cby = CMDBUTTONS_UL_Y;
	Btns[0] = new Button(btnNormal, btnMouseOver, btnDisabled, cbx, cby, 9, 0, g_game->font18, "", BLACK);
	cbx += btnNormal->w;
	Btns[1] = new Button(btnNormal, btnMouseOver, btnDisabled, cbx, cby, 10, 1, g_game->font18, "", BLACK);
	cbx += btnNormal->w;
	Btns[2] = new Button(btnNormal, btnMouseOver, btnDisabled, cbx, cby, 11, 2, g_game->font18, "", BLACK);

	cby += btnNormal->h;
	cbx = CMDBUTTONS_UL_X;
	Btns[3] = new Button(btnNormal, btnMouseOver, btnDisabled, cbx, cby, 12, 3, g_game->font18, "", BLACK);
	cbx += btnNormal->w;
	Btns[4] = new Button(btnNormal, btnMouseOver, btnDisabled, cbx, cby, 13, 4, g_game->font18, "", BLACK);
	cbx += btnNormal->w;
	Btns[5] = new Button(btnNormal, btnMouseOver, btnDisabled, cbx, cby, 14, 5, g_game->font18, "", BLACK);

	cby += btnNormal->h;
	cbx = CMDBUTTONS_UL_X;
	Btns[6] = new Button(btnNormal, btnMouseOver, btnDisabled, cbx, cby, 15, 6, g_game->font18, "", BLACK);
	cbx += btnNormal->w;
	Btns[7] = new Button(btnNormal, btnMouseOver, btnDisabled, cbx, cby, 16, 7, g_game->font18, "", BLACK);
	cbx += btnNormal->w;
	Btns[8] = new Button(btnNormal, btnMouseOver, btnDisabled, cbx, cby, 17, 8, g_game->font18, "", BLACK);

	//Load big command btn images
	btnBigNormal = (BITMAP*)psdata[COMMAND_BIGBUTTON_BG_BMP].dat;
	if (!btnBigNormal) {
		g_game->message("Planet: Error loading command_bigbutton_bg");
		return false;
	}

	btnBigDisabled = (BITMAP*)psdata[COMMAND_BIGBUTTON_BG_DISABLED_BMP].dat;
	if (!btnBigDisabled) {
		g_game->message("Planet: Error loading command_bigbutton_bg_disabled");
		return false;
	}

	btnBigMouseOver = (BITMAP*)psdata[COMMAND_BIGBUTTON_BG_MO_BMP].dat;
	if (!btnBigMouseOver) {
		g_game->message("Planet: Error loading command_bigbutton_bg_mo");
		return false;
	}

	btnBigSelect = (BITMAP*)psdata[COMMAND_BIGBUTTON_BG_SELECT_BMP].dat;
	if (!btnBigSelect) {
		g_game->message("Planet: Error loading command_bigbutton_bg_select");
		return false;
	}

	BigBtns[0] = new Button(btnBigNormal, btnBigMouseOver, btnBigDisabled, OFFICERICON_UL_X, OFFICERICON_UL_Y, BIGBTN1_HOVER, BIGBTN1_CLICK, g_game->font18, "Land", BLACK);
	BigBtns[1] = new Button(btnBigNormal, btnBigMouseOver, btnBigDisabled, OFFICERICON_UL_X + btnBigNormal->w, OFFICERICON_UL_Y, BIGBTN2_HOVER, BIGBTN2_CLICK, g_game->font18, "Launch", BLACK);

	//Load all the Lua Scripts and Register all the Lua->C++ functions
	SetupLua();

	//generate tile map
	if (!fabTilemap()) {
		return false;
	}

	//create the ship object  
	playerShip = new PlanetSurfacePlayerVessel(LuaVM, "PlayerShip");
	playerShip->Initialize();
	activeVessel = playerShip;
	playerShip->setHealth(g_game->gameState->m_ship.getHullIntegrity());
	playerShip->setFaceAngle(Util::Random(0, 360));
//	playerShip->setFaceAngle(225);  //jjh

	//Setup cinematicShip
	cinematicShip = new PlanetSurfaceObject(LuaVM, "PlayerShip");
	cinematicShip->Initialize();
	cinematicShip->setX( playerShip->getX() );
	cinematicShip->setY( playerShip->getY() );
	cinematicShip->setFaceAngle(playerShip->getFaceAngle());
	//Adjust for fly in position
	cinematicShip->setX( cinematicShip->getX() - (cos(cinematicShip->getFaceAngle() * 0.0174532925) * 900) );
	cinematicShip->setY( cinematicShip->getY() - (sin(cinematicShip->getFaceAngle() * 0.0174532925) * 900) );
	cinematicShip->setScale(5);


	//create the TV object
	playerTV = new PlanetSurfacePlayerVessel(LuaVM, "PlayerTV");
	playerTV->Initialize();

	asw = (int)g_game->getGlobalNumber("AUX_SCREEN_WIDTH");
	ash = (int)g_game->getGlobalNumber("AUX_SCREEN_HEIGHT");
	asx = (int)g_game->getGlobalNumber("AUX_SCREEN_X");
	asy = (int)g_game->getGlobalNumber("AUX_SCREEN_Y");

	minimap = create_bitmap(asw, ash);




	//scan database for artifacts and ruins that belong on this planet
	for (int n=0; n<g_game->dataMgr->GetNumItems(); n++)
	{
		Item *item = g_game->dataMgr->GetItem(n);

		//is this item an artifact?
		if (item->itemType == IT_ARTIFACT)
		{
			//artifact located on this planet?
			if (item->planetid == g_game->gameState->player->currentPlanet )
			{
				//convert longitude +/- value to tilemap coords
				//Note: these calculations are based on the following dimensions for the map; 
				//if these change, artifact positions will be messed up
                //154W,154E  156N,156S
				//Also, y = lat, x = long, so invert values 
                //154W 154E  156N 156S

				int itemy = CENTERX + (int) ( (float)(item->x+3) * ( (float)MAPW / ( 154.0 * 2.0 ) ) );
				int itemx = CENTERY + (int) ( (float)(item->y-1) * ( (float)MAPH / ( 156.0 * 2.0 ) ) );

				CreatePSObyItemID( "artifact", item->id, itemx, itemy );
			}
		}
        else if (item->itemType == IT_RUIN)
        {
			//is ruin located on this planet?
			if (item->planetid == g_game->gameState->player->currentPlanet )
			{
				//convert longitude +/- value to tilemap coords

				int itemy = CENTERX + (int) ( (float)(item->x+3) * ( (float)MAPW / ( 154.0 * 2.0 ) ) );
				int itemx = CENTERY + (int) ( (float)(item->y-1) * ( (float)MAPH / ( 156.0 * 2.0 ) ) );

				CreatePSObyItemID( "ruin", item->id, itemx, itemy );
			}

        }
	}


	//notify quest manager of planet landing event
	g_game->questMgr->raiseEvent(16, g_game->gameState->player->currentPlanet);


	return true;
}
#pragma endregion

void ModulePlanetSurface::CreatePSObyItemID(std::string scriptName, int itemid, int itemx, int itemy)
{
	int x, y;
	PlanetSurfaceObject *pso = new PlanetSurfaceObject(LuaVM, scriptName);
	
	Item *item = NULL;
	if (itemid == 0) return;
	item = g_game->dataMgr->GetItemByID(itemid);
	if (!item) return;

	pso->setID(item->id);
	pso->setItemType(item->itemType);
	pso->setName(item->name);
	pso->setValue(item->value);
	pso->setSize(item->size);
	pso->setSpeed(item->speed);
	pso->setDangerLvl(item->danger);
	pso->setDamage(item->damage);
	pso->setItemAge(item->itemAge);
	pso->setAsShipRepairMetal(item->shipRepairMetal);
	pso->setAsBlackMarketItem(item->blackMarketItem);
    pso->description = item->description;

	if (item->itemType == IT_ARTIFACT || item->itemType == IT_RUIN){
	//graphics for artifact in data/tradedepot; for ruins in data/planetsurface
		std::string filepath = "data/";
		filepath += (item->itemType==IT_ARTIFACT)? "tradedepot/":"planetsurface/";
		filepath += item->portrait;

		int res = pso->load(filepath.c_str());
		ASSERT(res);
	}

	//default is random location
	if (itemx == -1 || itemy == -1)
	{
		x = Util::Random(0, MAPW);
		y = Util::Random(0, MAPH);

		//make sure tile is "ground" and can be landed on
		while ( !IsValidTile(x, y) )
		{
			x = Util::Random(0, MAPW);
			y = Util::Random(0, MAPH);
		}
	}
	else {
		x = itemx;
		y = itemy;
	}

	pso->setPos(x,y);

	AddPlanetSurfaceObject(pso);

	return;
}
 

void ModulePlanetSurface::AddPlanetSurfaceObject(PlanetSurfaceObject *PSO)
{
	surfaceObjects.push_back(PSO);
	PSO->Initialize();
}


void ModulePlanetSurface::RemovePlanetSurfaceObject(PlanetSurfaceObject *PSO)
{
	if (PSO != NULL)
	{
		for (int i=0; i < (int)surfaceObjects.size(); ++i)
		{
			if (surfaceObjects[i] == PSO)
			{
				surfaceObjects.erase(surfaceObjects.begin() + i);
				break;
			}
		}
	}
}

#pragma region TILEMAP_CREATION
bool ModulePlanetSurface::fabTilemap()
{
	//get current star data
	int starid = -1;
	Star *star = g_game->dataMgr->GetStarByID(g_game->gameState->player->currentStar);
	if (star) {
		starid = star->id;
	}
	if (starid==-1) {
		g_game->fatalerror("ModulePlanetSurface::fabTilemap: starid is invalid");
	}

	//get current planet data
	int planetid = -1;
	if (g_game->gameState->player->currentPlanet > -1)
	{
		planet = star->GetPlanetByID(g_game->gameState->player->currentPlanet);
		if (planet) {
			planetid = planet->id;
		}
	}
	if (planetid==-1) {
		g_game->fatalerror("ModulePlanetSurface::fabTilemap: planetid is invalid");
	}

	//the planet surface is hard coded to 500x500 tiles
	//but the TexturedSphere software renderer works best at 256x256.
	//so, over in PlanetOrbit, both textures are generated

	//use starid and planetid for random seed
	int randomness = starid * 1000 + planetid;

	ostringstream os;
	os << "data/planetorbit/planet_" << randomness << "_500.bmp";
    std::string planetTextureFilename = os.str();

	//fill tilemap based on planet surface image
	surface = load_bitmap(planetTextureFilename.c_str(), NULL);
	if (!surface) {
		g_game->message("PlanetSurface: Error loading planet texture");
		return false;
	}

	if (surface->w != 500 && surface->h != 500) {
		g_game->message("PlanetSurface: Planet texture is invalid");
		return false;
	}

	//create tile scroller
	//these parameters CANNOT CHANGE despite being passed
	scroller = new AdvancedTileScroller(499, 499, 64, 64); 

	star = g_game->dataMgr->GetStarByID(g_game->gameState->player->currentStar);

	Planet *planet = star->GetPlanetByID(g_game->gameState->player->currentPlanet);

	//export planet info to lua scripts
	lua_pushstring(LuaVM, Planet::PlanetSizeToString(planet->size).c_str());
	lua_setglobal(LuaVM, "PLANETSIZE");
	lua_pushstring(LuaVM, Planet::PlanetTemperatureToString(planet->temperature).c_str());
	lua_setglobal(LuaVM, "TEMPERATURE");
	lua_pushstring(LuaVM, Planet::PlanetGravityToString(planet->gravity).c_str());
	lua_setglobal(LuaVM, "GRAVITY");
	lua_pushstring(LuaVM, Planet::PlanetAtmosphereToString(planet->atmosphere).c_str());
	lua_setglobal(LuaVM, "ATMOSPHERE");

	switch(planet->type) {
		case PT_OCEANIC:	fabOceanic();	break;
		case PT_FROZEN:		fabFrozen();	break;
		case PT_MOLTEN:		fabMolten();	break;
		case PT_ASTEROID:	fabAsteroid();	break;
		case PT_ROCKY:		fabRocky();		break;
		case PT_ACIDIC:		fabAcidic();	break;
		case PT_GASGIANT:
			g_game->message("PlanetSurface: Error, cannot land on a gas giant planet.");
			g_game->modeMgr->LoadModule(MODULE_ORBIT);
			break;
		default:
			g_game->message("PlanetSurface: Invalid planet type");
			g_game->modeMgr->LoadModule(MODULE_ORBIT);
			return false;
	}

	return true;
}

bool ModulePlanetSurface::fabAsteroid()
{
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ASH_TGA].dat, 16);//0
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ROCK_LIGHT_TGA].dat, 16);//1
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ICE_TGA].dat, 16);//2
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ROCK_DARK_TGA].dat, 16, false);//3
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_STARS_TGA].dat, 16, false);//4

	if (!scroller->CreateScrollBuffer(SCREEN_WIDTH, 640))
	{
		g_game->message("PlanetSurface: Error creating scroll buffer");
		return false;
	}

	int color, r, g, b, tile;
	for (int y=0; y < 500; y++) {
		for (int x=0; x < 500; x++) {

			//test colors found on planet texture to determine which planet tiles to draw

			color = getpixel(surface, x, y);
			r = getr(color); g = getg(color); b = getb(color);

			tile = 0;
			//r = g = b, asteroid is dark gray shades
			if(r < 15)			{ tile = 4; }
			else if (r < 30)	{ tile = 3; }
			else if (r < 45)	{ tile = 1; }
			else if (r < 60)	{ tile = 2; }
			else if (r < 75)	{ tile = 0; }
			else if (r < 90)	{ tile = 0; }
			else				{ tile = 1; }

			scroller->setPointData(x, y, tile);
		}
	}
	scroller->GenerateTiles();

	luaL_dofile(LuaVM, "data/planetsurface/PopAsteriod.lua");

	return true;
}


bool ModulePlanetSurface::fabRocky()
{
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ROCK_DARK_TGA].dat, 16, false);//0
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ROCK_LIGHT_TGA].dat, 16);//1
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_DIRT_TGA].dat, 16);//2
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_DESERT_TGA].dat, 16);//3

	if (!scroller->CreateScrollBuffer(SCREEN_WIDTH, 640))
	{
		g_game->message("PlanetSurface: Error creating scroll buffer");
		return false;
	}


	int color, r, g, b, tile;
	for (int y=0; y < 500; y++) {
		for (int x=0; x < 500; x++) {

			//test colors found on planet texture to determine which planet tiles to draw

			color = getpixel(surface, x, y);
			r = getr(color);
			g = getg(color);
			b = getb(color);

			tile = 0;

			//whitish colors
			if (b > r && b > g && g > r) {
				if (b > 190)		{ tile = 1; }
				else if (b > 170)	{ tile = 2; }
				else if (b > 150)	{ tile = 2; }
				else if (b > 130)	{ tile = 3; }
				else if (b > 120)	{ tile = 3; }
				else				{ tile = 3; }
			}
			//reddish colors
			else if (r > g) {
				if (r > 160)		{ tile = 0; }
				else if (r > 140)	{ tile = 0; }
				else if (r > 120)	{ tile = 0; }
				else if (r > 110)	{ tile = 0; }
				else if (r > 100)	{ tile = 0; }
				else				{ tile = 0; }
			}

			scroller->setPointData(x, y, tile);
		}
	}
	scroller->GenerateTiles();

	luaL_dofile(LuaVM, "data/planetsurface/PopRockyPlanet.lua");

	return true;
}


bool ModulePlanetSurface::fabFrozen()
{
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_WATER_DARK_TGA].dat, 16, false);//0
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ICE_TGA].dat, 16);//1
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ROCK_LIGHT_TGA].dat, 16);//2
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_SNOW_TGA].dat, 16);//3

	if (!scroller->CreateScrollBuffer(SCREEN_WIDTH, 640))
	{
		g_game->message("PlanetSurface: Error creating scroll buffer");
		return false;
	}

	int color, r, g, b, tile;
	for (int y=0; y < 500; y++) {
		for (int x=0; x < 500; x++) {

			//test colors found on planet texture to determine which planet tiles to draw

			color = getpixel(surface, x, y);
			r = getr(color); g = getg(color); b = getb(color);

			tile = 17;

			//frozen ocean slightly bluish
			if (b > r && b > g) {
				 tile = 0;
	/*			if (b < 120) tile = 0;
				else if (b < 130) tile = 16;
				else if (b < 140) tile = 15;
				else if (b < 150) tile = 14;
				else tile = 13;*/
			}
			//normal land tiles, r = g = b (shades of gray)
			else {
				if (r > 249)		{ tile = 2; }
				else if (r > 230)	{ tile = 2; }
				else if (r > 200)	{ tile = 2; }
				else if (r > 180)	{ tile = 3; }
				else if (r > 160)	{ tile = 1; }
				else if (r > 140)	{ tile = 1; }
				else				{ tile = 1; }
			}

			scroller->setPointData(x, y, tile);
		}
	}
	scroller->GenerateTiles();

	luaL_dofile(LuaVM, "data/planetsurface/PopFrozenPlanet.lua");

	return true;
}

bool ModulePlanetSurface::fabOceanic()
{
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_WATER_DARK_TGA].dat, 16, false);//0
	if(planet->temperature == PTMP_TEMPERATE){
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_MUD_TGA].dat, 16);//1
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_GRASS_LIGHT_TGA].dat, 16);//2
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_GRASS_DARK_TGA].dat, 16);//3
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_WATER_MID_TGA].dat, 16, false);//4
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ROCK_DARK_TGA].dat, 16, false);//5
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_SNOW_TGA].dat, 16, false);//6}
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ROCK_LIGHT_TGA].dat, 16, false);//7
	}
	else if(planet->temperature == PTMP_SEARING){
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_DESERT_TGA].dat, 16);//1
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_GRASS_DEAD_TGA].dat, 16);//2
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_GRASS_LIGHT_TGA].dat, 16);//3
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_WATER_MID_TGA].dat, 16, false);//4
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_DIRT_TGA].dat, 16);//5
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ROCK_LIGHT_TGA].dat, 16, false);//6}
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ROCK_DARK_TGA].dat, 16, false);//7
	}
	else{ //if(planet->temperature == PTMP_TROPICAL){
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_DESERT_TGA].dat, 16);//1
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_GRASS_LIGHT_TGA].dat, 16);//2
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_GRASS_DARK_TGA].dat, 16);//3
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_WATER_MID_TGA].dat, 16, false);//4
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_DIRT_TGA].dat, 16);//5
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ROCK_LIGHT_TGA].dat, 16, false);//6}
		scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ROCK_DARK_TGA].dat, 16, false);//7
	}


	if (!scroller->CreateScrollBuffer(SCREEN_WIDTH, 640))
	{
		g_game->message("PlanetSurface: Error creating scroll buffer");
		return false;
	}

	int color, r, g, b, tile;
	for (int y=0; y < 500; y++) {
		for (int x=0; x < 500; x++) {

			color = getpixel(surface, x, y);
			r = getr(color); g = getg(color); b = getb(color);

			tile = 0;
			if(r > 150 && g > 150 && b > 150){
				if (r > 250 && g > 250 && b > 250)		{ tile = 6; }
				else if(r > 200 && g > 200 && b > 200)	{ tile = 7; }
				else if(r > 150 && g > 150 && b > 150)	{ tile = 5; }
				else									{ tile = 3; }
			}
			//WATER TILES
			//red should be 0 in water pixels
			else if (r == 0) {
				if (b < 110)		{ tile = 0; }
				else if (b < 140)	{ tile = 0; }
				else if (b < 160)	{ tile = 0; }
				else if (b < 200)	{ tile = 0; }
				else if (b < 230)	{ tile = 4; }
				else				{ tile = 4;	}
			}
			else {
				//LAND TILES
				if (g < 140)			{ tile = 1; }
				else if (g < 150)		{ tile = 2; }
				else if (g < 160)		{ tile = 2; }
				else if (g < 170)		{ tile = 3; }
				else if (g < 180)		{ tile = 3; }
				else					{ tile = 3; }
			}

			scroller->setPointData(x, y, tile);
		}
	}
	scroller->GenerateTiles();

	luaL_dofile(LuaVM, "data/planetsurface/PopOceanicPlanet.lua");

	return true;
}

bool ModulePlanetSurface::fabMolten()
{
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_LAVA_TGA].dat, 16, false);//0
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_MAGMA_TGA].dat, 16, false);//1
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ASH_TGA].dat, 16);//2
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_ROCK_LIGHT_TGA].dat, 16);//3

	if (!scroller->CreateScrollBuffer(SCREEN_WIDTH, 640))
	{
		g_game->message("PlanetSurface: Error creating scroll buffer");
		return false;
	}

	int color, r, g, b, tile;
	for (int y=0; y < 500; y++) {
		for (int x=0; x < 500; x++) {

			//test colors found on planet texture to determine which planet tiles to draw

			color = getpixel(surface, x, y);
			r = getr(color);
			g = getg(color);
			b = getb(color);

			tile = 29;

			//lava ocean
			if (r > g && r > b && g == b){
				if (r > 249)		{ tile = 0; }
				else if (r > 210)	{ tile = 0; }
				else if (r > 180)	{ tile = 0; }
				else if (r > 160)	{ tile = 0; }
				else if (r > 140)	{ tile = 1; }
				else				{ tile = 1; }
			}
			//burnt ground
			else {
				if (g > 190)		{ tile = 3; }
				else if (g > 150)	{ tile = 3; }
				else if (g > 120)	{ tile = 3; }
				else if (g > 80)	{ tile = 2; }
				else if (g > 50)	{ tile = 2; }
				else				{ tile = 2; }
			}

			scroller->setPointData(x, y, tile);
		}
	}
	scroller->GenerateTiles();

	luaL_dofile(LuaVM, "data/planetsurface/PopMoltenPlanet.lua");

	return true;
}


bool ModulePlanetSurface::fabAcidic()
{
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_GAS_GRASS_TGA].dat, 16, true);//0
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_GAS_ACID_2_TGA].dat, 16, false);//1
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_GAS_ROCK_1_TGA].dat, 16);//2
	scroller->LoadTileSet( (BITMAP*)psdata[TILESET_GAS_ROCK_2_TGA].dat, 16, false);//3

	if (!scroller->CreateScrollBuffer(SCREEN_WIDTH, 640))
	{
		g_game->message("PlanetSurface: Error creating scroll buffer");
		return false;
	}

	int color, r, g, b, tile;
	for (int y=0; y < 500; y++) {
		for (int x=0; x < 500; x++) {
			//test colors found on planet texture to determine which planet tiles to draw
			color = getpixel(surface, x, y);
			r = getr(color);
			g = getg(color);
			b = getb(color);

			tile = 0;

			//acid ocean
			if (g > 100 ){
				tile = 1;
			}
			//toxic ground
			else {
				if (b > 120)			{ tile = 3; }
				else if (b > 100)	{ tile = 2; }
				else				{ tile = 0; }
			}
			scroller->setPointData(x, y, tile);
		}
	}
	scroller->GenerateTiles();

	luaL_dofile(LuaVM, "data/planetsurface/PopAcidicPlanet.lua");

	return true;
}
#pragma endregion


void ModulePlanetSurface::Update()
{
	char s[80];
	char sLong[20];
	int centerx = ((scroller->getTilesAcross()-16) * scroller->getTileWidth()) / 2; //-16 accomodates right edge adj
	int x = (centerx - (int)scroller->getScrollX()) / 100;
	if (x < 0) sprintf(sLong, "%iE", -x);
	else if (x == 0) sprintf(sLong, "%i", x);
	else if (x > 0) sprintf(sLong, "%iW", x);

	char sLat[20];
	int centery = ((scroller->getTilesDown()-10) * scroller->getTileHeight()) / 2; //-10 accomodates bottom edge adj
	
    int y = (centery - (int)scroller->getScrollY()) / 100 + 4; //for some reason it's off by 4?
	
    if (y < 0) sprintf(sLat, "%iS", -y);
	else if (y == 0) sprintf(sLat, "%i", y);
	else if (y > 0) sprintf(sLat, "%iN", y);

	//print position on top gui
	rectfill(img_gauges, 640, 10, 772, 38, makecol(50,50,50));
	sprintf(s, "%s,%s", sLat, sLong);
	//g_game->setFontSize(24);
	g_game->Print24(img_gauges, 645, 12, s, LTGREEN);


    // WHY is this being done here in PlanetSurface::Update? this is causing a validation bug
    // I suspect it's a holdover from a previous version of the quest system that eluded updates.

	//perform quest validation check
	//g_game->questMgr->getActiveQuest();
	//int reqCode = g_game->questMgr->questReqCode;
	//int reqType = g_game->questMgr->questReqType;
    //int reqAmt = g_game->questMgr->questReqAmt;
	//g_game->questMgr->VerifyRequirements( reqCode, reqType, reqAmt );


    //check for crushing gravity with a time delay so ship appears to land first
    if (badGravity > 0)
    {
        if (--badGravity <= 0)
        {
            badGravity = 0;

            //damage the ship's hull, random 5-25% dmg
            int damage = Util::Random(5,25);
            g_game->gameState->m_ship.augHullIntegrity( (float) -damage );

            if (g_game->gameState->m_ship.getHullIntegrity() <= 0.0f) 
            {
                //ship destroyed, game over
                g_game->gameState->player->setAlive(false);
            }
            else {
                //ship damaged
                g_game->ShowMessageBoxWindow("", "The heavy gravity of this planet has damaged your ship!", 400, 200, YELLOW);
				//key events won't be processed while the message window is shown
				//so, we force release of all keys here otherwise confusing things will happen
				activeVessel->TurnLeft(false);
				activeVessel->TurnRight(false);
				activeVessel->ForwardThrust(false);
				activeVessel->ReverseThrust(false);

                //damage random ship system or crew (33%)
	    	    g_game->gameState->m_ship.damageRandomSystemOrCrew();
            }

        }
    }


	//player ship destroyed?
	if (!g_game->gameState->player->getAlive())
    {
		if (deathState == 0) {
			deathState++;
			g_game->printout(g_game->g_scrollbox,"The heavy gravity of this planet has CRUSHED your ship!", RED);
            g_game->ShowMessageBoxWindow("", "The heavy gravity of this planet has CRUSHED your ship!",400,200,RED);
		}
		else {
			//show pause menu since player has died
			g_game->TogglePauseMenu();
		}
		//break out of update function
		return;
	}


    //update message window
	messages->ScrollToBottom();

}

void ModulePlanetSurface::Draw()
{
	clear_to_color(g_game->GetBackBuffer(), BLACK);

	if (vibration > 0)
		vibration -= 10;
	if (vibration < 0)
		vibration = 0;
	g_game->setVibration(vibration);

	for (int i=0; i < (int)surfaceObjects.size(); ++i)
	{
		surfaceObjects[i]->Update();
	}

	if (vessel_mode > 0)
		playerTV->Update();

	playerShip->Update();

	//update scrolling and draw tiles on the scroll buffer
	if (panCamera && panFocus != NULL)
	{
		int scrX = (int)scroller->getScrollX();
		int scrY = (int)scroller->getScrollY();

		int desiredX = (int)panFocus->getX() - (SCREEN_WIDTH/2 - panFocus->getFrameWidth()/2);
		int desiredY = (int)panFocus->getY() - (SCREEN_HEIGHT/2 - 128 - panFocus->getFrameHeight()/2);

		double angle = atan2((double)desiredY - scrY, (double)desiredX - scrX) * 180/3.1415926535;
		double distance = sqrt( (double)((desiredX - scrX) * (desiredX - scrX)) + ((desiredY - scrY) * (desiredY - scrY)) );
		double Increment = distance/10;
		if (Increment < 5) Increment = distance;

		scrX += (int)(cos(angle * 0.0174532925) * Increment);
		scrY += (int)(sin(angle * 0.0174532925) * Increment);

		//this misses some cases, so we have to force panCamera=false on BIGBTN1_CLICK event
		if (scrX == desiredX && scrY == desiredY) { panCamera = false; panFocus = NULL; }

		scrX = (int)Util::ClampValue<float>(scrX, 0, scroller->getTilesAcross() * scroller->getTileWidth());
		scrY = (int)Util::ClampValue<float>(scrY, 0, scroller->getTilesDown() * scroller->getTileHeight());

		scroller->setScrollPosition(scrX, scrY);
		g_game->gameState->player->posPlanet.x = scrX;
		g_game->gameState->player->posPlanet.y = scrY;
	}
	else
	{
		int scrX = (int)activeVessel->getX() - SCROLLEROFFSETX;
		int scrY = (int)activeVessel->getY() - SCROLLEROFFSETY;

		//keep scroll view from going off the "edge of the world"
		int maxwidth = ((scroller->getTilesAcross()-9) * scroller->getTileWidth()) - SCROLLEROFFSETX;
		int maxheight = ((scroller->getTilesDown()-6) * scroller->getTileHeight()) - SCROLLEROFFSETY;
		scrX = (int)Util::ClampValue<float>(scrX, 0, maxwidth);
		scrY = (int)Util::ClampValue<float>(scrY, 0, maxheight);

		scroller->setScrollPosition(scrX, scrY);
		g_game->gameState->player->posPlanet.x = scrX;
		g_game->gameState->player->posPlanet.y = scrY;
	}

	scroller->UpdateScrollBuffer();


	//draw scroll buffer
	scroller->DrawScrollWindow(g_game->GetBackBuffer(), 0, 0, SCREEN_WIDTH, 540);

	//TV goes on bottom so projectiles and lifeforms appear to crawl on top of it
	if (vessel_mode > 0)
	{
		bool TVisMoving = ( playerTV->getSpeed() != 0 || playerTV->TurnLeft() || playerTV->TurnRight() );
		bool TVisDamaged = ( playerTV->getHealth() < 75 );

		//the TV just passed under 75% health, and is moving
		if (!TVwasDamaged && TVisDamaged && TVisMoving){
			g_game->audioSystem->Stop("TVMove");
			g_game->audioSystem->Stop("damagedTV");
			g_game->audioSystem->Play("damagedTV", true);
			TVwasDamaged = true;
		}

		//the TV just stopped moving
		if (TVwasMoving && !TVisMoving){
			g_game->audioSystem->Stop("TVmove");
			g_game->audioSystem->Stop("damagedTV");
			TVwasMoving=false;
		}
		
		//the TV just started moving
		if (TVisMoving && !TVwasMoving){
			//this seems to be needed to prevent a race condition
			g_game->audioSystem->Stop("TVmove");
			g_game->audioSystem->Stop("damagedTV");

			TVisDamaged?
				g_game->audioSystem->Play("damagedTV",true) : g_game->audioSystem->Play("TVmove",true);
			TVwasMoving=true;
		}
		playerTV->TimedUpdate();
	}

	for (int i=0; i < (int)surfaceObjects.size(); ++i)
	{
		surfaceObjects[i]->TimedUpdate();
	}

    //cause cinematic ship to fly automatically 
	if (introCinematicRunning)
	{
		double distance = sqrt( (double)((playerShip->getX() - cinematicShip->getX()) * (playerShip->getX() - cinematicShip->getX())) + ((playerShip->getY() - cinematicShip->getY()) * (playerShip->getY() - cinematicShip->getY())) );
		double angle = atan2((double)playerShip->getY() - cinematicShip->getY(), (double)playerShip->getX() - cinematicShip->getX()) * 180/3.1415926535;

		double Increment = distance/10;
		if (Increment < 1) Increment = distance;
		cinematicShip->setX( cinematicShip->getX() + (cos(angle * 0.0174532925) * Increment) );
		cinematicShip->setY( cinematicShip->getY() + (sin(angle * 0.0174532925) * Increment) );

		if (cinematicShip->getScale() > playerShip->getScale())
			cinematicShip->setScale( cinematicShip->getScale() - .1 );

		if (cinematicShip->getX() == playerShip->getX() && cinematicShip->getY() == playerShip->getY())
		{
			introCinematicRunning = false;
		}
		cinematicShip->Draw();
	}

    //taking off from the surface into orbit
	else if (exitCinematicRunning)
	{
		double angle = cinematicShip->getFaceAngle();
		cinematicShip->setSpeed( cinematicShip->getSpeed() * 1.05 );

		cinematicShip->setX( cinematicShip->getX() + (cos(angle * 0.0174532925) * cinematicShip->getSpeed()) );
		cinematicShip->setY( cinematicShip->getY() + (sin(angle * 0.0174532925) * cinematicShip->getSpeed()) );

		cinematicShip->setScale( cinematicShip->getScale() + .15 );

		double distance = sqrt( (double)((playerShip->getX() - cinematicShip->getX()) * (playerShip->getX() - cinematicShip->getX())) + ((playerShip->getY() - cinematicShip->getY()) * (playerShip->getY() - cinematicShip->getY())) );
		cinematicShip->Draw();

        //this is the bug fix for issue 172
        //when at the edge of the screen and oriented outward, we'll never move 900 units
		//if (distance > 900)
        if (distance > 900 || cinematicShip->getScale() > 6.0 )
		{
			introCinematicRunning = false;
            g_game->gameState->m_ship.ConsumeFuel(100);
			g_game->modeMgr->LoadModule(MODULE_ORBIT);
			return;
		}
	}
	else
	{
		playerShip->TimedUpdate();
	}

	if (selectedPSO != NULL && selectedPSO->IsScanned())
		drawHPBar(selectedPSO);


	//draw top gauges gui
	static int ggx = (int)g_game->getGlobalNumber("GUI_GAUGES_POS_X");
	static int ggy = (int)g_game->getGlobalNumber("GUI_GAUGES_POS_Y");
	masked_blit(img_gauges, g_game->GetBackBuffer(), 0, 0, ggx, ggy, img_gauges->w, img_gauges->h);
	float percentage = 0.00f;


	if (vessel_mode != 1)
	{
		if(g_game->gameState->getShip().getMaxArmorIntegrity() <= 0){
			percentage = 0;
		}else{
			percentage = g_game->gameState->getShip().getArmorIntegrity() / g_game->gameState->getShip().getMaxArmorIntegrity();
		}
		masked_blit(Armor, g_game->GetBackBuffer(), 0, 0, 476, 10, Armor->w, Armor->h);
		masked_blit(ArmorBar, g_game->GetBackBuffer(), 0, 0, 536, 11, ArmorBar->w * percentage, ArmorBar->h);

		percentage = g_game->gameState->getShip().getFuel();
		masked_blit(Fuel, g_game->GetBackBuffer(), 0, 0, 666, 11, Fuel->w, Fuel->h);
		masked_blit(FuelBar, g_game->GetBackBuffer(), 0, 0, 709, 11, FuelBar->w * percentage, FuelBar->h);

		percentage = g_game->gameState->getShip().getHullIntegrity() / 100;
		masked_blit(Hull, g_game->GetBackBuffer(), 0, 0, 300, 11, Hull->w, Hull->h);
		masked_blit(HullBar, g_game->GetBackBuffer(), 0, 0, 342, 13, HullBar->w * percentage, HullBar->h);
	}
	else
	{
		masked_blit(Fuel, g_game->GetBackBuffer(), 0, 0, 666, 11, Fuel->w, Fuel->h);
		masked_blit(FuelBar, g_game->GetBackBuffer(), 0, 0, 709, 11, (int)(FuelBar->w * ((double)playerTV->getCounter3() / 100)), FuelBar->h);

		masked_blit(Hull, g_game->GetBackBuffer(), 0, 0, 300, 11, Hull->w, Hull->h);
		masked_blit(HullBar, g_game->GetBackBuffer(), 0, 0, 342, 13, (int)(HullBar->w * ((double)playerTV->getHealth() / 100)), HullBar->h);

	}

	//draw the aux gui
	static int gax = (int)g_game->getGlobalNumber("GUI_AUX_POS_X");
	static int gay = (int)g_game->getGlobalNumber("GUI_AUX_POS_Y");
	masked_blit(img_aux, g_game->GetBackBuffer(), 0, 0, gax, gay, img_aux->w, img_aux->h);

	//draw message window
	static int gmx = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_X");
	static int gmy = (int)g_game->getGlobalNumber("GUI_MESSAGE_POS_Y");
	blit(img_messages, g_game->GetBackBuffer(), 0, 0, gmx, gmy, img_messages->w, img_messages->h);
	messages->Draw(g_game->GetBackBuffer());

	//draw socket gui
	static int gsx = (int)g_game->getGlobalNumber("GUI_SOCKET_POS_X");
	static int gsy = (int)g_game->getGlobalNumber("GUI_SOCKET_POS_Y");
	masked_blit(img_socket, g_game->GetBackBuffer(), 0, 0, gsx, gsy, img_socket->w, img_socket->h);


	static int gcpx = (int)g_game->getGlobalNumber("GUI_CONTROLPANEL_POS_X");
	static int gcpy = (int)g_game->getGlobalNumber("GUI_CONTROLPANEL_POS_Y");
	masked_blit(img_control, g_game->GetBackBuffer(), 0, 0, gcpx, gcpy, img_control->w, img_control->h);


	//always draw help text unless it would interfere with buttons
	if (!activeButtons)
		label->Draw(g_game->GetBackBuffer());

	for (int i=0; i < 2; ++i) BigBtns[i]->Run(g_game->GetBackBuffer());

	for (int i=0; i < activeButtons; ++i) Btns[i]->Run(g_game->GetBackBuffer());

	cargoBtn->Run(g_game->GetBackBuffer());

	masked_blit( Cargo_BarFill, g_game->GetBackBuffer(), 0, 0, CARGOFILL_X, CARGOFILL_Y, (int)(Cargo_BarFill->w * cargoFillPercent), Cargo_BarFill->h);


	if (timerOn)
	{
		masked_blit(Timer_BarEmpty, g_game->GetBackBuffer(), 0, 0, TIMER_X, TIMER_Y, Timer_BarEmpty->w, Timer_BarEmpty->h);
		masked_blit(Timer_BarFill, g_game->GetBackBuffer(), 0, 0, TIMER_X, TIMER_Y, (int)(Timer_BarFill->w * ((double)timerCount/timerLength)), Timer_BarFill->h);
		TimerText->Draw(g_game->GetBackBuffer());

		if (timerLength <= ++timerCount)
		{
			timerOn = false;
			timerCount = 0;
			timerLength = 0;

			//stop playback of the sound effects
			if ( g_game->audioSystem->SampleExists("scanning") )
				g_game->audioSystem->Stop("scanning");
			if ( g_game->audioSystem->SampleExists("pickuplifeform") )
				g_game->audioSystem->Stop("pickuplifeform");
			if ( g_game->audioSystem->SampleExists("mining") )
				g_game->audioSystem->Stop("mining");

			Event e(TIMER_EXPIRED_EVENT);
			g_game->modeMgr->BroadcastEvent(&e);
		}
	}


	if(player_stranded == true && vessel_mode == 0){
		BigBtns[1]->SetButtonText("S.O.S.");
	}

	drawMinimap();

	//DEBUG CODE -- do not delete
	//int y=90;
	//g_game->PrintDefault(g_game->GetBackBuffer(), 700, y, "vessel_mode: " + Util::ToString(vessel_mode) );
	//y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 700, y, "playerShip  : " + Util::ToString(playerShip->getX()) + "," + Util::ToString(playerShip->getY()) + " (" + Util::ToString(playerShip->getFaceAngle()) + ")" );
	//y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 700, y, "playerTV    : " + Util::ToString(playerTV->getX()) + "," + Util::ToString(playerTV->getY()) + " (" + Util::ToString(playerTV->getFaceAngle()) + ")" );
	//y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 700, y, "activeVessel: " + Util::ToString(activeVessel->getX()) + "," + Util::ToString(activeVessel->getY()) + " (" + Util::ToString(activeVessel->getFaceAngle()) + ")" );
	//y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 700, y, "posPlanet: " + Util::ToString(g_game->gameState->player->posPlanet.x) + "," + Util::ToString(g_game->gameState->player->posPlanet.y));

}


void ModulePlanetSurface::drawMinimap()
{
	clear_bitmap(minimap);

	//draw the planet scanner image
	stretch_blit(surface, minimap, 0, 0, surface->w, surface->h, 0, 0, minimap->w, minimap->h);

	//draw the player's position on the minimap
	float x =  playerShip->getX() / ( scroller->getTilesAcross() * scroller->getTileWidth() ) * minimap->w ;
	float y =  playerShip->getY() / ( scroller->getTilesDown() * scroller->getTileHeight() ) * minimap->h ;
	circlefill(minimap, x , y, 3, LTRED);
	circle(minimap, x , y, 3, BLACK);

	//draw terrain vehicle on minimap
	if (vessel_mode > 0)
	{
		x = ( playerTV->getX() ) / ( scroller->getTilesAcross() * scroller->getTileWidth() ) * minimap->w;
		y = ( playerTV->getY() ) / ( scroller->getTilesDown() * scroller->getTileHeight() ) * minimap->h;
		circlefill(minimap, x, y, 3, YELLOW);
		circle(minimap, x, y, 3, BLACK);
	}

	//draw lifeforms and minerals on minimap
	int color;
	int objtype;
	for (int i=0; i < (int)surfaceObjects.size(); ++i)
	{
		objtype = surfaceObjects[i]->getObjectType();
        if (objtype == 0 || objtype == 1)  //draw only minerals/lifeforms
        {
		    switch (objtype)
		    {
			    case 0: color = makecol(30,180,30); break; //lifeform
			    case 1: color = makecol(120,100,50); break; //mineral
			    //case 2: color = makecol(0,0,255); break; //artifact
                //case 3: color = makecol(30,255,255); break; //ruin
			    //default: color = makecol(0,0,0); break;
		    }

		    x = surfaceObjects[i]->getX() / ( scroller->getTilesAcross() * scroller->getTileWidth() ) * minimap->w;
		    y = surfaceObjects[i]->getY() / ( scroller->getTilesDown() * scroller->getTileHeight() ) * minimap->h;
		    circlefill(minimap, x, y, 2, color );
		    circle(minimap, x, y, 2, BLACK);
        }
	}

	blit(minimap, g_game->GetBackBuffer(), 0, 0, asx, asy, asw, ash);
}

void ModulePlanetSurface::updateCargoFillPercent()
{
	double occupiedSpace = g_game->gameState->m_ship.getOccupiedSpace();
	double totalSpace = g_game->gameState->m_ship.getTotalSpace();
	cargoFillPercent = occupiedSpace/totalSpace;
	if (cargoFillPercent > 1) cargoFillPercent=1;
}

void ModulePlanetSurface::drawHPBar(PlanetSurfaceObject *PSO)
{
	masked_blit(HP_Bar, g_game->GetBackBuffer(), 0, 0, (int)(PSO->getX() + (PSO->getFrameWidth()/2) - (HP_Bar->w/2) - g_game->gameState->player->posPlanet.x), (int) (PSO->getY() - g_game->gameState->player->posPlanet.y), (int) (HP_Bar->w * (double)PSO->getHealth()/PSO->getMaxHealth()), HP_Bar->h);
}

double ModulePlanetSurface::CalcDistance(PlanetSurfaceObject *PSO1, PlanetSurfaceObject *PSO2)
{
	return sqrt( ((PSO2->getX() - PSO1->getX()) * (PSO2->getX() - PSO1->getX())) + ((PSO2->getY() - PSO1->getY()) * (PSO2->getY() - PSO1->getY())) );
}

void ModulePlanetSurface::PostMessage(std::string text)
{
	messages->Write(text);
	messages->ScrollToBottom();
}

void ModulePlanetSurface::PostMessage(std::string text, int color)
{
	messages->Write(text, color);
	messages->ScrollToBottom();
}

void ModulePlanetSurface::PostMessage(std::string text, int color, int blanksBefore)
{
	for (int i=0; i < blanksBefore; ++i) messages->Write("");
	messages->Write(text, color);
	messages->ScrollToBottom();
}

void ModulePlanetSurface::PostMessage(std::string text, int color, int blanksBefore, int blanksAfter)
{
	for (int i=0; i < blanksBefore; ++i) messages->Write("");
	messages->Write(text, color);
	for (int i=0; i < blanksAfter; ++i) messages->Write("");
	messages->ScrollToBottom();
}


void ModulePlanetSurface::LoadPortrait(std::string name, std::string filepath)
{
	portraitsIt = portraits.find(name);
	//Only load a portrait once
	if ( portraitsIt == portraits.end() )
	{
		BITMAP *portrait = load_bitmap( filepath.c_str(), NULL);

		//Make sure the image load just fine
		if (portrait != NULL && name != "")
			portraits[name] = portrait;
	}
}


void ModulePlanetSurface::ShowPortrait(std::string name)
{
	this->showPortrait = name;
	this->showPortraitCounter = 0;
}

void ModulePlanetSurface::CheckForCollisions(PlanetSurfaceObject *PSO)
{
	for (int i=0; i < (int)surfaceObjects.size(); ++i)
	{
		if (PSO != surfaceObjects[i])
			PSO->CheckCollision(surfaceObjects[i]);
	}
	if (vessel_mode > 0)
	{
		if (PSO != playerTV && PSO != playerShip)
			PSO->CheckCollision(playerTV);
	}

	//Check Top left
	int x = (int) PSO->getXOffset() - PSO->getColHalfWidth();
	int y = (int) PSO->getYOffset() - PSO->getColHalfHeight();
	CheckTileCollision(PSO, x,y);

	//Check Top right
	x = (int) PSO->getXOffset() + PSO->getColHalfWidth();
	y = (int) PSO->getYOffset() - PSO->getColHalfHeight();
	CheckTileCollision(PSO, x,y);

	//Check Bottom right
	x = (int) PSO->getXOffset() + PSO->getColHalfWidth();
	y = (int) PSO->getYOffset() + PSO->getColHalfHeight();
	CheckTileCollision(PSO, x,y);

	//Check Bottom left
	x = (int) PSO->getXOffset() - PSO->getColHalfWidth();
	y = (int) PSO->getYOffset() + PSO->getColHalfHeight();
	CheckTileCollision(PSO, x,y);

}

void ModulePlanetSurface::CheckTileCollision(PlanetSurfaceObject *PSO, int x, int y)
{
	if (scroller->CheckCollisionbyCoords(x, y))
	{
		scroller->ConvertCoordstoNearestPoint(x, y);
		PSO->CheckCollision((x * scroller->getTileWidth()) - (scroller->getTileWidth()/2), (y * scroller->getTileHeight()) - (scroller->getTileWidth()/2), scroller->getTileWidth(), scroller->getTileHeight());
	}
}

bool ModulePlanetSurface::IsValidTile(int x, int y)
{
	return !(scroller->CheckCollisionbyCoords(x, y));
}


#pragma region LUA_JUNK
void ModulePlanetSurface::SetupLua()
{
	/* initialize Lua */
	LuaVM = lua_open();

	/* load Lua base libraries */
	luaL_openlibs(LuaVM);

	lua_register(LuaVM, "L_Debug", L_Debug);
	lua_register(LuaVM, "L_LoadImage", L_LoadImage);
	lua_register(LuaVM, "L_Move", L_Move);
	lua_register(LuaVM, "L_Draw", L_Draw);
	lua_register(LuaVM, "L_Animate", L_Animate);
	lua_register(LuaVM, "L_LaunchTV", L_LaunchTV);
	lua_register(LuaVM, "L_SetActions", L_SetActions);
	lua_register(LuaVM, "L_LoadScript", L_LoadScript);
	lua_register(LuaVM, "L_PostMessage", L_PostMessage);
	lua_register(LuaVM, "L_LoadPortrait", L_LoadPortrait);
	lua_register(LuaVM, "L_ShowPortrait", L_ShowPortrait);
	lua_register(LuaVM, "L_AddItemtoCargo", L_AddItemtoCargo);
    lua_register(LuaVM, "L_AddArtifactToCargo", L_AddArtifactToCargo);
	lua_register(LuaVM, "L_DeleteSelf", L_DeleteSelf);
	lua_register(LuaVM, "L_LoadPSObyID", L_LoadPSObyID);
	lua_register(LuaVM, "L_CreateNewPSO", L_CreateNewPSO);
	lua_register(LuaVM, "L_CreateNewPSObyItemID", L_CreateNewPSObyItemID);
	lua_register(LuaVM, "L_LoadPlayerTVasPSO", L_LoadPlayerTVasPSO);
	lua_register(LuaVM, "L_LoadPlayerShipasPSO", L_LoadPlayerShipasPSO);
	lua_register(LuaVM, "L_Test", L_Test);
	lua_register(LuaVM, "L_SetRunPlanetLoadScripts", L_SetRunPlanetLoadScripts);
	lua_register(LuaVM, "L_GetRunPlanetLoadScripts", L_GetRunPlanetLoadScripts);
	lua_register(LuaVM, "L_SetRunPlanetPopulate", L_SetRunPlanetPopulate);
	lua_register(LuaVM, "L_GetRunPlanetPopulate", L_GetRunPlanetPopulate);
	lua_register(LuaVM, "L_CheckInventorySpace", L_CheckInventorySpace);
	lua_register(LuaVM, "L_KilledAnimal", L_KilledAnimal);
	lua_register(LuaVM, "L_AttackTV", L_AttackTV);
	lua_register(LuaVM, "L_TVDestroyed", L_TVDestroyed);
	lua_register(LuaVM, "L_TVOutofFuel", L_TVOutofFuel);
	lua_register(LuaVM, "L_PlayerTVisAlive", L_PlayerTVisAlive);
	lua_register(LuaVM, "L_CheckInventoryFor", L_CheckInventoryFor);
	lua_register(LuaVM, "L_RemoveItemFromInventory", L_RemoveItemFromInventory);
	lua_register(LuaVM, "L_GetPlanetID", L_GetPlanetID);
	lua_register(LuaVM, "L_CreateTimer", L_CreateTimer);

	lua_register(LuaVM, "L_GetPlayerShipPosition", L_GetPlayerShipPosition);
	lua_register(LuaVM, "L_GetPlayerTVPosition", L_GetPlayerTVPosition);
	lua_register(LuaVM, "L_GetActiveVesselPosition", L_GetActiveVesselPosition);
	lua_register(LuaVM, "L_GetScrollerPosition", L_GetScrollerPosition);
	lua_register(LuaVM, "L_GetPlayerProfession", L_GetPlayerProfession);
	lua_register(LuaVM, "L_GetPosition", L_GetPosition);
	lua_register(LuaVM, "L_GetOffsetPosition", L_GetOffsetPosition);
	lua_register(LuaVM, "L_GetScreenWidth", L_GetScreenWidth);
	lua_register(LuaVM, "L_GetScreenHeight", L_GetScreenHeight);
	lua_register(LuaVM, "L_GetScreenDim", L_GetScreenDim);
	lua_register(LuaVM, "L_GetSpeed", L_GetSpeed);
	lua_register(LuaVM, "L_GetFaceAngle", L_GetFaceAngle);
	lua_register(LuaVM, "L_GetPlayerNavVars", L_GetPlayerNavVars);
	lua_register(LuaVM, "L_GetScale", L_GetScale);
	lua_register(LuaVM, "L_GetCounters", L_GetCounters);
	lua_register(LuaVM, "L_GetThresholds", L_GetThresholds);
	lua_register(LuaVM, "L_IsPlayerMoving", L_IsPlayerMoving);
	lua_register(LuaVM, "L_GetItemID", L_GetItemID);
	lua_register(LuaVM, "L_GetState", L_GetState);
	lua_register(LuaVM, "L_GetVesselMode", L_GetVesselMode);
	lua_register(LuaVM, "L_IsScanned", L_IsScanned);
	lua_register(LuaVM, "L_GetName", L_GetName);
	lua_register(LuaVM, "L_GetValue", L_GetValue);
	lua_register(LuaVM, "L_GetDamage", L_GetDamage);
	lua_register(LuaVM, "L_IsBlackMarketItem", L_IsBlackMarketItem);
	lua_register(LuaVM, "L_IsShipRepairMetal", L_IsShipRepairMetal);
	lua_register(LuaVM, "L_IsAlive", L_IsAlive);
	lua_register(LuaVM, "L_GetColHalfWidth", L_GetColHalfWidth);
	lua_register(LuaVM, "L_GetColHalfHeight", L_GetColHalfHeight);
	lua_register(LuaVM, "L_GetID", L_GetID);
	lua_register(LuaVM, "L_GetScriptName", L_GetScriptName);
	lua_register(LuaVM, "L_GetHealth", L_GetHealth);
	lua_register(LuaVM, "L_GetMaxHealth", L_GetMaxHealth);
	lua_register(LuaVM, "L_GetStunCount", L_GetStunCount);
	lua_register(LuaVM, "L_GetItemSize", L_GetItemSize);
	lua_register(LuaVM, "L_GetSelectedPSOid", L_GetSelectedPSOid);
	lua_register(LuaVM, "L_GetObjectType", L_GetObjectType);
	lua_register(LuaVM, "L_GetDanger", L_GetDanger);
	lua_register(LuaVM, "L_GetMinimapColor", L_GetMinimapColor);
	lua_register(LuaVM, "L_GetMinimapSize", L_GetMinimapSize);

	lua_register(LuaVM, "L_SetPosition", L_SetPosition);
	lua_register(LuaVM, "L_SetVelocity", L_SetVelocity);
	lua_register(LuaVM, "L_SetSpeed", L_SetSpeed);
	lua_register(LuaVM, "L_SetFaceAngle", L_SetFaceAngle);
	lua_register(LuaVM, "L_SetAnimInfo", L_SetAnimInfo);
	lua_register(LuaVM, "L_SetAngleOffset", L_SetAngleOffset);
	lua_register(LuaVM, "L_SetScale", L_SetScale);
	lua_register(LuaVM, "L_SetCounters", L_SetCounters);
	lua_register(LuaVM, "L_SetThresholds", L_SetThresholds);
	lua_register(LuaVM, "L_SetState", L_SetState);
	lua_register(LuaVM, "L_SetVesselMode", L_SetVesselMode);
	lua_register(LuaVM, "L_SetScanned", L_SetScanned);
	lua_register(LuaVM, "L_SetDamage", L_SetDamage);
	lua_register(LuaVM, "L_SetAlive", L_SetAlive);
	lua_register(LuaVM, "L_SetColHalfWidth", L_SetColHalfWidth);
	lua_register(LuaVM, "L_SetColHalfHeight", L_SetColHalfHeight);
	lua_register(LuaVM, "L_SetScriptName", L_SetScriptName);
	lua_register(LuaVM, "L_SetAlpha", L_SetAlpha);
	lua_register(LuaVM, "L_SetHealth", L_SetHealth);
	lua_register(LuaVM, "L_SetMaxHealth", L_SetMaxHealth);
	lua_register(LuaVM, "L_SetStunCount", L_SetStunCount);
	lua_register(LuaVM, "L_SetObjectType", L_SetObjectType);
	lua_register(LuaVM, "L_SetName", L_SetName);
	lua_register(LuaVM, "L_SetMinimapColor", L_SetMinimapColor);
	lua_register(LuaVM, "L_SetMinimapSize", L_SetMinimapSize);
	lua_register(LuaVM, "L_SetNewAnimation", L_SetNewAnimation);
	lua_register(LuaVM, "L_SetActiveAnimation", L_SetActiveAnimation);

	lua_register(LuaVM, "L_PlaySound", L_PlaySound);
	lua_register(LuaVM, "L_PlayLoopingSound", L_PlayLoopingSound);
	lua_register(LuaVM, "L_StopSound", L_StopSound);

    //added for ruins
    lua_register(LuaVM, "L_GetDescription", L_GetDescription);


	/* load the scripts */
	luaL_dofile(LuaVM, "data/planetsurface/Functions.lua");
	luaL_dofile(LuaVM, "data/planetsurface/PlanetSurfacePlayerShip.lua");
	luaL_dofile(LuaVM, "data/planetsurface/PlanetSurfacePlayerTV.lua");
	luaL_dofile(LuaVM, "data/planetsurface/stunprojectile.lua");
}




//********************************************************
//*					Global Lua Functions                 *
//********************************************************

int L_Debug(lua_State* luaVM)
{
	std::string text = lua_tostring(luaVM, -1);
	lua_pop(luaVM, 1);	

	//cout << "LUA DEBUG: " << text << endl;
	TRACE( text.append("\n").c_str() );

	return 0;
}

int L_LoadImage(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->load( lua_tostring(luaVM, -1) );
	}
	lua_pop(luaVM, 1);

	return 0;
}

//Lua Example: L_Move()
int L_Move(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->Move();
	}

	return 0;
}

//Lua Example: L_Draw()
int L_Draw(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->Draw();
	}

	return 0;
}

//Lua Example: L_Animate()
int L_Animate(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->Animate();
	}

	return 0;
}


//Lua Example: L_LaunchTV()
int L_LaunchTV(lua_State* luaVM)
{
	if(g_game->gameState->getShip().getFuel() <= 0.00f)
		g_game->gameState->getShip().injectEndurium();
	g_game->gameState->m_ship.ConsumeFuel(10);
	g_game->PlanetSurfaceHolder->playerTV->setCounter3(100);
	g_game->PlanetSurfaceHolder->activeVessel = g_game->PlanetSurfaceHolder->playerTV;
	return 0;
}

//Lua Example: L_SetActions("Stun","PickUp","Mine") --You can go up to 9, one for each button
int L_SetActions(lua_State* luaVM)
{
	int i=0;
	for (i=0; lua_gettop( luaVM ); ++i)
	{
		if (i < 9)
		{
			g_game->PlanetSurfaceHolder->Btns[i]->SetButtonText( lua_tostring( luaVM, -1 ) );
			lua_pop(luaVM, 1);
		}
		else
		{
			break;
		}
	}
	g_game->PlanetSurfaceHolder->activeButtons = i;
	if (i == 0)
	{
		g_game->PlanetSurfaceHolder->label->SetText(OBJECT_NEEDS_SCANNED_TEXT);
		g_game->PlanetSurfaceHolder->label->Refresh();
	}
	return 0;
}

int L_LoadScript(lua_State* luaVM)
{
	luaL_dofile(luaVM, lua_tostring(luaVM, -1));
	lua_pop(luaVM, 1);

	return 0;
}

//			   L_PostMessage(b, g, r, "message")  ||  L_PostMessage("message")
//Lua Example: L_PostMessage(0, 0, 255, "You lick it...it doesn't taste good")
int L_PostMessage(lua_State* luaVM)
{
	int rgb[3];
	std::string text = lua_tostring(luaVM, -1);
	lua_pop(luaVM, 1);

	int i=0;
	for (i=0; lua_gettop( luaVM ); ++i)
	{
		if (i < 3)
		{
			rgb[i] = (int)lua_tonumber( luaVM, -1 );
			lua_pop(luaVM, 1);
		}
		else
		{
			break;
		}
	}

	if (i >= 3)
		g_game->PlanetSurfaceHolder->messages->Write( text, makecol(rgb[0], rgb[1], rgb[2]) );
	else
		g_game->PlanetSurfaceHolder->messages->Write( text );
	g_game->PlanetSurfaceHolder->messages->ScrollToBottom();

	return 0;
}

int L_LoadPortrait(lua_State* luaVM)
{
	std::string filepath = lua_tostring(luaVM, -1);
	lua_pop(luaVM, 1);

	std::string name = lua_tostring(luaVM, -1);
	lua_pop(luaVM, 1);

	g_game->PlanetSurfaceHolder->LoadPortrait(name, filepath);

	return 0;
}

//Lua Example: L_ShowPortrait("mineral")
int L_ShowPortrait(lua_State* luaVM)
{
	std::string name = lua_tostring(luaVM, -1);
	lua_pop(luaVM, 1);

	g_game->PlanetSurfaceHolder->ShowPortrait(name);

	return 0;
}

//Lua Example: L_AddItemtoCargo(amount, itemID)  ||  L_AddItemtoCargo(itemID) defaults to 1 amount
int L_AddItemtoCargo(lua_State* luaVM)
{
	int amount = 1;
	int id = (int)lua_tonumber(luaVM, -1);
	lua_pop(luaVM, 1);

	if (lua_gettop( luaVM ) )
	{
		amount = (int)lua_tonumber(luaVM, -1);
		lua_pop(luaVM, 1);
	}

	g_game->gameState->m_items.AddItems(id, amount);		//jjh

	Event e(CARGO_EVENT_UPDATE);
	g_game->modeMgr->BroadcastEvent(&e);

	return 0;
}

/**
    Lua Example: L_AddArtifactToCargo(artifactID)
**/
int L_AddArtifactToCargo(lua_State* luaVM)
{
    //get artifact ID
    int id = (int)lua_tonumber(luaVM, -1);
	lua_pop(luaVM, 1);

    //allow only one artifact by itemID to exist in cargo
    g_game->gameState->m_items.SetItemCount(id, 1);

    //notify cargo window to update list
    Event e(CARGO_EVENT_UPDATE);
    g_game->modeMgr->BroadcastEvent(&e);

	return 0;
}


//Lua Example: L_DeletePSO()
int L_DeleteSelf(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		if (g_game->PlanetSurfaceHolder->selectedPSO == g_game->PlanetSurfaceHolder->psObjectHolder)
		{
			g_game->PlanetSurfaceHolder->selectedPSO = NULL;
			g_game->PlanetSurfaceHolder->activeButtons = 0;
		}

		g_game->PlanetSurfaceHolder->RemovePlanetSurfaceObject(g_game->PlanetSurfaceHolder->psObjectHolder);

		g_game->PlanetSurfaceHolder->psObjectHolder = NULL;
	}

	return 0;
}

//Lua Example: L_LoadPSObyID(id)
int L_LoadPSObyID(lua_State* luaVM)
{
	int id = (int)lua_tonumber(luaVM, -1);
	lua_pop(luaVM, 1);

	if (id >= 0 && id < (int)g_game->PlanetSurfaceHolder->surfaceObjects.size() && g_game->PlanetSurfaceHolder->surfaceObjects[id] != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder = g_game->PlanetSurfaceHolder->surfaceObjects[id];
	}
	return 0;
}

//Lua Example: id = L_CreateNewPSO("scriptname")
int L_CreateNewPSO(lua_State* luaVM)
{
	g_game->PlanetSurfaceHolder->AddPlanetSurfaceObject(new PlanetSurfaceObject(luaVM, lua_tostring(luaVM, -1)));
	lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->surfaceObjects.size() - 1 );

	return 1;
}

//Lua Example: id = L_CreateNewPSObyItemID("scriptname", itemid)
int L_CreateNewPSObyItemID(lua_State* luaVM)
{
	int itemid = (int)lua_tonumber(luaVM, -1);
	lua_pop(luaVM, 1);

	std::string scriptName = lua_tostring(luaVM, -1);
	lua_pop(luaVM, 1);

	g_game->PlanetSurfaceHolder->CreatePSObyItemID(scriptName, itemid);
	lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->surfaceObjects.size() - 1 );

	return 1;
}


//Lua Example: L_LoadPlayerTVasPSO()
int L_LoadPlayerTVasPSO(lua_State* luaVM)
{
	g_game->PlanetSurfaceHolder->psObjectHolder = g_game->PlanetSurfaceHolder->playerTV;

	return 0;
}


//Lua Example: L_LoadPlayerShipasPSO()
int L_LoadPlayerShipasPSO(lua_State* luaVM)
{
	g_game->PlanetSurfaceHolder->psObjectHolder = g_game->PlanetSurfaceHolder->playerShip;

	return 0;
}

//Lua Example: L_Test()  --This function is used to test lua scripts
int L_Test(lua_State* luaVM)
{
	//I don't do anything I'm just used as a break point!
	return 0;
}


//Lua Example: L_SetRunPlanetLoadScripts(false)
int L_SetRunPlanetLoadScripts(lua_State* luaVM)
{
	g_game->PlanetSurfaceHolder->runPlanetLoadScripts = lua_toboolean(luaVM, -1) != 0;
	lua_pop(luaVM, 1);

	return 0;
}

//Lua Example: L_GetRunPlanetLoadScripts()
int L_GetRunPlanetLoadScripts(lua_State* luaVM)
{
	lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->runPlanetLoadScripts );
	return 1;
}


//Lua Example: L_SetRunPlanetPopulate(false)
int L_SetRunPlanetPopulate(lua_State* luaVM)
{
	g_game->PlanetSurfaceHolder->runPlanetPopulate = lua_toboolean(luaVM, -1) != 0;
	lua_pop(luaVM, 1);

	return 0;
}

//Lua Example: L_GetRunPlanetPopulate()
int L_GetRunPlanetPopulate(lua_State* luaVM)
{
	lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->runPlanetPopulate );
	return 1;
}

//Lua Example: L_CheckInventorySpace(quantity)
int L_CheckInventorySpace(lua_State* luaVM)
{
	int quantity = (int)lua_tonumber(luaVM, -1);
	lua_pop(luaVM, 1);

	lua_pushboolean( luaVM, g_game->gameState->m_ship.getAvailableSpace() >= quantity );

	return 1;

}

//Lua Example: L_KilledAnimal(itemid)
int L_KilledAnimal(lua_State* luaVM)
{
	//int animalid = (int)lua_tonumber(luaVM, -1);
	lua_pop(luaVM, 1);

	if (g_game->audioSystem->SampleExists("lifeformkilled"))
		g_game->audioSystem->Play("lifeformkilled");

	//Game::questMgr->KillAnimalEventMgr.Raise(IKillAnimalEvent::KillAnimal(animalid));

	return 0;
}

//Lua Example: L_Interacted(interactid)
//int L_Interacted(lua_State* luaVM)
//{
//	int interactid = (int)lua_tonumber(luaVM, -1);
//	lua_pop(luaVM, 1);
//
//	Game::questMgr->InteractEventMgr.Raise(IInteractEvent::Interact(interactid));
//
//	return 0;
//}

//Lua Example: L_AttackTV(damage)
int L_AttackTV(lua_State* luaVM)
{
	int damage = (int)lua_tonumber(luaVM, -1);
	lua_pop(luaVM, 1);

	if (g_game->audioSystem->SampleExists("lifeformattack"))
		g_game->audioSystem->Play("lifeformattack");

	if (g_game->PlanetSurfaceHolder->playerTV != NULL)
	{
		int realdamage = damage/10;

		g_game->PlanetSurfaceHolder->playerTV->setHealth( (int)(g_game->PlanetSurfaceHolder->playerTV->getHealth() - realdamage) );
		g_game->PlanetSurfaceHolder->vibration = 20;

		int health = g_game->PlanetSurfaceHolder->playerTV->getHealth();

		if (health < 25)
			g_game->PlanetSurfaceHolder->PostMessage("CAPTAIN! THE TERRAIN VEHICLE IS UNDER ATTACK AND IN CRITICAL CONDITION! HURRY AND GET IT OUT OF THERE!", RED, 0, 5);
		else if (health < 50)
			g_game->PlanetSurfaceHolder->PostMessage("CAPTAIN! A LIFEFORM IS ATTACKING THE TERRAIN VEHICLE! DO SOMETHING QUICK!", RED, 0, 5);
		else if (health < 75)
			g_game->PlanetSurfaceHolder->PostMessage("CAPTAIN! A LIFEFORM IS ATTACKING THE TERRAIN VEHICLE!", RED, 0, 6);
		else
			g_game->PlanetSurfaceHolder->PostMessage("Captain, the Terrain Vehicle is under attack.", RED, 0, 6);
	}

	return 0;
}

//Lua Example: L_TVDestroyed()
int L_TVDestroyed(lua_State* luaVM)
{
	g_game->PlanetSurfaceHolder->panCamera = true;
	g_game->PlanetSurfaceHolder->panFocus = g_game->PlanetSurfaceHolder->playerShip;
	g_game->PlanetSurfaceHolder->activeVessel = g_game->PlanetSurfaceHolder->playerShip;
	g_game->PlanetSurfaceHolder->vessel_mode = 0;
	if (g_game->PlanetSurfaceHolder->selectedPSO != NULL)
		g_game->PlanetSurfaceHolder->selectedPSO->setSelected(false);
	g_game->PlanetSurfaceHolder->selectedPSO = NULL;
	g_game->PlanetSurfaceHolder->activeButtons = 0;

	g_game->PlanetSurfaceHolder->playerShip->setSpeed(0); //This stops the ship from moving right after docking the TV
	g_game->PlanetSurfaceHolder->playerShip->ResetNav();
	g_game->PlanetSurfaceHolder->playerTV->setCounter3(0);//This empties the fuel bar

	g_game->PlanetSurfaceHolder->BigBtns[0]->SetButtonText("Land");
	g_game->PlanetSurfaceHolder->BigBtns[1]->SetButtonText("Launch");

	g_game->PlanetSurfaceHolder->label->SetText(SHIP_TEXT);
	g_game->PlanetSurfaceHolder->label->Refresh();

	return 0;
}


//Lua Example: L_TVOutofFuel()
int L_TVOutofFuel(lua_State* luaVM)
{
	g_game->PlanetSurfaceHolder->panCamera = true;
	g_game->PlanetSurfaceHolder->panFocus = g_game->PlanetSurfaceHolder->playerShip;
	g_game->PlanetSurfaceHolder->activeVessel = g_game->PlanetSurfaceHolder->playerShip;
	g_game->PlanetSurfaceHolder->vessel_mode = 2;
	if (g_game->PlanetSurfaceHolder->selectedPSO != NULL)
		g_game->PlanetSurfaceHolder->selectedPSO->setSelected(false);

	if (g_game->PlanetSurfaceHolder->timerOn)
	{
		g_game->PlanetSurfaceHolder->timerOn = false;
		g_game->PlanetSurfaceHolder->timerCount = 0;
		g_game->PlanetSurfaceHolder->timerLength = 0;
	}

	g_game->PlanetSurfaceHolder->selectedPSO = NULL;
	g_game->PlanetSurfaceHolder->activeButtons = 0;

	g_game->PlanetSurfaceHolder->BigBtns[0]->SetButtonText("Pick Up");
	g_game->PlanetSurfaceHolder->BigBtns[1]->SetButtonText("Pick Up");

	g_game->PlanetSurfaceHolder->label->SetText(TVOUTOFFUEL_TEXT);
	g_game->PlanetSurfaceHolder->label->Refresh();


	g_game->PlanetSurfaceHolder->playerShip->setSpeed(0); //This stops the ship from moving right after docking the TV
	g_game->PlanetSurfaceHolder->playerShip->ResetNav();

	g_game->PlanetSurfaceHolder->playerTV->setCounter3(0);//This empties the fuel bar
	g_game->PlanetSurfaceHolder->playerTV->ResetNav();
	g_game->PlanetSurfaceHolder->playerTV->setSpeed(0); //This stops the tv from moving

	return 0;
}

//Lua Example: alive = L_PlayerTVisAlive()
int L_PlayerTVisAlive(lua_State* luaVM)
{
	lua_pushboolean( luaVM, g_game->PlanetSurfaceHolder->playerTV->isAlive() );

	return 1;
}


//Lua Example: haveCargo = L_CheckInventoryFor( itemID, amount)
int L_CheckInventoryFor(lua_State* luaVM)
{
	int amount = (int)lua_tonumber(luaVM, -1);
	lua_pop(luaVM, 1);

	int itemID = (int)lua_tonumber(luaVM, -1);
	lua_pop(luaVM, 1);

	bool result = false;
	for (int i=0; i < g_game->gameState->m_items.GetNumStacks(); ++i)
	{
		Item item; int amt;
		g_game->gameState->m_items.GetStack(i, item, amt);

		if (item.id == itemID && amt >= amount)
		{
			result = true;
			break;
		}
	}

	lua_pushboolean( luaVM, result );

	return 1;
}

//Lua Example: L_RemoveItemFromInventory( itemID, amount)
int L_RemoveItemFromInventory(lua_State* luaVM)
{
	int amount = (int)lua_tonumber(luaVM, -1);
	lua_pop(luaVM, 1);

	int itemID = (int)lua_tonumber(luaVM, -1);
	lua_pop(luaVM, 1);

	g_game->gameState->m_items.RemoveItems(itemID, amount);

	return 0;
}


//Lua Example: planetid = L_GetPlanetID()
int L_GetPlanetID(lua_State* luaVM)
{
	lua_pushnumber( luaVM, g_game->gameState->player->currentPlanet );

	return 1;
}


//Lua Example: L_CreateTimer("Extract",100)
int L_CreateTimer(lua_State* luaVM)
{
	g_game->PlanetSurfaceHolder->timerOn = true;

	int timerLength = (int)lua_tonumber(luaVM, -1);
	lua_pop(luaVM, 1);

	std::string timerName = lua_tostring(luaVM, -1);
	lua_pop(luaVM, 1);

	g_game->PlanetSurfaceHolder->timerCount = 0;
	g_game->PlanetSurfaceHolder->timerLength = timerLength;
	g_game->PlanetSurfaceHolder->TimerText->SetText(timerName);
	g_game->PlanetSurfaceHolder->TimerText->Refresh();

	return 0;
}

//Lua Example: x,y = L_GetPlayerShipPosition()
int L_GetPlayerShipPosition( lua_State* luaVM )
{
	lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->playerShip->getX() );
	lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->playerShip->getY() );

	return 2;
}

//Lua Example: x,y = L_GetPlayerTVPosition()
int L_GetPlayerTVPosition( lua_State* luaVM )
{
	lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->playerTV->getX() );
	lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->playerTV->getY() );

	return 2;
}


//Lua Example: x,y = L_GetActiveVesselPosition()
int L_GetActiveVesselPosition( lua_State* luaVM )
{
	lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->activeVessel->getX() );
	lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->activeVessel->getY() );

	return 2;
}


//Lua Example: x,y = L_GetScrollerPosition()
int L_GetScrollerPosition( lua_State* luaVM )
{
	lua_pushnumber( luaVM, g_game->gameState->player->posPlanet.x );
	lua_pushnumber( luaVM, g_game->gameState->player->posPlanet.y );

	return 2;
}

//Lua Example: prof = L_GetPlayerProfession()
int L_GetPlayerProfession( lua_State* luaVM )
{
	lua_pushnumber( luaVM, (int)g_game->gameState->getProfession() );

	return 1;
}


//Lua Example: x,y = L_GetPosition()
int L_GetPosition( lua_State* luaVM )
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getX() );
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getY() );
	}
	else
	{
		lua_pushnumber( luaVM, 0 );
		lua_pushnumber( luaVM, 0 );
	}

	return 2;
}

//Lua Example: x,y = L_GetOffsetPosition()
int L_GetOffsetPosition( lua_State* luaVM )
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getXOffset() );
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getYOffset() );
	}
	else
	{
		lua_pushnumber( luaVM, 0 );
		lua_pushnumber( luaVM, 0 );
	}

	return 2;
}


//Lua Example: width = L_GetScreenWidth()
int L_GetScreenWidth( lua_State* luaVM )
{
	lua_pushnumber( luaVM, SCREEN_WIDTH);

	return 1;
}

//Lua Example: height = L_GetScreenHeight()
int L_GetScreenHeight( lua_State* luaVM )
{
	lua_pushnumber( luaVM, SCREEN_HEIGHT);

	return 1;
}

//Lua Example: width, height = L_GetScreenDim()
int L_GetScreenDim( lua_State* luaVM )
{
	lua_pushnumber( luaVM, SCREEN_WIDTH);
	lua_pushnumber( luaVM, SCREEN_HEIGHT);

	return 2;
}

//Lua Example: speed = L_GetSpeed()
int L_GetSpeed(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getSpeed() );
	}

	return 1;
}

//Lua Example: angle = L_GetFaceAngle()
int L_GetFaceAngle(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getFaceAngle() );
	}

	return 1;
}

//Lua Example: forwardThrust, reverseThrust, turnLeft, turnRight = L_GetPlayerNavVars()
int L_GetPlayerNavVars(lua_State* luaVM)
{
	lua_pushboolean( luaVM, g_game->PlanetSurfaceHolder->activeVessel->ForwardThrust() );
	lua_pushboolean( luaVM, g_game->PlanetSurfaceHolder->activeVessel->ReverseThrust() );
	lua_pushboolean( luaVM, g_game->PlanetSurfaceHolder->activeVessel->TurnLeft() );
	lua_pushboolean( luaVM, g_game->PlanetSurfaceHolder->activeVessel->TurnRight() );

	return 4;
}

//Lua Example: scale = L_GetScale()
int L_GetScale(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getScale() );
	}

	return 1;
}

//Lua Example: counter1, counter2, counter3 = L_SetCounters()
int L_GetCounters(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getCounter1() );
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getCounter2() );
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getCounter3() );
	}

	return 3;
}

//Lua Example: threshold1, threshold2, threshold3 = L_SetThresholds()
int L_GetThresholds(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getThreshold1() );
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getThreshold2() );
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getThreshold3() );
	}

	return 3;
}

//Lua Example: if (L_IsPlayerMoving() == true)
int L_IsPlayerMoving(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->activeVessel->getSpeed() != 0)
	{
		lua_pushboolean( luaVM, true );
	}
	else
	{
		lua_pushboolean( luaVM, false );
	}

	return 1;
}

//Lua Example: id = L_GetItemID()
int L_GetItemID(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getID() );
	}
	else
		g_game->fatalerror("GetItemID: psObjectHolder is null!");

	return 1;
}

//Lua Example: state = L_GetState()
int L_GetState(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getState() );
	}

	return 1;
}

//Lua Example: mode = L_GetVesselMode()
int L_GetVesselMode(lua_State* luaVM)
{
	lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->vessel_mode );

	return 1;
}

//Lua Example: scanned = L_IsScanned()
int L_IsScanned(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushboolean( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->IsScanned() );
	}

	return 1;
}

//Lua Example: name = L_GetName()
int L_GetName(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushstring( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getName().c_str() );
	}

	return 1;
}

//Lua Example: worth = L_GetValue()
int L_GetValue(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getValue() );
	}

	return 1;
}

//Lua Example: damage = L_GetDamage()
int L_GetDamage(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getDamage() );
	}

	return 1;
}

//Lua Example: isBlackMarket = L_IsBlackMarketItem()
int L_IsBlackMarketItem(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushboolean( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->IsBlackMarketItem() );
	}

	return 1;
}

//Lua Example: shipRepairMetal = L_IsShipRepairMetal()
int L_IsShipRepairMetal(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushboolean( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->IsShipRepairMetal() );
	}

	return 1;
}

//Lua Example: isAlive = L_IsAlive()
int L_IsAlive(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushboolean( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->isAlive() );
	}

	return 1;
}

//Lua Example: halfwidth = L_GetColHalfWidth()
int L_GetColHalfWidth(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getColHalfWidth() );
	}

	return 1;
}

//Lua Example: halfheight = L_GetColHalfHeight()
int L_GetColHalfHeight(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getColHalfHeight() );
	}

	return 1;
}

//Lua Example: id = L_GetID()
int L_GetID(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		for (int i=0; i < (int) g_game->PlanetSurfaceHolder->surfaceObjects.size(); ++i)
		{
			if (g_game->PlanetSurfaceHolder->psObjectHolder == g_game->PlanetSurfaceHolder->surfaceObjects[i])
			{
				lua_pushnumber( luaVM, i);
				break;
			}
		}
	}

	return 1;
}

//Lua Example: scriptName = L_GetScriptName()
int L_GetScriptName(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushstring( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->GetScriptName().c_str() );
	}

	return 1;
}


//Lua Example: health = L_GetHealth()
int L_GetHealth(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getHealth() );
	}

	return 1;
}

//Lua Example: health = L_GetMaxHealth()
int L_GetMaxHealth(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getMaxHealth() );
	}

	return 1;
}

//Lua Example: stuncount = L_GetStunCount()
int L_GetStunCount(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getStunCount() );
	}

	return 1;
}

//Lua Example: size = L_GetItemSize()
int L_GetItemSize(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getSize() );
	}

	return 1;
}

//Lua Example: id = L_GetSelectedPSOid()
int L_GetSelectedPSOid(lua_State* luaVM)
{
	for (int i=0; i < (int) g_game->PlanetSurfaceHolder->surfaceObjects.size(); ++i)
	{
		if (g_game->PlanetSurfaceHolder->selectedPSO == g_game->PlanetSurfaceHolder->surfaceObjects[i])
		{
			lua_pushnumber( luaVM, i);
			break;
		}
	}

	return 1;
}

//Lua Example: objectType = L_GetObjectType()
int L_GetObjectType(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getObjectType() );
	}

	return 1;
}

//Lua Example: danger = L_GetDanger()
int L_GetDanger(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getDangerLvl() );
	}

	return 1;
}


//Lua Example: color = L_GetMinimapColor()
int L_GetMinimapColor(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getMinimapColor() );
	}

	return 1;
}

//Lua Example: size = L_GetMinimapSize()
int L_GetMinimapSize(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		lua_pushnumber( luaVM, g_game->PlanetSurfaceHolder->psObjectHolder->getMinimapSize() );
	}

	return 1;
}

//Lua Example: name = L_GetDescription()
int L_GetDescription(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		string desc = g_game->PlanetSurfaceHolder->psObjectHolder->description;
		lua_pushstring( luaVM, desc.c_str() );
	}

	return 1;
}




//Lua Example: L_SetPosition(x,y)
int L_SetPosition(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setY(lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);

		g_game->PlanetSurfaceHolder->psObjectHolder->setX(lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetVelocity(velX,velY)
int L_SetVelocity(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setVelY(lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);

		g_game->PlanetSurfaceHolder->psObjectHolder->setVelX(lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetSpeed(speed)
int L_SetSpeed(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setSpeed(lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}
	return 0;
}

//Lua Example: L_SetFaceAngle(angle)
int L_SetFaceAngle(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setFaceAngle((float)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}
	return 0;
}

//Lua Example: L_SetAnimInfo(FrameWidth, FrameHeight, AnimColumns, TotalFrames, CurFrame)
int L_SetAnimInfo(lua_State* luaVM)
{
	g_game->PlanetSurfaceHolder->psObjectHolder->setCurrFrame((int)lua_tonumber(luaVM, -1));
	lua_pop(luaVM, 1);

	g_game->PlanetSurfaceHolder->psObjectHolder->setTotalFrames((int)lua_tonumber(luaVM, -1));
	lua_pop(luaVM, 1);

	g_game->PlanetSurfaceHolder->psObjectHolder->setAnimColumns((int)lua_tonumber(luaVM, -1));
	lua_pop(luaVM, 1);

	g_game->PlanetSurfaceHolder->psObjectHolder->setFrameHeight((int)lua_tonumber(luaVM, -1));
	lua_pop(luaVM, 1);

	g_game->PlanetSurfaceHolder->psObjectHolder->setFrameWidth((int)lua_tonumber(luaVM, -1));
	lua_pop(luaVM, 1);

	return 0;
}

//Lua Example: L_SetAngleOffset(angle)
int L_SetAngleOffset(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setAngleOffset((float)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetScale(angle)
int L_SetScale(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setScale(lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetCounters(counter1, counter2, counter3)
int L_SetCounters(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setCounter3((int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);

		g_game->PlanetSurfaceHolder->psObjectHolder->setCounter2((int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);

		g_game->PlanetSurfaceHolder->psObjectHolder->setCounter1((int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetThresholds(threshold1, threshold2, threshold3)
int L_SetThresholds(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setThreshold3((int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);

		g_game->PlanetSurfaceHolder->psObjectHolder->setThreshold2((int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);

		g_game->PlanetSurfaceHolder->psObjectHolder->setThreshold1((int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetState(state)
int L_SetState(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setState((int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_GetVesselMode(mode)
int L_SetVesselMode(lua_State* luaVM)
{
	g_game->PlanetSurfaceHolder->vessel_mode = (int)lua_tonumber(luaVM, -1);
	lua_pop(luaVM, 1);

	return 0;
}

//Lua Example: L_SetScanned(true)
int L_SetScanned(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setScanned( lua_toboolean(luaVM, -1) != 0);
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetDamage(damage)
int L_SetDamage(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setDamage(lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetAlive(isAlive)
int L_SetAlive(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setAlive(lua_toboolean(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}


//Lua Example: L_SetColHalfWidth(halfwidth)
int L_SetColHalfWidth(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setColHalfWidth( (int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetColHalfHeight(halfheight)
int L_SetColHalfHeight(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setColHalfHeight( (int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetScriptName(scriptName)
int L_SetScriptName(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setScriptName(lua_tostring(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetAlpha(true)
int L_SetAlpha(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setAlpha( lua_toboolean(luaVM, -1) != 0);
		lua_pop(luaVM, 1);
	}

	return 0;
}


//Lua Example: L_SetHealth(health)
int L_SetHealth(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setHealth( (int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetMaxHealth(health)
int L_SetMaxHealth(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setMaxHealth( (int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}


//Lua Example: L_SetStunCount(stuncount)
int L_SetStunCount(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setStunCount( (int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetObjectType(objectType)
int L_SetObjectType(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setObjectType( (int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetName("Justin")
int L_SetName(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setName(lua_tostring(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetMinimapColor(color)
int L_SetMinimapColor(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setMinimapColor( (int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetMinimapSize(size)
int L_SetMinimapSize(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->setMinimapSize( (int)lua_tonumber(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}

//Lua Example: L_SetNewAnimation("walk", 0, 4, 2)
int L_SetNewAnimation(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		int delay = (int)lua_tonumber(luaVM, -1);
		lua_pop(luaVM, 1);

		int endFrame = (int)lua_tonumber(luaVM, -1);
		lua_pop(luaVM, 1);

		int startFrame = (int)lua_tonumber(luaVM, -1);
		lua_pop(luaVM, 1);

		std::string name = lua_tostring(luaVM, -1);
		lua_pop(luaVM, 1);

		g_game->PlanetSurfaceHolder->psObjectHolder->AddAnimation(name, startFrame, endFrame, delay);
	}

	return 0;
}

//Lua Example: L_SetActiveAnimation("walk")
int L_SetActiveAnimation(lua_State* luaVM)
{
	if (g_game->PlanetSurfaceHolder->psObjectHolder != NULL)
	{
		g_game->PlanetSurfaceHolder->psObjectHolder->SetActiveAnimation(lua_tostring(luaVM, -1));
		lua_pop(luaVM, 1);
	}

	return 0;
}



//Lua Example: L_PlaySound("stunner")
int L_PlaySound(lua_State* luaVM)
{
	std::string sample = lua_tostring(luaVM, -1);
	if (g_game->audioSystem->SampleExists(sample))
		g_game->audioSystem->Play(sample);
	else
		TRACE("L_PlaySound: [ERROR] sample %s was not previously loaded\n", sample.c_str());
	lua_pop(luaVM, 1);

	return 0;
}

//Lua Example: L_PlayLoopingSound("TVmove")
int L_PlayLoopingSound(lua_State* luaVM)
{
	std::string sample = lua_tostring(luaVM, -1);
	if (g_game->audioSystem->SampleExists(sample))
		g_game->audioSystem->Play(sample, true);
	else
		TRACE("L_PlayLoopingSound: [ERROR] sample %s was not previously loaded\n", sample.c_str());
	lua_pop(luaVM, 1);

	return 0;
}

//Lua Example: L_StopSound("TVmove")
int L_StopSound(lua_State* luaVM)
{
	std::string sample = lua_tostring(luaVM, -1);
	if (g_game->audioSystem->SampleExists(sample))
		g_game->audioSystem->Stop(sample);
	else
		TRACE("L_StopSound: [ERROR] sample %s was not previously loaded\n", sample.c_str());
	lua_pop(luaVM, 1);

	return 0;
}
#pragma endregion
