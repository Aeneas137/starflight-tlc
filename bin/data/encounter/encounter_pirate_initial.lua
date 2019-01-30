--[[
	ENCOUNTER SCRIPT FILE: PIRATE

	Globals shared with C++ module:
		ACTION - actions invoked by script (see below)
		POSTURE - obsequious, friendly, hostile
		ATTITUDE - this alien's attitude toward player (1 to 100)
		GREETING - greeting text after calling Greeting()
		STATEMENT - statement text after calling Statement()
		QUESTION - question text after calling Question()
		RESPONSE - alien's responses to all player messages
		QUESTION1..5 - choices available in a branch actiona
		Q{} - same choices but in table format
		GOTO1..5 - jump locations associated with branch choices
		G{} - same gotos but in table format
		
		DROPITEM1..5 - item id #'s from stfltitems.xml (DataMgr) that this alien drops when killed
		DROPRATE1..5 - item drop rates
		Note: Random minerals are used by default for drops. If you want a specific mineral or drop item such as
		a quest item, then plug it in with it's % drop chance and it will be dropped randomly. If you want an item to
		always drop, set it's drop % to 100, but note that no other items will ever drop.
		
	ACTION REFERENCE:
		restart = start dialogue over at beginning
		terminate = end communication
		attack = engage in combat

	C++ module should examine all globals after any function is called.
	This script uses no function parameters or return values. All data is communicated with globals for simplicity.
--]]




dofile("data/encounter/encounter_common.lua")


------------------------------------------------------------------------
-- HOSTILE DIALOGUE ----------------------------------------------------
------------------------------------------------------------------------
function HostileDialogue()
	--add as many player greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack
	greetings[1] = {
		action="attack",
		player="",
		alien={"Your ship looks like it will bring a few credits.","Let's negotiate. Drop shields, disarm weapons, close your eyes and count to 50..er..100.","Our communication system is overloaded so please wait a minute.","From hunter to hunted, prepare to die.","Nice ship! I'll take it!"}
	}

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="attack",
		player="",
		alien={"We're taking your ship. Jump out in your escape pods and we'll let you live."} 
	}


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	
	questions[10000] = {
		action="attack",
		player="",
		alien={""}
	}
	


end

------------------------------------------------------------------------
-- SCRIPT INITIALIZATION - CALLED ONCE AT STARTUP
------------------------------------------------------------------------
function Initialize()
    -- COMBAT VALUES FOR THIS ALIEN RACE
    health = 100                    -- 100=baseline minimum
    mass = 2                        -- 1=tiny, 10=huge
	engineclass = 1
	shieldclass = 1
	armorclass = 2
	laserclass = 2
	missileclass = 0
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%
	
	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate of 0 is guaranteed because it will always be lower than the random number generated in the game
	--if none here are chosen at random, game will choose a random mineral (id # 30-54) to fill in
	--qty is max random amount
	--8 - pirate datacore
	--9 - pirate doodad
	
	DROPITEM1 = 8;	    DROPRATE1 = 97;		DROPQTY1 = 1
	DROPITEM2 = 9;		DROPRATE2 = 90;	    DROPQTY2 = 1
	DROPITEM3 = 31;		DROPRATE3 = 25;		DROPQTY3 = 4
	DROPITEM4 = 33;		DROPRATE4 = 50;		DROPQTY4 = 5
	DROPITEM5 = 48;		DROPRATE5 = 80;		DROPQTY5 = 1

	--initialize dialog
	starting_attitude = 10
	starting_posture = "hostile"
	current_question = 1
	next_question = 1

	--initialize globals as needed
	if ATTITUDE == nil then ATTITUDE = starting_attitude end
	if POSTURE == nil then POSTURE = starting_posture end

	--special consideration for attitudes
	if ATTITUDE < 10 then
	    ACTION = "attack"
	    RESPONSE = "Prepare to be boarded."
	end

	--initialize dialogue tables
	greetings = {}
	statements = {}
	questions = {}

	--initialize root categories
	questions[1] = {
		action="attack",
		choices = {
			{ text="ATTACK", goto=1 },
		}
	}

	--load dialogue based on posture
	HostileDialogue()
	
	--save copies of these globals
	old_attitude = ATTITUDE
	old_posture = POSTURE
end

------------------------------------------------------------------------
-- SCRIPT UPDATE - CALLED PERIODICALLY
------------------------------------------------------------------------
function Update()
--[[
	these globals are refreshed before update() is called:
	attitude
	posture
	player_money
	player_profession
	ship_engine_class
	ship_shield_class
	ship_armor_class
	ship_laser_class
	ship_missile_class
	plot_stage
	active_quest
--]]
end



