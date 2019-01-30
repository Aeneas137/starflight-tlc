/*
	STARFLIGHT - THE LOST COLONY
	ModuleAuxiliaryDisplay.cpp
	Author: J.Harbour
	Date: Jan 2008

	Engineer & Doctor: Keith Patch

	General status displayed for all crew:
		* DATE
		* DAMAGE
		* CARGO
		* ENERGY
		* SHIELDS
		* WEAPONS
		* CREW NAME

	Additional status info for each crew:

	Captain:
		* SHIP NAME
		* SHIP TYPE
		* CREDITS

	Science:

	Navigation:
		* COORD
		* REGION
		* SPEED
		* MINIMAP

	Tactical:
		* SHIELD CLASS
		* LASER CLASS
		* MISSILE CLASS

	Engineering:
		* ENGINE CLASS

	Communications:

	Medical:


*/

#include <sstream>
#include "env.h"
#include <allegro.h>
#include "Util.h"
#include "GameState.h"
#include "ModeMgr.h"
#include "Game.h"
#include "Sprite.h"
#include "AudioSystem.h"
#include "Events.h"
#include "DataMgr.h"
#include "Flux.h"
#include "Script.h"
#include "ModuleAuxiliaryDisplay.h"
#include "Button.h"

using namespace std;

#define AUX_ICON_FREELANCE_TGA           0        /* BMP  */
#define AUX_ICON_MILITARY_TGA            1        /* BMP  */
#define AUX_ICON_SCIENCE_TGA             2        /* BMP  */
//#define GUI_AUX_BMP                      3        /* BMP  */
#define HIGH_RES_SHIP_FREELANCE_TGA      4        /* BMP  */
#define HIGH_RES_SHIP_MILITARY_TGA       5        /* BMP  */
#define HIGH_RES_SHIP_SCIENCE_TGA        6        /* BMP  */
#define IS_TILES_SMALL_BMP               7        /* BMP  */


DATAFILE *auxdata;


ModuleAuxiliaryDisplay::ModuleAuxiliaryDisplay() {}
ModuleAuxiliaryDisplay::~ModuleAuxiliaryDisplay(){}
void ModuleAuxiliaryDisplay::OnKeyPressed(int keyCode){}
void ModuleAuxiliaryDisplay::OnKeyPress( int keyCode ){}
void ModuleAuxiliaryDisplay::OnKeyReleased(int keyCode){}
void ModuleAuxiliaryDisplay::OnMouseMove(int x, int y){}
void ModuleAuxiliaryDisplay::OnMouseClick(int button, int x, int y){}
void ModuleAuxiliaryDisplay::OnMousePressed(int button, int x, int y){}
void ModuleAuxiliaryDisplay::OnMouseReleased(int button, int x, int y){}
void ModuleAuxiliaryDisplay::OnMouseWheelUp(int x, int y){}
void ModuleAuxiliaryDisplay::OnMouseWheelDown(int x, int y){}

void ModuleAuxiliaryDisplay::OnEvent(Event *event)
{
	switch(event->getEventType())
	{
		case CARGO_EVENT_UPDATE:
			updateCargoFillPercent();
			break;
		default:
			break;
	}
}

void ModuleAuxiliaryDisplay::Close()
{
	delete scroller;

    destroy_bitmap(img_aux);

	//unload the data file
	unload_datafile(auxdata);
	auxdata = NULL;

}

bool ModuleAuxiliaryDisplay::Init()
{
	TRACE("  ModuleAuxiliaryDisplay Initialize\n");

	//load the datafile
	auxdata = load_datafile("data/auxiliary/auxiliary.dat");
	if (!auxdata) {
		g_game->message("Auxiliary: Error loading datafile");
		return false;
	}

    //create a new color
	HEADING_COLOR = makecol(0,168,168);


	canvas = g_game->GetBackBuffer();

	//get aux display location
	gax = (int)g_game->getGlobalNumber("GUI_AUX_POS_X");
	gay = (int)g_game->getGlobalNumber("GUI_AUX_POS_Y");

	//get position of screen within gui
	asx = (int)g_game->getGlobalNumber("AUX_SCREEN_X");
	asy = (int)g_game->getGlobalNumber("AUX_SCREEN_Y");
	asw = (int)g_game->getGlobalNumber("AUX_SCREEN_WIDTH");
	ash = (int)g_game->getGlobalNumber("AUX_SCREEN_HEIGHT");


	//load the aux gui
	img_aux = (BITMAP*)load_bitmap("data/spacetravel/GUI_AUX.BMP",NULL);
	if (!img_aux) {
		g_game->message("Aux: Error loading gui_aux");
		return false;
	}

	//load ship status icon
	ship_icon_image = NULL;
	switch(g_game->gameState->getProfession()){
		case PROFESSION_FREELANCE:
			ship_icon_image = (BITMAP*)auxdata[AUX_ICON_FREELANCE_TGA].dat;
			if (!ship_icon_image) {
				g_game->message("Aux: error loading ship image");
				return false;
			}
			break;
		case PROFESSION_MILITARY:
			ship_icon_image = (BITMAP*)auxdata[AUX_ICON_MILITARY_TGA].dat;
			if (!ship_icon_image) {
				g_game->message("Aux: error loading ship image");
				return false;
			}
			break;
		case PROFESSION_SCIENTIFIC:
			ship_icon_image = (BITMAP*)auxdata[AUX_ICON_SCIENCE_TGA].dat;
			if (!ship_icon_image) {
				g_game->message("Aux: error loading ship image");
				return false;
			}
			break;

		default: ASSERT(0);
	}
	if(ship_icon_image == NULL){return false;}

	//create ship status icon sprite
	ship_icon_sprite = new Sprite();
	ship_icon_sprite->setImage(ship_icon_image);

	//load scroller tiles
	/*tiles_image = (BITMAP*)auxdata[IS_TILES_SMALL_BMP].dat;
	if (!tiles_image) {
		g_game->message("Aux: Error loading is_tiles_small");
		return false;
	}*/


	init_nav();

	updateCargoFillPercent();

	return true;
}

void ModuleAuxiliaryDisplay::updateCargoFillPercent()
{
	double totalSpace = g_game->gameState->m_ship.getTotalSpace();
	double occupiedSpace = g_game->gameState->m_ship.getOccupiedSpace();
	cargoFillPercent = (int) (occupiedSpace / totalSpace * 100.0);
}

// The mini-scroller displayed in the navigator's aux display
void ModuleAuxiliaryDisplay::init_nav()
{
	scroller = new TileScroller();
	scroller->setTileSize(16,16);
	scroller->setTileImageColumns(5);
	scroller->setTileImageRows(2);
	scroller->setRegionSize(2500,2200);

	if (!scroller->createScrollBuffer(asw + scroller->getTileWidth(), ash + scroller->getTileHeight())) {
		g_game->message("ModuleAuxiliaryDisplay::Init: Error creating scroll buffer");
		return;
	}
	//initialize mini tile scroller for nav
	scroller->setTileImage( (BITMAP*)auxdata[IS_TILES_SMALL_BMP].dat );
	scroller->setScrollPosition(g_game->gameState->player->posHyperspace);

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


void ModuleAuxiliaryDisplay::updateAll()
{
	std::ostringstream os;
	Ship ship = g_game->gameState->getShip();
	Stardate date = g_game->gameState->stardate;
	int x = asx,y = asy;

	if(g_game->gameState->getCurrentSelectedOfficer() != OFFICER_MEDICAL && g_game->gameState->getCurrentSelectedOfficer() != OFFICER_ENGINEER)
    {
		//stardate
		g_game->Print20(canvas, x, y, "DATE:", HEADING_COLOR);
		g_game->Print20(canvas, x+60, y, date.GetFullDateString(), SKYBLUE);

		//damage status
		os.str(""); y+=20;
		g_game->Print20(canvas, x, y, "DAMAGE:", HEADING_COLOR);
		os.str("");
		int damage = 0; //ship.getHullIntegrity();
		int damage_color = SKYBLUE;
		if (damage > 66) {
			os << "HEAVY";
			damage_color = makecol(240,0,0); //red
		}
		else if (damage > 33) {
			os << "MODERATE";
			damage_color = makecol(240,240,0); //yellow
		}
		else if (damage > 0) {
			os << "LIGHT";
			damage_color = makecol(0,200,0); //green
		}
		else {
			os << "NONE";
		}
		g_game->Print20(canvas, x+75, y, os.str(), damage_color);

		//cargo status
		os.str(""); x+=75; y+=20;
		g_game->Print20(canvas, x, y, "CARGO:", HEADING_COLOR);
		os << cargoFillPercent << "%%";
		g_game->Print20(canvas, x+72, y, os.str(), SKYBLUE);

		//fuel status
		os.str(""); y+=20;
		g_game->Print20(canvas, x, y, "ENERGY:", HEADING_COLOR);
        //int fuel = g_game->gameState->m_ship.getFuel() * 100.0;
        int fuel = g_game->gameState->m_ship.getEnduriumOnBoard();
        os << fuel;
		g_game->Print20(canvas, x+72, y, os.str(), SKYBLUE);

		//shield status
		os.str(""); y+=20;
		g_game->Print20(canvas, x, y, "SHLDS:", HEADING_COLOR);
		if (g_game->gameState->getShieldStatus())
			os << "RAISED";
		else
			os << "LOWERED";
		g_game->Print20(canvas, x+72, y, os.str(), SKYBLUE);

		//weapon status
		os.str(""); y+=20;
		g_game->Print20(canvas, x, y, "WEAP:", HEADING_COLOR);
		if (g_game->gameState->getWeaponStatus())
			os << "ARMED";
		else
			os << "UNARMED";
		g_game->Print20(canvas, x+72, y, os.str(), SKYBLUE);

		//ship icon image
		ship_icon_sprite->setPos(asx+18,asy+45);
		ship_icon_sprite->drawframe(g_game->GetBackBuffer(),true);

		//shield bar is 48 pixels tall
		int shield = ship.getShieldClass();
		rectfill(g_game->GetBackBuffer(),asx+2,asy+95,asx+12,asy+95-shield*8,RED);
		rect(g_game->GetBackBuffer(),asx+2,asy+95,asx+12,asy+95-48,STEEL);
		g_game->Print18(canvas,asx+2,asy+96,"S",STEEL);

		//armor bar is 48 pixels tall
		int armor = ship.getArmorClass();
		rectfill(g_game->GetBackBuffer(),asx+56,asy+95,asx+66,asy+95-armor*8,YELLOW);
		rect(g_game->GetBackBuffer(),asx+56,asy+95,asx+66,asy+95-48,STEEL);
		g_game->Print18(canvas,asx+56,asy+96,"A",STEEL);

	}

}

void ModuleAuxiliaryDisplay::updateCap()
{
	int HEADING_COLOR = makecol(0,168,168);
	Ship ship = g_game->gameState->getShip();
	ProfessionType profession;
	std::ostringstream os;
	int x = asx,y = asy+130;

	//captain's name
    g_game->Print18(canvas,x,y, "CAPTAIN:", HEADING_COLOR);
    g_game->Print18(canvas, x+75, y, g_game->gameState->officerCap->getLastName(), SKYBLUE);

	//ship name
	os.str(""); y+=20;
    g_game->Print18(canvas,x,y,"SHIP:", HEADING_COLOR);
	g_game->Print18(canvas, x+75, y, "MSS " + ship.getName(), SKYBLUE);

	//ship type
	os.str(""); y += 20;
	g_game->Print18(canvas, x, y, "TYPE:", HEADING_COLOR);
	profession = g_game->gameState->getProfession();
	switch(profession)
	{
		case PROFESSION_SCIENTIFIC:	os << "SCIENTIFIC";	break;
		case PROFESSION_FREELANCE:	os << "FREELANCE"; break;
		case PROFESSION_MILITARY:	os << "MILITARY"; break;
		default:					os << "UNKNOWN"; break;
	}
	g_game->Print18(canvas, x+75, y, os.str(), SKYBLUE);

	//credits
	os.str(""); y+=20;
	g_game->Print18(canvas, x, y, "CREDITS:", HEADING_COLOR);
	os << g_game->gameState->getCredits();
	g_game->Print18(canvas, x+75, y, os.str(), SKYBLUE);



}

void ModuleAuxiliaryDisplay::updateSci()
{
	std::ostringstream os;
	int x = asx,y = asy+130;

	os << "Sci Off. " << g_game->gameState->officerSci->getLastName();
	g_game->Print18(canvas, x, y, os.str(), SKYBLUE);
}

void ModuleAuxiliaryDisplay::updateNav()
{
	int HEADING_COLOR = makecol(0,168,168);
	ostringstream os;
	int x = asx,y = asy+130;
	char s[255];

	double galacticx = g_game->gameState->player->posHyperspace.x;
	double galacticy = g_game->gameState->player->posHyperspace.y;

	//officer name
	os << "Nav Off. " << g_game->gameState->officerNav->getLastName();
	g_game->Print18(canvas, x, y, os.str(), SKYBLUE);

	//galactic location
	y+=18;
	g_game->Print18(canvas, x, y, "COORD:", HEADING_COLOR);
	// offset of 4 tiles on the x axis and 2 tiles on the y axis
	sprintf(s,"%.0f %.0f", galacticx/128 +4, galacticy/128 +2);
	g_game->Print20(canvas, x+66, y, s, SKYBLUE);

	//speed status
	y+=18;
	g_game->Print18(canvas, x, y, "SPEED:", HEADING_COLOR);
	sprintf(s,"%.1f", g_game->gameState->player->getCurrentSpeed());
	g_game->Print20(canvas, x+66, y, s, SKYBLUE);

	//galactic region (alien space)
	AlienRaces race = g_game->gameState->player->getGalacticRegion();
	string race_str = g_game->gameState->player->getAlienRaceName( race );
	if (race != ALIEN_NONE)
	{
		y+=18;
		g_game->Print18(canvas, x, y, "REGION:", HEADING_COLOR);
		g_game->Print18(canvas, x+66, y, race_str, SKYBLUE);
	}


	scroller->setScrollPosition(galacticx/8 + 24, galacticy/8 - 8);
	scroller->updateScrollBuffer();
	scroller->drawScrollWindow(g_game->GetBackBuffer(), asx+145, asy+150, 80, 75);
}

void ModuleAuxiliaryDisplay::PrintSystemStatus(int x,int y,int value)
{
    int color, x2;
    string status;
	if(value <= 0){
		color = BLACK;
		status = "NONE";
		x2 = x + 200;
	}else if(value < 25){
		color = RED2;
		status = "CRITICAL";
		x2 = x + 169;
	}else if(value < 50){
		color = YELLOW2;
		status = "DAMAGED";
		x2 = x + 163;
	}else{
		color = GREEN2;
		status = "FUNCTIONAL";
		x2 = x + 143;
	}
    ostringstream os;
	os << status;
	g_game->Print18(canvas, x2, y, os.str(), color);

}

void ModuleAuxiliaryDisplay::updateEng()
{
	ostringstream os;
	int x = asx, y = asy;
	std::string status = "";

	Ship ship = g_game->gameState->getShip();

	//officer name
	os << "Eng Off. " << g_game->gameState->officerEng->getLastName();
	g_game->Print20(canvas, x, y, os.str(), SKYBLUE);


	y+=40;
	g_game->Print18(canvas, x, y, "HULL", SKYBLUE);
	PrintSystemStatus(0,y,ship.getHullIntegrity());

	os.str(""); y+=20;
	os << "ENGINE " << ship.getEngineClassString();
	g_game->Print18(canvas, x, y, os.str(), SKYBLUE);
	PrintSystemStatus(0,y,ship.getEngineIntegrity());

	os.str(""); y+=20;
	os << "ARMOR " << ship.getArmorClassString();
	g_game->Print18(canvas, x, y, os.str(), SKYBLUE);
	PrintSystemStatus(0,y,ship.getArmorIntegrity()/ship.getMaxArmorIntegrity()*100.0);

	os.str(""); y+=20;
	os << "SHIELD " << ship.getShieldClassString();
	g_game->Print18(canvas, x, y, os.str(), SKYBLUE);
    PrintSystemStatus(0,y,ship.getShieldIntegrity());

	os.str(""); y+=20;
	os << "LASER " << ship.getLaserClassString();
	g_game->Print18(canvas, x, y, os.str(), SKYBLUE);
    PrintSystemStatus(0,y,ship.getLaserIntegrity());

	os.str(""); y+=20;
	os << "MISSILE " << ship.getMissileLauncherClassString();
	g_game->Print18(canvas, x, y, os.str(), SKYBLUE);
    PrintSystemStatus(0,y,ship.getMissileLauncherIntegrity());
}

void ModuleAuxiliaryDisplay::updateCom()
{
	std::ostringstream os;
	int x = asx,y = asy+130;

	//officer name
	os << "Comm Off. " << g_game->gameState->officerCom->getLastName();
	g_game->Print20(canvas, x, y, os.str(), SKYBLUE);

}

void ModuleAuxiliaryDisplay::updateTac()
{
	std::ostringstream os;
	Ship ship = g_game->gameState->getShip();
	int x = asx,y = asy+130;

	//officer name
	os << "Tac Off. " << g_game->gameState->officerTac->getLastName();
	g_game->Print20(canvas, x, y, os.str(), SKYBLUE);

	y += 18;
	g_game->Print18(canvas, x, y, "ARMOR:", HEADING_COLOR);
    g_game->Print18(canvas, x+72, y, ship.getArmorClassString(), SKYBLUE);

	y += 18;
	g_game->Print18(canvas, x, y, "SHIELD:", HEADING_COLOR);
    g_game->Print18(canvas, x+72, y, ship.getShieldClassString(), SKYBLUE);

	y += 18;
	g_game->Print18(canvas, x, y, "LASER: ", HEADING_COLOR);
    g_game->Print18(canvas, x+72, y, ship.getLaserClassString(), SKYBLUE);

	y += 18;
	g_game->Print18(canvas, x, y, "MISSILE: ", HEADING_COLOR);
    g_game->Print18(canvas, x+72, y, ship.getMissileLauncherClassString(), SKYBLUE);
}

void ModuleAuxiliaryDisplay::updateMed()
{
	int y = 525, x = 15;

	//officer name
	string doctor = "Med Off. " + g_game->gameState->officerDoc->getLastName();
	g_game->Print18(canvas, x, y, doctor, SKYBLUE);

    y += 40;
	medical_display(g_game->gameState->officerCap, x, y, "CAP. ");

	y += 20;
	medical_display(g_game->gameState->officerSci, x, y, "SCI. ");

	y += 20;
	medical_display(g_game->gameState->officerNav, x, y, "NAV. ");

	y += 20;
	medical_display(g_game->gameState->officerTac, x, y, "TAC. ");

	y += 20;
	medical_display(g_game->gameState->officerCom, x, y, "COM. ");

	y += 20;
	medical_display(g_game->gameState->officerEng, x, y, "ENG. ");

	y += 20;
	medical_display(g_game->gameState->officerDoc, x, y, "MED. ");
}

void ModuleAuxiliaryDisplay::medical_display(Officer* officer_data, int x, int y, std::string additional_data){
	int text_color = 0;
	std::string status = "";
	int x2 = 0;
	std::ostringstream os;
	if(officer_data->attributes.getVitality() <= 0){
		text_color = BLACK;
		status = "DEAD";
		x2 = 200;
	}else if(officer_data->attributes.getVitality() < 25){
		text_color = RED2;
		status = "CRITICAL";
		x2 = 175;
	}else if(officer_data->attributes.getVitality() < 50){
		text_color = YELLOW2;
		status = "INJURED";
		x2 = 175;
	}else{
		text_color = GREEN2;
		status = "HEALTHY";
		x2 = 170;
	}

	//name and rank
	os << additional_data << officer_data->getLastName();
	g_game->Print18(canvas, x, y, os.str(), SKYBLUE);

	os.str(""); //clear

	//medical status
	os << status;
	g_game->Print18(canvas, x2, y, os.str(), text_color);
}

void ModuleAuxiliaryDisplay::updateCrew()
{
	switch(g_game->gameState->getCurrentSelectedOfficer())
	{
		case OFFICER_CAPTAIN:		updateCap(); break;
		case OFFICER_SCIENCE:		updateSci(); break;
		case OFFICER_NAVIGATION:	updateNav(); break;
		case OFFICER_ENGINEER:		updateEng(); break;
		case OFFICER_COMMUNICATION:	updateCom(); break;
		case OFFICER_MEDICAL:		updateMed(); break;
		case OFFICER_TACTICAL:		updateTac(); break;
		default:
			//this should never happen, so we want a fatal if it happens to find the bug
			TRACE("  [AuxiliaryDisplay] ERROR: No officer selected in control panel.");
	}
}

void ModuleAuxiliaryDisplay::Update() {}

void ModuleAuxiliaryDisplay::DrawBackground()
{
	// draw the aux gui
	masked_blit(img_aux, canvas, 0, 0, gax, gay, img_aux->w, img_aux->h);
}

void ModuleAuxiliaryDisplay::DrawContent()
{
	//clear the "lcd" portion of the screen with darkgreen
	static int lcdcolor = makecol(20,40,0);
	rectfill(canvas, asx, asy, asx+asw, asy+ash, lcdcolor);

	updateAll();
	updateCrew();
}

void ModuleAuxiliaryDisplay::Draw()
{
	//draw the aux gui
	DrawBackground();

	//based on current module, fill aux display with content
	std::string module = g_game->gameState->getCurrentModule();
	if (module == MODULE_HYPERSPACE) 
    {
		DrawContent();
    }
	else if (module == MODULE_INTERPLANETARY)
	{
	}
	else if (module == MODULE_ORBIT)
	{
	}
	else if (module == MODULE_SURFACE)
	{
	}
	else if (module == MODULE_ENCOUNTER)
	{
	}

}
