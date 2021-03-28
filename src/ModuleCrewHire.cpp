///*
//	STARFLIGHT - THE LOST COLONY
//	ModuleCrewHire.cpp - This module gives the player the ability to hire, fire, and reassign crew members. 
//	Author: Justin Sargent
//	Date: 9/21/07
//	Mods: Jim Haga - JJH
//	Date: 3/16/21
//*/

#include "env.h"
#include "ModuleCrewHire.h"
#include "AudioSystem.h"
#include "QuestMgr.h"
#include "Events.h"
#include "Game.h"
#include "DataMgr.h"
#include "ModeMgr.h"
#include "Util.h"
#include "Label.h"
#include "PauseMenu.h"

using namespace std;

#define GENERIC_EXIT_BTN_NORM_BMP        0        /* BMP  */
#define GENERIC_EXIT_BTN_OVER_BMP        1        /* BMP  */
#define ICONS_SMALL_GREEN_TGA            2        /* BMP  */
#define ICONS_SMALL_RED_TGA              3        /* BMP  */
#define ICONS_SMALL_TGA                  4        /* BMP  */
#define PERSONEL_BACKGROUND_BMP          5        /* BMP  */
#define PERSONEL_BTN2_BMP                6        /* BMP  */
#define PERSONEL_BTN2_DIS_BMP            7        /* BMP  */
#define PERSONEL_BTN2_HOV_BMP            8        /* BMP  */
#define PERSONEL_BTN_BMP                 9        /* BMP  */
#define PERSONEL_BTN_DIS_BMP             10       /* BMP  */
#define PERSONEL_BTN_HOV_BMP             11       /* BMP  */
#define PERSONEL_CATBTN_BMP              12       /* BMP  */
#define PERSONEL_CATBTN_DIS_BMP          13       /* BMP  */
#define PERSONEL_CATBTN_HOV_BMP          14       /* BMP  */
//#define PERSONEL_COMBAR_BMP              15       /* BMP  */
//#define PERSONEL_DURBAR_BMP              16       /* BMP  */
//#define PERSONEL_ENGBAR_BMP              17       /* BMP  */
//#define PERSONEL_LRBAR_BMP               18       /* BMP  */
//#define PERSONEL_MEDBAR_BMP              19       /* BMP  */
//#define PERSONEL_MINIPOSITIONS_BMP       20       /* BMP  */
//#define PERSONEL_NAVBAR_BMP              21       /* BMP  */
//#define PERSONEL_SCIBAR_BMP              22       /* BMP  */
//#define PERSONEL_TACBAR_BMP              23       /* BMP  */

DATAFILE *chdata;


#define PERSONEL_SCREEN 0
#define UNEMPLOYEED_SCREEN 1

#define CREW_X 561
#define CREW_Y 538
#define CREW_HEIGHT 145
#define CREW_WIDTH 465

#define UNEMPLOYEED_X 564
#define UNEMPLOYEED_Y 68
#define UNEMPLOYEED_HEIGHT 594
#define UNEMPLOYEED_WIDTH 460

#define EXITBTN_X 16
#define EXITBTN_Y 698

#define HIREMOREBTN_X 217
#define HIREMOREBTN_Y 698

#define FIREBTN_X 815
#define FIREBTN_Y 688

#define HIREBTN_X 815
#define HIREBTN_Y 688

#define UNASSIGNBTN_X 606
#define UNASSIGNBTN_Y 688

#define CATBTN_X 531
#define CATBTN_Y 65
#define CATSPACING 59

#define SKILLBAR_X 73
#define SKILLBAR_Y 240

#define SKILLICONS_X 25
#define SKILLICONS_Y 220
#define SKILLSPACING 50

#define SKILLMAXIUM 200
#define ATTRIBUTEMAXIUM 65

#define CREWPOSITION_X 580
#define CREWPOSITION_Y 100
#define CREWSPACING 59

#define PORTRAITPOSITION_X 25
#define PORTRAITPOSITION_Y 170

#define EMPLOYEE_SPAWN_RATE 1

#define EVENT_CAP_CLICK 0
#define EVENT_SCI_CLICK 1
#define EVENT_NAV_CLICK 2
#define EVENT_ENG_CLICK 3
#define EVENT_COM_CLICK 4
#define EVENT_MED_CLICK 5
#define EVENT_TAC_CLICK 6
#define EVENT_UNK_CLICK 7
#define EVENT_NONE 8
#define EVENT_EXIT_CLICK 9
#define EVENT_HIREMORE_CLICK 10
#define EVENT_FIRE_CLICK 11
#define EVENT_UNASSIGN_CLICK 12
#define EVENT_BACK_CLICK 13
#define EVENT_HIRE_CLICK 14
#define EVENT_CREWLISTBOX_CLICK 15
#define EVENT_UNEMPLOYEEDLISTBOX_CLICK 16


ModuleCrewHire::ModuleCrewHire(void) : 
	lastEmployeeSpawn(-1),
	title(NULL),
	slogan(NULL),
	directions(NULL),
	hiremoreDirections(NULL),
	stats(NULL),
	m_background(NULL),
	m_miniSkills(NULL),
	m_exitBtn(NULL),
	m_hireBtn(NULL),
	m_hiremoreBtn(NULL),
	m_fireBtn(NULL),
	m_unassignBtn(NULL),
	m_backBtn(NULL),
	selectedOfficer(NULL),
	unassignedCrew(NULL),
	unemployeed(NULL),
	unemployeedType(NULL)
{

	for (int i=0; i < 8; ++i) m_PositionBtns[i] = NULL;
}

ModuleCrewHire::~ModuleCrewHire(void) {}

void ModuleCrewHire::OnKeyPress(int keyCode)	{ Module::OnKeyPress(keyCode); }
void ModuleCrewHire::OnKeyPressed(int keyCode)
{
	Module::OnKeyPressed(keyCode);
}
void ModuleCrewHire::OnKeyReleased(int keyCode)
{
	Module::OnKeyReleased(keyCode);

	switch (keyCode) 
	{
		case KEY_LCONTROL:
			break;

		case KEY_ESC: 
			//g_game->modeMgr->LoadModule(MODULE_STARPORT);
			break;
	}
}
void ModuleCrewHire::OnMouseMove(int x, int y)					
{ 
	Module::OnMouseMove(x,y); 

	switch(currentScreen)
	{
		case PERSONEL_SCREEN:
			if (selectedPosition != -1)
			{
				m_fireBtn->OnMouseMove(x,y);
				m_unassignBtn->OnMouseMove(x,y);
			}
			m_exitBtn->OnMouseMove(x,y);
			m_hiremoreBtn->OnMouseMove(x,y);

			for (int i=0; i < 8; i++)
				m_PositionBtns[i]->OnMouseMove(x,y);

			if (FALSEHover > -1 && FALSEHover < 8) 
				m_PositionBtns[FALSEHover]->OnMouseMove(m_PositionBtns[FALSEHover]->GetX(),m_PositionBtns[FALSEHover]->GetY());
			
			if (selectedPosition == -1 || selectedPosition == 7)
				unassignedCrew->OnMouseMove(x,y);
			break;

		case UNEMPLOYEED_SCREEN:
			unemployeedType->OnMouseMove(x,y);
			m_hireBtn->OnMouseMove(x,y);
			m_backBtn->OnMouseMove(x,y);
			break;
	}


}
void ModuleCrewHire::OnMouseClick(int button, int x, int y)		
{ 
	Module::OnMouseClick(button,x,y); 

	switch(currentScreen)
	{
		case PERSONEL_SCREEN:
			if (selectedPosition == -1 || selectedPosition == 7)
				unassignedCrew->OnMouseClick(button,x,y);
			break;

		case UNEMPLOYEED_SCREEN:
			unemployeedType->OnMouseClick(button,x,y);
			break;
	}

	
}
void ModuleCrewHire::OnMousePressed(int button, int x, int y)		{ Module::OnMousePressed(button, x, y); }
void ModuleCrewHire::OnMouseReleased(int button, int x, int y)	
{ 
	Module::OnMouseReleased(button, x, y);

	switch(currentScreen)
	{
		case PERSONEL_SCREEN:
			if (selectedPosition != -1)
			{
				m_fireBtn->OnMouseReleased(button,x,y);
				m_unassignBtn->OnMouseReleased(button,x,y);
			}

			m_hiremoreBtn->OnMouseReleased(button,x,y);
			
			for (int i=0; i < 8; i++)
				m_PositionBtns[i]->OnMouseReleased(button,x,y);

			if (selectedPosition == -1 || selectedPosition == 7)
				unassignedCrew->OnMouseReleased(button,x,y);

			//Always call the backBtn "Exit" last
			m_exitBtn->OnMouseReleased(button,x,y);
			break;

		case UNEMPLOYEED_SCREEN:
			unemployeedType->OnMouseReleased(button,x,y);
			m_hireBtn->OnMouseReleased(button,x,y);
			m_backBtn->OnMouseReleased(button,x,y);
			break;
	}

}
void ModuleCrewHire::OnMouseWheelUp(int x, int y)					
{ 
	Module::OnMouseWheelUp(x, y); 

	switch(currentScreen)
	{
		case UNEMPLOYEED_SCREEN:
			unemployeedType->OnMouseWheelUp(x,y);
			break;
	}

}
void ModuleCrewHire::OnMouseWheelDown(int x, int y)				
{
	Module::OnMouseWheelDown(x, y);

	switch(currentScreen)
	{
		case UNEMPLOYEED_SCREEN:
			unemployeedType->OnMouseWheelDown(x,y);
			break;
	}
}
void ModuleCrewHire::OnEvent(Event *event)
{

	bool playBtnClick = false;
	bool exitToStarportCommons = false;
	string escape = "";

	switch (event->getEventType())
	{
		case 0xDEADBEEF + 2: //save game
			g_game->gameState->AutoSave();
			break;
		case 0xDEADBEEF + 3: //load game
            g_game->gameState->AutoLoad();
			break;
		case 0xDEADBEEF + 4: //quit game
			g_game->setVibration(0);
			escape = g_game->getGlobalString("ESCAPEMODULE");
			g_game->modeMgr->LoadModule(escape);
			break;

    case EVENT_EXIT_CLICK:
		{
			playBtnClick = true;
			bool passedCheck = true;
			for (int i=0; i < (int)tOfficers.size(); i++)
			{
				if (tOfficers[i]->GetOfficerType() == OFFICER_NONE)
				{
					passedCheck = false;
				}
			}

			if (passedCheck)
				exitToStarportCommons = true;
		}
		break;

	case EVENT_HIREMORE_CLICK:
		playBtnClick = true;
		currentScreen = UNEMPLOYEED_SCREEN;
		selectedOfficer = NULL;
		selectedPosition = 1;
		this->RefreshUnemployeedCrewBox();
		break;

	case EVENT_HIRE_CLICK:
		if (tOfficers.size() <= 6)
		{
			for (int i=0; i < (int)g_game->gameState->m_unemployedOfficers.size(); i++)
			{
				if (g_game->gameState->m_unemployedOfficers[i] == selectedOfficer)
				{
					g_game->gameState->m_unemployedOfficers.erase(g_game->gameState->m_unemployedOfficers.begin() + i);
					tOfficers.push_back(selectedOfficer);
					selectedPosition = -1;
					selectedOfficer = NULL;
					RefreshUnemployeedCrewBox();
				}
			}
		}
		else
		{
			g_game->ShowMessageBoxWindow("", "You can't hire any more crew members!", 400, 150);
		}
		break;

	case EVENT_BACK_CLICK:
		currentScreen = PERSONEL_SCREEN;
		selectedOfficer = NULL;
		selectedPosition = -1;
		RefreshUnassignedCrewBox();
		break;

	case EVENT_FIRE_CLICK:
		playBtnClick = true;
		
		for (int i=0; i < (int)tOfficers.size(); i++)
		{
			if (tOfficers[i] == selectedOfficer)
			{
				if (selectedOfficer->GetOfficerType() != OFFICER_CAPTAIN)
				{
					tOfficers.erase(tOfficers.begin() + i);
					g_game->gameState->m_unemployedOfficers.push_back(selectedOfficer);
					selectedPosition = -1;
					selectedOfficer = NULL;
					RefreshUnassignedCrewBox();
				}
				else
				{
					g_game->ShowMessageBoxWindow("", "You can't fire yourself, Captain!");
				}
			}
		}
		break;

	case EVENT_UNASSIGN_CLICK:
		playBtnClick = true;
		for (int i=0; i < (int)tOfficers.size(); i++)// Find the officer we are clicking on and unassign him
		{
			if (tOfficers[i]->GetOfficerType()-1 == selectedPosition)
			{
				if (selectedOfficer->GetOfficerType() != OFFICER_CAPTAIN)
				{
					tOfficers[i]->SetOfficerType(OFFICER_NONE);// unassign the officer
					selectedPosition = -1;// set the selected position to none
					RefreshUnassignedCrewBox();
					break;
				}
				else
				{
					g_game->ShowMessageBoxWindow("", "You can't unassign yourself, Captain!");
				}
			}
		}
		selectedPositionLastRun = -2;// This forces a refresh in the run function
		break;

	case EVENT_CREWLISTBOX_CLICK:
		{
			//Find the selected officer
			int j=0;
			for (int i=0; i < (int)tOfficers.size(); i++)			//Loop through all the officers
			{
				if (tOfficers[i]->GetOfficerType() == OFFICER_NONE)	//Count the officers that aren't assigned a position
				{
					selectedOfficer = NULL;
					selectedPosition = -1;
					//If there are at least as many unassigned officers as the selected Index then its valid
					if (j == unassignedCrew->GetSelectedIndex())
					{
						selectedOfficer = tOfficers[i];
						selectedPosition = 7;
						break;
					}
					else
					{
						j++; //apparently it wasn't this officer perhaps the next one
					}
				}
			}
		}
		break;

	case EVENT_UNEMPLOYEEDLISTBOX_CLICK:
		{
			if (unemployeed->GetSelectedIndex() != -1)
			{
				//If there are at least as many officers as the selected Index then its valid
				if ( (int)g_game->gameState->m_unemployedOfficers.size() > unemployeed->GetSelectedIndex())
				{
					selectedOfficer = g_game->gameState->m_unemployedOfficers[unemployeed->GetSelectedIndex()];
					selectedPosition = -1;
				}
				else
				{
					selectedOfficer = NULL;
					selectedPosition = -1;
				}
			}
			else
			{
				selectedOfficer = NULL;
				selectedPosition = -1;
			}
		}
		break;

	case EVENT_CAP_CLICK:
	case EVENT_NAV_CLICK:
	case EVENT_MED_CLICK:
	case EVENT_ENG_CLICK:
	case EVENT_COM_CLICK:
	case EVENT_TAC_CLICK:
	case EVENT_SCI_CLICK:
	case EVENT_UNK_CLICK:
		playBtnClick = true;
		if (currentScreen == PERSONEL_SCREEN)
		{
#pragma region Personel Screen functions
			
            //no position selected yet, so we need to highlight it
            if (selectedPosition == -1)
			{
                // check to see if there is an officer in this position
				for (int i=0; i < (int)tOfficers.size(); i++)
				{
					if (tOfficers[i]->GetOfficerType()-1 == event->getEventType()) //If there is
					{
						selectedPosition = event->getEventType(); //Then select him
						selectedOfficer = tOfficers[i];
                        break;
					}
				}
			}
			else
			{
				if (selectedPosition == event->getEventType()) //Did we click on the same officer we already had selected?
				{
					if (selectedPosition == 7)
						this->RefreshUnassignedCrewBox();

					selectedPosition = -1; //Then Deselect him
					selectedOfficer = NULL;
				}
				else
				{
					// If we are clicking on a new position, we can assume this position is open
					// and the player wants it filled with the selected officer

					//First check to see if the position clicked is the unassigned button
					if (event->getEventType() == EVENT_UNK_CLICK)
					{
						//if it is...
						for (int i=0; i < (int)tOfficers.size(); i++)// Find the officer we are clicking on and unassign him
						{
							if (tOfficers[i]->GetOfficerType()-1 == selectedPosition)
							{
								tOfficers[i]->SetOfficerType(OFFICER_NONE);// unassign the officer
								selectedPosition = -1;// set the selected position to none
								selectedOfficer = NULL;
								RefreshUnassignedCrewBox();// refresh the crew listbox
								break;
							}
						}
						selectedPositionLastRun = -2;// This forces a refresh in the run function
					}
					else
					{
						for (int i=0; i < (int)tOfficers.size(); i++)// Find the officer we have selected already, and assign him to the new position
						{
							if (selectedPosition == 7)//If an unassigned officer was selected we have to do it different
							{
								//Find the selected officer
								int j=0;
								for (int i=0; i < (int)tOfficers.size(); i++)//Loop through all the officers
								{
									if (tOfficers[i]->GetOfficerType() == OFFICER_NONE)//Count the officers that aren't assign a position
									{
										//If there are at least as many unassigned officers as the selected Index then its valid
										if (j == unassignedCrew->GetSelectedIndex())
										{
											//assign that officer to the newly selected position
											tOfficers[i]->SetOfficerType((OfficerType)(event->getEventType()+1));
											selectedPosition = event->getEventType(); //Set the selectedPosition to the newly assigned position
											selectedOfficer = tOfficers[i];
											this->RefreshUnassignedCrewBox();
											break;
										}
										else
										{
											j++; //apparently it wasn't this officer perhaps the next one
										}
									}
								}
							}
							else
							{
								if (tOfficers[i]->GetOfficerType()-1 == selectedPosition)
								{
									tOfficers[i]->SetOfficerType((OfficerType)(event->getEventType()+1));// assign the officer
									selectedPosition = event->getEventType(); //Set the selectedPosition to the newly assigned position
									selectedOfficer = tOfficers[i];
									m_PositionBtns[FALSEHover]->OnMouseMove(0,0); //Remove the FALSEHover glow from the old position
									break;
								}
							}
						}
					}
				}
			}
#pragma endregion
		}
		else if (currentScreen == UNEMPLOYEED_SCREEN)
		{
#pragma region Unemployeed Screen functions
			
#pragma endregion
		}
		selectedPositionLastRun = -2;// This forces a refresh in the run function
		break;
	}

	if (exitToStarportCommons) {
		g_game->modeMgr->LoadModule(MODULE_STARPORT);
		return;
	}
}
//Close is where you release all your resources
void ModuleCrewHire::Close()
{
	TRACE("CrewHire Close\n");
	//Module::Close();

	//We must save all the officers to the game state class before closing
	//NOTE: code modified to use gameState objects directly
	//NOTE ON YOUR NOTE: doesn't work that way, you still have to update the officers in case they made any changes to their positions.
	//					 If we were making any changes to the officers stats they would change but we are repositioning them,
	//					 so we have to save them into their new proper places.
	
	g_game->gameState->officerSci = NULL;
	g_game->gameState->officerNav = NULL;
	g_game->gameState->officerEng = NULL;
	g_game->gameState->officerCom = NULL;
	g_game->gameState->officerDoc = NULL;
	g_game->gameState->officerTac = NULL;

	for (int i=0; i < (int)tOfficers.size(); ++i)
	{
		//No need to save the captain as they shouldn't of made any changes to begin with
		if (tOfficers[i]->GetOfficerType() == OFFICER_SCIENCE)			g_game->gameState->officerSci = tOfficers[i];
		if (tOfficers[i]->GetOfficerType() == OFFICER_NAVIGATION)		g_game->gameState->officerNav = tOfficers[i];
		if (tOfficers[i]->GetOfficerType() == OFFICER_ENGINEER)			g_game->gameState->officerEng = tOfficers[i];
		if (tOfficers[i]->GetOfficerType() == OFFICER_COMMUNICATION)	g_game->gameState->officerCom = tOfficers[i];
		if (tOfficers[i]->GetOfficerType() == OFFICER_MEDICAL)			g_game->gameState->officerDoc = tOfficers[i];
		if (tOfficers[i]->GetOfficerType() == OFFICER_TACTICAL)			g_game->gameState->officerTac = tOfficers[i];
	}

	if (g_game->gameState->officerSci == NULL) g_game->gameState->officerSci = new Officer(OFFICER_NONE);
	if (g_game->gameState->officerNav == NULL) g_game->gameState->officerNav = new Officer(OFFICER_NONE);
	if (g_game->gameState->officerEng == NULL) g_game->gameState->officerEng = new Officer(OFFICER_NONE);
	if (g_game->gameState->officerCom == NULL) g_game->gameState->officerCom = new Officer(OFFICER_NONE);
	if (g_game->gameState->officerDoc == NULL) g_game->gameState->officerDoc = new Officer(OFFICER_NONE);
	if (g_game->gameState->officerTac == NULL) g_game->gameState->officerTac = new Officer(OFFICER_NONE);

	if (title != NULL)	delete title;
	if (slogan != NULL)	delete slogan;
	if (directions != NULL)	delete directions;
	if (hiremoreDirections != NULL)	delete hiremoreDirections;
	if (stats != NULL)	delete stats;

	//delete the crew position button images
	for (int i=0; i < 8; i++)
	{
		destroy_bitmap(posNormImages[i]);
		destroy_bitmap(posOverImages[i]);
		destroy_bitmap(posDisImages[i]);
	}

	if (m_exitBtn)	{
		delete m_exitBtn;
		m_exitBtn = NULL;
	}

	if (m_hireBtn)	{
		delete m_hireBtn;
		m_hireBtn = NULL;
	}

	if (m_hiremoreBtn)	{
		delete m_hiremoreBtn;
		m_hiremoreBtn = NULL;
	}

	if (m_fireBtn) {
		delete m_fireBtn;
		m_fireBtn = NULL;
	}

	if (m_unassignBtn) {
		delete m_unassignBtn;
		m_unassignBtn = NULL;
	}

	if (m_backBtn)	{
		delete m_backBtn;
		m_backBtn = NULL;
	}

	for (int i=0; i < 8; i++)
	{
		delete m_PositionBtns[i];
		m_PositionBtns[i] = NULL;
	}

	if (unassignedCrew)	{
		delete unassignedCrew;
		unassignedCrew = NULL;
	}

	//This will also delete unemployeed
	if (unemployeedType)	{
		delete unemployeedType;
		unemployeedType = NULL;
	}


	//unload the data file (thus freeing all resources at once)
	unload_datafile(chdata);
	chdata = NULL;	
}



//InitModule is where you load all your resources
bool ModuleCrewHire::Init()
{
	BITMAP *btnNorm, *btnOver, *btnDis;

	TRACE("  Crew Hire Initialize\n");
	
	//load the datafile
	chdata = load_datafile("data/crewhire/crewhire.dat");
	if (!chdata) {
		g_game->message("CrewHire: Error loading datafile");	
		return false;
	}


	//BETA 3
	//g_game->ShowMessageBoxWindow("BETA 3 NOTE: A random crew has been assigned for testing purposes. You may still make changes to the crew.");
	
	//enable the Pause Menu
	g_game->pauseMenu->setEnabled(true);


	currentScreen = PERSONEL_SCREEN; 
	selectedPosition = -1; //Set the selectedPosition to none
	selectedEntryLastRun = -1;//Set the crew listbox selection previous run to unselected
	selectedOfficer = NULL;

	g_game->audioSystem->Load("data/crewhire/buttonclick.ogg", "click");


	//Load label for title
	title = new Label("Welcome to Crew Match v.0.3!", 28, 170, 456, 30, makecol(0,255,128), g_game->font32);
	title->Refresh();

	//Load label for slogan
	slogan = new Label("Where you can hire the finest galatic crew!", 28, 200, 456, 40, makecol(0,255,255), g_game->font22);
	slogan->Refresh();
 
	//Load label for directions
	directions = new Label("Click on your crew members to the right to reassign or fire them. You can also browse for future employees by clicking on the Hire More Crew Members button",
		28, 240, 456, 408, makecol(0,255,255), g_game->font18);
	directions->Refresh();

	//Load label for hiremoreDirections
	hiremoreDirections = new Label("On the right is a list potential galatic faring employees. You can view their statistics by clicking on them.",
		28, 240, 456, 408, makecol(0,255,255), g_game->font18);
	hiremoreDirections->Refresh();

	//Load label for stats
	stats = new Label("                  - Statistics -", 28, 170, 456, 30, makecol(0,255,128), g_game->font32);
	stats->Refresh();

	//setup unassignedCrew scrollbox
	unassignedCrew = new ScrollBox::ScrollBox(g_game->font24,ScrollBox::SB_LIST,CREW_X,CREW_Y,CREW_WIDTH,CREW_HEIGHT, EVENT_CREWLISTBOX_CLICK);
	unassignedCrew->DrawScrollBar(false);
	unassignedCrew->setLines(6);

	//setup unemployeed scrollbox
	unemployeed = new ScrollBox::ScrollBox(g_game->font24,ScrollBox::SB_LIST,UNEMPLOYEED_X,UNEMPLOYEED_Y,UNEMPLOYEED_WIDTH,UNEMPLOYEED_HEIGHT, EVENT_UNEMPLOYEEDLISTBOX_CLICK);
	unemployeed->DrawScrollBar(false);
	unemployeed->setLines(25);

	//setup unemployeed type column scrollbox
	unemployeedType = new ScrollBox::ScrollBox(g_game->font24, ScrollBox::SB_LIST, (int)(UNEMPLOYEED_X + UNEMPLOYEED_WIDTH * .66),UNEMPLOYEED_Y,UNEMPLOYEED_WIDTH/3,UNEMPLOYEED_HEIGHT, EVENT_UNEMPLOYEEDLISTBOX_CLICK);
	unemployeedType->DrawScrollBar(false);
	unemployeedType->setLines(25);
    unemployeedType->LinkBox(unemployeed);


	//Must clear the vectors incase this isn't the first time this module loaded
	tOfficers.clear();

	//Load current officers into the officer array
	// NOTE: Explicitly defined officers (i.e. officerCap) will ALWAYS exist and NEVER be null
	if (g_game->gameState->officerCap->name.length() > 0) tOfficers.push_back(g_game->gameState->officerCap);
	if (g_game->gameState->officerSci->name.length() > 0) tOfficers.push_back(g_game->gameState->officerSci);
	if (g_game->gameState->officerNav->name.length() > 0) tOfficers.push_back(g_game->gameState->officerNav);
	if (g_game->gameState->officerEng->name.length() > 0) tOfficers.push_back(g_game->gameState->officerEng);
	if (g_game->gameState->officerCom->name.length() > 0) tOfficers.push_back(g_game->gameState->officerCom);
	if (g_game->gameState->officerTac->name.length() > 0) tOfficers.push_back(g_game->gameState->officerTac);
	if (g_game->gameState->officerDoc->name.length() > 0) tOfficers.push_back(g_game->gameState->officerDoc);


	//if PERSONS FOR HIRE list is empty, fill it
	if (g_game->gameState->m_unemployedOfficers.size() == 0)
	{
		for (int i=0; g_game->gameState->m_unemployedOfficers.size() <= 18; i++)
		{
			//create a random dude
			Officer *dude = new Officer(OFFICER_NONE);
			dude->name = g_game->dataMgr->GetRandMixedName();
			for (int att=0; att < 6; att++)
				dude->attributes[att] = Util::Random(5,50);

			//specialization in a random skill
			dude->attributes[Util::Random(0,5)] = Util::Random(50,75);

			dude->attributes[6] = 5;
			dude->attributes[7] = 5;

			//add this dude to the FOR HIRE list
			g_game->gameState->m_unemployedOfficers.push_back(dude);
		}
	}

	if(lastEmployeeSpawn == -1)
	{ //it hasn't been initialized
		lastEmployeeSpawn = g_game->gameState->stardate.get_current_date_in_days();
	}

	currentVisit = g_game->gameState->stardate.get_current_date_in_days();

	//refresh the list of random employees (we do it unconditionally for the time being)
	//if ( (currentVisit - lastEmployeeSpawn)/EMPLOYEE_SPAWN_RATE >= 1 )
	if ( true )
	{
		//Save the new time for Employee Spawn
		lastEmployeeSpawn = g_game->gameState->stardate.get_current_date_in_days();

		//Remove some old faces
		int facesToRemove = Util::Random(2, 6);
		for (int i=0; i < facesToRemove; ++i)
		{
			g_game->gameState->m_unemployedOfficers.erase(g_game->gameState->m_unemployedOfficers.begin() + 
										Util::Random(0, (int)g_game->gameState->m_unemployedOfficers.size()-1) );
		}

		//Add some new ones (exactly has many has we removed for the time being; so we don't have to worry about the list growing or shrinking)
		int facesToAdd = facesToRemove;
		for (int i=0; i < facesToAdd; ++i)
		{
			//create a random dude
			Officer *dude = new Officer(OFFICER_NONE);
			dude->name = g_game->dataMgr->GetRandMixedName();
			for (int att=0; att < 6; att++)
				dude->attributes[att] = Util::Random(5,50);

			//specialization in a random skill
			dude->attributes[Util::Random(0,5)] = Util::Random(50,75);
			
			dude->attributes[6] = 5;
			dude->attributes[7] = 5;

			//add this dude to the FOR HIRE list
			g_game->gameState->m_unemployedOfficers.push_back(dude);
		}
	}

	for (int i=0; i < (int)g_game->gameState->m_unemployedOfficers.size(); ++i)
	{
		//add this person to the AVAILABLE FOR HIRE list
		coloredString.String = g_game->gameState->m_unemployedOfficers[i]->name;
		unemployeed->Write(coloredString);

		coloredString.String = g_game->gameState->m_unemployedOfficers[i]->GetPreferredProfession();
		unemployeedType->Write(coloredString);
	}


	//load the background
	m_background = (BITMAP*)chdata[PERSONEL_BACKGROUND_BMP].dat;
	if (!m_background) 
	{
		g_game->message("CrewHire: Error loading personel_background");
		return false;
	}

	//Create escape button for the module
	btnNorm = (BITMAP*)chdata[GENERIC_EXIT_BTN_NORM_BMP].dat;
	btnOver = (BITMAP*)chdata[GENERIC_EXIT_BTN_OVER_BMP].dat;
	m_exitBtn = new Button(btnNorm,btnOver,NULL,EXITBTN_X,EXITBTN_Y,EVENT_NONE,EVENT_EXIT_CLICK, g_game->font24, "Exit", makecol(255,0,0),"click");
	if (m_exitBtn == NULL) return false;
	if (!m_exitBtn->IsInitialized()) return false;

	//Create and initialize the Back button for the module
	m_backBtn = new Button(btnNorm,btnOver,NULL,EXITBTN_X,EXITBTN_Y,EVENT_NONE,EVENT_BACK_CLICK, g_game->font24, "Back", makecol(255,0,0),"click");
	if (m_backBtn == NULL) return false;
	if (!m_backBtn->IsInitialized()) return false;

	//Create and initialize the HireMore button for the module
	btnNorm = (BITMAP*)chdata[PERSONEL_BTN2_BMP].dat;
	btnOver = (BITMAP*)chdata[PERSONEL_BTN2_HOV_BMP].dat;
	btnDis = (BITMAP*)chdata[PERSONEL_BTN2_DIS_BMP].dat;
	m_hiremoreBtn = new Button(btnNorm,btnOver,btnDis,HIREMOREBTN_X,HIREMOREBTN_Y,EVENT_NONE,EVENT_HIREMORE_CLICK, g_game->font24, "Hire More Crew Members", makecol(0,255,255),"click");
	if (m_hiremoreBtn == NULL)
		return false;
	if (!m_hiremoreBtn->IsInitialized())
		return false;

	//Create and initialize the Hire button for the module
	btnNorm = (BITMAP*)chdata[PERSONEL_BTN_BMP].dat;
	btnOver = (BITMAP*)chdata[PERSONEL_BTN_HOV_BMP].dat;
	btnDis = (BITMAP*)chdata[PERSONEL_BTN_DIS_BMP].dat;
	m_hireBtn = new Button(btnNorm,btnOver,btnDis,HIREBTN_X,HIREBTN_Y,EVENT_NONE,EVENT_HIRE_CLICK, g_game->font24, "Hire", makecol(0,255,255),"click");
	if (m_hireBtn == NULL)	return false;
	if (!m_hireBtn->IsInitialized()) return false;

	//Create and initialize the Fire button for the module
	m_fireBtn = new Button(btnNorm,btnOver,btnDis,FIREBTN_X,FIREBTN_Y,EVENT_NONE,EVENT_FIRE_CLICK, g_game->font24, "Fire", makecol(0,255,255),"click");
	if (m_fireBtn == NULL)	return false;
	if (!m_fireBtn->IsInitialized())	return false;

	//Create and initialize the Assign Position button for the module
	m_unassignBtn = new Button(btnNorm,btnOver,btnDis,UNASSIGNBTN_X,UNASSIGNBTN_Y,EVENT_NONE,EVENT_UNASSIGN_CLICK, g_game->font24, "Unassign", makecol(0,255,255),"click");
	if (m_unassignBtn == NULL)	return false;
	if (!m_unassignBtn->IsInitialized())	return false;


	BITMAP *blackIcons = (BITMAP*)chdata[ICONS_SMALL_TGA].dat;
	BITMAP *greenIcons = (BITMAP*)chdata[ICONS_SMALL_GREEN_TGA].dat; 
	BITMAP *redIcons = (BITMAP*)chdata[ICONS_SMALL_RED_TGA].dat;

	btnNorm = (BITMAP*)chdata[PERSONEL_CATBTN_BMP].dat;
	btnOver = (BITMAP*)chdata[PERSONEL_CATBTN_HOV_BMP].dat;
	btnDis = (BITMAP*)chdata[PERSONEL_CATBTN_DIS_BMP].dat;

	//create crew buttons	
	BITMAP *temp = create_bitmap(30,30);

	char positions[8][20] = {"- Captain - ", "- Science -","- Navigation -","- Engineering -","- Communication -","- Medical -","- Tactical -","- Unassigned -"};

	for (int i=0; i < 8; i++)
	{
		//create a normal image for each crew position button
		posNormImages[i] = create_bitmap(btnNorm->w, btnNorm->h);
		blit(btnNorm, posNormImages[i], 0, 0, 0, 0, btnNorm->w, btnNorm->h);
		//create an over image for each crew position button
		posOverImages[i] = create_bitmap(btnOver->w, btnOver->h);
		blit(btnOver, posOverImages[i], 0, 0, 0, 0, btnOver->w, btnOver->h);
		//create a disabled image for each crew position button
		posDisImages[i] = create_bitmap(btnDis->w, btnDis->h);
		blit(btnDis, posDisImages[i], 0, 0, 0, 0, btnDis->w, btnDis->h);

		//Create and initialize the new button
		m_PositionBtns[i] = new Button( posNormImages[i], posOverImages[i], posDisImages[i],
			CATBTN_X, CATBTN_Y + (i * CATSPACING), EVENT_NONE, i,"click");

		if (m_PositionBtns[i] == NULL)	return false;
		if (!m_PositionBtns[i]->IsInitialized())	return false;
		
		blit(blackIcons, temp, 30 * i, 0, 0, 0, 30, 30);
		draw_trans_sprite(m_PositionBtns[i]->GetImgNormal(), temp, 0, 0);
		
		blit(greenIcons, temp, 30 * i, 0, 0, 0, 30, 30);
		draw_trans_sprite(m_PositionBtns[i]->GetImgMouseOver(), temp, 0, 0);

		blit(redIcons, temp, 30 * i, 0, 0, 0, 30, 30);
		draw_trans_sprite(m_PositionBtns[i]->GetImgDisabled(), temp, 0, 0);

		alfont_textout_ex(m_PositionBtns[i]->GetImgNormal(), g_game->font24, positions[i], 35, 4, makecol(0,255,255), -1);
		alfont_textout_ex(m_PositionBtns[i]->GetImgMouseOver(), g_game->font24, positions[i], 35, 4, makecol(0,255,255), -1);
		alfont_textout_ex(m_PositionBtns[i]->GetImgDisabled(), g_game->font24, positions[i], 35, 4, makecol(0,255,255), -1);
	}
	destroy_bitmap(temp);

	
	m_miniSkills = (BITMAP*)load_bitmap("data/crewhire/PERSONEL_MINIPOSITIONS.BMP",NULL);
	if (!m_miniSkills) {
		g_game->message("CrewHire: Error loading personel_miniPositions");
		return false;
	}

	//m_skillBars[0] = (BITMAP*)chdata[PERSONEL_SCIBAR_BMP].dat;
	//if (!m_skillBars[0]) {
	//	g_game->message("CrewHire: Error loading personel_sciBar");
	//	return false;
	//}
	//
	//m_skillBars[1] = (BITMAP*)chdata[PERSONEL_NAVBAR_BMP].dat;
	//if (!m_skillBars[1]) {
	//	g_game->message("CrewHire: Error loading personel_navBar");
	//	return false;
	//}

	//m_skillBars[2] = (BITMAP*)chdata[PERSONEL_ENGBAR_BMP].dat;
	//if (!m_skillBars[2]) {
	//	g_game->message("CrewHire: Error loading personel_engBar");
	//	return false;
	//}

	//m_skillBars[3] = (BITMAP*)chdata[PERSONEL_COMBAR_BMP].dat;
	//if (!m_skillBars[3]) {
	//	g_game->message("CrewHire: Error loading personel_comBar");
	//	return false;
	//}

	//m_skillBars[4] = (BITMAP*)chdata[PERSONEL_MEDBAR_BMP].dat;
	//if (!m_skillBars[4]) {
	//	g_game->message("CrewHire: Error loading personel_medBar");
	//	return false;
	//}

	//m_skillBars[5] = (BITMAP*)chdata[PERSONEL_TACBAR_BMP].dat;
	//if (!m_skillBars[5]) {
	//	g_game->message("CrewHire: Error loading personel_tacBar");
	//	return false;
	//}

	//m_skillBars[6] = (BITMAP*)chdata[PERSONEL_LRBAR_BMP].dat;
	//if (!m_skillBars[6]) {
	//	g_game->message("CrewHire: Error loading personel_lrBar");
	//	return false;
	//}
	//
	//m_skillBars[7] = (BITMAP*)chdata[PERSONEL_DURBAR_BMP].dat;
	//if (!m_skillBars[7]) {
	//	g_game->message("CrewHire: Error loading personel_durBar");
	//	return false;
	//}


	//tell questmgr that Personnel event has occurred
	g_game->questMgr->raiseEvent(18);


	return true;
}



void ModuleCrewHire::Update()
{
	Module::Update();

}

void ModuleCrewHire::Draw()
{
	blit(m_background, g_game->GetBackBuffer(), 0, 0, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

	switch (currentScreen)
	{
		case PERSONEL_SCREEN:
#pragma region Personel Screen
			if (selectedEntryLastRun != unassignedCrew->GetSelectedIndex())
			{
				selectedEntryLastRun = unassignedCrew->GetSelectedIndex();
				if (selectedEntryLastRun == -1)
				{
					selectedOfficer = NULL;
					selectedPosition = -1;
				}
				else
				{
					int j=0;
					for (int i=0; i < (int)tOfficers.size(); i++)//Loop through all the officers
					{
						if (tOfficers[i]->GetOfficerType() == OFFICER_NONE)//Count the officers that aren't assigned a position
						{
							//If there are at least as many unassigned officers as the selected Index then its valid
							if (j == unassignedCrew->GetSelectedIndex())
							{
								selectedOfficer = tOfficers[i];
								//Can't fire the captain
								if (selectedOfficer->GetOfficerType() != OFFICER_CAPTAIN)
									m_fireBtn->SetEnabled(true);
								else 
									m_fireBtn->SetEnabled(false);
								
								break;
							}
							else
							{
								j++; //apparently it wasn't this officer perhaps the next one
							}
						}
					}

					if (selectedOfficer != NULL && selectedOfficer->GetOfficerType() != OFFICER_CAPTAIN)
					{
						m_PositionBtns[7]->SetEnabled(true);
						selectedPosition = 7;
					}
				}
			}

			if (selectedPosition == -1)
			{ 
				if (selectedPositionLastRun != -1)
				{
					for (int i=0; i < 8; i++)
						m_PositionBtns[i]->SetEnabled(true);

					m_fireBtn->SetEnabled(false);
					m_unassignBtn->SetEnabled(false);

					FALSEHover = -1;
				}
				selectedPositionLastRun = -1;

				title->Draw(g_game->GetBackBuffer());
				slogan->Draw(g_game->GetBackBuffer());
				directions->Draw(g_game->GetBackBuffer());
			}
			else
			{
				if (selectedPositionLastRun != selectedPosition)
				{	
					if (selectedPosition != 7 || (selectedPosition == 7 && selectedOfficer != NULL) )
					{
						if (selectedOfficer->GetOfficerType() != OFFICER_CAPTAIN)
						{
							//Turn all the Position buttons on, except the no position button and the captain button
							for (int i=0; i < 8; i++)
								m_PositionBtns[i]->SetEnabled(true);

							//Turn off only the ones that already have officers
							for (int i=0; i < (int)tOfficers.size(); i++)
							{
								if (tOfficers[i]->GetOfficerType() != OFFICER_NONE && tOfficers[i]->GetOfficerType()-1 != selectedPosition)
								{
									m_PositionBtns[tOfficers[i]->GetOfficerType()-1]->SetEnabled(false);
								}
							}

							FALSEHover = selectedPosition; //Set the FALSEhover for the selectedPosition
			
							if (selectedOfficer != NULL)
							{
								if (selectedOfficer->GetOfficerType() != OFFICER_CAPTAIN)
								{
									if (selectedOfficer->GetOfficerType() == OFFICER_NONE)
									{
										m_fireBtn->SetEnabled(true);
										m_unassignBtn->SetEnabled(false);
									}
									else
									{
										m_fireBtn->SetEnabled(false);
										m_unassignBtn->SetEnabled(true);
									}
								}
							}						
						}
						else
						{
							FALSEHover = selectedPosition; //Set the FALSEhover for the selectedPosition

							//Turn all the other Position buttons off,this prevents the Captain from ever moving
							for (int i=1; i < 8; i++)
								m_PositionBtns[i]->SetEnabled(false);		
						}
					}
					selectedPositionLastRun = selectedPosition;
				}
				
				
				m_fireBtn->Run(g_game->GetBackBuffer());
				m_unassignBtn->Run(g_game->GetBackBuffer());

				if (selectedOfficer != NULL)
					DrawOfficerInfo(selectedOfficer);
			}

			for (int i=0; i < 8; i++)
				m_PositionBtns[i]->Run(g_game->GetBackBuffer());
			
			m_exitBtn->Run(g_game->GetBackBuffer());
			m_hiremoreBtn->Run(g_game->GetBackBuffer());
			unassignedCrew->Draw(g_game->GetBackBuffer());

			for (int i=0; i < (int)tOfficers.size(); i++)
			{
				if (tOfficers[i]->GetOfficerType() != OFFICER_NONE)
					alfont_textout_ex(g_game->GetBackBuffer(), g_game->font24, tOfficers[i]->name.c_str(),CREWPOSITION_X, CREWPOSITION_Y +((tOfficers[i]->GetOfficerType()-1)*CREWSPACING), ((tOfficers[i]->GetOfficerType()-1) == selectedPosition ?  makecol(0,255,255) : makecol(255,255,255)), -1);
			}
#pragma endregion
			break;

		case UNEMPLOYEED_SCREEN:
#pragma region Unemployeed Screen
			//unemployeed->Draw(g_game->GetBackBuffer());

			unemployeedType->Draw(g_game->GetBackBuffer());

			m_backBtn->Run(g_game->GetBackBuffer());

			if (selectedOfficer != NULL)
			{
				stats->Draw(g_game->GetBackBuffer());

				m_hireBtn->Run(g_game->GetBackBuffer());	
				DrawOfficerInfo(selectedOfficer);
			}
			else
			{
				title->Draw(g_game->GetBackBuffer());
				slogan->Draw(g_game->GetBackBuffer());
				hiremoreDirections->Draw(g_game->GetBackBuffer());
			}
#pragma endregion
			break;

	}

	//DEBUG CODE -- do not delete
	//int y = 0;
    //g_game->PrintDefault(g_game->GetBackBuffer(), 750, y, "last spawn   : " + Util::ToString(lastEmployeeSpawn), BLACK);
	//y+=10;g_game->PrintDefault(g_game->GetBackBuffer(), 750, y, "current visit: " + Util::ToString(currentVisit), BLACK);
}

void ModuleCrewHire::DrawOfficerInfo(Officer *officer)
{
    static const string skillnames[] = {
        "science",
        "navigation",
        "engineering",
        "communication",
        "medical",
        "tactical",
        "learning",
        "durability" };

	draw_sprite(g_game->GetBackBuffer(), m_miniSkills, SKILLICONS_X, SKILLICONS_Y);

	stats->Draw(g_game->GetBackBuffer());

//draw names and skills
    ostringstream os;

//Print Captain jjh
	string offtitle = "Officer ";
	if (officer->GetOfficerType() == OFFICER_CAPTAIN) {
		offtitle = "Captain "; 
	}
	os << offtitle <<officer->getFirstName() << " " << officer->getLastName();
	g_game->Print22(g_game->GetBackBuffer(), SKILLBAR_X+70, SKILLBAR_Y-30, os.str(), WHITE);
	os.str(""); 

//find officer's highest skill jjh
	int tempi = 0; 	int tempval = 0;
	for (int i=0; i < 6; i++) {
		if (officer->attributes[i] > tempval) { 
			tempval = officer->attributes[i];
			tempi = i;
		}
	}

//print skill name and skill level JJH (using 2 prints in hopes of highlighting one of the skills & readabiltiy) jjh
	for (int i=0; i < 6; i++) {
        os << skillnames[i]; 
		g_game->Print22(g_game->GetBackBuffer(), SKILLBAR_X + 20, SKILLBAR_Y + (SKILLSPACING * i) + 2, os.str(), STEEL);
		os.str("");  
		os << officer->attributes[i];
		if (tempi != i) {
			g_game->Print22(g_game->GetBackBuffer(), SKILLBAR_X + 180, SKILLBAR_Y + (SKILLSPACING * i) + 2, os.str(), STEEL); }
		else {
			g_game->Print22(g_game->GetBackBuffer(), SKILLBAR_X + 180, SKILLBAR_Y + (SKILLSPACING * i) + 2, os.str(), RED); }
		os.str(""); 
	}
//print attribute name and level JJH (using 2 prints for readabiltiy) jjh
	for (int i=6; i < 8; i++) {
		os << skillnames[i];
		g_game->Print22(g_game->GetBackBuffer(), SKILLBAR_X + 20, SKILLBAR_Y + (SKILLSPACING * i) + 2, os.str(), STEEL);
		os.str("");
		os << officer->attributes[i];
		g_game->Print22(g_game->GetBackBuffer(), SKILLBAR_X + 180, SKILLBAR_Y + (SKILLSPACING * i) + 2, os.str(), STEEL);
		os.str(""); 
	}
}

void ModuleCrewHire::RefreshUnassignedCrewBox()
{
	unassignedCrew->Clear();

	for (int i=0; i < (int)tOfficers.size(); i++)
	{
		if (tOfficers[i]->GetOfficerType() == OFFICER_NONE)
		{
			coloredString.String = tOfficers[i]->name;
			unassignedCrew->Write(coloredString);
		}
	}
	unassignedCrew->OnMouseMove(unassignedCrew->GetX(),unassignedCrew->GetY());
	unassignedCrew->OnMouseMove(0,0);
}

void ModuleCrewHire::RefreshUnemployeedCrewBox()
{
	unemployeedType->Clear();

	for (int i=0; i < (int)g_game->gameState->m_unemployedOfficers.size(); i++)
	{
		coloredString.String = g_game->gameState->m_unemployedOfficers[i]->name;
		unemployeed->Write(coloredString);

		coloredString.String = g_game->gameState->m_unemployedOfficers[i]->GetPreferredProfession();
		unemployeedType->Write(coloredString);
	}
	unemployeedType->OnMouseMove(unemployeedType->GetX(),unemployeedType->GetY());
	unemployeedType->OnMouseMove(0,0);
}
