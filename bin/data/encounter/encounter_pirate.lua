--[[------------------------------------------------------------------------------------------------------------------------------------------------- ]
	ENCOUNTER SCRIPT FILE: PIRATE

	Last Modified:  December 22, 2009

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

function SetPlayerTables()
	playerStatement= {
		obsequious= {
			remark= {
				alien= {
					"Greetings and felicitations oh kind and merciful alien.",
					"We can see that you are indeed the true race.",
					"Take pity on us who are not fit to grovel in your waste products.",
				}
			},
			comment= {
				trust= {
					"We bask in the glow of your races noble presence.",
				},
				info_exchange= {
					"Pray enlighten us with your gems of infinite wisdom.",
					"We want to bathe in your ever spewing fountain of knowledge.",
				}
			},
			plea= {
				"Please do not harm us oh most high and mighty.",
				"We truly are not worth your trouble to destroy.",
				"Please do not blast us into atomic particles.",
				"We understand that you could destroy us if you chose. I beg you not to do this.",
			}
		},

		friendly= {
			comment= {
				trust= {
					"We come in peace from Myrrdan, please trust me.",
					"Our goal is to strengthen the relationship between our peoples.",
					"Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
				},
				info_exchange= {
					"There is no limit to what both our races can gain from mutual exchange.",
					"We look forward to discussion of our respective histories.",
				}
			},
			remark= {
				ship= {
					"Your ship appears very irregular.",
					"Your ship seems to be very elaborate.",
					"Your ship seems to be very powerful.",
				},
				alien= {
					"It is a pleasure to speak with a friendly race such as yours.",
					"The [ALIEN] show both wisdom and discretion."
				}
			}
		},

		hostile= {
			comment= {
				general= {
					"We suggest you comply with our demands.",
					"You are making a tragic mistake.",
					"Resistance is futile. All your resources is belong to us!"
				},
				info_exchange= {
					"We demand you supply us with information.",
				}
			},
			remark= {
				ship= {
					"Your ship looks like a flying garbage scow.",
					"So, do you use tinfoil in all your ship designs?",
					"Your ship will look less aesthetically pleasing with laser burns on its hull.",
					"It's surprising to see a ship like yours anywhere outside a shipyard- or junk pile.",
					"Your ship is over-embellished and weak."
				},
				alien= {
					"What an ugly and worthless creature.",
					"The [ALIEN] are vile and weak.",
					"Your worthless race is beneath contempt."
				}
			},
			surrender_demand= {
				"Lower your shields and surrender, or face the consequences!",
				"We require immediate compliance: surrender!",
				"We will destroy you unless you submit to our demands."
			},
		},
	}

	preQuestion= {
		info= {
			obsequious= {
				"We beg you to honor our poor selves and bestow upon us a pearl of wisdom",
				"We humbly suggest that we would be interested in any little thing you might wish to tell us",
				"Mighty [ALIEN], take pity on us ignorant wretches and tell us",
			},
			friendly= {
				"Do you have any information you can share with us",
				"We would greatly appreciate some information",
				"Is there anything you can tell us",
				"We are interested in information",
				"Would you please tell us",
			},
			hostile= {
				"We require information",
				"You will tell us",
				"Our laser batteries are fully charged. I suggest you tell us",
				"Our tactical officer has a twitchy trigger finger. Give us information",
			},
		},
		desire= {
			obsequious= {
				"Noble and wise [ALIEN], take pity on our ignorant race and trade us",
			},
			friendly= {
				"We would sincerely appreciate it if you could trade us",
				"Would it be possible for you to trade us",
				"Can you trade us",
			},
			hostile= {
				"If you do not wish for some laser burns on your ship's hull, I suggest you give us",
				"We demand that you immediately hand over to us",
			},
		},
	}
end
------------------------------------------------------------------------
-- OBSEQUIOUS DIALOGUE -------------------------------------------------
------------------------------------------------------------------------
function ObsequiousDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack


if (plot_stage == 1) then -- initial plot state

	GreetTable= {
		"Your ship looks like it will bring a few credits.",
		"Let's negotiate. Drop shields, disarm weapons, close your eyes and count to 50..er..100.",
		"Our communication system is overloaded so please wait a minute.",
		"From hunter to hunted, prepare to die.",
		"Nice ship! I'll take it!",
		"We're taking your ship. Jump out in your escape pods and we might let you live."
	}

elseif (plot_stage == 2) then -- virus plot state

	GreetTable= {
		"Your ship looks like it will bring a few credits.",
		"Let's negotiate.  Drop shields, disarm weapons, close your eyes and count to 50..err..100.",
		"01111 001 1011 111, 00111 1010 111 10 1 010 111 0100, 00011 0010 111 1010 001 000, 00001 0100 111 1010 01 1 0 100, 00000, 10000",
		"From hunter to hunted, prepare to die.",
		"We're taking your ship. Jump out in your escape pods and we might let you live."
	}


elseif (plot_stage == 3) then -- war plot state

	GreetTable= {
		"Your ship looks like it will bring a few credits.",
		"Twas brillig, and the slithy toves, Did gyre and gimble in the wabe, All mimsy were the borogoves, And the mome raths outgrabe.",
		"01111 001 1011 111, 00111 1010 111 10 1 010 111 0100, 00011 0010 111 1010 001 000, 00001 0100 111 1010 01 1 0 100, 00000, 10000",
		"We're taking your ship. Jump out in your escape pods and we might let you live."
	}


elseif (plot_stage == 4) then -- ancients plot state

	GreetTable= {
	"Inexemay!  Inexemay!  Inexemay!",
	"Twas brillig, and the slithy toves, Did gyre and gimble in the wabe, All mimsy were the borogoves, And the mome raths outgrabe.",
	"01111 001 1011 111, 00111 1010 111 10 1 010 111 0100, 00011 0010 111 1010 001 000, 00001 0100 111 1010 01 1 0 100, 00000, 10000"
	}


end

	greetings[1] = {
		action="attack",
		player="Hail oh mighty ones, masters of the universe.",
		alien= 	GreetTable }
	greetings[2] = {
		action="attack",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien= 	GreetTable }
	greetings[3] = {
		action="attack",
		player="Greetings oh highest of the high most great alien beings.",
		alien= 	GreetTable }
	greetings[4] = {
		action="attack",
		player="We respectfully request that you identify your vastly superior selves.",
		alien= 	GreetTable }
	greetings[5] = {
		action="attack",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien= 	GreetTable }
	greetings[6] = {
		action="attack",
		player="Please do not harm us oh most high and mighty.",
		alien= GreetTable }
	greetings[7] = {
		action="attack",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien= GreetTable }
	greetings[8] = {
		action="attack",
		player="Please do not blast us into atomic particles.  Take pity on us who are not fit to grovel in your waste products.",
		alien= GreetTable }
	greetings[9] = {
		action="attack",
		player="We can see that you are indeed the true race.  Pray enlighten us with your gems of infinite wisdom.",
		alien= GreetTable }
	greetings[10] = {
		action="attack",
		player="We truly are not worth your trouble to destroy.",
		alien= GreetTable }
	greetings[11] = {
		action="attack",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien= GreetTable }
	greetings[12] = {
		action="attack",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien= GreetTable }


end

------------------------------------------------------------------------
-- FRIENDLY DIALOGUE ---------------------------------------------------
------------------------------------------------------------------------
function FriendlyDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack

if (plot_stage == 1) then -- initial plot state

	GreetTable= {
		"Your ship looks like it will bring a few credits.",
		"Let's negotiate. Drop shields, disarm weapons, close your eyes and count to 50..er..100.",
		"Our communication system is overloaded so please wait a minute.",
		"From hunter to hunted, prepare to die.",
		"Nice ship! I'll take it!",
		"We're taking your ship. Jump out in your escape pods and we might let you live."
	}

elseif (plot_stage == 2) then -- virus plot state

	GreetTable= {
		"Your ship looks like it will bring a few credits.",
		"Let's negotiate.  Drop shields, disarm weapons, close your eyes and count to 50..err..100.",
		"01111 001 1011 111, 00111 1010 111 10 1 010 111 0100, 00011 0010 111 1010 001 000, 00001 0100 111 1010 01 1 0 100, 00000, 10000",
		"From hunter to hunted, prepare to die.",
		"We're taking your ship. Jump out in your escape pods and we might let you live."
	}


elseif (plot_stage == 3) then -- war plot state

	GreetTable= {
		"Your ship looks like it will bring a few credits.",
		"Twas brillig, and the slithy toves, Did gyre and gimble in the wabe, All mimsy were the borogoves, And the mome raths outgrabe.",
		"01111 001 1011 111, 00111 1010 111 10 1 010 111 0100, 00011 0010 111 1010 001 000, 00001 0100 111 1010 01 1 0 100, 00000, 10000",
		"We're taking your ship. Jump out in your escape pods and we might let you live."
	}


elseif (plot_stage == 4) then -- ancients plot state

	GreetTable= {
	"Inexemay!  Inexemay!  Inexemay!",
	"Twas brillig, and the slithy toves, Did gyre and gimble in the wabe, All mimsy were the borogoves, And the mome raths outgrabe.",
	"01111 001 1011 111, 00111 1010 111 10 1 010 111 0100, 00011 0010 111 1010 001 000, 00001 0100 111 1010 01 1 0 100, 00000, 10000"
	}


end

	greetings[1] = {
		action="attack",
		player="Greetings from the planet Myrrdan. We come in peace...usually.",
		alien= GreetTable }
	greetings[2] = {
		action="attack",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien= GreetTable }
	greetings[3] = {
		action="attack",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien= GreetTable }
	greetings[4] = {
		action="attack",
		player="Greetings.  Your ship seems to be very powerful.",
		alien= GreetTable }
	greetings[5] = {
		action="attack",
		player="Hello there.  Your ship appears very unusual.",
		alien= GreetTable }
	greetings[6] = {
		action="attack",
		player="We come in peace from Myrrdan, please trust me.",
		alien= GreetTable }
	greetings[7] = {
		action="attack",
		player="Greetings friend!  There is no limit to what both our races can gain from mutual exchange.",
		alien= GreetTable }
	greetings[8] = {
		action="attack",
		player="Perhaps some day our young shall play and romp together...uhh...nevermind...let us be friends.",
		alien= GreetTable }



end

------------------------------------------------------------------------
-- HOSTILE DIALOGUE ----------------------------------------------------
------------------------------------------------------------------------
function HostileDialogue()
	--add as many player greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack

if (plot_stage == 1) then -- initial plot state

	GreetTable= {
		"Your ship looks like it will bring a few credits.",
		"Let's negotiate. Drop shields, disarm weapons, close your eyes and count to 50..er..100.",
		"Our communication system is overloaded so please wait a minute.",
		"From hunter to hunted, prepare to die.",
		"Nice ship! I'll take it!",
		"We're taking your ship. Jump out in your escape pods and we might let you live."
	}

elseif (plot_stage == 2) then -- virus plot state

	GreetTable= {
		"Your ship looks like it will bring a few credits.",
		"Let's negotiate.  Drop shields, disarm weapons, close your eyes and count to 50..err..100.",
		"01111 001 1011 111, 00111 1010 111 10 1 010 111 0100, 00011 0010 111 1010 001 000, 00001 0100 111 1010 01 1 0 100, 00000, 10000",
		"From hunter to hunted, prepare to die.",
		"We're taking your ship. Jump out in your escape pods and we might let you live."
	}


elseif (plot_stage == 3) then -- war plot state

	GreetTable= {
		"Your ship looks like it will bring a few credits.",
		"Twas brillig, and the slithy toves, Did gyre and gimble in the wabe, All mimsy were the borogoves, And the mome raths outgrabe.",
		"01111 001 1011 111, 00111 1010 111 10 1 010 111 0100, 00011 0010 111 1010 001 000, 00001 0100 111 1010 01 1 0 100, 00000, 10000",
		"We're taking your ship. Jump out in your escape pods and we might let you live."
	}


elseif (plot_stage == 4) then -- ancients plot state

	GreetTable= {
	"Inexemay!  Inexemay!  Inexemay!",
	"Twas brillig, and the slithy toves, Did gyre and gimble in the wabe, All mimsy were the borogoves, And the mome raths outgrabe.",
	"01111 001 1011 111, 00111 1010 111 10 1 010 111 0100, 00011 0010 111 1010 001 000, 00001 0100 111 1010 01 1 0 100, 00000, 10000"
	}


end


	greetings[1] = {
		action="attack", ftest= 1,
		player="This is captain [CAPTAIN] of the starship [SHIPNAME]. Identify yourselves immediately or be destroyed.",
		alien= GreetTable }
	greetings[2] = {
		action="attack", ftest= 1,
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien= GreetTable }
	greetings[3] = {
		action="attack", ftest= 1,
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien= GreetTable }
	greetings[4] = {
		action="attack", ftest= 1,
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien= GreetTable }
	greetings[5] = {
		action="attack", ftest= 1,
		player="We require information. Comply or be destroyed.",
		alien= GreetTable }
	greetings[6] = {
		action="attack",
		player="Your ship is simple and weak.",
		alien= GreetTable }
	greetings[7] = {
		action="attack",
		player="Your ship looks like a flying garbage scow.",
		alien= GreetTable }


end

function StandardQuestions()

	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"Should never be seen"}
	}
	questions[20000] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Should never be seen"}
	}
	questions[30000] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"Should never be seen"}
	}
	questions[40000] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"Should never be seen" }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Should never be seen",  goto=1 }
		}
	}


end




function QuestDialogue()


end


--[[ -------------------------------------------------------------------
--Randomized ship characteristics, 1st pass:
----------------------------------------------------------------------]]
function GenerateShips()

    -- COMBAT VALUES FOR THIS ALIEN RACE
--[[
    health = 100                    -- 100=baseline minimum
    mass = 2                        -- 1=tiny, 10=huge
	engineclass = 1
	shieldclass = 1
	armorclass = 2
	laserclass = 2
	missileclass = 0
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%
--]]

if (plot_stage == 1) then  -- initial plot stage

	health= gen_random(100)
	if (health < 10) then							health= 10							end

	mass= 2

	-- If the player's ship is fast, the alien ships are always just as fast. This applies to most Minex systems
	engineclass= gen_random(2)
	if (engineclass < 1) then						engineclass= 1						end
	if (engineclass < ship_engine_class) then		engineclass= ship_engine_class		end

	shieldclass= gen_random(3)
	if (shieldclass < 1) then						shieldclass= 1						end

	armorclass= gen_random(2)
	if (armorclass < 1) then						armorclass= 1						end

	laserclass= gen_random(2)
	if (laserclass < 1) then						laserclass= 1						end
	-- Improves the enemy ships laser class to at least four levels below the player's laser class
	if (laserclass < (ship_laser_class -4)) then	laserclass= (ship_laser_class -4)   end


	missileclass= gen_random(1)
	if (missileclass < (ship_missile_class -4)) then missileclass= (ship_missile_class -4) end

	laser_modifier= 100

	missile_modifier= gen_random(100)
	if (missile_modifier < 40) then 				missile_modifier= 40				end


elseif (plot_stage == 2) then -- virus plot state

	health= gen_random(100)
	if (health < 40) then							health= 40							end

	mass= 4

	engineclass= gen_random(2)
	if (engineclass < 1) then						engineclass= 1						end
	if (engineclass < ship_engine_class) then		engineclass= ship_engine_class		end

	shieldclass= gen_random(4)
	if (shieldclass < 1) then						shieldclass= 1						end

	armorclass= gen_random(2)
	if (armorclass < 1) then						armorclass= 1						end

	laserclass= gen_random(3)
	if (laserclass < 1) then						laserclass= 1						end
	if (laserclass < (ship_laser_class -4)) then	laserclass= (ship_laser_class -4)   end

	missileclass= gen_random(3)
	if (missileclass < (ship_missile_class -2)) then	missileclass= (ship_missile_class -2) end

	laser_modifier= 100

	missile_modifier= gen_random(100)
	if (missile_modifier < 40) then 				missile_modifier= 40				end


elseif (plot_stage == 3) or (plot_stage == 4) then -- war and ancients plot states

	health= gen_random(100)
	if (health < 70) then							health= 70							end

	mass= 6

	engineclass= gen_random(2)
	if (engineclass < 1) then						engineclass= 1						end
	if (engineclass < ship_engine_class) then		engineclass= ship_engine_class		end

	shieldclass= gen_random(4)
	if (shieldclass < 1) then						shieldclass= 1						end

	armorclass= gen_random(5)
	if (armorclass < 1) then						armorclass= 1						end

	laserclass= gen_random(6)
	if (laserclass < 1) then						laserclass= 1						end
	if (laserclass < (ship_laser_class -1)) then	laserclass= (ship_laser_class -1)   end


	missileclass= gen_random(6)
	if (missileclass < (ship_missile_class -1)) then	missileclass= (ship_missile_class -1) end

	laser_modifier= 50

	missile_modifier= gen_random(100)
	if (missile_modifier < 0) then 				missile_modifier= 0				end

end

end

------------------------------------------------------------------------
-- SCRIPT INITIALIZATION - CALLED ONCE AT STARTUP
------------------------------------------------------------------------
function Initialize()


	GenerateShips()		--Build aien ships.
	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in


if (plot_stage == 1) then -- initial plot state

	DROPITEM1 = 8;	    DROPRATE1 = 80;		DROPQTY1 = 1 -- pirate cargo
	DROPITEM2 = 9;		DROPRATE2 = 72;	    DROPQTY2 = 1 -- pirate small arms
	DROPITEM3 = 31;		DROPRATE3 = 25;		DROPQTY3 = 4
	DROPITEM4 = 33;		DROPRATE4 = 50;		DROPQTY4 = 5
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 3 -- Endurium

elseif (plot_stage == 2) then -- virus plot state

	DROPITEM1 = 231;	DROPRATE1 = 80;		DROPQTY1 = 1 -- Pirate genetic material
	DROPITEM2 = 9;		DROPRATE2 = 86;	    DROPQTY2 = 1 -- pirate small arms
	DROPITEM3 = 31;		DROPRATE3 = 25;		DROPQTY3 = 4
	DROPITEM4 = 33;		DROPRATE4 = 50;		DROPQTY4 = 5
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 3 -- Endurium

elseif (plot_stage == 3) then -- war plot state

	DROPITEM1 = 8;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- pirate cargo
	DROPITEM2 = 9;		DROPRATE2 = 86;	    DROPQTY2 = 1 -- pirate small arms
	DROPITEM3 = 31;		DROPRATE3 = 25;		DROPQTY3 = 4
	DROPITEM4 = 33;		DROPRATE4 = 50;		DROPQTY4 = 5
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 3 -- Endurium

elseif (plot_stage == 4) then -- ancients plot state

	DROPITEM1 = 8;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- pirate cargo
	DROPITEM2 = 9;		DROPRATE2 = 86;	    DROPQTY2 = 1 -- pirate small arms
	DROPITEM3 = 31;		DROPRATE3 = 25;		DROPQTY3 = 4
	DROPITEM4 = 33;		DROPRATE4 = 50;		DROPQTY4 = 5
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 3 -- Endurium

end


	SetPlayerTables()

	FTEST= -1	--FTEST is used to activate the commFxn, for decision making during conversations.


	--active_quest = 29	--  debugging use
	--artifact20 = 1		--  debugging use

	--initialize dialog
	first_question = 1

	starting_attitude = 100
	starting_posture = "obsequious"
	current_question = first_question
	next_question = first_question

	--initialize globals as needed
	if ATTITUDE == nil then ATTITUDE = starting_attitude end
	if POSTURE == nil then POSTURE = starting_posture end
	orig_posture= POSTURE

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


	StandardQuestions() -- load questions
	QuestDialogue()	--load the quest-related dialog.

	orig_posture= "n/a"
	UpdatePosture()

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

--[[ The communications function makes more involved decisions on what to do
	 based on type of communication (0: greeting,  1: statement,  2: question),
	 the ftest value passed back from the table (must be >= 1 for commFxn to be
	 invoked at all), and the question/statement number, n. Other variables
	 pulled in as needed from the script; in Lua everything is global unless
	 explicitly declared local. 											--]]
function commFxn(type, n, ftest)

	--player_money= player_money -900 --(test)
	if (type == 0) then							--greeting
		if (POSTURE == "friendly") then
			ATTITUDE = ATTITUDE + 0
		elseif (POSTURE == "obsequious") then
			ATTITUDE = ATTITUDE + 6
		elseif (POSTURE == "hostile") then
			ATTITUDE = ATTITUDE - 6
		end

	elseif (ftest == 4) then   --  Terminating question
		L_Terminate()
		return
	elseif (ftest == 5) then   --  Attack the player question
		L_Attack()
		return

	elseif (ATTITUDE < 10 and number_of_actions > 2) then
		goto_question = 910 -- alien attacks the player if attitude drops too low
		number_of_actions = 0

	elseif (ATTITUDE < 51 and number_of_actions > 4) then
		goto_question = 920 -- jump to hostile termination question
		number_of_actions = 0

	elseif (ATTITUDE < 70 and number_of_actions > 8) then
		goto_question = 930  -- jump to neutral termination question
		number_of_actions = 0

	elseif (number_of_actions > 13) then
		goto_question = 940  -- jump to friendly termination question
		number_of_actions = 0

	elseif (ftest < 1) then
		return

	else											--question
		if (n == 10000) or (n == 20000) or (n == 30000) or (n == 40000) then  -- General adjustment every time a category is started
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE + 2
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 2
			end
		elseif (ftest == 2) then  --  Insightful question
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE + 3
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 1
			end
		elseif (ftest == 3) then   --  Aggravating question
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE - 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE - 1
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 3
			end
		end
	end
end
