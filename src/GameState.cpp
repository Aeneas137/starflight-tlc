/*
	STARFLIGHT - THE LOST COLONY
	GameState.cpp - ?
	Author: ?
	Date: ?
*/

#include <math.h>
#include <sstream>
#include <fstream>
#include <exception>
#include "env.h"
#include "Util.h"
#include "GameState.h"
#include "Archive.h"
#include "sfitems.h"
#include "Point2D.h"
#include "Game.h"
#include "DataMgr.h"
#include "QuestMgr.h"
#include "ModeMgr.h"
#include "Events.h"

using namespace std;

//OFFICER CLASS

Officer::Officer()
{
	Reset();
}

Officer::Officer(OfficerType type)
{
	Reset();
	officerType = type;
}

Officer::~Officer()
{
	Reset();
}

/**
    This function increases a crew member's skill in a specific area as a result of performing a task.
    The name of the skill is passed as a string to avoid our already prodigious use of enums.
    vcap: otoh, enum are nice because compilers know about them, also you can use the switch construct
     with them, so i did one anyway.
**/
bool Officer::SkillUp(string skill, int amount)
{
	//because of the way we use attributes.extra_variable, all sort of bad things will happen if we allow captain
	//skills to increase thru this function and the captain is filling several roles.
	if (this->officerType == OFFICER_CAPTAIN)
		return false;

	//level up a specific skill
	if (skill == "science") {
		if (this->attributes.science >= 255) return false;
		if (this->attributes.science + amount >= 255) this->attributes.science = 255;
		else this->attributes.science += amount;
	}
	else if (skill == "engineering") {
		if (this->attributes.engineering >= 255) return false;
		if (this->attributes.engineering + amount >= 255) this->attributes.engineering = 255;
		else this->attributes.engineering += amount;
	}
	else if (skill == "navigation") {
		if (this->attributes.navigation >= 255) return false;
		if (this->attributes.navigation + amount >= 255) this->attributes.navigation = 255;
		else this->attributes.navigation += amount;
	}
	else if (skill == "communication") {
		if (this->attributes.communication >= 255) return false;
		if (this->attributes.communication + amount >= 255) this->attributes.communication = 255;
		else this->attributes.communication += amount;
	}
	else if (skill == "medical") {
		if (this->attributes.medical >= 255) return false;
		if (this->attributes.medical + amount >= 255) this->attributes.medical = 255;
		else this->attributes.medical += amount;
	}
	else if (skill == "tactical") {
		if (this->attributes.tactics >= 255) return false;
		if (this->attributes.tactics + amount >= 255) this->attributes.tactics = 255;
		else this->attributes.tactics += amount;
	}
	else ASSERT(0);

	return true;
}

//same as above but with the Skill enum
bool Officer::SkillUp(Skill skill, int amount)
{
	//because of the way we use attributes.extra_variable, all sort of bad things will happen if we allow captain
	//skills to increase thru this function and the captain is filling several roles.
	if (this->officerType == OFFICER_CAPTAIN)
		return false;

	//level up a specific skill
	switch (skill){
		case SKILL_SCIENCE:
			if (this->attributes.science >= 255) return false;
			if (this->attributes.science + amount >= 255) this->attributes.science = 255;
			else this->attributes.science += amount;
		break;

		case SKILL_ENGINEERING:
			if (this->attributes.engineering >= 255) return false;
			if (this->attributes.engineering + amount >= 255) this->attributes.engineering = 255;
			else this->attributes.engineering += amount;
		break;

		case SKILL_NAVIGATION:
			if (this->attributes.navigation >= 255) return false;
			if (this->attributes.navigation + amount >= 255) this->attributes.navigation = 255;
			else this->attributes.navigation += amount;
		break;

		case SKILL_COMMUNICATION:
			if (this->attributes.communication >= 255) return false;
			if (this->attributes.communication + amount >= 255) this->attributes.communication = 255;
			else this->attributes.communication += amount;
		break;

		case SKILL_MEDICAL:
			if (this->attributes.medical >= 255) return false;
			if (this->attributes.medical + amount >= 255) this->attributes.medical = 255;
			else this->attributes.medical += amount;
		break;

		case SKILL_TACTICAL:
			if (this->attributes.tactics >= 255) return false;
			if (this->attributes.tactics + amount >= 255) this->attributes.tactics = 255;
			else this->attributes.tactics += amount;
		break;

		default: ASSERT(0);
    }

    return true;
}

Officer & Officer::operator =(const Officer &rhs)
{
	name = rhs.name;
	attributes = rhs.attributes;
	officerType = rhs.officerType;

	return *this;
}

/*
 * THIS IS KNOWN AS A CODE COMMENT. IT EXPLAINS STUFF. IT HELPS OTHER PROGRAMMERS.
 */
OfficerType Officer::GetOfficerType() const
{
	return officerType;
}

/*
 * THIS IS KNOWN AS A CODE COMMENT. IT EXPLAINS STUFF. IT HELPS OTHER PROGRAMMERS.
 */
string Officer::GetTitle()
{
	string result = "";

	switch (officerType)
	{
	case OFFICER_CAPTAIN:
		result = "Captain";
		break;

	case OFFICER_SCIENCE:
		result = "Sciences";
		break;

	case OFFICER_NAVIGATION:
		result = "Navigation";
		break;

	case OFFICER_ENGINEER:
		result = "Engineering";
		break;

	case OFFICER_COMMUNICATION:
		result = "Communications";
		break;

	case OFFICER_MEDICAL:
		result = "Medical";
		break;

	case OFFICER_TACTICAL:
		result = "Tactical";
		break;

	case OFFICER_NONE:
	default:
		result = "None";
		break;
	};

	return result;
}

string Officer::GetTitle(OfficerType officerType)
{
	string result = "";

	switch (officerType)
	{
	case OFFICER_CAPTAIN:
		result = "Captain";
		break;

	case OFFICER_SCIENCE:
		result = "Sciences";
		break;

	case OFFICER_NAVIGATION:
		result = "Navigation";
		break;

	case OFFICER_ENGINEER:
		result = "Engineering";
		break;

	case OFFICER_COMMUNICATION:
		result = "Communications";
		break;

	case OFFICER_MEDICAL:
		result = "Medical";
		break;

	case OFFICER_TACTICAL:
		result = "Tactical";
		break;

	case OFFICER_NONE:
	default:
		result = "None";
		break;
	};

	return result;
}

std::string Officer::GetPreferredProfession()
{
	OfficerType prefferredType = OFFICER_NONE;
	int highestValue = 0;

	for (int i=0; i < 7; ++i)
	{
		if (attributes[i] > highestValue)
		{
			highestValue = attributes[i];
			prefferredType = (OfficerType)(i + 2);
		}
	}

	return GetTitle(prefferredType);
}


/*
 * THIS IS KNOWN AS A CODE COMMENT. IT EXPLAINS STUFF. IT HELPS OTHER PROGRAMMERS.
 */
void Officer::SetOfficerType(int type)
{
	switch(type) {
		case 0:
			officerType = OFFICER_NONE;
			break;
		case 1:
			officerType = OFFICER_CAPTAIN;
			break;
		case 2:
			officerType = OFFICER_SCIENCE;
			break;
		case 3:
			officerType = OFFICER_NAVIGATION;
			break;
		case 4:
			officerType = OFFICER_ENGINEER;
			break;
		case 5:
			officerType = OFFICER_COMMUNICATION;
			break;
		case 6:
			officerType = OFFICER_MEDICAL;
			break;
		case 7:
			officerType = OFFICER_TACTICAL;
			break;

	}
}

/*
 * THIS IS KNOWN AS A CODE COMMENT. IT EXPLAINS STUFF. IT HELPS OTHER PROGRAMMERS.
 */
void Officer::SetOfficerType(OfficerType type)
{
	officerType = type;
}

/*
 * THIS IS KNOWN AS A CODE COMMENT. IT EXPLAINS STUFF. IT HELPS OTHER PROGRAMMERS.
 */
void Officer::Reset()
{
	name = "";
	attributes.Reset();
	officerType = OFFICER_NONE;
	isHealing = false;
	this->lastSkillCheck.SetYear(0);
}

/*
 * THIS IS KNOWN AS A CODE COMMENT. IT EXPLAINS STUFF. IT HELPS OTHER PROGRAMMERS.
 */
bool Officer::Serialize(Archive &ar)
{
   string ClassName = "Officer";
   int Schema = 0;

   if (ar.IsStoring())
   {
	   ar << ClassName;
	   ar << Schema;

	   ar << name;

	   if (!attributes.Serialize(ar))
		   return false;

	   ar << (int)officerType;
   }
   else
   {
   	Reset();

      string LoadClassName;
      ar >> LoadClassName;
      if (LoadClassName != ClassName)
         return false;

      int LoadSchema;
      ar >> LoadSchema;
      if (LoadSchema > Schema)
         return false;

	   ar >> name;

	   if (!attributes.Serialize(ar))
		   return false;

	   int tmpi;
	   ar >> tmpi;
	   officerType = (OfficerType)tmpi;
   }

	return true;
}

bool Officer::SkillCheck()
{
	int skill_value = 0;
	int chance = 0;

	lastSkillCheck = g_game->gameState->stardate;

	switch(this->GetOfficerType()){
		case OFFICER_SCIENCE:
			skill_value = this->attributes.getScience();
			break;
		case OFFICER_ENGINEER:
			skill_value = this->attributes.getEngineering();
			break;
		case OFFICER_MEDICAL:
			skill_value = this->attributes.getMedical();
			break;
		case OFFICER_NAVIGATION:
			skill_value = this->attributes.getNavigation();
			break;
		case OFFICER_TACTICAL:
			skill_value = this->attributes.getTactics();
			break;
		case OFFICER_COMMUNICATION:
			skill_value = this->attributes.getCommunication();
			break;
		default:
			return false;
	}

    //250+ is guaranteed pass
	if (skill_value > 250) {
		return true;
	}
    //any below 200 is % chance to pass skill check
    else if(skill_value > 200) {
		chance = 90;
	}
    else if(skill_value > 150) {
		chance = 80;
	}
    else if(skill_value > 100) {
		chance = 70;
	}
    else if(skill_value > 75) {
		chance = 60;
    }
    else if(skill_value > 50) {
        chance = 50;
    }
	else 
		chance = 25;


    int roll = rand()%100;
	return (roll < chance);
}

bool Officer::CanSkillCheck(){
	return ( this->lastSkillCheck < g_game->gameState->stardate );
}

void Officer::FakeSkillCheck(){
	lastSkillCheck = g_game->gameState->stardate;
}


std::string Officer::getFirstName()
{
	string::size_type loc = name.find(" ",0);
	if( loc != string::npos )
		//found space, return first name
		return name.substr(0,loc);
	else
		//not found, return whole name
		return name;
}

std::string Officer::getLastName()
{
	string::size_type loc = name.find(" ",0);
	if( loc != string::npos )
		//found space, return last name
		return name.substr(loc+1);
	else
		//not found, return whole name
		return name;
}



/*
 * THIS IS KNOWN AS A CODE COMMENT. IT EXPLAINS STUFF. IT HELPS OTHER PROGRAMMERS.
 */
std::string convertClassTypeToString(int num)
{
	switch(num)
	{
	case 0: return "None";
	case 1: return "Class 1";
	case 2: return "Class 2";
	case 3: return "Class 3";
	case 4: return "Class 4";
	case 5: return "Class 5";
	case 6: return "Class 6";
	}
	return "Error in convertClassTypeToString()";
}

Ship::Ship():
maxEngineClass(0),maxArmorClass(0),maxShieldClass(0),maxLaserClass(0),maxMissileLauncherClass(0)
{
	 Reset();
}

Ship::~Ship() {}

void Ship::initializeRepair()
{
	TRACE("Calling Ship::initializeRepair()\n");

	//roll the minerals that will be used for repair
	for ( int i=0; i < NUM_REPAIR_PARTS; i++){
			switch (rand()%5){
				case 0: repairMinerals[i] = ITEM_COBALT;     break;
				case 1: repairMinerals[i] = ITEM_MOLYBDENUM; break;
				case 2: repairMinerals[i] = ITEM_ALUMINUM;   break;
				case 3: repairMinerals[i] = ITEM_TITANIUM;   break;
				case 4: repairMinerals[i] = ITEM_SILICA;     break;
				default: ASSERT(0);
			}
	}

	//set the repair counters so that the player will need to pay the next time he start repairs
	for ( int i=0; i < NUM_REPAIR_PARTS; i++){ repairCounters[i] = MAX_REPAIR_COUNT; }

	//stop all repair, if needed
	partInRepair = PART_NONE;
}

//accessors
std::string Ship::getName()											const { return name; }
int Ship::getCargoPodCount()										const { return cargoPodCount; }
int Ship::getEngineClass()											const { return engineClass; }
int Ship::getShieldClass()											const { return shieldClass; }
int Ship::getArmorClass()											const { return armorClass; }
int Ship::getMissileLauncherClass() 								const { return missileLauncherClass; }

int Ship::getTotalSpace() { return cargoPodCount * POD_CAPACITY; }

int Ship::getOccupiedSpace()
{
	Item item;
	int numItems, occupiedSpace = 0;

	//loop over the inventory to get items count
	int numstacks = g_game->gameState->m_items.GetNumStacks();
	for (int i = 0; i < numstacks; i++){
		g_game->gameState->m_items.GetStack(i, item, numItems);

		//artifacts do not take any space
		if (!item.IsArtifact())
			occupiedSpace+=numItems;
	}

	return occupiedSpace;
}
int Ship::getAvailableSpace()
{
	int freeSpace = getTotalSpace() - getOccupiedSpace();
	if (freeSpace < 0)
		g_game->ShowMessageBoxWindow("", "Your cargo hold contains more stuff than it's actual capacity!");

	return freeSpace;
}


int Ship::getMissileLauncherDamage()
{
	//return missile damage based on class
	switch(missileLauncherClass) {
		case 1: return g_game->getGlobalNumber("MISSILE1_DAMAGE"); break;
		case 2: return g_game->getGlobalNumber("MISSILE2_DAMAGE"); break;
		case 3: return g_game->getGlobalNumber("MISSILE3_DAMAGE"); break;
		case 4: return g_game->getGlobalNumber("MISSILE4_DAMAGE"); break;
		case 5: return g_game->getGlobalNumber("MISSILE5_DAMAGE"); break;
		case 6: return g_game->getGlobalNumber("MISSILE6_DAMAGE"); break;
		default: return 0;
	}
}

int Ship::getMissileLauncherFiringRate()
{
	//return missile firing rate based on class
	switch(missileLauncherClass) {
		case 1: return g_game->getGlobalNumber("MISSILE1_FIRERATE"); break;
		case 2: return g_game->getGlobalNumber("MISSILE2_FIRERATE"); break;
		case 3: return g_game->getGlobalNumber("MISSILE3_FIRERATE"); break;
		case 4: return g_game->getGlobalNumber("MISSILE4_FIRERATE"); break;
		case 5: return g_game->getGlobalNumber("MISSILE5_FIRERATE"); break;
		case 6: return g_game->getGlobalNumber("MISSILE6_FIRERATE"); break;
		default: return 0;
	}
}
int Ship::getLaserClass()	const { return laserClass; }
int Ship::getLaserDamage()
{
	//return laser damage based on class
	switch(laserClass) {
		case 1: return g_game->getGlobalNumber("LASER1_DAMAGE"); break;
		case 2: return g_game->getGlobalNumber("LASER2_DAMAGE"); break;
		case 3: return g_game->getGlobalNumber("LASER3_DAMAGE"); break;
		case 4: return g_game->getGlobalNumber("LASER4_DAMAGE"); break;
		case 5: return g_game->getGlobalNumber("LASER5_DAMAGE"); break;
		case 6: return g_game->getGlobalNumber("LASER6_DAMAGE"); break;
		default: return 0;
	}
}

int Ship::getLaserFiringRate()
{
	//return laser firing rate based on class
	switch(laserClass) {
		case 1: return g_game->getGlobalNumber("LASER1_FIRERATE"); break;
		case 2: return g_game->getGlobalNumber("LASER2_FIRERATE"); break;
		case 3: return g_game->getGlobalNumber("LASER3_FIRERATE"); break;
		case 4: return g_game->getGlobalNumber("LASER4_FIRERATE"); break;
		case 5: return g_game->getGlobalNumber("LASER5_FIRERATE"); break;
		case 6: return g_game->getGlobalNumber("LASER6_FIRERATE"); break;
		default: return 0;
	}
}

float Ship::getMaxArmorIntegrity()
{
	switch(armorClass) {
		case 1: return g_game->getGlobalNumber("ARMOR1_STRENGTH"); break;
		case 2: return g_game->getGlobalNumber("ARMOR2_STRENGTH"); break;
		case 3: return g_game->getGlobalNumber("ARMOR3_STRENGTH"); break;
		case 4: return g_game->getGlobalNumber("ARMOR4_STRENGTH"); break;
		case 5: return g_game->getGlobalNumber("ARMOR5_STRENGTH"); break;
		case 6: return g_game->getGlobalNumber("ARMOR6_STRENGTH"); break;
		default: return 0;
	}
}

//shield capacity is the absorbing capacity of the shield, it is different from the
//shield generator integrity itself. it will slowly regenerate itself up to a maximum
//determined by the shield generator class and current integrity and only decrease as
//a result of taking damage during combat.
float Ship::getMaxShieldCapacity()
{
	switch(shieldClass) {
		case 1: return g_game->getGlobalNumber("SHIELD1_STRENGTH") * shieldIntegrity/100.0f; break;
		case 2: return g_game->getGlobalNumber("SHIELD2_STRENGTH") * shieldIntegrity/100.0f; break;
		case 3: return g_game->getGlobalNumber("SHIELD3_STRENGTH") * shieldIntegrity/100.0f; break;
		case 4: return g_game->getGlobalNumber("SHIELD4_STRENGTH") * shieldIntegrity/100.0f; break;
		case 5: return g_game->getGlobalNumber("SHIELD5_STRENGTH") * shieldIntegrity/100.0f; break;
		case 6: return g_game->getGlobalNumber("SHIELD6_STRENGTH") * shieldIntegrity/100.0f; break;
		default: return 0;
	}
}

float Ship::getMaxShieldCapacityAtFullIntegrity()
{
	switch(shieldClass) {
		case 1: return g_game->getGlobalNumber("SHIELD1_STRENGTH"); break;
		case 2: return g_game->getGlobalNumber("SHIELD2_STRENGTH"); break;
		case 3: return g_game->getGlobalNumber("SHIELD3_STRENGTH"); break;
		case 4: return g_game->getGlobalNumber("SHIELD4_STRENGTH"); break;
		case 5: return g_game->getGlobalNumber("SHIELD5_STRENGTH"); break;
		case 6: return g_game->getGlobalNumber("SHIELD6_STRENGTH"); break;
		default: return 0;
	}
}

float Ship::getHullIntegrity()								const { return hullIntegrity; }
float Ship::getArmorIntegrity()								const { return armorIntegrity; }
float Ship::getShieldIntegrity()							const { return shieldIntegrity; }
float Ship::getShieldCapacity()								const { return shieldCapacity; }

float Ship::getEngineIntegrity()							const { return engineIntegrity; }
float Ship::getMissileLauncherIntegrity()					const { return missileLauncherIntegrity; }
float Ship::getLaserIntegrity()								const { return laserIntegrity; }

//std::string Ship::getCargoPodCountString()					const { return convertClassTypeToString(cargoPodCount); }
std::string Ship::getEngineClassString()					const { return convertClassTypeToString(engineClass); }
std::string Ship::getShieldClassString()					const { return convertClassTypeToString(shieldClass); }
std::string Ship::getArmorClassString()						const { return convertClassTypeToString(armorClass); }
std::string Ship::getMissileLauncherClassString()			const { return convertClassTypeToString(missileLauncherClass); }
std::string Ship::getLaserClassString()						const { return convertClassTypeToString(laserClass); }
bool Ship::HaveEngines()									const { return engineClass != NotInstalledType; }


#pragma region FUEL_SYSTEM

float Ship::getFuel()										  { return fuelPercentage;}

/**
    Standard consumption occurs in interplanetary space (iterations=1). Interstellar
    should consume 4x this amount. Planet landing/takeoff should each consume 10x. 
    Remember, 1 cu-m Endurium will fill the fuel tank.
**/
void Ship::ConsumeFuel(int iterations)
{
    for (int n=0; n<iterations; n++)
    {
	    //consume fuel 0.1% / engine_class (higher class uses less fuel)
	    float percent_amount = 0.001f / g_game->gameState->m_ship.getEngineClass();

        g_game->gameState->m_ship.augFuel(-percent_amount);

        float fuel = g_game->gameState->m_ship.getFuel();
        if (fuel < 0.0f) fuel = 0.0f;
    }
}

void Ship::setFuel(float percentage)								
{
    fuelPercentage = percentage; 
    capFuel();
}
void Ship::augFuel(float percentage)
{
	fuelPercentage += percentage;
	capFuel();
}

void Ship::capFuel()
{
	if (fuelPercentage > 1.0f)
		fuelPercentage = 1.0f;
	else if (fuelPercentage < 0.0f)
		fuelPercentage = 0.0f;
}

int Ship::getEnduriumOnBoard()
{
    //get amount of endurium in cargo
	Item endurium;
	const int ITEM_ENDURIUM = 54;
	int amount = 0;
	g_game->gameState->m_items.Get_Item_By_ID(ITEM_ENDURIUM, endurium, amount);
    return amount;
}

void Ship::injectEndurium()
{
    if (g_game->g_scrollbox == NULL) {
        g_game->fatalerror("Ship::injectEndurium: g_scrollbox is null");
        return;
    }

    //check endurium amount
	int number_of_endurium = getEnduriumOnBoard();
	if(number_of_endurium >= 1)
	{
        //reduce endurium
        number_of_endurium--;
		g_game->gameState->m_items.RemoveItems(54, 1);
		g_game->printout(g_game->g_scrollbox, "Consuming Endurium crystal... We have " + Util::ToString(number_of_endurium) + " left.", ORANGE,5000);
		
        //use it to fill the fuel tank
		g_game->gameState->m_ship.augFuel(1.0f);
		
        //notify CargoHold to update itself
        Event e(CARGO_EVENT_UPDATE);
		g_game->modeMgr->BroadcastEvent(&e);
	}
	else
		g_game->printout(g_game->g_scrollbox, "We have no Endurium!", ORANGE,5000);

}
#pragma endregion

//mutators
void Ship::setName(std::string initName)							{ name = initName; }
void Ship::setCargoPodCount(int initCargoPodCount)					{ cargoPodCount = initCargoPodCount; }
void Ship::cargoPodPlusPlus()										{ cargoPodCount++; }
void Ship::cargoPodMinusMinus()										{ cargoPodCount--; }
void Ship::setEngineClass(int initEngineClass)						{ engineClass = initEngineClass; }
void Ship::setShieldClass(int initShieldClass)						{ shieldClass = initShieldClass; }
void Ship::setArmorClass(int initArmorClass)						{ armorClass = initArmorClass; }
void Ship::setMissileLauncherClass(int initMissileLauncherClass)	{ missileLauncherClass = initMissileLauncherClass; }
void Ship::setLaserClass(int initLaserClass)						{ laserClass = initLaserClass; }


void Ship::setHullIntegrity(float value)
{
	if (value < 0.0f) value = 0.0f;
	if (value > 100.0f) value = 100.0f;
	hullIntegrity = value;
}
void Ship::augHullIntegrity(float amount)            
{ 
    if (hullIntegrity + amount < 100)
        setHullIntegrity(hullIntegrity+amount); 
    else
        setHullIntegrity(100);
}

void Ship::setArmorIntegrity(float value)
{
	if (value < 0.0f) value = 0.0f;
	if (value > getMaxArmorIntegrity()) value = getMaxArmorIntegrity();
	armorIntegrity = value;
}
void Ship::augArmorIntegrity(float amount)           
{ 
    if (armorIntegrity + amount < 100)
        setArmorIntegrity(armorIntegrity+amount); 
    else
        setArmorIntegrity(100);
}

void Ship::setShieldIntegrity(float value)
{
	if (value < 0.0f) value = 0.0f;
	if (value > 100.0f) value = 100.0f;
	shieldIntegrity = value;
}
void Ship::augShieldIntegrity(float amount)          
{ 
    if (shieldIntegrity + amount < 100)
        setShieldIntegrity(shieldIntegrity+amount); 
    else
        setShieldIntegrity(100);
}

void Ship::setShieldCapacity(float value)
{
	if (value < 0.0f) value = 0.0f;
	if (value > getMaxShieldCapacity()) value = getMaxShieldCapacity();
	shieldCapacity = value;
}
void Ship::augShieldCapacity(float amount)          
{ 
    if (shieldCapacity + amount < 100)
        setShieldCapacity(shieldCapacity+amount); 
    else
        setShieldCapacity(100);
}

void Ship::setEngineIntegrity(float value)
{
	if (value < 0.0f) value = 0.0f;
	if (value > 100.0f) value = 100.0f;
	engineIntegrity = value;
}
void Ship::augEngineIntegrity(float amount)          
{ 
    if (engineIntegrity + amount < 100)
        setEngineIntegrity(engineIntegrity+amount); 
    else
        setEngineIntegrity(100);
}

void Ship::setMissileLauncherIntegrity(float value)
{
	if (value < 0.0f) value = 0.0f;
	if (value > 100.0f) value = 100.0f;
	missileLauncherIntegrity = value;
}
void Ship::augMissileLauncherIntegrity(float amount) 
{ 
    if (missileLauncherIntegrity + amount < 100)
        setMissileLauncherIntegrity(missileLauncherIntegrity+amount); 
    else
        setMissileLauncherIntegrity(100);
}

void Ship::setLaserIntegrity(float value)
{
	if (value < 0.0f) value = 0.0f;
	if (value > 100.0f) value = 100.0f;
	laserIntegrity = value;
}
void Ship::augLaserIntegrity(float amount)           
{ 
    if (laserIntegrity + amount < 100)
        setLaserIntegrity(laserIntegrity+amount); 
    else
        setLaserIntegrity(100);
}

void Ship::setMaxEngineClass(int engineClass)
{
	ASSERT(engineClass >= 1 && engineClass <= 6);
	maxEngineClass = engineClass;
}
void Ship::setMaxArmorClass(int armorClass)
{
	ASSERT(armorClass >= 1 && armorClass <= 6);
	maxArmorClass = armorClass;
}
void Ship::setMaxShieldClass(int shieldClass)
{
	ASSERT(shieldClass >= 1 && shieldClass <= 6);
	maxShieldClass = shieldClass;
}
void Ship::setMaxLaserClass(int laserClass)
{
	ASSERT(laserClass >= 1 && laserClass <= 6);
	maxLaserClass = laserClass;
}
void Ship::setMaxMissileLauncherClass(int missileLauncherClass)
{
	ASSERT(missileLauncherClass >= 1 && missileLauncherClass <= 6);
	maxMissileLauncherClass = missileLauncherClass;
}


void Ship::SendDistressSignal()
{
    //calculate cost of rescue
	Point2D starport_pos(15553,13244);
    double distance = Point2D::Distance( g_game->gameState->player->posHyperspace, starport_pos );
    double cost = ( 5000 + (distance * 10.0) );

    string com = g_game->gameState->officerCom->getFirstName() + "-> ";

    string message = "Myrrdan Port Authority has dispatched a tow ship to bring us in. ";
    message += "The cost of the rescue is " + Util::ToString( cost ) + " MU.";
    g_game->ShowMessageBoxWindow("", message, 500, 300, BLUE, SCREEN_WIDTH/2, SCREEN_HEIGHT/2, true, false);


    //charge player's account for the tow
	g_game->gameState->m_credits -= cost;

    //return to starport
    g_game->setVibration(0);
	g_game->modeMgr->LoadModule(MODULE_PORT);
}

//specials
void Ship::Reset()
{
	/*
	These properties are set in ModuleCaptainCreation based on profession
	NOTE: Actually ModuleCaptainCreation will call this function at the end of the creation process
	      so the values set here are the definitive ones. Presumably this was not the original purpose
	      of this function but it was thereafter hijacked to override ModuleCaptainCreation.
	*/
	//name                     = "Hyperion";
	cargoPodCount            =   0;
	engineClass              =   0; //this will be upgraded with a tutorial mission
	shieldClass              =   0;
	armorClass               =   0;
	missileLauncherClass     =   0;
	laserClass               =   0;
	hullIntegrity            = 100;
	armorIntegrity           =   0;
	shieldIntegrity          =   0;
	engineIntegrity          = 100;
	missileLauncherIntegrity =   0;
	laserIntegrity           =   0;
	hasTV                    =true;
	fuelPercentage           =1.0f;

	/*
	These properties are not stored on disk; they must be recalculated at captain creation and at savegame load
	NOTE: we can't actually reset them here or they will override the one set in captain creation.
	*/
	//maxEngineClass           = 0;
	//maxArmorClass            = 0;
	//maxShieldClass           = 0;
	//maxLaserClass            = 0;
	//maxMissileLauncherClass  = 0;
}

void Ship::RunDiagnostic()
{
	//verify that all ship components are valid?

}

bool Ship::Serialize(Archive& ar)
{
   string ClassName = "Ship";
   int Schema = 0;

   if (ar.IsStoring())
   {
	   ar << ClassName;
	   ar << Schema;

		ar << name;
		ar << cargoPodCount;
		ar << engineClass;
		ar << shieldClass;
		ar << armorClass;
		ar << missileLauncherClass;
		ar << laserClass;
		ar << hullIntegrity;
		ar << armorIntegrity;
		ar << shieldIntegrity;
		ar << engineIntegrity;
		ar << missileLauncherIntegrity;
		ar << laserIntegrity;
		ar << hasTV;
		ar << fuelPercentage;
   }
   else
   {
   	Reset();

      string LoadClassName;
      ar >> LoadClassName;
      if (LoadClassName != ClassName)
         return false;

      int LoadSchema;
      ar >> LoadSchema;
      if (LoadSchema > Schema)
         return false;

		ar >> name;
		ar >> cargoPodCount;
		ar >> engineClass;
		ar >> shieldClass;
		ar >> armorClass;
		ar >> missileLauncherClass;
		ar >> laserClass;
		ar >> hullIntegrity;
		ar >> armorIntegrity;
		ar >> shieldIntegrity;
		ar >> engineIntegrity;
		ar >> missileLauncherIntegrity;
		ar >> laserIntegrity;
		ar >> hasTV;
		ar >> fuelPercentage;
   }

	//we used to allow shieldIntegrity > 100.0f, but now that we distinguish between shield integrity and capacity,
	//integrity can't be greater than 100 anymore.
	if (shieldIntegrity > 100.0f) shieldIntegrity = 100.0f;

	return true;
}

Ship & Ship::operator =(const Ship &rhs)
{
	if (this == &rhs)
		return *this;

	name = rhs.name;
	cargoPodCount = rhs.cargoPodCount;

	engineClass = rhs.engineClass;
	shieldClass = rhs.shieldClass;
	armorClass  = rhs.armorClass;
	laserClass  = rhs.laserClass;
	missileLauncherClass = rhs.missileLauncherClass;

	maxEngineClass = rhs.maxEngineClass;
	maxShieldClass = rhs.maxShieldClass;
	maxArmorClass  = rhs.maxArmorClass;
	maxLaserClass  = rhs.maxLaserClass;
	maxMissileLauncherClass = rhs.maxMissileLauncherClass;

	hullIntegrity   = rhs.hullIntegrity;
	engineIntegrity = rhs.engineIntegrity;
	shieldIntegrity = rhs.shieldIntegrity;
	shieldCapacity  = rhs.shieldCapacity;
	armorIntegrity  = rhs.armorIntegrity;
	laserIntegrity  = rhs.laserIntegrity;
	missileLauncherIntegrity = rhs.missileLauncherIntegrity;

	hasTV = rhs.hasTV;
	fuelPercentage = rhs.fuelPercentage;

	partInRepair = rhs.partInRepair;

	for (int i=0; i<NUM_REPAIR_PARTS; i++){
		repairMinerals[i] = rhs.repairMinerals[i];
		repairCounters[i] = rhs.repairCounters[i];
	}

	return *this;
}

void Ship::damageRandomSystemOrCrew(int odds, int mindamage, int maxdamage)
{
	if (Util::Random(1,100) > odds) return;

	float amount;
//	int health;
	int damage = Util::Random(mindamage,maxdamage);
	int system = Util::Random(0,4); //0=hull,1=laser,2=missile,3=shield,4=engine,5=crew

	switch(system) {
        case 0: 
            //damage the hull
            amount = getHullIntegrity();
            if (amount > 0) {
                amount -= damage;
                if (amount < 0) {
                    amount = 0;
                    g_game->printout(g_game->g_scrollbox,"Ship's Hull has been destroyed.",RED,1000);
                }
            }
            else g_game->printout(g_game->g_scrollbox, "Ship's Hull has been breached!",YELLOW,1000);
            setHullIntegrity(amount);
            break;
        case 1:
			//damage the laser
			amount = getLaserIntegrity();
			if (amount > 1) {
				amount -= damage;
				if (amount < 1) {
					amount = 1;
					//setLaserClass(0); //this is too harsh!
					g_game->printout(g_game->g_scrollbox, "Your laser has been heavily damaged!",RED,1000);
				}
				else g_game->printout(g_game->g_scrollbox, "Laser is sustaining damage.",YELLOW,1000);
				setLaserIntegrity(amount);
			}
			break;
		case 2:
			//damage missile launcher
			amount = getMissileLauncherIntegrity();
			if (amount > 1) {
				amount -= damage;
				if (amount < 1) {
					amount = 1;
					//setMissileLauncherClass(0);
					g_game->printout(g_game->g_scrollbox, "The missile launcher has been heavily damaged!",RED,1000);
				}
				else g_game->printout(g_game->g_scrollbox,"Missile launcher is sustaining damage.",YELLOW,1000);
				setMissileLauncherIntegrity(amount);
			}
			break;
		case 3:
			//damage shield generator
			amount = getShieldIntegrity();
			if (amount > 1) {
				amount -= damage;
				if (amount < 1) {
					amount = 1;
					//setShieldClass(0);
					g_game->printout(g_game->g_scrollbox,"The shield generator has been heavily damaged!",RED,1000);
				}
				else g_game->printout(g_game->g_scrollbox,"Shield generator is sustaining damage.",YELLOW,1000);
				setShieldIntegrity(amount);
			}
			break;
		case 4:
			//damage engine
			amount = getEngineIntegrity();
			if (amount > 1) {
				amount -= damage;
				if (amount < 1) {
					amount = 1;
					//setEngineClass(0);
					g_game->printout(g_game->g_scrollbox,"The engine has been heavily damaged!",RED,1000);
				}
				else g_game->printout(g_game->g_scrollbox,"Engine is sustaining damage.",YELLOW,1000);
				setEngineIntegrity(amount);
			}
			break;

	}
}

//ATTRIBUTES CLASS

Attributes::Attributes()
{
	Reset();
}

Attributes::~Attributes()
{
	Reset();
}

int& Attributes::operator [] (int i)
{
	static int Err = -1;

	switch (i)
	{
		case 0:
			return science;
			break;

		case 1:
			return navigation;
			break;

		case 2:
			return engineering;
			break;

		case 3:
			return communication;
			break;

		case 4:
			return medical;
			break;

		case 5:
			return tactics;
			break;

/*
    6 & 7 were reversed in the artwork so I'm just reversing them here
    if this introduces any weird bugs in the game we'll deal with it
*/
        case 7: //6:
			return durability;
			break;

        case 6: //7:
			return learnRate;
			break;

		default:
			return Err;
			break;
	}
}


Attributes & Attributes::operator =(const Attributes &rhs)
{
	durability = rhs.durability;
	learnRate  = rhs.learnRate;

	science       = rhs.science;
	navigation    = rhs.navigation;
	tactics       = rhs.tactics;
	engineering   = rhs.engineering;
	communication = rhs.communication;
	medical       = rhs.medical;
	vitality      = rhs.vitality;

	extra_variable = rhs.extra_variable;

	return *this;
}

//accessors
int Attributes::getDurability()								const { return durability; }
int Attributes::getLearnRate()								const { return learnRate; }
int Attributes::getScience()								const { return science; }
int Attributes::getNavigation()								const { return navigation; }
int Attributes::getTactics()								const { return tactics; }
int Attributes::getEngineering()							const { return engineering; }
int Attributes::getCommunication()							const { return communication; }
int Attributes::getMedical()								const { return medical; }
float Attributes::getVitality()								const { return vitality; }

//mutators
void Attributes::setDurability(int initDurability)			{ durability = initDurability; }
void Attributes::setLearnRate(int initLearnRate)			{ learnRate = initLearnRate; }
void Attributes::setScience(int initScience)				{ science = initScience; }
void Attributes::setNavigation(int initNavigation)			{ navigation = initNavigation; }
void Attributes::setTactics(int initTactics)				{ tactics = initTactics; }
void Attributes::setEngineering(int initEngineering)		{ engineering = initEngineering; }
void Attributes::setCommunication(int initCommunication)	{ communication = initCommunication; }
void Attributes::setMedical(int initMedical)				{ medical = initMedical;}
void Attributes::setVitality(float initVital)				{ vitality = initVital; capVitality();}
void Attributes::augVitality(float value)					{ vitality += value; capVitality();}
void Attributes::capVitality()								{ if(vitality > 100){vitality = 100;} if(vitality < 0){vitality = 0;} }

void Attributes::Reset()
{
	durability = 0;
	learnRate  = 0;

	science       = 0;
	navigation    = 0;
	tactics       = 0;
	engineering   = 0;
	communication = 0;
	medical       = 0;

	vitality = 100;
	extra_variable = 0;
}

bool Attributes::Serialize(Archive& ar)
{
   string ClassName = "Attributes";
   int Schema = 0;

   if (ar.IsStoring())
   {
      ar << ClassName;
      ar << Schema;

	   ar << durability;
	   ar << learnRate;
	   ar << science;
	   ar << navigation;
	   ar << tactics;
	   ar << engineering;
	   ar << communication;
	   ar << medical;
	   ar << vitality;
	   ar << extra_variable;
   }
   else
   {
      Reset();

      string LoadClassName;
      ar >> LoadClassName;
      if (LoadClassName != ClassName)
         return false;

      int LoadSchema;
      ar >> LoadSchema;
      if (LoadSchema > Schema)
         return false;

	   ar >> durability;
	   ar >> learnRate;
	   ar >> science;
	   ar >> navigation;
	   ar >> tactics;
	   ar >> engineering;
	   ar >> communication;
	   ar >> medical;
	   ar >> vitality;
	   ar >> extra_variable;
   }

   return true;
}

//GAMESTATE CLASS

GameState::GameState():
	m_items(*new Items),
	player(NULL),
	officerCap(NULL),
	officerSci(NULL),
	officerNav(NULL),
	officerTac(NULL),
	officerEng(NULL),
	officerCom(NULL),
	officerDoc(NULL)
{}

GameState::~GameState()
{
	delete &m_items;
	delete player;		player = NULL;
	delete officerCap;	officerCap = NULL;
	delete officerSci;	officerSci = NULL;
	delete officerNav;	officerNav = NULL;
	delete officerTac;	officerTac = NULL;
	delete officerEng;	officerEng = NULL;
	delete officerCom;	officerCom = NULL;
	delete officerDoc;	officerDoc = NULL;

	for (int i=0; i < (int)m_unemployedOfficers.size(); ++i)
	{
		delete m_unemployedOfficers[i];
		m_unemployedOfficers[i] = NULL;
	}
	m_unemployedOfficers.clear();
}

GameState & GameState::operator=(const GameState &rhs)
{
   for (int i = 0; i < NUM_ALIEN_RACES; i++)
      alienAttitudes[i] = rhs.alienAttitudes[i];

	playerPosture = rhs.playerPosture;
	m_gameTimeSecs = rhs.m_gameTimeSecs;
	stardate = rhs.stardate;
	m_captainSelected = rhs.m_captainSelected;
	m_profession = rhs.m_profession;
	m_credits = rhs.m_credits;
	m_items = rhs.m_items;

	delete player; player = new PlayerInfo;
	*player = *rhs.player;

	m_ship = rhs.m_ship;

	fluxSeed = rhs.fluxSeed;

	m_currentSelectedOfficer = rhs.m_currentSelectedOfficer;

	for (int i=0; i < (int)m_unemployedOfficers.size(); ++i)
	{
		delete m_unemployedOfficers[i];
		m_unemployedOfficers[i] = NULL;
	}
	m_unemployedOfficers.clear();
   for (int i = 0; i < (int)rhs.m_unemployedOfficers.size(); i++)
   {
      Officer * newOfficer = new Officer;
      *newOfficer = *rhs.m_unemployedOfficers[i];
      m_unemployedOfficers.push_back(newOfficer);
   }

	delete officerCap; officerCap = new Officer();
	*officerCap = *rhs.officerCap;
	delete officerSci; officerSci = new Officer();
	*officerSci = *rhs.officerSci;
	delete officerNav; officerNav = new Officer();
	*officerNav = *rhs.officerNav;
	delete officerTac; officerTac = new Officer();
	*officerTac = *rhs.officerTac;
	delete officerEng; officerEng = new Officer();
	*officerEng = *rhs.officerEng;
	delete officerCom; officerCom = new Officer();
	*officerCom = *rhs.officerCom;
	delete officerDoc; officerDoc = new Officer();
	*officerDoc = *rhs.officerDoc;

   TotalCargoStacks = rhs.TotalCargoStacks;
   defaultShipCargoSize = rhs.defaultShipCargoSize;

   m_baseGameTimeSecs = rhs.m_baseGameTimeSecs;
   m_gameTimeSecs = rhs.m_gameTimeSecs;

   activeQuest = rhs.activeQuest;
   storedValue = rhs.storedValue;

   currentModeWhenGameSaved= rhs.currentModeWhenGameSaved;
   dirty= false;
	return *this;
}


void PlayerInfo::Reset()
{
   m_scanner = false;
   m_previous_scanner_state = false;
   m_bHasHyperspacePermit = true;
   m_bHasOverdueLoan = false;

	currentStar = 2;
	currentPlanet = 450;
   controlPanelMode = 0; // ?????  NOT SURE WHAT TO SET THIS TO

	posHyperspace.x = g_game->getGlobalNumber("PLAYER_HYPERSPACE_START_X");
	posHyperspace.y = g_game->getGlobalNumber("PLAYER_HYPERSPACE_START_Y");

	posSystem.x = g_game->getGlobalNumber("PLAYER_SYSTEM_START_X");
	posSystem.y = g_game->getGlobalNumber("PLAYER_SYSTEM_START_Y");

	posPlanet.x = 0; //randomized in PlanetSurface module
	posPlanet.y = 0;

   posStarport.x = g_game->getGlobalNumber("PLAYER_STARPORT_START_X");
	posStarport.y = g_game->getGlobalNumber("PLAYER_STARPORT_START_Y");

   posCombat.x = 0;
   posCombat.y = 0;

   m_is_lost = false;
   alive = true;

}

std::string PlayerInfo::getAlienRaceName(int race)
{
	switch(race) {
		case 1:		return "Pirate"; break;
		case 2:		return "Elowan"; break;
		case 3:		return "Spemin"; break;
		case 4:		return "Thrynn"; break;
		case 5:		return "Barzhon"; break;
		case 6:		return "Nyssian"; break;
		case 7:		return "Tafel"; break;
		case 8:		return "Minex"; break;
		case 9: 	return "Coalition"; break;
		default:	return "None"; break;
	}
	return "";
}

std::string PlayerInfo::getAlienRaceName(AlienRaces race)
{
    return getAlienRaceName( (int) race );
}

std::string PlayerInfo::getAlienRaceNamePlural(AlienRaces race)
{
	switch(race) {
		case ALIEN_ELOWAN:		return "Elowan"; break;
		case ALIEN_SPEMIN:		return "Spemin"; break;
		case ALIEN_THRYNN:		return "Thrynn"; break;
		case ALIEN_BARZHON:		return "Barzhon"; break;
		case ALIEN_NYSSIAN:		return "Nyssian"; break;
		case ALIEN_TAFEL:		return "Tafel"; break;
		case ALIEN_MINEX:		return "Minex"; break;
		case ALIEN_COALITION:	return "Coalition"; break;
		case ALIEN_PIRATE:		return "Pirates"; break;
		default:				return "None"; break;
	}
	return "";
}

bool PlayerInfo::Serialize(Archive& ar)
{
   string ClassName = "PlayerInfo";
   int Schema = 0;

   if (ar.IsStoring())
   {
      ar << ClassName;
      ar << Schema;

      ar << m_scanner;
      ar << m_previous_scanner_state;
      ar << m_bHasHyperspacePermit;
      ar << m_bHasOverdueLoan;

      ar << currentStar;
      ar << currentPlanet;
      ar << controlPanelMode;

      if (!posHyperspace.Serialize(ar))
         return false;

      if (!posSystem.Serialize(ar))
         return false;

      if (!posPlanet.Serialize(ar))
         return false;

      if (!posStarport.Serialize(ar))
         return false;

      if (!posCombat.Serialize(ar))
         return false;
   }
   else
   {
      string LoadedClassName;
      ar >> LoadedClassName;
      if (LoadedClassName != ClassName)
         return false;

      int LoadedSchema;
      ar >> LoadedSchema;
      if (LoadedSchema > Schema)
         return false;

      ar >> m_scanner;
      ar >> m_previous_scanner_state;
      ar >> m_bHasHyperspacePermit;
      ar >> m_bHasOverdueLoan;

      ar >> currentStar;
      ar >> currentPlanet;
      ar >> controlPanelMode;

      if (!posHyperspace.Serialize(ar))
         return false;

      if (!posSystem.Serialize(ar))
         return false;

      if (!posPlanet.Serialize(ar))
         return false;

      if (!posStarport.Serialize(ar))
         return false;

      if (!posCombat.Serialize(ar))
         return false;
   }

   return true;
}

PlayerInfo& PlayerInfo::operator=(const PlayerInfo& rhs)
{
   if (this == &rhs)
      return *this;

   m_scanner = rhs.m_scanner;
   m_previous_scanner_state = rhs.m_previous_scanner_state;
   m_bHasHyperspacePermit = rhs.m_bHasHyperspacePermit;
   m_bHasOverdueLoan = rhs.m_bHasOverdueLoan;

   currentStar = rhs.currentStar;
   currentPlanet = rhs.currentPlanet;
   controlPanelMode = rhs.controlPanelMode;

   posHyperspace = rhs.posHyperspace;
   posSystem = rhs.posSystem;
   posPlanet = rhs.posPlanet;
   posStarport = rhs.posStarport;
   posCombat = rhs.posCombat;

   return *this;
}

/*
 * This resets the GameState to the default values
 */
void GameState::Reset()
{
	//initialize alien race attitudes
	alienAttitudes[ALIEN_ELOWAN] = 80;
	alienAttitudes[ALIEN_SPEMIN] = 50;
	alienAttitudes[ALIEN_THRYNN] = 50;
	alienAttitudes[ALIEN_BARZHON] = 40;
	alienAttitudes[ALIEN_NYSSIAN] = 60;
	alienAttitudes[ALIEN_TAFEL] = 95;
	alienAttitudes[ALIEN_MINEX] = 20;
	alienAttitudes[ALIEN_COALITION] = 10;
	alienAttitudes[ALIEN_PIRATE] = 10;

	//start alien attitude update time
	alienAttitudeUpdate = g_game->globalTimer.getTimer();

	//initialize player's posture
	playerPosture = "friendly";

	m_gameTimeSecs = 0;
	m_baseGameTimeSecs = 0;

	stardate.Reset();	//altered to use current object.
	//Stardate sdNew;
	//g_game->gameState->stardate = sdNew;

	setCaptainSelected(false);

	setProfession(PROFESSION_MILITARY);

	//player starts with nothing and given things via missions
	setCredits(0);

	m_items.Reset();

	//initialize player data
	if (player != NULL) { delete player;  player = NULL; }
	player = new PlayerInfo;
	player->Reset();

	//This returns the ship's values to the defaults
	m_ship.Reset();

	//Those values are not used anywhere anymore but must be conserved to preserve savegame compatibility
	defaultShipCargoSize = 0;
	TotalCargoStacks = 0;

	init_fluxSeed();

	m_currentSelectedOfficer = OFFICER_CAPTAIN;

	for (int i=0; i < (int)m_unemployedOfficers.size(); ++i)
	{
		delete m_unemployedOfficers[i];
		m_unemployedOfficers[i] = NULL;
	}
	m_unemployedOfficers.clear();

	if (officerCap != NULL) { delete officerCap; officerCap = NULL; }
	officerCap = new Officer(OFFICER_CAPTAIN);

	if (officerSci != NULL) { delete officerSci; officerSci = NULL; }
	officerSci = new Officer(OFFICER_SCIENCE);

	if (officerNav != NULL) { delete officerNav; officerNav = NULL; }
	officerNav = new Officer(OFFICER_NAVIGATION);

	if (officerTac != NULL) { delete officerTac; officerTac = NULL; }
	officerTac = new Officer(OFFICER_TACTICAL);

	if (officerEng != NULL) { delete officerEng; officerEng = NULL; }
	officerEng = new Officer(OFFICER_ENGINEER);

	if (officerCom != NULL) { delete officerCom; officerCom = NULL; }
	officerCom = new Officer(OFFICER_COMMUNICATION);

	if (officerDoc != NULL) { delete officerDoc; officerDoc = NULL; }
	officerDoc = new Officer(OFFICER_MEDICAL);


	////////////////////////////////////////////////////////////////////////////
	// RANDOM OFFICER POPULATION - BEGIN
	// * These data should be overwritten when the crew is loaded from a savegame file
	// * or replaced. This should eventually be removed.
	////////////////////////////////////////////////////////////////////////////
/*
	setCaptainSelected(true);

	//initialize profession (should be needed only during testing)
	this->m_profession = PROFESSION_MILITARY;

	if (officerCap != NULL)
	{
		delete officerCap;
		officerCap = NULL;
	}
	//create the captain
	officerCap = new Officer(OFFICER_CAPTAIN);
	officerCap->name = g_game->dataMgr->GetRandMixedName();
	for (int i=0; i < 6; i++)
		officerCap->attributes[i] = Util::Random(10,200);
	officerCap->attributes[6] = Util::Random(1,25);
	officerCap->attributes[7] = Util::Random(1,25);

	if (officerSci != NULL)
	{
		delete officerSci;
		officerSci = NULL;
	}
	//create the science officer
	officerSci = new Officer(OFFICER_SCIENCE);
	officerSci->name = g_game->dataMgr->GetRandMixedName();
	for (int i=0; i < 6; i++)
		officerSci->attributes[i] = Util::Random(10,200);
	officerSci->attributes[6] = Util::Random(1,25);
	officerSci->attributes[7] = Util::Random(1,25);

	if (officerNav != NULL)
	{
		delete officerNav;
		officerNav = NULL;
	}
	//create the navigation officer
	officerNav = new Officer(OFFICER_NAVIGATION);
	officerNav->name = g_game->dataMgr->GetRandMixedName();
	for (int i=0; i < 6; i++)
		officerNav->attributes[i] = Util::Random(10,200);
	officerNav->attributes[6] = Util::Random(1,25);
	officerNav->attributes[7] = Util::Random(1,25);

	if (officerEng != NULL)
	{
		delete officerEng;
		officerEng = NULL;
	}
	//create the engineering officer
	officerEng = new Officer(OFFICER_ENGINEER);
	officerEng->name = g_game->dataMgr->GetRandMixedName();
	for (int i=0; i < 6; i++)
		officerEng->attributes[i] = Util::Random(10,200);
	officerEng->attributes[6] = Util::Random(1,25);
	officerEng->attributes[7] = Util::Random(1,25);

	if (officerCom != NULL)
	{
		delete officerCom;
		officerCom = NULL;
	}
	//create the communications officer
	officerCom = new Officer(OFFICER_COMMUNICATION);
	officerCom->name = g_game->dataMgr->GetRandMixedName();
	for (int i=0; i < 6; i++)
		officerCom->attributes[i] = Util::Random(10,200);
	officerCom->attributes[6] = Util::Random(1,25);
	officerCom->attributes[7] = Util::Random(1,25);

	if (officerDoc != NULL)
	{
		delete officerDoc;
		officerDoc = NULL;
	}
	//create the medical officer
	officerDoc = new Officer(OFFICER_MEDICAL);
	officerDoc->name = g_game->dataMgr->GetRandMixedName();
	for (int i=0; i < 6; i++)
		officerDoc->attributes[i] = Util::Random(10,200);
	officerDoc->attributes[6] = Util::Random(1,25);
	officerDoc->attributes[7] = Util::Random(1,25);

	if (officerTac != NULL)
	{
		delete officerTac;
		officerTac = NULL;
	}
	//create the tactical officer
	officerTac = new Officer(OFFICER_TACTICAL);
	officerTac->name = g_game->dataMgr->GetRandMixedName();
	for (int i=0; i < 6; i++)
		officerTac->attributes[i] = Util::Random(10,200);
	officerTac->attributes[6] = Util::Random(1,25);
	officerTac->attributes[7] = Util::Random(1,25);
*/
	////////////////////////////////////////////////////////////////////////////
	//
	// RANDOM OFFICER POPULATION - END
	//
	////////////////////////////////////////////////////////////////////////////

	//initial tactical properties
	shieldStatus = false;
	weaponStatus = false;

   currentModeWhenGameSaved = "";

   //current stage of the game, INITIAL=1,VIRUS=2,WAR=3,ANCIENTS=4
   plotStage = 1;

   //quest related state variables
   activeQuest = 1; // -1;  bug fix
   storedValue= -1;
   questCompleted = false;
   firstTimeVisitor = true;
}

/*
 * This function will either serialize the current game into the Archive or pull from it depending on whether
 * the archive is flagged for storing.
 */
bool GameState::Serialize(Archive& ar)
{
   string ClassName = "GameState";
   int Schema = 0;
   Schema = 1; // dsc - added currentModeWhenGameSaved

   if (ar.IsStoring())
   {
		ar << ClassName;
		ar << Schema;

      ar << (int)NUM_ALIEN_RACES;
      for (int i = 0; i < NUM_ALIEN_RACES; i++)
         ar << alienAttitudes[i];

      ar << playerPosture;

	  //the base game time is added to the current ms timer to get an accurate
	  //date (from gameTimeSecs), so we save gameTimeSecs, but read back into
	  //baseGameTimeSecs:
	   //ar << (double)(m_baseGameTimeSecs + m_gameTimeSecs);	//m_gameTimeSecs already includes base.
	   ar << (double) m_gameTimeSecs;

	   if (!stardate.Serialize(ar))
		   return false;

	   ar << m_captainSelected;
	   ar << (int)m_profession;

      ar << m_credits;

      if (!m_items.Serialize(ar))
         return false;

      if (!player->Serialize(ar))
         return false;

      if (!m_ship.Serialize(ar))
         return false;

	   ar << fluxSeed;

      ar << (int)m_currentSelectedOfficer;

      ar << (int)m_unemployedOfficers.size();
      for (vector<Officer*>::iterator i = m_unemployedOfficers.begin(); i != m_unemployedOfficers.end(); ++i)
      {
         if (!(*i)->Serialize(ar))
            return false;
      }

	   //serialize the officers/crew
      int numOfficers = 7;
      ar << numOfficers;
	   if (!officerCap->Serialize(ar)) return false;
	   if (!officerSci->Serialize(ar)) return false;
	   if (!officerNav->Serialize(ar)) return false;
	   if (!officerEng->Serialize(ar)) return false;
	   if (!officerCom->Serialize(ar)) return false;
	   if (!officerTac->Serialize(ar)) return false;
	   if (!officerDoc->Serialize(ar)) return false;

      ar << TotalCargoStacks;
      ar << defaultShipCargoSize;

      currentModeWhenGameSaved = g_game->modeMgr->GetCurrentModuleName();
      ar << currentModeWhenGameSaved;

	  //save quest data
	  ar << activeQuest;
	  //storedValue keeps track of current quest objective
	  //ar << g_game->questMgr->storedValue;
	  ar << storedValue;

   }
   // READING ARCHIVE INSTEAD OF STORING
   else
   {
		Reset();

		string LoadClassName;
		ar >> LoadClassName;
		if (LoadClassName != ClassName)
		 return false;

		int LoadSchema;
		ar >> LoadSchema;
      if (LoadSchema > Schema)
         return false;

      int LoadedNumAlienRaces;
      ar >> LoadedNumAlienRaces;
      for (int i = 0; (i < LoadedNumAlienRaces) && (i < NUM_ALIEN_RACES); i++)
         ar >> alienAttitudes[i];

      ar >> playerPosture;


	  //the base game time is added to the current ms timer to get an accurate
	  //date (from gameTimeSecs), so we save gameTimeSecs, but read back into
	  //baseGameTimeSecs:
	  ar >> m_baseGameTimeSecs;

		if (!stardate.Serialize(ar))
         return false;

		ar >> m_captainSelected;

      int tmpi;
		ar >> tmpi;
		m_profession = (ProfessionType)tmpi;

      ar >> m_credits;

      if (!m_items.Serialize(ar))
         return false;

      if (!player->Serialize(ar))
         return false;

      if (!m_ship.Serialize(ar))
         return false;

      ar >> fluxSeed;

      int LoadedCurrentlySelectedOfficer;
      ar >> LoadedCurrentlySelectedOfficer;
      m_currentSelectedOfficer = (OfficerType)LoadedCurrentlySelectedOfficer;

      int LoadedNumUnemployedOfficers;
      ar >> LoadedNumUnemployedOfficers;
      for (int i = 0; i < LoadedNumUnemployedOfficers; i++)
      {
         Officer * newOfficer = new Officer;
         if (!newOfficer->Serialize(ar))
         {
            delete newOfficer;
            return false;
         }
         m_unemployedOfficers.push_back(newOfficer);
      }

		//Load Officers
      int LoadedNumOfficers;
      ar >> LoadedNumOfficers;
		if (!officerCap->Serialize(ar)) return false;
		if (!officerSci->Serialize(ar)) return false;
		if (!officerNav->Serialize(ar)) return false;
		if (!officerEng->Serialize(ar)) return false;
		if (!officerCom->Serialize(ar)) return false;
		if (!officerTac->Serialize(ar)) return false;
		if (!officerDoc->Serialize(ar)) return false;

      ar >> TotalCargoStacks;
      ar >> defaultShipCargoSize;

      if (LoadSchema >= 1)
         ar >> currentModeWhenGameSaved;

	  //load quest data
	  ar >> activeQuest;
	  ar >> storedValue;
	  //ar >> g_game->questMgr->storedValue;
   }

   return true;
}

std::string GameState::currentSaveGameFile;

#define GAME_MAGIC  0xAAFFAAFF
#define GAME_STRING "StarflightTLC-SaveGame"
#define GAME_SCHEMA 0

bool GameState::SaveGame(std::string fileName)
{
   currentSaveGameFile = fileName;

   Archive ar;
	if (!ar.Open(fileName,Archive::AM_STORE))
		return false;

	int GameMagic = GAME_MAGIC;
   ar << GameMagic;

   string GameString = GAME_STRING;
   ar << GameString;

   int GameSchema = GAME_SCHEMA;
   ar << GameSchema;

	if (!Serialize(ar))
   {
      ar.Close();
      return false;
   }

   ar << GameMagic;

   ar.Close();

	return true;
}

GameState* GameState::ReadGame(std::string fileName)
{
   currentSaveGameFile = fileName;

	Archive ar;
	if (!ar.Open(fileName,Archive::AM_LOAD)) {
		TRACE("*** GameState: Cannot open save game file");
		return NULL;
	}

	//numeric code uniquely identifying this game's file
   int LoadedGameMagic;
   ar >> LoadedGameMagic;
   if ( (unsigned int) LoadedGameMagic != GAME_MAGIC ) {
	   g_game->message("Invalid save game file");
       TRACE("*** GameState: Invalid save game file");
      return NULL;
   }

   //unique string for this savegame file
   string LoadedGameString;
   ar >> LoadedGameString;
   if (LoadedGameString != GAME_STRING) {
	   g_game->message("Invalid save game file");
       TRACE("*** GameState: Invalid save game file");
      return NULL;
   }

   //schema number--not really needed
   int LoadedGameSchema = 0;
   ar >> LoadedGameSchema;
   if (LoadedGameSchema > GAME_SCHEMA) {
	   TRACE("*** GameState: Incorrect schema in save game file");
      return NULL;
   }

	GameState * g = new GameState;
	g->Reset();

	if (!g->Serialize(ar))
	{
		TRACE("*** GameState: Error reading save game file");
		delete g;
		ar.Close();
		return NULL;
	}

   LoadedGameMagic = 0;
   ar >> LoadedGameMagic;
   if ( (unsigned int) LoadedGameMagic != GAME_MAGIC )
   {
	   TRACE("*** GameState: Error loading save game file");
      delete g;
      ar.Close();
      return NULL;
   }

	ar.Close();
	return g;
}

GameState * GameState::LoadGame(std::string fileName) {
	TRACE("\n");
	GameState* gs= ReadGame(fileName);
	if (gs == NULL) {TRACE(" in GameState::LoadGame\n"); return gs; }	//message picks up where ReadGame left off.

	gs->m_captainSelected= true;
	*g_game->gameState= *gs;		//assign to game state.
	delete gs;						//return reference pointer only (to game state).


	g_game->globalTimer.reset();	//reset the global timer (logic from CaptainsLounge module)
	//restart the quest mgr
	if (!g_game->questMgr->Initialize())
		g_game->fatalerror("GameState::LoadGame(): Error initializing quest manager");

	/* Copy baseGameTimeSecs into the gameTimeSecs (note this could be done on assignment;
	   in order to keep code functions compartmentalized, it is done here along with all
	   other manipulations related to GameState initialization). This assignment is done to
	   avoid issues related to reloading a saved game starting in a time-paused module such
	   as the Captain's Lounge, from another module with unpaused time. (=> baseGameTimeSecs
	   is set using gameTimeSecs, which is assumed to have been previously updated itself
	   from baseGameTimeSecs and the timer ) */
	g_game->gameState->setGameTimeSecs(g_game->gameState->getBaseGameTimeSecs());

	//Update the quest completion status:
	g_game->questMgr->getActiveQuest();
	int reqCode = g_game->questMgr->questReqCode;
	int reqType = g_game->questMgr->questReqType;
    int reqAmt = g_game->questMgr->questReqAmt;
	g_game->questMgr->VerifyRequirements( reqCode, reqType, reqAmt );

	//Set the corresponding plot stage
	switch ( g_game->gameState->getActiveQuest() ) {
		case 36: g_game->gameState->setPlotStage(2); break;
		case 37: g_game->gameState->setPlotStage(3); break;
		case 38: case 39: g_game->gameState->setPlotStage(4); break;

		default: g_game->gameState->setPlotStage(1); break;
	}


	//Set maximum ship upgrades available given captain profession
	int maxEngineClass=0, maxShieldClass=0, maxArmorClass=0, maxMissileLauncherClass=0, maxLaserClass=0;
	switch(g_game->gameState->getProfession()) {
		case PROFESSION_FREELANCE:
			maxEngineClass          = g_game->getGlobalNumber("PROF_FREELANCE_ENGINE_MAX");
			maxShieldClass          = g_game->getGlobalNumber("PROF_FREELANCE_SHIELD_MAX");
			maxArmorClass           = g_game->getGlobalNumber("PROF_FREELANCE_ARMOR_MAX");
			maxMissileLauncherClass = g_game->getGlobalNumber("PROF_FREELANCE_MISSILE_MAX");
			maxLaserClass           = g_game->getGlobalNumber("PROF_FREELANCE_LASER_MAX");
			break;
		case PROFESSION_MILITARY:
			maxEngineClass          = g_game->getGlobalNumber("PROF_MILITARY_ENGINE_MAX");
			maxShieldClass          = g_game->getGlobalNumber("PROF_MILITARY_SHIELD_MAX");
			maxArmorClass           = g_game->getGlobalNumber("PROF_MILITARY_ARMOR_MAX");
			maxMissileLauncherClass = g_game->getGlobalNumber("PROF_MILITARY_MISSILE_MAX");
			maxLaserClass           = g_game->getGlobalNumber("PROF_MILITARY_LASER_MAX");
			break;
		case PROFESSION_SCIENTIFIC:
			maxEngineClass          = g_game->getGlobalNumber("PROF_SCIENCE_ENGINE_MAX");
			maxShieldClass          = g_game->getGlobalNumber("PROF_SCIENCE_SHIELD_MAX");
			maxArmorClass           = g_game->getGlobalNumber("PROF_SCIENCE_ARMOR_MAX");
			maxMissileLauncherClass = g_game->getGlobalNumber("PROF_SCIENCE_MISSILE_MAX");
			maxLaserClass           = g_game->getGlobalNumber("PROF_SCIENCE_LASER_MAX");
			break;
		default:
			//cant happen
			ASSERT(0);
	}

	g_game->gameState->m_ship.setMaxEngineClass(maxEngineClass);
	g_game->gameState->m_ship.setMaxShieldClass(maxShieldClass);
	g_game->gameState->m_ship.setMaxArmorClass(maxArmorClass);
	g_game->gameState->m_ship.setMaxMissileLauncherClass(maxMissileLauncherClass);
	g_game->gameState->m_ship.setMaxLaserClass(maxLaserClass);

	g_game->gameState->m_ship.setShieldCapacity(g_game->gameState->m_ship.getMaxShieldCapacity());

	//Roll random repair minerals and set the repair counters
	g_game->gameState->m_ship.initializeRepair();

	#ifdef DEBUG
	DumpStats(g_game->gameState);	//dump statistics to file.
	#endif
	TRACE("Game state loaded successfully\n");
	return g_game->gameState;		//return gs & leave deletion to caller?
}

void GameState::AutoSave()
{
	if (currentSaveGameFile.size() == 0) {
		g_game->ShowMessageBoxWindow("", "There is no active player savegame file!");
		return;
	}

   SaveGame(currentSaveGameFile);

   g_game->ShowMessageBoxWindow("", "Game state has been saved", 400, 200, GREEN);

}

void GameState::AutoLoad()
{
	if (currentSaveGameFile.size() == 0) {
		g_game->ShowMessageBoxWindow("", "There is no active player savegame file to load!");
		return;
	}

   GameState* lgs = LoadGame(currentSaveGameFile);
	//if (lgs != NULL)		//logic now handled in LoadGame
	//{
	//   lgs->m_captainSelected = true;
	//   *this = *lgs;
	//   delete lgs;
	//}

	if (lgs != NULL)
		g_game->ShowMessageBoxWindow("", "Game has been restored to last save point", 400, 200, GREEN);
	else
		g_game->ShowMessageBoxWindow("", "Game save file could not be found/opened!", 400, 200, GREEN);

   if (currentModeWhenGameSaved.size() > 0)
   {
      g_game->modeMgr->LoadModule(currentModeWhenGameSaved);
	  return;
   }

}

//accessors


//Stardate GameState::getStardate()								const { return m_stardate; }
bool GameState::isCaptainSelected()								const { return m_captainSelected; }
ProfessionType GameState::getProfession()						const { return m_profession; }
int GameState::getCredits()										const { return m_credits; }

string GameState::getProfessionString()
{
	switch (getProfession()) {
		case PROFESSION_NONE:		return "none"; break;
		case PROFESSION_FREELANCE:	return "freelance"; break;
		case PROFESSION_MILITARY:	return "military"; break;
		case PROFESSION_SCIENTIFIC: return "scientific"; break;
		case PROFESSION_OTHER:		return "other"; break;
	}
	return "";
}


// Helper function in case some module doesn't like to work directly with explicit officer objects
Officer *GameState::getOfficer(int officerType)
{
	switch(officerType)
	{
		case OFFICER_CAPTAIN:			return officerCap; break;
		case OFFICER_SCIENCE:			return officerSci; break;
		case OFFICER_NAVIGATION:		return officerNav; break;
		case OFFICER_ENGINEER:			return officerEng; break;
		case OFFICER_COMMUNICATION:		return officerCom; break;
		case OFFICER_MEDICAL:			return officerDoc; break;
		case OFFICER_TACTICAL:			return officerTac; break;
		default: ASSERT(0);
	}

	//UNREACHABLE

	//to keep the compiler happy
	return NULL;
}

// Helper function in case some module doesn't like to work directly with explicit officer objects
Officer *GameState::getOfficer(std::string officerName)
{
	if (officerName == "CAPTAIN")
		return officerCap;
	else if (officerName == "SCIENCE" || officerName == "SCIENCE OFFICER")
		return officerSci;
	else if (officerName == "NAVIGATION" || officerName == "NAVIGATOR")
		return officerNav;
	else if (officerName == "ENGINEER" || officerName == "ENGINEERING" || officerName == "ENGINEERING OFFICER")
		return officerEng;
	else if (officerName == "COMMUNICATION" || officerName == "COMMUNICATIONS")
		return officerCom;
	else if (officerName == "MEDICAL" || officerName == "MEDICAL OFFICER" || officerName == "DOCTOR")
		return officerDoc;
	else if (officerName == "TACTICAL" || officerName == "TACTICAL OFFICER")
		return officerTac;
	else
		ASSERT(0);

	//to keep the compiler happy
	return NULL;
}

//return the officer who currently fill the given role
Officer* GameState::getCurrentSci() { return (officerSci->attributes.vitality > 0)? officerSci : officerCap; }
Officer* GameState::getCurrentNav() { return (officerNav->attributes.vitality > 0)? officerNav : officerCap; }
Officer* GameState::getCurrentTac() { return (officerTac->attributes.vitality > 0)? officerTac : officerCap; }
Officer* GameState::getCurrentEng() { return (officerEng->attributes.vitality > 0)? officerEng : officerCap; }
Officer* GameState::getCurrentCom() { return (officerCom->attributes.vitality > 0)? officerCom : officerCap; }
Officer* GameState::getCurrentDoc() { return (officerDoc->attributes.vitality > 0)? officerDoc : officerCap; }

Officer* GameState::getCurrentOfficerByType(OfficerType officertype)
{
	switch(officertype){
		case OFFICER_CAPTAIN       : return officerCap;
		case OFFICER_SCIENCE       : return getCurrentSci();
		case OFFICER_NAVIGATION    : return getCurrentNav();
		case OFFICER_ENGINEER      : return getCurrentEng();
		case OFFICER_COMMUNICATION : return getCurrentCom();
		case OFFICER_MEDICAL       : return getCurrentDoc();
		case OFFICER_TACTICAL      : return getCurrentTac();

		default: ASSERT(0);		
	}

	//to keep the compiler happy
	return NULL;
}

//calculate effective skill level taking into account vitality and captain modifier
int GameState::CalcEffectiveSkill(Skill skill)
{
	float cap_vitality = officerCap->attributes.vitality;
	float cap_skill, off_vitality, off_skill;

	switch(skill){
		case SKILL_SCIENCE:
			cap_skill = officerCap->attributes.science;
			off_skill = officerSci->attributes.science;
			off_vitality = officerSci->attributes.vitality;
			break;
		case SKILL_NAVIGATION:
			cap_skill = officerCap->attributes.navigation;
			off_skill = officerNav->attributes.navigation;
			off_vitality = officerNav->attributes.vitality;
			break;
		case SKILL_TACTICAL:
			cap_skill = officerCap->attributes.tactics;
			off_skill = officerTac->attributes.tactics;
			off_vitality = officerTac->attributes.vitality;
			break;
		case SKILL_ENGINEERING:
			cap_skill = officerCap->attributes.engineering;
			off_skill = officerEng->attributes.engineering;
			off_vitality = officerEng->attributes.vitality;
			break;
		case SKILL_COMMUNICATION:
			cap_skill = officerCap->attributes.communication;
			off_skill = officerCom->attributes.communication;
			off_vitality = officerCom->attributes.vitality;
			break;
		case SKILL_MEDICAL:
			cap_skill = officerCap->attributes.medical;
			off_skill = officerDoc->attributes.medical;
			off_vitality = officerDoc->attributes.vitality;
			break;

		default: ASSERT(0);
	}

	float res = (off_vitality > 0)?
		off_skill*off_vitality/100 + cap_skill/10*cap_vitality/100 :
		cap_skill*cap_vitality/100;

//	TRACE("CalcSkill: skill %d, cap_skill %f, cap_vitality %f, off_skill %f, off_vitality %f, res %f\n",
//				skill,cap_skill,cap_vitality,off_skill,off_vitality,res);

	return res;
}

/**
  this does the same thing as Officer::SkillCheck() except that it does take into account that officers
  can be replaced by the captain when they are dead, it also does take into account vitality and captain
  modifier.
**/
bool GameState::SkillCheck(Skill skill)
{
	Officer *tempOfficer;
	int skill_value = 0;
	int chance = 0;

	switch(skill){
		case SKILL_SCIENCE:
			tempOfficer = getCurrentSci();
			skill_value = CalcEffectiveSkill(SKILL_SCIENCE);
			break;
		case SKILL_ENGINEERING:
			tempOfficer = getCurrentEng();
			skill_value = CalcEffectiveSkill(SKILL_ENGINEERING);
			break;
		case SKILL_MEDICAL:
			tempOfficer = getCurrentDoc();
			skill_value = CalcEffectiveSkill(SKILL_MEDICAL);
			break;
		case SKILL_NAVIGATION:
			tempOfficer = getCurrentNav();
			skill_value = CalcEffectiveSkill(SKILL_NAVIGATION);
			break;
		case SKILL_TACTICAL:
			tempOfficer = getCurrentTac();
			skill_value = CalcEffectiveSkill(SKILL_TACTICAL);
			break;
		case SKILL_COMMUNICATION:
			tempOfficer = getCurrentCom();
			skill_value = CalcEffectiveSkill(SKILL_COMMUNICATION);
			break;
		default:
			ASSERT(0);
	}

	//this is to set tempOfficer->lastSkillCheck to current stardate
	tempOfficer->FakeSkillCheck();

    //250+ is guaranteed pass
	if (skill_value > 250) {
		return true;
	}
    //any below 200 is % chance to pass skill check
    else if(skill_value > 200) {
		chance = 90;
	}
    else if(skill_value > 150) {
		chance = 80;
	}
    else if(skill_value > 100) {
		chance = 70;
	}
    else if(skill_value > 75) {
		chance = 60;
    }
    else if(skill_value > 50) {
        chance = 50;
    }
	else 
		chance = 25;


    int roll = rand()%100;
	return roll < chance;
}

Ship GameState::getShip()										const { return m_ship; }
bool GameState::HaveFullCrew() const
{
	//officer assignment is determined now by NAME, not NULL condition
	//if all officers have a name, then state will be true
	bool state = (officerCap->name.length() != 0);
	state &= (officerSci->name.length() != 0);
	state &= (officerNav->name.length() != 0);
	state &= (officerEng->name.length() != 0);
	state &= (officerCom->name.length() != 0);
	state &= (officerTac->name.length() != 0);
	state &= (officerDoc->name.length() != 0);

	return state;
}
bool GameState::PreparedToLaunch() const
{
	return HaveFullCrew() && m_ship.HaveEngines();
}

AlienRaces GameState::getCurrentAlien() {return player->getGalacticRegion(); }
string GameState::getCurrentAlienName() {return player->getAlienRaceNamePlural(getCurrentAlien()); }
int GameState::getAlienAttitude() {AlienRaces region= getCurrentAlien();	return alienAttitudes[region]; }

//mutators
//void GameState::setStardate(const Stardate &initStardate)							{ m_stardate = initStardate; }
void GameState::setCaptainSelected(bool initCaptainSelected)						{ m_captainSelected = initCaptainSelected; }
void GameState::setProfession(const ProfessionType &initProfession)					{ m_profession = initProfession; }
void GameState::setCredits(int initCredits)											{ m_credits = initCredits; }
void GameState::augCredits(int amount)												{ m_credits += amount; }
void GameState::setShip(const Ship &initShip)										{ m_ship = initShip; }

void GameState::setProfession(string profession) {
	if 		(profession == "none")			m_profession= PROFESSION_NONE;
	else if (profession == "freelance")		m_profession= PROFESSION_FREELANCE;
	else if (profession == "military")		m_profession= PROFESSION_MILITARY;
	else if (profession == "scientific")	m_profession= PROFESSION_SCIENTIFIC;
	else if (profession == "other")			m_profession= PROFESSION_OTHER;
	else									m_profession= PROFESSION_OTHER;
}

void GameState::setAlienAttitude(int value) {
	if (value < 0) value= 0;					if (value > 100) value= 100;
	AlienRaces region= getCurrentAlien();		alienAttitudes[region]= value;
}
