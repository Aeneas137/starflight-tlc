--[[
	ENCOUNTER SCRIPT FILE: COALITION  VIRUS

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
		alien={"We are the ancient and mighty Uhlek.  Bow and pay us homage!  Snicker, snicker.","We ain't your father's Bar-zhon.","Us is stupid alien the most delightful.  Now it is the message leave at the beep."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"We are the ancient and mighty Uhlek.  Bow and pay us homage!  Snicker, snicker.","We ain't your father's Bar-zhon.","Us is stupid alien the most delightful.  Now it is the message leave at the beep."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"We are the ancient and mighty Uhlek.  Bow and pay us homage!  Snicker, snicker.","We ain't your father's Bar-zhon.","Us is stupid alien the most delightful.  Now it is the message leave at the beep."} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"We are the ancient and mighty Uhlek.  Bow and pay us homage!  Snicker, snicker.","We ain't your father's Bar-zhon.","Us is stupid alien the most delightful.  Now it is the message leave at the beep."} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"We are the ancient and mighty Uhlek.  Bow and pay us homage!  Snicker, snicker.","We ain't your father's Bar-zhon.","Us is stupid alien the most delightful.  Now it is the message leave at the beep."} }
		
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
		
	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=60000,
		player="What can you tell us about yourselves?",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[20000] = {
		action="jump", goto=60000,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[30000] = {
		action="jump", goto=60000,
		player="What can you tell us about the past?",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[40000] = {
		action="jump", goto=60000,
		player="Tell us about the Ancients.",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[50000] = {
		action="jump", goto=60000,
		player="Tell us about..",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[60000] = {
		action="branch",
		choices = {
			{ text="Yes, we surrender.",  goto=60001 },
			{ text="No, we will not surrender!",  goto=60002 }
		}
	}
 
	questions[60001] = {
		action="attack",
		player="",
		alien={"Lower your shields and disarm any weapons and hold perfectly still for a minute, will ya?"}
	}
	questions[60002] = {
		action="attack",
		player="",
		alien={"Have at 'em mate!"}
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
		alien={"Greetings from your friendly terrorist cell.  We rarely come in peace, and even more rarely go in pieces."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"This is Captain anonymous of the transport warship anonymous.  You won't be going now."} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Hi yourself, we're not."} }
	greetings[4] = {
		action="",
		player="Dude, that is one odd ship you have there!",
		alien={"Why thank you very much.  It is my own custom model transport freighter outfitted with afterburners and state-of-the-art weaponry just ready to slice and dice and even make julian fries."} }
	greetings[5] = {
		action="",
		player="How's it going, umm ... aren't you Bar-zhon?",
		alien={"Nope."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"Why thank you kind sir or madame.  Your ship doesn't."} }
	statements[2] = {
		action="",
		player="Your ship appears very irregular.",
		alien={"Why thank you very much.  It is my own custom model transport freighter outfitted with afterburners and state-of-the-art weaponry just ready to slice and dice and even make julian fries."} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"Oh we believe you, believe me that we believe you."} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"I would wholeheartedly agree, as long as to exchange is kept in our direction."} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"How did you come up with a whopper like that one?"} }
		 



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 
	questions[10000] = {
		action="jump", goto=60000,
		player="What can you tell us about yourselves?",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[20000] = {
		action="jump", goto=60000,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[30000] = {
		action="jump", goto=60000,
		player="What can you tell us about the past?",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[40000] = {
		action="jump", goto=60000,
		player="Tell us about the Ancients.",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[50000] = {
		action="jump", goto=60000,
		player="Tell us about..",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[60000] = {
		action="branch",
		choices = {
			{ text="Yes, we surrender.",  goto=60001 },
			{ text="No, we will not surrender!",  goto=60002 }
		}
	}
 
	questions[60001] = {
		action="attack",
		player="",
		alien={"Lower your shields and disarm any weapons and hold perfectly still for a minute, will ya?"}
	}
	questions[60002] = {
		action="attack",
		player="",
		alien={"Have at 'em mate!"}
	}

end

------------------------------------------------------------------------
-- HOSTILE DIALOGUE ----------------------------------------------------
------------------------------------------------------------------------
function HostileDialogue()
	--add as many player greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack
	greetings[1] = {
		action="attack",
		player="This is captain [CAPTAIN] of the starship [SHIPNAME]. Identify yourselves immediately or be destroyed.",
		alien={"Not likely, on either count."} }
	greetings[2] = {
		action="attack",
		player="This is the starship [SHIPNAME]. We are heavily armed.",
		alien={"So are we."}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"Not just a spaceship, but a starship now is it..."} }
	greetings[4] = {
		action="attack",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"No we won't"} }
	greetings[5] = {
		action="attack",
		player="We require information. Comply or be destroyed.",
		alien={"We will not comply, but we will gladly perform the destroying."} }
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="attack",
		player="Your ship is over-embellished and weak.",
		alien={"Over embellished, maybe.  Weak, never.  Here, let me demonstrate."} }
	statements[2] = {
		action="attack",
		player="What an ugly and worthless creature.",
		alien={"I'm sorry I can't seem to hear you.  Please boost your gain knob.  Nevermind, we'll just get closer and call you right back."} }
	statements[3] = {
		action="attack",
		player="Your ship looks like a flying garbage scow.",
		alien={"Incredible!  How could I have not noticed this?  Unfortunately our cargo bays are empty of garbage.  If you would not mind, we would greatly appreciate it if you could scrap your ship for us to haul.."} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
		questions[10000] = {
		action="jump", goto=60000,
		player="What can you tell us about yourselves?",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[20000] = {
		action="jump", goto=60000,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[30000] = {
		action="jump", goto=60000,
		player="What can you tell us about the past?",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[40000] = {
		action="jump", goto=60000,
		player="Tell us about the Ancients.",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[50000] = {
		action="jump", goto=60000,
		player="Tell us about..",
		alien={"Nothing right now.  Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[60000] = {
		action="branch",
		choices = {
			{ text="Yes, we surrender.",  goto=60001 },
			{ text="No, we will not surrender!",  goto=60002 }
		}
	}
 
	questions[60001] = {
		action="attack",
		player="",
		alien={"Lower your shields and disarm any weapons and hold perfectly still for a minute, will ya?"}
	}
	questions[60002] = {
		action="attack",
		player="",
		alien={"Have at 'em mate!"}
	}

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
		action="branch",
		choices = {
			{ text="YOURSELVES", goto=10000 },
			{ text="OTHER RACES", goto=20000 },
			{ text="THE PAST", goto=30000 },
			{ text="THE ANCIENTS", goto=40000 },
			{ text="GENERAL INFO", goto = 50000 }
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

