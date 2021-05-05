--[[------------------------------------------------------------------------------------------------------------------------------------------------- ]
	ENCOUNTER SCRIPT FILE: BAR-ZHON

	Last Modified: January 13, 2014

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

-- Sentence fragments to combine for questions and statements
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

if (plot_stage == 1) then -- Initial state

	obsequiousGreetTable= {
			"We are Bar-zhon.  Please stop this foolish demeaning of yourself.",
			"We are Bar-zhon.  I would formally request that conventional attitudes be taken.",
			"We are Bar-zhon.  Please stop this foolish demeaning of yourself, there is no point to it.",
			"We are Bar-zhon.  Foolish perceptions are the result of immature or distorted minds."
	}

elseif (plot_stage == 2) then -- viruses state


	obsequiousGreetTable= {
			"We are Bar-zhon.  Contagion quarantine lockdown is in effect. Contrite statements do not appease madness stages.",
			"We are Bar-zhon.  Contagion quarantine lockdown is in effect. Demeaning yourselves will not protect against infection.",
			"We are Bar-zhon.  Contagion quarantine lockdown is in effect. Please stop this foolish demeaning of yourself, there is no point to it.",
			"We are Bar-zhon.  Contagion quarantine lockdown is in effect. Foolish perceptions are the result of immature or distorted minds."
	}

elseif (plot_stage == 3) or (plot_stage == 4) then -- ancients state

	obsequiousGreetTable= {
			"We are Bar-zhon.  Fleet action protocols active.  Contrite statements will not convince us to act outside procedures.",
			"We are Bar-zhon.  Fleet action protocols active.  Demeaning yourselves serves no purpose.",
			"We are Bar-zhon.  Fleet action protocols active.  Please stop this foolish demeaning of yourself in the face of present danger. It will not improve circumstances.",
			"We are Bar-zhon.  Fleet action protocols active.  Foolish perceptions may be the result of irrational fear or madness from infection.  Preventive lockdown is suggested."
	}
end

-- generic greeting messages, answers to be randomly obtained from the bank of answers above depending on what plot stage the game is in. Note that CommFxn is always called for greetings and statements and that attitude is adjusted per the criteria referenced in Commfxn
	greetings[1] = {
		action="",
		player="Hail oh mighty ones, masters of the universe.",
		alien= 	obsequiousGreetTable }
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"We Bar-zhon are civilized and not prone to precipitous action despite present difficulties."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien= 	obsequiousGreetTable }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien= 	obsequiousGreetTable }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien= 	obsequiousGreetTable }
	greetings[6] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien= obsequiousGreetTable }
	greetings[7] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien= obsequiousGreetTable }
	greetings[8] = {
		action="",
		player="Please do not blast us into atomic particles.  Take pity on us who are not fit to grovel in your waste products.",
		alien= obsequiousGreetTable }
	greetings[9] = {
		action="",
		player="We can see that you are indeed the true race.  Pray enlighten us with your gems of infinite wisdom.",
		alien= obsequiousGreetTable }
	greetings[10] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien= obsequiousGreetTable }
	greetings[11] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien= obsequiousGreetTable }
	greetings[12] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien= obsequiousGreetTable }
end

------------------------------------------------------------------------
-- FRIENDLY DIALOGUE ---------------------------------------------------
------------------------------------------------------------------------
function FriendlyDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack

if (plot_stage == 1) then -- initial state

	friendlyGreetTable= {
		"Greetings representative from Myrrdan.  This patrol vessel is a representative of the Bar-Zhon Imperial Navy.",
		"This is the Imperial Bar-Zhon.  Welcome.",
		"Alien craft, you have encountered the Barzhon.",
		"We also extend greetings and the wish for peaceful relations from the Bar-Zhon peoples."
	}

elseif (plot_stage == 2) then -- virus state

	friendlyGreetTable= {
		"Greetings representative from Myrrdan.  We advise readiness in the face of unpredictable contagion behavior.",
		"This is the Imperial Bar-Zhon starship.  You are advised to keep your distance for our safety and yours.",
		"Alien craft, you have encountered the Barzhon.  Be advised we watch for signs of madness.",
		"We also extend greetings and the wish for peaceful relations from the Bar-Zhon peoples.  May I request the reason for your intrusion in these troubling times?",
		"We also extend greetings and the wish for peaceful relations from the Bar-Zhon peoples."
	}

elseif (plot_stage == 3) then -- war state

	friendlyGreetTable= {
		"Greetings representative from Myrrdan.  You will not be granted protection if the Minex attack here.  We advise readiness.",
		"This is the Imperial Bar-Zhon.  You are advised to keep shields enabled and watch for Minex warships.",
		"Alien craft, you have encountered the Barzhon.  Be advised we watch both for signs of treachery and madness.",
		"This is the Imperial Bar-Zhon.  We reservedly accept your hail.  May I request the reason for your intrusion in these warring times?",
		"This is the Imperial Bar-Zhon.   Difficult times induce cooperation.  We return your greetings with due respect."
	}

elseif (plot_stage == 4) then -- ancients state

	friendlyGreetTable= {
		"Greetings representative from Myrrdan.  You will not be granted protection if the Infected or the Minex attack here.  We advise readiness.",
		"This is the Imperial Bar-Zhon starship.  You are advised to keep shields enabled and watch for Infected warships now that the Minex have retreated.",
		"Alien craft, you have encountered the Barzhon.  Be advised we watch both for signs of Infected and hints of madness.",
		"This is the Imperial Bar-Zhon.   We reservedly accept your hail.  May I request the reason for your intrusion in these dire times?",
		"This is the Imperial Bar-Zhon.   Difficult times induce cooperation.  We return your greetings with due respect."
	}

end

	greetings[1] = {
		action="",
		player="Greetings from the planet Myrrdan. We come in peace...usually.",
		alien= friendlyGreetTable }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien= friendlyGreetTable }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien= friendlyGreetTable }
	greetings[4] = {
		action="",
		player="Greetings.  Your ship seems to be very powerful.",
		alien= friendlyGreetTable }
	greetings[5] = {
		action="",
		player="Hello there.  Your ship appears very unusual.",
		alien= friendlyGreetTable }
	greetings[6] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien= friendlyGreetTable }
	greetings[7] = {
		action="",
		player="Greetings friend!  There is no limit to what both our races can gain from mutual exchange.",
		alien= friendlyGreetTable }


end

------------------------------------------------------------------------
-- HOSTILE DIALOGUE ----------------------------------------------------
------------------------------------------------------------------------
function HostileDialogue()
	--add as many player greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack

if (plot_stage == 1) then

	hostileattackGreetTable= {
		"Bar-Zhon patrol vessel engaging hostile pirate."
	}

	hostileGreetTable= {
		"Bar-Zhon Naval ships do not respond to threats.  You are given warning.",
		"This a heavily armed patrol vessel of the Bar-Zhon Imperial Navy.",
		"Threats are taken very seriously by the Bar-zhon Navy.  Any action will be met by equal amounts of force.",
		"Take no hostile or evasive action unless you want to suffer the wrath of the imperial Barzhon Navy.",
		"Bar-Zhon Naval ships do not respond to threats or insults.",
		"By the laws of the Barzhon Imperial Confederacy we hereby present you with the sole warning.  Cease this aggressive attitude."
	}


elseif (plot_stage == 2) then


	hostileattackGreetTable= {
		"Bar-Zhon patrol vessel engaging maddened privateer.",
		"Bar-Zhon Naval ships do tolerate threats or insults.  Signs of infection cannot pass."
	}

	hostileGreetTable= {
		"Bar-Zhon Naval ships in this vicinity are under full control. Confrontational postures are not recommended at this time due to contagion wariness. Be warned.",
		"This a heavily armed patrol vessel of the Bar-Zhon Imperial Navy.  You are being monitored for signs of erratic madness.",
		"Threats are taken very seriously by the Bar-zhon Navy due to current difficulties.  Any action will be met by equal amounts of force.",
		"Take no hostile or evasive action unless you want to suffer the wrath of the imperial Barzhon Navy.",
		"Bar-Zhon Naval ships do not respond to threats or insults.",
		"By the laws of the Barzhon Imperial Confederacy we hereby present you with the sole warning.  Cease this aggressive attitude."
	}

elseif (plot_stage == 3) then


	hostileattackGreetTable= {
		"Bar-Zhon patrol vessel engaging privateer.",
		"Bar-Zhon Naval ships do tolerate threats or insults."
	}
	hostileGreetTable= {
		"By the laws of the Barzhon Imperial Confederacy we hereby present you with the sole warning.  Cease this aggressive attitude.",
		"Take no hostile or evasive action unless you want to suffer the wrath of the imperial Barzhon Navy.",
		"Bar-Zhon Naval ships do not respond to threats or insults."
	}


elseif (plot_stage == 4) then

	hostileattackGreetTable= {
		"Bar-Zhon patrol vessel engaging Infected One.",
		"Bar-Zhon Naval ships do tolerate threats or insults.  Signs of infection cannot pass."
	}

	hostileGreetTable= {
		"Scans for Infected modified technology negative.  By the laws of the Barzhon Imperial Confederacy we hereby present you with the sole warning.  Cease this aggressive attitude.",
		"Take no hostile or evasive action unless you want to suffer the wrath of the imperial Barzhon Navy.  We tolerate no Infected here.",
		"Beeh!  Stupid alien.  You are not infected.  Do not seek unnecessary trouble."
	}

end

	greetings[1] = {
		action="attack",
		player="This is captain [CAPTAIN] of the starship [SHIPNAME]. Identify yourselves immediately or be destroyed.",
		alien= hostileattackGreetTable }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien= hostileGreetTable }
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien= hostileGreetTable }
	greetings[4] = {
		action="",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien= hostileGreetTable }
	greetings[5] = {
		action="attack",
		player="We require information. Comply or be destroyed.",
		alien= hostileattackGreetTable }
	greetings[6] = {
		action="",
		player="Your ship is useless and weak.",
		alien= hostileGreetTable }
	greetings[7] = {
		action="",
		player="What an ugly and worthless creature.",
		alien= hostileGreetTable }
	greetings[8] = {
		action="",
		player="Your ship looks like a flying garbage scow.",
		alien= hostileGreetTable }
end

-- Questions used for answers for all dialogue.
function StandardQuestions()

--[[player questions / alien responses

	ACTION SYNTAX:
	 ftest=1 (Call CommFxn to perform one or more actions when this question is called)
	 ftest=2 Adjust attitude for an insightful question, values spelled out in CommFxn
	 ftest=3 Adjust attitude for an aggravating question, values spelled out in CommFxn

	 goto=1 Restart dialogue
	 goto=997 Terminate dialog
	 goto=999 Terminate dialog and attack the player

	 Player="value" - This option is presented as a single choice for the player to click on unless [AUTO_REPEAT] is used. Auto repeat either repeats the last player or player fragment statement or repeats the menu choice picked in a case statement. If playerFragment is used, then the player field is overridden and should always be set to [AUTO_REPEAT] for compatibility reasons.

	introFragment="value" - This optional field is always shown from the player's side before any other text.

	playerFragment="value" - This optional field first displays the introFragment text, then picks a random sentence fragment from the SetPlayerTables function that corresponds to the current posture chosen, and then displays the text within quotations, and then appends a period.

		fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}}, - Appended onto a playerFragment statement to tell the script which sentence fragments are inappropriate for that particular question

	alien={"value"} - The alien response to the player question

	YOURSELVES THREAD   10000-19999
	OTHER RACES THREAD  20000-29999
	THE PAST THREAD     30000-39999
	THE ANCIENTS THREAD 40000-49999
	GENERALINFO THREAD  50000-59999
	"CURRENT EVENTS"    60000-69999
	(These questions are used in some scripts in the virus, war, and ancients stages when dialog is not completely rewritten)

	MILITARY MISSIONS   70000-79999
	SCIENTIFIC MISSIONS 80000-89999
	FREELANCE MISSIONS  90000-99999

	UNIVERSAL MISSIONS AND SPECIAL CASES 100-999	
]]--




if (plot_stage == 1) then -- initial plot state

	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"The Bar-zhon people and our Navy are matched by none other.  Many other races inhabit this area of space but none come close to our strength and power.  Well, maybe only the Minex come close to our strength."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Please be more specific.  Are you interested in the rabble known as the coalition?  Or the other races, the Tafel, the Nyssian, the Minex, the Thrynn and Elowan, or the Spemin?  Or do you want to know about other pirates?"}
	}
	questions[30000] = {
		action="jump", goto=31001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"A few centicycles ago, in your own system of time about 1500 years ago, this entire region of space was enveloped by sector wide warfare known to historians as The Great War.   It is a lengthy story, are you sure you want to hear it?"}
	}
	questions[40000] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"The ancients traveled through this area of space several millennia ago, leaving strange uniformly shaped ruins and endurium crystals for whatever reason at the time.  Seek out some Nyssian story monger if you wish to learn more about them." }
	}
	questions[50000] = {
		action="branch",
		choices = {
--			{ text="Let us become allies",  goto=51000 }, -- disabled unless home worlds and trade depots are enabled
--			{ text="Your home world", goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}

	questions[51000] = {
		action="jump", goto=50000, ftest= 2, -- insightful attitude modification
		introFragment="We are interested in becoming allies of your great empire.",
		player="[AUTO_REPEAT]",
		playerFragment= "on the location of your leaders",
		alien={"The benefits of citizenship to the player in the great Bar-zhon empire cannot be counted.  Please visit our primary naval station at Midir V - 201,105."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="[AUTO_REPEAT]",
		playerFragment="on the location of your home world",
		alien={"Our primary naval station at Midir V - 201,105."}
	}


elseif (plot_stage == 2) then  -- virus plot state

	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"The Bar-zhon people and our Navy are matched by none other.  Many other races inhabit this area of space but none come close to our strength and power.  We will meet and surpass these current difficulties."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Please be more specific.  Are you interested in the rabble known as the coalition?  Or the other races, the Tafel, the Nyssian, the Minex, the Thrynn and Elowan, or the Spemin?  Or do you want to know about other pirates?  All have seemingly been affected by the current infection."}
	}
	questions[30000] = {
		action="jump", goto=31001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"A few centicycles ago, in your own system of time about 1500 years ago, this entire region of space was enveloped by sector wide warfare known to historians as The Great War.  This period challenged us far more than some minor sickness.  It is a lengthy story, are you sure you want to hear it?"}
	}
	questions[40000] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"The ancients traveled through this area of space several millennia ago, leaving strange uniformly shaped ruins and endurium crystals for whatever reason at the time.  Seek out some Nyssian story monger if you wish to learn more about them.  Our attention is focused more on more general and current issues such as this new illness." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Current news",  goto=60000 },
			--{ text="Let us become allies",  goto=51000 },
			{ text="Your home world", goto=52000 },  -- Disabled until trade depots or extra star ports are created
			{ text="<Back>",  goto=1 }
		}
	}

	questions[51000] = {
		action="jump", goto=50000, ftest= 2, -- insightful
		introFragment="We are interested in becoming allies of your great empire.",
		player="[AUTO_REPEAT]",
		playerFragment= "on the location of your leaders",
		alien={"The benefits of citizenship to the player in the great Bar-zhon empire cannot be counted.  Please visit our primary naval station at Midir V - 201,105."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="[AUTO_REPEAT]",
		playerFragment="on the location of your home world",
		alien={"Our primary naval station at Midir V - 201,105."}
	}

	questions[60000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about current events",
		alien={"A lethal virus is devastating our populations and driving selective crews to madness." }
	}
	questions[60001] = {
		action="branch",
		choices = {
			{ text="Number of infected", goto=61000 },
			{ text="Madness", goto=62000 },
			{ text="Progress towards a cure", goto=63000 },   -- plot stage 2 
			{ text="Response of other races", goto=64000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[61000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about who is infected by the virus", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"All nearby alien species appear to have contracted the contagion nearly simultaneously." }
	}
	questions[62000] = {
		action="jump", goto=62001,
		player="[AUTO_REPEAT]",
		playerFragment="about what you meant by saying ship crews have been driven to madness",
		alien={"All of our population including deep space and Naval vessels have tested positive to this infection.  Most crews simply show minor symptoms of lethargy and physical exhaustion.  Other times entire ship crews have gone rogue and completely broken off contact with the fleet." }
	}
	questions[63000] = {
		action="jump", goto=63001,
		player="[AUTO_REPEAT]",
		playerFragment="what progress you have made towards a cure", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Significant progress is being made by Bar-zhon scientists.  When a breakthrough is made it will be distributed to others." }
	}
	questions[63001] = {
		action="jump", goto=63002,
		player="[AUTO_REPEAT]",
		playerFragment="anything your scientists have discovered about the virus", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The technology of this infectious nanovirus is far beyond the capabilities of any existing race in this area of space. The Bar-Zhon military has been mobilized in search of archaeological digs which may have uncovered this nightmarish technology." }
	}
	questions[63002] = {
		action="jump", goto=60001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the archaeological digs you are referring to",
		alien={"The three imperialists were aided by some technology far beyond their science.  We have started to investigate many locations in their space.  For example many Bx fleets were found to be patrolling an area far outside their homeworld of Anextiomarus. (Boann system - 115,184) They often traveled near the central supports of the tower. (13, 92)" }
	}
	questions[64000] = {
		action="jump", goto=60001, ftest= 2, -- insightful
		introFragment="Considering the impact of this contagion for a moment,",
		player="[AUTO_REPEAT]",
		playerFragment="about how the other races have been taking advantage of this situation",
		alien={"No one has been given an advantage in this situation in any way that we can detect.  The infection has even calmed incursions of the coalition for the moment.  Multiple alien fleet movements have been detected in the downspin and outward direction.  The significance of this is unknown at this time." }
	}
	questions[62001] = {
		action="branch",
		choices = {
			{ title="Contacting rogue ships", text="Do you eventually reestablish contact with rogue ships?", goto=62100 },
			{ text="What do insane ship crews do?", goto=62200 },
			{ title="Do they always recover?", text="Do rogue ships always return to sanity?", goto=62300 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[62100] = {
		action="jump", goto=62001,
		player="[AUTO_REPEAT]",
		alien={"Most of the time complete control is reasserted after a period of time.  Very few become derelicts losing all officers on board.  Most retain control of themselves after a time with no memory of the period of insanity.  Approaching these rogue ships during their period of insanity instigates a firefight." }
	}
	questions[62200] = {
		action="jump", goto=62001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="if the rogue ships do anything or try to go anywhere", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Sickness and insanity have no rationality.  On the other hand it is very curious how the crew of an entire ship will go mad and also recover at the exact moment.  It is also curious how those in a period of insanity are so effective at operating their ships navigation and weaponry and later have no memory of the event." }
	}
	questions[62300] = {
		action="jump", goto=62001,
		player="[AUTO_REPEAT]",
		alien={"Yes." }
	}


elseif (plot_stage == 3) then  -- war plot state


	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"The Bar-zhon people and our Navy are the defenders of freedom in this region.  Many other races inhabit this area of space but none but the Minex come close to our strength and power.  If you want more specific about the Minex aggression I may be able to answer some general inquiries on that subject."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Please be more specific.  Are you interested in the rampaging Minex?  Or the Coalition, the Tafel, the Nyssian, the Thrynn and Elowan, the Spemin or other pirates?"}
	}
	questions[30000] = {
		action="jump", goto=31001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"A few centicycles ago this entire region of space was enveloped by sector wide warfare known to historians as The Great War.   I have more recent and general information about the Minex aggression if you wish."}
	}
	questions[40000] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"The ancients traveled through this area of space several millennia ago, leaving strange uniformly shaped ruins and endurium crystals for whatever reason at the time.  Seek out some Nyssian story monger if you wish to learn more about them.  Military protocols dictate only a productive use of our time during these savage days." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Current news",  goto=60000 },
			--{ text="Let us become allies",  goto=51000 },
			--{ text="Your home world", goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}

	questions[51000] = {
		action="jump", goto=50000, ftest= 2, -- insightful
		introFragment="We are interested in becoming allies of your great empire.",
		player="[AUTO_REPEAT]",
		playerFragment= "on the location of your leaders",
		alien={"The benefits of citizenship to the player in the great Bar-zhon empire cannot be counted.  Please visit our primary naval station at Midir V - 201,105."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="[AUTO_REPEAT]",
		playerFragment="on the location of your home world",
		alien={"Our primary naval station at Midir V - 201,105."}
	}

	questions[60000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about current events",
		alien={"Plenty of news but none of pleasant type.  The Minex have left their isolationism and are attacking all other races.  The virus infection grows more serious.  The Coalition and other profiteering groups are becoming more aggressive.  The Bar-zhon people have endured worse." }
	}

	questions[60001] = {
		action="branch",
		choices = {
			{ text="The Minex War", goto=61000 },
			{ text="News about the the viral infection", goto=62000 },
			{ text="The Coalition being more aggressive", goto=63000 },  -- stage 3
			{ text="<Back>", goto=1 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the war against the Minex",
		alien={"Minex millitary strength is more vast then we could have dreamed.  They are waging a successful military campaign against all of the other races simultaneously and at least so far they have been successful at it.  Fortunately their tactics are flawed and their will for conquest is lacking. " }
	}
	questions[62000] = {
		action="jump", goto=62001,
		player="[AUTO_REPEAT]",
		playerFragment="if you know anything new about the the viral infection",
		alien={"We have made significant progress towards a cure however this war has forced us to recall most research teams." }
	}
	questions[63000] = {
		action="jump", goto=60001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how the the Coalition is more aggressive", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"This is a nuanced issue.  They are partially shielded from the Minex from their spatial position in the galaxy and have benefited from grave robbing battle derelicts.  On the other hand, the virus infection has decimated their densely populated asteroid bases and their fleets are caught between our forces and the Minex roaming fleets.  They are being forced into open warfare and are losing badly." }
	}

	questions[61001] = {
		action="branch",
		choices = {
			{ text="Flawed Minex tactics", goto=61100 },
			{ text="Minex attacking all races", goto=61200 },
			{ text="Progress of the war", goto=61300 },
			{ text="Stopping the Minex", goto=61400 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[61100] = {
		action="jump", goto=61001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how the Minex tactics are flawed", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Minex battleships retreat from serious opposition, fail to hold territory, and rarely enter heavily industrialized systems.  Although their technology is formidable, we will wear them down." }
	}
	questions[61200] = {
		action="jump", goto=61202, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about what you meant by the Minex attacking all races", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The statement is true in the literal sense.  This misstep we are fully taking advantage of.  Non-aggression pacts have been drawn up with the Thrynn and Elowan to share intelligence and to coordinate attacks against Minex, pirates, and rogue ships.  The Coalition and our Navy are observing a tacit cease-fire during the difficulties." }
	}
	questions[61202] = {
		action="jump", goto=61201,
		player="[AUTO_REPEAT]",
		alien={"How has Myrrdan fared against the Minex?" }
	}
	questions[61300] = {
		action="jump", goto=61301,
		player="[AUTO_REPEAT]",
		playerFragment="how the war has progressed so far", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The Minex seemed to have been emphasizing a strategy of isolation.  Dense fleets are attacking wandering groups of ships outside of their territory and retreating from organized opposition.  The net effect is preventing any alliance from forming to oppose them, but covering vast areas of space has prevented them from taking any territory or achieving any obvious objective." }
	}
	questions[61301] = {
		action="jump", goto=61001,
		player="[AUTO_REPEAT]",
		playerFragment="if their tactics seem to be just to attack the weak points in your defense", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Essentially true but since they are not actively using scouts, their tactics have caused them to bear the brunt of attacks from virus crazed ships of all races.  Their efforts have also weakened quite a few pirate organizations in your area of space.  The attacks themselves also are carried out in a blind and unfocused manner.  Despite their great technological power this demonstrates their lack of military leadership." }
	}
	questions[61400] = {
		action="jump", goto=61001,
		player="[AUTO_REPEAT]",
		playerFragment="how you plan to stop the Minex", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"We expect that Minex fleet losses will exceed the capacity of their industrial base.  When attrition causes a visible shift in their fleet size we plan to counter attack against their worlds.  Attempted incursions during the great war led many to believe that the Minex homeworld to be located somewhere within the Pearl cluster." }
	}

	questions[61201] = {
		action="branch",
		choices = {
			{ text="Umm, uhh, well, we've been able to withstand so far.", goto=61210 },
			{ text="So far the Minex have not attacked us.", goto=61220 },
		}
	}
	questions[61210] = {
		action="jump", goto=61001,
		player="[AUTO_REPEAT]",
		alien={"Although Myrrdan's military strength is insignificant, please convey to your leaders the Bar-zhon people's desire to expand our peaceful relations into an alliance." }
	}
	questions[61220] = {
		action="jump", goto=61001,
		player="[AUTO_REPEAT]",
		alien={"Very curious but fortunate.  Your people may want to keep a low profile for now." }
	}

	questions[62001] = {
		action="branch",
		choices = {
			{ text="What research and where were the research teams?", goto=62100 },
			{ text="Any progress on combating the madness?", goto=62200 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[62100] = {
		action="jump", goto=62101,
		player="[AUTO_REPEAT]",
		playerFragment="about what research these teams were conducting before being recalled",
		alien={"During the Great War, the Transmodra race utilized biological weapons of surprising complexity and effectiveness but nothing as ruthless as the contagion we all face now.  Unfortunately the complete razing of their homeworld left their civilizations mute to the ages. Thermal, radioactive, and dust particles have only recently settled down allowing sensors to operate again." }
	}
	questions[62101] = {
		action="jump", goto=62001,
		player="[AUTO_REPEAT]",
		playerFragment="about the location of the Transmodra home world",
		alien={"Their home world was located at Dian Cecht 4 - 35,139.  Investigate if you wish.  We have already decoded some of their records and have learned that much of their weapon technology originated from an archaeological dig in the deserted city on Dagda III (228, 192) at planetary coordinates 69S X 133E.  Feel free to follow up on these leads." }
	}
	questions[62200] = {
		action="jump", goto=62201,
		player="[AUTO_REPEAT]",
		playerFragment="if you have made any progress treating or combating the madness", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Unfortunately no.  We have started to permanently lose contact with certain ships in our fleet and have heard similar reports from the other races as well.  At first the losses were attributed to warfare but tachyon identifier broadcasts continue." }
	}
	questions[62201] = {
		action="jump", goto=62001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the activities of the missing ships",
		alien={"They are infected and beyond rescue save coming to their own senses.  Doubtlessly they are wandering aimlessly and aggressively attacking any ship in their range." }
	}


elseif (plot_stage == 4) then  -- ancients plot state


	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"The Bar-zhon people and our Navy are the defenders of freedom in this region.  Many other races inhabit this area of space but none but the Minex come close to our strength and power.  If you want more specific information concerning the continuing plague or the rampaging Infected I may be able to answer some general inquiries on that subject."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Please be more specific.  Are you interested in current news concerning the rampaging Infected?  Or general information about the other races?"}
	}
	questions[30000] = {
		action="jump", goto=31001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"A few centicycles ago this entire region of space was enveloped by sector wide warfare known to historians as The Great War.   I have more recent and general information about the new military difficulty if you wish."}
	}
	questions[40000] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"The ancients traveled through this area of space several millennia ago, leaving strange uniformly shaped ruins and endurium crystals for whatever reason at the time.  The rampaging Infected do not sit around gossiping about irrelevant history.  Seek out some Nyssian story monger if you wish to learn more about them." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Current news",  goto=60000 },
			--{ text="Let us become allies",  goto=51000 },
			--{ text="Your home world", goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}

	questions[51000] = {
		action="jump", goto=50000, ftest= 2, -- insightful
		introFragment="We are interested in becoming allies of your great empire.",
		player="[AUTO_REPEAT]",
		playerFragment= "on the location of your leaders",
		alien={"The benefits of citizenship to the player in the great Bar-zhon empire cannot be counted.  Please visit our primary naval station at Midir V - 201,105."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="[AUTO_REPEAT]",
		playerFragment="on the location of your home world",
		alien={"Our primary naval station at Midir V - 201,105."}
	}

	questions[60000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about current events",
		alien={"Our situation is dire.  The deaths from the virus infection have been minimized and all war hostilities have ceased from the Minex, but our society is crumbling and all research leads towards a cure have been exhausted." }
	}
	questions[60001] = {
		action="branch",
		choices = {
			{ text="Society crumbling", goto=61000 },
			{ text="Research leads", goto=62000 },
			{ title="Reveal Minex hint", text="The Minex revealed that the ancients may have a cure.", goto=63000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="[AUTO_REPEAT]",
		playerFragment="how your society is crumbling",
		alien={"Isolation necessary to keep people alive has seriously dampened the Bar-zhon economy.  Large numbers of transport and warships have simply deserted and this has created severe shortages in many areas." }
	}
	questions[62000] = {
		action="jump", goto=62001,
		player="[AUTO_REPEAT]",
		playerFragment="about your research leads",
		alien={"I am referring to the archaeology digs in the Dagda system you have already investigated.  Despite interesting finds, none of it provides any medical insight into the infection." }
	}
	questions[62001] = {
		action="jump", goto=60001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="what we should pursue next", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Seek out the Minex and the Nyssian.  The Minex have been proven to have the most advanced technology and the Nyssian possess very unusual and unique organic technology which may give them insights into biological problems." }
	}

	questions[63000] = {				-- Stage 4
		action="jump", goto=63001,
		player="[AUTO_REPEAT]",
		alien={"That notion seems irrelevant to the current situation.  If they refer to the ancients in present tense I assume they know where they are and how to contact them?" }
	}
	questions[63001] = {
		action="jump", goto=63002, ftest= 3, -- aggravating
		player="Uhh, no, but they think that telepathy is the key.",
		alien={"Telepathy is a fluke of genetics.  In ancient times our society was somewhat successful at duplicating it to a limited degree.  Unfortunately those with true telepathic abilities are either too influenced by others, too unreliable, or too often driven mad by their gifts to be of any real use. Unless the Minex can demonstrate telepathy technology, we would suggest seeking out ancient ruins, not some fantasy." }
	}
	questions[63002] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="where we would have a good chance of finding Ancient ruins and Ancient technology",
		alien={"The Bar-zhon have vast endurium stores but these were collected hundreds of years ago from the former Sabion territories.  The Sabion home world was Gorias 3 - 5,16.  The Thrynn and Elowan contest that region of space today.  Search in that area or seek out the Nyssian if you wish to hear more idle speculation about the Ancients themselves." }
	}
	questions[61001] = {
		action="branch",
		choices = {
			{ text="Ships deserting", goto=61100 },
			{ title="The Coalition", text="Has the coalition been responsible for any of your problems?", goto=61200 },
			{ text="Isolation procedures", goto=61300 },
			{ text="Dampened economy", goto=61400 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[61100] = {
		action="jump", goto=61102,
		player="[AUTO_REPEAT]",
		playerFragment="why your ships are deserting",
		alien={"The virus infection has become more and more effective at keeping ship crews in a state of 'madness'.  We have traced large numbers of infected ships uniting with the infected of other races and combining forces to attack Minex fleets." }
	}
	questions[61102] = {
		action="jump", goto=61001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="Why those who are virus-infected gain a compulsion to attack the Minex",
		alien={"We have no idea.  This is very different from their previous behavior of drifting aimlessly.  Since the mad-ones exhibit telepathic behavior, the current theory is that a vast invisible consciousness in space might be directing them." }
	}
	questions[61200] = {
		action="jump", goto=61001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"No.  The Coalition has been more dramatically weakened by warfare and the infection than we have been.  They maintain patrols but they are no longer an effective fighting force.  They have conducted no attacks that we aware after the Minex cessation of hostilities." }
	}
	questions[61300] = {
		action="jump", goto=61001,
		player="[AUTO_REPEAT]",
		playerFragment="about the isolation procedures you have implemented",
		alien={"The exact details are confidential but population density seems to be the key to fatalities from this infection.  Most cities have had their populations scattered and quarantined throughout the countryside.  Cyclical madness still occurs but the Bar-zhon people survive." }
	}
	questions[61400] = {
		action="jump", goto=61001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how your economy has been dampened", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"With no major external threats to motivate the people and a scattered and quarantined population going insane on a regular basis, productivity has been difficult to maintain." }
	}



end

if (plot_stage == 1) then  -- initial plot state

	questions[11001] = {
		action="branch",
		choices = {
			{ text="Your empire",  goto=11000 },
			{ text="Your biology", goto=12000 },
			{ text="Your government", goto=13000 },
			{ text="Trade", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
		questions[12000] = {
		action="jump", goto=11001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about your biology",
		alien={"Our biology is our concern and no interest of yours." }
	}


elseif (plot_stage == 2) or (plot_stage == 3) or (plot_stage == 4) then -- virus, war, or ancients plot states


	questions[11001] = {
		action="branch",
		choices = {
			{ text="Your empire",  goto=11000 },
			{ text="Your government", goto=13000 },
			{ text="Trade", goto=14000 },
			{ text="Current news",  goto=60000 },
			{ text="<Back>", goto=1 }
		}
	}

end


	questions[11000] = {
		action="jump", goto=11001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about your empire",
		alien={"Our territory is vast and our industrial and military might unmatched by all.  Freedom and justice prevail throughout the system of industrialized planets and their colonies, for no planet is taken advantage of or unfairly taxed by another." }
	}

	questions[13000] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		playerFragment="what system of government you have", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"A centralized imperium, however in practice our government operates as a coordinated federation.  The cohesiveness we share is not a matter of taxation or enslavement by the multitude of worlds united by a similar cultural system." }
	}
	questions[14000] = {
		action="jump", goto=14101,
		player="[AUTO_REPEAT]",
		playerFragment="what your people offer for trade", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"Our people have a strict noninterference policy towards less developed races such as yourselves.  Your world was discovered and has been shielded by our fleet until which time you developed space flight.  The unexpectedly advanced technology and weaponry your ship possesses must be analyzed." }
	}

	questions[14101] = {
		action="branch",
		choices = {
			{ text="Why not trade with us?",  goto=14110 },
			{ title="<THREATEN>", text="Less developed?  I'll show you how less-developed we are!", goto=14120 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[14110] = {
		action="jump", goto=14101, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="why your race will not trade with us", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"Of course we will, but first your species must be categorized properly and trade goods which will not be unnecessarily disruptive to your species must be found." }
	}
	questions[14120] = {
		action="jump", goto=999,  ftest= 3, -- aggravating, attack
		player="[AUTO_REPEAT]",
		alien={"Terrorist threats will not be tolerated.  Force must be met with force." }
	}

if (plot_stage == 1) then  -- initial plot state

	questions[21001] = {
		action="branch",
		choices = {
			{ text="The Coalition",  goto=21000 },
			{ text="The Tafel",  goto=22000 },
			{ text="The Nyssian",  goto=23000 },
			{ text="<More>",  goto=21002 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21002] = {
		action="branch",
		choices = {
			{ text="The Minex",  goto=24000 },
			{ text="The Thrynn and Elowan",  goto=25000 },
			{ text="The Spemin",  goto=26000 },
			{ text="Other pirates",  goto=27000 },
			{ text="<Back>", goto=1 }
		}
	}

elseif (plot_stage == 2) or (plot_stage == 3) or (plot_stage == 4) then  -- virus, war, or ancients plot states

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Current news",  goto=60000 },
			{ text="The Coalition",  goto=21000 },
			{ text="The Tafel",  goto=22000 },
			{ text="<More>",  goto=21002 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21002] = {
		action="branch",
		choices = {
			{ text="The Nyssian",  goto=23000 },
			{ text="The Minex",  goto=24000 },
			{ text="The Thrynn and Elowan",  goto=25000 },
			{ text="The Spemin",  goto=26000 },
			{ text="<Back>", goto=1 }
		}
	}
end


	questions[21000] = {
		action="jump", goto=21005, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the Coalition",
		alien={"We must warn you about an annoyance you may find in our area of space.  Currently our empire is experiencing minor guerrilla warfare from a minor faction of malcontents, self-titled 'The Coalition.'" }
	}
	questions[21005] = {
		action="jump", goto=21101,
		player="[AUTO_REPEAT]",
		alien={"The rebels are a group of malcontents and pirates which hide inside our vast territory.  Utilizing and rebuilding many of the scrapped mining equipment and shipyards of the three imperialists they pose a constant but minimal threat to the law-abiding sentients of this sector." }
	}
	questions[22000] = {
		action="jump", goto=22100,
		player="[AUTO_REPEAT]",
		playerFragment="about the Tafel",
		alien={"The Tafel are a disgustingly primitive group of collectivists.  Their primitive and emotional culture has a penchant for extreme shifts that makes them untrustworthy. The sole redeeming value is their incredible mining ability." }
	}
	questions[22100] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		alien={"We traded the Tafel antiquated trinkets and junk for vast amounts of radioactive wastes and other trinkets.  They are a prolific and insidious species which one day may become dangerous.  We have recently lost all contact with them." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Nyssian",
		alien={"The Nyssian are a harmless nomadic and secretive people who number in the low thousands.  Their technologies are antiquated, their people weak willed and divided, and their wisdom fractured and contradictory.  Do not bother with them." }
	}
if (plot_stage == 1) or (plot_stage == 2) then  -- initial or virus plot states

	questions[24000] = {
		action="jump", goto=24100,
		player="[AUTO_REPEAT]",
		playerFragment="about the Minex",
		alien={"Minex culture is an enigma.  They do not travel and have never expanded their territory.  Encroaching on space yields fierce opposition, yet they hold no apparent hostility." }
	}

elseif (plot_stage == 3) or (plot_stage == 4) then -- war or ancients plot states

	questions[24000] = {
		action="jump", goto=24100,
		player="[AUTO_REPEAT]",
		playerFragment="about the Minex",
		alien={"Minex xenophobia is total.  They do not communicate, do not act, and cannot be dealt with." }
	}

end

	questions[24100] = {
		action="jump", goto=21002,
		player="[AUTO_REPEAT]",
		alien={"As far as we can determine, the Minex culture has been static and unchanging since our earliest days of space travel.  From what are a few successful probes have shown their populations and fleets are vast." }
	}
	questions[25000] = {
		action="jump", goto=21002,
		player="[AUTO_REPEAT]",
		playerFragment="about the Thrynn and Elowan",
		alien={"The Thrynn and Elowan savages are both barely sentient warmongers with no industrial base to speak of.  Their frail industries barely support their tattered ships.  One day if an empire decided to conquer them, they would discover how similar they actually are to each other." }
	}
	questions[26000] = {
		action="jump", goto=21002,
		player="[AUTO_REPEAT]",
		playerFragment="about the Spemin",
		alien={"The Spemin blobs are innocent and truly nonsentient organisms which only mimic communication, technology and behavior.  They rely on insane breeding rates and Darwinism to kill off the non-effective.  They truly cannot think for themselves, so don't bother with them." }
	}
	questions[27000] = {
		action="jump", goto=21002,
		player="[AUTO_REPEAT]",
		playerFragment="about other pirates",
		alien={"Various pirate clans composed of members from all the alien species occasionally traverses the un-patrolled areas of space.  Don't take it personally if an alien ship simply decides to attack you.  It's likely not affiliated with the hierarchy of its species." }
	}

	questions[21101] = {
		action="branch",
		choices = {
			{ text="How can the coalition hide?",  goto=21100 },
			{ text="Where are they?",  goto=21200 },
			{ text="How dangerous is the coalition?",  goto=21300 },
			{ text="Members of your own race make up this coalition?",  goto=21400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[21100] = {
		action="jump", goto=21101,
		player="[AUTO_REPEAT]",
		playerFragment="how are they able to hide inside your territory", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"Only with constant espionage to keep up with our technological advances and through careful random and emissionless construction.  Silhouettes of their ships and structures are extremely erratic and disguised as asteroids or floating debris." }
	}
	questions[21200] = {
		action="jump", goto=21201,
		player="[AUTO_REPEAT]",
		playerFragment="where are they located", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"They primarily roaming platforms and ships in asteroid fields or a large asteroids, making them very difficult to find and eliminate.  Many attempts have been made to wipe them out but have only served to cull their numbers." }
	}
	questions[21201] = {
		action="jump", goto=21101, ftest= 3, -- aggravating
		player="Surely sensors can detect life or energy signatures?",
		alien={"Life signs can be masked with sufficient shielding.  Energy signatures can be hidden as long as no propulsion is used.  Efforts to dragnet sectors are discovered and patrols avoided.  Simple communication signals can be undetectably embedded inside our own communication network." }
	}
	questions[21300] = {
		action="jump", goto=21101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how dangerous is the coalition?",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"The coalition is not a true threat to us, only an annoyance.  They are wise enough to avoid clashes with our military, but we tell you about them since they often seek out and attack individual vessels, especially newcomers to this area." }
	}
	questions[21400] = {
		action="jump", goto=21101, ftest= 3, -- aggravating
		player="So members of the Bar-zhon people make up the coalition?",
		alien={"Only malcontents from the worker caste working with technicians of the alien cultures in our populations.  This pattern of rebellion has occurred before.  Unfortunately it is impossible to keep determined individuals earthbound, and this pirating culture has formed." }
	}

if (plot_stage == 1) then


	questions[31001] = {
		action="branch",
		choices = {

			{ text="Which races were involved?",  goto=31002 },
			{ text="Story of The Great War",  goto=31003 },
			{ text="<Back>", goto=1 }
		}
	}

elseif (plot_stage == 2) or (plot_stage == 3) or (plot_stage == 4) then


	questions[31001] = {
		action="branch",
		choices = {

			{ text="Races that were involved",  goto=31002 },
			{ text="Story of The Great War",  goto=31003 },
			{ text="Current news",  goto=60000 },
			{ text="<Back>", goto=1 }
		}
	}
end


	questions[31002] = {
		action="jump", goto=31101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="which races were involved in this Great War",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"The Great War involved a conflict between four of the five major powers in the region.  Ourselves, the Minex, the Transmodra, the Sabion, and the Bx.  The last three races were known collectively as the Three Imperialists." }
	}
	questions[31003] = {
		action="jump", goto=31004, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="the full story of The Great War",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"The Transmodra formed the backbone of the imperialist alliance against us and the most terrible atrocities did they commit.  Biological warfare was their specialty.  Over a dozen Bar-zhon worlds did they extinguish before our people could fully mobilize." }
	}
	questions[31004] = {
		action="jump", goto=31005, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"The elite corps of the Bar-zhon Navy was created, replacing the old Guardian Corp. the noblest families in the finest tradition of our history have been trained since birth to glide and fight in the starry skies." }
	}
	questions[31005] = {
		action="jump", goto=31006, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"The workers party was thrown down from office and control of our glorious empire given back to its rightful heirs.  The temporary slave camps and razing of the useless extravagances of the past were fully necessary and saved countless lives despite the minor cultural turmoil they caused." }
	}
	questions[31006] = {
		action="jump", goto=31007,
		player="[AUTO_REPEAT]",
		alien={"Within five years the Bar-zhon held their own and completely halted the imperialists advance.  A holding force was maintained while our people secretly built a tremendous fleet." }
	}
	questions[31007] = {
		action="jump", goto=31008,
		player="[AUTO_REPEAT]",
		alien={"After a particularly powerful wave was repelled, our people took a desperate gamble.  The entire defensive fleet was consolidated and combined with the secret fleet and sent at flank speed to the Transmodra home world." }
	}
	questions[31008] = {
		action="jump", goto=31009,
		player="[AUTO_REPEAT]",
		alien={"After overwhelming defensive forces, mass drivers razed all population and industrial centers.  Mop up operations took little effort and the entire Transmodra industrial machine was quickly under Bar-zhon control." }
	}
	questions[31009] = {
		action="jump", goto=31010,
		player="[AUTO_REPEAT]",
		alien={"This maneuver split the Sabion and the Bx forces in half and effectively won the tactical war.  Unfortunately the Sabion and the Bx refused to surrender." }
	}
	questions[31010] = {
		action="jump", goto=31011,
		player="[AUTO_REPEAT]",
		alien={"The two remaining races maintained unprovoked hit-and-run attacks for an additional two years coordinated from the BX headquarters at 58N X 96E before their home worlds were overrun and industrial forces stopped." }
	}
	questions[31011] = {
		action="jump", goto=31012, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"Unwilling to let these races ever become a threat again, the entire populations of the three industrialists were relocated onto Bar-zhon colony worlds, where they continue to thrive to this day." }
	}
	questions[31012] = {
		action="jump", goto=31013, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"Control of our government has remained firmly in the claws of the Imperial Navy, and we have successfully prevented any catastrophic mistakes from ever threatening our people again." }
	}
	questions[31013] = {
		action="jump", goto=31001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="if the events of the war led to the creation of the Coalition", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"An insightful question indeed, and it is true.  The worker caste working with technicians of the alien cultures in our populations at several times in our recent history attempted to form rebellions which always failed miserably.  The coalition is their latest attempt." }
	}
	questions[31101] = {
		action="branch",
		choices = {
			{ text="What about the fifth power?",  goto=31100 },
			{ text="Why the war began.",  goto=31200 },
			{ text="Weren't there other races?",  goto=31300 },
			{ text="Your people defeated everyone?",  goto=31400 },
			{ text="<Back>", goto=31001 }
		}
	}
	questions[31100] = {
		action="jump", goto=31102,
		player="[AUTO_REPEAT]",
		playerFragment="what do you mean about only four of the five powers",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"The Minex remained neutral throughout the conflict, neither worrying nor caring of the consequences to their own empire if we lost.  We discovered later that they repulsed several skirmishes into their territory but only fought defensively." }
	}
	questions[31102] = {
		action="jump", goto=31101, ftest= 3, -- aggravating
		player="What about the Nyssian?",
		playerFragment="about the Nyssian?  Aren't they an ancient race?",
		alien={"Ha!  Ancient, maybe.  Relevant, no.  Those so-called anti-materialists strip mined their world and polluted it to the point that only a few escaped the devastation.  Their lifespan and their race are only maintained through cryogenic stasis." }
	}
	questions[31200] = {
		action="jump", goto=31101,
		player="[AUTO_REPEAT]",
		playerFragment="what started off the war", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"In the ancient past our sphere of influence was far less and much greater challenges were our people faced with.  A coalition of three upstart imperialists decided, completely unprovoked, to expand their territory directly into our area space." }
	}
	questions[31300] = {
		action="jump", goto=31101,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races now in this sector",
		alien={"Your people had yet to develop space flight.  The Tafel were also still mucking around scratching dirt on their lava world.  The Spemin?  Weaponless incomprehensible savages.  The Thrynn and the Elowan did not show up on the scene until later." }
	}
	questions[31400] = {
		action="jump", goto=31101, ftest= 2,-- insightful
		player="[AUTO_REPEAT]", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		playerFragment="how your people defeated a coalition of races allied against you",
		alien={"Yes, the Bar-zhon people met this challenge unwaveringly and without hesitance.  Only we accepted the challenge of defending the liberty of the sector.  Great and heroic our countrymen acted in those days.  Glorious were our many victories." }
	}


end




function QuestDialogueinitial()


--[[
title="Military Mission #30:  We are seeking an afterburner - possess the afterburner."
--]]

	questions[74000] = {
		action="jump", goto=1, ftest= 1,
		player="We have a coalition afterburner unit for you.",
		alien={"Excellent work.  Your species shows considerable promise.  " }
	}

	questions[74005] = {
--		artifact20 = 0,
--		active_quest = active_quest + 1,
--		ship_shield_class = ship_shield_class + 1,
		action="jump", goto=1, ftest= 1,
		player="Transferring the unit now.",
		alien={"For your efforts I have been authorized to enhance the defensive shielding of your vessel. (Mission Completed)" }
	}
	questions[74006] = {
--		artifact20 = 0,
--		active_quest = active_quest + 1,
--		ship_shield_class = ship_shield_class + 1,
		action="jump", goto=1, ftest= 1,
		player="Transferring the unit now.",
		alien={"We are unable to improve the efficiency of your shields, but we are willing to provide you a monetary award of energy crystals. (Mission Completed)" }
	}

--[[
title="Military Mission #35:  Making an offer on Minex Electronics"
--]]


	questions[79000] = {
		action="jump", goto=79001,
		player="Are you interested in a Minex electronics system?",
		alien={"Yes [CAPTAIN].  We are very interested in Minex technology.  We will be willing to upgrade your missiles to class 6 in exchange for the artifact." }
			}

	questions[79001] = {
		action="branch",
		choices = {
			{ text="Okay, it's yours.",  goto=79100 },
			{ text="No thanks.",  goto=79200 },
		}
	}
	questions[79100] = {
		action="jump", goto=1, ftest= 1,
--		artifact22 = 0,
--		active_quest = active_quest + 1,
--		ship_missile_class = 6 or endurium += 35
		player="[AUTO_REPEAT]",
		alien={"You will not regret this decision.  Our engineers are being sent over your ship as we speak." }
	}
	questions[79105] = {
		action="jump", goto=1, ftest= 1,
		player="Transferring the unit now.",
		alien={"For your efforts I have been authorized to provide you with the top missile technology of our empire.  (Mission Completed)" }
	}
	questions[74106] = {
		action="jump", goto=1, ftest= 1,
		player="Transferring the unit now.",
		alien={"We are unable to improve the missile technology of your vessel, but we are willing to provide you a monetary award of energy crystals.   (Mission Completed)" }
	}
	questions[79200] = {
		action="jump", goto=1, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Very well." }
	}

--[[
title="Scientific Mission #29:  first contact"
--]]

	questions[83000] = {
		action="jump", goto=83002,
		title="First Contact",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"Bar-zhon Naval vessel to unknown craft. We acknowledge your hail and wish to establish peaceful relations with your people." }
	}
	questions[83002] = {
		action="jump", goto=83001,
		player="We are on a mission to contact other sentient races!",
		alien={"We acknowledge also that you have succeeded with this intention today.  Now is there anything else we can do for you? " }
	}
	questions[83001] = {
		action="jump", goto=1, ftest= 1,
--		ship_engine_class = ship_engine_class + 1
--		artifact15 = 0
--		active_quest = active_quest + 1
		player="We wanted to return the data system that we discovered.",
		alien={"The Bar-zhon people appreciate your efforts and your friendliness.  In return I am authorized to offer you technical data that may improve the efficiency of your ship's engines.  We hope that future relationships between our people may progress in like manner.   (Mission Completed)" }
	}

--[[
title="Scientific - The shipping invoice"
--]]

	questions[84000] = {
		action="jump", goto=84002,
		title="Shipping Invoice",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		player="[AUTO_REPEAT]",
		playerFragment="about this shipping invoice that we found",
		alien={"Bar-zhon Naval vessels are not in the business of cargo transport nor are we interested in every curio artifact others may run across." }
	}
	questions[84002] = {
		action="jump", goto=84001,
		player="<More>",
		alien={"However you are new in this region of space and we are always willing to help developing races. This is a credit slip for 40 cubic meters of Thorium from the Tafel bank of Lesstwin." }
	}
	questions[84001] = {
		action="jump", goto=1, ftest= 1,
--		artifact381 = 0
		player="Where may we find Lesstwin?",
		alien={"The Tafel race has recently become completely ... umm ... uncommunicative and will more likely attempt to destroy your ship than do business with you. Your best option is to find an oceanic world and mine the mineral yourself." }
	}

--[[
title="Science Mission #31:  Returning the Whining orb"
--]]

	questions[85000] = {
		action="jump", goto=85001,
		player="Locating the Whining orb",
		introFragment= "Bar-zhon vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have a scientific inquiry concerning a device you may be aware of.",
		playerFragment= "about a whining orb",
		alien={"Yes.  Such a device is a primitive communications code breaker for one unique type of code that we've never been able to find.  Our current communication systems far surpasses its capacity and we have fully integrated it's abilities into our software centuries ago on the chance we would ever found a use for it.   The original device was stolen out of one of our museums recently. " }
	}
	questions[85001] = {
		action="jump", goto=85002,
		player="Can you tell us where Lazerarp is?",
		playerFragment="about the location of Lazerarp",
		alien={"Please classify that label.  Our systems do not understand the word.  What is a Lazerarp? " }
	}
	questions[85002] = {
		action="jump", goto=1,
		player="Lazerarp is supposedly a planet.",
		alien={"I still am unable to find any reference or even a partial match utilizing any derivation of that label.  Go bother the Nyssian.  A few of their ships wander the empty territory downspin of our own.  If any race knows unusual or dead languages it would be them." }
	}

--[[
title="Science Mission #35:  Locating an exotic planet"
--]]


	questions[89000] = {
		action="jump", goto=89001,
		player="Locating an exotic planet",
		playerFragment="how to decode this data on exotic particles",
		alien={"Your search is foolhardy.  Exotic matter has been proven not to exist and this scan data is most likely a forgery." }
	}
	questions[89001] = {
		action="jump", goto=1, ftest= 3, -- aggravating
		player="Could you analyze the data anyway?",
		alien={"The broken nature of this information also suggests an attempt to hide discrepancy in the data.  Oh well, if you wish to pursue this further I am able to match the planet type against known acidic planets in our database.  Nothing else.  Don't bother me with this anymore." }
	}

--[[
title="Freelance Mission #29:  Returning the Whining orb - hint"
--]]

	questions[93000] = {
		action="jump", goto=93001,
		player="A Whining orb",
		introFragment= "Bar-zhon vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment= "about a whining orb",
		alien={"Yes.  Such a device is a primitive communications code breaker for one unique type of code that we've never been able to find.  Our current communication systems far surpasses its capacity.  We have fully integrated it's abilities into our software centuries ago on the chance we would ever found a use for it.   The original device was stolen out of one of our museums. " }
	}
	questions[93001] = {
		action="jump", goto=93002,
		player="Also could you tell us where Lazerarp is? ",
		alien={"Please classify that label.  Our systems do not understand the word.  What is a Lazerarp? " }
	}
	questions[93002] = {
		action="jump", goto=1,
		player="Lazerarp is supposedly a planet.",
		alien={"I still am unable to find any reference or even a partial match utilizing any derivation of that label.  Go bother the Nyssian.  A few of their ships wander the empty territory downspin of our own.  If any race knows unusual or dead languages it would be them." }
	}

--[[
title="Freelance Mission #29:  Returning the Whining orb - in possession of the orb"
--]]
	questions[93500] = {
		action="jump", goto=93501, ftest= 3, -- aggravating
		player="Can you tell us about...",
		playerFragment= "...",
		alien={"Halt!  Our scanners indicate that you are trafficking in stolen merchandise.  You will immediately return the whining orb or face consequences. " }
	}
	questions[93501] = {
		action="branch",
		choices = {
			{ text="Sure, go ahead and take it.",  goto=93600 },
			{ text="No.",  goto=93700 },
			{ title="35 units of endurium",  text="We are willing to return this device for 35 units of endurium.",  goto=93800 },
		}
	}
	questions[93600] = {
--		artifact16 = 0,
--		active_quest = active_quest + 1,
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"You have done well to submit to our authority.   (Mission Completed)" }
	}

	questions[93700] = {
--		attitude = 20,
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		alien={"You have been classified as a pirate and appropriate measures will be taken." }
	}
	questions[93800] = {
		action="jump", goto=93501,
		player="[AUTO_REPEAT]",
		alien={"No reimbursement will be made for stolen merchandise.  You must return this artifact immediately." }
	}

--[[
title="Freelance Mission #31:  Coalition afterburner"
--]]
	questions[95000] = {
		action="jump", goto=1, ftest= 1,
--		artifact20 = 0,
--		active_quest = active_quest + 1,
--		ship_shield_class = ship_shield_class + 1,
		player="I have a coalition afterburner unit for you.",
		alien={"Excellent work.  Your species shows considerable promise.  I have been authorized to enhance the defensive shielding of your vessel in exchange. " }
	}


	questions[95005] = {
--		artifact20 = 0,
--		active_quest = active_quest + 1,
--		ship_shield_class = ship_shield_class + 1,
		action="jump", goto=1, ftest= 1,
		player="I'm sending it by the transporter now.",
		alien={"Due to your efforts I will provide you enhancements for the defensive shielding of your vessel.  (Mission Completed)" }
	}
	questions[95006] = {
--		artifact20 = 0,
--		active_quest = active_quest + 1,
--		ship_shield_class = ship_shield_class + 1,
		action="jump", goto=1, ftest= 1,
		player="I'm sending it by the transporter now.",
		alien={"We are unable to improve the efficiency of your shields, but we are willing to provide you a monetary award of energy crystals.   (Mission Completed)" }
	}

--[[
title="Freelance Mission #34: Pawning off artistic containers"
--]]

	questions[98000] = {
		action="jump", goto=98001,
		player="Are you interested in incredibly old artistic containers?",
		introFragment= "Bar-zhon vessel.  This is Captain [CAPTAIN].  We have acquired a collection of artifacts of inestimable value.  You will be astounded by these incredibly old and wondrous artistic containers",
		playerFragment="something in exchange it",  fragmentTable= preQuestion.desire,
		alien={"Perhaps ... yes.  These appear to be of primitive Nyssian origin." }
	}
	questions[98001] = {
		action="branch",
		choices = {
			{ text="Nyssian? I would not accept less than 15 endurium.",  goto=98100 },
			{ text="I am willing to sell them for 12 endurium.",  goto=98200 },
			{ text="Nevermind", goto=1 }
		}
	}
	questions[98100] = {
--		artifact18 = 0,
--		player_money = player_money + 15000,
--		active_quest = active_quest + 1,
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Confirmed.   (Mission Completed)" }
	}
	questions[98200] = {
--		artifact18 = 0,
--		player_money = player_money + 12000,
--		active_quest = active_quest + 1,
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Agreed.  This pottery is nearly identical to fragments we traced back to the Nyssian homeworld.  Good exchange.   (Mission Completed)" }
	}
--[[
title="Freelance Mission #35:  Resolving the Bar-zhon Elowan conflict - Initial"
--]]

	questions[99000] = {
		action="jump", goto=99001,
		player="Tell us about the Elowan Bar-zhon conflict",
		playerFragment="about the Elowan Bar-zhon conflict",
		alien={"This is a nonissue.  We staked the initial claim and were first in establishing a colony at Aircthech III.  The primitive Elowan established another colony after ours on the other side of the planet.  Now they are making nonsensical statements and threats." }
	}
	questions[99001] = {
		action="jump", goto=99002,
		player="What do they threaten you with?",
		alien={"The Elowan accuse us of polluting the air with particulate matter.  Bar-zhon industrial technology is very advanced and does not generate visible pollution.  The primary output of our factories are noble gases and carbon dioxide, not any pollutant.  Our colony is well defended and if the Elowan decide to attack they will be annihilated." }
	}
	questions[99002] = {
		action="jump", goto=1,
		player="Can't you negotiate with them?",
		alien={"It is not possible.  The Elowan make no other demands other than their single irrational assertion.  Their ships are attempting to blockade our transports and a military conflict appears inevitable.  We have no objection if you wish to attempt to make them see reason."}
	}

--[[
title="Freelance Mission #35:  Resolving the Bar-zhon Elowan conflict -  after probe"
--]]

	questions[99500] = {
		action="jump", goto=1,
		player="We located this Thrynn probe which delivered the dust.",
		alien={"Good.  Take this to the Elowan and give it to them.  As long as the Elowan cease their harassment and protests, we are more than willing to peacefully cohabitate this planet."}
	}


end

function QuestDialoguevirus()


--[[
title="Special Encounter with inspector Borno"
--]]
	questions[90000] = {
		action="jump", goto=90002,
		title="Greetings",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are ...",
		playerFragment="what type of huge dreadnought is that?  I have never seen a ship so large", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Pretty expensive disguise, Xenon. You think I can't see thru that cheap theatrical effect?" }
	}
	questions[90002] = {
		action="jump", goto=90001,
		title="Deny",
		player="This is Captain [CAPTAIN], not some pirate.  I am a fully authorized representative of Myrrdan ",
		alien={"An unlikely story.  Be aware Xenon that I am fully aware of your holographic ship disguises!  You will not fool me again!" }
	}
	questions[90001] = {
		action="branch",
		choices = {
			{ title="Assert", text="This is a Myrrdan starship. We have nothing to do with this Xenon character you seek.", goto=92000 },
			{ title="Threaten", text="You do not worry us.  Myrrdan vessels know how to deal with those who make crazy assertions!", goto=93000 },
			{ title="Tracking Device?", text="How did you find us?", goto=94000 },
			{ title="Prove", text="This is ridiculous. My ship is real. Transport a crew member over to my ship and they will testify to it.", goto=91000 },
			{ text="<END COMM>", goto=999 }
		}
	}
	questions[91000] = {
		action="jump", goto=91001,
		player="[AUTO_REPEAT]",
		alien={"Xenon, do you think I am stupid enough to fall for the old, 'Transport a nonessential crew member wearing a red shirt over to us so we can hold a gun to his head and make him say anything we want him to say' trick? -- Transport one of your crew over here first. -- Make that a non-human crew member since Xenon and his crew are all human." }
	}
	questions[91001] = {
		action="jump", goto=91002, ftest= 2, -- insightful
		player="Myrrdan crew are all human",
		alien={"Ohh, I forgot about that." }
	}
	questions[91002] = {
		action="jump", goto=95000, ftest= 1, -- remove artifact390 - tracking device
		player="Just launch an automated probe",
		alien={"Clever, most clever. You think to trick me into believing...Hmm...Actually my probe reports that your ship is solid and not a holographic projection. Sorry about that Capt. [CAPTAIN].  We inspectors can't be too careful.  You picked up a tracking device that Xenon was supposed to have picked up instead.  Now how may I be of service to you today?" }
	}
	questions[92000] = {
		action="jump", goto=90001,
		player="[AUTO_REPEAT]",
		alien={"Don't try trickery Xenon.  Myrrdan ships are human.  You and your pirates are human. Obviously there is a link, isn't there?" }
	}
	questions[93000] = {
		action="jump", goto=999, ftest= 1, -- make the entire Bar-zhon race hostile to the player
		player="[AUTO_REPEAT]",
		alien={"This is Alonso Borno, Bar-zhon Ministry of Internal Security, to all supporting craft. I order you in all haste to immediately and without delay open fire upon this dastardly pirate vessel. If for some reason you are unable to open fire, you are ordered to close range with this dastardly pirate at top speed..." }
	}
	questions[94000] = {
		action="jump", goto=94001,
		player="[AUTO_REPEAT]",
		alien={"You admire my ingenuity Xenon, don't you?  It so happened that I planted that ancient artifact in Myrrdan territory next to a signaling device. I knew that you could not resist." }
	}
	questions[94001] = {
		action="jump", goto=94002,  ftest= 1, -- remove artifact390 - tracking device
		player="Why couldn't a Myrrdan ship run across the artifact first?",
		alien={"Perhaps, but perhaps not. We both know that you are far too clever to let someone else beat you to a lucrative goal." }
	}
	questions[94002] = {
		action="jump", goto=90001,
		player="We found a message for you from Xenon",
		alien={"I cannot be reasoned ... umm ... tricked by such a message. Perhaps you simply think fast on your feet and created such a message on the fly just now. Can any other ship besides yourself verify the existence of such a message?  And even if it actually does exist couldn't you still be the one who left the message?  This does not prove that you are not Xenon!" }
	}
	questions[95000] = {
		action="branch",
		choices = {
			{ title="Inspector", text="Who are you and why do you have such a huge dreadnought?", goto=96000 },
			{ title="Xenon", text="What can you tell us about Xenon?", goto=97000 },
			{ title="Virus", text="Could you tell us about this virus that appeared recently?", goto=98000 },
			{ title="Hints", text="Could you give us any hints or tips?", goto=99000 },
			{ text="<END COMM>", goto=997 }
		}
	}
	questions[96000] = {
		action="jump", goto=95000,
		player="[AUTO_REPEAT]",
		alien={"I am the famous Alonso Borno, Bar-zhon Ministry of Internal Security, scourge to pirates, malcontents, and all manner of trouble makers everywhere.  As the nephew of the current monarch, fate has allowed all of Bar-zhon society to fully recognize my innate brilliance and cunning intellect and reward me with the enormous responsibilities my superior talents have given me the capacity to handle. This flagship of internal security and it's attached fleet vessels are currently hunting the infamous human pirate Xenon."  }
	}
	questions[97000] = {
		action="jump", goto=97001,
		player="[AUTO_REPEAT]",
		alien={"Xenon a.k.a. Harrison is the worst possible Myrrdan criminal, the most notorious scoundrel that the entire universe has ever faced. He is brilliant, has access to technology that no one has seen before, and has a sadistic pleasure in infiltrating deeply into organizations to steal their most vital secrets, pilfer their supplies, and run off with their most valuable equipment."  }
	}
	questions[97001] = {
		action="jump", goto=95000,
		player="Harrison?",
		alien={"He uses a dozen other aliases but his pirate followers will frequently use the handle Harrison, while he will more frequently use Xenon.  Your security people have been unable to find even a trace or hint of his origins and his ships are subtly but significantly different from Myrrdan designs.  My people speculate that he and his followers are not originally from Myrrdan, but we have no other evidence of this."  }
	}
	questions[98000] = {
		action="jump", goto=98001,
		player="[AUTO_REPEAT]",
		alien={"This virus is nasty stuff, nasty, nasty stuff.  Xenon collaborates with the Coalition and they are undoubtedly behind the release of some ancient biological weapon uncovered in some archaeological dig somewhere."  }
	}
	questions[98001] = {
		action="jump", goto=95000,
		player="<More>",
		alien={"You did not hear this from me but the Bx home world is where the answers are. It is the site of the last fortress of the Coalition to fall and all of their technological archaeological finds were taken there.  They placed traps operational to this day that target Bar-zhon genetics but your people should be safe enough. My computers don't have the information but you should talk to our regular Navy and maybe the Coalition if you must, but find that fortress."  }
	}

	questions[99000] = {
		action="jump", goto=95000,
		player="[AUTO_REPEAT]",
		alien={"You wish to receive some great wisdom or insight into your mission to cure the galaxy?  I'm sorry, the mission of internal security does not entail finding cures to diseases. I guess I could tell you that the mace constellation is centered around 200, 105, or that when other Bar-zhon discuss the history of the great war they sometimes divulge important state secrets such as important planetary coordinates. I of course will not even discuss the great war so do not even ask."  }
	}

--[[
title="Mission #37:  Catching the Smugglers"
--]]
	questions[77000] = {
		action="jump", goto=1,
		title="Catching the Smugglers",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are on official Myrrdan business to track down two dangerous criminal starships of our own race.",
		playerFragment="any information that could help us find them",
		alien={"As referenced by the last update of our contact database, the Diligent was last observed in Bar-zhon space heading towards Spemin territory 12 days ago.  The Excelsior was fired upon in retaliation for earlier attacks 4 days ago and haphazardly retreated somewhat outward in the direction of Nyssian space.  This is the extent of my knowledge on the matter.  May we be of any additional service captain?" }
	}

--[[
title="Mission #38:  Collecting Genetic Samples" no coalition data
--]]
	questions[78000] = {
		action="jump", goto=78001,
		title="Genetic Samples",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are working with a team of medical researchers attempting to find a cure for this plague.",
		playerFragment="samples of genetic material from members of your race", fragmentTable=preQuestion.desire,
		alien={"Such a compilation of data could have serious ramifications with regards to regional political stability." }
	}
	questions[78001] = {
		action="jump", goto=78002,
		player="What sort of ramifications?",
		alien={"The Bar-zhon people live under a constant fear of terrorist attacks. Your people probably don't understand this, but it is the result of attempting to completely integrate without segregation diverse groups of alien populations among our own people." }
	}
	questions[78002] = {
		action="jump", goto=78003,
		title="Terrorist Attacks?",
		player="[AUTO_REPEAT]",
		playerFragment="what terrorists attacks have to do with genetic data?", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Tailored bioweapons are the staple of terrorist attacks performed by the races of the three imperialists. Conventional sabotage and weapons are easily detectable and lethal biological warfare is easily filtered but mild biological illnesses are often tailored and targeted to destroy the efficiency of Bar-zhon facilities at times." }
	}
	questions[78003] = {
		action="jump", goto=1,
		title="Exchange for what?",
		player="[AUTO_REPEAT]",
		playerFragment="what could convince you to give up this data", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Only a corresponding and equivalent sampling of genetic data from ALL three races of the active rebel races of the coalition would be sufficient.  We would hold this data in exchange for our own as a pledge that the data we would provide would not be used for terrorist attacks by the coalition." }
	}


--[[
title="Mission #38:  Collecting Genetic Samples" coalition data
--]]
	questions[78500] = {
		action="jump", goto=78501,
		title="Genetic Samples",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are working with a team of medical researchers attempting to find a cure for this plague.",
		playerFragment="a few samples of genetic material from members of your race", fragmentTable=preQuestion.desire,
		alien={"We would be happy to help you in exchange for the collection of Coalition genetic data you have already collected. Are you willing to transport that data over to us now?" }
	}
	questions[78501] = {
		action="branch",
		choices = {
			{ title="Yes", text="Yes, transmitting copies of our data to you now.", goto=78505 },
			{ text="No",  goto=1 },
		}
	}
	questions[78505] = {
		action="jump", goto=78510,  ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Acknowledged and received." }
	}

	questions[78510] = {
		action="jump", goto=1,  ftest= 1,
		player="And your data?",
		alien={"Transmitting medical data now.  Is there any other way we may assist you?" }
	}

--[[
title="Mission #39:  Defensive Alliance, Part 1, initial contact
--]]
	questions[79000] = {
		action="jump", goto=79001,
		title="Defensive Alliance",
		player="[AUTO_REPEAT]",
		introFragment="Greetings, Bar-zhon naval vessel. This is Captain [CAPTAIN] of the starship [SHIPNAME].  Coalition ships are violating our territory and raiding our freighters and transports.",
		playerFragment="how we could make a common cause against them?", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"You first need to speak to the fleet admiral concerning this matter. Do you wish for us to notify him?" }
	}
	questions[79001] = {
		action="branch",
		choices = {
			{ title="Yes", text="Yes", goto=79002 },
			{ text="No",  goto=1 },
		}
	}
	questions[79002] = {
		action="jump", goto=79003,  ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"We are transporting to you a signaling device. Remain in Bar-zhon territory and The Imperial will locate you.  Do you have any other requests at this time?" }
	}


	questions[79003] = {
		action="branch",
		choices = {
			{ title="Yes", text="Yes, I have a few questions on another subject", goto=79004 },
			{ text="No",  goto=997 },
		}
	}
	questions[79004] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"We are at your disposal." }
	}


--[[
title="Mission #39:  Defensive Alliance, Part 1, reestablish with the Fleet Adm.
--]]
	questions[79500] = {
		action="jump", goto=79003, ftest= 1,
		title="Defensive Alliance",
		player="[AUTO_REPEAT]",
		introFragment="Greetings, Bar-zhon naval vessel. This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="the signaling device to contact Fleet Admiral Thrr-zalik?", fragmentTable=preQuestion.desire,
		alien={"We are transporting to you the signaling device again. Remain in Bar-zhon territory and The Imperial will locate you.  Do you have any other requests at this time?" }
	}


--[[
title="Mission #39:  Defensive Alliance, Part 1, Fleet Adm. initial contact
--]]

	questions[79600] = {
		action="jump", goto=79602,  ftest= 1, -- remove Beacon
		player="Greetings, Bar-zhon naval vessel.",
		alien={"Fleet Admiral Thrr-zalik here. Why have you requested this meeting?" }
	}

	questions[79602] = {
		action="jump", goto=79601,
		title="Introduction",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  Coalition ships are violating our territory and raiding our freighters and transports.",
		playerFragment="how we could make a common cause against them?", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"State the terms of your proposal." }
	}

	questions[79601] = {
		action="branch",
		choices = {
			{ title="Shared Enemies", text="We both are experiencing guerrilla attacks by the same enemy.  It only makes sense that we should coordinate our efforts against them.",  goto=79610 },
			{ title="Coalition Overextended", text="The coalition is outside their territory trying to expand into ours. They are more vulnerable if attacked in force in our region of space.",  goto=79620 },
			{ title="Cooperation Benefits", text="combining fleets of Bar-zhon warships with our faster and more maneuverable ships will make a powerful force.",  goto=79630 },
			{ title="Combined Fleets", text="We should make arrangements to combine forces to attack our shared enemy.",  goto=79640 },
		}
	}
	questions[79610] = {
		action="jump", goto=79601,
		player="[AUTO_REPEAT]",
		alien={"Yes... Yes..." }
	}
	questions[79620] = {
		action="jump", goto=79601,
		player="[AUTO_REPEAT]",
		alien={"Perhaps, but at the same time moving our ships into your territory will expose greater weaknesses within ours." }
	}
	questions[79630] = {
		action="jump", goto=79601,
		player="[AUTO_REPEAT]",
		alien={"Coordination and command of combined fleets is always difficult at best." }
	}
	questions[79640] = {
		action="jump", goto=79651,
		player="[AUTO_REPEAT]",
		alien={"So in summary, are you asking for aid?" }
	}


	questions[79651] = {
		action="branch",
		choices = {
			{ title="Yes", text="Yes, I would have to admit we are asking for assistance in fighting off the Coalition.", goto=79652 },
			{ text="No, mutual cooperation",  goto=79653 },
		}
	}
	questions[79652] = {
		action="jump", goto=79661,
		player="[AUTO_REPEAT]",
		alien={"I appreciate a honest assessment of your own limitations and inabilities.  As long as you humans acknowledge that you require our help and that we do not require yours, we have a foundation to build upon. What type of compensation are you offering us in exchange for this aid?"}
	}
	questions[79653] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		alien={"Contact us again when you are grounded back in reality." }
	}


	questions[79661] = {
		action="branch",
		choices = {
			{ title="Gratitude", text="We will express to your people our endless gratitude and appreciation.",  goto=79660 },
			{ title="Alliance", text="Our people would be willing to form an alliance with yours.",  goto=79670 },
			{ title="Endurium Crystals", text="We would be willing to transport a significant number of fuel crystals.",  goto=79680 },
			{ title="Nothing", text="The benefits of such an alliance should be obvious to both of us.  We should not be required to offer anything more.",  goto=79690 },
		}
	}
	questions[79660] = {
		action="jump", goto=79661,
		player="[AUTO_REPEAT]",
		alien={"Gratitude is transitory. Our aid would be substantial. Try again." }
	}
	questions[79670] = {
		action="jump", goto=79661,
		player="[AUTO_REPEAT]",
		alien={"You are negotiating terms of such an alliance. The agreement is not in of itself payment for itself." }
	}
	questions[79680] = {
		action="jump", goto=79681,
		player="[AUTO_REPEAT]",
		alien={"Monetary resources are not required or in limited supply to the Bar-zhon.  If your government is willing to construct a fueling outpost around the gas giant of your home system known as Samhain, for both our use and yours, we will have a deal." }
	}
	questions[79681] = {
		action="jump", goto=79682, ftest= 1, -- provide Observer
		player="Myrrdan tentatively agrees",
		alien={"Before we finalize our agreement, I first have a small task for you, a small demonstration you might say.  Mount this observer-recorder to your vessel and destroy enough Coalition vessels to obtain a Coalition targeting computer." }
	}
	questions[79682] = {
		action="jump", goto=997,
		player="We will return shortly",
		alien={"I will wait with bated breath for your success." }
	}
	questions[79690] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		alien={"Such an attitude is regrettable.  Contact us again if you wish to renegotiate." }
	}



--[[
title="Mission #39:  Defensive Alliance, Part 1, Fleet Adm. after demonstration
--]]

	questions[79700] = {
		action="jump", goto=79701,  ftest= 1, -- remove Beacon
		player="Greetings, Bar-zhon naval vessel.",
		alien={"Fleet Admiral Thrr-zalik here. Awaiting transport of our recording device and a coalition computer." }
	}
	questions[79701] = {
		action="jump", goto=997,  ftest= 1, -- transport Observer and computer, send diplomatic pouch
		player="Transporting now",
		alien={"Excellent work.  Your people have proven yourselves sufficiently capable.  Take this diplomatic pouch describing the terms of our alliance back to your government for ratification." }
	}
--[[
title="Mission #39:  Defensive Alliance, Part 1, no computer
--]]

	questions[79800] = {
		action="jump", goto=79801,
		player="Greetings, Bar-zhon naval vessel.",
		alien={"Have you acquired a coalition targeting computer yet" }
	}
	questions[79801] = {
		action="jump", goto=997,
		player="Not quite yet.",
		alien={"Contact us again when you do." }
	}

--[[
title="Mission #40:  Defensive Alliance, Part 2
--]]

	questions[80000] = {
		action="jump", goto=1,
		title="Defensive Alliance, Part 2",
		player="[AUTO_REPEAT]",
		introFragment="Greetings, Bar-zhon naval vessel. This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are carrying the response of the Myrrdan Governing Council to the proposed alliance.",
		playerFragment="the signaling device to contact Fleet Admiral Thrr-zalik", fragmentTable=preQuestion.desire,
		alien={"We have a message for you from the Admiral. He requests that you proceed to the Bar-zhon city of Nysing where a quorum has been assembled to study the agreement.  Nysing is located at 114S X 23E on the habitable planet in the mace handle." }
	}



--[[
title="Mission #41:  Exotic Datacube
--]]

	questions[81000] = {
		action="jump", goto=1,
		title="Exotic Datacube",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="about this exotic datacube",
		alien={"Welcome allies. This device presents an interesting puzzle. One moment please...  Interpolation of repeated patterns indicates harmonic overtones. Our assessment is that this is a musical database. Very peculiar music and very dissident. No practical value." }
	}

--[[
title="Mission #41:  Organic Database
--]]

	questions[81200] = {
		action="jump", goto=1,
		title="Organic Database",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="about this organic database",
		alien={"The scans you have transmitted indicate that this is nothing more than a failed genetic experiment gone bad. Some forgotten geneticist stasis-storing their Frankensteinian failure. The translated markings stating data storage are obviously intended as some sort of joke in some peculiar form of alien humor." }
	}

--[[
title="Mission #41:  Exotic Datacube and organic database
--]]

	questions[81500] = {
		action="jump", goto=81501,
		title="Exotic Datacube",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="about this exotic datacube",
		alien={"Welcome allies. This device presents an interesting puzzle. One moment please...  Interpolation of repeated patterns indicates harmonic overtones. Our assessment is that this is a musical database. Very peculiar music and very dissident. No practical value." }
	}
	questions[81501] = {
		action="jump", goto=1,
		player="What about this organic database?",
		alien={"The scans you have transmitted indicate that this is nothing more than a failed genetic experiment gone bad. Some forgotten geneticist stasis-storing their Frankensteinian failure. The translated markings stating data storage are obviously intended as some sort of joke in some peculiar form of alien humor." }
	}

--[[
title="Mission #42:  Tracking the Laytonites
--]]

	questions[82000] = {
		action="jump", goto=82001,
		title="Tracking the Laytonites",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are here as representatives of the Myrrdan government seeking a small fleet of rebel Myrrdan terrorists.",
		playerFragment="any information that could help us find them",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"We have no direct contact with any group matching such a description.  Hmm.  Maybe this might be relevant, maybe not." }
	}
	questions[82001] = {
		action="jump", goto=82002,
		title="Relevant Information",
		player="[AUTO_REPEAT]",
		playerFragment="what information you think might be relevant", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"In the last few days there was a report of a clash between a well disciplined pirate force using small short range fighters and a Bar-zhon transport escort upspin of our primary territory.  The transports escaped but the escort vessels were destroyed so only limited sensor data on these 'pirates' is available."}
	}
	questions[82002] = {
		action="jump", goto=1, ftest= 1, -- give the player artifact254: Bar-zhon Pirate sensor data
		title="Location?",
		player="[AUTO_REPEAT]",
		playerFragment="any information on their current location",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"We have no concrete data. However if they are your laytonite terrorists and judging from the implied vector from Myrrdan, they may have been attempting to contact the Coalition.  Transmitting our limited information to you now."}
	}


--[[
title="Mission #43:  Desperate Measures
--]]

	questions[83000] = {
		action="jump", goto=83001,  ftest= 1, -- set attitude to 25
		title="Defensive Measures",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are here on behalf of Myrrdan and have absolute proof that Myrrdan is not responsible for the terrorist attack on your world.",
		playerFragment="that you are willing to listen to our evidence.",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Myrrdan is situated in the center of a hotbed of pirates. It has been long suspected that your people are nothing more than the most technologically advanced group of pirates attempting to stifle all competition.  Your ship personally admitted that factions of your people have become pirates. Your ship personally has recently been traced supplying coalition terrorists.  Why should we believe you?" }
	}
	questions[83001] = {
		action="jump", goto=83002,
		title="Special Cases",
		player="[AUTO_REPEAT]",
		playerFragment="how our actions could compare to the raid of a entire system? We bribed a coalition vessel with a few units of fuel to trace down a few poorly equipped environmentalist fanatics.  We have worked with your people to fight off both Coalition and also unorganized pirates in our area. Coalition and Thrynn ships retrofitted with Myrrdan styled hull plating raided your colony", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Impossible. The Thrynn coalition has recently concluded an alliance with us. They collaborate the report of your attacks."}
	}
	questions[83002] = {
		action="jump", goto=997, ftest= 1, -- give the Bar-zhon a holographic scan
		title="Thrynn Complicit",
		player="[AUTO_REPEAT]",
		introFragment="The Elowan have been tracking a faction of Thrynn collaborating with the Coalition for some time.  Evidence of the retrofit of a large number of Thrynn ships alongside Coalition ships can still be found on Bor Tuatheh 2019.  The Thrynn have been attacking our ships for some time without provocation.",
		playerFragment="what you make of this evidence",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"This will be investigated thoroughly. I will say this however. The fleet dispatched to your home world was ambushed and destroyed enroute. Early investigations show that they were attacked by unknown but non-Myrrdan forces. Until we trace down the guilty party I assure you that your people are safe from us."}
	}
--[[
title="Mission #44:  Decontamination Transporter
--]]

	questions[84000] = {
		action="jump", goto=84001,
		title="Decontamination Transporter",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="about this decontamination transporter you guys requested our help with.",
		alien={"A complete briefing of our situation was sent to your home world previously. In short, we are unable to contact the Elowan for assistance due to our government's official relations with the Thrynn and we need you to relay our request for assistance." }
	}
	questions[84001] = {
		action="branch",
		choices = {
			{ title="Essential Information", text="Is there any other essential information we would need pass on to the Elowan concerning this transporter?", goto=84110 },
			{ title="why do you need help?", text="Can you explain why you need the help of the Elowan?", goto=84120 },
			{ title="Make Changes", text="If you could rebuild someone from their genetic code leaving out all forms of contamination could you not make changes to them?", goto=84130 },
			{ title="(Previous Mission Inquiry)", text="(Previous Mission) Did you guys ever discover who attacked your battle fleet?", goto=84140 },
			{ title="Ready to Assist", text="Please send over to us the information we need to take to the Elowan", goto=84150 }
		}
	}
	questions[84110] = {
		action="jump", goto=84001,
		player="[AUTO_REPEAT]",
		alien={"Everything we need should be listed in the specifications we are ready to send you. One additional thing, the Bliy Skup interlock frequency of Bar-zhon transporters is 5.15 Ghz." }
	}
	questions[84120] = {
		action="jump", goto=84001,
		player="[AUTO_REPEAT]",
		alien={"Very simply the goal of this project is to create a transporter that operates similar to cloning process, except that genetic material must be completely quantifiable.  In particular, the process of gene activation and complete life form construction without template material has proven somewhat difficult." }
		}
	questions[84130] = {
		action="jump", goto=84001,
		player="[AUTO_REPEAT]",
		alien={"Technically nothing prevents modifications other than the inherent difficulties involved in creating stability of form.  Copying one life form into the state of another might be possible.  Making significant and stable changes would require significant more finesse. At this point even the simplest task of reproducing the same exact lifeform requires extremely convoluted calculations requiring outside assistance." }
	}
	questions[84140] = {
		action="jump", goto=84001,
		player="[AUTO_REPEAT]",
		alien={"No.  Based on wreckage recovered the fleet was attacked by Tafel ships.  Unfortunately weapon discharge patterns of every other known race in the galaxy including other Bar-zhon ships were found when examining the debris.  The evidence must have been doctored." }
	}
	questions[84150] = {
		action="jump", goto=997, ftest= 1, -- give the player artifact261: Genetic Transporter Specifications
		player="[AUTO_REPEAT]",
		alien={"Transporting specifications now. Please contact the Elowan at your earliest convenience." }
	}

--[[
title="Mission #44:  Decontamination Transporter - operational code
--]]

	questions[84300] = {
		action="jump", goto=84301, ftest= 1, -- Remove artifact262: operating code
		title="Decontamination Transporter",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="what we should do with this transporter software we received from the Elowan", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Excellent work.  There are significant radical deviations from our expectations, but this could be expected from Elowan technology. This code basically creates through a healing process we dont fully understand.   Please wait." }
	}
	questions[84301] = {
		action="jump", goto=997,  ftest= 1, --  provide artifact264, a data cube
		player="Glad to be of service.",
		alien={"Initial tests show that this operational code works with lower forms of life. We will be conducting additional trials in the future and hope to transport sentients in the next few days if no further issues are discovered. For your assistance, we are providing Myrrdan with a data cube containing the complete specifications of this transporter and all of our research data on this project so far. Please relay this information to your people." }
	}

--[[
title="Mission #44:  Decontamination Transporter - broken code
--]]

	questions[84600] = {
		action="jump", goto=84601, ftest= 1, -- Remove artifact263: broken operating code,
		title="Decontamination Transporter",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="what we should do with this transporter software we received from the Elowan", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Excellent work.  Please wait." }
	}
	questions[84601] = {
		action="jump", goto=997, -- Terminate communications
		player="Glad to be of service.",
		alien={"Initial tests show that this operational code does not achieve even a modicum of stability.  Our chief engineer estimates that the Elowan code is based on false premises. Please inform them that the Bliy Skup interlock frequency of Bar-zhon transporters is 5.15 Ghz." }
	}

--[[
title="Mission #45:  Alien Healthcare Scam - no sample
--]]

	questions[85000] = {
		action="jump", goto=85100,
		title="Plague Treatment",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are investigating reports of a medical treatment that minimizes or stops the periods of madness caused by the plague.",
		playerFragment="about it",
		alien={"Our government was contacted a number of weeks ago concerning this so-called treatment. On the off chance that the treatment was legitimate, our military dispatched the Bar-zhon cruiser Edsezen to meet with the group and investigate their claims." },
	}

	questions[85100] = {
		action="jump", goto=1,
		player="What did they discover?",
		alien={"Absolutely nothing.  Both the Edsezen and the representative of the group disappeared without a trace a few weeks ago.  We suspect Coalition treachery. If in your travels you discover their fate we would appreciate the news." }
	}

--[[
title="Mission #45:  Alien Healthcare Scam - sample
--]]

	questions[85500] = {
		action="jump", goto=85600,  ftest= 1, -- transport drugs sample to alien
		title="Plague Treatment",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are investigating this medical treatment drug that minimizes or stops the periods of madness caused by the plague.  We are transporting over the information needed to synthesize it.",
		playerFragment="about it",
		alien={"We appreciate your effort in recovering the ship's log and also this so-called medical treatment.  The families of the crew no doubt will appreciate your efforts.  Our scientists will investigate its effectiveness in a controlled environment in the near future." }
	}

	questions[85600] = {
		action="jump", goto=1,
		player="How soon will you know anything?",
		alien={"Soon.  Moderately soon.  Reasonably soon.  If you want a more rapid analysis, why not bring this sample to the Elowan?  Their safety standards for medical technology are far more lax and they may be able to give you immediate results." }
	}


end

function QuestDialoguewar()

--[[
title="Mission #48:  Intelligence Collaboration - no Minex Power Core, no data chips
--]]

	questions[78000] = {
		action="jump", goto=78001,
		title="Intelligence Collaboration",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME]. We have compiled a datacube of technological, tactical, and strategic observations of the Minex war machine.  In the interests of all of our survival, we are willing to share this information freely.",
		playerFragment="a collection of similar observations by your people", fragmentTable=preQuestion.desire,
		alien={"Your sensor platforms are ingenious to have been able to gather so much data.  Your Myrrdan engineers must greatly benefit from that scientific culture of yours, as your sensors have proven more effective in piercing the electronic jamming that the Minex dreadnoughts emit then even ours have." }
	}
	questions[78001] = {
		action="jump", goto=78002,
		title="Intelligence Collaboration",
		player="[AUTO_REPEAT]",
		introFragment="Thank you.",
		playerFragment="any conclusions you reach from the data",
		alien={"The power output curve of these new Minex warships is much higher than we have observed just a few months prior to hostilities.  Their fire rate and drive acceleration we suspect are maintained on a short-term basis only by overloading their power core.  If this is true they would be unable to sustain their overwhelming offensive firepower in an extended fleet action.  A large fleet may be able to take advantage of this, but we need confirmation." }
	}
	questions[78002] = {
		action="jump", goto=1,
		player="What can we do?",
		alien={"If you obtain a Minex Power Core either through direct confrontation with them or from another race, bring it to us for investigation." }
	}

--[[
title="Mission #48:  Intelligence Collaboration - Minex Power Core, no data chips
--]]

	questions[78500] = {
		action="jump", goto=1, ftest= 1, -- Remove artifact275: Minex Power Core, give the player artifact276 Bar-zhon Data Chips,
		title="Intelligence Collaboration",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have found a Minex Power Core.",
		playerFragment="about any conclusions you can draw from it",
		alien={"Exactly as predicted!  Minex warships should weaken considerably after roughly 28 minutes in an extended confrontation.  Please relay our conclusions to your leaders with our thanks." }
	}
--[[
title="Mission #49:  Unrest - no flight recorders
--]]

	questions[79000] = {
		action="jump", goto=997, -- terminated
		title="Unrest",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have heard that Coalition ships have been raiding the Thrynn and Elowan.  We are here to determine the truth behind such reports and to offer our services as mediators to their disputes.",
		playerFragment="about the situation",
		alien={"Terrorists and pirates will always operate under the same banner.  Nothing more needs to be said than this: The Coalition thrives on catastrophe and chaos. They grow stronger as we grow weaker, so it is in their best interest to be Minex collaborators.  If you have any doubts, contact the Elowan or the Thrynn and obtain data recordings from them substantiating the attacks." }
	}

--[[
title="Mission #49:  Unrest - at least one flight recorder
--]]

	questions[79500] = {
		action="jump", goto=1,
		title="Unrest",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have heard that Coalition ships have been raiding the Thrynn and Elowan.  We are here to determine the truth behind such reports and to offer our services as mediators to their disputes.",
		playerFragment="about the situation",
		alien={"You have already obtained proof of the Coalition's complicity in these attacks. Nothing else needs to be said upon this subject." }
	}

--[[
title="Mission #53:  Tactical Coordination - initial
--]]

	questions[83000] = {
		action="jump", goto=83001,
		title="Tactical Coordination",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  Did your race transmit a proposal for some type of beneficial collaboration in the war effort?",
		playerFragment="the details of this proposal", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The Bar-zhon fleet command has put together a proposal for a series of wargames to be held cooperatively with all of the races affected by Minex aggression.  After seeing the success that others have had, it is in our best interest to find the strongest tactical ship combinations and strategies to face off Minex battle fleets.  As a member of the only race still unaffected by the plague, would you be willing to take this proposal to those races?" }
	}

	questions[83001] = {
		action="branch",
		choices = {
			{ title="Other's Success?", text="Which others have had success with this concept?", goto=83110 },
			{ title="Which Races", text="Which races do you wish us to contact?", goto=83120 },
			{ title="Myrrdan Fleet", text="Are you not interested in knowing if Myrrdan would participate?", goto=83130 },
			{ title="Refuse", text="We cannot help you at this time.", goto=83140 },
			{ title="Accept", text="I accept this mission.", goto=83150 }
		}
	}
	questions[83110] = {
		action="jump", goto=83001,
		player="[AUTO_REPEAT]",
		alien={"I am doubtlessly referring to the Elowan and the Thrynn.  Burying useless animosity, they have combined their fleets and use each other's strengths to produce a fleet many times more effective than their ships could possibly have been separately." }
	}
	questions[83120] = {
		action="jump", goto=83001,
		player="[AUTO_REPEAT]",
		alien={"Besides the Elowan and the Thrynn, the other races which are currently fighting off the Minex are the Spemin, Nyssian, and the Coalition.  Please contact every single one of these races, even if they decline to participate.  The Tafel and the pirate clans we recognize as unapproachable." }
		}
	questions[83130] = {
		action="jump", goto=83001,
		player="[AUTO_REPEAT]",
		alien={"Despite your technology, Myrrdan numerically still has only a few hundred ships, correct?  This is fewer than even the drunken pirate clans.  The focus must be on the effective fighting forces." }
	}
	questions[83140] = {
		action="jump", goto=997, ftest= 1, -- refuse, end the mission
		player="[AUTO_REPEAT]",
		alien={"Very well.  We will pursue this matter on our own.   (Mission Completed)" }
	}
	questions[83150] = {
		action="jump", goto=997, ftest= 1, -- give the player artifact335 Bar-zhon fleet proposal
		player="[AUTO_REPEAT]",
		alien={"Transporting details of the proposal to you now.  I personally thank you for your assistance in this matter." }
	}

--[[
title="Mission #53:  Tactical Coordination - all responses collected		-jjh - allow player to read it before it's pushed off the window. added 83501
--]]

	questions[83500] = {
		action="jump", goto=83501, 
		title="Tactical Coordination",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have successfully contacted five races and have their responses.",
		playerFragment="about how you will proceed with this endeavor",
		alien={"The wargames are canceled.  If only two races see the benefit of such a collaboration, and those two races already have a functioning collaboration, there is little to be gained. (Mission Completed)" }
	}

	questions[83501] = {
		action="jump", goto=997, ftest= 1, -- remove artifacts 335-340 and end the mission
		player="Sorry to hear that.",
		alien={"As are we." }
	}


--[[
title="Mission #54:  Transport Escort Duty
--]]

	questions[84000] = {
		action="jump", goto=84001,
		title="Transport Escort Duty",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN].  We are searching for the transports Andermani and Mycondel last seen at this location.",
		playerFragment="about their whereabouts",
		alien={"I regretfully wish to inform you that the Tridal listening station recorded the destruction of your two freighters on long range sensors." }
	}
	questions[84001] = {
		action="jump", goto=997, ftest= 1, -- give the player artifact341 Bar-zhon Sensor data
		player="May we have copies of those logs?",
		alien={"Of course.  Please also convey the sincerest regrets of the Bar-zhon people to the families of the passengers and crewmembers of the transports." }
	}

--[[
title="Mission #56:  Scavenger Hunt - Introduction
--]]


	questions[86000] = {
		action="jump", goto=86001,
		title="Scavenger Hunt",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN].  I understand that you have some sort of archaeological task for us.",
		playerFragment="about it",
		alien={"During the great war the 3 imperialists expended an inordinate amount of resources on technological archeology and espionage. Much of this was focused upon the Minex with fortunately little benefit to their war effort at the time." }
	}
	questions[86001] = {
		action="branch",
		choices = {
			{ title="Why now?", text="Why is there interest in their research now after all these centuries?", goto=86010 },
			{ title="End of the great war", text="Why did your people not pursue this at the end of the war?", goto=86020 },
			{ title="Why us?", text="How are we expected to do any better?", goto=86030 },
			{ title="Refuse", text="We don't want to pursue this task, ask someone else.", goto=86040 },
			{ title="Accept", text="Where do we start searching?", goto=86050 }
		}
	}
	questions[86010] = {
		action="jump", goto=86001,
		player="[AUTO_REPEAT]",
		alien={"Outside their planetary network, a few Sabion research labs with independent databases coordinated with the military structures of all three races to obtain technology from archaeology, espionage, and piracy.  Extinct races and the Minex were primary targets of their focus.  Possibly some insight or technology captured from the Minex could help us out today." }
	}
	questions[86020] = {
		action="jump", goto=86001,
		player="[AUTO_REPEAT]",
		alien={"The military structure was deeply underground and the secrecy of their location was never broken until well after the war.  Estimates of the cost in lives required to capture, pacify, and hold three entire planets was incredibly high.  Military survivors doubtlessly would have destroyed the underground bases rather than let them be taken. The decision was made to evacuate the civilians and irradiate the surface, with many repeated warnings and offers of rescue." }
		}
	questions[86030] = {
		action="jump", goto=86001,
		player="[AUTO_REPEAT]",
		alien={"Myrrdan humans and Myrrdan technology should not trigger any automated booby traps or defenses still surviving.  We have the location of one of the headquarters of the Bx, and we hope that logistics and secure records at the site will lead you to the locations of all of the other underground military bases of all of the three races. Any artifacts being studied will be on site." }
	}
	questions[86040] = {
		action="jump", goto=997, ftest= 1, -- refuse, end the mission
		player="[AUTO_REPEAT]",
		alien={"Very well.  We will pursue this matter on our own.   (Mission Completed)" }
	}
	questions[86050] = {
		action="jump", goto=997, -- Terminate
		player="[AUTO_REPEAT]",
		alien={"The secret underground bunker of the Bx Emperor was revealed to us to be at 74S X 28E on the Bx home world of Anextiomarus in the Boann system (115,184)  High radiation levels made it inconvenient to return to the site until recently." }
	}

--[[
title="Mission #56:  Scavenger Hunt - Items
--]]

	questions[86100] = {
		action="jump", goto=86102,
		title="Scavenger Hunt",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN].  We have an artifact hologram to transmit for analysis",
		playerFragment="about it",
		alien={"We await your transport." }
	}
	questions[86101] = {
		action="branch",
		choices = {
			{ title="Additional Artifacts", text="We obtained additional artifacts, transporting holographic details of another artifact now", goto=86102 },
			{ text="<Exit>", goto=1 }
		}
	}
	questions[86102] = {
		action="jump", goto=86103, ftest= 1, -- remove one artifact (347-352) and jump to corresponding question 200 first five, 300 artifact352
		player="Transporting now",
		alien={"One moment Myrrdan vessel." }
	}
	questions[86103] = {
		action="jump", goto=86101,
		player="<More>",
		alien={"We've received nothing. Please retransmit." }
		}
	questions[86200] = {
		action="jump", goto=86101,
		player="<Analysis>",
		alien={"Analysis of this artifact has revealed very little of interest. It has a slight value as an alien curio, but otherwise is totally useless to us." }
	}
	questions[86300] = {
		action="jump", goto=86301,
		player="<Analysis>",
		alien={"This formation is a single genetically engineered flora lifeform thousands of years old.  Encapsulated airtight pockets of high pressure gases and bacteria provide the lifeform the basis of a low level of photosynthesis even in an airless environment. The outer layers form some type of organic crystal structure harder then most metals." }
	}
	questions[86301] = {
		action="jump", goto=86302,
		player="<More>",
		alien={"A fungal growth imbedded within the lifeform naturally exhibits superconductive properties. Small spherical devices within the lifeform emit a curious inertia nullification field, reducing the effective mass of all objects inside the field." }
	}
	questions[86302] = {
		action="jump", goto=86303, ftest= 1, -- remove artifact352, provide artifact362 Bar-zhon Analyzed Organic Monstrosity
		player="<More>",
		alien={"Inertia nullification has our scientists excitedly theorizing about missile defense. Reduce the kinetic inertia of an object nearly to zero, and any oscillating force exerted upon it can rip it apart or divert it's trajectory. Your engineers should be able to use this information to improve your shielding technology immediately." }
	}
	questions[86303] = {
		action="jump", goto=86101,
		player="<More>",
		alien={"We would recommend that you take this analyzed organic monstrosity data to the Nyssian and see if they can shed any light on what it is." }
	}


end

function QuestDialogueancients()


--[[
title="Mission #60:  Overrun
--]]

	questions[80000] = {
		action="jump", goto=80001,
		title="Overrun",
		player="[AUTO_REPEAT]",
		introFragment="Greetings Bar-zhon. This is Captain [CAPTAIN] of the starship [SHIPNAME].  Myrrdan picked up an emergency distress signal from your Starbase at Ceridwen in the Ailil system (188, 88).",
		playerFragment="if there is any way we may assist you", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"You are too late. It is too late for all of us. The rampaging infected have already left leaving nothing in their wake." }
	}
	questions[80001] = {
		action="jump", goto=80002,
		title="what happened?",
		player="[AUTO_REPEAT]",
		playerFragment="what happened", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The small force defending the system picked up a fleet of incoming vessels. Since they were using civilian grade drives, it was assumed that this was a trading convoy with their escorts. After they entered the system the presence of Tafel ships gave them away.  A fleet of Tafel, Bar-zhon, Spemin, and Thrynn ships, including  one or two Elowan scouts approached the system from every vector and overwhelmed the defenders uncaring of any losses." }
	}
	questions[80002] = {
		action="jump", goto=80003,
		title="How infected ships fight?",
		player="[AUTO_REPEAT]",
		playerFragment="how infected ships fight", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Infected ships somehow upgrade the weapon systems of their ships by roughly 40 percent in terms of damage and accuracy.  Active sensors are not even used as if infected already knew where their opponents were.  Much effort has been expended into figuring out just how this is possible. Defensive systems are left on automatics or even ignored, as if they were completely uncaring of losses.  Battles tend to be short and brutal." }
	}
	questions[80003] = {
		action="jump", goto=80004,
		title="What was their objective?",
		player="[AUTO_REPEAT]",
		playerFragment="what their objective was at Ceridwen", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Objective?  I thought I was already clear on that point. Their only objective was to kill every living thing on the planet and then flee. The few evacuees lucky enough to escape before the massacre were able to watch their families and friends perish.  Logs kept at the city of Fissif where traffic control was located may reveal more." }
	}
	questions[80004] = {
		action="jump", goto=997, -- Terminate
		player="<More>",
		alien={"Bar-zhon Fleet command has decided that the cost of sufficiently rebuilding and defending the Ailil system is not feasible at this time.  No Naval vessels defend the few hundred refugees who decided to return to the planet once numbering among the millions.  Enough on this subject." }
	}


--[[
title="Mission #61:  Another Ruins Search
--]]

	questions[81000] = {
		action="jump", goto=1,
		title="Another Ruins Search",
		player="[AUTO_REPEAT]",
		introFragment="Greetings. This is Captain [CAPTAIN] of the starship [SHIPNAME].  Your government sent us a list of research sites on the worlds of the 3 Imperialists which were studying the ancients.",
		playerFragment="about the Society of Ancient Studies",
		alien={"We have no interest chasing fairy tales. If someone in the government sent you that list and you can use it, so much better for you." }
	}


end

function OtherDialogue()


--[[
title=" Universal exchanges"
--]]
	questions[500] = {
		action="jump", goto=501,
		player="Can you tell me about...",
		playerFragment="...",
		alien={"Would you be interested in selling your Thrynn Battle Machine?  I'll buy it for 6 endurium crystals." }
	}
	questions[501] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=510 },
			{ text="No.",  goto=520 },
		}
	}
	questions[510] = {
		--player_money = player_money + artifact14 * 3500,
		--artifact14 = 0,
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Transfering." }
	}
	questions[520] = {
		action="jump", goto=1, ftest= 3,  -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Very well." }
	}

	-- attack the player because attitude is too low

	questions[910] = {
		action="jump", goto=999,  -- attack
		player="What can you tell us about...",
		alien={"Your uncivilized behavior will no longer be tolerated. Our patience is exhausted and your time has run out." }
	}

	-- hostile termination question
	questions[920] = {
		action="jump", goto=997,  -- terminate
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"More important matters call us to duty.  We suggest that you vacate this area immediately." }
	}

	-- neutral termination question
	questions[930] = {
		action="jump", goto=997,  -- terminate
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"We must call an end to our negotiations.  Honor and duty require our immediate time and attention." }
	}

	-- friendly termination question
	questions[940] = {
		action="jump", goto=997,  -- terminate
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"Good fortune, [CAPTAIN] of the starship [SHIPNAME].  We bid you farewell and look forward to our next encounter." }
	}

	questions[997] = {
		action="jump", ftest= 4, -- Generic terminate question
		player="This text is never shown to the player because communications is terminated instantly",
		alien={"" }
	}
	questions[998] = {
		action="jump", goto=999,
		player="<Open Communication>", -- Generic I do not want to talk question
		playerFragment= "...",
		alien={"Get lost!" }
	}
	questions[999] = {
		action="jump", ftest= 5, -- Generic attack question
		player="This text is never shown to the player because communications is terminated instantly",
		alien={"" }
	}
end

------------------------------------------------------------------------
-- SCRIPT INITIALIZATION -----------------------------------------------
------------------------------------------------------------------------
function Initialize()
    -- COMBAT VALUES FOR THIS ALIEN RACE

-- Initial plot stage
if (plot_stage == 1) then


    health = 100                    -- 100=baseline minimum
    mass = 6                        -- 1=tiny, 10=huge

	engineclass= 3
	shieldclass = 4
	armorclass = 3
	laserclass = 1
	missileclass = 5
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%

-- virus plot stage
elseif (plot_stage == 2) then

    health = 100                    -- 100=baseline minimum
    mass = 7                        -- 1=tiny, 10=huge

	engineclass= 3
	shieldclass = 4
	armorclass = 3
	laserclass = 1
	missileclass = 5
	laser_modifier = 75				-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 90			-- % of damage received, used for racial abilities, 0-100%

-- war and ancients plus pages
elseif (plot_stage == 3) or (plot_stage == 4) then


    health = 100                    -- 100=baseline minimum
    mass = 7                        -- 1=tiny, 10=huge

	engineclass= 3
	shieldclass = 4
	armorclass = 3
	laserclass = 1
	missileclass = 6
	laser_modifier = 40				-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 90			-- % of damage received, used for racial abilities, 0-100%

end


	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in


if (plot_stage == 1) then -- initial plot state

	DROPITEM1 = 15;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Bar-Zhon Data Cube
	DROPITEM2 = 54;		DROPRATE2 = 70;		DROPQTY5 = 4 -- Endurium
	DROPITEM3 = 34;		DROPRATE3 = 25;		DROPQTY3 = 9
	DROPITEM4 = 50;		DROPRATE4 = 50;		DROPQTY4 = 2
	DROPITEM5 = 31;		DROPRATE5 = 0;	    DROPQTY2 = 15

elseif (plot_stage == 2) then -- virus plot state

	DROPITEM1 = 224;	DROPRATE1 = 80;		DROPQTY1 = 1 -- Bar-zhon genetic material
	DROPITEM2 = 54;		DROPRATE2 = 70;		DROPQTY5 = 4 -- Endurium
	DROPITEM3 = 34;		DROPRATE3 = 25;		DROPQTY3 = 9
	DROPITEM4 = 50;		DROPRATE4 = 50;		DROPQTY4 = 2
	DROPITEM5 = 31;		DROPRATE5 = 0;	    DROPQTY2 = 15

elseif (plot_stage == 3) then -- war plot state

	DROPITEM1 = 15;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Bar-Zhon Data Cube
	DROPITEM2 = 54;		DROPRATE2 = 70;		DROPQTY5 = 4 -- Endurium
	DROPITEM3 = 34;		DROPRATE3 = 25;		DROPQTY3 = 9
	DROPITEM4 = 50;		DROPRATE4 = 50;		DROPQTY4 = 2
	DROPITEM5 = 31;		DROPRATE5 = 0;	    DROPQTY2 = 15

elseif (plot_stage == 4) then -- ancients plot state

	DROPITEM1 = 15;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Bar-Zhon Data Cube
	DROPITEM2 = 54;		DROPRATE2 = 70;		DROPQTY5 = 4 -- Endurium
	DROPITEM3 = 34;		DROPRATE3 = 25;		DROPQTY3 = 9
	DROPITEM4 = 50;		DROPRATE4 = 50;		DROPQTY4 = 2
	DROPITEM5 = 31;		DROPRATE5 = 0;	    DROPQTY2 = 15

end

	SetPlayerTables() -- Load in all of the statement and question fragments

	FTEST= -1	--FTEST is used to activate the commFxn, for decision making during conversations.

	--player_Quorsitanium = 150
	--player_Endurium = 124
	--active_quest = 46			--  debugging use
	--plot_stage = 2
	--artifact394 = 1
	--ship_missile_class = 7
	--ship_laser_class = 9

	--[[initialize dialog and jump to a specific Quest question before the standard questions if certain conditions are met

	MILITARY MISSIONS   70000-79999
	SCIENTIFIC MISSIONS 80000-89999
	FREELANCE MISSIONS  90000-99999

	Question 70000 = Mission 26, 75000 = Mission 31, 79000 = Mission 35, etc.]]--

if (plot_stage == 1) then -- initial plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low
	elseif player_profession == "military" and active_quest == 30 and artifact20 > 0 then
		first_question = 74000
	elseif player_profession == "military" and active_quest == 35 and artifact22 > 0 then
		first_question = 79000
	elseif player_profession == "scientific" and active_quest == 29 and artifact15 > 0 then
		first_question = 83000
	elseif player_profession == "scientific" and active_quest == 31 and artifact16 == 0 then
		first_question = 85000
	elseif player_profession == "scientific" and active_quest == 35 then
		first_question = 89000
	elseif player_profession == "freelance" and active_quest == 29 and artifact16 == 0 then
		first_question = 93000
	elseif player_profession == "freelance" and active_quest == 29 and artifact16 == 1 then
		first_question = 93500
	elseif player_profession == "freelance" and active_quest == 31 and artifact20 > 0 then
		first_question = 95000
	elseif player_profession == "freelance" and active_quest == 34 and artifact18 == 1 then
		first_question = 98000
	elseif player_profession == "freelance" and active_quest == 35 and artifact27 == 0 and artifact28 == 0 then
		first_question = 99000
	elseif player_profession == "freelance" and active_quest == 35 and artifact27 == 1 and artifact28 == 0 then
		first_question = 99500


	-- Universal exchange - shipping invoice for information
	elseif artifact381 > 0 then
		first_question = 84000

	-- Universal exchange - Thrynn Battle Machine for energy crystals
	elseif artifact14 > 0 then
		first_question = 500

	-- no mission is active, just go to the standard questions
	else
		first_question = 1
	end

elseif (plot_stage == 2) then -- virus plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low

-- Player picked up artifact390 - the ancient artifact with a hidden tracking device triggering an encounter with Borno
	elseif artifact390 == 1 then
		first_question = 90000

--Quest #37: Track down two Myrrdan smugglers, the Diligent and the Excelsior.
-- Bar-zhon refers the player to the Coalition or outward
	elseif active_quest == 37 then
		first_question = 77000

--Quest #38: Gather genetic and viral samples for a team of Elowan doctors. Each race contacted wants something.
--The Bar-zhon want the Coalition data.

	elseif active_quest == 38 and artifact224 == 0 and (artifact225 == 0 or artifact226 == 0 or artifact227 == 0)  then
		first_question = 78000
	elseif active_quest == 38 and artifact224 == 0 and artifact225 > 0 and artifact226 > 0 and artifact227 > 0  then
		first_question = 78500

-- Quest #39: defensive alliance, initial Contact
--artifact236 computer
--artifact241 Observer
--artifact242 signaling device

-- Step one
	elseif active_quest == 39 and artifact241 == 0 and artifact242 == 0 then
		first_question = 79000
-- Quest 39: Fleet Adm. initial contact - step two
	elseif active_quest == 39 and artifact241 == 0 and artifact242 == 1 then
		first_question = 79600
-- Quest 39: reestablish with the Fleet Adm. - step three
	elseif active_quest == 39 and artifact236 > 0 and artifact241 == 1  and artifact242 == 0 then
		first_question = 79500
-- Quest #39: Fleet Adm. after demonstration - step four
	elseif active_quest == 39 and artifact236 > 0 and artifact241 == 1 and artifact242 == 1 then
		first_question = 79700
-- Quest #39: Have not acquired targeting computer yet - alternate step three if computer  has not been obtained yet
	elseif active_quest == 39 and artifact236 == 0 and artifact241 == 1 and artifact242 == 0 then
		first_question = 79800

-- Quest #40: Defensive Alliance, Acceptance of Terms
	elseif active_quest == 40 and artifact238 == 0 then
		first_question = 80000

-- Quest #41: Medical Archaeology
	elseif active_quest == 41 and artifact247 > 0 and artifact249 == 0 then -- exotic dataCube only
		first_question = 81000

	elseif active_quest == 41 and artifact247 == 0 and artifact249 > 0 then -- organic database only
		first_question = 81200

	elseif active_quest == 41 and artifact247 > 0 and artifact249 > 0 then -- exotic dataCube and organic database
		first_question = 81500

	elseif active_quest == 42 and artifact253 == 0 then
		first_question = 82000


-- Mission #43:  Framed!
	elseif active_quest == 43 and artifact260 == 0 then
		first_question = 999

-- Mission #43:  Framed! - with holographic evidence
	elseif active_quest == 43 and artifact260 == 1 then
		first_question = 83000


-- Mission #44:  Decontamination Transporter initial
	elseif active_quest == 44 and artifact262 == 0 and artifact263 == 0 then
		first_question = 84000

-- Mission #44:  Decontamination Transporter Operational code only
	elseif active_quest == 44 and artifact262 == 1 and artifact263 == 0 then
		first_question = 84300

-- Mission #44:  Decontamination Transporter Broken code only
	elseif active_quest == 44 and artifact263 == 1 and artifact262 == 0 then
		first_question = 84600

-- Mission #44:  Decontamination Transporter finished
	elseif active_quest == 44 and artifact264 == 1 then
		first_question = 1

-- Mission #45:  Healthcare Scam - no medical treatment sample
	elseif active_quest == 45 and artifact265 == 0 and artifact266 == 0 then
		first_question = 85000

-- Mission #45:  Healthcare Scam - medical treatment sample
	elseif active_quest == 45 and artifact265 == 1 and artifact266 == 0 then
		first_question = 85500





	-- Universal exchange - Thrynn Battle Machine for energy crystals
	elseif artifact14 > 0 then
		first_question = 500

	-- no mission is active, just go to the standard questions
	else
		first_question = 1
	end

elseif (plot_stage == 3) then -- war plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low

-- Mission #48:  Intelligence Gathering
	elseif active_quest == 48 and artifact275 == 0 and artifact276 == 0 then -- no power core
		first_question = 78000
	elseif active_quest == 48 and artifact275 == 1 and artifact276 == 0 then -- obtained power core
		first_question = 78500

-- Mission #49:  Unrest
	elseif active_quest == 49 and artifact280 == 0 and artifact281 == 0 then -- no flight recorders
		first_question = 79000
	elseif active_quest == 49 and (artifact280 == 1 or artifact281 == 1) then -- at least one flight recorder
		first_question = 79500


-- Mission #53:  Tactical coordination - initial
	elseif active_quest == 53 and artifact335 == 0 then
		first_question = 83000

-- Mission #53:  Tactical coordination - all responses collected		-jjh
	elseif active_quest == 53 and artifact336 == 1 and artifact337 == 1 and artifact338 == 1 and artifact339 == 1 and artifact340 == 1 then
		first_question = 83500


-- Mission #54:  Transport Escort Duty
	elseif active_quest == 54 and artifact341 == 0 then
		first_question = 84000

-- Mission #56: Scavenger Hunt - initial
	elseif active_quest == 56 and artifact347 == 0 and artifact348 == 0 and artifact349 == 0 and artifact350 == 0 and artifact351 == 0 and artifact352 == 0 then
		first_question = 86000

-- Mission #56: Scavenger Hunt - returning an artifact
	elseif active_quest == 56 and artifact362 == 0 then
		first_question = 86100

-- Mission #56: Scavenger Hunt - go to Nyssian
	elseif active_quest == 56 and artifact362 == 1 then
		first_question = 1



	-- Universal exchange - Thrynn Battle Machine for energy crystals
	elseif artifact14 > 0 then
		first_question = 500

	-- no mission is active, just go to the standard questions
	else
		first_question = 1
	end

elseif (plot_stage == 4) then -- ancients plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low

	-- Mission #60: Overrun
	elseif active_quest == 60 then
		first_question = 80000


	-- Mission #61: Another Ruins Search
	elseif active_quest == 61 -- and artifact375 == 0 
		then
		first_question = 81000


	-- Universal exchange - Thrynn Battle Machine for energy crystals
	elseif artifact14 > 0 then
		first_question = 500

	-- no mission is active, just go to the standard questions
	else
		first_question = 1
	end

end

	starting_attitude = 100
	starting_posture = "obsequious"
	current_question = first_question
	next_question = first_question

	-- Attitude this value and higher unlocks all questions, alien lowers their shields, maximum number of questions may be asked
	friendlyattitude = 70
	-- Attitude this value and higher is a neutral attitude, alien disarmed weapons but has raised shields
	neutralattitude = 45

	--initialize globals as needed
	if ATTITUDE == nil then ATTITUDE = starting_attitude end
	if POSTURE == nil then POSTURE = starting_posture end
	orig_posture= POSTURE

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


	StandardQuestions() -- load generic dialogue questions

if (plot_stage == 1) then	--load the quest-related dialog.
	QuestDialogueinitial()
elseif (plot_stage == 2) then
	QuestDialoguevirus()
elseif (plot_stage == 3) then
	QuestDialoguewar()
elseif (plot_stage == 4) then
	QuestDialogueancients()
end

	OtherDialogue()  -- load universal exchanges and special actions


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

	This function is executed roughly once a second during every encounter.
--]]



end

--[[ The communications function makes more involved decisions on what to do
	 based on:
	 type (0: greeting,  1: statement,  2: question),
	 n (question/statement number)
	 ftest (1: generic actions: 2: insightful attitude adjustment, 3: aggravating
	 attitude adjustment.  These values are explicitly specified in the question action
	 Note: must be >= 1 for commFxn to be invoked at all)

	 Other variables pulled in as needed from the script.

	This function is called during communications every time an action is made
	such as making a statement or asking a question. --]]

function commFxn(type, n, ftest)

	--greeting modifications of attitude
	if (type == 0) then
		if (POSTURE == "friendly") then
			ATTITUDE = ATTITUDE + 4
		elseif (POSTURE == "obsequious") then
			ATTITUDE = ATTITUDE + 6
		elseif (POSTURE == "hostile") then
			ATTITUDE = ATTITUDE - 6
		end

	--statement modifications of attitude
	elseif (type == 1) then
		if (POSTURE == "friendly") then
			ATTITUDE = ATTITUDE + 1
		elseif (POSTURE == "obsequious") then
			ATTITUDE = ATTITUDE + 3
		elseif (POSTURE == "hostile") then
			ATTITUDE = ATTITUDE - 6
		end

	-- Terminating function - should only be called by question 997
	elseif (ftest == 4) then
		L_Terminate()
		return
	-- Attack the player function - should only be called by question 999
	elseif (ftest == 5) then
		L_Attack()
		return

	-- jump to hostile "tired of answering questions" question
	elseif (ATTITUDE < neutralattitude and number_of_actions > 4) then
		goto_question = 920
		number_of_actions = 0

	-- jump to neutral "tired of answering questions" question
	elseif (ATTITUDE < friendlyattitude and number_of_actions > 10) then
		goto_question = 930
		number_of_actions = 0

	-- jump to friendly "tired of answering questions" question
	elseif (number_of_actions > 20) then
		goto_question = 940
		number_of_actions = 0

	-- Will not execute or waste time checking any of the logic below if a question does not have an explicit ftest=1/2/3/4/5/6 value
	elseif (ftest < 1) then
		return

	-- All logic below applies to questions (divided up by plot stage to allow us to reuse mission numbers
	else
		-- General adjustment every time a category is started
		if (n == 10000) or (n == 20000) or (n == 30000) or (n == 40000) then
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE + 2
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 2
			end

		--  Insightful question attitude adjustment
		elseif (ftest == 2) then
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE + 3
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 1
			end

		--  Aggravating question attitude adjustment
		elseif (ftest == 3) then
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE - 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE - 1
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 3
			end
		end

		-- Universal exchange - Thrynn Battle Machine for energy crystals

		if (n == 510) then
			player_Endurium = player_Endurium + 6
			artifact14 = 0
			ATTITUDE = ATTITUDE + 10

		elseif (plot_stage == 1) then -- initial plot state

		-- Universal exchange - shipping invoice for information

			if (n == 84001) then
				artifact381 = 0

			-- "Military Mission #30:  We are seeking an afterburner - possess the afterburner."
			elseif (n == 74000) then
				if (ship_shield_class < max_shield_class) then
					goto_question = 74005
				else
					goto_question = 74006
				end

			-- player ship does not have the top shield class, upgrade shields
			elseif (n == 74005) then
				artifact20 = 0
				active_quest = active_quest + 1
				ship_shield_class = ship_shield_class + 1
				ATTITUDE = ATTITUDE + 10

			-- player ship already has the top shield class, provide energy crystals instead
			elseif (n == 74006) then
				artifact20 = 0
				active_quest = active_quest + 1
				player_Endurium = player_Endurium + 15
				ATTITUDE = ATTITUDE + 20

			--"Military Mission #35:  Making an offer on Minex Electronics"
			elseif (n == 79100) then
				ATTITUDE = ATTITUDE + 3
				if (ship_missile_class < max_missile_class) then
					goto_question = 79105
				else
					goto_question = 79106
				end

			-- player ship does not have the top missile class, upgrade missiles
			elseif (n == 79105) then
				artifact22 = 0
				active_quest = active_quest + 1
				ship_missile_class = max_missile_class
				ATTITUDE = ATTITUDE + 10

			-- player ship already has the top missile class, provide energy crystals instead
			elseif (n == 79106) then
				artifact22 = 0
				active_quest = active_quest + 1
				player_Endurium = player_Endurium + 35
				ATTITUDE = ATTITUDE + 20

			-- Scientific Mission # 29: First Contact, returning the Bar-zhon data cube
			elseif (n == 83001) then
				artifact15 = 0
				active_quest = active_quest + 1
				if (ship_engine_class < max_engine_class) then
					ship_engine_class = ship_engine_class + 1
				end
				ATTITUDE = ATTITUDE + 20

			-- "Freelance Mission #29:  Returning the Whining orb - in possession of the orb"
			elseif (n == 93600) then
				artifact16 = 0
				active_quest = active_quest + 1
				ATTITUDE = ATTITUDE + 3

			-- "Freelance Mission #31:  Coalition afterburner"
			elseif (n == 95000) then
				if (ship_shield_class < max_shield_class) then
					goto_question = 95005
				else
					goto_question = 95006
				end

			-- player ship does not have the top Shields class, upgrade shields
			elseif (n == 95005) then
				artifact20 = 0
				active_quest = active_quest + 1
				ship_shield_class = ship_shield_class + 1
				ATTITUDE = ATTITUDE + 10

			-- player ship already has the top Shields class, provide energy crystals instead
			elseif (n == 95006) then
				artifact20 = 0
				active_quest = active_quest + 1
				player_Endurium = player_Endurium + 15
				ATTITUDE = ATTITUDE + 20

			-- "Freelance Mission #34: Pawning off artistic containers" option #1
			elseif (n == 98100) then
				artifact18 = 0
				player_Endurium = player_Endurium + 15
				active_quest = active_quest + 1
				ATTITUDE = ATTITUDE + 5

			-- "Freelance Mission #34: Pawning off artistic containers" option #2
			elseif (n == 98200) then
				artifact18 = 0
				player_Endurium = player_Endurium + 12
				active_quest = active_quest + 1
				ATTITUDE = ATTITUDE + 10

			end


		elseif (plot_stage == 2) then -- virus plot state

-- title="Borno encounter"

			if (n == 91002) then
				artifact390 = 0  -- discard tracking device

			elseif (n == 94001) then
				artifact390 = 0  -- discard tracking device

			elseif (n == 93000) then
				ATTITUDE = 5  -- make the entire Bar-zhon race hostile to the player


-- title="Mission #38:  Collecting Genetic Samples" coalition data

			elseif (n == 78505) then
				artifact225 = 0  -- The Appearance of giving away samples without losing them
				artifact226 = 0
				artifact227 = 0

			elseif (n == 78510) then
				artifact225 = 1
				artifact226 = 1
				artifact227 = 1

				artifact224 = 1 -- Bar-zhon data

-- title="Mission #39:  Defensive alliance: contacting the Adm.
			elseif (n == 79002) then
				artifact242 = 1  -- transport signaling device
			elseif (n == 79600) then
				artifact242 = 0  -- remove signaling device
			elseif (n == 79681) then
				artifact241 = 1  -- transport observer
			elseif (n == 79500) then
				artifact242 = 1  -- transport signaling device
			elseif (n == 79700) then
				artifact242 = 0  -- remove signaling device
			elseif (n == 79701) then
				artifact241 = 0  -- remove Observer and computer, send government communiqué
				artifact236 = 0
				artifact237 = 1

-- title="Mission #42:  Tracking the Laytonites
			elseif (n == 82002) then
				artifact254 = 1  -- Bar-zhon Pirate sensor data

-- title="Mission #43:  Desperate Measures
			elseif (n == 83000) then
				if (ATTITUDE >  25) then
					ATTITUDE =  25
				end

-- title="Mission #43:  Desperate Measures
			elseif (n == 83002) then
				artifact255 = 0  -- remove red Herring
				artifact260 = 0  -- remove holographic scanning location
				if player_profession == "military" then
					active_quest = active_quest + 2  --was 3 JJH
				else
					active_quest = active_quest + 1
				end

-- title="Mission #44: Decontamination Transporter
			elseif (n == 84150) then
				artifact261 = 1  -- Genetic Transporter Specifications
			elseif (n == 84300) then
				artifact262 = 0  -- remove operating code
			elseif (n == 84301) then
				artifact264 = 1  -- provide data cube
			elseif (n == 84600) then
				artifact263 = 0  -- remove broken code

			elseif (n == 85500) then -- quest 45 make it look like transporting medical treatment
				artifact265 = 0
				artifact265 = 1

			end


		elseif (plot_stage == 3) then -- war plot state

-- title="Mission #48: Intelligence Gathering
			if (n == 78500) then
				artifact275 = 0 -- Minex Power Core
				artifact276 = 1 -- Bar-zhon Data Chips

-- title="Mission #53: Tactical coordination - refuse
			elseif (n == 83140) then
				active_quest = active_quest + 1
				ATTITUDE = ATTITUDE - 20

-- title="Mission #53: Tactical coordination - transfer proposal
			elseif (n == 83150) then
				artifact335 = 1 -- Bar-zhon fleet proposal
				ATTITUDE = ATTITUDE + 10

-- title="Mission #53: Tactical coordination - end the mission		--jjh was 83500
			elseif (n == 83501) then
				artifact335 = 0 --  Bar-zhon fleet proposal
				artifact336 = 0 --  Elowan response
				artifact337 = 0 --  Thrynn response
				artifact338 = 0 --  Spemin response
				artifact339 = 0 --  Nyssian response
				artifact340 = 0 --  Coalition response
				ATTITUDE = ATTITUDE + 10
				active_quest = active_quest + 1

-- title="Mission #54: Transport Escort Duty
			elseif (n == 84001) then
				artifact341 = 1 -- Bar-zhon Sensor data

-- title="Mission #56: Scavenger Hunt
			elseif (n == 86040) then -- If the player refuses the mission
				ATTITUDE = ATTITUDE - 10
				active_quest = active_quest + 1

			elseif (n == 86102) then
				if (artifact347 == 1) then
					artifact347 = 0
					goto_question = 86200
				elseif (artifact348 == 1) then
					artifact348 = 0
					goto_question = 86200
				elseif (artifact349 == 1) then
					artifact349 = 0
					goto_question = 86200
				elseif (artifact350 == 1) then
					artifact350 = 0
					goto_question = 86200
				elseif (artifact351 == 1) then
					artifact351 = 0
					goto_question = 86200
				elseif (artifact352 == 1) then
					artifact352 = 0
					goto_question = 86300
				end

			elseif (n == 86302) then
					artifact352 = 0
					artifact362 = 1
					ship_shield_class_class = max_shield_class

			end
		elseif (plot_stage == 4) then -- ancients plot state


		end
	end
end
