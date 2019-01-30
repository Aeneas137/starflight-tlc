/*
	STARFLIGHT - THE LOST COLONY
	ModulePlanetSurface.h - Handles planet surface travel
	Author: Justin Sargent
	Date: March, 2007

	Modified: Keith Patch
*/

#ifndef _PLANETSURFACE_H
#define _PLANETSURFACE_H

#include <lua.hpp>

#include "env.h"
#include <allegro.h>
#include "Module.h"
#include "TileScroller.h"
#include "PlayerShipSprite.h"
#include "ScrollBox.h"
#include "DataMgr.h"
#include <map>

class PlanetSurfaceObject;
class PlanetSurfacePlayerVessel;
class Sprite;
class Label;
class Button;
class ModuleCargoWindow;
class Items;
class AdvancedTileScroller;


const int MAPW = 31936;
const int MAPH = 31936;
const int CENTERX = MAPW / 2;
const int CENTERY = MAPH / 2;


class ModulePlanetSurface : public Module
{
private:
	~ModulePlanetSurface(void);

	void SetupLua();

	AdvancedTileScroller	*scroller;

	/* the Lua interpreter */
	lua_State *LuaVM;

	std::map<std::string, BITMAP*> portraits;
	std::map<std::string, BITMAP*>::iterator portraitsIt;

	Button *cargoBtn;

	BITMAP *img_messages;
	BITMAP *img_socket;
	BITMAP *img_gauges;
	BITMAP *img_aux;
	BITMAP *img_control;
	BITMAP *surface;
	BITMAP *minimap;
	BITMAP *btnNormal;
	BITMAP *btnDisabled;
	BITMAP *btnMouseOver;
	BITMAP *btnSelect;
	BITMAP *btnBigNormal;
	BITMAP *btnBigDisabled;
	BITMAP *btnBigMouseOver;
	BITMAP *btnBigSelect;
	BITMAP *Static;
	BITMAP *Cargo;
	BITMAP *Cargo_BarFill;
	BITMAP *CargoMouseOver;

	BITMAP *Timer_BarFill;
	BITMAP *Timer_BarEmpty;
	BITMAP *HP_Bar;

	BITMAP *Fuel;
	BITMAP *FuelBar;
	BITMAP *Armor;
	BITMAP *ArmorBar;
	BITMAP *Hull;
	BITMAP *HullBar;

	int CMDBUTTONS_UL_X;
	int CMDBUTTONS_UL_Y;
	int OFFICERICON_UL_X;
	int OFFICERICON_UL_Y;
	int CARGOFILL_X;
	int CARGOFILL_Y;

	int asw;
	int ash;
	int asx;
	int asy;

	int showPortraitCounter;
	bool introCinematicRunning;
	bool exitCinematicRunning;

	bool player_stranded;
	bool distressSignal;
    int badGravity;
    int deathState;

	double cargoFillPercent;

	Planet *planet;
public:
	PlanetSurfaceObject *cinematicShip;
	PlanetSurfaceObject *psObjectHolder;
	PlanetSurfacePlayerVessel *playerShip;
	PlanetSurfacePlayerVessel *playerTV;
	PlanetSurfacePlayerVessel *activeVessel;
	PlanetSurfaceObject *panFocus;
	bool TVwasMoving;  //needed to know when to start/stop the related sound effects.
	bool TVwasDamaged; //needed to know when to play damagedTV rather than TVmove.

	PlanetSurfaceObject *selectedPSO;
	std::string showPortrait;
	std::vector<PlanetSurfaceObject*> surfaceObjects;
	std::vector<PlanetSurfaceObject*>::iterator	objectIt;

	ScrollBox::ScrollBox *messages;

	bool runPlanetLoadScripts;
	bool runPlanetPopulate;
	int vibration;
	bool panCamera;
	bool timerOn;
	int timerCount;
	int timerLength;
	Label  *TimerText;

	int vessel_mode; // 0=ship with TV, 1=TV, 2=ship without TV
	Button *Btns[9];
	Button *BigBtns[2];
	int activeButtons;
	Label *label;

	ModulePlanetSurface(void);
	bool Init();
	void Update();
	void Draw();
	void drawMinimap();
	void drawHPBar(PlanetSurfaceObject *PSO);
	void updateCargoFillPercent();
	double CalcDistance(PlanetSurfaceObject *PSO1, PlanetSurfaceObject *PSO2);
	void PostMessage(std::string text);
	void PostMessage(std::string text, int color);
	void PostMessage(std::string text, int color, int blanksBefore);
	void PostMessage(std::string text, int color, int blanksBefore, int blanksAfter);
	void LoadPortrait(std::string name, std::string filepath);
	void ShowPortrait(std::string name);
	void CheckForCollisions(PlanetSurfaceObject *PSO);
	void CheckTileCollision(PlanetSurfaceObject *PSO,int x, int y);
	bool IsValidTile(int x, int y);

	void CreatePSObyItemID(std::string scriptName, int itemid, int itemx=-1, int itemy=-1);
	void AddPlanetSurfaceObject(PlanetSurfaceObject *PSO);
	void RemovePlanetSurfaceObject(PlanetSurfaceObject *PSO);

	void OnKeyPress(int keyCode);
	void OnKeyPressed(int keyCode);
	void OnKeyReleased(int keyCode);
	void OnMouseMove(int x, int y);
	void OnMouseClick(int button, int x, int y);
	void OnMousePressed(int button, int x, int y);
	void OnMouseReleased(int button, int x, int y);
	void OnMouseWheelUp(int x, int y);
	void OnMouseWheelDown(int x, int y);
	void OnEvent(Event *event);
	void Close();
	
	bool fabTilemap();
	bool fabAsteroid();
	bool fabRocky();
	bool fabFrozen();
	bool fabOceanic();
	bool fabMolten();
	//bool fabGasGiant();
	bool fabAcidic();
	void fabPlanetSurfaceObjects( std::string scriptName, std::string scriptFile, int filter, int maxPerItemType, int maxItemTypes );


};

	//********************************************************
	//*					Global Lua Functions                 *
	//********************************************************
	int L_Debug(lua_State* luaVM);
	int L_LoadImage( lua_State* luaVM );				//Lua Example: L_LoadImage("data/example.bmp")
	int L_Move(lua_State* luaVM);						//Lua Example: L_Move()
	int L_Draw(lua_State* luaVM);						//Lua Example: L_Draw()
	int L_Animate(lua_State* luaVM);					//Lua Example: L_Animate()
	int L_LaunchTV(lua_State* luaVM);					//Lua Example: L_LaunchTV()
	int L_SetActions(lua_State* luaVM);					//Lua Example: L_SetActions("Stun","PickUp","Mine") --You can go up to 9, one for each button, remember to put them in reverse order, so the first button is the last one you list
	int L_LoadScript(lua_State* luaVM);					//Lua Example: L_LoadScript("data/testScript.lua")
														//             L_PostMessage(b, g, r, "message")  ||  L_PostMessage("message")
	int L_PostMessage(lua_State* luaVM);				//Lua Example: L_PostMessage(0, 0, 255, "You lick it...it doesn't taste good") 
	int L_LoadPortrait(lua_State* luaVM);				//Lua Example: L_LoadPortrait("mineral", "data/mineralPortrait01.bmp") 
	int L_ShowPortrait(lua_State* luaVM);				//Lua Example: L_ShowPortrait("mineral") 
	int L_AddItemtoCargo(lua_State* luaVM);				//Lua Example: L_AddItemtoCargo(amount, itemID)  ||  L_AddItemtoCargo(itemID) defaults to 1 amount 

	int L_PlaySound(lua_State* luaVM);					//Lua Example: L_PlaySound("stunner")
	int L_PlayLoopingSound(lua_State* luaVM);			//Lua Example: L_PlayLoopingSound("TVmove")
	int L_StopSound(lua_State* luaVM);					//Lua Example: L_StopSound("TVmove")
    
    //special new AddItem function for artifacts
    int L_AddArtifactToCargo(lua_State* luaVM);

	int L_DeleteSelf(lua_State* luaVM);					//Lua Example: L_DeleteSelf()  
	int L_LoadPSObyID(lua_State* luaVM);				//Lua Example: L_LoadPSObyID(id)
	int L_CreateNewPSO(lua_State* luaVM);				//Lua Example: id = L_CreateNewPSO("scriptname")
	int L_CreateNewPSObyItemID(lua_State* luaVM);		//Lua Example: id = L_CreateNewPSObyItemID("scriptname", itemid)
	int L_LoadPlayerTVasPSO(lua_State* luaVM);			//Lua Example: L_LoadPlayerTVasPSO()
	int L_LoadPlayerShipasPSO(lua_State* luaVM);		//Lua Example: L_LoadPlayerShipasPSO()
	int L_Test(lua_State* luaVM);						//Lua Example: L_Test()  --This function is used to test lua scripts
	int L_SetRunPlanetLoadScripts(lua_State* luaVM);	//Lua Example: L_SetRunPlanetLoadScripts(false)
	int L_GetRunPlanetLoadScripts(lua_State* luaVM);	//Lua Example: L_GetRunPlanetLoadScripts()
	int L_SetRunPlanetPopulate(lua_State* luaVM);		//Lua Example: L_SetRunPlanetPopulate(false)
	int L_GetRunPlanetPopulate(lua_State* luaVM);		//Lua Example: L_GetRunPlanetPopulate()
	int L_CheckInventorySpace(lua_State* luaVM);		//Lua Example: L_CheckInventorySpace(quantity)
	int L_KilledAnimal(lua_State* luaVM);				//Lua Example: L_KilledAnimal(itemid)
	int L_Interacted(lua_State* luaVM);					//Lua Example: L_Interacted(interactid)
	int L_AttackTV(lua_State* luaVM);					//Lua Example: L_AttackTV(damage)
	int L_TVDestroyed(lua_State* luaVM);				//Lua Example: L_TVDestroyed()
	int L_TVOutofFuel(lua_State* luaVM);				//Lua Example: L_TVOutofFuel()
	int L_PlayerTVisAlive(lua_State* luaVM);			//Lua Example: alive = L_PlayerTVisAlive()
	int L_CheckInventoryFor(lua_State* luaVM);			//Lua Example: haveCargo = L_CheckInventoryFor( itemID, amount)
	int L_RemoveItemFromInventory(lua_State* luaVM);	//Lua Example: L_RemoveItemFromInventory( itemID, amount)
	int L_GetPlanetID(lua_State* luaVM);				//Lua Example: planetid = L_GetPlanetID()
	int Q_CheckRequirement(lua_State* luaVM);			//Lua Example: complete = Q_CheckRequirement(1)
	int Q_LoadQuestbyID(lua_State* luaVM);				//Lua Example: Q_LoadQuestbyID(1)
	int L_CreateTimer(lua_State* luaVM);				//Lua Example: L_CreateTimer("Extract",100)
	
	//Lua Accessors
	int L_GetPlayerShipPosition( lua_State* luaVM );	//Lua Example: x,y = L_GetPlayerShipPosition() 
	int L_GetPlayerTVPosition( lua_State* luaVM );		//Lua Example: x,y = L_GetPlayerTVPosition() 
	int L_GetActiveVesselPosition( lua_State* luaVM );	//Lua Example: x,y = L_GetActiveVesselPosition() 
	int L_GetScrollerPosition( lua_State* luaVM );		//Lua Example: x,y = L_GetScrollerPosition() 
	int L_GetPlayerProfession( lua_State* luaVM );		//Lua Example: prof = L_GetPlayerProfession() 
	int L_GetPosition( lua_State* luaVM );				//Lua Example: x,y = L_GetPosition() 
	int L_GetOffsetPosition( lua_State* luaVM );		//Lua Example: x,y = L_GetOffsetPosition() 
	int L_GetScreenWidth( lua_State* luaVM );			//Lua Example: width = L_GetScreenWidth() 
	int L_GetScreenHeight( lua_State* luaVM );			//Lua Example: height = L_GetScreenHeight() 
	int L_GetScreenDim( lua_State* luaVM );				//Lua Example: width, height = L_GetScreenDim() 
	int L_GetSpeed(lua_State* luaVM);					//Lua Example: speed = L_GetSpeed()
	int L_GetFaceAngle(lua_State* luaVM);				//Lua Example: angle = L_GetFaceAngle()
	int L_GetPlayerNavVars(lua_State* luaVM);			//Lua Example: forwardThrust, reverseThrust, turnLeft, turnRight = L_GetPlayerNavVars()
	int L_GetScale(lua_State* luaVM);					//Lua Example: scale = L_GetScale()
	int L_GetCounters(lua_State* luaVM);				//Lua Example: counter1, counter2, counter3 = L_GetCounters()
	int L_GetThresholds(lua_State* luaVM);				//Lua Example: threshold1, threshold2, threshold3 = L_GetThresholds()
	int L_IsPlayerMoving(lua_State* luaVM);				//Lua Example: if (L_IsPlayerMoving() == true)
	int L_GetItemID(lua_State* luaVM);					//Lua Example: id = L_GetItemID()
	int L_GetState(lua_State* luaVM);					//Lua Example: state = L_GetState()
	int L_GetVesselMode(lua_State* luaVM);				//Lua Example: mode = L_GetVesselMode()
	int L_IsScanned(lua_State* luaVM);					//Lua Example: scanned = L_IsScanned()
	int L_GetName(lua_State* luaVM);					//Lua Example: name = L_GetName()
	int L_GetValue(lua_State* luaVM);					//Lua Example: worth = L_GetValue()
	int L_GetDamage(lua_State* luaVM);					//Lua Example: damage = L_GetDamage()
	int L_IsBlackMarketItem(lua_State* luaVM);			//Lua Example: isBlackMarket = L_IsBlackMarketItem()
	int L_IsShipRepairMetal(lua_State* luaVM);			//Lua Example: shipRepairMetal = L_IsShipRepairMetal()
	int L_IsAlive(lua_State* luaVM);					//Lua Example: isAlive = L_IsAlive()
	int L_GetColHalfWidth(lua_State* luaVM);			//Lua Example: halfwidth = L_GetColHalfWidth()
	int L_GetColHalfHeight(lua_State* luaVM);			//Lua Example: halfheight = L_GetColHalfHeight()
	int L_GetID(lua_State* luaVM);						//Lua Example: id = L_GetID()
	int L_GetScriptName(lua_State* luaVM);				//Lua Example: scriptName = L_GetScriptName()
	int L_GetHealth(lua_State* luaVM);					//Lua Example: health = L_GetHealth()
	int L_GetMaxHealth(lua_State* luaVM);				//Lua Example: health = L_GetMaxHealth()
	int L_GetStunCount(lua_State* luaVM);				//Lua Example: stuncount = L_GetStunCount()
	int L_GetItemSize(lua_State* luaVM);				//Lua Example: size = L_GetItemSize()
	int L_GetSelectedPSOid(lua_State* luaVM);			//Lua Example: id = L_GetSelectedPSOid()
	int L_GetObjectType(lua_State* luaVM);				//Lua Example: objectType = L_GetObjectType()
	int L_GetDanger(lua_State* luaVM);					//Lua Example: danger = L_GetDanger()
	int L_GetMinimapColor(lua_State* luaVM);			//Lua Example: color = L_GetMinimapColor()
	int L_GetMinimapSize(lua_State* luaVM);				//Lua Example: size = L_GetMinimapSize()

	//Lua Mutators
	int L_SetPosition( lua_State* luaVM );				//Lua Example: L_SetPosition(x,y) 
	int L_SetVelocity(lua_State* luaVM);				//Lua Example: L_SetVelocity(velX,velY) 
	int L_SetSpeed(lua_State* luaVM);					//Lua Example: L_SetSpeed(speed)
	int L_SetFaceAngle(lua_State* luaVM);				//Lua Example: L_SetFaceAngle(angle)
	int L_SetAnimInfo( lua_State* luaVM );				//Lua Example: L_SetAnimInfo(FrameWidth, FrameHeight, AnimColumns, TotalFrames, CurFrame) 
	int L_SetAngleOffset(lua_State* luaVM);				//Lua Example: L_SetAngleOffset(angle)
	int L_SetScale(lua_State* luaVM);					//Lua Example: L_SetScale(angle)
	int L_SetCounters(lua_State* luaVM);				//Lua Example: L_SetCounters(counter1, counter2, counter3)
	int L_SetThresholds(lua_State* luaVM);				//Lua Example: L_SetThresholds(threshold1, threshold2, threshold3)
	int L_SetState(lua_State* luaVM);					//Lua Example: L_SetState(state)
	int L_SetVesselMode(lua_State* luaVM);				//Lua Example: L_GetVesselMode(mode)
	int L_SetScanned(lua_State* luaVM);					//Lua Example: L_SetScanned(true)
	int L_SetDamage(lua_State* luaVM);					//Lua Example: L_SetDamage(damage)
	int L_SetAlive(lua_State* luaVM);					//Lua Example: L_SetAlive(isAlive)
	int L_SetColHalfWidth(lua_State* luaVM);			//Lua Example: L_SetColHalfWidth(halfwidth)
	int L_SetColHalfHeight(lua_State* luaVM);			//Lua Example: L_SetColHalfHeight(halfheight)
	int L_SetScriptName(lua_State* luaVM);				//Lua Example: L_SetScriptName(scriptName)
	int L_SetAlpha(lua_State* luaVM);					//Lua Example: L_SetAlpha(true)
	int L_SetHealth(lua_State* luaVM);					//Lua Example: L_SetHealth(health)
	int L_SetMaxHealth(lua_State* luaVM);				//Lua Example: L_SetMaxHealth(health)
	int L_SetStunCount(lua_State* luaVM);				//Lua Example: L_SetStunCount(stuncount)
	int L_SetObjectType(lua_State* luaVM);				//Lua Example: L_SetObjectType(objectType)
	int L_SetName(lua_State* luaVM);					//Lua Example: L_SetName("Justin")
	int L_SetMinimapColor(lua_State* luaVM);			//Lua Example: L_SetMinimapColor(color)
	int L_SetMinimapSize(lua_State* luaVM);				//Lua Example: L_SetMinimapSize(size)
	int L_SetNewAnimation(lua_State* luaVM);			//Lua Example: L_SetNewAnimation("walk", 0, 4, 2)
	int L_SetActiveAnimation(lua_State* luaVM);			//Lua Example: L_SetActiveAnimation("walk")

    //added for Ruins
	int L_GetDescription(lua_State* luaVM);					//Lua Example: name = L_GetDescription()


#endif
