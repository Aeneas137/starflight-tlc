--[[------------------------------------------------------------------------------------------------------------------------------------------------- ]
	ENCOUNTER SCRIPT FILE: MINEX

	Last Modified:  October 27, 2011

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

if (plot_stage == 1) or (plot_stage == 2) or (plot_stage == 3) then

	SilenceTable= {
		"<Silence>",
		"<No response>",
		"<Static>"
	}

	NoiseTable= {
		"And?",
		"<Click>",
		"<Humm>",
		"<Untranslatable>",
		"<Tick>",
		"<Whirl>",
		"<Loud Click>"
	}


elseif (plot_stage == 4) then -- ancients plot state

	SilenceTable= {
		"Greetings allies."
	}

	NoiseTable= {
		"You bring a gift of the eternal ones.  We again feel, we see, we know.  This gift restores our minds and helps us remember the past.  We now remember, the virus is a creation of the demons long past, the Uyo.  In exchange for it we offer peace to all, an alliance with Humans, and our help in discovering the true source of the virus."
	}
end


	greetings[1] = {
		action="",
		player="Hail oh mighty ones, masters of the universe.",
		alien= SilenceTable }
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien= SilenceTable }
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien= SilenceTable }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien= SilenceTable }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien= SilenceTable }
	greetings[6] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien= NoiseTable }
	greetings[7] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien= NoiseTable }
	greetings[8] = {
		action="",
		player="Please do not blast us into atomic particles.  Take pity on us who are not fit to grovel in your waste products.",
		alien= NoiseTable }
	greetings[9] = {
		action="",
		player="We can see that you are indeed the true race.  Pray enlighten us with your gems of infinite wisdom.",
		alien= NoiseTable }
	greetings[10] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien= NoiseTable }
	greetings[11] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien= NoiseTable }
	greetings[12] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien= NoiseTable }

end

------------------------------------------------------------------------
-- FRIENDLY DIALOGUE ---------------------------------------------------
------------------------------------------------------------------------
function FriendlyDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack

if (plot_stage == 1) or (plot_stage == 2) or (plot_stage == 3) then

	SilenceTable= {
		"<Silence>",
		"<No response>",
		"<Static>"
	}

	NoiseTable= {
		"And?",
		"<Click>",
		"<Humm>",
		"<Untranslatable>",
		"<Tick>",
		"<Whirl>",
		"<Loud Click>"
	}


elseif (plot_stage == 4) then -- ancients plot state

	SilenceTable= {
		"Greetings allies."
	}

	NoiseTable= {
		"You bring a gift of the eternal ones.  We again feel, we see, we know.  This gift restores our minds and helps us remember the past.  We now remember, the virus is a creation of the demons long past, the Uyo.  In exchange for it we offer peace to all, an alliance with Humans, and our help in discovering the true source of the virus."
	}
end


	greetings[1] = {
		action="",
		player="Greetings from the planet Myrrdan. We come in peace...usually.",
		alien= SilenceTable }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien= SilenceTable }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien= SilenceTable }
	greetings[4] = {
		action="",
		player="Greetings.  There is a lot we can learn from each other.  Please respond.",
		alien= SilenceTable }
	greetings[5] = {
		action="",
		player="Greetings.  Your ship seems to be very powerful.",
		alien= NoiseTable }
	greetings[6] = {
		action="",
		player="Hello there.  Your ship appears very elaborate.",
		alien= NoiseTable }
	greetings[7] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien= NoiseTable }
	greetings[8] = {
		action="",
		player="Greetings friend!  There is no limit to what both our races can gain from mutual exchange.",
		alien= NoiseTable }
end
------------------------------------------------------------------------
-- HOSTILE DIALOGUE ----------------------------------------------------
------------------------------------------------------------------------
function HostileDialogue()
	--add as many player greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack

if (plot_stage == 1) or (plot_stage == 2) or (plot_stage == 3) then

	SilenceTable= {
		"<Silence>",
		"<No response>",
		"<Static>"
	}

	NoiseTable= {
		"And?",
		"<Click>",
		"<Humm>",
		"<Untranslatable>",
		"<Tick>",
		"<Whirl>",
		"<Loud Click>"
	}


elseif (plot_stage == 4) then -- ancients plot state

	SilenceTable= {
		"Greetings allies."
	}

	NoiseTable= {
		"You bring a gift of the eternal ones.  We again feel, we see, we know.  This gift restores our minds and helps us remember the past.  We now remember, the virus is a creation of the demons long past, the Uyo.  In exchange for it we offer peace to all, an alliance with Humans, and our help in discovering the true source of the virus."
	}
end

	greetings[1] = {
		action="",
		player="This is captain [CAPTAIN] of the starship [SHIPNAME]. Identify yourselves immediately or be destroyed.",
		alien= SilenceTable }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien= SilenceTable }
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien= SilenceTable }
	greetings[4] = {
		action="",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien= SilenceTable }
	greetings[5] = {
		action="",
		player="We require information. Comply or be destroyed.",
		alien= SilenceTable }
	greetings[6] = {
		action="",
		player="Your ship is oversized and weak.",
		alien= SilenceTable }
	greetings[7] = {
		action="",
		player="What an ugly and worthless creature.",
		alien= SilenceTable }
	greetings[8] = {
		action="",
		player="Your ship looks like a flying garbage scow.",
		alien= SilenceTable }
	greetings[9] = {
		action="",
		player="You do not frighten me. Surrender at once. ",
		alien= SilenceTable }
	greetings[10] = {
		action="",
		player="We are prepared to spare you if you comply with our demands.",
		alien= SilenceTable }
	greetings[11] = {
		action="",
		player="Prepare yourselves for dissolution, alien scum dogs.",
		alien= SilenceTable }
end

function StandardQuestions()


if (plot_stage == 1) then -- initial plot state

	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"By the agreement of 17439 one is warned not to interfere in Minex affairs or encroach upon our territory."}
	}
	questions[20000] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"By the agreement of 17439 one is warned not to interfere in Minex affairs or encroach upon our territory."}
	}
	questions[30000] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"By the agreement of 17439 one is warned not to interfere in Minex affairs or encroach upon our territory."}
	}
	questions[40000] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"By the agreement of 17439 one is warned not to interfere in Minex affairs or encroach upon our territory."}
	}

	questions[50000] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		playerFragment="..",
		alien={"By the agreement of 17439 one is warned not to interfere in Minex affairs or encroach upon our territory."}
	}

end



if (artifact1 == 1) then  -- player read message about Harrison

	questions[60000] = {
		action="jump", goto=60001,
		player="Artifact dispensary",
		introFragment="We are uhh...agents of Harrison and are here to obtain one of the uhh... items left in safekeeping.",
		playerFragment= "whatever he gave you", fragmentTable= preQuestion.desire,
		alien={"Minex hold in store many items for the privateer Harrison.  Contact was lost for over 1200 Empire cycles ago but recently reestablished.  Your genome matches specifications.  Request approved.  This vessel holds exactly one item for Harrison." }

	}
	questions[60001] = {
		action="jump", goto=997, ftest= 1, -- Terminate
		player="Transfer Item",
		playerFragment="about the artifact",
		alien={"Negative." }
	}
else

	questions[60000] = {
		action="jump", goto=997, -- Terminate
		player="[AUTO_REPEAT]",
		alien={"Very well. " }
	}
end


--[[
	questions[11000] = {
		action="terminate",
		player="But would you consider...",
		alien={"By the agreement of 17439 one is warned not to interfere in Minex affairs or encroach upon our territory."}
	}
--]]

if (plot_stage == 2) then -- virus plot state

	questions[10000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="about you..",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[20000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="about the other..",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[30000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[40000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[50000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="about..",
		alien={"Your race spreads contagion. Do you deny this?"}
	}
	questions[50001] = {
		action="branch",
		choices = {
			{ title="Humans are immune to this virus.", text="Wait!  This is Captain [CAPTAIN], Humans are completely immune to this virus.", goto=60000 },
			{ text="We do not deny it. We are infected just like everyone else.", goto=50002 },
		}
	}

elseif (plot_stage == 3) then -- war plot state

	questions[10000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="about you..",
		alien={"All in quarantine.  All are infected and your travel spreads contagion.  Return to your home world."}
	}
	questions[20000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="about the other..",
		alien={"All in quarantine.  All are infected and your travel spreads contagion.  Return to your home world."}
	}
	questions[30000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"All in quarantine.  All are infected and your travel spreads contagion.  Return to your home world."}
	}
	questions[40000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"All in quarantine.  All are infected and your travel spreads contagion.  Return to your home world."}
	}
	questions[50000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="about..",
		alien={"All in quarantine.  All are infected and your travel spreads contagion.  Return to your home world."}
	}
	questions[50001] = {
		action="branch",
		choices = {
			{ title="Humans are immune", text="Wait!  This is Captain [CAPTAIN], Humans are completely immune to this virus.", goto=60000 },
			{ title="<Depart>", text="Okay, we will be leaving now.", goto=50002 },
		}
	}

end

if (plot_stage == 2) or (plot_stage == 3) then  -- virus plot state

	questions[60000] = {
		action="jump", goto=61000,
		player="[AUTO_REPEAT]",
		alien={"Improbable.  Drastically different sentient alien races, all are infected.  Justify your response." }
	}
	questions[50002] = {
		action="jump", goto=999, -- attack
		player="[AUTO_REPEAT]",
		alien={"<Static>" }
	}

	if (plot_stage == 2) then -- virus plot state

	questions[61000] = {
		action="branch",
		choices = {
			{ title="We are immune", text="Humanity is immune to the virus!", goto=61200 },
			{ title="No symptoms", text="Humans exposed to the virus develop no symptoms.", goto=61300 },
			{ title="We have the cure", text="We have the cure to the virus!", goto=61400 }
		}
	}

	elseif (plot_stage == 3) then -- war plot state


	questions[61000] = {
		action="branch",
		choices = {
			{ title="Stop fighting first", text="I'm not going to tell you anything unless you stop the war.", goto=61100 },
			{ title="We are immune", text="Humanity is immune to the virus!", goto=61200 },
			{ title="No symptoms", text="Humans exposed to the virus develop no symptoms.", goto=61300 },
			{ title="We have the cure", text="We have the cure to the virus!", goto=61400 }
		}
	}
	questions[61100] = {
		action="jump", goto=999, -- attack
		player="[AUTO_REPEAT]",
		alien={"Creative ploy.  We are not fools." }
	}

	end

	questions[61200] = {
		action="jump", goto=997, -- Terminate
		player="[AUTO_REPEAT]",
		alien={"Anomalous nonsentient flag triggered.  Possibility your race is developmentally flawed.  We will investigate." }
	}
	questions[61300] = {
		action="jump", goto=61301,
		player="[AUTO_REPEAT]",
		alien={"Provide further details." }
	}
	questions[61400] = {
		action="jump", goto=999, -- attack
		player="[AUTO_REPEAT]",
		alien={"Falsehood.  You lack even the most basic nano-disassembler." }
	}
	questions[61301] = {
		action="branch",
		choices = {
			{ title="Virus is not activated in humans", text="The virus remains inert and does not infect human cells.", goto=61310 },
			{ title="<Accuse Minex>", text="You are using the virus to destroy all other races!", goto=61320 },
			{ title="Natural immunity", text="We humans could have natural immunity.", goto=61330 },
			{ title="Unnatural virus", text="The spread of the virus was unnaturally fast.", goto=61340 }
		}
	}
	questions[61310] = {
		action="jump", goto=61301,
		player="[AUTO_REPEAT]",
		alien={"Similar behavior seen in 99.37 percent of life forms cataloged.  Plenty of specimens to study.  All nonsentient except for your race." }
	}
	questions[61320] = {
		action="jump", goto=997, -- Terminate
		player="[AUTO_REPEAT]",
		alien={"Falsehood.  Neither we nor any other race has working knowledge of the virus or of a cure." }
	}
	questions[61330] = {
		action="jump", goto=61301,
		player="[AUTO_REPEAT]",
		alien={"The virus is not natural.  No flaws in its programming can be exploited." }
	}
	questions[61340] = {
		action="jump", goto=52000,
		player="[AUTO_REPEAT]",
		alien={"We concur.  We suspect interference from an interloper or shadow power.  Assistance may be justified.  Provide proof of your trustworthiness." }
	}
	questions[52000] = {
		action="branch",
		choices = {
			{ title="Offer to perform any task", text="I am willing to do anything to prove our trustworthiness.", goto= 52100 },
			{ title="Promise to help", text="I can give only my personal vow that we will help.", goto=52200 },
			{ title="Inquire what can be done", text="What would you want us to do?", goto=52300 },
			{ title="State that we are trustworthy", text="Humans are always trustworthy.   Tell us how we can help.", goto=52400 }
		}
	}
	questions[52100] = {
		action="jump", goto=997, -- Terminate
		player="[AUTO_REPEAT]",
		alien={"Physical demonstration not required.  Leave." }
	}
	questions[52200] = {
		action="jump", goto=52201,
		player="[AUTO_REPEAT]",
		alien={"There exists a location were we may not travel.  Psychic disturbances localized around the M-class star outward of The Wee Dipper have repelled us for eons.  Possibility of advanced technology at this location is likely.  We retain some instinctual enmity against the purveyors of this contagion.  We must fight, we must contain." }
	}
	questions[52201] = {
		action="jump", goto=52202,
		player="What else would you want us to do?",
		alien={"Will you transmit a diverse selection of human genetic material for us to study?" }
	}
	questions[52300] = {
		action="jump", goto=52000,
		player="[AUTO_REPEAT]",
		alien={"Revelation requires justification.  Justify yourself." }
	}
	questions[52400] = {
		action="jump", goto=999, -- attack
		player="[AUTO_REPEAT]",
		alien={"Deceptive statement detected." }
	}
	questions[52202] = {
		action="branch",
		choices = {
			{ title="Yes", text="Yes, transmitting samples now.", goto=52210 },
			{ title="No", text="No, not at this time.", goto=52220 }
		}
	}
	questions[52210] = {
		action="jump", goto=997, -- Terminate
		player="[AUTO_REPEAT]",
		alien={"We will contact you.  Observe containment protocol and remain at your homeworld.  For now you may pass." }
	}
	questions[52220] = {
		action="jump", goto=997, -- Terminate
		player="[AUTO_REPEAT]",
		alien={"We will then remove what we need from Myrrdan without your consent.  Observe containment protocol and remain at your homeworld." }
	}

elseif (plot_stage == 4) then -- ancients plot state


	questions[10000] = {
		action="jump", goto=10001,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"The Minex are the shattered ones.  We struggle to defend and rebuild the lost unity of the age of sanity.  All actions are constructed to this goal."}
	}

	questions[10001] = {
		action="branch",
		choices = {
			{ text="Shattered?", goto=11000 },
			{ text="Trade", goto=12000 },
			{ text="Your biology", goto=13000 },
			{ text="Location of home world", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		playerFragment="why you consider yourselves shattered", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Unlike the enemy we have individuality and collective strength.  Collective strength was once powerful and our entire race could unite their thoughts at will bending reality itself.  This collective strength was lost." }
	}
	questions[12000] = {
		action="jump", goto=10001,
		player="[AUTO_REPEAT]",
		playerFragment="what your people offer for trade", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Irrelevant subject." }
	}
	questions[13000] = {
		action="jump", goto=10001,
		player="[AUTO_REPEAT]",
		playerFragment="about your biology",
		alien={"Transitory state, irrelevant subject." }
	}
	questions[14000] = {
		action="jump", goto=10001,
		player="[AUTO_REPEAT]",
		playerFragment="where your home world is located", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Original home world unknown.  In this group of the scattering, several colony worlds lie within communication range.  Coordinates are irrelevant." }
	}
	questions[11001] = {
		action="branch",
		choices = {
			{ text="The Enemy", goto=11100 },
			{ text="Bend reality", goto=11200 },
			{ text="Collective strength lost", goto=11300 },
			{ text="When this shattering occurred", goto=11400 },
			{ text="<Back>", goto=10001 }
		}
	}
	questions[11100] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		playerFragment="who or what is the..",
		alien={"Enemy known as Uyo.  They had collective strength but no individuality." }
	}
	questions[11200] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		playerFragment="about what you meant by bending reality",
		alien={"Translation into language is difficult.  Fabrication and manipulation of individual atoms is possible on a microscopic-scale with the collective simultaneous efforts of millions.  Technology is efficiency.  Psyonics may only be used for craftsmanship or to affect consciousness.  No longer do we have this power." }
	}
	questions[11300] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		playerFragment="why the collective..",
		alien={"Collective strength was lost near the end of the war against the Uyo.  Energy-based creatures you call Ancients intervened and ended the war.  Unknown reason for the loss.  Maybe Uyo action, maybe Ancient action  responsible." }
	}
	questions[11400] = {
		action="jump", goto=11401,
		player="[AUTO_REPEAT]",
		playerFragment="when your race was 'shattered'",
		alien={"Exact records are lost.  Mental imprints of events destroy the time sense.  Estimate in your clock system would be hundreds of millions of years ago.  What you see as Minex is not who we have been in the past." }
	}
	questions[11401] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		playerFragment="how could your race be hundreds of millions of years old",fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Minex have taken on many genetic forms and developed many divergent technologies.  All change is rejected yet change takes place.  Mental imprints upon our young have preserved only the essential fragments of our history.  Our society has been destroyed, conquered, and transformed countless times.  Our history and knowledge is all that unites us with our past selves.  Everything else is transitory." }
	}

	questions[20000] = {
		action="jump", goto=20001,
		player="[AUTO_REPEAT]",
		playerFragment="about other races",
		alien={"Other races rise and fall.  They are irrelevant.  The contagion unifies and strengthens them to attack us.  We will not be capable of holding a defense posture forever." }
	}

	questions[20001] = {
		action="branch",
		choices = {
			{ text="Other races irrelevant", goto=21000 },
			{ title="Military assistance", text="Will you help us with..", goto=22000 },
			{ text="Exchange technology", goto=23000 },
			{ text="Didn't you cease your warfare?", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="[AUTO_REPEAT]",
		playerFragment="why you are even talking to us if you consider other races irrelevant", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Minex have never been in debt to an alien before.  Your species immunity to the contagion is also unique and not understood." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="[AUTO_REPEAT]",
		alien={"No.  Focus on finding the Ancients and/or stopping the contagion.  Your other concerns are irrelevant." }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="[AUTO_REPEAT]",
		introFragment="There are many ways we can help each other.   If you are willing to open your database, so are we.",
		playerFragment="your technology in exchange for ours. Between us we may be able to find a solution to defeat this virus.", fragmentTable=preQuestion.desire,
		alien={"No.  Your race is unknown to us.  You have no history in this sector.  Your technology is already refined.  Combining technologies will not solve the problem.  We have scouted and controlled this particular region of space for tens of thousands of years.  This technology is far outside both of our sciences, not merely beyond it.  Investigate and search for its source.  Start at Lir IV." }
	}
	questions[23001] = {
		action="jump", goto=20001,
		title="Lir IV",
		player="[AUTO_REPEAT]",
		playerFragment="what is located at Lir IV", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"We know this area of space.  The planetary system of that M-class star repels us psychically.  The In'tral'ess may be there. The nomadic wanderers within that territory may know more. Ask them." }
	}
	questions[24000] = {
		action="jump", goto=24001,
		player="[AUTO_REPEAT]",
		playerFragment="what you mean by a defense posture.  You declared that you had ceased your warfare", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Allowing contagion directed aliens freedom of movement only allows those who are infected to gather their strength and attack us more effectively.  We give you this window of time to work towards finding a cure.  If our existence is threatened further we will resume destroying fleets and start annihilating population centers." }
	}
	questions[24001] = {
		action="jump", goto=20001,
		player="[AUTO_REPEAT]",
		playerFragment="what you mean by population centers", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Planets.  We have a limited but sufficient number of artifacts that may destroy homeworlds.  These are last resort weaponry.  No further inquiries will be answered on this subject." }
	}

	questions[30000] = {
		action="jump", goto=30001,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"Minex develop mind imprinting of offspring allow us accurate transmission of historical and technological knowledge.  The Uyo develop space transport technology and begin systematically eliminating all other sentient life.  Energy beings you call Ancients step in and destroy the Uyo completely.  The Ancients leave.  We begin the unending struggle to restore ourselves to our former state."}
	}

	questions[30001] = {
		action="branch",
		choices = {
			{ text="Mind imprinting technology", goto=31000 },
			{ text="The Uyo.", goto=32000 },
			{ text="Restore yourselves?", goto=33000 },
			{ text="Previous war against the Uyo", goto=34000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31000] = {
		action="jump", goto=30001,
		player="[AUTO_REPEAT]",
		playerFragment="about your mind imprinting technology",
		alien={"We will not impart that knowledge or answer any inquiries on this subject" }
	}
	questions[32000] = {
		action="jump", goto=32001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Uyo",
		alien={"They were the enemy of all races.  They fought in planet bound environments only, specializing in telepathic destruction and biological warfare.  Every Uyo-inhabited planet acted as a single individual with every biological organism acting as a cell of the individual.  They emitted a powerful telepathic presence felt hundreds of sectors away by any one of us." }
	}
	questions[33000] = {
		action="jump", goto=30001,
		player="[AUTO_REPEAT]",
		playerFragment="why your people need to restore yourselves", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The In'tral'ess or Ancients gifted us or enhanced us with the mental powers to fight the Uyo.  Much knowledge over the ages has been lost.  Either the Uyo genetically damaged us or the eternal ones may have withdrawn their gifts.  Without them, we are shattered and crippled." }
	}
	questions[34000] = {
		action="jump", goto=30001,
		player="[AUTO_REPEAT]",
		playerFragment="what the war against the Uyo was like", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"You have no concept of real war.  Your war consists of pushing buttons and watching technology fight.  With the gifts of the eternals we struggled endlessly against the minds of the destroyers simultaneously coordinated with our technological firepower." }
	}
	questions[32001] = {
		action="branch",
		choices = {
			{ title="Origin of the virus", text="Could the Uyo be the source of this virus?", goto=32100 },
			{ title="Collective intelligence", text="Are you saying that every Uyo planet acted like a person?", goto=32200 },
			{ text="Tell us about the Uyo 'transport technology'?", goto=32300 },
			{ text="How did the Ancients stop the Uyo?", goto=32400 },
			{ text="<Back>", goto=30001 }
		}
	}
	questions[32100] = {
		action="jump", goto=32001,
		player="[AUTO_REPEAT]",
		alien={"It is possible that they released this virus but not likely.  We do not feel their presence now.  Some other race may have simply uncovered their technology.  We have been searching for their telepathic signature widely and will continue to do so.  Non-telepathic races cannot assist." }
	}
	questions[32200] = {
		action="jump", goto=32001,
		player="[AUTO_REPEAT]",
		alien={"Yes, an incredibly intelligent creature whose intelligent was proportional to the number of Uyo 'lifeforms' in communal telepathic communication.  The group mind could only focus on one thing at a time and was incredibly slow.  Individual Uyo had no awareness and could not respond or fight back.  The Uyo could only deal with individualistic races as a virus, and create an antibodies to fight them on a biological level.  This contagion bears their handiwork." }
	}
	questions[32300] = {
		action="jump", goto=32001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Uyo transport technology",
		alien={"The Uyo could only function as intelligent creatures in vast numbers.  They used circular vessels with incredibly powerful shielding and no weaponry to travel.  Somehow these vessels built up power over long periods of time before instantly jumping to their destination.  Occasionally we have found mysterious ships with organic computers still drifting in the cosmos matching this historical description." }
	}
	questions[32400] = {
		action="jump", goto=32001,
		player="[AUTO_REPEAT]",
		playerFragment="how the ancients stopped the Uyo in the past", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The Ancients were grand designers.  Although it took them ages before they intervened, they cured the virus on a galactic scale and somehow were able to neutralize the telepathic ability of the Uyo.  This neutralized and destroyed all known colonies in a single generation.  We do not know how they did this." }
	}

	questions[40000] = {
		action="jump", goto=40001,
		player="[AUTO_REPEAT]",
		playerFragment="about the ancients",
		alien={"The ancients or the eternal ones are energy beings.  They have left this space-time continuum.  We feel that one of their centers was on the outer planet of a yellow star, but remember not where."}
	}

	questions[40001] = {
		action="branch",
		choices = {
			{ text="Appearance of the ancients", goto=41000 },
			{ text="What the ancients did", goto=42000 },
			{ text="Where they are now", goto=43000 },
			{ text="Contacting the ancients", goto=44000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[41000] = {
		action="jump", goto=40001,
		player="[AUTO_REPEAT]",
		playerFragment="what the ancients appeared to look like", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Unknown.  Description lost over time." }
	}
	questions[42000] = {
		action="jump", goto=40001,
		player="[AUTO_REPEAT]",
		playerFragment="what activities the ancients were known to do", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Explore and expand their territory.  Turn inwards and improve themselves.  Isolate themselves from influencing other races.  Declare war when forced.  We emulate their behavior as best we can." }
	}
	questions[43000] = {
		action="jump", goto=40001,
		player="[AUTO_REPEAT]",
		playerFragment="where the ancients went", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Unknown.  Beyond our understanding." }
	}
	questions[44000] = {
		action="jump", goto=44001,
		player="[AUTO_REPEAT]",
		playerFragment="how to contact the ancients", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"This may be impossible.  We could communicate with them only in ancient times when our minds were at full strength and then only at research sites.  These sites have been lost.  No evidence has been seen of any Ancient activity in past eons." }
	}
	questions[44001] = {
		action="jump", goto=40001,
		player="[AUTO_REPEAT]",
		playerFragment="where could we find ancient research sites", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Search out Ancient ruins.  Contact other alien races.  Ancients did not congregate for social reasons, but Ancient research sites, often misnamed 'cities of the ancients' contained their most advanced technology and operated as communication junctions." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Current news", goto=50001 },
			{ text="Stopping the virus and the infected ones", goto=60000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[50001] = {
		action="jump", goto=50000,
		player="[AUTO_REPEAT]",
		playerFragment="about current events",
		alien={"All relevant events are current. Focus your inquiries." }
	}
	questions[60000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="what we can do to stop the virus and cure those already infected", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The eternals gifts are not completely restored by that which you have returned to us.  In ancient times we could feel the presence of the destroyers a galaxy span's away.  We must find the destroyers.  They controlled this virus in ancient times.  They may have returned again.  Find similar Ancient technology.  Find the Ancients.  Find the source of the Uyo technology." }
	}
	questions[60001] = {
		action="branch",
		choices = {
			{ text="Ancient technology", goto=61000 },
			{ text="Finding the ancients", goto=62000 },
			{ text="Finding the source of the Uyo technology", goto=63000 },
			{ text="Details of the virus or 'the contagion'", goto=64000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[61000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about where ancient technology may be found",
		alien={"Search out ancient ruins.  Contact other alien races.  Ancients did not congregate for social reasons, but ancient research sites often misnamed 'Cities of the Ancients' contained their most advanced technology." }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="how we can find the ancients", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"This may be impossible.  The eternal ones could shape matter but they themselves were never seen.  They manipulated stars, changed the mass of planets, wiped out whole solar systems where the destroyers gained strongholds.  We could communicate with them only in ancient times when our minds were at full strength and then only at research sites.  These sites have been lost.  No evidence has been seen of any Ancient activity in past eons." }
	}

	questions[63000] = {
		action="jump", goto=63001,
		player="[AUTO_REPEAT]",
		playerFragment="about the source of the Uyo technology",
		alien={"Unknown.  This virus is most likely a technological remnant of their existence.  Our mission now is to search the galaxy to find them and stop them if they still exist.  You may help us find them but only scout.  We alone have any hope of opposing them.  Report to us any progress." }
	}
	questions[63001] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		alien={"The Uyo have only one remaining base that has yet to be penetrated and destroyed.  All other locations have been sterilized when defenses fell.  Only the base at the star that you know of as Cermait 6 has yet to be breached." }
	}
	questions[64000] = {
		action="jump", goto=64001,
		player="[AUTO_REPEAT]",
		playerFragment="about the virus itself or the contagion",
		alien={"All we know is that it is a stealthed nano assembler with two functions.  The first is to damage nothing with the exception of sentient beings.  When sentient beings are detected, create a continual flood of custom biological bacteria to reduce sentient populations and render them susceptible to telepathic control." }
	}
	questions[64001] = {
		action="branch",
		choices = {
			{ title="Vaccination", text="Do you know how vaccinate against the virus?",  goto=64100 },
			{ text="Infected Minex?", goto=64200 },
			{ title="Reversing infected madness", text="Do you know how to reverse the madness?", goto=64300 },
			{ title="A cure for the virus", text="Do you know how to cure the virus?", goto=64400 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[64100] = {
		action="jump", goto=64001,
		player="[AUTO_REPEAT]",
		alien={"No." }
	}
	questions[64200] = {
		action="jump", goto=64001,
		player="[AUTO_REPEAT]",
		playerFragment="about what the virus does to the Minex",
		alien={"It kills Minex instantly with no dormancy period.  Detection of infected areas is easy for us and sterilization unnecessary." }
	}
	questions[64300] = {
		action="jump", goto=64001,
		player="[AUTO_REPEAT]",
		alien={"No." }
	}
	questions[64400] = {
		action="jump", goto=64001,
		player="[AUTO_REPEAT]",
		alien={"Find and ask the ancients.  Only they know." }
	}
 end
end


function QuestDialogueinitial()

end

function QuestDialoguevirus()

--[[
title="Mission #37:  Catching the Smugglers.",
--]]
	questions[77000] = {
		action="jump", goto=1,
		title="Catching the Smugglers",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are on official Myrrdan business to track down two dangerous criminal starships of our own race.",
		playerFragment="any information that could help us find them",
		alien={"Your internal matters are none of our concern." }
	}

--[[
title="Mission #38:  Collecting Genetic Samples"
--]]
	questions[78000] = {
		action="jump", goto=999, -- Attack the player
		title="Genetic Samples",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are working with a team of medical researchers attempting to find a cure for this plague.",
		playerFragment="samples of genetic material from members of your race", fragmentTable=preQuestion.desire,
		alien={"lxlxlxlxlxlxlxlxlx" }
	}

--[[
title="Mission #43:  Desperate Measures
--]]

	questions[83000] = {
		action="jump", goto=83001,
		title="Desperate Measures",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  It is extremely important that we talk to you about this fabricated Bar-Zhon - Myrrdan incident.",
		playerFragment="any information that could help us", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Your internal matters are none of our concern." }
	}
	questions[83001] = {
		action="jump", goto=997, --- Terminate the conversation
		player="But this matter is between us and the Bar-Zhon.",
		alien={"Your external matters are none of our concern either." }
	}

--[[
title="Mission #45:  Alien Healthcare Scam - no sample
--]]

	questions[85000] = {
		action="jump", goto=997,
		title="Plague Treatment",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are investigating reports of a medical treatment that minimizes or stops the periods of madness caused by the plague.",
		playerFragment="about it",
		alien={"Subject irrelevant. Do not bother us." }
	}

--[[
title="Mission #45:  Alien Healthcare Scam - sample
--]]

	questions[85500] = {
		action="jump", goto=997,  ftest= 1, -- transport drugs sample to alien
		title="Plague Treatment",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are investigating this medical treatment drug that minimizes or stops the periods of madness caused by the plague.  We are transporting over the information needed to synthesize it.",
		playerFragment="about it",
		alien={"Ineffectual." }
	}



end
function QuestDialoguewar()

--[[
title="Special Encounter with Captain Xenon"
--]]

	questions[90000] = {
		action="jump", goto=90002,
		player="General Information",
		playerFragment="about..",
		alien={"All in quarantine.  All are infected and your travel spreads contagion.  Return to your home world.....Clank!"}
	}
	questions[90002] = {
		action="jump", goto=90003,
		player="<More>",
		alien={"Danger Captain Xenon, Danger! ... Turn that thing off!  I'm telling ya...a guy just don't get no respect around here.  What if that fool Myrdannian heard that?"}
	}
	questions[90003] = {
		action="jump", goto=90004,
		title="Hey!",
		player="Hey!  I heard that!  This is Captain [CAPTAIN].  You are not Minex.  Who are you?",
		alien={"We've got a live one here.  Give him a prize.   So captain...you still doing that boldly going where nobody has gone before scthick?." }
	}
	questions[90004] = {
		action="jump", goto=90001,
		title="Who are you?",
		player="Uhh...Who are you and what do you want?",
		alien={"Captain Xenon at your service.  That's a pretty big demand from somebody piloting a clinking clattering collection of caliginous junk you call a 'starship'... Why don't you simply hand over the whirling disk if you want to live?" }
	}
	questions[90001] = {
		action="branch",
		choices = {
			{ title="Appearance", text="Why do you look like a Minex and your fellow pirates appear to be Minex warships?", goto=91000 },
			{ title="Prize", text="What prize did I win?", goto=92000 },
			{ title="Minex Territory", text="How are you avoidiing the Minex?  Don't they see through that hologram trick?", goto=93000 },
			{ title="Whirling Disk", text="Why do you want this whirling disk artifact?  It does nothing but give my crew headaches when we look at it.", goto=94000 },
			{ text="<END COMM>", goto=99000 }
		}
	}
	questions[91000] = {
		action="jump", goto=91001,
		player="[AUTO_REPEAT]",
		alien={"Pirates?  You wound me sir.  You cut me to the quick with your unjust accusations. Unconventional entrepreneurs would describe us more fairly. As for our appearance, nothing is safer than traveling around in Minex territory looking like Minex.  You may prefer to look at an image of June Lockhart but this holographic gizmo can only do so much." }
	}
	questions[91001] = {
		action="jump", goto=90001,
		player="I demand you show your true appearance!",
		alien={"Make any demands and in 2...no, I mean one minute, your charred and sizzling skeleton will be the main attraction on the bridge of your ship." }
	}
	questions[92000] = {
		action="jump", goto=90001,
		player="[AUTO_REPEAT]",
		alien={"You may have already won an all expense paid three-hour tour on the S.S. Minnow!  Simply transport over the whirling disk." }
	}
	questions[93000] = {
		action="jump", goto=90001,
		player="[AUTO_REPEAT]",
		alien={"That's for us to worry about.  A person has got to have some secrets" }
	}
	questions[94000] = {
		action="jump", goto=94002,
		player="[AUTO_REPEAT]",
		alien={"You snatched that artifact from one of my drops Captain. 'Oh!  We only holorecord artifacts here'  It is a valued heirloom and not from this sector." }
	}
	questions[94002] = {
		action="jump", goto=94001,
		player="What you mean 'not from this sector?'",
		alien={"Exactly that.  My men and I have been in cryo for a long time.  We followed the Elowan & Thrynn out here.  That whirling disk is my property." }
	}

	questions[94001] = {
		action="branch",
		choices = {
			{ title="Borno", text="What can you tell me about this Inspector Borno who is after you?", goto=94100 },
			{ title="Harrison", text="Your real name is Harrison!", goto=94200 },
			{ title="Human Colony", text="Would you tell me about the human world you came from?  Was it Earth?", goto=94300 },
			{ title="Under Arrest", text="Under my authority as a representative of Myrrdan, I am placing you under arrest for piracy.", goto=94400 },
			{ text="<END COMM>", goto=99000}
		}
	}
	questions[94100] = {
		action="jump", goto=94101,
		player="[AUTO_REPEAT]",
		alien={"Borno?  That inbred Bar-zhon moron with a great PR team?  Hey!  Next time you run into him tell him that the Minex are giving me sanctuary.  Hee hee." }
	}
	questions[94101] = {
		action="jump", goto=94001,
		player="Why would we do that?",
		alien={"Someone is as sharp as a hot butter knife today." }
	}
	questions[94200] = {
		action="jump", goto=94001,
		player="[AUTO_REPEAT]",
		alien={"How did you know?  ...  Ohh, Some of my men have been sloppy I see.  All right, I'll give you credit for figuring out that my real name.  Not that you actually know anything about Harrison." }
	}
	questions[94300] = {
		action="jump", goto=94301,
		player="[AUTO_REPEAT]",
		alien={"Earth is a deep-fried rocky ruin devoid of all life. My men and I are defectors from another Noah colony of stuffed shirts and corporate types." }
	}
	questions[94301] = {
		action="jump", goto=94302,
		player="Why did you leave?",
		alien={"The environmental tree-hugging nut cases banned endurium and all space travel!  The rocks are alive!  Do you have any Dilithium crystals you could spare?  Hee Hee." }
	}
	questions[94302] = {
		action="jump", goto=94001,
		player="Where is this colony?",
		alien={"Ohh, far outside the sector. It would take you years to get there and require more fuel than your ship can hold. Besides why would you want to in the first place?  The retro savages probably reverted to another dark age and dropped another letter from their planet's name by now." }
	}
	questions[94400] = {
		action="jump", goto=94401,
		player="[AUTO_REPEAT]",
		alien={"Don't think that this ship and my boys are incapable of defending ourselves.  You have two choices if you arm your weapons. Die quickly or die for nothing." }
	}
	questions[94401] = {
		action="jump", goto=94001,
		player="Surrender now!",
		alien={"I can't hear you...  Let's try this again now.  I am a rather dashing buccaneer with a fleet of heavily, I repeat, heavily armed Minex ships behind him. You are the lonely underequipped starship far outside your territory.  Any hostilities on your part will result in you instantly becoming the most unpopular person on what is left of your ship." }
	}
	questions[99000] = {
		action="jump", goto=99001,
		player="[AUTO_REPEAT]",
		alien={"Enough chitchat.  Hand over my whirling disk.  You could be lucky today, or, you could be stupid. Make a choice, pal." }
	}
	questions[99001] = {
		action="branch",
		choices = {
			{ title="Yes, here it is", text="Sure thing.  I don't know what we would do it anyway.", goto=99002 },
			{ title="No", text="Myrrdan ships do not respond well to threats. Remember that next time.", goto= 99100},
			{ text="<END COMM>", goto=99100 }
		}
	}
	questions[99002] = {
		action="jump", goto=99003,  ftest= 1, -- remove whirling disk
		player="[AUTO_REPEAT]",
		alien={"Thanks Capt.  I do appreciate it. By the way, many of my men are enjoying their retirement with Myrrdan hospitality so let me give you a few tips.  I'd hate for another human world to be overrun.  Beware of the Thrynn.  The Elowan are the innocent ones. They also have a better understanding of history and know far more about the ancients than they let on." }
	}
	questions[99003] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		alien={"Ohh, and the Bx, Sabion, and Transmodra had an endless fascination for advanced technology and that means Minex tech and possibly the technology behind this virus. Talk to the Coalition and find their former home worlds.  Good luck!"  }
	}
	questions[99100] = {
		action="jump", goto=997,  ftest= 1, -- remove whirling disk and 1/3rd of all endurium
		player="[AUTO_REPEAT]",
		alien={"Good thing you gave me enough time to analyze your shield frequency. I'll be taking that now and a little extra.  See you around [CAPTAIN], but I suspect you won't."  }
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
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  Myrrdan picked up an emergency distress signal from the Starbase at Ceridwen in the Ailil system (188, 88).",
		playerFragment="about the attack on the Bar-zhon in that system",
		alien={"You were warned about this already." }
	}
	questions[80001] = {
		action="jump", goto=80002,
		title="What were we warned of?",
		player="[AUTO_REPEAT]",
		playerFragment="what we were warned about", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Allowing contagion directed aliens freedom of movement only allows those who are infected to gather their strength and attack us all more effectively.  We ceased culling the infected due to your request." }
	}
	questions[80002] = {
		action="jump", goto=1, ftest= 1, -- end the mission
		player="What was their objective?",
		playerFragment="what their objective was at Ceridwen", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The virus now has exceeded the number of sentients it can control. Those superfluous numbers are used for low priority objectives such as this.  It is seeking the isolation of cooperating races through terror tactics.  It knows that much pressure will be placed upon keeping spaceships held in defensive orbits from now on, limiting you.  This is all we have to say upon this subject. (Mission Completed)" }
	}

--[[
title="Mission #62:  The Crazed Spemin - initial
--]]

	questions[82000] = {
		action="jump", goto=997, ftest= 1, -- give player artifact376 Minex Data Cube
		title="The Spemin Project",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="about these questions you wanted us to ask the Spemin",
		alien={"Your superiors briefed you on this endeavor.  Do not convey weakness or indecision.  If Tri'na'li'da determines that you are falsely impersonating the Uyo your world could be targeted and wiped out within hours. Ask only questions as prompted by the artificial intelligence.  Return to your people when finished." }
	}

--[[
title="Mission #62:  The Crazed Spemin - returning with loaded cube
--]]

	questions[82500] = {
		action="jump", goto=997, -- Terminate
		title="The Spemin Project",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME]. We have the data cube with all of the Spemin responses.",
		playerFragment="for it",   fragmentTable=preQuestion.desire,
		alien={"Irregular. Our contract with Myrrdan grants your people access to this data first. We do not honor nor permit breaking of contracts." }
	}

end

function OtherDialogue()


	-- attack the player because attitude is too low
	questions[910] = {
		action="jump", goto=999,
		player="What can you tell us about...",
		alien={"<Tick><Humm><...Silence...><Tick>" }
	}
	-- hostile termination question
	questions[920] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"<Untranslatable>" }
	}
	-- neutral termination question
	questions[930] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"You will now depart immediately." }
	}
	-- friendly termination question
	questions[940] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"You will now depart." }
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


--function QuestDialogue()





--end

--[[ -------------------------------------------------------------------
--Randomized ship characteristics, 1st pass:
----------------------------------------------------------------------]]
function GenerateShips()

    -- COMBAT VALUES FOR THIS ALIEN RACE
--[[
    health = 100                    -- 100=baseline minimum
    mass = 10                       -- 1=tiny, 10=huge
	engineclass = 6
	shieldclass = 6
	armorclass = 6
	laserclass = 6
	missileclass = 6
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 25			-- % of damage received, used for racial abilities, 0-100%
	--]]

if (plot_stage == 1) or (plot_stage == 2) then -- initial and virus plot states

	health= 100
	mass= 10

	-- If the player's ship is fast, the alien ships are always just as fast. This applies to most Minex systems
	engineclass= gen_random(6)
	if (engineclass < 3) then						engineclass= 3						end
	if (engineclass < ship_engine_class) then		engineclass= ship_engine_class - 1		end

	shieldclass= gen_random(6)
	if (shieldclass < 1) then						shieldclass= 1						end
	if (shieldclass < ship_shield_class) then		shieldclass= ship_shield_class		end


	armorclass= 4

	laserclass= gen_random(3)
	if (laserclass < 1) then						laserclass= 1						end
	if (laserclass < (ship_laser_class -2)) then	laserclass= (ship_laser_class -2)  	end


	missileclass= gen_random(6)
	if (missileclass < 3) then						missileclass= 3						end
	if (missileclass < ship_missile_class) then	missileclass= ship_missile_class   	end


	laser_modifier= 100

	missile_modifier= gen_random(40)
	if (missile_modifier < 5) then 				missile_modifier= 5					end



elseif (plot_stage == 3) or (plot_stage == 4) then -- war and ancients plot states

	-- Some of these ships are very damaged and very far from home
	health= gen_random(100)
	if (health < 10) then							health= 10							end

	-- These ships are now slightly more maneuverable sometimes
	mass= 7

	engineclass= gen_random(6)
	if (engineclass < 3) then						engineclass= 3						end
	if (engineclass < ship_engine_class) then		engineclass= ship_engine_class - 2		end

	shieldclass= gen_random(6)
	if (shieldclass < 3) then						shieldclass= 3						end
	if (shieldclass < ship_shield_class) then		shieldclass= ship_shield_class		end


	armorclass= 4

	laserclass= gen_random(3)
	if (laserclass < 1) then						laserclass= 1						end
	if (laserclass < (ship_laser_class -2)) then	laserclass= (ship_laser_class -2)  	end


	missileclass= gen_random(6)
	if (missileclass < 3) then						missileclass= 3						end
	if (missileclass < ship_missile_class) then	missileclass= ship_missile_class   	end

    -- Effectively make all ships twice as strong as they were in the initial phase versus lasers
	laser_modifier= 50

	-- Average out missile damage even lower
	missile_modifier= gen_random(20)
	if (missile_modifier < 5) then 				missile_modifier= 5				end

end

end


------------------------------------------------------------------------
-- SCRIPT INITIALIZATION -----------------------------------------------
------------------------------------------------------------------------
function Initialize()
	GenerateShips()		--Build aien ships.
	SetPlayerTables()

	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in

if (plot_stage == 1) then -- initial plot state

	DROPITEM1 = 21;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Minex Golden Device
	DROPITEM2 = 22;		DROPRATE2 = 80;	    DROPQTY2 = 1 -- Minex Electronics
	DROPITEM3 = 23;		DROPRATE3 = 90;		DROPQTY3 = 1 -- Minex Silver Gadget
	DROPITEM4 = 53;		DROPRATE4 = 40;		DROPQTY4 = 2
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 10 -- Endurium

elseif (plot_stage == 2) then -- virus plot state

	DROPITEM1 = 229;	DROPRATE1 = 80;		DROPQTY1 = 1 -- Minex genetic material
	DROPITEM2 = 22;		DROPRATE2 = 90;	    DROPQTY2 = 1 -- Minex Electronics
	DROPITEM3 = 23;		DROPRATE3 = 90;		DROPQTY3 = 1 -- Minex Silver Gadget
	DROPITEM4 = 21;		DROPRATE4 = 90;		DROPQTY4 = 1 -- Minex Golden Device
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 10 -- Endurium

elseif (plot_stage == 3) then -- war plot state

	DROPITEM1 = 275;	DROPRATE1 = 90;		DROPQTY1 = 1 -- Minex Power Core
	DROPITEM2 = 22;		DROPRATE2 = 90;	    DROPQTY2 = 1 -- Minex Electronics
	DROPITEM3 = 23;		DROPRATE3 = 90;		DROPQTY3 = 1 -- Minex Silver Gadget
	DROPITEM4 = 53;		DROPRATE4 = 40;		DROPQTY4 = 2
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 10 -- Endurium

elseif (plot_stage == 4) then -- ancients plot state

	DROPITEM1 = 21;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Minex Golden Device
	DROPITEM2 = 22;		DROPRATE2 = 90;	    DROPQTY2 = 1 -- Minex Electronics
	DROPITEM3 = 23;		DROPRATE3 = 90;		DROPQTY3 = 1 -- Minex Silver Gadget
	DROPITEM4 = 53;		DROPRATE4 = 40;		DROPQTY4 = 2
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 10 -- Endurium

end

	FTEST= -1	--FTEST is used to activate the commFxn, for decision making during conversations.

	--initialize dialog

	--active_quest = 17  	--  debugging use
	--artifact13 = 1		--  debugging use

if (plot_stage == 1) then -- initial plot state



	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low
	elseif player_profession == "military" and active_quest == 34 then
	    first_question = 999 -- attack
	elseif player_profession == "military" and active_quest == 35 then
	    first_question = 999 -- attack
	elseif player_profession == "freelance" and active_quest == 33 then
	    first_question = 999 -- attack
	end

	first_question = 1


elseif (plot_stage == 2) then -- virus plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low

	elseif active_quest == 37 then -- catching the smugglers
		first_question = 77000

	elseif active_quest == 38 then -- medical samples
		first_question = 78000


-- Mission #43:  Framed!
	elseif active_quest == 43 then
		first_question = 83000

-- Mission #45:  Healthcare Scam - no medical treatment sample
	elseif active_quest == 45 and artifact265 == 0 and artifact266 == 0 then
		first_question = 85000

-- Mission #45:  Healthcare Scam - medical treatment sample
	elseif active_quest == 45 and artifact265 == 1 and artifact266 == 0 then
		first_question = 85500
	else
		first_question = 1
	end


elseif (plot_stage == 3) then -- war plot state

-- Player picked up artifact394 - the Whirling Disk triggering an encounter with Xenon
	if artifact394 == 1 then
		first_question = 90000
	elseif ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low
	elseif active_quest >= 48 and active_quest <= 53 then
		first_question = 910 -- Attack the player during the first couple missions of the Minex war stage.
	else
		first_question = 1
	end

elseif (plot_stage == 4) then -- ancients plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low

-- Mission #60: Overrun
	elseif active_quest == 60 then
		first_question = 80000

-- Mission #62:  The Crazed Spemin -- initial
	elseif active_quest == 62 and artifact376 == 0 and artifact377 == 0 then
		first_question = 82000

-- Mission #62:  The Crazed Spemin -- returning with loaded cube
	elseif active_quest == 62 and artifact376 == 0 and artifact377 == 1 then
		first_question = 82500





	else
		first_question = 1
	end

end


	-- first_question = 90000 -- Artifact store
	starting_attitude = 100
	starting_posture = "obsequious"
	current_question = first_question
	next_question = first_question


	-- Attitude this value and higher unlocks all questions, alien lowers their shields, maximum number of questions may be asked
	friendlyattitude = 50
	-- Attitude this value and higher is a neutral attitude, alien disarmed weapons but has raised shields
	neutralattitude = 45


	--initialize globals as needed
	if ATTITUDE == nil then ATTITUDE = starting_attitude end
	if POSTURE == nil then POSTURE = starting_posture end


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
			{ text="GENERAL INFO", goto=50000 }
		}
	}

	StandardQuestions()

-- load questions

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
--]]
end

--[[ The communications function makes more involved decisions on what to do
	 based on type of communication (0: greeting,  1: statement,  2: question),
	 the ftest value passed back from the table (must be >= 1 for commFxn to be
	 invoked at all), and the question/statement number, n. Other variables
	 pulled in as needed from the script; in Lua everything is global unless
	 explicitly declared local. 											--]]
function commFxn(type, n, ftest)
	if (ftest < 1) then
		return
	elseif (type == 0) then							--greeting
	elseif (type == 1) then							--statement

	elseif (ftest == 4) then   --  Terminating question
		L_Terminate()
		return
	elseif (ftest == 5) then   --  Attack the player question
		L_Attack()
		return

	elseif (ATTITUDE < neutralattitude and number_of_actions > 4) then
		goto_question = 920 -- jump to hostile termination question
		number_of_actions = 0

	elseif (ATTITUDE < neutralattitude and number_of_actions > 4) then
		goto_question = 920 -- jump to hostile termination question
		number_of_actions = 0

	elseif (ATTITUDE < friendlyattitude and number_of_actions > 12) then
		goto_question = 930  -- jump to neutral termination question
		number_of_actions = 0

	elseif (number_of_actions > 20) then
		goto_question = 940  -- jump to friendly termination question
		number_of_actions = 0
	end


	if (plot_stage == 1) then -- initial plot state


	elseif (plot_stage == 2) then -- virus plot state


		if (n == 85500) then -- quest 45 make it look like transporting medical treatment
				artifact265 = 0
				artifact265 = 1
		end


	elseif (plot_stage == 3) then -- war plot state

		if (n == 99002) then
			artifact394 = 0 -- remove the whirling disk artifact
			number_of_actions = 0
		elseif (n == 99100) then
			artifact394 = 0 -- remove the whirling disk artifact
			player_Endurium= player_Endurium * 2 / 3
			number_of_actions = 0
		end

	elseif (plot_stage == 4) then -- ancients plot state

		if (n == 80002) then -- quest 60 overrun- EVERYONE PLAYS THROUGH - NO SKIPPING
			--jjh	if player_profession == "military" then
			--		active_quest = active_quest + 3
			--	elseif player_profession == "freelance" then
			--		active_quest = active_quest + 2
			--	else -- scientific
					active_quest = active_quest + 1
			--	end

		elseif (n == 82000) then -- quest 62 The Crazed Spemin
				artifact376 = 1 -- Minex Data Cube
		end
	end
end
