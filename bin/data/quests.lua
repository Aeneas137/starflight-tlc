--[[
	QUEST SYSTEM SCRIPT
	The quest system is sequential with a simple tracking number stored in the savegame file, representing the current quest (active_quest).
	This script file is state based, responding to quest events based on active_quest, therefore no other data needs to be stored.


	Quests table properties:
		1 = mission name
		2 = short description (for ship)
		3 = long description (for starport)
		4 = short debriefing
		5-7 = requirement
		8-10 = reward

	requirement = { code, type, amount }
	Requirement codes:
		2 = item
		10 = explore star system  - for example { 10, 20, 0 },
		12 = orbit planet
		14 = scan planet
		16 = land on planet
		18 = enter personnel module
		20 = enter trade depot
		22 = enter docking bay
		24 = enter bank

	reward = { code, type, amount }
	Reward codes:
		0 = YOU SAVED THE GALAXY!!
		1 = money  - for example { 1, 0, 1000 }
		2 = item  - for example { 2, 29, 1 }
--]]


function round(num, places)
  local mult = 10^(places or 0)
  return math.floor(num * mult + 0.5) / mult
end

function gen_random(max)
    local temp = math.mod((42 * math.random() + 29573), 139968)
	local ret = math.mod( ((100 * temp)/139968) * 1000000, max)
    return round(ret + 0.5)
end

function init_training_missions()
	--the training missions come before the professions to give player a chance to get familiar with the game

-- quest 1
	addQuest( "Welcome to the Starport!",
		"Visit the Docking Bay",
		"Welcome to the Starport, Captain.  Although the Starport is a large facility and it's resources are at your disposal, it can be a bit overwhelming to a new captain. So, to help you get familiar with the Starport's resources, we're going to take a quick tour of the facility and help you to configure your ship to ready it for the maiden voyage.  Let's begin at the Docking Bay, where your ship is berthed. Go take a look, then come back here for further instructions.",
		"You follow orders well, captain. Now, let's continue.",
		22, 0, 0,
		1, 0, 500 )

-- quest 2
	addQuest ( "Personalized Banking",
		"Visit the Bank",
		"Now let's introduce you to the bank. This is where you can quickly see your balance of Monetary Units (MUs). The banker can also give you a loan if you are ever strapped for credits. A word of caution, though: if you fail to repay a loan, your hyperspace license could be suspended.  Go visit the Bank, then return here.",
		"Great. Continuing onward...",
		24, 0, 0,
		1, 0, 800 )

-- quest 3
	addQuest( "Capitalism Du Jour",
		"Visit the Trade Depot",
		"Next stop on our tour of the Starport is the Trade Depot. This is where you will sell the ores and lifeforms gathered on planets or acquired from, ahem, alien 'interaction', so to speak.  Most importantly, this is where you will go to buy more fuel for your ship.  Go to the Trade Depot then return here.",
		"Great! Now, let's continue with your tour.",
		20, 0, 0,
		1, 0, 500 )

-- quest 4
	addQuest( "Human Resources",
		"Visit the Personnel department",
		"You're almost ready to take your ship out for your first starflight. Before you can exit the Starport in your new ship, you will need to familiarize yourself with the Starport's crew support facility. Go visit the Personnel department. There you will need to assign your ship's crew.  Hire a crew member for each station that your ship requires, and then highlight each crew member and assign them to a station.",
		"Did you assign a crew member to each ship station? If not, you'll need to do that before you can leave the Docking Bay. Now let's continue your tour.",
		18, 0, 0,
		1, 0, 500 )

-- quest 5
	addQuest( "Engine Test",
		"Orbit the homeworld of Myrrdan, then return to the Starport",
		"Now that you're familiar with the Starport and what is required of a captain, I think it's time for a flight test. As the captain of one of the earliest ships constructed at the Myrrdan Starport Shipyard, we need you to give her a good shakedown cruise prior to her maiden voyage. You should now have enough resources now to purchase a set of engines, a cargo pod, and a unit of Endurium.  Your first mission is a simple engine fire-up test: Take her out of the Starport, run a few orbits around Myrrdan, then return. You can depart from the Starport via the Docking Bay. After completing the orbital maneuver, your navigation officer will be able to dock with the starport again.",
		"Great, you survived! I mean... er... We have the utmost faith in our ships, of course. Now, let's proceed.",
		12, 8, 0, --orbit Myrrdan
		1, 0, 1000 )

-- quest 6
	addQuest( "Sensor Test",
		"Go to the planet Islay and test the ship's planetary scanner",
		"It's time to log some more star hours!  Are you ready for another flight? Another vital ship component is the sensor system. It is your eyes and ears in space.  We need to test the sensors to ensure they are functioning within normal parameters.  Go to the nearby planet Islay and establish orbit, then perform a full planetary scan.  Your science officer will be able to perform this function.  Note that the most fuel-efficient 'thrust' consists of intermittently holding the thrust key, not holding it continuously. Return here when complete.",
		"The ship's sensors performed above expectations.",
		14, 2, 0,
		1, 0, 1000 )

-- quest 7
	addQuest( "Critical Mineral Shortage",
		"Bring back at least five cubic meters of Antimony ore from Senlabor.",
		"A critical Antimony shortage on Myrrdan has delayed the launch of many of your co-explorers. A number of durable ship components require that metal.  Instead of playing exorbitant prices planet side, we have divided up the chore of obtaining this mineral between all of the operational ships in the area. Your task is to mine 5 cubic meters of Antimony ore from Senlabor.  Mining is one of the most effective ways of raising capital for ship upgrades and fuel costs, so feel free to pick up any additional ore to keep your fuel tanks full, but do not delay in bringing back this essential shipment.",
		"Good work. Now you can sell any collected ore at the Trade Depot.",
		2, 42, 5,
		1, 0, 2000 )

-- quest 8
	addQuest( "Zoological Expedition",
		"Capture an Humanoid Hopper lifeform from the planet Ildathach and return it to Starport",
		"You've demonstrated your skill at mining for ores with the terrain vehicle, but ores are relatively easy to find and pick up.  A local collector has offered to fund a sizable amount of your ship's construction in exchange for an exotic life form that our probes have recently picked up.  Your Terrain Vehicle is equipped with a stun weapon that is capable of taking down even the largest and most violent of lifeforms, but you have to be fast and furious in the Terrain Vehicle to keep from becoming lunch for some of the more dangerous varieties.  Your mission is to capture a Humanoid Hopper and return it to the Starport.  This lifeform can be found on the planet Ildathach.",
		"Great! The Capital Petting Zoo appreciates your donation of this strange creature.",
		2, 70, 1, --humanoid hopper
		1, 0, 1000 )


-- quest 9: Return the Hypercube from Ciuin in the Faidh system, 96N X 31E
	addQuest( "Artifacts",
		"Find an artifact located at the northern edge of a deep valley on Ciuin in the Faidh system",
		"The age-old myths about our origins have become our heroic stories of legend, and there is no greater legend than that of Captain Meriwether who guided our ancestors aboard the Noah 3 colony ship, which was launched from our native homeworld of Earth over a millennia ago. During the urgent struggle to find a habitable world in this system, a single technologically advanced probe was sent and retrieved from each planet to obtain more detailed readings on possible life sustaining environments beyond what the ship sensors were able to discern at first glance.  The Hypercube, as we now call it, was lost in space just before the fortuitous last-minute discovery of Myrrdan.  A signal from the device has been triangulated from a nearby system, on the northern edge of a deep valley on Ciuin in the Faidh system, near the 'center' of the Northern Hemisphere.  Pick it up and return this historical treasure to Myrrdan as soon as possible.  (Note: to skip the training missions in future games, simply collect the hypercube at any time)",
		"This is a wonderful find! Absolutely marvelous! Good work, captain. Your training is now complete.",
		2, 2, 1, --hypercube artifact
		1, 0, 10000 )

-- quest 10: Return the Hypercube from Ciuin in the Faidh system, 96N X 31E
	addQuest( "Artifacts",
		"Find an artifact located at the northern edge of a deep valley on Ciuin in the Faidh system",
		"The age-old myths about our origins have become our heroic stories of legend, and there is no greater legend than that of Captain Meriwether who guided our ancestors aboard the Noah 3 colony ship, which was launched from our native homeworld of Earth over a millennia ago. During the urgent struggle to find a habitable world in this system, a single technologically advanced probe was sent and retrieved from each planet to obtain more detailed readings on possible life sustaining environments beyond what the ship sensors were able to discern at first glance.  The Hypercube, as we now call it, was lost in space just before the fortuitous last-minute discovery of Myrrdan.  A signal from the device has been triangulated from a nearby system, on the northern edge of a deep valley on Ciuin in the Faidh system, near the 'center' of the Northern Hemisphere.  Pick it up and return this historical treasure to Myrrdan as soon as possible.  (Note: to skip the training missions in future games, simply collect the hypercube at any time)",
		"This is a wonderful find! Absolutely marvelous! Good work, captain. Your training is now complete.",
		2, 2, 1, --hypercube artifact
		1, 0, 10000 )

--[[
Missions #11-25:  Unused
]]--
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )
	addQuest( "Unused Training Mission","",	"",	"",	0, 0, 0, 0, 0, 0 )

	 -- This is a repeat of the last training mission. Data in this quest will show up when the player successfully completes the last training mission so the text must be identical.

	addQuest( "Artifacts",
		"Find an artifact located at the northern edge of a deep valley on Ciuin in the Faidh system",
		"The age-old myths about our origins have become our heroic stories of legend, and there is no greater legend than that of Captain Meriwether who guided our ancestors aboard the Noah 3 colony ship, which was launched from our native homeworld of Earth over a millennia ago. During the urgent struggle to find a habitable world in this system, a single technologically advanced probe was sent and retrieved from each planet to obtain more detailed readings on possible life sustaining environments beyond what the ship sensors were able to discern at first glance.  The Hypercube, as we now call it, was lost in space just before the fortuitous last-minute discovery of Myrrdan.  A signal from the device has been triangulated from a nearby system, on the northern edge of a deep valley on Ciuin in the Faidh system, near the 'center' of the Northern Hemisphere.  Pick it up and return this historical treasure to Myrrdan as soon as possible.  (Note: to skip the training missions in future games, simply collect the hypercube at any time)",
		"This is a wonderful find! Absolutely marvelous! Good work, captain. Your training is now complete.",
		2, 2, 1, --hypercube artifact
		1, 0, 10000 )


end

function init_science_missions()


--[[
Science Mission #26:  Scan Scanned planet 241: Fedlech and return, receive 10 cubic meters of endurium
]]--
	addQuest( "Anomalous Readings",
		"Perform a sensor scan of the planet Fedlech, the third planet in the Etarlam system. (172,118)",
		"For your next mission, we need you to do a sensor scan of the planet Fedlech, the third planet in the Etarlam system. (172,118)  Our data from the preliminary survey ship to the system located some unusual anomalies on the planet's surface.  Unfortunately only a passing system sweep was performed at that time and we require additional data.  Be sure that your propulsion systems has been upgraded sufficiently for extended hyperspace travel and that you have enough endurium crystals on board to convert into fuel for the trip.",
		"Analysis of your data will clear up some mysteries!",
		14, 241, 0,
		2, 54, 10 )


--[[
Science Mission #27:  Scan Airgdech in the Beothach system, receive 10 cubic meters of endurium
]]--
	addQuest( "Colonizable Worlds",
		"Scan planets within our neighboring star systems until you locate one that is colonizable.",
		"Although outposts can be build at varying cost and difficulty anywhere, the real treasure is a planet capable of supporting carbon-based life with little or no terraforming.  Capt. Meriwether under tremendous pressure was extremely fortunate to locate Myrrdan with a badly damaged ship.  His survey of the surrounding star systems was not complete, and now we would like you to finish his task.  Scan all of the planets of the three nearby systems and see if you can locate any colonizable worlds. Colonizable worlds must have a tropical or temperate climate, a breathable atmosphere, and low to optimum gravity.",
		"Very good work!  Myrrdan now has a solution to overpopulation, if someday we were actually in danger of overpopulation.",
		14, 20, 0,
		2, 54, 10 )

--[[
Science Mission #28:  Multiple requirements are not implemented, so the game checks to see if the player landed on 111: Caintigern I.  Upon returning, the player receives 25,000 monetary units.
]]--
	addQuest( "Soil Samples",
		"Land on the following planets: Fiochra II (201,192), Esar Brec II (39,134), Caintigern I (106,18), Cailte I (61,22)",
		"A number of unusual planets that defy predictions have recently been discovered.  We request that you land and take soil samples of the following planets:  Fiochra II (201,192), Esar Brec II (39,134), Caintigern I (106,18), and Cailte I (61,22). Our grant funding has recently been approved, so upon completion we will be able to reward you with a decent number of monetary units.",
		"I hope it didn't take you too long!",
		16, 111, 0,
		1, 0, 20000 )

--[[
Science Mission #29: Pickup the data core on planet Tuatha, Nemed (125,96) at coordinates 47S X 45E. When this is taken to the Bar-zhon, a dialogue sequence is triggered, the player engine class is upgraded if less than max, and the quest is completed.
]]--
	addQuest( "First Contact",
		"Pickup the data cube on planet Tuatha, Nemed (125,96) at coordinates 40N X 63E and then establish friendly contact with a Bar-zhon vessel and return their data cube.",
		"Alien pirates in our region of space have destroyed our scouts and seriously hampered hyperspace travel for many hundreds of years.  The new hyperdrive engines invented by Mega Dynamics are more than 20 times more efficient than any vessel our civilization has produced since the Noah 3 was lost.  This breakthrough was made possible with a data cube salvaged from another starship vessel affiliated with a race known as the 'Bar-zhon'.  Your mission is to establish friendly first contact with this race, and return the data cube from their vessel.  The data was recently unearthed at the archaeological dig on planet Tuatha, Nemed (125, 96) at coordinates 40N X 63E.  All that is known for certain about the Bar-zhon is that their territory is coreward from here.",
		"Player should not see this.  Bar-zhon should terminate the mission",
		0, 0, 0 ,
		0, 0, 0 )

--[[
Science Mission #30: When 5 m³ of Thorium is returned to starport, the player is given 10,000 monetary units.
]]--
	addQuest( "Radioactive Ore",
		"Locate and retrieve 5 cubic meters of Thorium from any planet and return it to Starport.",
		"Nitron Inc. is searching for a sizable volume of Thorium for a functional reconstruction of an Empire sensor system.  Apparently when fossil fuels and uranium were nearly exhausted on our original homeworld, it was discovered that there was more energy available in Thorium than from any other single source on that planet surface.  Myrrdan is a very inert planet and it is far more economically feasible to locate an extra-planetary source of this radioactive material than it would be to re-create it en-bulk.  A world similar in type to our original home world may possibly hold this mineral.   You are hereby warned not to obtain this mineral through salvage!",
		"Good mining!",
		2, 49, 5 ,
		1, 0, 10000 )

--[[
Science Mission #31: Multiple step mission:

1. Thrynn: The orb is located on the north pole of the planet 'Lazerarp'

2. Bar-zhon: Refers the player to the Nyssian and gives the history of the device

3. Nyssian: Lazerarp is known to you as Alastir, the first planet of the system Tat. (132,125)

Returning the orb to starport provides the player 15,000 monetary units

]]--
	addQuest( "Hunt for the Orb",
		"Contact the Thrynn and follow any leads that take you to the location of the Whining Orb.",
		"The Thrynn relayed to us at discovery of possibly useful information from a pirate stash referring to a valuable piece of technology known as a Whining Orb.  Their hyperwave broadcast did not mention any specifics, so we request that you travel outward and slightly upspin to Thrynn space to ask them directly about it.",
		"Umm, this is a piece of junk, but good work.",
		2, 16, 1 , -- Whining Orb
		1, 0, 15000 )

--[[
Science Mission #32: Scanning the planet 429: Cermait 6 - 247, 218 reveals nothing but completes the request. The player is awarded 8000 monetary units.
]]--
	addQuest( "The Mysterious Planet",
		"Scan the planet of Cermait 6 (247, 218) and if you are able to locate the source of such emissions, land and investigate.",
		"We have received information about a planet emitting very strong but erratic gamma radiation bursts in a synchronous pattern.  A Myrrdan military vessel picked up the signal but did not bother to investigate.  Your mission is to scan the planet of Cermait 6 (247, 218) and if you are able to locate the source of such emissions, land and investigate.",
		"No luck landing?  We'll dispatch military muscle to uhh .. test that force field.",
		14, 429, 0 ,
		1, 0, 8000 )

--[[
Science Mission #33: Returning artifact #24, artistic baubles provide the player with 12,000 monetary units.
]]--
	addQuest( "Acidic Treasures",
		"Locate anything of interest on an acidic planet somewhere in the bow constellation (65,110) at planetary coordinates 90N X 70W",
		"The Nyssian have given us clues to the location of a possible archaeological treasure trove.  All they have for us is planetary coordinates 90N X 70W on an acidic planet somewhere in the bow constellation (65,110). Fortunately for us their technology is organically based and will not survive a landing on an acidic planet.",
		"Nice work.",
		2, 24, 1 ,
		1, 0, 12000 )

--[[
Science Mission #34: Again multiple objectives are not possible with the current engine, so the quest is completed when the player scans planet Forgoll II (ID# 635)  Reward is 20,000 monetary units.
]]--
	addQuest( "Young Stars",
		"Perform orbital sweeps of all of the planets of all of the class O stars in this region of space.",
		"A sizable grant has been given to the science guild to investigate the development of stellar nurseries in this area of space.  Orbital sweeps of all of the planets of all of the young class O stars should provide sufficient information.",
		"Uhh, see any nebula out there?",
		14, 455, 0 ,
		1, 0, 20000 )

--[[
Science Mission #35: Collection of hints from multiple races:

Coalition: acidic
Bar-zhon: acidic
Spemin: Far away from the star,
Elowan: F or G class

The quest is completed when the player scans planet Fogwyrd (#350) in the Delbaeth system(107,183). Reward is 75,000 monetary units.
]]--
	addQuest( "Planet Hunt",
		"Talk to the other races to find clues locating an exotic small planet with a massive gravity field.  Perform a sensor scan on the planet and return with the data.",
		"The Nyssian has given us information recovered from a derelict of an extinct race that refers to a planet somewhere in this region of space with a core of exotic particles.  Scanning this planet may finally help scientists prove the existence or nonexistence of the elusive Higgs Boson particle.  All we know from the Nyssian is that this small planet possesses a very strong gravity field.  The Nyssian also provided us considerable data from the derelict's computer system describing the planet and the system that it resides, but the data is fragmentary and barely decipherable.  It is possible that other races may have better luck deciphering the data and may be able to help us locate it.",
		"Wow.  This data is going to keep us busy for a long time!",
		14, 350, 0 ,
		1, 0, 75000 )

end

function init_military_missions()

--[[
Military Mission #26: Also extremely simple, reward is 35 cubic meters of endurium.  COMPLETION_CHECK: Entered system 34: Breothigernd
]]--

	addQuest( "Shakedown Cruise",
		"Go to and enter the Breothigernd system (118, 47) and the return to starport.",
		"Now if you feel that your ship is up to specs, take her out on a shakedown cruise to familiarize your crew with her full operations.  Fly directly to the Breothigernd system (118, 47) and return again.  Be sure that your propulsion systems has been upgraded sufficiently for extended hyperspace travel and that you have enough endurium crystals on board to convert into fuel for the trip.",
		"Good job.  Ready for some real work?",
		 10, 34, 0 ,
		 2, 54, 20 )

--[[
Military Mission #27:  A Hunt for the pirate base:

Lough Leane 2389 - 122N X 115W

1. We move to place on other side of gas giants at 115N X 46E... Harrison promise us scanner tech.  He  smart, but we watch him ... He show us evidence at 55S X 35W on the planet of fire.  He should discover its exact location soon ... must remember to add 20 to numbers...

... subtract 20 from both coordinates 115N X 46E, acid planet on other side of gas giants, Oilell - 95N X 26E

2. Shantytown and rod device, "This facility has been heavily damaged by orbital weapons fire."

]]--
	addQuest( "The Pirate Hunt",
		"Travel to Lough Leane and investigate the base at 122N X 115W",
		"Your next exercise will be a hunt for real foes. A group of pirates attempted to establish a base here in Sidhichean but fortunately were eliminated by a military patrol.  References salvaged from one of their wrecks referred to the 'Rock' at 122N X 115W.  Investigate and retrieve whatever you can from what we assume is an asteroid base and bring it back to starport.  It is unlikely that any pirate outposts would remain staffed and armed, especially after their supporting ships were destroyed, but stay cautious either way.",
		"Doesn't look like any of them survived.  Interesting curio artifact. It appears to be made out of an ornamental mineral known as rodium.",
		2, 197, 1, -- Rod Device
		1, 0, 2000 )


--[[
Military Mission #28: Destroy Pirates until at least one sample of pirate small arms is obtained. Reward is 5000 credits.
]]--

	addQuest( "Pirate Cleanup",
		"Destroy pirate vessels until you successfully retrieve a sample of pirate small arms.",
		"Preliminary excursions into hyperspace have been severely hampered by what appears to be a large number of haphazardly organized alien pirates.  Their technological edge has recently been minimized by a number of important breakthroughs in military weaponry and propulsion systems.  We feel that it is time to make our presence known and establish a beachhead in this lawless domain to protect the safety of Myrrdan's entrepreneurial and scientific communities.  Your mission is to spool up your hyperdrive engine and either seek out or wait for a patrol of pirate vessels.  Data from previous encounters indicate that although you may be outmatched numerically, tactical and coordination are not a strong point of these pirates, and we expect them to be completely incapable of handling a well-trained and well armed opponent.  Your primary objective is to successfully engage and destroy a number of pirate vessels.  Your secondary objective is to bring back samples of alien technology, preferably weaponry.",
		"Good hunting captain!",
		 2, 9, 1 ,
		 1, 0, 5000 )

--[[
Military Mission #29: Destroy Pirates until at least one sample of pirate cargo is obtained.  Reward is 7500 credits.
]]--
	addQuest( "Pirate Encryption",
		"Destroy pirate vessels until you successfully retrieve a sample of pirate cargo.",
		"After the success of your last mission, long-range scanners have detected several groups of pirates converging on our system.  Although the number of pirate vessels we have detected is still quite large, the majority of their ships presently continues to drift in a disorganized and aimless fashion around our listening posts and do not appear to be supporting this small number of ships heading towards us.  We cannot afford to be too cautious since this trickle could easily become a flood and overwhelm our planetary defenses.  It has been decided to utilize the disorganization of these pirates against them by striking hard in a preemptive strike before they get a chance to rally in significant numbers.  Towards this goal, you are being dispatched immediately to attack at the small groups of pirate vessels directly outside our system while a task force is being assembled to combat the larger threat.   This mission should essentially be similar to your last one, except that this time we request that you bring back at least one intact sample of their cargo, so we can better understand their strengths and weaknesses in the future.",
		"Not much of a challenge?  We now know why they fly like drunken sailors.",
		 2, 8, 1, -- one unit of pirate cargo
		 1, 0, 7500 )

--[[
Military Mission #30: Obtain a coalition afterburner either through diplomacy or by salvaging one through combat.  There is a small chance of dropping a coalition afterburner from a coalition ship when one is destroyed.

Alternatively in conversation when this mission is active the player has three choices, Moolah (offer 20 units of endurium), Diplomacy and Moolah (offer 12 units of endurium - works if attitude is greater than 35), Threaten (attack).

Taking this item back to the Bar-zhon increases the shield class by 1, or provides an attitude boost and 15 units of endurium if the player shields class is already maxed out.
]]--
	addQuest( "Coalition Negotiation",
		"Obtain a Coalition Afterburner through diplomacy or through combat and take it to the Bar-zhon.",
		"Congratulations on your recent successes Captain!  Your efforts have been instrumental in protecting Myrrdan and establishing a presence in this region of space.  We have been contacted by the Bar-zhon.  They possess a sizable empire directly coreward from Myrrdan and have entered negotiations with our government.  They are having some minor problems with rebels known as the Coalition, organized pirates upspin of their territory.  They want us to obtain a coalition afterburner one way or another and in exchange they will help us reduce the number of Pirates in our own territory.  Their failure to obtain one themselves has nothing to do with military strength.  Coalition pirates are considerably more intelligent than the pirates in our territory, and will usually run from the Bar-zhon military.  With their new afterburner technology they have been very successful at avoiding patrols.  Since we are new to this region the Bar-zhon emissary has informed us that we have a much better chance of either purchasing or picking a fight with a coalition ship.  How you want to approach this mission is up to you.",
		"Player should not see this.  Bar-zhon should terminate the mission",
		 0, 0, 0 ,
		 0, 0, 0 )

--[[
Military Mission #31: The Thrynn will reward the player by increasing their laser class by 1 if the player provides them with a salvaged Elowan Shield Capacitor.  If the player's laser classes already maxed, then the player is given 5 cubic meters of endurium instead.  Elowan should simply attack the player when this quest is active. This item may only be obtained by destroying Elowan ships.
]]--
	addQuest( "Battle Front",
		"Assist in the Thrynn war effort near 45,30, at least until you are able to salvage a Elowan Shield capacitor.  Take the capacitor to the Thrynn.",
		"Another embattled alien race has approached us.  They are known as Thrynn, and are under attack by intelligent and hostile carnivorous plants.  We have been asked to assist in their defense.  We have been asked to focus our attention on the border of Thrynn space near 45,30.  According to the Thrynn, Elowan ships possess advanced shielding technology and the Thrynn are willing to give us specifications on their top laser weaponry in exchange for your help. Myrrdan scientists are eager to get their hands on this technology and your crew should be able to further enhance your laser cannon with this data.  Destroy as many Elowan ships necessary to obtain one of their shield capacitors and then take a sample to the Thrynn.  Intelligence gathered from other races has shed some doubt on the motives and trustworthiness of the Thrynn, so keep your eyes open out there.  This is a war zone undergoing active hostilities, but our goals are humanitarian and not mercenary.  Do not provoke an attack, nor risk your ship for an extended duration, but if you are fired upon you are authorized to defend yourself.",
		"Player should not see this.  Thrynn should terminate the mission",
		 0, 0, 0 ,
		 0, 0, 0 )

--[[
Military Mission #32: Obtain another coalition afterburner this time only possible by salvaging one through combat. Coalition ships attack the player instantly when this quest is active.
]]--
	addQuest( "Preemptive Strike",
		"Destroy enough Coalition ships to salvage another Coalition afterburner.",
		"The Coalition has made several threatening gestures towards us due to our continued negotiations with the Bar-Zhon.  A show of force has been deemed necessary to prevent these terrorists from mounting an attack against Myrrdan.  Your objective is to enter Coalition territory and destroy several coalition ships.  Your secondary objective is to obtain at one Coalition afterburner artifact for our own scientists to study.  We were not able to discover much from our scans of the earlier unit you retrieved, and some of the eggheads complained that we turned over the unit to the Bar-zhon too quickly.",
		"Very well done.  They should now better understand our military strength.",
		 2, 20, 1 ,
		 1, 0, 15000 )

--[[
Military Mission #33: Obtain Nutritional Chemicals from the Spemin - this quest is not possible.  No matter how many ships are destroyed, the item will not be dropped and no conversation path will reach it. The only option is to tell the Spemin to forget the quest.
]]--
	addQuest( "Medical Breakthrough",
		"Obtain Nutritional Chemicals from the Spemin, outwards and slightly downspin of Myyrdan.",
		"The Bar-zhon recently discovered a race located between the Minex and Thrynn long ignored by both empires.  This race, the Spemin, apparently possess advanced medical knowledge and utilize a regenerative fluid which our scientists are eager to study.  This is a first contact situation, however our top priority is to obtain this technology.  Information provided by the Thrynn show that the Spemin, although extremely numerous, pose no military threat to anyone.  You are authorized to use any level of force you deem necessary, but this decision is of course your call to make.",
		"This stuff is absolute garbage, but we'll still give you something for your fuel costs.",
		 2, 12, 1 ,
		 1, 0, 4000 )

--[[
Military Mission #34: Return the sample of erratic energy devices.  Minex automatically attack when this quest is active.
]]--
	addQuest( "Covert Retrieval",
		"Retrieve any artifacts found on planet Inchegeela II (59,210) at coordinates 135N X 133W",
		"Although we have now learned that the Spemin nutritional fluid is a simple broth of basic chemicals, we have another mission that will not prove to be such a waste of time.  Myrrdan scientists have decoded data sources dating from the Great War between the  Bar-zhon and the three imperialists that indicate that an advanced alien research lab was held in a secret location far away from the conflict.  This lab now lies on the planet Inchegeela II (59,210) at coordinates 135N X 133W, deep within Minex space.  The Minex are not overtly hostile, but intelligence indicates that their ships are very powerful and they are known to attack vessels in their territory.  It has been decided at the top levels that the possible benefits from obtaining new technology through a covert expedition of this nature outweighs the possible risks.",
		"Excellent job as usual.",
		 2, 17, 1 ,
		 1, 0, 30000 )

--[[
Military Mission #35: Destroy Minex ships until Minex electronics are recovered. Minex automatically attack when this quest is active.  Starport pays 50,000, the Bar-zhon upgrade the ship to the max_missile_class or provide 35 endurium if the artifact is taken to them.  The Thrynn upgrade the ship to the max_laser_class if the artifact is taken to them.
]]--
	addQuest( "Minex Retaliation",
		"Salvage a piece of functioning Minex electronics from their computer core and return to starport.",
		"The Minex have attacked and destroyed several Myrrdan transports in apparent retaliation for your last mission.  We must not let this aggression stand.  The brass has authorized a very challenging strike mission.  Your primary goal is to engage and destroy several Minex warships.  Your secondary goal is to acquire an operational computer core from one of their warships for our scientists to analyze.  Since there is no way of knowing how many ships you must destroy to obtain one, your orders are to return immediately after salvaging an operational unit.  Although other races may be interested in this technology, we urge you only to deliver it directly to starport.",
		"Very impressive Captain!  This tech should ensure our superiority!",
		 2, 22, 1 ,
		 1, 0, 50000 )

end

function init_freelance_missions()

--[[
Freelance Mission #26: Originally a multiple-choice interrogation and first contact negotiation with the Tafel would let the player purchase this item or obtain it for free. Since they are now a hostile race only with no artwork, the only option is to salvage it from a destroyed ship.
]]--
	addQuest( "Stellar Data",
		"Obtain a Tafel Data System by any means necessary.",
		"A source is willing to pay for stellar charts of the region possessed by the Tafel.  Their ships mainly group in the region of space upspin from us.  Either convince them to give us stellar data of this region or else destroy enough of their ships to salvage another datacore.  Our source reported that the Tafel were not hostile but the last ship we sent out did not return. We are confident that you will not become lost in space like they were!",
		"That should fill in the holes in our maps!",
		2, 7, 1,
		1, 0, 3500 )

--[[
Freelance Mission #27: Obtain the ticking cylinder from Fiacha III 219,179, at landing coordinates 63N, 147W. Taking the artifact to the Nyssian will complete the mission.
]]--
	addQuest( "Archaeology Appropriation",
		"Investigate planet Fiacha III (219,179), at landing coordinates 152N X 64W.",
		"Information obtained from, ahh, anonymous sources indicate that something unusual was recovered at a Myrrdan archaeological dig on a world far downspin and coreward from here.  Investigate planet Fiacha III (219,179), at landing coordinates 152N X 64W.  If you impersonate their supply ship, you should be able to pick up any artifacts on site without a fuss.  After you pick it up, your buyer is one of the nomadic race downspin of the Bar-zhon.",
		"The player should not see this, the Nyssian will complete the mission.",
		0, 0, 0,
		0, 0, 0 )

--[[
Freelance Mission #28: Contact a Nyssian ship, attempt to purchase data crystals, the player is given an option to terminate the mission, trying to use force or bribe them with endurium fails, telling them the truth about why you want the reaper ends the mission and severely hurts your attitude with them. The only successful option is to go to the Thrynn and obtain a reaper from them. This requires that the player have more than 10 m³ of radium (51) and/or uranium (52) in their hold. All uranium and radium are given to the Thrynn in exchange for one Thrynn reaper, and then this item can be taken back to the Nyssian to obtain the data crystals.
]]--
	addQuest( "Database",
		"Contact a Nyssian ship and try to purchase these data crystals or optionally use violence to salvage a collection of data crystals.",
		"A trustworthy intelligence source has recently confirmed that all Nyssian ships like the one you dealt with in your last mission carry optical data crystals with vast amounts of data on this region of space.  We have a number of potential buyers interested in paying quite well for this information.  Contact a Nyssian ship and try to purchase these data crystals or optionally use violence to salvage a collection of data crystals.",
		"These histories stretch back tens of thousands of years.",
		2, 19, 1,  -- Nyssian data crystals
		1, 0, 25000 )


--[[
Freelance Mission #29: Contact the coalition about the stolen orb. If their attitude is above 60, or if you bribe them with five endurium, they will tell you about Lazerarp and that the orb is on the north pole of the planet.  The Bar-zhon describe how the device was stolen from them, vaguely what it does, and refer you to the Nyssian.  The Nyssian tell the player that Lazerarp is known as Alastir, the first planet of the system Tat. (132,125)

Bar-zhon: demands immediate return for no compensation or if refused, attacks the player and attitude drops by 50 points
Coalition: 15cm of endurium or increase laser class by one
starport: 6000 credits
]]--
	addQuest( "The Orb",
		"Contact the Coalition about a stolen orb, locate it, and return it to Myrrdan, the Coalition, or the Bar-zhon for a reward.",
		"Members of the Coalition have run across information about a Bar-zhon artifact that was recently stolen by pirates.  They have the details about this orb, and you must ask them for further information, but keep in mind that both they and the Bar-zhon are interested in retrieving the device.  In addition there are factions here at home that are interested and willing to pay well for it.",
		"This whining orb is somewhat familiar.  Glad you didn't sell it elsewhere.",
		2, 16, 1,
		1, 0, 6000 )

--[[
Freelance Mission #30: Contact the Nyssian about their amazing artifact. They demand a Minex silver gadget that may be obtained by destroying Minex ships, or by trading for one from the Coalition.  The Coalition is looking for the spiral lens device of the Thrynn.   The Thrynn in their normal conversation about general information will tell you that the spiral ends may be obtained from Eocho in the Etarlam (172,118) system at coordinates 47S X 95W.
]]--
	addQuest( "The Incredible Astounding Amazing Artifact",
		"Contact the Nyssian and obtain their amazing artifact.",
		"The Nyssian have discovered something they call an amazing artifact and have sent broadcasts blanketing the entire region of space with the news.  We have several clients who are willing to pay well for it. Go and encounter a Nyssian scout ship and find out what it will take to get hold of it.  ",
		"This thing doesn't even appear that old.   Fortunately our contract to acquire this thing is ironclad.",
		2, 26, 1,
		1, 0, 10000 )

--[[
Freelance Mission #31: Parallel to military mission # 30.  If the coalition attitude is 60 or above, when the player gives them 10 endurium, the attitude is increased to 70 an afterburner is provided. If not, the attitude is increased by 10, the player receives nothing, and the communication session is ended and has to be repeated again until the attitude is above 70.

Increasing their attitude through conversation first is far cheaper.
]]--
	addQuest( "The Runners",
		"Obtain a Coalition Afterburner through diplomacy or combat.",
		"The Bar-zhon have run across a new Coalition drive technology in their skirmishes and want a working sample.  This device is known as a Coalition afterburner, and has been giving the coalition a significant tactical advantage in their conflict.  It may possible to bribe a Coalition captain to obtain the technology, but if that fails, destroying a sufficient number of Coalition ships should eventually allow an enterprising captain to salvage a functioning unit.",
		"This thruster tech should keep the eggheads happy.",
		2, 20, 1, --  coalition afterburner
		1, 0, 14000 )

--[[
Freelance Mission #32: Parallel to military mission # 31.  If the player chooses to destroy Elowan ships to obtain a shield capacitor, the Thrynn will increase the player's laser class by up to 2 levels if possible.  If the player chooses to destroy Thrynn ships to obtain a Thrynn Battle Machine, the player is given an upgrade to their shields by 1 level if possible.
]]--
	addQuest( "Killer Plants",
		"Enter the war zone near 45,30 and either salvaged an Elowan Shield capacitor to the Thrynn, or salvage something for the Elowan.",
		"Envoys of the Thrynn have reached Myrrdan and they are currently begging the powers that be for aid.  They claim they are under attack by intelligent and hostile carnivorous plants known as the Elowan.  A skirmish is currently occurring on the border of Thrynn space somewhere near 45,30.  According to the Thrynn, Elowan ships possess advanced shielding technology and the Thrynn are willing to give us specifications on their top laser weaponry in exchange for your help. On the other hand, covert scans of the Thrynn ships docked here show many useful technologies as well.  A profitable venture would be to either destroy as many Elowan ships necessary to obtain one of their shield capacitors and then take a sample to the Thrynn, or to destroy enough Thrynn ships to find something to take to the Elowan.  Choose what you want to do, but make sure you line up a buyer first.",
		"Player should never see this message.  Resolved by the Elowan or Thrynn",
		0, 0, 0,
		0, 0, 0 )

--[[
Freelance Mission #33: When this mission is active, the Minex instantly attack the player.  That being said, retrieving the artifact 'Erratic Energy Devices' is very straightforward. The artifact can be returned to starport for a reward, or alternatively the coalition will reward the player with their choice of either 40 endurium, +1 to shielding (if possible) or +1 to lasers (if possible)
]]--
	addQuest( "Covert Operation",
		"Retrieve any artifacts found on planet Inchegeela II (59,210) at coordinates 135N X 133W",
		"Myrrdan scientists have decoded data sources dating from the Great War between the Bar-zhon and the three imperialists that indicate that an advanced alien research lab was held in a secret location far away from the conflict.  This lab now lies on the planet Inchegeela II (59,210) at coordinates 135N X 133W deep within Minex space.  The Minex are not overtly hostile, but intelligence indicates that their ships are very powerful and they are known to attack vessels in their territory.  Avoid all contact and simply get in and get out.  The Myrrdan council wants deniability, so if you get in trouble out there you will be on your own.  An insurgent group that shall go nameless is also interested in any technology you find, but Myrrdan is more then willing to provide decent compensation as long as you return any technology here.",
		"This technology is like nothing we've ever seen.",
		2, 17, 1,
		1, 0, 30000 )

--[[
Freelance Mission #34: Also very simple, pick up the artifact and contact all alien races to see who will pay the most:

Elowan: not interested
Thrynn: 16 endurium
Spemin: not interested
Bar-zhon: 12 endurium or 15 endurium
Nyssian: attacks the player
Minex: no option to ask
Coalition: not interested

]]--
	addQuest( "Supply and Demand",
		"Retrieve the Unusual Artistic Containers on the planet Ildathach at coordinates 51S X 127W and sell to the highest bidder.",
		"Unusual Artistic Containers were recently found in an archaeological dig into our solar system on the planet Ildathach at coordinates 51S X 127W.  Radioactive dating shows these artifacts are incredibly ancient, and we have been given the task of discovering what they are worth and acting accordingly.",
		"Player should never see this message, mission ended by the Thrynn or the Bar-zhon.",
		0, 0, 0,
		0, 0, 0 )

--[[
Freelance Mission #35: The player is directed to negotiate peace between the Bar-zhon and the Elowan

Elowan: Overview of the conflict, references a Nyssian ship in the system
Bar-zhon: Overview of the conflict
Nyssian: Observed a Thrynn vessel launch a probe at the third planet which landed on the second planet
Thrynn: Deny knowledge of the conflict, deny ownership of the drone
Spemin: 'drone supposed to be located at 37S X 25W'
Minex: no option to ask
Coalition: Nothing useful, only taunts the Bar-zhon

After the probe has been found by the player:

Bar-zhon: Directs the player to take the drone to the Elowan
Elowan: Takes the shattered drone from the player and gives the player strange manuscripts

Starport: Gives the player 40,000 credits in exchange for the strange manuscripts

]]--
	addQuest( "Diplomacy",
		"Resolve the conflict of the Bar-zhon and the Elowan over the planet Aircthech III.",
		"We have been asked to mediate between the Bar-zhon and the Elowan over the Aircthech system and more specifically the planet Aircthech III.  Both races have desires to terraform this near optimal planet but talks between them have broken down.  This is unusual because it seems unlikely that either race would want any conflict.  The Elowan are embroiled in their own bitter conflict with the Thrynn, and the Bar-zhon military is focused on the Coalition at the moment. Neither race has the motive to want additional conflict.",
		"These papers should fetch a high price.",
		2, 28, 1, -- strange manuscripts
		1, 0, 40000 )
end


function init_virus_missions()

--[[
Virus stage overview:
·	Elowan wary, denies the plagues existence
·	Thrynn isolationist and hostile
·	Spemin arrogant and hints of telepathy
·	Bar-zhon busy with archaeological digs, very fearful
·	Nissan superstitious and pessimistic
·	Minex hold extremely limited conversations
·	Coalition attacks the player for resources
]]--

--[[
Quest #36: 1. Conversation Mission: talk to all alien races to find the source of the plague (Tafel debris)

]]--
	addQuest(
		"Chaos!",
		"Find evidence for the source of this plague.",
		"One of our exploratory vessels brought back what appeared to a mild viral infection that has rapidly spread across all of Myrrdan and threatens to become a serious pandemic.  So far no human has died, but massive numbers across the entire planet have experienced irregular flu-like symptoms and periods of complete unconsciousness.  We have absolutely no idea how this sickness was able to bypass quarantine so easily and quickly.  The only other thing we know is that the virus apparently mutates rapidly and drastically.  Already several thousand strains have been collected.  Your mission is to discover where this virus originated, which race is responsible for its spread, and any technology or artifact that may contribute to a search for a cure.",
		"Incredibly old and unidentifiable rock samples were found in the Tafel debris, and we have identified a nanomachine still active in the samples!",
		 2, 1, 1, -- Tafel Wreckage
		 1, 0, 40000 )



--[[
Quest #37: 2. Track down two Myrrdan smugglers, the Diligent and the Excelsior. Spemin reveal that the Thrynn destroyed the Excelsior, and the Diligent recently traveled to a lava planet in a class a system in Elowan territory. 50 randomly placed ruins on the planet point the player to 73S X 21W, and that ruin points to an abandoned base built by the Diligent's crew, abandoned except for an air plant which appears to be of the Elowan, the Elowan provides the player with the false sensor signature used by the 	Diligent. Returning to starport reveals that they were masquerading as a Myrrdan ship known as the Intrepid and escaped to Myrrdan.
]]--

	addQuest(
		"Containment",
		"Track down smugglers possibly carrying a more dangerous version of the virus",
		"We have a serious situation on our hands. Despite the pandemic racing across Myrrdan, reports from many of our exploratory vessels of the massive death tolls other races have been experiencing indicate our problems could have been much, much worse. Myrrdan planetary security has been enforcing a strict blockade of our planet to ensure that the more dangerous strains don't make it through. This has not been publicized widely, but two Myrrdan ships have gone rogue, the Diligent and the Excelsior.  They deserted after they were caught smuggling alien artifacts obtained through questionable means. Statistically they have a high likelihood of encountering the more deadly strains and a strong motivation to bypass the blockade the planet surface. The defensive fleet has orders to deny them passage and to arrest them on sight, yet security is not satisfied with merely a passive approach. Due to your excellent track record you have been chosen to track them down. We have no current leads, but their ECM signatures and proprietary schematics are being sent to your ship. Your science officer should be able to trace a warm tachyon trail or trace even cold evidence of their more presence on a planet's surface.",
		"The so-called Intrepid landed two days ago on Myrrdan.  Planetside investigations has been alerted.  We can only hope that they haven't brought any dangerous viral strains with them.",
		 2, 223, 1,
		 1, 0, 20000 )

--[[
Quest #38: 3. Gather genetic and viral samples for a team of Elowan doctors. Each race contacted wants something. The Bar-zhon want the Coalition data. The Coalition want Minex technology salvaged from a Minex vessel. The Minex want nothing and will attack the player if asked. The Elowan provide their data free, but only if their attitude is 85 or above. Below that attitude level, they will still deny that they are being affected by the plague. The Thrynn are completely hostile. The only way to get their data is through salvage.  The Spemin deny the player but can be tricked to giving their data free, the Nyssian want a scan of the hypercube the player found earlier.  Alternatively by destroying ships of each alien race, including the Tafel, viral data can be salvaged. The Coalition demands that a nuclear reactor be stolen from a  Bar-zhon world, and then they only provide Bar-zhon data. The Coalition debris gives Bar-zhon/BX/Transmodra/Sabion data randomly.  The player must retrieve 7 out of the 10 possible "artifacts" of data to complete this mission.  Items #224-234.
]]--

	addQuest(
		"Samples",
		"Obtained at least seven genetic samples from other alien races and give them to the Elowan",
		"We have been contacted by a independent group of Elowan researchers who see us as the lone power still able to make long trips in hyperspace without fear of losing ships to the madness caused by the plague.  They have been studying the virus and its effect on various life forms, but since it only activates within sentients, they have been stymied from a lack of diverse tissue samples.  They have asked us to obtain genetic samples from as many of the other races as possible. With persuasion, these samples may be obtained through diplomacy but the researchers have also pointed out that genetic samples may be obtained through other less pleasant means as well.",
		"This may not be a cure, but the insights into the nature of the plague are astounding!",
		 2, 235, 1 , -- Elowan research data
		 1, 0, 20000 )

--[[
Quest #39: 4. The Coalition is harassing Myrrdan transport and supply ships. Negotiate with the Bar-zhon to break up the Coalition's expansion into Myrrdan territory. Destroy Coalition ships until salvaging Coalition computer and targeting technology (Item #236). Relay request of Bar-zhon to build a fueling outpost around the gas giant planet of Samhain.
]]--

	addQuest(
		"Defensive Alliances",
		"Negotiate with the Bar-zhon to break up the Coalition's expansion into Myrrdan territory.",
		"Myrrdan has been planting a number of bases in the surrounding systems at a frantic pace recently to occupy displaced pirate territories in the region and also to supply our world with the huge number of mineralogical resources our economy needs to fuel our expansion of shipbuilding infrastructure.  We need to quickly build up a defensive space-based military fleet as rapidly as possible in these uncertain times.  Unfortunately the Coalition has decided to take advantage of our current military weakness and stepped up raids upon Myrrdan transport and supply ships even within our territory.  Our ships have an excellent chance against them on a one-to-one basis but in a major fleet action we cannot stand up to them in terms of pure numbers.  Their ships have also done a good job of avoiding the well-armed explorers such as yourself and our military patrols.  Diplomatic channels with them have been closed since the outbreak of this unnatural infection. Since we simply cannot provide every single transport with a sufficient military escort, our only other recourse is to appeal to the Bar-zhon for aid against them. Your mission is to contact the Bar-zhon and to start the diplomatic process  towards a defensive alliance." ,
		"Very good work Captain!  The Bar-zhon proposal will be presented to Planetary Congress immediately.",
		 2, 237, 1, -- Diplomatic Pouch
		 1, 0, 20000 )

--[[
Quest #40: 5. Part two: Relay Myrrdan's acceptance of Bar-zhon terms, Bar-zhon demand a fully cooperative alliance: we must also come to their aid with military, humanitarian, and technological assistance and the Bar-zhon in return promise the same. Bar-zhon military patrols breakup Coalition excursions into Myrrdan space.
]]--

	addQuest(
		"Defensive Alliances, part two",
		"Return Myrrdan's counterproposal to the Bar-zhon.",
		"Good news!  In uncharacteristic haste, planetary Congress has reviewed the Bar-zhon proposal and issued a counter proposal for you to take back to them. You are authorized, assuming that the Bar-zhon do not have any objection to the minor changes made, to finalize and accept the defensive pact on behalf of Myrrdan.",
		"You may have exceeded your authority slightly, Captain, but the results speak for themselves.",
		 2, 238, 1 , -- Bar-zhon Governmental Communiqué
		 1, 0, 20000 )

--[[
Quest #41: 6. Investigate medical technology found in several ruins, three different planetary landing locations chained together. Data cube turns out to be a music database. Organic database must be taken to the Spemin or Nyssian to decode. Spemin respond to flattery. Nyssian demand a Thrynn laser battery. Remove organic core add decoded organic core when this is analyzed and take back to starport.  (Tandelou)
]]--

	addQuest(
		"Medical Archaeology",
		"Investigate the ruins on .....",
		"One of our scout vessels discovered the remains of an alien colony ship in the nearby system of .........  The alien race consisted of sentient plant creatures similar to the Elowan, but they did not survive on the planet's surface long enough to form a lasting civilization.  The scout vessel was unable to decode anything significant from the ruin and has turned the discovery over to us.  Your task is to investigate the ruins on the planet’s surface and identify what you find.",
		"That organic core yielded a breakthrough of regenerative gel known as grow goo: a hybrid lifeforms that connects and grafts tissue without rejection. Unfortunately it does nothing to impede the plague",
		 2, 999, 1 , -- Decoded Organic Core
		 1, 0, 20000 )

--[[
Quest #42: 7. Tracking mission, heading to Coalition space.  Coalition must be bribed to reveal that the Laytonites traded large amounts of raw ore for engine upgrades, a second bribe reveals that the Coalition discreetly traced them to the fifth planet of the Oende system, 50 randomly placed ruins show bombardment from orbit, deflected bomb craters.  Science officer extrapolates roughly where the bombs were targeted. Wreckage of base and interceptor ships destroyed in atmospheric combat attempting to defend the base from Tafel attack.
]]--

	addQuest(
		"Terrorists",
		"Track down a group of terrorists headed towards Bar-zhon territory using the provided sensor data.",
		"A group of environmental fanatics have stolen a number of commercial freighter escort fighters.  Calling themselves the New Laytonites, their stated goal is to destroy all technology and dismantle society, justifying their stance on the discovery that the nano-virus does not affect non-technological species. They warn that once Myrrdan has a chance to modernize, the violence and the death toll of the plague will start within our civilization as well. Their ships fortunately consist solely of armed space interceptors, no bombers.  Your job is to track them down and prevent them from establishing a base of operations offplanet that they can use to attack our people.  Intelligence has tracked them headed in the direction of Bar-zhon territory, but they were intelligent enough to start off on a false heading they could be anywhere by now.  Your mission is to bring the sensor profiles of their ships to the nearby alien races and see if you can find any leads.",
		"Good investigative work. It looks like this threat will not materialize at all.",
		 2, 999, 1, -- Laytonite Base Wreckage
		 1, 0, 20000 )

--[[
Quest #43: 8. Myrrdan is framed for a terrorist attack on a Bar-zhon world by independent faction of Thrynn and Coalition forces.  Source of this tip is Bar-zhon miners who reveal that the Bar-zhon are planning to retaliate. Thrynn and Coalition denies any knowledge of the event. Bar-zhon ships during this quest refuse to communicate and attack the player. The Elowan direct the player to a meeting location where Thrynn and Coalition troops were seen gathering.  Thrynn base located but no evidence of any Coalition presence. Red Herring artifact. When Red Herring is taken back to the Elowan, they reveal a second meeting place. The second meeting place shows evidence of a large number of Coalition and Thrynn ships landing, and remains of a fabrication factory to produce Myrrdan style hull plating is found. Player told to take holographic evidence to the Bar-zhon immediately.  Bar-zhon communication must answer three sets of questions correctly or be attacked. If answered correctly the Bar-zhon take the holographic evidence, provide a government communiqué to take back to Myrrdan, and inform the player that the retaliation fleet was already destroyed en-route to Myrrdan by a surprise ambush of Tafel and infected ships working together.
]]--

	addQuest(
		"Desperate Measures",
		"Find any evidence to stop the Bar-zhon from retaliating against us!",
		"A group of Bar-zhon miners have come to us outside of their government's knowledge with confidential and extremely alarming information. The Bar-Zhon supposedly have 'incontrovertible proof' that a small group of Myrrdan warships raided the Bar-zhon colony world of MacCecht IV, destroyed the system's infrastructure, killed a number of naval officers who were unable to reach escape pods in time, and salvaged and stole anything of value in the system. The miners have come to us because they say their government has decided not to confront Myrrdan diplomatically but instead dispatch a war fleet directly to our homeworld to demand reparations and possibly retaliate for the attack.  Needless to say, that war fleet has not arrived yet.  Your mission is to contact the Bar-zhon directly concerning this issue and also investigate and discover what you can about the incident in the hope to exonerate Myrrdan before another incident occurs and Myrrdan lives are possibly lost because of this falsehood.",
		"Player should not see this, mission ended by the Bar-zhon",
		0, 0, 0,
		0, 0, 0 )

--[[
Quest #44: 9. The decontamination transporter. Bar-zhon approach Myrrdan. A joint Bar-zhon/Thrynn venture needs Myrrdan help to obtain resequencer data from the Elowan. No other race is able or capable of solving the technical problem with the teleporter’s resequencer other than the Elowan.  Because the Bar-zhon are allied with Thrynn, the Elowan are not speaking to them. The Elowan provide the data on request. The player can take the data to either the Thrynn or the Bar-zhon for a small reward and they provide the player with a data cube to take to starport to construct a transporter.  Starport reports that the decontamination transporter fails to filter all traces of the plague.
]]--

	addQuest(
		"Decontamination",
		"Contact the Elowan concerning the joint Bar-zhon/Thrynn teleporter project",
		"After their embarrassment, the Bar-zhon have established a permanent embassy on Myrrdan and have pledged to work with us towards building stronger ties between our peoples. They have asked us for assistance on a joint Bar-zhon/Thrynn venture that needs outside help. This group of researchers have taken a unique approach in the attempt to remove the plague from those who are infected by it. Instead of direct matter to energy to matter reconstruction that conventional teleportation devices use, they have invented a teleportation device that intelligently rebuilds the life form from its unique biological data directly, therefore allowing a complete removal of all contaminants.  The problem with device has been gene activation.  Genetic material alone is insufficient to rebuild a life form and the bioscience needed to solve this problem is beyond the Bar-zhon, Thrynn, or us. The Bar-zhon have discreetly asked us to contact the Elowan on their behalf.  The recently announced Bar-zhon / Thrynn alliance has greatly cooled relations between them and the Elowan.",
		"Our tests with the transporter demonstrates that not only does it fail to filter all biological viral traces, but it also creates hermaphrodites out of the volunteers.",
		 2, 999, 1 , -- Decontamination Transporter
		 1, 0, 20000 )

--[[
Quest #45: 10. (War planet/G’nunk planet where all lifeforms are dangerous and hostile.  New planet type / dozens of ruins)
]]--

	addQuest(
		"The War Planet",
		"Go to the planet ... then bring back 5 armored humanoid lifeforms",
		"A non-sentient lifeform has been found on Cermait III that destroys all biological viral code generated by the nano-virus within its body.  Our researchers are currently unable to determine how this creature's immune system is responsible for this effect. Your mission is to find and collect at least 5 additional specimens from this planet that we hope will exhibit the same trait.",
		"Unfortunately in your absence new biological strains of the virus appeared which is not being destroyed by this lifeform's immune system",
		 2, 999, 5, -- Armored Humanoid
		 1, 0, 20000 )

--[[
Quest #46: 11. A group of aliens is selling a treatment for the plague that is designed to greatly reduce the periods of madness caused by the virus.  The Nyssian declare that this group is promoting a complete fraud. They send the player to ......... to investigate a crashed Bar-zhon ship. Artifact: Medical Treatment found. Ship's log describing partial effectiveness: half the crew become possessed and start muttering in a strange alien language and are completely unresponsive to orders or questions. When some of them are restrained, all of the possessed crewmembers mutiny and slaughter the regular crewmembers. Captain sets self-destruct, self-destruct is disabled, intentionally crashes the ship. No survivors. If all go mad at once, at least all return at once.  Telepathic influence suggested.  Medical treatment taken to Bar-zhon, refer to the Elowan.  Elowan describe their tests of their samples they have as partially effective and losing effectiveness as new mutations appear.  The treatment is currently useless for Myrrdan since humans appear to be immune from all serious effects of the virus.  Elowan end the mission.
]]--

	addQuest(
		"Alien healthcare scam",
		"Discover if there is any truth to the alien healthcare treatment",
		"A group of unaffiliated aliens from multiple species has been researching leads to slow down or stop the periods of madness caused by the virus.  Some report that they have made great success while others report that they lobotomize their patients. Your task is to track down this group and find out what you can about their methods. Our best information on this group has come from the Nyssian.",
		"Player should not see this, mission ended by the Bar-zhon",
		0, 0, 0,
		0, 0, 0 )

--[[
Quest #47: 12. Shield cracking. Return to the inaccessible planet at Cermait 6 - 247, 218.  Failure yet again. Communications with the other alien races report failed attempts of using particle beams or bombs against the force field without success over the centuries.
]]--

	addQuest(
		"Penetration",
		"Trade 25cm radioactives to the Nyssian for a shield phase synchronizer, try to land at Cermait 6 - 247, 218",
		"Technological negotiations via hyperwave with a Nyssian traveler have gone unexpectedly well.  In exchange for 25 cubic meters of radioactives, they have promised to give us a new technological artifact that will allow any object to passes through a shield without obstruction. The device is much too large to mount on conventional weaponry and we have been warned that the device is based on technology that is extremely difficult or impossible to reverse engineer.  Before we tear it apart, you are ordered to install the device in your ship and attempt to pass through the shield surrounding the planet Cermait 6 - 247, 218.  Return the device back to Starport immediately afterwards, successful or not.",
		"This exotic device indeed penetrates every test shield we can generate on Myrrdan.  Cermait 6 will have to remain a mystery a bit longer.",
		 2, 999, 1 ,  -- Shield phase synchronizer
		 1, 0, 20000 )

end

function init_war_missions()

--[[
War stage overview:
·	Elowan alliance with Thrynn, some knowledge of the Uyo/ancients
·	Thrynn apologetic, seeking military alliance, gloating over Elowan
·	Spemin insane and schizophrenic, wild statements, telepathic
·	Bar-zhon strategizing, isolationist, bravado over their strength
·	Nissan wildly pessimistic and superstitious
·	Minex extremely sparse dialogue sometimes possible
·	Coalition apologetic and giddy over salvaged technology, helpful
]]--

--[[
Quest #48: 1. Conversation Mission: talk to all alien races to find the reason for the Minex fleet movements (shimmering pyramid artifact)
]]--
	addQuest(
		"Threatening Actions",
		"Attempt to discover the reason for the Minex fleet movements.",
		"Despite massive death tolls among all other races, humanity is apparently still mostly immune and no human casualties have been reported.  The nanovirus is still creating mild illnesses in our population no more serious than the common cold, but there is no guarantee that the next strain will not generate a massive death toll.  Meanwhile, we have started to receive reports of enormous fleets moving from Minex space towards the direction of the Bar-zhon and the Thrynn/Elowan.  If this is an invasion, keep in mind that the number of ships that Myrrdan has available is tiny next to the other races, and if we are discovered here, it is doubtful that humanity would survive.  Attempt to discover the reason for the Minex fleet movements.  If this is war, attempt to find any way possible to stop the Minex before they turn their attention on us.",
		"This Shimmering Pyramid is a very advanced database written in the Minex language.  We are sending an envoy to the Minex with this artifact.",
		 2, 3, 1 , -- Shimmering Pyramid
		 1, 0, 20000 )


--[[
Quest #49: 2.	Intel gathering on Minex, all races provide some insights, the Bar-zhon will analyze any salvaged Minex power core and provide a data chip for Myrrdan. The Minex will always attack the player without any conversation possible when this quest active. All of the other races have interesting generalities but nothing specific to resolving the mission. If the player does not want to salvage one themselves, the Thrynn will sell a power core for 40 endurium.
]]--

	addQuest(
		"Intelligence Collaboration",
		"Contact all of the nearby alien races to discover what has been learned about Minex ship technology",
		"Combat with the Minex has gone unexpectedly poorly for all of the other races including ourselves.  Our military has compiled a data core containing all of our knowledge of the technological strengths and weaknesses of Minex vessels and also tactical analysis of our few battles with them. The other races are more than likely to be compiling this information as well and information sharing between all of us should prove beneficial if not essential for turning the tide of this war.  Your mission is to exchange our data for any significant technological discoveries that others have made about the Minex. As the Bar-zhon, Thrynn, and Elowan are currently bearing the brunt of the attacks, it is likely that they will have the most information about the enemy.",
		"Very successful diplomatic work!  We are collating this information and distributing it to all of our allies",
		 2, 999, 1, -- Bar-zhon Intelligence Data
		 1, 0, 20000 )

--[[
Quest #50: 3.	When the player contacts the coalition, they deny the charge of attacking the Elowan and Thrynn strongly. The Bar-zhon affirm the guilt of the Coalition, accuse them of being Minex collaborators and even give the player a data recording substantiating the attacks. Taking these recordings back to the Coalition, and they point out that the ships in the attacks were previously lost to them and they fought to the death, a very non-coalition behavior and that they failed to take advantage of their afterburners. They finally report that the recordings were made within Spemin territory. The Spemin report when in a schizophrenic state that "project overwash" proved to be ineffective due to Minex. They tell you that they plan to postpone efforts and conserve controlled ships. This revelation ends the mission.
]]--

	addQuest(
		"Unrest",
		"Confront the coalition concerning their attacks on the Elowan and the Thrynn",
		"Both Elowan and Thrynn have reported raiding attacks by the Coalition upon weak points in their territories. This is obviously far outside the Coalition’s normal operating theater.  With our recently overhauled relationship with them, we have been asked to confront them on this issue.",
		"Player should not see this, mission ended by the Spemin",
		0, 0, 0,
		0, 0, 0 )

--[[
Quest #51: 4.	Malfunction with power system threatened life-support and made even interplanetary travel impossible. Two escape pods attempted to make it to the nearby rocky planetoid, other passengers decided to stay with the better-equipped transport ship.  A beacon would be placed on the most prominent landmark on the planet that would direct any rescuers to their location.
]]--

	addQuest(
		"Emergency Evacuation",
		"Travel to the lava planet in the system ..... and search for survivors.",
		"Although the Minex have generally abstained from approaching heavily populated planets, they have not hesitated to attack civilian targets. We have heard reports that a number of space stations and outposts have been wiped out without warning and have issued a complete evacuate order to our few recently constructed stations down to minimum crew levels.  One personnel transport failed to return and a drone has pinpointed their ship on the nearby lava planet.  No communications could be established between the drone and the downed ship, so be prepared for anything.",
		"Very good work!  No casualties were reported",
		 2, 999, 2, -- escape pods
		 1, 0, 20000 )

--[[
Quest #52: 5.	  A chain of wreck sites, an artifact or two taken to the Thrynn each time. Each time Thrynn disclose the next sit.  Most sites useless, two sites contain artifacts that can be salvaged, inertial compensator technology and laser focusing technology. Lasers upgraded to level MAX+1
]]--

	addQuest(
		"Wreck salvaging",
		"Contact the Thrynn and investigate each wreck location",
		"A number of major battles have occurred between the Minex and the joint Elowan/Thrynn alliance. The Thrynn have contracted with us to investigate a number of wrecks that have crashed on several planets. Almost certainly anything useful would be destroyed either from atmospheric burn up or impact but in the off chance that something useful may be found, the Thrynn have forwarded us a list of crash sites. Under the terms of our contract, any artifacts you locate should be taken to the Thrynn for analysis and they have agreed to jointly share any resulting technology with us.",
		"Player should not see this, mission ended by the Thrynn",
		0, 0, 0,
		0, 0, 0 )

--[[
Quest #53: 6.	Weapons test class 99. Thrynn give 4 options on the communications menu. Install experimental lasers / install experimental missiles / Remove enhancements / End mission choice
]]--

	addQuest(
		"Prototype Testing",
		"Contact the Thrynn and have them equip your vessel with the prototype weapons",
		"With all of their battleships fully engaged defending their territory, the Thrynn have asked us to test a new rapid-fire missile and laser technology they have developed. A Thrynn refit crew will mount and install the new weapons and store your old equipment. If you are satisfied with the prototypes, you are welcome to keep them.",
		"Player should not see this, mission ended by the Thrynn",
		0, 0, 0,
		0, 0, 0 )

--[[
Quest #54: 7.	The player must go and talk to them to learn what the proposal is. Based on the very successful coordination between Elowan and the Thrynn, they want to try to locate similar synchronicities between other alien warships. The Bar-zhon propose holding war games between the races and find powerful ship combinations in order to find effective fleet combinations to use to challenge the Minex. Must persuade player, if not, mission ends. If successful, player goes to all other races. Myrrdan is judged to have too few ships to make any difference. Both Elowan and the Thrynn agree. The Coalition and the Nyssian strongly decline. Every time the Spemin are asked, they become insane and do not answer. Because of only three participants, the event is cancelled.
]]--

	addQuest(
		"Tactical coordination.",
		"Contact the Bar-zhon concerning their proposal",
		"The Bar-zhon have a proposal for collaboration in the war effort against the Minex. For security reasons, their broadcast to us was sparse on details. Contact them and evaluate what they are proposing.  Based on your previous successes, you have been authorized to use your own judgment in determining the merits of their proposal. Of coarse if any issues arise outside of your area of experience, you are to bring that information to Myrrdan first if the proposal has serious security ramifications.",
		"Player should not see this, mission ended by the Bar-zhon",
		0, 0, 0,
		0, 0, 0 )

--[[
Quest #55: 8.	Defend transports Myrrdan transports traveling unexpectedly unescorted from Bar-zhon territory. Coordinates are given to the player. Bar-zhon ships meet the player instead and tell them that raiders have destroyed the transports already. Mission ends.
]]--

	addQuest(
		"Transport Defense",
		"Immediately travel to ......., broadcast your position and wait for Myrrdan transports to find you, and then escort them back to Myrrdan",
		"A number of transports hauling a combination of trade goods and mineral ore has stubbornly left Bar-zhon space for Myrrdan without any escort after their military transport suffered a central coil overload.  Your task is to immediately travel to ......., broadcast your position and wait for Myrrdan transports to find you, and then escort them back to Myrrdan without delay. Piracy along this route has been rampant as military vessels have been called to face the Minex. You are urged to leave post haste",
		"You did all that you could Captain.",
		 2, 999, 1, -- Bar-zhon Sensor data
		 1, 0, 20000 )

--[[
Quest #56: 9.	Infighting pirate raiders following up devastated areas.     Three sets of coordinates; hints from each site give the player clues to how the virus is starting to directly control the actions and characters of many of the Pirates. Pirate corpse found in fourth outpost referenced by the last two of the three original outposts represents a pirate that was considered "possessed" and locked up. Return to Myrrdan for analysis.
]]--

	addQuest(
		"Infighting Pirates",
		"Travel and investigate these locations: ........, .........., and ..........",
		"The numerous pirate clans that inhabit the area around Myrrdan space have gradually grown more dangerous due to the large market of salvaged military technology created by the widespread territorial conflict with the Minex. This might be more of a problem for Myrrdan except that according to reports they have started infighting among themselves to a greater degree than they were before the war. We need you to investigate a number of razed pirate outposts in the hope that you can discover the cause of this infighting and let us judge how long we can rely upon it to keep Myrrdan unscathed. Your mission is to investigate these locations: ........, .........., and .......... ",
		"It looks like the virus is causing these pirates even more trouble then the rest of us.",
		 2, 999, 1, -- Pirate Corpse
		 1, 0, 20000 )

--[[
Quest #57: 10.	 Multiple messages concerning excursions into Minex territory. Take results to the Bar-zhon. 8 artifacts.  All curios with no military significance. One of the artifacts appears to have a organic interface. The Bar-zhon refer to the player to the Nyssian. The Nyssian revealed that the artifact is a Gazurtoid ship fragment. Lasers if less then class MAX+1 are then sent to class MAX+1, correspondingly shields are modified in the same way.
]]--

	addQuest(
		"Scavenger Hunt",
		"Investigate outposts of the 3 imperialists to discover any intelligence concerning the Minex.  First location: ........",
		"In recent weeks, the Bar-zhon have become almost outright friendly with Myrrdan and have outsourced an forensic examination of the ruins of the Transmodra and Sabion to us. Any artifacts you locate should be taken to the Bar-zhon for analysis. We have jointly agreed to share any resulting technology that we find.  The first location they want us to investigate is ..........",
		"Player should not see this, mission ended by the Nyssian.",
		0, 0, 0,
		0, 0, 0 )

--[[
Quest #58: 11.	The Spemin have a shimmering ball, but they are unable to reverse engineer or even figure it out.  They want 100 fuel or a Minex salvage piece.  An option exists "nothing from Spemin is of value, forget this mission!” Not functional. Thrynn give 50 Quorsitanium if the item is taken to them. Starport gives the player nothing.
]]--

	addQuest(
		"The Shimmering Ball",
		"Contact the Spemin and obtain from them their shimmering ball artifact",
		"The Spemin have reported a major technological find, a prototype cloaking device that operates during combat giving a single ship an enormous tactical advantage.  Your job is to contact the Spemin and find out what they would take in exchange for the device before they decide to offer it to another race.",
		"This artifact is nonfunctional and most likely a counterfeit. Better luck next time.",
		 2, 999, 1, -- shimmering ball
		 1, 0, 0 )

--[[
Quest #59: 12.	Formalizing the Bar-zhon alliance leads the player to three buildings with long sections of dialogue. Certain factions of the Bar-zhon declare Myrrdan to be nothing more than reformed pirates.  Other factions rehash all of the achievements the player has made up to this point. Player returns with draft paperwork located in third building to complete the mission.
]]--

	addQuest(
		"Formalizing the Bar-zhon alliance",
		"Travel to the Bar-zhon world of ....... to formalize our alliance with them.",
		"In a time of war, distinguished naval officers often performed the duty of ambassadors for their countries. The Bar-zhon government, firmly entrenched within their naval system, has requested a formal presence of a distinguished Myrrdan ship captain to attend the ceremony that will formally announce our alliance to their people. You have been elected to represent Myrrdan for this event and are directed to travel to the Bar-zhon world of ....... to formalize our alliance with them.  We understand that there is some controversy concerning our alliance, but the Bar-zhon ambassador has strongly downplayed these reports and assured us that the outcome of this ceremonial ritual is mostly assured.",
		"Flawlessly executed as usual Captain!",
		 2, 999, 1, -- draft paperwork
		 1, 0, 20000 )

end

function init_ancients_missions()

--[[
Ancients stage overview:
·	Elowan rebuilding, much lore of the ancients, very friendly
·	Thrynn completely hostile, claims player is Uyo
·	Spemin completely controlled by robotic Tri'na'li'da
·	Bar-zhon distressed and broken
·	Nissan very helpful and positive, knowledgeable about other races
·	Minex concise yet very open and friendly
·	Coalition giddy over salvaged technology, helpful
]]--


--[[
Quest #60: 1.	Conversation Mission: talk to all alien races to find hints about how to contact the ancients (Ancient Database Plates)
]]--

	addQuest(
		"Quest for the Ancients",
		"Discover how to contact the ancients.",
		"The Minex have suddenly withdrawn back to their borders and have issued a communiqué to Myrrdan concerning the Shimmering Pyramid we had turned over to them.  In short, their message states that they have able to recover a significant amount of their forgotten history from the device and believe that only the Ancients can stop the propagation of the nanomachines creating this plague.  The Ancients apparently once cured the Minex of a similar sickness in the past, although how they did so and how to make contact with them has been forgotten.  Your primary mission is to contact the Minex to confirm their change of disposition. Your secondary mission is to start a new search and contact all of the other alien races to hopefully discover any artifact or technology capable of contacting the Ancients.",
		"Excellent work captain!  We will start work immediately to decode this artifact, whatever it really is.",
		 2, 4, 1, -- Ancient Database Plates
		 1, 0, 20000 )

--[[
Quest #61: 2.	The Infected swarm a planet of the Bar-zhon. Investigate ruins showing their ruthless nature. No survivors, and all of the infected ones left the planet. Minex commentary about infected finishes the mission.
]]--

	addQuest(
		"Overrun",
		"Investigate the Bar-zhon planet of ..... and provide whatever rescue or aid possible.",
		"A very faint unidirectional broadcast SOS has been picked up from the orbital station around the Bar-zhon border world of ........  The transmission ends with the recorded destruction of the station, but the message also describes an invasion of the planet by a large collection of supposedly friendly alien races working in tandem.  The time lag of this hyper wave message to the nearest Bar-zhon outpost is only hours, but the delay before it reached us has been over 8 days, so it is very likely that any active combat operations between the Bar-zhon and the invaders has already been resolved.  Your primary task is to assist the Bar-zhon in any way possible and secondarily to investigate the incident itself. If this is another case of virus-controlled aliens acting together then you are instructed to consult with the Bar-zhon and the Minex.",
		"Player should not see this, mission ended by the Minex.",
		0, 0, 0,
		0, 0, 0 )

--[[
Quest #62: 3.	Search ruined worlds of the Bx/Transmodra/Sabion. The player is given a list of sites.  Commentary about the ancients includes: Ancient settlements show absolute individuality. No defensive system. Uniformity of distance between settlements but randomized vectors. Uniform settlements at any altitude as if planetary weather and temperature was irrelevant. Majority of all settlements found at class m stars. No unstable planets tectonically were ever inhabited. Long lifespan and extreme individualism assumed. Recordkeeping beyond comprehension or telepathic because of a complete lack of any trace of communication or writing or data storage systems. All messages signed by "The Society of Ancient Studies"
]]--

	addQuest(
		"Another Ruined Search",
		"Investigate a number of archaeological sites on the 3 ruined world starting with .........",
		"A database of Sabion origin has been handed to us by the Bar-zhon.  No details of any interest were found in the database other than a collection of coordinates of academic research sites dedicated to study the ancients.  As before, the Bar-zhon have uncovered this list from their historic archives but do not have the time or manpower to investigate the ruins themselves and have outsourced the task to us in exchange for a share in any of the discoveries we make.",
		"It is a shame that we cannot consult with this Society of Ancient Studies directly.",
		 2, 999, 1, -- Society of Ancient Studies Seal
		 1, 0, 20000 )

--[[
Quest #63: 4.	 Data cube given to the player by the Minex.  Questions include: Uyo matrix frequency. Last contact and contact location with the Uyo. (Shielded planet coordinates given) Activation preconditions. Termination conditions. Area of operation. Self sentience level.  The data cube tells the player what to ask next each time.  Data cube artifact exchanged for 'Data cube with responses' artifact at the end of the questions.
]]--

	addQuest(
		"The Crazed Spemin",
		"Obtain a data cube from the Minex, question the Spemin from the prompts the data cube requests, and return it to starport.",
		"The Minex have learned that the Spemin are possessed by the personality of the virus expressing itself as the Tri'na'li'da and they have discovered its mistake in thinking that Myrrdan humans are its masters.  They have devised a series of strategy questions for us to ask, and created a sophisticated sapient simulation stored within a datacube which will direct us in what questions to ask.  When you are done questioning the Spemin you are to return to starport and we will relay the responses directly to the Minex.",
		"This information is being relayed to the Mine.",
		 2, 999, 1,  -- Data cube with responses
		 1, 0, 20000 )

--[[
Quest #64: 5.	Treasure map of an infamous pirate known to scavenge artifacts. Map provided by the coalition after they tried to trick the player into paying more for it.  Aliens try and fail to pronounce name.  'Mignizitaeri'  Series of riddles and mazes.  Already looted ancient sites. Maze at end.  Prizes: small black egg. Crystal obelisk. Blackrock gem. Amethyst rod with triangular crystal base. Nyssian will tell the story of each artifact.  Thrynn will buy all artifacts except for the black egg. Returning the black egg artifact to starport finishes the mission
]]--

	addQuest(
		"The Treasure Map",
		"Contact the Coalition and obtain the treasure map that we already sent paid for. Search for the treasure.",
		"During the Bar-zhon's Republic days, an infamous pirate with a completely unpronounceable name established a reputation for himself as a collector of powerful alien artifacts.  In exchange for an unnamed quantity of supplies, the coalition has agreed to turn over a recently discovered treasure map supposedly belonging to this pirate. Starport has already paid for this map in the hopes that it will lead us to additional ancient artifacts.  Your task is to simply collect it and follow its instructions in order to locate and retrieve whatever treasure can be found.",
		"This one black artifact has been confiscated from your cargo hold.  You are directed not to ever mentioned its existence to anyone.",
		 2, 999, 1, -- black egg
		 1, 0, 20000 )

--[[
Quest #65: 6.  Coalition decides to attack Myrrdan . Elowan strongly supportive and issue a data rod to take to the Coalition. The Nyssian prophecy that we are not in any way related to the Uyo and also issue a data rod. The Bar-zhon offer to raid Coalition territory to try to pressure them into withdrawing the fleet. (useless) The Minex provide data rod contrasting the differing traits of humans and Uyo. The Coalition with all three data rods removes their fleet and sends a truce agreement to Myrrdan
]]--

	addQuest(
		"We are not Uyo",
		"Find a way to stop a faction of the Coalition from attacking Myrrdan!",
		"The Elowan have brought us information that the Thrynn accusations against Myrrdan stating that we are ‘the Uyo’ have taken root in a faction of the Coalition. Elowan Intelligence shows that they are currently building up a taskforce of ships just outside Myrrdan space gathering strength to attack us.  Contact the Coalition and any other alien races necessary to prove to them that humanity bears no relationship to the genocidal Uyo.",
		"We all owe you yet again.  Ask us for anything, anything other than discounts on equipment and minerals and it's yours!",
		 2, 999, 1, -- Coalition Truce Agreement
		 1, 0, 20000 )

--[[
Quest #66: 7.	Nyssian locate a certain ancient site. Telepathic artifact located there. Written description is that any who approaches the artifact fall into an unconscious state. The artifact itself resembles an opaque perfect mirror.  No apparent use.  Nyssian tell the player to take the artifact to the Minex.  Minex ask the player where they have located one of their children's toys. They confiscate the device and tell the player that it is something they created, not of ancient manufacture. They also tell the player that a thought mirror is too dangerous for humans.
]]--

	addQuest(
		"Telepathic Turnabouts",
		"Contact the Nyssian, search many ancient sites they may have found, and take any artifacts back to the Nyssian for analysis",
		"The Nyssian Scouts have been dredging through their oldest recordings in search of any hint or clue to the location of any ancient sites or artifacts. They have recently sent out a directional broadcast towards us informing us that they may have found something significant.  Your task is to make contact with one of them and evaluate and investigate their information as you deem appropriate.",
		"Player should not see this, mission ended by the Minex.",
		0, 0, 0,
		0, 0, 0 )

--[[
Quest #67: 8.	Searching for the legend of the Alta-hlai .  All races except for the Spemin know nothing.  Possessed message: You seek Leghk khan. Unusable. Provides coordinates. The device resembles an Inert EMP disrupter.  Discharged sometime in the last 500 years. Extremely hard shell. Bar-zhon explosives destroyed its power supply and also damaged a large part of the mechanism.
]]--

	addQuest(
		"Legend of the Alta-hlai",
		"Contact all of the races and inquire about Coalition activity on the Sabion homeworld and search out historic clues that might lead to Alta-hlai's ship",
		"Myrrdan intelligence services have reported that the Coalition is showing higher than usual activity and interest in the Sabion homeworld.  Over a dozen Coalition ships have converged on the world from different locations and have been endlessly scanning the surface for weeks now.  Inquiries to their activities have been met with denials.  We covertly intercepted and decoded communications that have revealed little other than repeated references to Alta-hlai. In the historic record, Alta-hlai was a famous Bar-zhon explorer who charted distant areas of space in the dead zone coreward of Spemin territory on his final expedition.  The Great War flared up just before his return, and he transmitted a report of finding a powerful weapon that disrupted life-force. Unfortunately his ship vanished shortly afterwards and was presumed lost due to the hostilities.  Without revealing our intelligence sources, your assignment is to discretely contact the other alien races concerning Coalition activity and to inquire concerning additional historic information about Alta-hlai.  If Alta-hlai's disruptor is found, it may of course prove to be a devastating weapon but it also theoretically might be used to disrupt the nanomachine's control of the infected.",
		"Unfortunately Bar-zhon bombs have completely destroyed the disruptor's power supply and also damaged most of the device.  It is not repairable.",
		 2, 999, 1 ,
		 1, 0, 20000 )

--[[
Quest #68: 9.	Elowan warn of military buildup to raze Myrrdan. The Elowan are too weak to oppose the action on their own.  They have tried to contact the Thrynn on our behalf but have been ignored. The Bar-zhon won't intervene, fail to honor the Myrrdan alliance, but promise to send strong diplomatic condemnation, the Nyssian confirm the fleet location (give the player a data rod) and report that the fleet is no longer at their home world but is hiding well outside of the ecliptic of the system but have no fleet of their own to assist us with.  The Minex refuse to act in judiciary role.  They report that any military assistance of any type always turns aggression upon themselves in the long term. ‘Your assistance has been invaluable but your survival is irrelevant if you can't defend yourselves.’ To resolve this mission, the player must contact the Spemin, pretend to be Uyo, give system and location (Nyssian data rod). They tell you to wait and contact them again later. They report that a large fleet of infected ships have wiped out the taskforce and provide a Spemin data crystal for the player to give to starport.
]]--

	addQuest(
		"Thrynn strike",
		"Contact all of our allies and promise anything in exchange for assistance in deflecting the Thrynn fleet.",
		"With the destruction and abandonment of many of our mining outposts, Myrrdan has not been as successful in building a fleet of ships to match the fleet levels of the other races as we would like.  With the disruption of all of the other races including those hostile to Myrrdan, this has not generally been a problem up until now. Large fleets of pirates and infected have been assailing all races including ourselves, but since we only have a single star systems to defend, our dedicated military and strong system defenses have allowed us to withstand attack after attack. Unfortunately we now have a major event our hands.  The Thrynn have completely withdrawn from the alliance, withdrawn all of their ships from the joint defensive fleet in the sector, and have been massing warships in their home system. The Elowan have secretly informed us that the Thrynn government has started whipping up their population against humans as the Uyo, blaming us for all of their problems, and are preparing to send most of their ships to Myrrdan to raze our homeworld.  Your task is to do anything necessary to prevent this attack. Contact all of our allies and promise anything in exchange for assistance in deflecting the Thrynn action.",
		"Creative solution, but we are all grateful to be alive.",
		 2, 999, 1, -- Spemin data crystal
		 1, 0, 20000 )

--[[
Quest #69: 10.	Minex summons: An unfocused transmission has been picked up in an empty star system located ...  within Elowan space. The Elowan independently tracked the signal to a minstrel who flees after relaying the message. Elowan pass on the following message and tell the player the background history of the minstrels:

Fury born without focus
Ancient evil without a core
An alliance born from willful blindness
Tethers history and ancient lore.

The crystal ones right is not to fight.
As salvation's winds blindly turn their way.
Distant reforms may echo true,
To close the past, the mute must play

]]--

	addQuest(
		"The Minstrel",
		"Respond to the Minex summons",
		"The Minex have relayed to also request to personally talk to you, Captain.  They will not disclose their business to anyone else and have asked you to travel to their territory to discuss an urgent matter.",
		"Player should not see this, mission ended by the Elowan.",
		0, 0, 0,
		0, 0, 0 )

--[[
Quest #70: 11  The Elowan read off the set of 15 coordinates.  No endurium found, but each site relays some history of the war against the Uyo from the point of view of the ancients.  In this series of ruins Earth is given as a major Uyo center and the physical form of the Uyo described. Story of anti-telepathic device destroying the Uyo on a galactic scale and leaving them open to local nonsentient predators on every world except Earth. Useless curio artifact Crystal bar found at last ruin site and returned to Myrrdan to end the quest.
]]--

	addQuest(
		"The Longshot",
		"Contact the Elowan and investigate each set of coordinates that they will provide",
		"The Elowan have been given Minex astrological survey data describing the location of what they believe are geometrically placed ancient lay lines or a set of communication relays.  Where the Minex have failed to make sense of the data for millennia, the Elowan believe they have detected some order or pattern based on the positions of the ancient ruins discovered in this sector.  A total of 15 possible unvisited ancient site coordinates have been generated all based on an algorithm that the Elowan have developed. Contact them and investigate each set of coordinates that they will provide.",
		"Unfortunately the Crystal bar appears to be simply a useless curio.",
		 2, 999, 1, -- The Crystal Bar
		 1, 0, 20000 )

--[[
Quest #71: 12.	Data from survey in mission number 11 has been thoroughly analyzed by the Minex. They have located a city of the ancients and the player returns with a Crystal Sphere (endgame)
]]--

	addQuest(
		"City of the Ancients",
		"Locate a City of the Ancients and return with a Crystal Sphere.",
		"The Crystal Bar has proven to be more than just a curio. The seemingly inert device allows those who are physically touching it to receive telepathic impressions from other ancient devices.  When brought near your earlier discovery, the Ancient Database Plates, researchers temporarily feel the sensation of vague, indistinct memories of events overlaid within their own personal memories. Dozens of researchers using the device have recorded their impressions and correlations between records have allowed us to 'read' the database plates in a matter of fashion. The most pertinent data from the device reveal the location of focal points of ancient society. We also have learned details of an interdimensional ancient device known as a crystal sphere.  The Minex have been able to provide further information and they describe these focal points as vast assemblies of ruins filled with endurium, often containing samples of advanced technology.  If a high-energy device such as a pearl-sized crystal sphere is found, they believe it is capable of boosting their telepathic abilities a level where it would be possible for them to contact the ancients directly.  Your mission is to locate a city of the ancients in the hope that a crystal sphere can be recovered.  We have been under sporadic attack by pirates and mad-ones growing stronger every day under the influence of the Uyo's nanomachines.  Do not delay in your search.",
		"",
		 2, 5, 1, -- crystal sphere
		 0, 0, 0 )
-- This reward should end the game.

end

function add_last_quest()
	-- Add one final quest to the end of the quest table to keep it from crashing
	size = table.getn(quests)
	quests[size+1] = {
		name = "GAME OVER",
		short = "Error",
		long = "This quest should never be shown to the player! The last quest should end the game.",
		debrief = "",
		requirement = { 0, 0, 0 },
		reward = { 0, 0, 0 }
	}
end

function addQuest(n,s,l,d, req1, req2, req3, rew1, rew2, rew3)
	num = table.getn(quests)+1
	quests[num] = {
		name = n,
		short = s,
		long = l,
		debrief = d,
		requirement = { req1, req2, req3 },
		reward = { rew1, rew2, rew3 }
	}

end


function getActiveQuest()
	--Return data for the current quest from the quests table based on active_quest
	quest_name = quests[active_quest].name
	quest_short = quests[active_quest].short
	quest_long = quests[active_quest].long
	quest_debrief = quests[active_quest].debrief
	requirement_code = quests[active_quest].requirement[1]
	requirement_type = quests[active_quest].requirement[2]
	requirement_amount = quests[active_quest].requirement[3]
	reward_code = quests[active_quest].reward[1]
	reward_type = quests[active_quest].reward[2]
	reward_amount = quests[active_quest].reward[3]
	getPlotStage()
end

function getPlotStage()
	if active_quest == 36 then plot_stage = 2
	elseif active_quest == 48 then plot_stage = 3
	elseif active_quest == 60 then plot_stage = 4
	elseif active_quest == 72 then plot_stage = 5
	else plot_stage = 1
	end
end

function getNextQuest()
	-- Increment active_quest counter and then retrieve the new quest from the quests table
	size = table.getn(quests)
	if active_quest < size then
		active_quest = active_quest + 1
		getActiveQuest()
		quest_completed = false
	end
end

function Initialize()
	math.randomseed( os.time() )

	--this will be removed after testing
	active_quest = 1
	quest_completed = false

	quests = {}
	quest_name = ""
	quest_desc = ""
	quest_debrief = ""
	require_code = 0
	require_type = 0
	require_amount = 0
	reward_code = 0
	reward_type = 0
	reward_amount = 0

	--load the tutorial training missions
	init_training_missions()

	--load the profession-specific missions
	if profession == "military" then
		init_military_missions()
	elseif profession == "freelance" then
		init_freelance_missions()
	elseif profession == "scientific" then
		init_science_missions()
	end

	--load the post-profession shared missions for the endgame
	init_virus_missions()
	init_war_missions()
	init_ancients_missions()
	add_last_quest()

end

--these premature calls just help validate the script against errors
Initialize()
getActiveQuest()

