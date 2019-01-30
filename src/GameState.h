/*
	STARFLIGHT - THE LOST COLONY
	GameState.h - ?
	Author: ?
	Date: ?

*/

#ifndef GAMESTATE_H
#define GAMESTATE_H

#include "debug.h"		//prefs for debug modes, keys, etc.
#include "env.h"
#include <allegro.h>
#include <string>
#include <vector>
#include <map>

#include "Point2D.h"
#include "Stardate.h"
#include "DataMgr.h"

class Items;
class Archive;
class Quest;

enum Faction
{
    Myrrdan = 0,
    Elowan,
    Veloxi,
    Spemin,
    Thrynn,
    BarZhon,
    Nyssian,
    Tafel,
    Minex,
    TheCoalition
};

//I hesitate to introduce a duplicate enum but Faction is incorrect
//  * it does not have a NONE option
//  * Pirate is missing
//  * Myrrdan is not an alien race
//  * Veloxi is not an alien race

enum AlienRaces {
	ALIEN_NONE = 0,
	ALIEN_PIRATE,
	ALIEN_ELOWAN,
	ALIEN_SPEMIN,
	ALIEN_THRYNN,
	ALIEN_BARZHON,
	ALIEN_NYSSIAN,
	ALIEN_TAFEL,
	ALIEN_MINEX,
	ALIEN_COALITION
};
#define NUM_ALIEN_RACES 10

//ATTRIBUTES CLASS
enum Skill {
	SKILL_SCIENCE = 0,
	SKILL_NAVIGATION,
	SKILL_TACTICAL,
	SKILL_ENGINEERING,
	SKILL_COMMUNICATION,
	SKILL_MEDICAL
};

class Attributes
{
public:

	Attributes();
	virtual ~Attributes();

	Attributes & operator =(const Attributes &rhs);

	int& operator [] (int i);

	int durability;
	int learnRate;

	int science;
	int navigation;
	int tactics;
	int engineering;
	int communication;
	int medical;

	float vitality; //the health of the officer
	float extra_variable;

	//accessors
	int getDurability() const;
	int getLearnRate() const;
	int getScience() const;
	int getNavigation() const;
	int getTactics() const;
	int getEngineering() const;
	int getCommunication() const;
	int getMedical() const;
	float getVitality() const;

	//mutators
	void setDurability(int initDurability);
	void setLearnRate(int initLearnRate);
	void setScience(int initScience);
	void setNavigation(int initNavigation);
	void setTactics(int initTactics);
	void setEngineering(int initEngineering);
	void setCommunication(int initCommunication);
	void setMedical(int initMedical);

	void setVitality(float initVital);
	void augVitality(float value);
	void capVitality();

	void Reset();
	bool Serialize(Archive &ar);
};

//OFFICER CLASS

enum ProfessionType
{
   PROFESSION_NONE = 0,
   PROFESSION_SCIENTIFIC = 1,
   PROFESSION_FREELANCE = 2,
   PROFESSION_MILITARY = 4,
   PROFESSION_OTHER= 8
};

enum OfficerType
{
   OFFICER_NONE = 0,
   OFFICER_CAPTAIN = 1,
   OFFICER_SCIENCE = 2,
   OFFICER_NAVIGATION = 3,
   OFFICER_ENGINEER = 4,
   OFFICER_COMMUNICATION = 5,
   OFFICER_MEDICAL = 6,
   OFFICER_TACTICAL = 7
};

class Officer
{
public:
	Officer();
	Officer(OfficerType officerType);
	virtual ~Officer();

	Officer & operator =(const Officer &rhs);

	OfficerType GetOfficerType() const;
	void SetOfficerType(OfficerType type);
	void SetOfficerType(int type);
	std::string GetTitle();
	std::string GetTitle(OfficerType officerType);
	std::string GetPreferredProfession();

	void Reset();
	bool Serialize(Archive &ar);

    bool SkillUp(std::string skill, int amount = 1);
    bool SkillUp(Skill skill, int amount = 1);
	bool SkillCheck();
	bool CanSkillCheck();
	void FakeSkillCheck(); //this function is used to fake a skill check for the purpose of CanSkillCheck().

	bool isBeingHealed(){return isHealing;}
	void Recovering(bool recovering){isHealing = recovering;}

	std::string getFirstName();
	std::string getLastName();

	std::string		name;
	Attributes		attributes;

private:
	Stardate lastSkillCheck;
	bool isHealing;

	OfficerType		officerType;
};

//SHIP CLASS
#define STARTING_HULL_INTEGRITY 100

//added class 6
enum ClassType
{
	NotInstalledType,
	Class1Type,
	Class2Type,
	Class3Type,
	Class4Type,
	Class5Type,
	Class6Type
};

//NUM_REPAIR_PARTS is the number of repairable ship systems
//MAX_REPAIR_COUNT is the number of repair iteration the player can do before spending a repair mineral
const int NUM_REPAIR_PARTS = 5;
const int MAX_REPAIR_COUNT = 3;

//NOTE: the repair code rely on this starting at 0, having no hole, PART_NONE first, and NUM_REPAIR_PARTS+1 members.
enum ShipPart{
	PART_NONE     = 0,
	PART_LASERS   = 1,
	PART_MISSILES = 2,
	PART_HULL     = 3,
	PART_SHIELDS  = 4,
	PART_ENGINES  = 5
};

//repair minerals
const ID ITEM_COBALT             = 32;
const ID ITEM_MOLYBDENUM         = 36;
const ID ITEM_ALUMINUM           = 39;
const ID ITEM_TITANIUM           = 40;
const ID ITEM_SILICA             = 44;

//capacity of a Cargo Pod
const int POD_CAPACITY = 10;

class Ship
{
public:

	Ship();
	virtual ~Ship();
	Ship & operator =(const Ship &rhs);

	//accessors
	std::string getName()			const;
	int getCargoPodCount()			const;
	int getEngineClass()			const;
	int getShieldClass()			const;
	int getArmorClass()				const;
	float getHullIntegrity()		const;
	float getArmorIntegrity()		const;
	float getShieldIntegrity()		const;
	float getShieldCapacity()		const;
	float getEngineIntegrity()		const;
	int getMissileLauncherClass()   const;
	int getMissileLauncherDamage();
	int getMissileLauncherFiringRate();
	float getMissileLauncherIntegrity() const;
	float getLaserIntegrity() const;
	int getLaserClass() const;
	int getLaserDamage();
	int getLaserFiringRate();
	bool getHasTV()						const	{ return hasTV; }
	float getMaxArmorIntegrity();
	float getMaxShieldCapacity();
	float getMaxShieldCapacityAtFullIntegrity();

	void damageRandomSystemOrCrew(int odds = 33, int mindamage = 10, int maxdamage = 30);

	std::string getCargoPodCountString()			const;
	std::string getEngineClassString()				const;
	std::string getShieldClassString()				const;
	std::string getArmorClassString()				const;
	std::string getMissileLauncherClassString()		const;
	std::string getLaserClassString()				const;
	bool HaveEngines()								const;

	int getMaxEngineClass(){return maxEngineClass;}
	int getMaxArmorClass() {return maxArmorClass; }
	int getMaxShieldClass(){return maxShieldClass;}
	int getMaxLaserClass() {return maxLaserClass; }
	int getMaxMissileLauncherClass(){return maxMissileLauncherClass;}

	int getTotalSpace();
	int getOccupiedSpace();
	int getAvailableSpace();

	//mutators
	void setName(std::string initName);
	void setCargoPodCount(int initCargoPodCount);
	void cargoPodPlusPlus();
	void cargoPodMinusMinus();
	void setEngineClass(int initEngineClass);
	void setShieldClass(int initShieldClass);
	void setArmorClass(int initArmorClass);
	void setMissileLauncherClass(int initMissileLauncherClass);
	void setLaserClass(int initLaserClass);
	void setHullIntegrity(float initHullIntegrity);
	void augHullIntegrity(float amount);
	void setArmorIntegrity(float initArmorIntegrity);
	void augArmorIntegrity(float amount);
	void setShieldIntegrity(float initShieldIntegrity);
	void augShieldIntegrity(float amount);
	void setShieldCapacity(float initShieldCapacity);
	void augShieldCapacity(float amount);
	void setEngineIntegrity(float initEngineIntegrity);
	void augEngineIntegrity(float amount);
	void setMissileLauncherIntegrity(float initMissileLauncherIntegrity);
	void augMissileLauncherIntegrity(float amount);
	void setLaserIntegrity(float initLaserIntegrity);
	void augLaserIntegrity(float amount);

	void setMaxEngineClass(int engineClass);
	void setMaxArmorClass(int armorClass);
	void setMaxShieldClass(int shieldClass);
	void setMaxLaserClass(int laserClass);
	void setMaxMissileLauncherClass(int missileLauncherClass);

	void setHasTV(bool initHasTV)				{ hasTV = initHasTV; }

	//specials
	void Reset();
	bool Serialize(Archive &ar);

	//fuel consumption
	float getFuel();
	void setFuel(float percentage);
	void augFuel(float percentage);
    void injectEndurium();
   	void ConsumeFuel(int iterations=1);
    int getEnduriumOnBoard();

	//in-space repair
	void initializeRepair();
	int repairMinerals[NUM_REPAIR_PARTS];
	int repairCounters[NUM_REPAIR_PARTS];
	ShipPart partInRepair;

    void SendDistressSignal();

	//this function verifies that components are valid
	void RunDiagnostic();


private:

	std::string		name;
	int				cargoPodCount;
	int				engineClass;
	int				shieldClass;
	int				armorClass;
	int				missileLauncherClass;
	int				laserClass;
	float			hullIntegrity;
	float			armorIntegrity;
	float			shieldIntegrity;
	float			shieldCapacity;
	float			engineIntegrity;
	float			missileLauncherIntegrity;
	float			laserIntegrity;
	int				maxEngineClass;
	int				maxShieldClass;
	int				maxArmorClass;
	int				maxMissileLauncherClass;
	int				maxLaserClass;
	bool			hasTV;
	float			fuelPercentage; //1.0 = full, 0.0 = empty, 0.5 = half tank
	void capFuel();	//tops off the fuel tank... basically this function just makes sure that the fuel is within the proper limits
};

//GAMESTATE CLASS
#define STARTING_CREDITS 1000

class PlayerInfo {
	private:
		bool m_scanner,
			m_previous_scanner_state,
			m_bHasHyperspacePermit,
			m_bHasOverdueLoan;
		void set_prev_scanner_state(bool state){m_previous_scanner_state = state;}
		bool m_is_lost;
		Stardate m_date_lost;
	public:
		PlayerInfo() { Reset(); }
		~PlayerInfo() {};

      void Reset();
      bool Serialize(Archive& ar);
      PlayerInfo& operator=(const PlayerInfo& rhs);

		int				currentStar;
		int				currentPlanet;
		int				controlPanelMode;

		Point2D			posHyperspace;
		Point2D			posSystem;
		Point2D			posPlanet;
		Point2D			posStarport;
		Point2D			posCombat;
		double			currentSpeed;

		double get_galactic_x() { return posHyperspace.x; }
		double get_galactic_y() { return posHyperspace.y; }

		Point2D get_galactic_pos() { return posHyperspace; }

		void set_galactic_pos(Point2D pos) { posHyperspace = pos; }

		void set_galactic_pos(double x, double y) {
			posHyperspace.x = x;
			posHyperspace.y = y;
		}

		/*
		 * ENCOUNTER DATA STORED HERE
		 * This data is shared by space travel and encounter modules
		 */
		//GalacticRegion property is used to identify the area of the galaxy where the player is located.
		//It is set by the interstellar module and used by the auxiliary window.
		AlienRaces galacticRegion;
		std::string getAlienRaceName(AlienRaces race);
        std::string getAlienRaceName(int race);
		std::string getAlienRaceNamePlural(AlienRaces race);
		AlienRaces getGalacticRegion() { return galacticRegion; }
		void setGalacticRegion(AlienRaces race) { galacticRegion = race; }

		int fleetSize;
		int getAlienFleetSize() { return fleetSize; }
		void setAlienFleetSize(int value) { fleetSize = value; }

		/*
		 * END ENCOUNTER RELATED DATA
		 */

		double getCurrentSpeed() { return currentSpeed; }
		void setCurrentSpeed(double value) { currentSpeed = value; }

		bool has_flux_scanner(){return m_scanner;}
		void set_flux_scanner(bool status){set_prev_scanner_state(m_scanner); m_scanner = status;}
		bool prev_scanner_state(){return m_previous_scanner_state;}

		bool hasHyperspacePermit(){return m_bHasHyperspacePermit;}
		void set_HyperspacePermit(bool status){m_bHasHyperspacePermit = status;}
		bool hasOverdueLoan(){return m_bHasOverdueLoan;}
		void set_OverdueLoan(bool status){m_bHasOverdueLoan = status;}

		bool isLost(){return m_is_lost;}
		void isLost(bool is_lost){m_is_lost = is_lost;}

		//alive property used for encounters
		bool alive;
		bool getAlive() { return alive; }
		void setAlive(bool value) { alive = value; }
};

struct QuestScript
{
	std::string script;
	Quest *parentQuest;

	QuestScript()
	{
		script = "";
		parentQuest = NULL;
	}

	QuestScript(std::string script, Quest *parentQuest)
	{
		this->script = script;
		this->parentQuest = parentQuest;
	}
};


class GameState
{
public:

	GameState();
	virtual ~GameState();

	GameState & operator =(const GameState &rhs);

	void Reset();
	bool Serialize(Archive& ar);

	bool SaveGame(std::string fileName);
	static GameState * ReadGame(std::string fileName);
	static GameState * LoadGame(std::string fileName);
	static void DumpStats(GameState *);					//debug tool.

	void AutoSave();
	void AutoLoad();

	Officer *getOfficer(int officerType);
	Officer *getOfficer(std::string officerName);

	//return the officer who currently fill the given role
	Officer* getCurrentSci();
	Officer* getCurrentNav();
	Officer* getCurrentTac();
	Officer* getCurrentEng();
	Officer* getCurrentCom();
	Officer* getCurrentDoc();

	Officer* getCurrentOfficerByType(OfficerType officertype);

	//calculate effective skill level taking into account vitality and captain modifier
	int CalcEffectiveSkill(Skill skill);

	//do a roll against given skill, using CalcEffectiveSkill to get the skill value
	bool SkillCheck(Skill skill);

	bool HaveFullCrew() const;
	bool PreparedToLaunch() const;
	Ship getShip() const;
	void init_fluxSeed()			{ srand(time(NULL)); fluxSeed = rand(); }

	std::vector<QuestScript*> planetsurfaceEvents;
	Quest *RunningScriptsParentQuest;


	bool			isCaptainSelected()		const;
	ProfessionType	getProfession()			const;
	int				getCredits()			const;
	int				get_fluxSeed()			const	{return fluxSeed;}

	//mutators
	//void setStardate(const Stardate &initStardate);
	void setCaptainSelected(bool initCaptainSelected);
	void setProfession(const ProfessionType &initProfession);
	void setProfession(std::string prof);
	void setCredits(int initCredits);
	void augCredits(int amount);
	void setShip(const Ship &initShip);
	void set_fluxSeed(int seed)									{fluxSeed = seed;}

	OfficerType getCurrentSelectedOfficer() { return m_currentSelectedOfficer; }
	void setCurrentSelectedOfficer(OfficerType value) { m_currentSelectedOfficer = value; }


	int						alienAttitudes[NUM_ALIEN_RACES]; //use enum AlienRaces for index
	long					alienAttitudeUpdate;
	std::string				playerPosture;				//for use in Encounters

	double m_baseGameTimeSecs;			//base starting value for timer
	double getBaseGameTimeSecs() { return m_baseGameTimeSecs; }
	void setBaseGameTimeSecs(double value) { m_baseGameTimeSecs = value; }

	double m_gameTimeSecs;				//# seconds since the start of the game
	double getGameTimeSecs() const { return m_gameTimeSecs; }
	void setGameTimeSecs(double value) { m_gameTimeSecs = value; }

	Stardate				stardate;					//the current Stardate

	bool					m_captainSelected;			//is a captain selected for play?
	ProfessionType			m_profession;				//captain profession
	int						m_credits;					//credits
	Items					&m_items;					//player inventory
	PlayerInfo				*player;					//Holds misc player data
	Ship					m_ship;						//ship data
	int						fluxSeed;					//The seed for the randomizing of the fluxes
	OfficerType				m_currentSelectedOfficer;	//currently selected officer in Control Panel
	std::vector<Officer*>	m_unemployedOfficers;		//current unemployeed officers;

	Officer *officerCap;
	Officer *officerSci;
	Officer *officerNav;
	Officer *officerTac;
	Officer *officerEng;
	Officer *officerCom;
	Officer *officerDoc;


	//navigation status
	bool navigateStatus;
	bool getNavigating() { return navigateStatus; }
	void setNavigating(bool value) { navigateStatus = value; }

	//tactical shield up/down status
	bool shieldStatus;
	bool getShieldStatus() { return shieldStatus; }
	void setShieldStatus(bool value) { shieldStatus = value; }

	//tactical weapon arm status
	bool weaponStatus;
	bool getWeaponStatus() { return weaponStatus; }
	void setWeaponStatus(bool value) { weaponStatus = value; }

	//the plot stage represents the four stages of the game: INITIAL, VIRUS, WAR, ANCIENTS
	//as defined in the alien script files
	int plotStage;
	int getPlotStage() { return plotStage; }
	void setPlotStage(int value) { ASSERT(plotStage>=1 && plotStage<=4); plotStage = value; }
	bool dirty;				//Does the game state need saving (for Captain's Lounge code)?

	ProfessionType getProfession() { return m_profession; }
	std::string getProfessionString();

	//Accessors & mutator imported from Encounter module to standardize access:
	AlienRaces getCurrentAlien();
	std::string getCurrentAlienName();
	int getAlienAttitude();
	void setAlienAttitude(int value);

	//the currently active module
	//Module names are found in ModeMgr.h
	std::string currentModule;
	std::string getCurrentModule() { return currentModule; }
	std::string getSavedModule() { return currentModeWhenGameSaved; }
	void setCurrentModule(std::string value) { currentModule = value; }

	//the currently active quest ID
	int getActiveQuest() { return activeQuest; }
	int getStoredValue() { return storedValue; }
	void setStoredValue(int v) { storedValue= v; }
	void setActiveQuest(int v) { if (v != activeQuest) {activeQuest= v; storedValue= -1; questCompleted= false;} }
	bool getQuestCompleted() { return questCompleted; }
	void setQuestCompleted(bool value) { questCompleted = value; }
	bool firstTimeVisitor;


private:

	int activeQuest;
	int storedValue;			//stored value of quest requirement is a game state variable, just like others.
	bool questCompleted;

	static std::string currentSaveGameFile;
	std::string currentModeWhenGameSaved;

	//The following are not used anywhere anymore. we preserve them only for savegame compatibility
	int TotalCargoStacks;
	int defaultShipCargoSize;
};

#endif
