--[[
	ENCOUNTER SCRIPT FILE: MINEX WAR

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
		action="jump", goto=50001,
		player="What can you tell us about you...",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[20000] = {
		action="jump", goto=50001,
		player="What can you tell us about the other...",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[30000] = {
		action="jump", goto=50001,
		player="What can you tell us about the past?",
		alien={"Your race spreads contagion. Do you deny this?"}
	}		
	questions[40000] = {
		action="jump", goto=50001,
		player="Tell us about the Ancients.",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[50000] = {
		action="jump", goto=50001,
		player="What can you tell us about...",
		alien={"Your race spreads contagion. Do you deny this?"}
	}

	questions[50001] = {
		action="branch",
		choices = {
			{ text="Yes, in fact humans are immune to this virus.", goto=60000 },
			{ text="We do not deny it. We are infected just like everyone else.", goto=50002 },
		}
	}
	questions[60000] = {
		action="jump", goto=61000,
		player="",
		alien={"Improbable.  Drastically different sentient alien races, all are infected.  Justify your response." }
	}
	questions[50002] = {
		action="attack",
		player="",
		alien={"..." }
	} 
	questions[61000] = {
		action="branch",
		choices = {
			{ text="I'm not going to tell you anything unless you stop the war.", goto=61100 },
			{ text="Humanity is immune to the virus!", goto=61200 },
			{ text="Humans exposed to the virus develop no symptoms.", goto=61300 },
			{ text="We have the cure to the virus!", goto=61400 }
		}
	}
	questions[61100] = {
		action="attack", 
		player="",
		alien={"Creative ploy.  We are not fools." }
	}
	questions[61200] = {
		action="terminate",
		player="",
		alien={"Anomalous nonsentient flag triggered.  Possibility your race is developmentally flawed.  We will investigate." }
	}
	questions[61300] = {
		action="jump", goto=61301,
		player="",
		alien={"Provide further details." }
	}
	questions[61400] = {
		action="attack", 
		player="",
		alien={"Falsehood.  You lack even the most basic nano-disassembler." }
	}
	questions[61301] = {
		action="branch",
		choices = {
			{ text="The virus remains inert and does not infect human cells.", goto=61310 },
			{ text="You are using the virus to destroy all other races!", goto=61320 },
			{ text="We humans could have natural immunity.", goto=61330 },
			{ text="The spread of the virus was unnaturally fast.", goto=61340 }
		}
	}
	questions[61310] = {
		action="jump", goto=61301,
		player="",
		alien={"Similar behavior seen in 99.37 percent of lifeforms cataloged.  Plenty of specimens to study.  All nonsentient except for your race." }
	}
	questions[61320] = {
		action="terminate",
		player="",
		alien={"Falsehood.  Neither we nor any other race has working knowledge of the virus or of a cure." }
	}
	questions[61330] = {
		action="jump", goto=61301,
		player="",
		alien={"The virus is not natural.  No flaws in its programming can be exploited." }
	}
	questions[61340] = {
		action="jump", goto=52000,
		player="",
		alien={"We concur.  We suspect interference from an interloper or shadow power.  Assistance may be justified.  Provide proof of your trustworthiness." }
	}
	questions[52000] = {
		action="branch",
		choices = {
			{ text="I am willing to do anything to prove our trustworthiness.", goto= 52100 },
			{ text="I can give only my personal vow that we will help.", goto=52200 }, 
			{ text="What would you want us to do?", goto=52300 },
			{ text="Humans are always trustworthy.   Tell us how we can help.", goto=52400 }
		}
	}
	questions[52100] = {
		action="terminate",
		player="",
		alien={"Physical demonstration not required.  Leave." }
	}
	questions[52200] = {
		action="jump", goto=52201,
		player="",
		alien={"There exists a location were we may not travel.  Psychic disturbances localized around Lir IV have repelled us for eons.  Possibility of advanced technology at this location is likely.  We retain some instinctual enmity against the purveyors of this contagion.  We must fight, we must contain." }
	}
	questions[52201] = {
		action="jump", goto=52202,
		player="<More>",
		alien={"Will you transmit a diverse selection of human genetic material for us to study?" }
	}
	questions[52300] = {
		action="jump", goto=52000,
		player="",
		alien={"Revelation requires justification.  Justify yourself." }
	}
	questions[52400] = {
		action="attack",
		player="",
		alien={"Deceptive statement detected." }
	}
	questions[52202] = {
		action="branch",
		choices = {
			{ text="Yes", goto=52210 },
			{ text="No", goto=52220 }
		}
	}
	questions[52210] = {
		action="terminate",
		player="",
		alien={"We will contact you.  Observe containment protocol and remain at your homeworld.  For now you may pass." }
	}
	questions[52220] = {
		action="terminate",
		player="",
		alien={"Very well." }
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
		action="jump", goto=50001,
		player="What can you tell us about you...",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[20000] = {
		action="jump", goto=50001,
		player="What can you tell us about the other...",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[30000] = {
		action="jump", goto=50001,
		player="What can you tell us about the past?",
		alien={"Your race spreads contagion. Do you deny this?"}
	}		
	questions[40000] = {
		action="jump", goto=50001,
		player="Tell us about the Ancients.",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[50000] = {
		action="jump", goto=50001,
		player="What can you tell us about...",
		alien={"Your race spreads contagion. Do you deny this?"}
	}

	questions[50001] = {
		action="branch",
		choices = {
			{ text="Yes, in fact humans are immune to this virus.", goto=60000 },
			{ text="We do not deny it. We are infected just like everyone else.", goto=50002 },
		}
	}
	questions[60000] = {
		action="jump", goto=61000,
		player="",
		alien={"Improbable.  Drastically different sentient alien races, all are infected.  Justify your response." }
	}
	questions[50002] = {
		action="attack",
		player="",
		alien={"..." }
	} 
	questions[61000] = {
		action="branch",
		choices = {
			{ text="I'm not going to tell you anything unless you stop the war.", goto=61100 },
			{ text="Humanity is immune to the virus!", goto=61200 },
			{ text="Humans exposed to the virus develop no symptoms.", goto=61300 },
			{ text="We have the cure to the virus!", goto=61400 }
		}
	}
	questions[61100] = {
		action="attack", 
		player="",
		alien={"Creative ploy.  We are not fools." }
	}
	questions[61200] = {
		action="terminate",
		player="",
		alien={"Anomalous nonsentient flag triggered.  Possibility your race is developmentally flawed.  We will investigate." }
	}
	questions[61300] = {
		action="jump", goto=61301,
		player="",
		alien={"Provide further details." }
	}
	questions[61400] = {
		action="attack", 
		player="",
		alien={"Falsehood.  You lack even the most basic nano-disassembler." }
	}
	questions[61301] = {
		action="branch",
		choices = {
			{ text="The virus remains inert and does not infect human cells.", goto=61310 },
			{ text="You are using the virus to destroy all other races!", goto=61320 },
			{ text="We humans could have natural immunity.", goto=61330 },
			{ text="The spread of the virus was unnaturally fast.", goto=61340 }
		}
	}
	questions[61310] = {
		action="jump", goto=61301,
		player="",
		alien={"Similar behavior seen in 99.37 percent of lifeforms cataloged.  Plenty of specimens to study.  All nonsentient except for your race." }
	}
	questions[61320] = {
		action="terminate",
		player="",
		alien={"Falsehood.  Neither we nor any other race has working knowledge of the virus or of a cure." }
	}
	questions[61330] = {
		action="jump", goto=61301,
		player="",
		alien={"The virus is not natural.  No flaws in its programming can be exploited." }
	}
	questions[61340] = {
		action="jump", goto=52000,
		player="",
		alien={"We concur.  We suspect interference from an interloper or shadow power.  Assistance may be justified.  Provide proof of your trustworthiness." }
	}
	questions[52000] = {
		action="branch",
		choices = {
			{ text="I am willing to do anything to prove our trustworthiness.", goto= 52100 },
			{ text="I can give only my personal vow that we will help.", goto=52200 }, 
			{ text="What would you want us to do?", goto=52300 },
			{ text="Humans are always trustworthy.   Tell us how we can help.", goto=52400 }
		}
	}
	questions[52100] = {
		action="terminate",
		player="",
		alien={"Physical demonstration not required.  Leave." }
	}
	questions[52200] = {
		action="jump", goto=52201,
		player="",
		alien={"There exists a location were we may not travel.  Psychic disturbances localized around Lir IV have repelled us for eons.  Possibility of advanced technology at this location is likely.  We retain some instinctual enmity against the purveyors of this contagion.  We must fight, we must contain." }
	}
	questions[52201] = {
		action="jump", goto=52202,
		player="<More>",
		alien={"Will you transmit a diverse selection of human genetic material for us to study?" }
	}
	questions[52300] = {
		action="jump", goto=52000,
		player="",
		alien={"Revelation requires justification.  Justify yourself." }
	}
	questions[52400] = {
		action="attack",
		player="",
		alien={"Deceptive statement detected." }
	}
	questions[52202] = {
		action="branch",
		choices = {
			{ text="Yes", goto=52210 },
			{ text="No", goto=52220 }
		}
	}
	questions[52210] = {
		action="terminate",
		player="",
		alien={"We will contact you.  Observe containment protocol and remain at your homeworld.  For now you may pass." }
	}
	questions[52220] = {
		action="terminate",
		player="",
		alien={"Very well." }
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
		action="jump", goto=50001,
		player="What can you tell us about you...",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[20000] = {
		action="jump", goto=50001,
		player="What can you tell us about the other...",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[30000] = {
		action="jump", goto=50001,
		player="What can you tell us about the past?",
		alien={"Your race spreads contagion. Do you deny this?"}
	}		
	questions[40000] = {
		action="jump", goto=50001,
		player="Tell us about the Ancients.",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[50000] = {
		action="jump", goto=50001,
		player="What can you tell us about...",
		alien={"Your race spreads contagion. Do you deny this?"}
	}

	questions[50001] = {
		action="branch",
		choices = {
			{ text="Yes, in fact humans are immune to this virus.", goto=60000 },
			{ text="We do not deny it. We are infected just like everyone else.", goto=50002 },
		}
	}
	questions[60000] = {
		action="jump", goto=61000,
		player="",
		alien={"Improbable.  Drastically different sentient alien races, all are infected.  Justify your response." }
	}
	questions[50002] = {
		action="attack",
		player="",
		alien={"..." }
	} 
	questions[61000] = {
		action="branch",
		choices = {
			{ text="I'm not going to tell you anything unless you stop the war.", goto=61100 },
			{ text="Humanity is immune to the virus!", goto=61200 },
			{ text="Humans exposed to the virus develop no symptoms.", goto=61300 },
			{ text="We have the cure to the virus!", goto=61400 }
		}
	}
	questions[61100] = {
		action="attack", 
		player="",
		alien={"Creative ploy.  We are not fools." }
	}
	questions[61200] = {
		action="terminate",
		player="",
		alien={"Anomalous nonsentient flag triggered.  Possibility your race is developmentally flawed.  We will investigate." }
	}
	questions[61300] = {
		action="jump", goto=61301,
		player="",
		alien={"Provide further details." }
	}
	questions[61400] = {
		action="attack", 
		player="",
		alien={"Falsehood.  You lack even the most basic nano-disassembler." }
	}
	questions[61301] = {
		action="branch",
		choices = {
			{ text="The virus remains inert and does not infect human cells.", goto=61310 },
			{ text="You are using the virus to destroy all other races!", goto=61320 },
			{ text="We humans could have natural immunity.", goto=61330 },
			{ text="The spread of the virus was unnaturally fast.", goto=61340 }
		}
	}
	questions[61310] = {
		action="jump", goto=61301,
		player="",
		alien={"Similar behavior seen in 99.37 percent of lifeforms cataloged.  Plenty of specimens to study.  All nonsentient except for your race." }
	}
	questions[61320] = {
		action="terminate",
		player="",
		alien={"Falsehood.  Neither we nor any other race has working knowledge of the virus or of a cure." }
	}
	questions[61330] = {
		action="jump", goto=61301,
		player="",
		alien={"The virus is not natural.  No flaws in its programming can be exploited." }
	}
	questions[61340] = {
		action="jump", goto=52000,
		player="",
		alien={"We concur.  We suspect interference from an interloper or shadow power.  Assistance may be justified.  Provide proof of your trustworthiness." }
	}
	questions[52000] = {
		action="branch",
		choices = {
			{ text="I am willing to do anything to prove our trustworthiness.", goto= 52100 },
			{ text="I can give only my personal vow that we will help.", goto=52200 }, 
			{ text="What would you want us to do?", goto=52300 },
			{ text="Humans are always trustworthy.   Tell us how we can help.", goto=52400 }
		}
	}
	questions[52100] = {
		action="terminate",
		player="",
		alien={"Physical demonstration not required.  Leave." }
	}
	questions[52200] = {
		action="jump", goto=52201,
		player="",
		alien={"There exists a location were we may not travel.  Psychic disturbances localized around Lir IV have repelled us for eons.  Possibility of advanced technology at this location is likely.  We retain some instinctual enmity against the purveyors of this contagion.  We must fight, we must contain." }
	}
	questions[52201] = {
		action="jump", goto=52202,
		player="<More>",
		alien={"Will you transmit a diverse selection of human genetic material for us to study?" }
	}
	questions[52300] = {
		action="jump", goto=52000,
		player="",
		alien={"Revelation requires justification.  Justify yourself." }
	}
	questions[52400] = {
		action="attack",
		player="",
		alien={"Deceptive statement detected." }
	}
	questions[52202] = {
		action="branch",
		choices = {
			{ text="Yes", goto=52210 },
			{ text="No", goto=52220 }
		}
	}
	questions[52210] = {
		action="terminate",
		player="",
		alien={"We will contact you.  Observe containment protocol and remain at your homeworld.  For now you may pass." }
	}
	questions[52220] = {
		action="terminate",
		player="",
		alien={"Very well." }
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
	    RESPONSE = "No more warnings will be given."
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

