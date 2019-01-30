/*

#include "env.h"
#include <allegro.h>
#include "Module.h"
#include "GameState.h"
#include "Button.h"
#include "ScrollBox.h"
#include "EventMgr.h"
#include "Label.h"
#include "Game.h"
#include "DataMgr.h"
#include "ModeMgr.h"
using namespace std;

void launchDebugEncounter(AlienRaces alien, int size)
{

	//init the alien fleet
	gameState->player->setGalacticRegion( alien );
	gameState->player->setAlienFleetSize( size );

	//give player some gear if ship is weak
	Ship ship = g_game->gameState->getShip();
	if (ship.getShieldClass() == 0) {
		ship.setShieldClass( 1 );
		ship.setShieldIntegrity( 100 );
	}
	if (ship.getArmorClass() == 0) {
		ship.setArmorClass( 1 );
		ship.setArmorIntegrity( 100 );
	}
	if (ship.getLaserClass() == 0) {
		ship.setLaserClass( 1 );
		ship.setLaserIntegrity( 100 );
	}
	if (ship.getMissileLauncherClass() == 0) {
		ship.setMissileLauncherClass( 1 );
		ship.setMissileLauncherIntegrity( 100 );
	}

	//launch encounter
	if (!modeMgr->LoadModule( MODULE_ENCOUNTER ))
	{
		fatalerror("Error loading encounter module: " + gameState->player->getAlienRaceName(alien));
		m_keepRunning = false;
	}
}

void blah()
{
	//load default savegame file from position #1
	//string filename = "savegame-0.dat";
	//gameState = gameState->LoadGame( filename );

 
	//when holding LEFT CONTROL key, these debug keys are checked
	if (key[KEY_LCONTROL])
	{
		if (key[KEY_PLUS_PAD]) {
			g_game->gameState->m_credits += 1000;
		}
		else if (key[KEY_MINUS_PAD]) {
			g_game->gameState->m_ship.setHullIntegrity(50);
			g_game->gameState->m_ship.setArmorIntegrity(50);
			g_game->gameState->m_ship.setShieldIntegrity(50);
			g_game->gameState->m_ship.setEngineIntegrity(50);
			g_game->gameState->m_ship.setLaserIntegrity(50);
			g_game->gameState->m_ship.setMissileLauncherIntegrity(50);
		}

		else if (key[KEY_F1]) {
			launchDebugEncounter( ALIEN_ELOWAN, 5 );
		}
		else if (key[KEY_F2]) {
			//spemin **
		}
		else if (key[KEY_F3]) {
			//thrynn **
		}
		else if (key[KEY_F4]) {
			//barzhon **
		}
		else if (key[KEY_F5]) {
			//nyssian **
		}
		else if (key[KEY_F6]) {
			//tafel
		}
		else if (key[KEY_F7]) {
			//minex
		}
		else if (key[KEY_F8]) {
			//coalition **
		}
		else if (key[KEY_F9]) {
			//pirate (no img)
		}
		else if (key[KEY_F10]) {
		}
		else if (key[KEY_F11]) {
		}
		else if (key[KEY_F12]) {
		}


	}
}

*/
