/*
	STARFLIGHT - THE LOST COLONY
	ModuleStarport.h - Handles Starport activity
	Author: Scott Idler
	Date: June 29, 2007
*/

#ifndef _SHIPCONFIG_H
#define _SHIPCONFIG_H 1

#include "env.h"
#include <allegro.h>
#include <vector>
#include "Module.h"
#include "Button.h"
#include "GameState.h"

#define MAX_CARGOPODS 16
#define BUTTON_X_START 130
#define BUTTON_Y_START 255
#define BOTTOM_CORNER_X 20
#define BOTTOM_CORNER_Y 684

#define MENU_PATH_X 30
#define MENU_PATH_Y 184

#define STATIC_READOUT_X 550
#define DYNAMIC_READOUT_X 950
#define READOUT_Y 150
#define READOUT_SPACING 50


#define STATIC_CREDITS_X 650
#define DYNAMIC_CREDITS_X 900
#define CREDITS_Y 75

#define STATIC_SHIPNAME_X 560
#define DYNAMIC_SHIPNAME_X 700
#define SHIPNAME_Y 685

#define PIXEL_BUFFER 4
#define BUTTON_HEIGHT 64
#define NINETY_DEGREES 90
#define NUMBER_OF_BUTTONS 7
const double _360_TO_256(256.0/360.0);

#define CARGOPODS 500
#define SELLBACK_RATE .7
//Cargo Pods: 500
//						Class 1		Class 2		Class 3		Class 4		Class 5		Class 6
//
//Engines				1,000		8,000		20,000		40,000      100,000		220,000
//Shields     			4,000		12,000		32,000		70,000		125,000		240,000
//Armor					1,500		3,100		6,200		12,500		25,000		70,000
//Missile Launchers		12,000		28,000		60,000		120,000		200,000		330,000
//Laser Cannons			8,000		20,000		54,000		90,000		150,000		260,000

#define ENGINE_CLASS1 1000
#define ENGINE_CLASS2 8000
#define ENGINE_CLASS3 20000
#define ENGINE_CLASS4 40000
#define ENGINE_CLASS5 100000
#define ENGINE_CLASS6 220000

#define SHIELD_CLASS1 4000
#define SHIELD_CLASS2 12000
#define SHIELD_CLASS3 32000
#define SHIELD_CLASS4 70000
#define SHIELD_CLASS5 125000
#define SHIELD_CLASS6 240000

#define ARMOR_CLASS1 1500
#define ARMOR_CLASS2 3100
#define ARMOR_CLASS3 6200
#define ARMOR_CLASS4 12500
#define ARMOR_CLASS5 25000
#define ARMOR_CLASS6 70000

#define MISSILELAUNCHER_CLASS1 12000
#define MISSILELAUNCHER_CLASS2 28000
#define MISSILELAUNCHER_CLASS3 60000
#define MISSILELAUNCHER_CLASS4 120000
#define MISSILELAUNCHER_CLASS5 200000
#define MISSILELAUNCHER_CLASS6 330000

#define LASER_CLASS1 8000
#define LASER_CLASS2 20000
#define LASER_CLASS3 54000
#define LASER_CLASS4 90000
#define LASER_CLASS5 150000
#define LASER_CLASS6 260000

const int ITEM_PRICES[5][6] =	
{
{ ENGINE_CLASS1, ENGINE_CLASS2, ENGINE_CLASS3, ENGINE_CLASS4, ENGINE_CLASS5, ENGINE_CLASS6 },
{ SHIELD_CLASS1, SHIELD_CLASS2, SHIELD_CLASS3, SHIELD_CLASS4, SHIELD_CLASS5, SHIELD_CLASS6 },
{ ARMOR_CLASS1, ARMOR_CLASS2, ARMOR_CLASS3, ARMOR_CLASS4, ARMOR_CLASS5, ARMOR_CLASS6 },
{ MISSILELAUNCHER_CLASS1, MISSILELAUNCHER_CLASS2, MISSILELAUNCHER_CLASS3, MISSILELAUNCHER_CLASS4, MISSILELAUNCHER_CLASS5, MISSILELAUNCHER_CLASS6 },
{ LASER_CLASS1, LASER_CLASS2, LASER_CLASS3, LASER_CLASS4, LASER_CLASS5, LASER_CLASS6 }
};
enum ButtonType
{
	UndefButtonType,
	ModuleEntry,
	ShipConfig,
	Launch,
	Buy,
	Sell,
	Repair,
	Name,
	Exit,
	CargoPods,
	Engines,
	Shields,
	Armor,
	Missiles,
	Lasers,
    Hull,
	Back,
	Class1,
	Class2,
	Class3,
	Class4,
	Class5,
	Class6,
	Pay,
	Nevermind,
	SaveName,
	TVConfig,
	BuyTV
};


//calculate the difference between the enums
const int CLASS_ENUM_DIF = (Class1 - Class1Type);  //calculates the correct value for the class of item
const int ITEM_ENUM_DIF = Engines - 0; //calculates the correct index into the ITEM_PRICES[5][6] array

class ModuleShipConfig : public Module
{

public:
	ModuleShipConfig();	//ctor
	bool Init();
	void Update();
	void Draw();
	void OnKeyPress(int keyCode);
	void OnKeyPressed(int keyCode);
	void OnKeyReleased(int keyCode);
	void OnMouseMove(int x, int y);
	void OnMouseClick(int button, int x, int y);
	void OnMousePressed(int button, int x, int y);
	void OnMouseReleased(int button, int x, int y);
	void OnMouseWheelUp(int x, int y);
	void OnMouseWheelDown(int x, int y);
	void OnEvent(Event * event);
	void Close();	

private:
	~ModuleShipConfig();	//dtor
	
	int						buttonsActive;
	std::vector<ButtonType>	menuPath;
	Button 					*buttons[NUMBER_OF_BUTTONS];
	//ALFONT_FONT				*fontPtr;
	BITMAP					*shipImage;
	BITMAP					*shipConfig;
	int						repairCost;
	bool					inputName;
	std::string				shipName;
	Sample 					*m_sndClick;
	Sample 					*m_sndErr;
	BITMAP					*m_cursor;

	void display() const;
	std::string convertMenuPathToString() const;
	std::string convertButtonTypeToString(ButtonType btnType) const;
	void configureButton(int btn, ButtonType btnType);
	bool checkComponent() const;
	void buyComponent();
	void sellComponent();
    void repairComponent();
	int getMaxEngineClass();
	int getMaxArmorClass();
	int getMaxShieldClass();
	int getMaxLaserClass();
	int getMaxMissileClass();

    int getEngineValue();
    int getLaserValue();
    int getMissileValue();
    int getShieldValue();
    int getArmorValue();

    int getEngineRepair();
    int getLaserRepair();
    int getMissileRepair();
    int getShieldRepair();
    int getArmorRepair();
    int getHullRepair();
};

#endif
