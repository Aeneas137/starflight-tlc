--[[
	ENCOUNTER SCRIPT FILE: THRYNN VIRUS

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
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."} }


		
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="attack",
		player="Please do not harm us oh most high and mighty.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[2] = {
		action="attack",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[3] = {
		action="attack",
		player="Please do not blast us into atomic particles.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[4] = {
		action="attack",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[5] = {
		action="attack",
		player="We can see that you are indeed the true race.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[6] = {
		action="attack",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[7] = {
		action="attack",
		player="We truly are not worth your trouble to destroy.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[8] = {
		action="attack",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[9] = {
		action="attack",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
		
	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD


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
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."} }
	greetings[4] = {
		action="",
		player="Dude, that is one crazy powerful ship you have there!",
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."} }
	greetings[5] = {
		action="",
		player="How's it going, lizard guys?",
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="attack",
		player="Your ship seems to be very powerful.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[2] = {
		action="attack",
		player="Your ship appears very elaborate.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[3] = {
		action="attack",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[4] = {
		action="attack",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[5] = {
		action="attack",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
		 



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 

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
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."} }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."} }
	greetings[4] = {
		action="",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."} }
	greetings[5] = {
		action="",
		player="We require information. Comply or be destroyed.",
		alien={"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."} }
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="attack",
		player="Your ship is simple and weak.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[2] = {
		action="attack",
		player="What an sorry excuse for a misshapen creature.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }
	statements[3] = {
		action="attack",
		player="Your ship looks like a flying garbage scow.",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart."} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	


end

------------------------------------------------------------------------
-- SCRIPT INITIALIZATION -----------------------------------------------
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
	DROPITEM1 = 31;	    DROPRATE1 = 97;		DROPQTY1 = 1
	DROPITEM2 = 31;		DROPRATE2 = 90;	    DROPQTY2 = 1
	DROPITEM3 = 31;		DROPRATE3 = 25;		DROPQTY3 = 1
	DROPITEM4 = 31;		DROPRATE4 = 50;		DROPQTY4 = 1
	DROPITEM5 = 31;		DROPRATE5 = 80;		DROPQTY5 = 1


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
	    RESPONSE = "Die you vile murderous human!"
	    --return
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

