/*
	STARFLIGHT - THE LOST COLONY
	DataMgr.h - Provides access to game data and resources; for Get methods which have corresponding
	Free methods, the caller is responsible for calling the Free method to release loaded resources.
   If there is no Free method provided, then the caller IS NOT responsible for releasing memory as
   the memory is owned by the providing class.
	Author: Dave "coder1024" Calkins
	Date: 01/22/2007
*/

#ifndef DATAMGR_H
#define DATAMGR_H
//#pragma once

#include <string>
#include <vector>
#include <map>
#include <utility>
#include <alfont.h>
#include <list>
#include "Flux.h"
#include "Script.h"
#include "GameState.h"

#define MAX_FLUX 2000
typedef std::list<Flux*>::iterator flux_iter;

class Officer;
class DataMgr;
struct Point;
class Archive;

// type used for object IDs
typedef int ID;

// type used for coordinate values (x and y for stars, for example)
typedef int CoordValue;

// type used for temperature
typedef unsigned long Kelvins;

// item types
typedef enum
{
   IT_INVALID = 0,
   IT_ARTIFACT = 1,
   IT_RUIN = 2,
   IT_MINERAL = 4,
   IT_LIFEFORM = 8,
   IT_TRADEITEM = 16
} ItemType;

// item age
typedef enum
{
   IA_INVALID = 0,
   IA_STONE,
   IA_METAL,
   IA_INDUSTRIAL,
   IA_SPACEFARING
} ItemAge;

// an item
class Item
{
public:

   Item();
   Item(const Item& rhs);
   virtual ~Item();
   Item& operator=(const Item& rhs);

   void Reset();

   bool IsArtifact() {return itemType == IT_ARTIFACT;};
   bool IsMineral()  {return itemType == IT_MINERAL;};
   bool IsLifeForm() {return itemType == IT_LIFEFORM;};

   ID id;                   // the ID of this item
   ItemType itemType;       // the type of item
   std::string name;        // the name
   double value;            // value
   double size;             // size (m^3)
   double speed;            // speed
   double danger;           // danger
   double damage;           // damage
   ItemAge itemAge;         // age
   bool shipRepairMetal;    // is this a ship repair metal?
   bool blackMarketItem;    // is this a blackmarket item?
   std::string portrait;    //This refers to the image file

   //for Artifact items these properties are used:
   int planetid;
   int x;
   int y;

   //additional properties for Ruins:
   std::string description;

   // helper methods for working with the enumerated types
   static ItemType ItemTypeFromString(std::string s);
   static std::string ItemTypeToString(ItemType itemType);
   static ItemAge ItemAgeFromString(std::string s);
   static std::string ItemAgeToString(ItemAge itemAge);
};

// used to represent a collection of items; the collection is comprised of
// stacks of items; for example, 100 cans of root beer, 3 slim jims, etc; you can request
// the # of stacks, and then iterate over all the stacks; each stack returns
// to you the item and the quantity in that stack
class Items
{
public:
   Items();
   Items(const Items& rhs);
   virtual ~Items();
   Items& operator=(const Items& rhs);

   void Reset();
   bool Serialize(Archive& ar);

   /**
    * initializes this object to contain a random collection of items.
    * @param maxNumStacks # of stacks will not exceed this value
    * @param maxNumItemsPerStack # of items in any stack will not exceed this value
    * @param typeFilter if provided, only items of the specified type mask will be generated
    */
   void RandomPopulate(int maxNumStacks, int maxNumItemsPerStack, ItemType typeFilter = IT_INVALID);

   /**
    * returns the number of stacks, each stack contains a set of a single item type
    */
   int GetNumStacks();

   /**
    * returns a single stack of items - the item info and the number of that item in the stack
    */
   void GetStack(int idx, Item& item, int& numItemsInStack);

   /**
    * add the specified quantity of the item ID to this object; the item(s) will be
    * added to the stack of that item type if already present.
    */
   void AddItems(ID id, int numItemsToAdd);

   /**
	* this function should be called before any item is added to the inventory!
	* returns true if it finds space for the list of items, and false if it doesn't.
	* the ellipse takes in the item ids of each item to be added
    */
	bool CheckForSpace(int spaceLimit, ... );
	bool CheckForSpace(int spaceLimit, int totalSentIDs, int itemIDs[] );



   /**
    * remove the specified quantity of the item ID from this object; the stack of this
    * item type will be decremented by the specified amount; it will not go below zero.
    */
   void RemoveItems(ID id, int numItemsToRemove);

   /**
    * sets the # of the specified item to the value provided, overwriting the existing
    * value if the item is already present or adding it if not.
    */
   void SetItemCount(ID id, int numItems);

	/**
    * scan the vector for the item with the given id value and set the item placeholder to the item matching that id
    */
   void Get_Item_By_ID(int id, Item& item, int &num_in_stack);

   void Get_Item_By_Name(std::string name, Item& item, int &num_in_stack);


private:
   std::vector<std::pair<ID,int> > stacks; // holds the stacks (each stack is a set of one item type)
};

// spectral classes
typedef enum
{
   SC_INVALID = 0,
   SC_M,
   SC_K,
   SC_G,
   SC_F,
   SC_A,
   SC_B,
   SC_O
} SpectralClass;

class Planet;

// a star
class Star
{
public:

   Star();
   Star(const Star& rhs);
   virtual ~Star();
   Star& operator=(const Star& rhs);

   // the ID of this star
   ID id;

   // the name of the star
   std::string name;

   // the position on the starmap
   CoordValue x,y;

   // spectral class of the star
   SpectralClass spectralClass;

   // the color of the star
   std::string color;

   // star temperature
   Kelvins temperature;

   // mass
   unsigned long mass;

   // radius
   unsigned long radius;

   // luminosity
   unsigned long luminosity;

   // used to access the planets in this star; this class owns the
   // memory and so it is not necessary to delete the returned pointer
   int GetNumPlanets();
   Planet * GetPlanet(int idx); // by index [0...N)
   Planet * GetPlanetByID(ID id); // by ID

   // helper methods for working with the enumerated types
   static SpectralClass SpectralClassFromString(std::string s);
   static std::string SpectralClassToString(SpectralClass spectralClass);

private:

   std::vector<Planet*> planets;
   std::map<ID,Planet*> planetsByID;

   friend class DataMgr;
};

// planet sizes
typedef enum
{
   PS_INVALID = 0,
   PS_SMALL,
   PS_MEDIUM,
   PS_LARGE,
   PS_HUGE
} PlanetSize;

// planet types
typedef enum
{
   PT_INVALID = 0,
   PT_ASTEROID,
   PT_ROCKY,
   PT_FROZEN,
   PT_OCEANIC,
   PT_MOLTEN,
   PT_GASGIANT,
   PT_ACIDIC
} PlanetType;

// planet temperatures
typedef enum
{
   PTMP_INVALID = 0,
   PTMP_SUBARCTIC,
   PTMP_ARCTIC,
   PTMP_TEMPERATE,
   PTMP_TROPICAL,
   PTMP_SEARING,
   PTMP_INFERNO
} PlanetTemperature;

// planet gravity
typedef enum
{
   PG_INVALID = 0,
   PG_NEGLIGIBLE,
   PG_VERYLOW,
   PG_LOW,
   PG_OPTIMAL,
   PG_VERYHEAVY,
   PG_CRUSHING
} PlanetGravity;

// planet atmosphere
typedef enum
{
   PA_INVALID = 0,
   PA_NONE,
   PA_TRACEGASES,
   PA_BREATHABLE,
   PA_ACIDIC,
   PA_TOXIC,
   PA_FIRESTORM
} PlanetAtmosphere;

// planet weather
typedef enum
{
   PW_INVALID = 0,
   PW_NONE,
   PW_CALM,
   PW_MODERATE,
   PW_VIOLENT,
   PW_VERYVIOLENT
} PlanetWeather;

// a planet within a star
class Planet
{
public:

   Planet();
   Planet(const Planet& rhs);
   virtual ~Planet();
   Planet& operator=(const Planet& rhs);

   // the ID of this planet
   ID id;

   // the ID of the host star containing this planet
   ID hostStarID;

   // planet name
   std::string name;

   // planet size
   PlanetSize size;

   // planet type
   PlanetType type;

   // planet color
   std::string color;

   // planet temperature
   PlanetTemperature temperature;

   // planet gravity
   PlanetGravity gravity;

   // planet atmosphere
   PlanetAtmosphere atmosphere;

   // planet weather
   PlanetWeather weather;

   //landable property
   bool landable;

   // helper methods for working with the enumerated types
   static PlanetSize PlanetSizeFromString(std::string size);
   static std::string PlanetSizeToString(PlanetSize size);

   static PlanetType PlanetTypeFromString(std::string type);
   static std::string PlanetTypeToString(PlanetType type);

   static PlanetTemperature PlanetTemperatureFromString(std::string temperature);
   static std::string PlanetTemperatureToString(PlanetTemperature temperature);

   static PlanetGravity PlanetGravityFromString(std::string gravity);
   static std::string PlanetGravityToString(PlanetGravity gravity);

   static PlanetAtmosphere PlanetAtmosphereFromString(std::string atmosphere);
   static std::string PlanetAtmosphereToString(PlanetAtmosphere atmosphere);

   static PlanetWeather PlanetWeatherFromString(std::string weather);
   static std::string PlanetWeatherToString(PlanetWeather weather);
};

class DataMgr
{
public:

   // don't create new instances of this class, use the instance provided in the Module class
   DataMgr();
   virtual ~DataMgr();

   // only called once at game initialization to load in all the data and prepare it for access
   // shouldn't need to call this.
   bool Initialize();

   // used to access available items; memory is owned by this class; you should not delete
   // any returned objects
   int GetNumItems();
   Item* GetItem(int idx);			// by index [0..N)
   Item* GetItemByID(ID id);		// by ID
   Item* GetItem(std::string name); // by name

   // used to access the available stars; memory is owned by this class; you should not delete
   // any returned objects
   int GetNumStars();
   Star* GetStar(int idx); // by index [0...N)
   Star* GetStarByID(ID id); // by ID
   Star* GetStarByLocation(CoordValue x, CoordValue y); // by location

   //this version does not require a star parent class
   std::vector<Planet*> allPlanets;
   std::map<ID,Planet*> allPlanetsByID;
   Planet *GetPlanetByID(ID id);

   int GetNumHumanNames();
   std::string GetFullName(int id);
   std::string GetFirstName(int id);
   std::string GetLastName(int id);
   std::string GetRandWholeName();
   std::string GetRandMixedName();

  //this should have only be needed during testing
   //Officer* GetRandOfficer(int type);
   std::list<Flux*> flux;


private:
   bool m_initialized;
   bool LoadItems();
   bool LoadGalaxy();
   bool LoadHumanNames();

   std::vector<Item*> items;
   std::map<ID,Item*> itemsByID;
   std::vector<Star*> stars;
   std::map<ID,Star*> starsByID;
   std::map<std::pair<CoordValue,CoordValue>,Star*> starsByLocation;
   std::vector<std::pair<std::string*,std::string*>*> humanNames;

};


#endif
