/*
	STARFLIGHT - THE LOST COLONY
	ModuleControlPabel.cpp
	Author: coder1024
	Date: April, 07
*/

#include "env.h"
#include "ModuleControlPanel.h"
#include "AudioSystem.h"
#include "Events.h"
#include "ModeMgr.h"
#include "GameState.h"
#include "Game.h"

using namespace std;

#define COMMAND_BUTTON_BG_BMP            0        /* BMP  */
#define COMMAND_BUTTON_BG_DISABLED_BMP   1        /* BMP  */
#define COMMAND_BUTTON_BG_MO_BMP         2        /* BMP  */
#define COMMAND_BUTTON_BG_SELECT_BMP     3        /* BMP  */
#define COMMANDICON_CAPTAIN_CARGO_BMP    4        /* BMP  */
#define COMMANDICON_CAPTAIN_DESCEND_BMP  5        /* BMP  */
#define COMMANDICON_CAPTAIN_DISEMBARK_BMP 6        /* BMP  */
#define COMMANDICON_CAPTAIN_LAUNCH_BMP   7        /* BMP  */
#define COMMANDICON_CAPTAIN_LOGPLANET_BMP 8        /* BMP  */
#define COMMANDICON_COM_DISTRESS_BMP     9        /* BMP  */
#define COMMANDICON_COM_HAIL_BMP         10       /* BMP  */
#define COMMANDICON_COM_POSTURE_BMP      11       /* BMP  */
#define COMMANDICON_COM_QUESTION_BMP     12       /* BMP  */
#define COMMANDICON_COM_QUESTLOG_BMP     13       /* BMP  */
#define COMMANDICON_COM_RESPOND_BMP      14       /* BMP  */
#define COMMANDICON_COM_STATEMENT_BMP    15       /* BMP  */
#define COMMANDICON_COM_TERMINATE_BMP    16       /* BMP  */
#define COMMANDICON_ENG_DAMAGE_BMP       17       /* BMP  */
#define COMMANDICON_ENG_REPAIR_BMP       18       /* BMP  */
#define COMMANDICON_MED_EXAMINE_BMP      19       /* BMP  */
#define COMMANDICON_MED_TREAT_BMP        20       /* BMP  */
#define COMMANDICON_NAV_DOCK_BMP         21       /* BMP  */
#define COMMANDICON_NAV_HYPERSPACE_BMP   22       /* BMP  */
#define COMMANDICON_NAV_MANEUVER_BMP     23       /* BMP  */
#define COMMANDICON_NAV_ORBIT_BMP        24       /* BMP  */
#define COMMANDICON_NAV_STARMAP_BMP      25       /* BMP  */
#define COMMANDICON_SCIENCE_ANALYSIS_BMP 26       /* BMP  */
#define COMMANDICON_SCIENCE_SCAN_BMP     27       /* BMP  */
#define COMMANDICON_TAC_COMBAT_BMP       28       /* BMP  */
#define COMMANDICON_TAC_SHIELDS_BMP      29       /* BMP  */
#define COMMANDICON_TAC_WEAPONS_BMP      30       /* BMP  */
#define CP_CAPTAIN_MO_BMP                31       /* BMP  */
#define CP_CAPTAIN_SELECT_BMP            32       /* BMP  */
#define CP_COMM_MO_BMP                   33       /* BMP  */
#define CP_COMM_SELECT_BMP               34       /* BMP  */
#define CP_ENGINEER_MO_BMP               35       /* BMP  */
#define CP_ENGINEER_SELECT_BMP           36       /* BMP  */
#define CP_MEDICAL_MO_BMP                37       /* BMP  */
#define CP_MEDICAL_SELECT_BMP            38       /* BMP  */
#define CP_NAVIGATION_MO_BMP             39       /* BMP  */
#define CP_NAVIGATION_SELECT_BMP         40       /* BMP  */
#define CP_SCIENCE_MO_BMP                41       /* BMP  */
#define CP_SCIENCE_SELECT_BMP            42       /* BMP  */
#define CP_TACTICAL_MO_BMP               43       /* BMP  */
#define CP_TACTICAL_SELECT_BMP           44       /* BMP  */
//#define GUI_CONTROLPANEL_BMP             45       /* BMP  */

DATAFILE *cpdata = NULL;


int CMDBUTTONS_UL_X;
int CMDBUTTONS_UL_Y;
int OFFICERICON_UL_X;
int OFFICERICON_UL_Y;



#define TRANSPARENTCLR makecol(255,0,255)
#define CMDBUTTON_SPACING 0

ModuleControlPanel::ModuleControlPanel(void)
{
	controlPanelBackgroundImg = NULL;
	mouseOverOfficer = NULL;
	selectedOfficer = NULL;
	mouseOverCommand = NULL;
	selectedCommand = NULL;
	bEnabled = true;
}

ModuleControlPanel::~ModuleControlPanel(void){}

bool ModuleControlPanel::Init()
{
	//load the control panel datafile
	cpdata = load_datafile("data/controlpanel/controlpanel.dat");
	if (!cpdata) {
		g_game->message("ControlPanel: Error loading datafile");
		return false;
	}
	
	
	static int bx = (int)g_game->getGlobalNumber("GUI_CONTROLPANEL_POS_X");
	static int by = (int)g_game->getGlobalNumber("GUI_CONTROLPANEL_POS_Y");
	CMDBUTTONS_UL_X = bx + 18;
	CMDBUTTONS_UL_Y = by + 242;
	OFFICERICON_UL_X = bx + 45;
	OFFICERICON_UL_Y = by + 157;
	

	//load background image
	//controlPanelBackgroundImg = load_bitmap(CONTROLPANELBACKGROUNDIMG_FILE,NULL);
	controlPanelBackgroundImg = (BITMAP *)load_bitmap("data/controlpanel/GUI_CONTROLPANEL.BMP",NULL);
	if (controlPanelBackgroundImg == NULL) {
		g_game->message("Error loading controlpanel background");
		return false;
	}

	const int officerIconWidth = 40;
	const int officerIconHeight = 40;
	int officerIconX = OFFICERICON_UL_X;
	int officerIconY = OFFICERICON_UL_Y;

	if (!CommandButton::InitCommon())
		return false;

	if (!OfficerButton::InitCommon())
		return false;

	//reusable button object
	CommandButton* cbtn;

	/*
	* CAPTAIN
	*/
	OfficerButton *captainBtn;
	captainBtn = new OfficerButton(*this,OFFICER_CAPTAIN,CP_CAPTAIN_MO_BMP,CP_CAPTAIN_SELECT_BMP,officerIconX,officerIconY);

		selectedOfficer = captainBtn;
		officerButtons.push_back(captainBtn);

		int cix = CMDBUTTONS_UL_X;
		int ciy = CMDBUTTONS_UL_Y;

		//LAUNCH BUTTON
		cbtn = new CommandButton(*this, COMMANDICON_CAPTAIN_LAUNCH_BMP, "Break orbit", cix,ciy);
		cbtn->setEventID(EVENT_CAPTAIN_LAUNCH);
		captainBtn->commandButtons.push_back(cbtn);

		//DESCEND BUTTON
		cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_CAPTAIN_DESCEND_BMP, "Descend to surface", cix,ciy);
		cbtn->setEventID(EVENT_CAPTAIN_DESCEND);
		captainBtn->commandButtons.push_back(cbtn);

		//CARGO HOLD BUTTON
		cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_CAPTAIN_CARGO_BMP, "Cargo hold", cix,ciy);
		cbtn->setEventID(EVENT_CAPTAIN_CARGO);
		captainBtn->commandButtons.push_back(cbtn);

		//LOG PLANET BUTTON
		//cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		//cbtn = new CommandButton(*this, COMMANDICON_CAPTAIN_LOGPLANET_BMP, "Log planet", cix,ciy);
		//cbtn->setEventID(EVENT_CAPTAIN_LOG);
		//captainBtn->commandButtons.push_back(cbtn);

		//QUESTLOG BUTTON
		cix = CMDBUTTONS_UL_X;
		ciy += CommandButton::GetCommonHeight() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_COM_QUESTLOG_BMP, "Quest log", cix,ciy);
		cbtn->setEventID(EVENT_CAPTAIN_QUESTLOG);
		captainBtn->commandButtons.push_back(cbtn);

	/*
	* SCIENCE OFFICER
	*/
	officerIconX += officerIconWidth;
	OfficerButton *scienceBtn = new OfficerButton(*this, OFFICER_SCIENCE,CP_SCIENCE_MO_BMP,CP_SCIENCE_SELECT_BMP,officerIconX,officerIconY);
	officerButtons.push_back(scienceBtn);

		cix = CMDBUTTONS_UL_X;
		ciy = CMDBUTTONS_UL_Y;

		//SCAN BUTTON
		cbtn = new CommandButton(*this, COMMANDICON_SCIENCE_SCAN_BMP, "Sensor scan", cix,ciy);
		cbtn->setEventID(EVENT_SCIENCE_SCAN);
		scienceBtn->commandButtons.push_back(cbtn);

		//ANALYSIS BUTTON
		cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_SCIENCE_ANALYSIS_BMP, "Sensor analysis", cix,ciy);
		cbtn->setEventID(EVENT_SCIENCE_ANALYSIS);
		scienceBtn->commandButtons.push_back(cbtn);

	/*
	* NAVIGATOR
	*/
	officerIconX += officerIconWidth;
	OfficerButton *navBtn = new OfficerButton(*this, OFFICER_NAVIGATION,CP_NAVIGATION_MO_BMP,CP_NAVIGATION_SELECT_BMP,officerIconX,officerIconY);
	officerButtons.push_back(navBtn);

		cix = CMDBUTTONS_UL_X;
		ciy = CMDBUTTONS_UL_Y;

		//ORBIT BUTTON
		cbtn = new CommandButton(*this, COMMANDICON_NAV_ORBIT_BMP, "Orbit planet", cix,ciy);
		cbtn->setEventID(EVENT_NAVIGATOR_ORBIT);
		navBtn->commandButtons.push_back(cbtn);

		//STARPORT DOCK BUTTON
		cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_NAV_DOCK_BMP, "Dock with Starport", cix,ciy);
		cbtn->setEventID(EVENT_NAVIGATOR_DOCK);
		navBtn->commandButtons.push_back(cbtn);

		//HYPERSPACE ENGINE BUTTON
		cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_NAV_HYPERSPACE_BMP, "Hyperspace engine", cix,ciy);
		cbtn->setEventID(EVENT_NAVIGATOR_HYPERSPACE);
		navBtn->commandButtons.push_back(cbtn);

		//STARMAP BUTTON
		cix = CMDBUTTONS_UL_X;
		ciy += CommandButton::GetCommonHeight() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_NAV_STARMAP_BMP, "Starmap", cix,ciy);
		cbtn->setEventID(EVENT_NAVIGATOR_STARMAP);
		navBtn->commandButtons.push_back(cbtn);


	/*
	* TACTICAL
	*/
	officerIconX += officerIconWidth;
	OfficerButton *tacBtn = new OfficerButton(*this,OFFICER_TACTICAL,CP_TACTICAL_MO_BMP,CP_TACTICAL_SELECT_BMP,officerIconX,officerIconY);
	officerButtons.push_back(tacBtn);

		cix = CMDBUTTONS_UL_X;
		ciy = CMDBUTTONS_UL_Y;

		//SHIELDS BUTTON
		cbtn = new CommandButton(*this, COMMANDICON_TAC_SHIELDS_BMP, "Raise/Lower Shields", cix,ciy);
		cbtn->setEventID(EVENT_TACTICAL_SHIELDS);
		tacBtn->commandButtons.push_back(cbtn);

		//WEAPONS BUTTON
		cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_TAC_WEAPONS_BMP, "Arm/Disarm Weapons", cix,ciy);
		cbtn->setEventID(EVENT_TACTICAL_WEAPONS);
		tacBtn->commandButtons.push_back(cbtn);

	/*
	* ENGINEER
	*/
	officerIconX = OFFICERICON_UL_X;
	officerIconY = OFFICERICON_UL_Y + officerIconHeight;
	OfficerButton *engBtn = new OfficerButton(*this,OFFICER_ENGINEER,CP_ENGINEER_MO_BMP,CP_ENGINEER_SELECT_BMP,officerIconX,officerIconY);
	officerButtons.push_back(engBtn);

		cix = CMDBUTTONS_UL_X;
		ciy = CMDBUTTONS_UL_Y;

		//REPAIR BUTTON
		//cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_ENG_REPAIR_BMP, "Repair systems", cix,ciy);
		cbtn->setEventID(EVENT_ENGINEER_REPAIR);
		engBtn->commandButtons.push_back(cbtn);

		//INJECT FUEL BUTTON
		cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_COM_RESPOND_BMP, "Inject fuel", cix, ciy);
		cbtn->setEventID(EVENT_ENGINEER_INJECT);
		engBtn->commandButtons.push_back(cbtn);

	/*
	* COMMUNICATIONS
	*/
	officerIconX += officerIconWidth;
	OfficerButton *comBtn = new OfficerButton(*this,OFFICER_COMMUNICATION,CP_COMM_MO_BMP,CP_COMM_SELECT_BMP,officerIconX,officerIconY);
	officerButtons.push_back(comBtn);

		cix = CMDBUTTONS_UL_X;
		ciy = CMDBUTTONS_UL_Y;

		//HAIL BUTTON
		cbtn = new CommandButton(*this, COMMANDICON_COM_HAIL_BMP, "Hail or respond", cix,ciy);
		cbtn->setEventID(EVENT_COMM_HAIL);
		comBtn->commandButtons.push_back(cbtn);

		//QUESTION BUTTON
		cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_COM_QUESTION_BMP, "Ask a question", cix,ciy);
		cbtn->setEventID(EVENT_COMM_QUESTION);
		comBtn->commandButtons.push_back(cbtn);

		//STATEMENT BUTTON
		//cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		//cbtn = new CommandButton(*this, COMMANDICON_COM_STATEMENT_BMP, "Make a statement", cix,ciy);
		//cbtn->setEventID(EVENT_COMM_STATEMENT);
		//comBtn->commandButtons.push_back(cbtn);

		//POSTURE BUTTON
		cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_COM_POSTURE_BMP, "Change posture", cix,ciy);
		cbtn->setEventID(EVENT_COMM_POSTURE);
		comBtn->commandButtons.push_back(cbtn);

		//TERMINATE BUTTON
		cix = CMDBUTTONS_UL_X;
		ciy += CommandButton::GetCommonHeight() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_COM_TERMINATE_BMP, "End communication", cix,ciy);
		cbtn->setEventID(EVENT_COMM_TERMINATE);
		comBtn->commandButtons.push_back(cbtn);

		//DISTRESS BUTTON
		cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_COM_DISTRESS_BMP, "Send distress signal", cix,ciy);
		cbtn->setEventID(EVENT_COMM_DISTRESS);
		comBtn->commandButtons.push_back(cbtn);

	/*
	* MEDICAL
	*/
	officerIconX += officerIconWidth;
	OfficerButton *medBtn = new OfficerButton(*this,OFFICER_MEDICAL,CP_MEDICAL_MO_BMP,CP_MEDICAL_SELECT_BMP,officerIconX,officerIconY);
	officerButtons.push_back(medBtn);

		cix = CMDBUTTONS_UL_X;
		ciy = CMDBUTTONS_UL_Y;

		//EXAMINE BUTTON
		cbtn = new CommandButton(*this, COMMANDICON_MED_EXAMINE_BMP, "Examine crew", cix,ciy);
		cbtn->setEventID(EVENT_DOCTOR_EXAMINE);
		medBtn->commandButtons.push_back(cbtn);

		//TREAT BUTTON
		cix += CommandButton::GetCommonWidth() + CMDBUTTON_SPACING;
		cbtn = new CommandButton(*this, COMMANDICON_MED_TREAT_BMP, "Treat crew", cix,ciy);
		cbtn->setEventID(EVENT_DOCTOR_TREAT);
		medBtn->commandButtons.push_back(cbtn);



	//do something with the buttons
	for (vector<OfficerButton*>::iterator i = officerButtons.begin(); i != officerButtons.end(); ++i)
	{
		OfficerButton *officerButton = *i;

		if (officerButton == NULL)
			return false;

		if (!officerButton->InitButton())
			return false;
	}

	//load audio files
	sndOfficerSelected = g_game->audioSystem->Load("data/controlpanel/officer_selected.ogg");
	if (!sndOfficerSelected) {
		g_game->message("ControlPanel: Error loading officer_selected");
		return false;
	}

	sndOfficerCommandSelected = g_game->audioSystem->Load("data/controlpanel/officer_command_selected.ogg");
	if (!sndOfficerCommandSelected) {
		g_game->message("ControlPanel: Error loading officer_command_selected");
		return false;
	}

	return true;
}


void ModuleControlPanel::SetButton(int ButtonID, bool enabled)
{
	for (vector<CommandButton*>::iterator i = selectedOfficer->commandButtons.begin(); i != selectedOfficer->commandButtons.end(); ++i)
	{
		CommandButton* button = *i;
		if (button->getEventID() == ButtonID) 
		{
			button->SetEnabled(enabled);
		}
	}
}


void ModuleControlPanel::Update()
{
	Module::Update();

	/**
	 * Set gameState variable to keep track of currently selected officer
	 * this is needed by the Status Window module, among other places.
	**/
	if (selectedOfficer != NULL)
		g_game->gameState->setCurrentSelectedOfficer(selectedOfficer->GetOfficerType());
}

void ModuleControlPanel::Draw()
{
	if (g_game->gameState->getCurrentModule() == MODULE_ENCOUNTER &&
		g_game->doShowControls() == false)
			return;
	
	static int lastMode = 0;

	//set CP buttons when mode change takes place
	if (g_game->gameState->player->controlPanelMode != lastMode) {
		lastMode = g_game->gameState->player->controlPanelMode;
		//this->ToggleButtons();
	}	

	// render CP background with transparency
	static int gcpx = (int)g_game->getGlobalNumber("GUI_CONTROLPANEL_POS_X");
	static int gcpy = (int)g_game->getGlobalNumber("GUI_CONTROLPANEL_POS_Y");
	if (controlPanelBackgroundImg)
		masked_blit(controlPanelBackgroundImg, g_game->GetBackBuffer(), 0,0,
			gcpx, gcpy, controlPanelBackgroundImg->w, controlPanelBackgroundImg->h);

	// render command buttons for the selected officer
	if (selectedOfficer != NULL)
	{
		for (vector<CommandButton*>::iterator i = selectedOfficer->commandButtons.begin(); i != selectedOfficer->commandButtons.end(); ++i)
		{
			CommandButton *commandButton = *i;

			if (commandButton->GetEnabled()) 
			{
			if (selectedCommand == commandButton)
			{
				commandButton->RenderSelected(g_game->GetBackBuffer());
			}
			else if (mouseOverCommand == commandButton)
			{
				commandButton->RenderMouseOver(g_game->GetBackBuffer());
			}
			else
			{
				commandButton->RenderPlain(g_game->GetBackBuffer());
			}
			}
			else
			{
			commandButton->RenderDisabled(g_game->GetBackBuffer());
			}
		}
	}

	// render officer buttons
	for (vector<OfficerButton*>::iterator i = officerButtons.begin(); i != officerButtons.end(); ++i)
	{
		OfficerButton *officerButton = *i;

	
		if (officerButton == selectedOfficer)
		{
			officerButton->RenderSelected(g_game->GetBackBuffer());
		}
		else if (officerButton == mouseOverOfficer)
		{
			officerButton->RenderMouseOver(g_game->GetBackBuffer());
		}
		else
		{
		if (officerButton->imgMouseOver)
			blit(officerButton->imgMouseOver,g_game->GetBackBuffer(),0,0,officerButton->posX, officerButton->posY, officerButton->imgMouseOver->w, officerButton->imgMouseOver->h);
		}
	}
}

void ModuleControlPanel::Close()
{
	//Module::Close();

	try {

        destroy_bitmap(controlPanelBackgroundImg);


		for (vector<OfficerButton*>::iterator i = officerButtons.begin(); i != officerButtons.end(); ++i)
		{
			if (*i != NULL)
			{
				(*i)->DestroyButton();
				delete *i;
			}
		}
		officerButtons.clear();

		CommandButton::DestroyCommon();
		OfficerButton::DestroyCommon();

		if (sndOfficerSelected != NULL)
		{
			sndOfficerSelected = NULL;
		}

		if (sndOfficerCommandSelected != NULL)
		{
			sndOfficerCommandSelected = NULL;
		}

		selectedOfficer = NULL;
		
		
		//unload the data file (thus freeing all resources at once)
		unload_datafile(cpdata);
		cpdata = NULL;	
	}
	catch (std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in ControlPanel::Close\n");
	}
}

#pragma region INPUT
void ModuleControlPanel::OnKeyPress(int keyCode){}
void ModuleControlPanel::OnKeyPressed(int keyCode){}

void ModuleControlPanel::OnKeyReleased(int keyCode)
{
	Module::OnKeyReleased(keyCode);
	switch (keyCode) {
		case KEY_F1: //select the captain
			g_game->gameState->setCurrentSelectedOfficer(OFFICER_CAPTAIN);
			for (vector<OfficerButton*>::iterator i = officerButtons.begin(); i != officerButtons.end(); ++i){
				OfficerButton *officerButton = *i;
				if(officerButton->GetOfficerType() == OFFICER_CAPTAIN){
					//change the officer
					selectedOfficer = officerButton;
					break;
				}	
			}
			break;
		case KEY_F2: //select the science officer
			g_game->gameState->setCurrentSelectedOfficer(OFFICER_SCIENCE);
			for (vector<OfficerButton*>::iterator i = officerButtons.begin(); i != officerButtons.end(); ++i){
				OfficerButton *officerButton = *i;
				if(officerButton->GetOfficerType() == OFFICER_SCIENCE){
					//change the officer
					selectedOfficer = officerButton;
					break;
				}	
			}
			break;
		case KEY_F3: //select the navigator
			g_game->gameState->setCurrentSelectedOfficer(OFFICER_NAVIGATION);
			for (vector<OfficerButton*>::iterator i = officerButtons.begin(); i != officerButtons.end(); ++i){
				OfficerButton *officerButton = *i;
				if(officerButton->GetOfficerType() == OFFICER_NAVIGATION){
					//change the officer
					selectedOfficer = officerButton;
					break;
				}	
			}
			break;
		case KEY_F4: //select the tactician
			g_game->gameState->setCurrentSelectedOfficer(OFFICER_TACTICAL);
			for (vector<OfficerButton*>::iterator i = officerButtons.begin(); i != officerButtons.end(); ++i){
				OfficerButton *officerButton = *i;
				if(officerButton->GetOfficerType() == OFFICER_TACTICAL){
					//change the officer
					selectedOfficer = officerButton;
					break;
				}	
			}
			break;
		case KEY_F5: //select the engineer
			g_game->gameState->setCurrentSelectedOfficer(OFFICER_ENGINEER);
			for (vector<OfficerButton*>::iterator i = officerButtons.begin(); i != officerButtons.end(); ++i){
				OfficerButton *officerButton = *i;
				if(officerButton->GetOfficerType() == OFFICER_ENGINEER){
					//change the officer
					selectedOfficer = officerButton;
					break;
				}	
			}
			break;
		case KEY_F6: //select the comms officer
			g_game->gameState->setCurrentSelectedOfficer(OFFICER_COMMUNICATION);
			for (vector<OfficerButton*>::iterator i = officerButtons.begin(); i != officerButtons.end(); ++i){
				OfficerButton *officerButton = *i;
				if(officerButton->GetOfficerType() == OFFICER_COMMUNICATION){
					//change the officer
					selectedOfficer = officerButton;
					break;
				}	
			}
			break;
		case KEY_F7: //select the doctor
			g_game->gameState->setCurrentSelectedOfficer(OFFICER_MEDICAL);
			for (vector<OfficerButton*>::iterator i = officerButtons.begin(); i != officerButtons.end(); ++i){
				OfficerButton *officerButton = *i;
				if(officerButton->GetOfficerType() == OFFICER_MEDICAL){
					//change the officer
					selectedOfficer = officerButton;
					break;
				}	
			}
			break;

		case KEY_M: // "map" button
			g_game->gameState->setCurrentSelectedOfficer(OFFICER_NAVIGATION);
			for (vector<OfficerButton*>::iterator i = officerButtons.begin(); i != officerButtons.end(); ++i){
				OfficerButton *officerButton = *i;
				if(officerButton->GetOfficerType() == OFFICER_NAVIGATION){
					//change the officer
					selectedOfficer = officerButton;
					break;
				}
			}
			Event e(EVENT_NAVIGATOR_STARMAP);
			g_game->modeMgr->BroadcastEvent(&e);
			break;

	}
}

void ModuleControlPanel::OnMouseMove(int x, int y)
{
	Module::OnMouseMove(x,y);

	// look for officer button mouse over
	mouseOverOfficer = NULL;
	for (vector<OfficerButton*>::iterator i = officerButtons.begin(); (i != officerButtons.end()) && (mouseOverOfficer == NULL); ++i)
	{
		OfficerButton *officerButton = *i;

		if (officerButton->IsInButton(x,y))
		{
			mouseOverOfficer = officerButton;
		}
	}

	// look for command button mouse over
	mouseOverCommand = NULL;
	if (selectedOfficer != NULL)
	{
		for (vector<CommandButton*>::iterator i = selectedOfficer->commandButtons.begin(); i != selectedOfficer->commandButtons.end(); ++i)
		{
			CommandButton *commandButton = *i;

			if (commandButton->IsInButton(x,y))
			{
			mouseOverCommand = commandButton;
			}
		}
	}
}

void ModuleControlPanel::OnMouseClick(int button, int x, int y)
{
	Module::OnMouseClick(button,x,y);
}

void ModuleControlPanel::OnMousePressed(int button, int x, int y)
{
	Module::OnMousePressed(button, x, y);

	if (button != 0)
		return;

	// select officer
	for (vector<OfficerButton*>::iterator i = officerButtons.begin(); i != officerButtons.end(); ++i)
	{
		OfficerButton *officerButton = *i;

		if (officerButton->IsInButton(x,y))
		{
			//change the officer
			selectedOfficer = officerButton;

			//enable command buttons
			//this->ToggleButtons();

			//play sound
			g_game->audioSystem->Play(sndOfficerSelected);

			break;
		}
	}
//jjh - maybe here to force navigator when entering hyperspace
	// set command to pressed
	if (selectedOfficer != NULL)
	{
		for (vector<CommandButton*>::iterator i = selectedOfficer->commandButtons.begin(); i != selectedOfficer->commandButtons.end(); ++i)
		{
			CommandButton *commandButton = *i;

			if (commandButton->IsInButton(x,y) && commandButton->GetEnabled())
			{
			selectedCommand = commandButton;

			g_game->audioSystem->Play(sndOfficerCommandSelected);
			}
		}
	}

}

void ModuleControlPanel::OnMouseReleased(int button, int x, int y)
{
	Module::OnMouseReleased(button, x, y);

	//launch event based on button ID so all modules in this mode will be notified
	if ( selectedCommand ){
		Event e(selectedCommand->getEventID());
		g_game->modeMgr->BroadcastEvent(&e);
	}

	selectedCommand = NULL;
}

void ModuleControlPanel::OnMouseWheelUp(int x, int y)
{
	Module::OnMouseWheelUp(x, y);
}

void ModuleControlPanel::OnMouseWheelDown(int x, int y)
{
	Module::OnMouseWheelDown(x, y);
}

#pragma endregion


void ModuleControlPanel::OnEvent(Event * event){}


#pragma region COMMANDBUTTON
//******************************************************************************
// CommandButton
//******************************************************************************

#define CMDBUTTON_LABEL_CLR			makecol(0,0,0)

BITMAP* ModuleControlPanel::CommandButton::imgBackground = NULL;
BITMAP* ModuleControlPanel::CommandButton::imgBackgroundDisabled = NULL;
BITMAP* ModuleControlPanel::CommandButton::imgBackgroundMouseOver = NULL;
BITMAP* ModuleControlPanel::CommandButton::imgBackgroundSelected = NULL;

ModuleControlPanel::CommandButton::CommandButton(ModuleControlPanel& outer, int datFileCmdIcon, std::string cmdName, int posX, int posY)
: outer(outer)
{
	this->datFileCmdIcon = datFileCmdIcon;
	this->cmdName = cmdName;
	this->posX = posX;
	this->posY = posY;
	this->imgCmdIcon = NULL;
	this->enabled = true;
}

ModuleControlPanel::CommandButton::~CommandButton()
{
}

bool ModuleControlPanel::CommandButton::InitCommon()
{
	//imgBackground = load_bitmap(CMDBUTTON_BGFILE,NULL);
	imgBackground = (BITMAP*)cpdata[COMMAND_BUTTON_BG_BMP].dat;
	if (imgBackground == NULL) {
		g_game->message("Error in control panel");
		return false;
	}

	//imgBackgroundDisabled = load_bitmap(CMDBUTTON_BGFILE_DISABLED,NULL);
	imgBackgroundDisabled = (BITMAP*)cpdata[COMMAND_BUTTON_BG_DISABLED_BMP].dat;
	if (imgBackgroundDisabled == NULL) {
		g_game->message("Error in control panel");
		return false;
	}

	//imgBackgroundMouseOver = load_bitmap(CMDBUTTON_BGFILE_MOUSEOVER,NULL);
	imgBackgroundMouseOver = (BITMAP*)cpdata[COMMAND_BUTTON_BG_MO_BMP].dat;
	if (imgBackgroundMouseOver == NULL) {
		g_game->message("Error in control panel");
		return false;
	}

	//imgBackgroundSelected = load_bitmap(CMDBUTTON_BGFILE_SELECT,NULL);
	imgBackgroundSelected = (BITMAP*)cpdata[COMMAND_BUTTON_BG_SELECT_BMP].dat;
	if (imgBackgroundSelected == NULL) {
		g_game->message("Error in control panel");
		return false;
	}

	return true;
}

int ModuleControlPanel::CommandButton::GetCommonWidth()
{
	return imgBackground->w;
}

int ModuleControlPanel::CommandButton::GetCommonHeight()
{
	return imgBackground->h;
}

bool ModuleControlPanel::CommandButton::InitButton()
{
	//imgCmdIcon = load_bitmap(imgFileCmdIcon.c_str(),NULL);
	imgCmdIcon = (BITMAP*) cpdata[datFileCmdIcon].dat;
	if (imgCmdIcon == NULL) {
		g_game->message("Error in control panel");
		return false;
	}

	return true;
}

void ModuleControlPanel::CommandButton::DestroyButton()
{

	if (imgCmdIcon != NULL)
	{

		//now handled by the datafile
		//destroy_bitmap(imgCmdIcon);

		imgCmdIcon = NULL;
	}
}

void ModuleControlPanel::CommandButton::DestroyCommon()
{
	//now handled by the datafile
	
	/*if (imgBackground != NULL)
	{
		destroy_bitmap(imgBackground);
		imgBackground = NULL;
	}

	if (imgBackgroundDisabled != NULL)
	{
		destroy_bitmap(imgBackgroundDisabled);
		imgBackgroundDisabled = NULL;
	}

	if (imgBackgroundMouseOver != NULL)
	{
		destroy_bitmap(imgBackgroundMouseOver);
		imgBackgroundMouseOver = NULL;
	}

	if (imgBackgroundSelected != NULL)
	{
		destroy_bitmap(imgBackgroundSelected);
		imgBackgroundSelected = NULL;
	}*/

}

void ModuleControlPanel::CommandButton::RenderPlain(BITMAP* canvas)
{
	Render(canvas,imgBackground);
}

void ModuleControlPanel::CommandButton::RenderDisabled(BITMAP* canvas)
{
	Render(canvas,imgBackgroundDisabled);
}

void ModuleControlPanel::CommandButton::RenderMouseOver(BITMAP* canvas)
{
	Render(canvas,imgBackgroundMouseOver);

	static int x = 40 + (int)g_game->getGlobalNumber("GUI_CONTROLPANEL_POS_X"); 
	static int y = 115 + (int)g_game->getGlobalNumber("GUI_CONTROLPANEL_POS_Y"); 
	g_game->Print18(canvas, x + 5, y, cmdName.c_str(), WHITE);
	
}

void ModuleControlPanel::CommandButton::RenderSelected(BITMAP* canvas)
{
	Render(canvas,imgBackgroundSelected, true);
}

bool ModuleControlPanel::CommandButton::IsInButton(int x, int y)
{
	if ((x >= posX) && (x < posX+imgBackground->w) &&
		(y >= posY) && (y < posY+imgBackground->h))
	{
		return true;
	}

	return false;
}

void ModuleControlPanel::CommandButton::SetEnabled(bool enabled)
{
	this->enabled = enabled;
}

bool ModuleControlPanel::CommandButton::GetEnabled()
{
	return enabled;
}

void ModuleControlPanel::CommandButton::Render(BITMAP *canvas, BITMAP *imgBackground, bool down)
{
	// draw button background and command icon image
	blit(imgBackground,canvas,0,0,posX,posY,imgBackground->w,imgBackground->h);
	
	if (down)
		masked_blit(imgCmdIcon,canvas,0,0,posX,posY,imgCmdIcon->w,imgCmdIcon->h);
	else
		masked_blit(imgCmdIcon,canvas,0,2,posX,posY,imgCmdIcon->w,imgCmdIcon->h);

}

#pragma endregion


#pragma region OFFICERBUTTON

//******************************************************************************
// OfficerButton
//******************************************************************************

//BITMAP *ModuleControlPanel::OfficerButton::imgTipWindowBackground = NULL;

#define OFFICER_MOUSEOVERTIP_SPACEFROMBTN_X		3
#define OFFICER_MOUSEOVERTIP_SPACEFROMBTN_Y		0
#define OFFICER_MOUSEOVERTIP_BORDER_THICKNESS	2
#define OFFICER_MOUSEOVERTIP_BORDER_CLR			makecol(0,0,0)
#define OFFICER_MOUSEOVERTIP_BACKGROUND_CLR		makecol(200,200,200)
#define OFFICER_MOUSEOVERTIP_TEXT_CLR			makecol(255,255,0)
#define OFFICER_MOUSEOVERTIP_INNER_SPACING		5
#define OFFICER_MOUSEOVERTIP_BAR_HEIGHT			10
#define OFFICER_MOUSEOVERTIP_HEALTH_CLR			makecol(255,0,0)
#define OFFICER_MOUSEOVERTIP_LABEL_CLR			makecol(255,255,255)
#define OFFICER_MOUSEOVERTIP_TEXTOFFSET_X		6
#define OFFICER_MOUSEOVERTIP_TEXTOFFSET_Y		6

ModuleControlPanel::OfficerButton::OfficerButton(ModuleControlPanel& outer, OfficerType officerType, int datFileMouseOver, int datFileSelected, int posX, int posY)
: outer(outer)
{
	this->officerType = officerType;
	this->datFileMouseOver = datFileMouseOver;
	this->datFileSelected = datFileSelected;
	this->posX = posX;
	this->posY = posY;
	this->imgMouseOver = NULL;
	this->imgSelected = NULL;
}

ModuleControlPanel::OfficerButton::~OfficerButton()
{
}

bool ModuleControlPanel::OfficerButton::InitCommon()
{
	//imgTipWindowBackground = load_bitmap(OFFICER_MOUSEOVERTIP_BACKGROUNDIMG,NULL);
	//if (imgTipWindowBackground == NULL)
	//	return false;

	return true;
}

bool ModuleControlPanel::OfficerButton::InitButton()
{
	//imgMouseOver = load_bitmap(imgFileMouseOver.c_str(),NULL);
	imgMouseOver = (BITMAP*)cpdata[datFileMouseOver].dat;
	if (imgMouseOver == NULL) {
		g_game->message("Error in control panel");
		return false;
	}

	//imgSelected = load_bitmap(imgFileSelected.c_str(),NULL);
	imgSelected = (BITMAP*)cpdata[datFileSelected].dat;
	if (imgSelected == NULL) {
		g_game->message("Error in control panel");
		return false;
	}

	for (vector<CommandButton*>::iterator i = commandButtons.begin(); i != commandButtons.end(); ++i)
	{
		CommandButton* commandButton = *i;

		if (commandButton == NULL)
			return false;

		if (!commandButton->InitButton())
			return false;
	}

	return true;
}

void ModuleControlPanel::OfficerButton::RenderMouseOver(BITMAP *canvas)
{
	std::string name = "Unknown Officer";
	std::string title = "Unknown Title";
	Officer* officer = NULL;

	// mouse-over button image
	blit(imgMouseOver,canvas,0,0,posX,posY,imgMouseOver->w,imgMouseOver->h);

	try {
		// get the officer associated with this button
		//officer = g_game->gameState->m_officers[this->officerType];
		officer = g_game->gameState->getOfficer(this->officerType);
		name = officer->name;
		title = officer->GetTitle();
	}
	catch(...) { }

	// determine location for tip window
	static int cpx = (int)g_game->getGlobalNumber("GUI_CONTROLPANEL_POS_X");
	static int cpy = (int)g_game->getGlobalNumber("GUI_CONTROLPANEL_POS_Y");
	static int x = cpx + 40; 
	static int y = cpy + 115; 

	// background image
	//blit(imgTipWindowBackground,canvas,0,0,x,y,imgTipWindowBackground->w,imgTipWindowBackground->h);
	rectfill(canvas, x, y, x+165, y+32, makecol(57,59,134));

	// draw tooltip of crew position/name
	//g_game->setFontSize(18);
	g_game->Print18(canvas, x + 5, y, officer->GetTitle().c_str(), OFFICER_MOUSEOVERTIP_TEXT_CLR);
	g_game->Print18(canvas, x + 5, y + 13, name.c_str(), OFFICER_MOUSEOVERTIP_LABEL_CLR);

}

void ModuleControlPanel::OfficerButton::RenderSelected(BITMAP *canvas)
{
	blit(imgSelected,canvas,0,0,posX,posY,imgMouseOver->w,imgMouseOver->h);
}

bool ModuleControlPanel::OfficerButton::IsInButton(int x, int y)
{
	if ((x >= posX) && (x < posX+imgMouseOver->w) &&
		(y >= posY) && (y < posY+imgMouseOver->h))
	{
		return true;
	}

	return false;
}

void ModuleControlPanel::OfficerButton::DestroyButton()
{
	//these are now stored in the data file
	
	//if (imgMouseOver != NULL)
	//{
	//	destroy_bitmap(imgMouseOver);
	//	imgMouseOver = NULL;
	//}

	//if (imgSelected != NULL)
	//{
	//	destroy_bitmap(imgSelected);
	//	imgSelected = NULL;
	//}

	for (vector<CommandButton*>::iterator i = commandButtons.begin(); i != commandButtons.end(); ++i)
	{
		//handled by the datafile
		//(*i)->DestroyButton();
		
		delete *i;
	}
	commandButtons.clear();
}

void ModuleControlPanel::OfficerButton::DestroyCommon()
{
	//if (imgTipWindowBackground != NULL)
	//{
	//	destroy_bitmap(imgTipWindowBackground);
	//	imgTipWindowBackground = NULL;
	//}

}

#pragma endregion


