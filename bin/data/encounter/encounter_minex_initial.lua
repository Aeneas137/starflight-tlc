--[[
	ENCOUNTER SCRIPT FILE: MINEX INITIAL

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

	ACTION REFERENCE:
		restart = start dialogue over at beginning
		terminate = end communication
		attack = engage in combat

	C++ module should examine all globals after any function is called.
--]]

--include common encounter functions
dofile("data/encounter/encounter_common.lua")


------------------------------------------------------------------------
-- OBSEQUIOUS DIALOGUE -------------------------------------------------
------------------------------------------------------------------------
function ObsequiousDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack
	greetings[1] = {
		action="",
		player="Hail oh mighty ones, masters of the universe.",
		alien={"<Silence>"} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"<Silence>"}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"<Silence>"} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"<Silence>"} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"<Silence>"} }

		
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"And?"} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien={"<Silence>"} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"<Click>"} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"<Silence>"} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"<Humm>"} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"<Silence>"} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"<Tick>"} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"<Click>"} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"<Whirl>"} }

		
	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=11000,
		player="What can you tell us about...",
		alien={"By the agreement of 17439 one is warned not to interfere in Minex affairs or encroach upon our territory."}
	}
	
	questions[11000] = {
		action="terminate",
		player="But would you consider...",
		alien={"By the agreement of 17439 one is warned not to interfere in Minex affairs or encroach upon our territory."}
	}

end

------------------------------------------------------------------------
-- FRIENDLY DIALOGUE ---------------------------------------------------
------------------------------------------------------------------------
function FriendlyDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack
	greetings[1] = {
		action="",
		player="Greetings from the planet Myrrdan. We come in peace...usually.",
		alien={"<Silence>"} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"<Silence>"} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"<Silence>"} }
	greetings[4] = {
		action="",
		player="Greetings.  There is a lot we can learn from each other.  Please respond.",
		alien={"<Silence>"} } 
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"<Humm>"} }
	statements[2] = {
		action="",
		player="Your ship appears very elaborate.",
		alien={"<Click>"} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"<Whirl>"} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"<Humm>"} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"No, they will not."} }
		 


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 
	
	questions[10000] = {
		action="jump", goto=11000,
		player="What can you tell us about...",
		alien={"By the agreement of 17439 one is warned not to interfere in Minex affairs or encroach upon our territory."}
	}
	
	questions[11000] = {
		action="terminate",
		player="But would you consider...",
		alien={"By the agreement of 17439 one is warned not to interfere in Minex affairs or encroach upon our territory."}
	}
	
end

------------------------------------------------------------------------
-- HOSTILE DIALOGUE ----------------------------------------------------
------------------------------------------------------------------------
function HostileDialogue()
	--add as many player greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack
	greetings[1] = {
		action="",
		player="This is captain [CAPTAIN] of the starship [SHIPNAME]. Identify yourselves immediately or be destroyed.",
		alien={"<Silence>"} }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"<Silence>"}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"<Silence>"} }
	greetings[4] = {
		action="",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"<Silence>"} }
	greetings[5] = {
		action="",
		player="We require information. Comply or be destroyed.",
		alien={"<Silence>"} }
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="terminate",
		player="Your ship is oversized and weak.",
		alien={"<Silence>"} }
	statements[2] = {
		action="terminate",
		player="What an ugly and worthless creature.",
		alien={"<Silence>"} }
	statements[3] = {
		action="terminate",
		player="You do not frighten me. Surrender at once. ",
		alien={"<Silence>"} }
	statements[4] = {
		action="terminate",
		player="You will cooperate with us or you will be destroyed.",
		alien={"<Silence>"} }
	statements[5] = {
		action="terminate",
		player="We are prepared to spare you if you comply with our demands.",
		alien={"<Silence>"} }
	statements[6] = {
		action="terminate",
		player="Prepare yourselves for dissolution, alien scum dogs.",
		alien={"<Silence>"} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	
	questions[10000] = {
		action="jump", goto=11000,
		player="What can you tell us about...",
		alien={"By the agreement of 17439 one is warned not to interfere in Minex affairs or encroach upon our territory."}
	}
	
	questions[11000] = {
		action="terminate",
		player="But would you consider...",
		alien={"By the agreement of 17439 one is warned not to interfere in Minex affairs or encroach upon our territory."}
	}


end

------------------------------------------------------------------------
-- SCRIPT INITIALIZATION -----------------------------------------------
------------------------------------------------------------------------
function Initialize()
    -- COMBAT VALUES FOR THIS ALIEN RACE
    health = 100                    -- 100=baseline minimum
    mass = 10                       -- 1=tiny, 10=huge
	engineclass = 6
	shieldclass = 6
	armorclass = 6
	laserclass = 6
	missileclass = 6
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 25			-- % of damage received, used for racial abilities, 0-100%


	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in

	-- 21 Minex Golden Sphere
	-- 22 Minex Bladed Apparatus
	-- 23 Minex Silver Gadget
	
	DROPITEM1 = 21;	    DROPRATE1 = 90;		DROPQTY1 = 1
	DROPITEM2 = 22;		DROPRATE2 = 90;	    DROPQTY2 = 1
	DROPITEM3 = 23;		DROPRATE3 = 90;		DROPQTY3 = 1
	DROPITEM4 = 53;		DROPRATE4 = 0;		DROPQTY4 = 2
	DROPITEM5 = 54;		DROPRATE5 = 20;		DROPQTY5 = 10

	--initialize dialog
	first_question = 1
	starting_attitude = 100
	starting_posture = "obsequious"
	current_question = first_question
	next_question = first_question

	--initialize globals as needed
	if ATTITUDE == nil then ATTITUDE = starting_attitude end
	if POSTURE == nil then POSTURE = starting_posture end

	--special consideration for attitudes
	if ATTITUDE < 10 then
	    ACTION = "attack"
	    RESPONSE = "No more warnings will be given."
	    --return
	end
	
	if player_profession == "military" and active_quest == 34 then
		ACTION = "attack"
	elseif player_profession == "military" and active_quest == 35 then
		ACTION = "attack"
	elseif player_profession == "freelance" and active_quest == 33 then
		ACTION = "attack"
	end


	--initialize dialogue tables
	greetings = {}
	statements = {}
	questions = {}

	--initialize root categories
	questions[1] = {
		action="branch",
		choices = {
			{ text="YOURSELVES", goto=10000 },
			{ text="OTHER RACES", goto=10000 },
			{ text="THE PAST", goto=10000 },
			{ text="THE ANCIENTS", goto=10000 },
			{ text="GENERAL INFO", goto=10000 }
		}
	}


	--load dialogue based on posture
	if POSTURE == "obsequious" then
		ObsequiousDialogue()
	elseif POSTURE == "hostile" then
		HostileDialogue()
	else
		FriendlyDialogue()
	end
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

