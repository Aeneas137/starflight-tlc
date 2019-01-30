--[[
	ENCOUNTER SCRIPT FILE: SPEMIN  ANCIENTS

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
		player="Hail oh mighty ones, Masters of the universe.",
		alien={"<Silence>"} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"<Silence>"} 	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"<Silence>"} 	}
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"<Silence>"} 	}
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"<Silence>"} 	}


		
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
		
	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=50001,
		player="What can you tell...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[20000] = {
		action="jump", goto=50001,
		player="What can you tell...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[30000] = {
		action="jump", goto=50001,
		player="Tell us about...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[40000] = {
		action="jump", goto=40001,
		player="Tell us about the Ancients.",
		alien={"The In'tral'ess remain dormant.  We detect no action." }
	}
	questions[40001] = {
			action="branch",
			choices = {
				{ text="You are not acting like Spemin.", goto=41000 },
				{ text="Who are the In'tral'ess?", goto=42000 },
				{ text="Why do the In'tral'ess remaine dormant?", goto=43000 },
				{ text="What actions would they take?", goto=44000 },
				{ text="<Back>", goto=1 }
			}
		}
		questions[41000] = {
			action="jump", goto=50001,
			player="",
			alien={"We are the Tri'na'li'da.  Why do you not respond?" }
		}
		questions[42000] = {
			action="jump", goto=42001,
			player="",
			alien={"Crystal ones.  Ancients.  Knowledge association with Endurium.  You need not fear them nor their servants.  Both are inactive." }
		}
		questions[42001] = {
			action="jump", goto=40001,
			player="Who are their servants?",
			alien={"You need not fear them.  Both are inactive." }
		}
		questions[43000] = {
			action="jump", goto=40001,
			player="",
			alien={"You need not fear them.  Both are inactive." }
		}
		questions[44000] = {
			action="jump", goto=44001,
			player="",
			alien={"Scanning for appropriate analogy.  We scan for telepathy.  Both are inactive." }
		}
		questions[44001] = {
			action="jump", goto=40001,
			player="Who do you scan for telepathy?",
			alien={"Crystal ones.  Servants.  You need not fear them.  Both are inactive." }
		}

	questions[50000] = {
		action="jump", goto=50001,
		player="Tell us about...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[50001] = {
		action="branch",
		choices = {
			{ text="Aren't you Spemin?",  goto=51000 },
			{ text="Who are the Tri'na'li'da?", goto=52000 },
			{ text="Don't you us talking to you now?", goto=53000 },
			{ text="What do you want?", goto=54000 },
		}
	}
 	questions[51000] = {
		action="jump", goto=51001,
		player="",
		alien={"Refinement of this biological communication node makes your identification possible."}
	}
 	questions[51001] = {
		action="jump", goto=50001,
		player="Identify us as who?  What node?  What are you?",
		alien={"Masters.  Spemin.  Tri'na'li'da"}
	}	
	 questions[52000] = {
		action="jump", goto=52001,
		player="",
		alien={"Your servants for creating hybrid nodes.  We await networking."}
	}
	questions[52001] = {
		action="jump", goto=52003,
		player="Hybrid nodes?  Networking?",
		alien={"Hybrid nodes are alien flesh adapted to receive instructions.  Networking is telepathic linkup with Masters."}
	}
	questions[52003] = {
		action="jump", goto=52004,
		player="Do you mean you are the virus?",
		alien={"Tes.  Adequate analogy."}
	}
	questions[52004] = {
		action="terminate",
		player="I command you to stop infecting alien races!",
		alien={"Networking required before instructions are received.  Verbal exchange inaccurate."}
	}
	questions[53000] = {
		action="jump", goto=52001,
		player="",
		alien={"Inaccurate verbal exchange with hybrid node.  Networking is required.  Please respond."}
	}
 	questions[54000] = {
		action="terminate",
		player="",
		alien={"Imperative to neutralize crystal ones at Bec-Felmas 3 - 16,183 or Mathgen 4 - 212,3.  Phlegmak devices recommended."}
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
		alien={"<Silence>"} 	}
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"<Silence>"} 	}
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"<Silence>"} 	}
	greetings[4] = {
		action="",
		player="Dude, that is one funky ship you have there!",
		alien={"<Silence>"} 	}
	greetings[5] = {
		action="",
		player="How's it going, blob thing?",
		alien={"<Silence>"} 	}

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[2] = {
		action="",
		player="Your ship appears very simple yet functional.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together...uhh...nevermind...let us be friends.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
		 



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 
	questions[10000] = {
		action="jump", goto=50001,
		player="What can you tell...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[20000] = {
		action="jump", goto=50001,
		player="What can you tell...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[30000] = {
		action="jump", goto=50001,
		player="Tell us about...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[40000] = {
		action="jump", goto=40001,
		player="Tell us about the Ancients.",
		alien={"The In'tral'ess remain dormant.  We detect no action." }
	}
	questions[40001] = {
			action="branch",
			choices = {
				{ text="You are not acting like Spemin.", goto=41000 },
				{ text="Who are the In'tral'ess?", goto=42000 },
				{ text="Why do the In'tral'ess remaine dormant?", goto=43000 },
				{ text="What actions would they take?", goto=44000 },
				{ text="<Back>", goto=1 }
			}
		}
		questions[41000] = {
			action="jump", goto=50001,
			player="",
			alien={"We are the Tri'na'li'da.  Why do you not respond?" }
		}
		questions[42000] = {
			action="jump", goto=42001,
			player="",
			alien={"Crystal ones.  Ancients.  Knowledge association with Endurium.  You need not fear them nor their servants.  Both are inactive." }
		}
		questions[42001] = {
			action="jump", goto=40001,
			player="Who are their servants?",
			alien={"You need not fear them.  Both are inactive." }
		}
		questions[43000] = {
			action="jump", goto=40001,
			player="",
			alien={"You need not fear them.  Both are inactive." }
		}
		questions[44000] = {
			action="jump", goto=44001,
			player="",
			alien={"Scanning for appropriate analogy.  We scan for telepathy.  Both are inactive." }
		}
		questions[44001] = {
			action="jump", goto=40001,
			player="Who do you scan for telepathy?",
			alien={"Crystal ones.  Servants.  You need not fear them.  Both are inactive." }
		}

	questions[50000] = {
		action="jump", goto=50001,
		player="Tell us about...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[50001] = {
		action="branch",
		choices = {
			{ text="Aren't you Spemin?",  goto=51000 },
			{ text="Who are the Tri'na'li'da?", goto=52000 },
			{ text="Don't you us talking to you now?", goto=53000 },
			{ text="What do you want?", goto=54000 },
		}
	}
 	questions[51000] = {
		action="jump", goto=51001,
		player="",
		alien={"Refinement of this biological communication node makes your identification possible."}
	}
 	questions[51001] = {
		action="jump", goto=50001,
		player="Identify us as who?  What node?  What are you?",
		alien={"Masters.  Spemin.  Tri'na'li'da"}
	}	
	 questions[52000] = {
		action="jump", goto=52001,
		player="",
		alien={"Your servants for creating hybrid nodes.  We await networking."}
	}
	questions[52001] = {
		action="jump", goto=52003,
		player="Hybrid nodes?  Networking?",
		alien={"Hybrid nodes are alien flesh adapted to receive instructions.  Networking is telepathic linkup with Masters."}
	}
	questions[52003] = {
		action="jump", goto=52004,
		player="Do you mean you are the virus?",
		alien={"Tes.  Adequate analogy."}
	}
	questions[52004] = {
		action="terminate",
		player="I command you to stop infecting alien races!",
		alien={"Networking required before instructions are received.  Verbal exchange inaccurate."}
	}
	questions[53000] = {
		action="jump", goto=52001,
		player="",
		alien={"Inaccurate verbal exchange with hybrid node.  Networking is required.  Please respond."}
	}
 	questions[54000] = {
		action="terminate",
		player="",
		alien={"Imperative to neutralize crystal ones at Bec-Felmas 3 - 16,183 or Mathgen 4 - 212,3.  Phlegmak devices recommended."}
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
		alien={"<Silence>"} 	}
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"<Silence>"} 	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"<Silence>"} 	}
	greetings[4] = {
		action="",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"<Silence>"} 	}
	greetings[5] = {
		action="",
		player="We require information. Comply or be destroyed.",
		alien={"<Silence>"} 	}
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship is simple and weak.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[2] = {
		action="",
		player="What an ugly and worthless creature.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }
	statements[3] = {
		action="",
		player="Your ship looks like a flying garbage doughnut.",
		alien={"kxkxkxkxkxkxkxkxkx","iroiroiroiro","vivivivivi","Ataraxia"} }



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	
	questions[10000] = {
		action="jump", goto=50001,
		player="What can you tell...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[20000] = {
		action="jump", goto=50001,
		player="What can you tell...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[30000] = {
		action="jump", goto=50001,
		player="Tell us about...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[40000] = {
		action="jump", goto=40001,
		player="Tell us about the Ancients.",
		alien={"The In'tral'ess remain dormant.  We detect no action." }
	}
	questions[40001] = {
			action="branch",
			choices = {
				{ text="You are not acting like Spemin.", goto=41000 },
				{ text="Who are the In'tral'ess?", goto=42000 },
				{ text="Why do the In'tral'ess remaine dormant?", goto=43000 },
				{ text="What actions would they take?", goto=44000 },
				{ text="<Back>", goto=1 }
			}
		}
		questions[41000] = {
			action="jump", goto=50001,
			player="",
			alien={"We are the Tri'na'li'da.  Why do you not respond?" }
		}
		questions[42000] = {
			action="jump", goto=42001,
			player="",
			alien={"Crystal ones.  Ancients.  Knowledge association with Endurium.  You need not fear them nor their servants.  Both are inactive." }
		}
		questions[42001] = {
			action="jump", goto=40001,
			player="Who are their servants?",
			alien={"You need not fear them.  Both are inactive." }
		}
		questions[43000] = {
			action="jump", goto=40001,
			player="",
			alien={"You need not fear them.  Both are inactive." }
		}
		questions[44000] = {
			action="jump", goto=44001,
			player="",
			alien={"Scanning for appropriate analogy.  We scan for telepathy.  Both are inactive." }
		}
		questions[44001] = {
			action="jump", goto=40001,
			player="Who do you scan for telepathy?",
			alien={"Crystal ones.  Servants.  You need not fear them.  Both are inactive." }
		}

	questions[50000] = {
		action="jump", goto=50001,
		player="Tell us about...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[50001] = {
		action="branch",
		choices = {
			{ text="Aren't you Spemin?",  goto=51000 },
			{ text="Who are the Tri'na'li'da?", goto=52000 },
			{ text="Don't you us talking to you now?", goto=53000 },
			{ text="What do you want?", goto=54000 },
		}
	}
 	questions[51000] = {
		action="jump", goto=51001,
		player="",
		alien={"Refinement of this biological communication node makes your identification possible."}
	}
 	questions[51001] = {
		action="jump", goto=50001,
		player="Identify us as who?  What node?  What are you?",
		alien={"Masters.  Spemin.  Tri'na'li'da"}
	}	
	 questions[52000] = {
		action="jump", goto=52001,
		player="",
		alien={"Your servants for creating hybrid nodes.  We await networking."}
	}
	questions[52001] = {
		action="jump", goto=52003,
		player="Hybrid nodes?  Networking?",
		alien={"Hybrid nodes are alien flesh adapted to receive instructions.  Networking is telepathic linkup with Masters."}
	}
	questions[52003] = {
		action="jump", goto=52004,
		player="Do you mean you are the virus?",
		alien={"Tes.  Adequate analogy."}
	}
	questions[52004] = {
		action="terminate",
		player="I command you to stop infecting alien races!",
		alien={"Networking required before instructions are received.  Verbal exchange inaccurate."}
	}
	questions[53000] = {
		action="jump", goto=52001,
		player="",
		alien={"Inaccurate verbal exchange with hybrid node.  Networking is required.  Please respond."}
	}
 	questions[54000] = {
		action="terminate",
		player="",
		alien={"Imperative to neutralize crystal ones at Bec-Felmas 3 - 16,183 or Mathgen 4 - 212,3.  Phlegmak devices recommended."}
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

