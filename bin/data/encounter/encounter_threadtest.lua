DEBUGMODE = 0
--[[

	ENCOUNTER THREAD TEST SCRIPT FILE

	Globals shared with C++ module:
		RACENAME - name of alien race
		PORTRAITIMAGE - bitmap file of alien portrait
		SCHEMATICIMAGE - bitmap file of alien ship schematic
		SPRITEIMAGE - bitmap file of alien ship sprite
		ACTION - actions invoked by script (see below)
		POSTURE - obsequious, friendly, hostile
		ATTITUDE - this alien's attitude toward player (1 to 100)
		GREETING - greeting text after calling Greeting()
		STATEMENT - statement text after calling Statement()
		QUESTION - question text after calling Question()
		RESPONSE - alien's responses to all player messages
		QUESTION1..5 - choices available in a branch action
		Q{} - same choices but in table format
		GOTO1..5 - jump locations associated with branch choices
		G{} - same gotos but in table format

	ACTION REFERENCE:
		restart = start dialogue over at beginning
		terminate = end communication
		attack = engage in combat

	C++ module should examine all globals after one of the three functions are called.

--]]

RACENAME = "TAFEL"
PORTRAITIMAGE = "data/portrait_tafel.bmp"
SCHEMATICIMAGE = "data/schematic_tafel.bmp"
SPRITEIMAGE = "data/ship_tafel.bmp"

--include common encounter functions
if DEBUGMODE == 0 then
  --this version for production
  dofile("data/encounter_common.lua")
else
  --this version for testing
  dofile("encounter_common.lua")
end


------------------------------------------------------------------------
-- OBSEQUIOUS DIALOGUE -------------------------------------------------
------------------------------------------------------------------------
function ObsequiousDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack
	greetings[1] = {
		action="",
		player="Obsequious player greeting 1",
		
		--ALL alien responses may include optional alternates chosen at random
		
		alien={"Obsequious alien greeting 1","random2","random3"} 
	}
	greetings[2] = {
		action="",
		player="Obsequious player greeting 2",
		alien={"Obsequious alien greeting 2","random2","random3"}	}
	greetings[3] = {
		action="",
		player="Obsequious player greeting 3",
		alien={"Obsequious alien greeting 3"} }
	greetings[4] = {
		action="",
		player="Obsequious player greeting 4",
		alien={"Obsequious alien greeting 4"} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Obsequious Player statement 1",
		alien={"Obsequious Alien statement 1","random2","random3"} }
	statements[2] = {
		action="",
		player="Obsequious Player statement 2",
		alien={"Obsequious Alien statement 2"} }
	statements[3] = {
		action="",
		player="Obsequious Player statement 3",
		alien={"Obsequious Alien statement 3","random2","random3"} }
	statements[4] = {
		action="",
		player="Obsequious Player statement 4",
		alien={"Obsequious Alien statement 4"} }

	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	questions[10000] = {
		action="jump", goto=10010,
		player="OBSEQ/YOURSELVES THREAD START",
		alien={"Alien response to OBSEQ/YOURSELVES thread start","random2","random3"}
	}
	questions[10010] = {
		action="jump", goto=10020,
		player="OBSEQ/YOURSELVES THREAD",
		alien={"Alien response to OBSEQ/YOURSELVES","random2","random3"}
	}
	questions[10020] = {
		action="restart",
		player="OBSEQ/YOURSELVES THREAD END",
		alien={"Alien response to OBSEQ/YOURSELVES thread end","random2","random3"}
	}

	--OTHER RACES THREAD
	questions[20000] = {
		action="jump", goto=20010,
		player="OTHER RACES THREAD START",
		alien={"Alien response to OTHER RACES thread start"}
	}
	questions[20010] = {
		action="restart",
		player="OTHER RACES THREAD END",
		alien={"Alien response to OTHER RACES thread end"}
	}

	--THE PAST THREAD
	questions[30000] = {
		action="jump", goto=30010,
		player="THE PAST THREAD START",
		alien={"Alien response to THE PAST thread start"} --remember, alternate responses are supported
	}
	questions[30010] = {
		action="restart",
		player="THE PAST THREAD END",
		alien={"Alien response to THE PAST thread end"}
	}

	--THE ANCIENTS THREAD
	questions[40000] = {
		action="jump", goto=40010,
		player="THE ANCIENTS THREAD START",
		alien={"Alien response to THE ANCIENTS thread start"}
	}
	questions[40010] = {
		action="restart",
		player="THE ANCIENTS THREAD END",
		alien={"Alien response to THE ANCIENTS thread end"}
	}

	--GENERAL INFO THREAD
	questions[50000] = {
		action="jump", goto=50010,
		player="GENERAL INFO THREAD START",
		alien={"Alien response to GENERAL INFO thread start"}
	}
	questions[50010] = {
		action="restart",
		player="GENERAL INFO THREAD END",
		alien={"Alien response to GENERAL INFO thread end"}
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
		player="Friendly player greeting 1",
		alien={"Friendly alien greeting 1"} }
	greetings[2] = {
		action="",
		player="Friendly player greeting 2",
		alien={"Friendly alien greeting 2"}	}
	greetings[3] = {
		action="",
		player="Friendly player greeting 3",
		alien={"Friendly alien greeting 3"} }
	greetings[4] = {
		action="",
		player="Friendly player greeting 4",
		alien={"Friendly alien greeting 4"} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Friendly Player statement 1",
		alien={"Friendly Alien statement 1"} }
	statements[2] = {
		action="",
		player="Friendly Player statement 2",
		alien={"Friendly Alien statement 2"} }
	statements[3] = {
		action="",
		player="Friendly Player statement 3",
		alien={"Friendly Alien statement 3"} }
	statements[4] = {
		action="",
		player="Friendly Player statement 4",
		alien={"Friendly Alien statement 4"} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	questions[10000] = {
		action="jump", goto=10010,
		player="FRIENDLY/YOURSELVES THREAD START",
		alien={"Alien response to FRIENDLY/YOURSELVES thread start","random2","random3"}
	}
	questions[10010] = {
		action="jump", goto=10020,
		player="FRIENDLY/YOURSELVES THREAD",
		alien={"Alien response to FRIENDLY/YOURSELVES","random2","random3"}
	}
	questions[10020] = {
		action="restart",
		player="FRIENDLY/YOURSELVES THREAD END",
		alien={"Alien response to FRIENDLY/YOURSELVES thread end","random2","random3"}
	}

	--OTHER RACES THREAD
	questions[20000] = {
		action="jump", goto=20010,
		player="FRIENDLY/OTHER RACES THREAD START",
		alien={"Alien response to FRIENDLY/OTHER RACES thread start"}
	}
	questions[20010] = {
		action="restart",
		player="FRIENDLY/OTHER RACES THREAD END",
		alien={"Alien response to FRIENDLY/OTHER RACES thread end"}
	}

	--THE PAST THREAD
	questions[30000] = {
		action="jump", goto=30010,
		player="FRIENDLY/THE PAST THREAD START",
		alien={"Alien response to FRIENDLY/THE PAST thread start"} --remember, alternate responses are supported
	}
	questions[30010] = {
		action="restart",
		player="FRIENDLY/THE PAST THREAD END",
		alien={"Alien response to FRIENDLY/THE PAST thread end"}
	}

	--THE ANCIENTS THREAD
	questions[40000] = {
		action="jump", goto=40010,
		player="FRIENDLY/THE ANCIENTS THREAD START",
		alien={"Alien response to FRIENDLY/THE ANCIENTS thread start"}
	}
	questions[40010] = {
		action="restart",
		player="FRIENDLY/THE ANCIENTS THREAD END",
		alien={"Alien response to FRIENDLY/THE ANCIENTS thread end"}
	}

	--GENERAL INFO THREAD
	questions[50000] = {
		action="jump", goto=50010,
		player="FRIENDLY/GENERAL INFO THREAD START",
		alien={"Alien response to FRIENDLY/GENERAL INFO thread start"}
	}
	questions[50010] = {
		action="restart",
		player="FRIENDLY/GENERAL INFO THREAD END",
		alien={"Alien response to FRIENDLY/GENERAL INFO thread end"}
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
		player="Hostile player greeting 1",
		alien={"Hostile alien greeting 1"} }
	greetings[2] = {
		action="",
		player="Hostile player greeting 2",
		alien={"Hostile alien greeting 2"}	}
	greetings[3] = {
		action="",
		player="Hostile player greeting 3",
		alien={"Hostile alien greeting 3"} }
	greetings[4] = {
		action="attack",
		player="Hostile player greeting 4",
		alien={"Hostile alien greeting 4"} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Hostile Player statement 1",
		alien={"Hostile Alien statement 1"} }
	statements[2] = {
		action="",
		player="Hostile Player statement 2",
		alien={"Hostile Alien statement 2"} }
	statements[3] = {
		action="attack",
		player="Hostile Player statement 3",
		alien={"Hostile Alien statement 3"} }
	statements[4] = {
		action="terminate",
		player="Hostile Player statement 4",
		alien={"Hostile Alien statement 4"} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	questions[10000] = {
		action="jump", goto=10010,
		player="HOSTILE/YOURSELVES THREAD START",
		alien={"Alien response to HOSTILE/YOURSELVES thread start","random2","random3"}
	}
	questions[10010] = {
		action="jump", goto=10020,
		player="HOSTILE/YOURSELVES THREAD",
		alien={"Alien response to HOSTILE/YOURSELVES","random2","random3"}
	}
	questions[10020] = {
		action="restart",
		player="HOSTILE/YOURSELVES THREAD END",
		alien={"Alien response to HOSTILE/YOURSELVES thread end","random2","random3"}
	}

	--OTHER RACES THREAD
	questions[20000] = {
		action="jump", goto=20010,
		player="HOSTILE/OTHER RACES THREAD START",
		alien={"Alien response to HOSTILE/OTHER RACES thread start"}
	}
	questions[20010] = {
		action="restart",
		player="HOSTILE/OTHER RACES THREAD END",
		alien={"Alien response to HOSTILE/OTHER RACES thread end"}
	}

	--THE PAST THREAD
	questions[30000] = {
		action="jump", goto=30010,
		player="HOSTILE/THE PAST THREAD START",
		alien={"Alien response to HOSTILE/THE PAST thread start"} --remember, alternate responses are supported
	}
	questions[30010] = {
		action="restart",
		player="HOSTILE/THE PAST THREAD END",
		alien={"Alien response to HOSTILE/THE PAST thread end"}
	}

	--THE ANCIENTS THREAD
	questions[40000] = {
		action="jump", goto=40010,
		player="HOSTILE/THE ANCIENTS THREAD START",
		alien={"Alien response to HOSTILE/THE ANCIENTS thread start"}
	}
	questions[40010] = {
		action="restart",
		player="HOSTILE/THE ANCIENTS THREAD END",
		alien={"Alien response to HOSTILE/THE ANCIENTS thread end"}
	}

	--GENERAL INFO THREAD
	questions[50000] = {
		action="jump", goto=50010,
		player="HOSTILE/GENERAL INFO THREAD START",
		alien={"Alien response to HOSTILE/GENERAL INFO thread start"}
	}
	questions[50010] = {
		action="restart",
		player="HOSTILE/GENERAL INFO THREAD END",
		alien={"Alien response to HOSTILE/GENERAL INFO thread end"}
	}

end

------------------------------------------------------------------------
-- SCRIPT INITIALIZATION -----------------------------------------------
------------------------------------------------------------------------
function Initialize()
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
-- SCRIPT PROCESSING ---------------------------------------------------
------------------------------------------------------------------------

--uncomment the following to enable testing
if DEBUGMODE == 1 then
	Initialize()
	TestScript()
end
