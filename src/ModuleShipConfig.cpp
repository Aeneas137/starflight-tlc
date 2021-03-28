/*
	STARFLIGHT - THE LOST COLONY
	ModuleStarport.cpp - Handles Starport activity
	Author: Scott Idler
	Date: June 29, 2007

	This module is the common starport area, where the user gains access to the
	areas where he can create his character, customize his ship, hire a crew,
	go to the bank, trade goods and receive orders.
*/

#include "env.h"
#include "ModuleShipConfig.h"
#include "AudioSystem.h"
#include "Game.h"
#include "Events.h"
#include "ModeMgr.h"
#include "DataMgr.h"
#include "QuestMgr.h"
#include "Util.h"
using namespace std;

#define FREELANCE_TGA                    0        /* BMP  */
#define MILITARY_TGA                     1        /* BMP  */
#define SCIENCE_TGA                      2        /* BMP  */
#define SHIPCONFIG_BMP                   3        /* BMP  */
#define SHIPCONFIG_BTN_DEACTIVE_BMP      4        /* BMP  */
#define SHIPCONFIG_BTN_NORM_BMP          5        /* BMP  */
#define SHIPCONFIG_BTN_OVER_BMP          6        /* BMP  */
#define SHIPCONFIG_CURSOR0_BMP           7        /* BMP  */


DATAFILE *scdata;


#define SHIPNAME_MAXLEN 20

ModuleShipConfig::ModuleShipConfig(void)
{
	//fontPtr = NULL;
	//shipImage = NULL;
	//shipConfig = NULL;
}

//Init is a good place to load resources
bool ModuleShipConfig::Init()
{
	TRACE("  ShipConfig Initialize\n");
	
	//load the datafile
	scdata = load_datafile("data/shipconfig/shipconfig.dat");
	if (!scdata) {
		g_game->message("ShipConfig: Error loading datafile");
		return false;
	}

	inputName = false;

	//create button images
	BITMAP *btnNorm, *btnOver, *btnDeact;
	btnNorm = (BITMAP*)scdata[SHIPCONFIG_BTN_NORM_BMP].dat;
	btnOver = (BITMAP*)scdata[SHIPCONFIG_BTN_OVER_BMP].dat;
	btnDeact = (BITMAP*)scdata[SHIPCONFIG_BTN_DEACTIVE_BMP].dat;
	if (!btnNorm || !btnOver || !btnDeact) {
		g_game->message("Error loading ship config images");
		return false;
	}

	//initialize array of button ptrs
	for(int i=0; i<NUMBER_OF_BUTTONS; ++i)
	{
		if(i < NUMBER_OF_BUTTONS)
		{
			buttons[i] = new Button(btnNorm, btnOver, btnDeact, 
				BUTTON_X_START, BUTTON_Y_START+i*(BUTTON_HEIGHT+PIXEL_BUFFER), 0, 0, g_game->font32, "def", makecol(0,255,0));
		}
		if(buttons[i])
		{
			if( !buttons[i]->IsInitialized() ) 
				return false;
		}
		else
			return false;
	}

	//setup up the pathing
	menuPath.clear();
	Event e(ModuleEntry);
	g_game->modeMgr->BroadcastEvent(&e);

	//load background image
	shipConfig = (BITMAP*)scdata[SHIPCONFIG_BMP].dat;
	if (!shipConfig) {
		g_game->message("ShipConfig: Error loading background");
		return false;
	}

	//load ship image
	switch(g_game->gameState->getProfession()) {
		case PROFESSION_FREELANCE:	shipImage = (BITMAP*)scdata[FREELANCE_TGA].dat;	break;
		case PROFESSION_MILITARY:	shipImage = (BITMAP*)scdata[MILITARY_TGA].dat; break;
		case PROFESSION_SCIENTIFIC:	shipImage = (BITMAP*)scdata[SCIENCE_TGA].dat; break;
		default:
			TRACE("***ERROR: ShipConfig: Player's profession is invalid.");
	}


	//load audio files
	m_sndClick = g_game->audioSystem->Load("data/shipconfig/click.ogg");
	if (!m_sndClick) {
		g_game->message("ShipConfig: Error loading click.ogg");
		return false;
	}
	m_sndErr = g_game->audioSystem->Load("data/shipconfig/error.ogg");
	if (!m_sndErr) {
		g_game->message("ShipConfig: Error loading error.ogg");
		return false;
	}
	m_cursor = (BITMAP*)scdata[SHIPCONFIG_CURSOR0_BMP].dat;
	if (m_cursor == NULL) {
		g_game->message("Error loading cursor");
		return false;
	}



	//tell questmgr that this module has been entered
	g_game->questMgr->raiseEvent(22);

	return true;
}

ModuleShipConfig::~ModuleShipConfig(void) {}
void ModuleShipConfig::OnKeyPress(int keyCode)		{ }
void ModuleShipConfig::OnKeyPressed(int keyCode)
{
	if (inputName)
	{
		bool playKeySnd = false;
		bool playErrSnd = false;

		if (((keyCode >= KEY_A) && (keyCode <= KEY_9_PAD)) || (keyCode == KEY_SPACE))
		{
		if (shipName.size() < SHIPNAME_MAXLEN)
		{
			char c = (char)scancode_to_ascii(keyCode);

			if ((key[KEY_LSHIFT] || key[KEY_RSHIFT]) && (keyCode < KEY_0) && (keyCode != KEY_SPACE))
			{
				c -= 32;
			}

			shipName.push_back(c);

			playKeySnd = true;
		}
		else
			playErrSnd = true;
		}
		else if (keyCode == KEY_BACKSPACE)
		{
		if (shipName.size() > 0)
		{
			shipName.erase(--(shipName.end()));

			playKeySnd = true;
		}
		else
			playErrSnd = true;
		}

		if (playKeySnd)
		{		
			g_game->audioSystem->Play(m_sndClick);
		}

		if (playErrSnd)
		{		
			g_game->audioSystem->Play(m_sndErr); 
		}

	}
}
void ModuleShipConfig::OnKeyReleased(int keyCode){}
void ModuleShipConfig::OnMouseMove(int x, int y)
{ 
	for(int i=0; i<buttonsActive; ++i)
		buttons[i]->OnMouseMove(x, y);
}
void ModuleShipConfig::OnMouseClick(int button, int x, int y)		{ }
void ModuleShipConfig::OnMousePressed(int button, int x, int y)		{ }
void ModuleShipConfig::OnMouseReleased(int button, int x, int y)	
{ 
	for(int i=0; i<buttonsActive; ++i)
		if(buttons[i]->OnMouseReleased(button, x, y) )
			return;
}
void ModuleShipConfig::OnMouseWheelUp(int x, int y)					{ }
void ModuleShipConfig::OnMouseWheelDown(int x, int y)				{ }
void ModuleShipConfig::OnEvent(Event *event)
{
	int evnum, maxclass = -1;
	Event e;

	//check for general events
	switch(event->getEventType() ) 
	{
		case UndefButtonType:
			break;		
		case ModuleEntry:
			menuPath.push_back(ModuleEntry);
			buttonsActive = 4;
			configureButton(0, ShipConfig);
			configureButton(1, TVConfig);
			configureButton(2, Launch);
			configureButton(3, Exit);
			break;

		case ShipConfig:
			menuPath.push_back(ShipConfig);
			buttonsActive = 5;
			configureButton(0, Buy);
			configureButton(1, Sell);
			configureButton(2, Repair);
			configureButton(3, Name);
			configureButton(4, Back);
			break;

		case Launch:
			if(g_game->gameState->PreparedToLaunch() )
            {
				ID starid = 2;
				g_game->gameState->player->currentStar = starid;
				g_game->gameState->player->set_galactic_pos(15553, 13244);

				//compute myrrdan position
				int orbitalpos = 3;
				int tilesacross=100, tilesdown=100, tileswidth=256, tilesheight=256;
				int starX=tilesacross/2, starY=tilesdown/2;

				srand(starid);
				for (int i = 0; i < orbitalpos; i++) rand();
				float radius = (2 + orbitalpos) * 4;
				float angle = rand() % 360;
				int rx = (int)( cos(angle) * radius );
				int ry = (int)( sin(angle) * radius );

				//set player position to start near myrrdan
				g_game->gameState->player->posSystem.SetPosition( (starX+rx)*tileswidth -256, (starY+ry)*tilesheight -135);

				g_game->modeMgr->LoadModule(MODULE_INTERPLANETARY);
			}else{
				g_game->ShowMessageBoxWindow("Not prepared to launch! Make sure you have an engine and a crew.");
			}
			return;
			break;

		case Buy:
			menuPath.push_back(Buy);
			buttonsActive = 7;
			configureButton(0, CargoPods);
			configureButton(1, Engines);
			configureButton(2, Shields);
			configureButton(3, Armor);
			configureButton(4, Missiles);
			configureButton(5, Lasers);
			configureButton(6, Back);
			break;

		case Sell:
			menuPath.push_back(Sell);
			buttonsActive = 7;
			configureButton(0, CargoPods);
			configureButton(1, Engines);
			configureButton(2, Shields);
			configureButton(3, Armor);
			configureButton(4, Missiles);
			configureButton(5, Lasers);
			configureButton(6, Back);
			break;

		case Repair:
        {
            //calculate repair cost
            repairCost = 0;
            Ship ship = g_game->gameState->m_ship;
            if (ship.getHullIntegrity() < 100)
                repairCost += getHullRepair();
            if (ship.getArmorIntegrity() < 100)
                repairCost += getArmorRepair();
            if (ship.getEngineIntegrity() < 100)
                repairCost += getEngineRepair();
            if (ship.getShieldIntegrity() < 100)
                repairCost += getShieldRepair();
            if (ship.getLaserIntegrity() < 100)
                repairCost += getLaserRepair();
            if (ship.getMissileLauncherIntegrity() < 100)
                repairCost += getMissileRepair();

			menuPath.push_back(Repair);
			buttonsActive = 7;
			configureButton(0, Engines);
			configureButton(1, Shields);
			configureButton(2, Armor);
			configureButton(3, Missiles);
			configureButton(4, Lasers);
            configureButton(5, Hull);
			configureButton(6, Back);
        }
			break;

		case Name:
			menuPath.push_back(Name);
			buttonsActive = 2;
			configureButton(0, SaveName);
			configureButton(1, Nevermind);
			inputName = true;
			shipName = g_game->gameState->m_ship.getName();	
			break;

		case Exit:
			g_game->modeMgr->LoadModule(MODULE_STARPORT);
			return;
			break;

		case CargoPods:
			//menuPath.push_back(CargoPods);
			if (menuPath[2] == Buy 
                && g_game->gameState->m_ship.getCargoPodCount() < MAX_CARGOPODS 
                && g_game->gameState->m_credits >= CARGOPODS )
			{
				g_game->gameState->m_ship.cargoPodPlusPlus();
				g_game->gameState->m_credits -= CARGOPODS;
			}
			else if (menuPath[2] == Sell 
                && g_game->gameState->m_ship.getCargoPodCount() > 0)
			{
				if (g_game->gameState->m_ship.getAvailableSpace() < POD_CAPACITY)
					g_game->ShowMessageBoxWindow("", "You can't sell any of your cargo pods--you have too many items in the hold.");
				else {
					g_game->gameState->m_ship.cargoPodMinusMinus();
					g_game->gameState->m_credits += CARGOPODS;
				}
			}
			break;

		//buy/sell ship components
		case Engines:
		case Shields:
		case Armor:
		case Missiles:
		case Lasers:
        case Hull:
			menuPath.push_back( (ButtonType)event->getEventType() );
			if(menuPath[2] == Buy) 
            {
				buttonsActive = 7;
				configureButton(0, Class1);
				configureButton(1, Class2);
				configureButton(2, Class3);
				configureButton(3, Class4);
				configureButton(4, Class5);
				configureButton(5, Class6);
				configureButton(6, Back);

				//limit purchase to maximum class by profession
				evnum = event->getEventType();
				switch(evnum) {
					case Engines:
						maxclass = g_game->gameState->m_ship.getMaxEngineClass();
						break;
					case Shields:
						maxclass = g_game->gameState->m_ship.getMaxShieldClass();
						break;
					case Armor:
						maxclass = g_game->gameState->m_ship.getMaxArmorClass();
						break;
					case Missiles:
						maxclass = g_game->gameState->m_ship.getMaxMissileLauncherClass();
						break;
					case Lasers:
						maxclass = g_game->gameState->m_ship.getMaxLaserClass();
						break;
					default:
						ASSERT(0);
				}

				for (int n=6; n>maxclass; n--) {
					configureButton(n-1, UndefButtonType);
				}

			}
			else if(menuPath[2] == Sell) 
            {
				if (checkComponent()) 
                {
					sellComponent();
					menuPath.pop_back();
				}
				else g_game->ShowMessageBoxWindow("", "You don't have one to sell!", 400, 200);

				menuPath.pop_back();
				e = menuPath.back();
				menuPath.pop_back();
				g_game->modeMgr->BroadcastEvent(&e);
			}
            else if (menuPath[2] == Repair)
            {
                if (checkComponent())
                {
                    repairComponent();
                    menuPath.pop_back();
                }
                else g_game->ShowMessageBoxWindow("", "You don't have one to repair!", 400, 200);

                menuPath.pop_back();
                e = menuPath.back();
                menuPath.pop_back();
                g_game->modeMgr->BroadcastEvent(&e);
            }
			break;

		case Back:
			inputName = false;
			menuPath.pop_back();
			e = menuPath.back();
			menuPath.pop_back();
			g_game->modeMgr->BroadcastEvent(&e);
			break;

		//buy new class of component
		case Class1:
		case Class2:
		case Class3:
		case Class4:
		case Class5:
		case Class6:
			menuPath.push_back( (ButtonType)event->getEventType() );
			if(menuPath[2] == Buy)
			{
				if(!checkComponent() )
				{
					buyComponent();
					menuPath.pop_back();
					menuPath.pop_back();
				}
			}
			menuPath.pop_back();
			e = menuPath.back();
			menuPath.pop_back();
			g_game->modeMgr->BroadcastEvent(&e);
			break;

		case Nevermind:
			menuPath.pop_back();
			e = menuPath.back();
			menuPath.pop_back();
			g_game->modeMgr->BroadcastEvent(&e);
			break;

		case SaveName:
			if(menuPath[2] == Name)
			{
				if (shipName != "")
				{
					g_game->gameState->m_ship.setName(shipName);

					menuPath.pop_back();
					e = menuPath.back();
					menuPath.pop_back();
					g_game->modeMgr->BroadcastEvent(&e);
				}
				else
				{
					g_game->ShowMessageBoxWindow("", "You must first christen your ship!", 400, 200);
				}
			}
			break;

		case TVConfig:
			menuPath.push_back(TVConfig);
			buttonsActive = 2;
			configureButton(0, BuyTV);
			configureButton(1, Back);
			break;

		case BuyTV:
			if (g_game->gameState->m_ship.getHasTV())
			{
				g_game->ShowMessageBoxWindow("", "You already own a Terrain Vehicle!", 400, 150);
			}
			else
			{
				if (g_game->gameState->getCredits() >= 2000)
				{
					g_game->gameState->m_ship.setHasTV(true);
					g_game->gameState->augCredits(-2000);
					
					menuPath.pop_back();
					e = menuPath.back();
					menuPath.pop_back();
					g_game->modeMgr->BroadcastEvent(&e);
				}
				else
				{
					g_game->ShowMessageBoxWindow("", "A new Terrain Vehicle costs 2,000 credits.", 400, 200);
				}
			}
			break;

		default:
			break;
	}
}


void ModuleShipConfig::Close()
{
	TRACE("ShipConfig Destroy\n");

	try {
		menuPath.clear();
		//if(*buttons) delete [] *buttons;
		for(int a = 0; a < NUMBER_OF_BUTTONS; ++a)
		{
			buttons[a]->Destroy();
			buttons[a] = NULL;
		}
		//fontPtr = NULL;

		if(m_sndClick != NULL) delete m_sndClick;
		if(m_sndErr != NULL) delete m_sndErr;
		//if(m_cursor != NULL) destroy_bitmap(m_cursor);

		
		//unload the data file (thus freeing all resources at once)
		unload_datafile(scdata);
		scdata = NULL;
	}
	catch(std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in ShipConfig::Close\n");
	}	
	
}
std::string ModuleShipConfig::convertMenuPathToString() const
{
	if(menuPath.size() < 2)
		return "Error menuPath.size() < 1";
	std::string result = convertButtonTypeToString(menuPath[1]);
	for(int i=2; i<(int)menuPath.size(); ++i)
		result = result + "->" + convertButtonTypeToString(menuPath[i]);
	return result;
}
std::string ModuleShipConfig::convertButtonTypeToString(ButtonType btnType) const
{
	switch(btnType)
	{
	case UndefButtonType:   return "";  		break;
	case ShipConfig:	return "Ship Systems";	break;
	case Launch:		return "Launch";		break;
	case Buy:		    return "Buy";		    break;
	case Sell:		    return "Sell";		    break;
	case Repair:		return "Repair";		break;
	case Name:		    return "Name";		    break;
	case Exit:		    return "Exit";		    break;
	case CargoPods:		return "Cargo Pods";	break;
	case Engines:		return "Engines";		break;
	case Shields:		return "Shields";		break;
	case Armor:		    return "Armor";		    break;
	case Missiles:		return "Missiles";		break;
	case Lasers:		return "Lasers";		break;
    case Hull:          return "Hull";          break;
	case Back:		    return "Back";		    break;
	case Class1:		return "Class 1";		break;
	case Class2:		return "Class 2";		break;
	case Class3:		return "Class 3";		break;
	case Class4:		return "Class 4";		break;
	case Class5:		return "Class 5";		break;
	case Class6:		return "Class 6";       break;
	case Pay:   		return "Pay";		    break;
	case Nevermind:		return "Cancel";		break;
	case SaveName:		return "Save Name";		break;
	case TVConfig:		return "Terrain Vehicle";		break;
	case BuyTV:	    	return "Buy T.V. (2,000)";		break;
	}
	return "";
}

void ModuleShipConfig::configureButton(int btn, ButtonType btnType)
{
	if(0 <= btn && btn < NUMBER_OF_BUTTONS)
	{
		buttons[btn]->SetClickEvent(btnType);
		if(Class1 <= btnType && btnType <= Class6)
		{
			buttons[btn]->SetButtonText(convertButtonTypeToString(btnType) + 
				"  " + Util::ToString(ITEM_PRICES[menuPath[3] - ITEM_ENUM_DIF][btn]) );

		}	
		else if(btnType == CargoPods)
			buttons[btn]->SetButtonText(convertButtonTypeToString(btnType) + 
				"  " + Util::ToString(CARGOPODS) );
		else
			buttons[btn]->SetButtonText(convertButtonTypeToString(btnType) );
		
		if(btnType == Exit || btnType == Back)
		{
			buttons[btn]->SetX(BOTTOM_CORNER_X);
			buttons[btn]->SetY(BOTTOM_CORNER_Y);
		}
		else
		{
			buttons[btn]->SetX(BUTTON_X_START);
			buttons[btn]->SetY(BUTTON_Y_START+btn*(BUTTON_HEIGHT+PIXEL_BUFFER) );
		}
	}
}
bool ModuleShipConfig::checkComponent() const
{
	if( (int)menuPath.size() < 4) return false;

	switch(menuPath[2])
	{
	case Buy:
		{
			int itemIndex = menuPath[3] - ITEM_ENUM_DIF;
			int classIndex = menuPath[4] - CLASS_ENUM_DIF - 1;
			int cost = ITEM_PRICES[itemIndex][classIndex];

            //can player afford it?
			int cash = g_game->gameState->m_credits;
			if(cash - cost < 0)	return true;

			switch(menuPath[3])
			{
			case Engines: 
                return g_game->gameState->m_ship.getEngineClass() == menuPath[4] - CLASS_ENUM_DIF;
			case Shields: 
                return g_game->gameState->m_ship.getShieldClass() == menuPath[4] - CLASS_ENUM_DIF;
			case Armor: 
                return g_game->gameState->m_ship.getArmorClass() == menuPath[4] - CLASS_ENUM_DIF;
			case Missiles: 
                return g_game->gameState->m_ship.getMissileLauncherClass() == menuPath[3] - CLASS_ENUM_DIF;
			case Lasers: 
                return g_game->gameState->m_ship.getLaserClass() == menuPath[4] - CLASS_ENUM_DIF;
			}
		}
		break;
	case Sell:
		switch(menuPath[3])
		{
		case Engines:  return g_game->gameState->m_ship.getEngineClass() != NotInstalledType;
		case Shields:  return g_game->gameState->m_ship.getShieldClass() != NotInstalledType;
		case Armor:    return g_game->gameState->m_ship.getArmorClass() != NotInstalledType;
		case Missiles: return g_game->gameState->m_ship.getMissileLauncherClass() != NotInstalledType;
		case Lasers:   return g_game->gameState->m_ship.getLaserClass() != NotInstalledType;
		}
		break;

    case Repair:
        switch(menuPath[3])
        {
		case Engines:  return g_game->gameState->m_ship.getEngineClass() != NotInstalledType;
		case Shields:  return g_game->gameState->m_ship.getShieldClass() != NotInstalledType;
		case Armor:    return g_game->gameState->m_ship.getArmorClass() != NotInstalledType;
		case Missiles: return g_game->gameState->m_ship.getMissileLauncherClass() != NotInstalledType;
		case Lasers:   return g_game->gameState->m_ship.getLaserClass() != NotInstalledType;
        case Hull:     return true; 
        }

	}
	return false;
}


int ModuleShipConfig::getEngineValue()
{
    int value = 0;
    Ship ship = g_game->gameState->getShip();
    int engine = ship.getEngineClass();
    switch(engine)
    {
        case 0: value = 0; break;
        case 1: value = ENGINE_CLASS1; break;
        case 2: value = ENGINE_CLASS2; break;
        case 3: value = ENGINE_CLASS3; break;
        case 4: value = ENGINE_CLASS4; break;
        case 5: value = ENGINE_CLASS5; break;
        case 6: value = ENGINE_CLASS6; break;
    }
    float health = ship.getEngineIntegrity() * 0.01f;
    health *= 0.75f;
    value = (int)((float)value * health);
    return value;
}

int ModuleShipConfig::getLaserValue()
{
    int value = 0;
    Ship ship = g_game->gameState->getShip();
    int laser = ship.getLaserClass();
    switch(laser)
    {
        case 0: value = 0; break;
        case 1: value = LASER_CLASS1; break;
        case 2: value = LASER_CLASS2; break; 
        case 3: value = LASER_CLASS3; break;
        case 4: value = LASER_CLASS4; break;
        case 5: value = LASER_CLASS5; break;
        case 6: value = LASER_CLASS6; break;
    }
    float health = ship.getLaserIntegrity() * 0.01f;
    health *= 0.75f;
    value = (int)((float)value * health);
    return value;
}

int ModuleShipConfig::getMissileValue()
{
    int value = 0;
    Ship ship = g_game->gameState->getShip();
    int missile = ship.getMissileLauncherClass();
    switch(missile)
    {
        case 0: value = 0; break;
        case 1: value = MISSILELAUNCHER_CLASS1; break;
        case 2: value = MISSILELAUNCHER_CLASS2; break;
        case 3: value = MISSILELAUNCHER_CLASS3; break;
        case 4: value = MISSILELAUNCHER_CLASS4; break;
        case 5: value = MISSILELAUNCHER_CLASS5; break;
        case 6: value = MISSILELAUNCHER_CLASS6; break;
    }
    float health = ship.getMissileLauncherIntegrity() * 0.01f;
    health *= 0.75f;
    value = (int)((float)value * health);
    return value;
}

int ModuleShipConfig::getShieldValue()
{
    int value = 0;
    Ship ship = g_game->gameState->getShip();
    int shield = ship.getShieldClass();
    switch(shield)
    {
        case 0: value = 0; break;
        case 1: value = SHIELD_CLASS1; break;
        case 2: value = SHIELD_CLASS2; break;
        case 3: value = SHIELD_CLASS3; break;
        case 4: value = SHIELD_CLASS4; break;
        case 5: value = SHIELD_CLASS5; break;
        case 6: value = SHIELD_CLASS6; break;
    }
    float health = ship.getShieldIntegrity() * 0.01f;	//jjh
    health *= 0.75f;
    value = (int)((float)value * health);
    return value;
}

int ModuleShipConfig::getArmorValue()
{
    int value = 0;
    Ship ship = g_game->gameState->getShip();
    int armor = ship.getArmorClass();
    switch(armor)
    {
        case 0: value = 0; break;
        case 1: value = ARMOR_CLASS1; break;
        case 2: value = ARMOR_CLASS2; break;
        case 3: value = ARMOR_CLASS3; break;
        case 4: value = ARMOR_CLASS4; break;
        case 5: value = ARMOR_CLASS5; break;
        case 6: value = ARMOR_CLASS6; break;
    }
    float health = ship.getArmorIntegrity() * 0.01f;
    health *= 0.75f;
    value = (int)((float)value * health );		//was health   jjh
    return value;
}

int ModuleShipConfig::getEngineRepair()
{
    int value = 0;
    Ship ship = g_game->gameState->getShip();
    int engine = ship.getEngineClass();
    switch(engine)
    {
        case 0: value = 0; break;
        case 1: value = ENGINE_CLASS1; break;
        case 2: value = ENGINE_CLASS2; break;
        case 3: value = ENGINE_CLASS3; break;
        case 4: value = ENGINE_CLASS4; break;
        case 5: value = ENGINE_CLASS5; break;
        case 6: value = ENGINE_CLASS6; break;
    }
    float damage = (100 - ship.getEngineIntegrity()) * 0.01f;
    value = (int)((float)value * damage);
    return value;
}

int ModuleShipConfig::getLaserRepair()
{
    int value = 0;
    Ship ship = g_game->gameState->getShip();
    int laser = ship.getLaserClass();
    switch(laser)
    {
        case 0: value = 0; break;
        case 1: value = LASER_CLASS1; break;
        case 2: value = LASER_CLASS2; break; 
        case 3: value = LASER_CLASS3; break;
        case 4: value = LASER_CLASS4; break;
        case 5: value = LASER_CLASS5; break;
        case 6: value = LASER_CLASS6; break;
    }
    float damage = (100 - ship.getLaserIntegrity()) * 0.01f;
    value = (int)((float)value * damage);
    return value;
}

int ModuleShipConfig::getMissileRepair()
{
    int value = 0;
    Ship ship = g_game->gameState->getShip();
    int missile = ship.getMissileLauncherClass();
    switch(missile)
    {
        case 0: value = 0; break;
        case 1: value = MISSILELAUNCHER_CLASS1; break;
        case 2: value = MISSILELAUNCHER_CLASS2; break;
        case 3: value = MISSILELAUNCHER_CLASS3; break;
        case 4: value = MISSILELAUNCHER_CLASS4; break;
        case 5: value = MISSILELAUNCHER_CLASS5; break;
        case 6: value = MISSILELAUNCHER_CLASS6; break;
    }
    float damage = (100 - ship.getMissileLauncherIntegrity()) * 0.01f;
    value = (int)((float)value * damage);
    return value;
}

int ModuleShipConfig::getShieldRepair()
{
    int value = 0;
    Ship ship = g_game->gameState->getShip();
    int shield = ship.getShieldClass();
    switch(shield)
    {
        case 0: value = 0; break;
        case 1: value = SHIELD_CLASS1; break;
        case 2: value = SHIELD_CLASS2; break;
        case 3: value = SHIELD_CLASS3; break;
        case 4: value = SHIELD_CLASS4; break;
        case 5: value = SHIELD_CLASS5; break;
        case 6: value = SHIELD_CLASS6; break;
    }
    float damage = (100 - ship.getShieldIntegrity()) * 0.01f;
    value = (int)((float)value * damage);
    return value;
}

int ModuleShipConfig::getArmorRepair()
{
    int value = 0;
    Ship ship = g_game->gameState->getShip();
    int armor = ship.getArmorClass();
    switch(armor)
    {
        case 0: value = 0; break;
        case 1: value = ARMOR_CLASS1; break;
        case 2: value = ARMOR_CLASS2; break;
        case 3: value = ARMOR_CLASS3; break;
        case 4: value = ARMOR_CLASS4; break;
        case 5: value = ARMOR_CLASS5; break;
        case 6: value = ARMOR_CLASS6; break;
    }
    float damage = (100 - ship.getArmorIntegrity()) * 0.01f;
    value = (int)((float)value * damage);
    return value;
}

int ModuleShipConfig::getHullRepair()
{
    Ship ship = g_game->gameState->getShip();
    int damage = (100 - ship.getHullIntegrity()) * 100;
    return damage;
}

void ModuleShipConfig::repairComponent()
{
    if( (int)menuPath.size() < 4 ) return;

    string noMsg = "You don't have enough credits to pay for the repairs.";
    int itemCost = 0;
	switch(menuPath[3])
	{
        case Hull:
            itemCost = getHullRepair();
            if (itemCost > 0)
            {
                if (g_game->gameState->m_credits >= itemCost)
                {
        		    g_game->gameState->augCredits(-itemCost);
                    g_game->gameState->m_ship.setHullIntegrity(100);
                    g_game->ShowMessageBoxWindow("", "Hull breaches have been patched up.", 400, 200);
                }
	            else
		            g_game->ShowMessageBoxWindow("", noMsg, 400, 200);
            }
            break;
	    case Engines:    
            itemCost = getEngineRepair();
            if (itemCost > 0)
            {
                if (g_game->gameState->m_credits >= itemCost)
                {
        		    g_game->gameState->augCredits(-itemCost);
                    g_game->gameState->m_ship.setEngineIntegrity(100);
                    g_game->ShowMessageBoxWindow("", "Engines now at peak operating efficiency.", 400, 200);
                }
	            else
		            g_game->ShowMessageBoxWindow("", noMsg, 400, 200);
            }
            break;
	    case Shields:    
            itemCost = getShieldRepair();	
            if (itemCost > 0)
            {
                if (g_game->gameState->m_credits >= itemCost)
                {
        		    g_game->gameState->augCredits(-itemCost);
                    g_game->gameState->m_ship.setShieldIntegrity(100);
                    g_game->ShowMessageBoxWindow("", "Shield capability fully restored.", 400, 200);
                }
	            else
		            g_game->ShowMessageBoxWindow("", noMsg, 400, 200);
            }
            break;
	    case Armor:      
            itemCost = getArmorRepair();	
            if (itemCost > 0)
            {
                if (g_game->gameState->m_credits >= itemCost)
                {
        		    g_game->gameState->augCredits(-itemCost);
                    g_game->gameState->m_ship.setArmorIntegrity(100);
                    g_game->ShowMessageBoxWindow("", "Armor plating has been reinforced.", 400, 200);
                }
	            else
		            g_game->ShowMessageBoxWindow("", noMsg, 400, 200);
            }
            break;
	    case Missiles:   
            itemCost = getMissileRepair();	
            if (itemCost > 0)
            {
                if (g_game->gameState->m_credits >= itemCost)
                {
        		    g_game->gameState->augCredits(-itemCost);
                    g_game->gameState->m_ship.setMissileLauncherIntegrity(100);
                    g_game->ShowMessageBoxWindow("", "Missile launcher fully repaired.", 400, 200);
                }
	            else
		            g_game->ShowMessageBoxWindow("", noMsg, 400, 200);
            }
            break;
	    case Lasers:     
            itemCost = getLaserRepair();	
            if (itemCost > 0)
            {
                if (g_game->gameState->m_credits >= itemCost)
                {
        		    g_game->gameState->augCredits(-itemCost);
                    g_game->gameState->m_ship.setLaserIntegrity(100);
                    g_game->ShowMessageBoxWindow("", "Lasers are ready for action.", 400, 200);
                }
	            else
		            g_game->ShowMessageBoxWindow("", noMsg, 400, 200);
            }
            break;
	    default:    
		    ASSERT(0);
	}

	
	g_game->gameState->m_ship.setHullIntegrity(100);
		

}

void ModuleShipConfig::sellComponent()
{
	if( (int)menuPath.size() < 4 ) return;

    int salePrice = 0;
    string saleText = "You received ";
    string saleItem = "";

	Ship ship = g_game->gameState->getShip();
	switch(menuPath[3])
	{
	case Engines: 
        salePrice = getEngineValue();
        saleItem = "Class " + Util::ToString(ship.getEngineClass()) + " Engine";
		ship.setEngineClass(NotInstalledType); 
		break;
	case Shields: 
        salePrice = getShieldValue();
        saleItem = "Class " + Util::ToString(ship.getShieldClass()) + " Shield";
		ship.setShieldClass(NotInstalledType); 
		break;
	case Armor: 
        salePrice = getArmorValue();
        saleItem = "Class " + Util::ToString(ship.getArmorClass()) + " Armor";
		ship.setArmorClass(NotInstalledType); 
		break;
	case Missiles: 
        salePrice = getMissileValue();
        saleItem = "Class " + Util::ToString(ship.getMissileLauncherClass()) + " Missile Launcher";
		ship.setMissileLauncherClass(NotInstalledType); 
		break;
	case Lasers: 
        salePrice = getLaserValue();
        saleItem = "Class " + Util::ToString(ship.getLaserClass()) + " Laser";
		ship.setLaserClass(NotInstalledType); 
		break;
	default:
		ASSERT(0);
	}

    //save ship changes
	g_game->gameState->setShip(ship);

    //add credits to player's account
    //int cost = ITEM_PRICES[itemIndex][classIndex];
	//g_game->gameState->m_credits += (int)(cost * SELLBACK_RATE);
    g_game->gameState->augCredits( salePrice );

    saleText = "You received " + Util::ToString(salePrice) + " credits for the " + saleItem + ".";
    g_game->ShowMessageBoxWindow("", saleText, 600, 200);

}

void ModuleShipConfig::buyComponent()
{
	if( (int)menuPath.size() < 5 ) return;

	int itemIndex = menuPath[3] - ITEM_ENUM_DIF;
	int classIndex = menuPath[4] - CLASS_ENUM_DIF - 1;
	int cost = ITEM_PRICES[itemIndex][classIndex];
	Ship ship = g_game->gameState->getShip();

	switch(menuPath[3]) 
    {
		case Engines: 
            if (ship.getEngineClass() == 0)
            {
			    ship.setEngineClass(menuPath[4] - CLASS_ENUM_DIF); 
			    ship.setEngineIntegrity(100.0f);
              	g_game->gameState->augCredits(-cost);
            }
            else
                g_game->ShowMessageBoxWindow("", "Your ship already has an engine!",450,200);
			break;
		case Shields: 
            if (ship.getShieldClass() == 0)
            {
			    ship.setShieldClass(menuPath[4] - CLASS_ENUM_DIF); 
			    ship.setShieldIntegrity(100.0f);
			    ship.setShieldCapacity(ship.getMaxShieldCapacity());
                g_game->gameState->augCredits(-cost);
            }
            else
                g_game->ShowMessageBoxWindow("", "Your ship already has a shield generator!",450,200);
			break;
		case Armor: 
            if (ship.getArmorClass() == 0)
            {
			    ship.setArmorClass(menuPath[4] - CLASS_ENUM_DIF); 
			    ship.setArmorIntegrity(ship.getMaxArmorIntegrity());
                g_game->gameState->augCredits(-cost);
            }
            else
                g_game->ShowMessageBoxWindow("", "Your ship already has armor plating!",450,200);
			break;
		case Missiles: 
            if (ship.getMissileLauncherClass() == 0)
            {
			    ship.setMissileLauncherClass(menuPath[4] - CLASS_ENUM_DIF); 
			    ship.setMissileLauncherIntegrity(100.0f);
                g_game->gameState->augCredits(-cost);
            }
            else 
                g_game->ShowMessageBoxWindow("", "Your ship already has a missile launcher!",450,200);
			break;
		case Lasers: 
            if (ship.getLaserClass() == 0)
            {
			    ship.setLaserClass(menuPath[4] - CLASS_ENUM_DIF); 
			    ship.setLaserIntegrity(100.0f);
                g_game->gameState->augCredits(-cost);
            }
            else
                g_game->ShowMessageBoxWindow("", "Your ship already has a laser!",450,200);
			break;
		default:
			ASSERT(0);
	}
	g_game->gameState->setShip(ship);
}

void ModuleShipConfig::display() const
{
	//show menu path
	if (menuPath.back() == Repair)
	{
		std::string temp = "Total Repair Cost: " + Util::ToString(repairCost) + " MU";
		alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, temp.c_str(), MENU_PATH_X, MENU_PATH_Y, WHITE, -1);
	}
	else if (menuPath.back() == Name)		
	{
		//print "MSS"
		alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, "MSS", MENU_PATH_X, MENU_PATH_Y, WHITE, -1);

		//print ship name
		alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, shipName.c_str(), MENU_PATH_X+80, MENU_PATH_Y, WHITE, -1);

		int nlen = alfont_text_length(g_game->font32, shipName.c_str());
		blit(m_cursor,g_game->GetBackBuffer(),0,0,MENU_PATH_X+80+nlen+2,MENU_PATH_Y,m_cursor->w,m_cursor->h);
		
	}
	else
	{
		if(menuPath.size() > 1)
			alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, convertMenuPathToString().c_str(), MENU_PATH_X, MENU_PATH_Y, WHITE, -1);
	}

	//draw ship schematic
	draw_trans_sprite(g_game->GetBackBuffer(), shipImage, 586, 548);

	//static
	int i=0;
	alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, "Ship Name: MSS",	STATIC_SHIPNAME_X-10, SHIPNAME_Y, WHITE, -1);	
	alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, "Cargo Pods",		STATIC_READOUT_X, READOUT_Y+(i++)*READOUT_SPACING, WHITE, -1);
	alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, "Engine",			STATIC_READOUT_X, READOUT_Y+(i++)*READOUT_SPACING, WHITE, -1);
	alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, "Shield",			STATIC_READOUT_X, READOUT_Y+(i++)*READOUT_SPACING, WHITE, -1);
	alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, "Armor",			STATIC_READOUT_X, READOUT_Y+(i++)*READOUT_SPACING, WHITE, -1);
	alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, "Missile",		STATIC_READOUT_X, READOUT_Y+(i++)*READOUT_SPACING, WHITE, -1);
	alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, "Laser",			STATIC_READOUT_X, READOUT_Y+(i++)*READOUT_SPACING, WHITE, -1);
	alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, "Hull Integrity",	STATIC_READOUT_X, READOUT_Y+(i++)*READOUT_SPACING, WHITE, -1);
	alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, "Credits",		STATIC_CREDITS_X, CREDITS_Y, WHITE, -1);

	//dynamic
	int j=0;
	alfont_textout_ex(g_game->GetBackBuffer(), g_game->font32, g_game->gameState->m_ship.getName().c_str(), DYNAMIC_SHIPNAME_X+90, SHIPNAME_Y, WHITE, -1); 
	alfont_textprintf_right_ex(g_game->GetBackBuffer(), g_game->font32, DYNAMIC_READOUT_X, READOUT_Y+(j++)*READOUT_SPACING, WHITE, -1, "%d", g_game->gameState->m_ship.getCargoPodCount() );

    //display class level of engine
    int color = WHITE;
    int health = g_game->gameState->m_ship.getEngineIntegrity();
    if (health < 50) color = RED;
    else if (health < 100) color = YELLOW;
    else color = WHITE;
    alfont_textout_right_ex(g_game->GetBackBuffer(), g_game->font32, 
        g_game->gameState->m_ship.getEngineClassString().c_str(), 
        DYNAMIC_READOUT_X, READOUT_Y+(j++)*READOUT_SPACING, color, -1);

    //display class level of shield
    health = g_game->gameState->m_ship.getShieldIntegrity();
    if (health < 50) color = RED;
    else if (health < 100) color = YELLOW;
    else color = WHITE;
	alfont_textout_right_ex(g_game->GetBackBuffer(), g_game->font32, 
        g_game->gameState->m_ship.getShieldClassString().c_str(), 
        DYNAMIC_READOUT_X, READOUT_Y+(j++)*READOUT_SPACING, color, -1);

    //display class level of armor
    health = g_game->gameState->m_ship.getArmorIntegrity();
    if (health < 50) color = RED;
    else if (health < 100) color = YELLOW;
    else color = WHITE;
	alfont_textout_right_ex(g_game->GetBackBuffer(), g_game->font32, 
        g_game->gameState->m_ship.getArmorClassString().c_str(), 
        DYNAMIC_READOUT_X, READOUT_Y+(j++)*READOUT_SPACING, color, -1);

    //display class level of missile
    health = g_game->gameState->m_ship.getMissileLauncherIntegrity();
    if (health < 50) color = RED;
    else if (health < 100) color = YELLOW;
    else color = WHITE;
    alfont_textout_right_ex(g_game->GetBackBuffer(), g_game->font32, 
        g_game->gameState->m_ship.getMissileLauncherClassString().c_str(), 
        DYNAMIC_READOUT_X, READOUT_Y+(j++)*READOUT_SPACING, color, -1);

    //display class level of laser
    health = g_game->gameState->m_ship.getLaserIntegrity();
    if (health < 50) color = RED;
    else if (health < 100) color = YELLOW;
    else color = WHITE;
	alfont_textout_right_ex(g_game->GetBackBuffer(), g_game->font32, 
        g_game->gameState->m_ship.getLaserClassString().c_str(), 
        DYNAMIC_READOUT_X, READOUT_Y+(j++)*READOUT_SPACING, color, -1);

	//this should clear up any hull init problem
    health = g_game->gameState->m_ship.getHullIntegrity();
    if (health < 50) color = RED;
    else if (health < 100) color = YELLOW;
    else color = WHITE;
	
    if (g_game->gameState->m_ship.getHullIntegrity() > 100.0f)
		g_game->gameState->m_ship.setHullIntegrity(100.0f);

    //print hull integrity
	alfont_textprintf_right_ex(g_game->GetBackBuffer(), g_game->font32, 
        DYNAMIC_READOUT_X, READOUT_Y+(j++)*READOUT_SPACING, WHITE, -1, "%.0f", 
        g_game->gameState->m_ship.getHullIntegrity() );

    //print credits
	alfont_textprintf_right_ex(g_game->GetBackBuffer(), g_game->font32, 
        DYNAMIC_CREDITS_X, CREDITS_Y, WHITE, -1, "%d", 
        g_game->gameState->m_credits );

}


void ModuleShipConfig::Update(){}

void ModuleShipConfig::Draw()
{
	//blit the background image
	blit(shipConfig, g_game->GetBackBuffer(), 0, 0, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

	//step through active buttons
	for(int i=0; i<buttonsActive; ++i)
		buttons[i]->Run(g_game->GetBackBuffer());

	display();

}
