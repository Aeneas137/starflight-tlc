--[[------------------------------------------------------------------------------------------------------------------------------------------------- ]
	ENCOUNTER SCRIPT FILE: THRYNN

	Last Modified:  May 28, 2014

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

		obsequiousGreetTable= {
			"We are thynynthrynn, the shield of the Thrynn confederacy.  We are the elite guard.  Why are you here?",
			"In the name of the Thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.",
			"This is shield unit Thryssanyn, second force guard of the Thrynn.",
			"A Prophet once declared it is the destiny of the Thrynn to rule the galaxy.  You recognize this to your credit.",
			"Appropriate understanding are necessary for the survival of all individuals and species alike.",
			"The Thrynn military is a formidable force.  Consider aiding our military machine, for the benefits to you would be incalculable."
	}

elseif (plot_stage == 2) then -- virus plot state

		obsequiousGreetTable= {
			"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."
	}

elseif (plot_stage == 3) then -- war plot state

		obsequiousGreetTable= {
			"We are thynynthrynn, the shield of the Thrynn confederacy.  We are the elite guard.  Your homeworld territory is unfortunate, but you should know that we no longer classify your race as pirates.  Why are you here?",
			"In the name of the Thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.  Your homeworld territory is unfortunate, but you should know that we no longer classify your race as pirates.",
			"This is shield unit Thryssanyn, second force guard of the Thrynn.  Your homeworld territory is unfortunate, but you should know that we no longer classify your race as pirates.",
			"A Prophet once declared it is the destiny of the Thrynn to rule the galaxy.  You recognize this to your credit.",
			"Appropriate understanding are necessary for the survival of all individuals and species alike.  Your homeworld territory is unfortunate, but you should know that the Thrynn no longer classify your race as pirates.",
			"The Thrynn military is a formidable force.  Consider aiding our military machine, for the benefits to you would be incalculable."
	}

elseif (plot_stage == 4) then -- ancients plot state

		obsequiousGreetTable= {
			"Our initial suspicions were correct.  You are Uyo!  Your people created and released this virus.  Your timing upon entering this sector, your advanced technology, your control of the Minex, your physical descriptions at the ancient sites all correspond.  We will exterminate your people!"
	}

end


if (plot_stage == 1) or (plot_stage == 2) or (plot_stage == 3) then -- initial or war plot states

	greetings[1] = {
		action="",
		player="Hail oh mighty ones, masters of the universe.",
		alien= 	obsequiousGreetTable }
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien= 	obsequiousGreetTable }
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
		alien=	obsequiousGreetTable }
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

elseif (plot_stage == 4) then -- virus or ancients plot states

	greetings[1] = {
		action="attack",
		player="Hail oh mighty ones, masters of the universe.",
		alien= 	obsequiousGreetTable }
	greetings[2] = {
		action="attack",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien= 	obsequiousGreetTable }
	greetings[3] = {
		action="attack",
		player="Greetings oh highest of the high most great alien beings.",
		alien= 	obsequiousGreetTable }
	greetings[4] = {
		action="attack",
		player="We respectfully request that you identify your vastly superior selves.",
		alien= 	obsequiousGreetTable }
	greetings[5] = {
		action="attack",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien=	obsequiousGreetTable }
	greetings[6] = {
		action="attack",
		player="Please do not harm us oh most high and mighty.",
		alien= obsequiousGreetTable }
	greetings[7] = {
		action="attack",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien= obsequiousGreetTable }
	greetings[8] = {
		action="attack",
		player="Please do not blast us into atomic particles.  Take pity on us who are not fit to grovel in your waste products.",
		alien= obsequiousGreetTable }
	greetings[9] = {
		action="attack",
		player="We can see that you are indeed the true race.  Pray enlighten us with your gems of infinite wisdom.",
		alien= obsequiousGreetTable }
	greetings[10] = {
		action="attack",
		player="We truly are not worth your trouble to destroy.",
		alien= obsequiousGreetTable }
	greetings[11] = {
		action="attack",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien= obsequiousGreetTable }
	greetings[12] = {
		action="attack",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien= obsequiousGreetTable }

end

end

------------------------------------------------------------------------
-- FRIENDLY DIALOGUE ---------------------------------------------------
------------------------------------------------------------------------
function FriendlyDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack

if (plot_stage == 1) then -- initial plot state

	friendlyGreetTable= {
		"Ahhh, just so. We of the Thrynn order wish peace as well.  How may we of service to each other?",
		"We are the Thrynn.  We sincerely hope that we shall both profit from this meeting.",
		"Greetings.  In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.",
	}

	friendlyAttitudeGreetTable= {
		"We are the Thrynn.  Commerce and mutual aid against a common cause - these are the important things to remember.",
		"Our races are much alike. We both know what is important. We must unite for the benefit of both our peoples.",
		"We are the Thrynn.  Supreme technology is the most noble goal of sentience. Join us in helping the less astute races become aware of this."
	}

elseif (plot_stage == 2) then -- virus plot state

		friendlyGreetTable= {
			"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."
	}

elseif (plot_stage == 3) then -- war plot state

		friendlyGreetTable= {
			"We are thynynthrynn, the shield of the thrynn confederacy.  We are the elite guard.  Your homeworld territory is unfortunate, but you should know that we no longer classify your race as pirates.  Why are you here?",
			"In the name of the Thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.  Your homeworld territory is unfortunate, but you should know that we no longer classify your race as pirates.",
			"This is shield unit Thryssanyn, second force guard of the Thrynn.  Your homeworld territory is unfortunate, but you should know that we no longer classify your race as pirates.",
			"Ahhh, just so.  We of the Thrynn order wish you peace as well.  Your homeworld territory is unfortunate, but you should know that we no longer classify your race as pirates.  I greet you and offer our hopes for friendship and mutual cooperation."
	}

	friendlyAttitudeGreetTable= {
		"We are the Thrynn.  Commerce and mutual aid against a common cause - these are the important things to remember.",
		"Our races are much alike. We both know what is important. We must unite for the benefit of both our peoples.",
		"We are the Thrynn.  Supreme technology is the most noble goal of sentience. Join us in helping the less astute races become aware of this."
	}

elseif (plot_stage == 4) then -- ancients plot state

		friendlyGreetTable= {
			"Our initial suspicions were correct.  You are Uyo!  Your people created and released this virus.  Your timing upon entering this sector, your advanced technology, your control of the Minex, your physical descriptions at the ancient sites all correspond.  We will exterminate your people!"
	}

end


if (plot_stage == 1) or (plot_stage == 2) or (plot_stage == 3) then -- initial or war plot states

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
		player="That is one crazy powerful ship you have there!",
		alien= friendlyGreetTable }
	greetings[5] = {
		action="",
		player="Greetings.  Your ship seems to be very powerful.",
		alien= friendlyGreetTable }
	greetings[6] = {
		action="",
		player="Hello there.  Your ship appears very elaborate.",
		alien= friendlyGreetTable }
	greetings[7] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien= friendlyGreetTable }
	greetings[8] = {
		action="",
		player="Greetings friend!  There is no limit to what both our races can gain from mutual exchange.",
		alien= friendlyGreetTable }


elseif (plot_stage == 4) then -- virus or ancients plot states

	greetings[1] = {
		action="attack",
		player="Greetings from the planet Myrrdan. We come in peace...usually.",
		alien= friendlyGreetTable }
	greetings[2] = {
		action="attack",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien= friendlyGreetTable }
	greetings[3] = {
		action="attack",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien= friendlyGreetTable }
	greetings[4] = {
		action="attack",
		player="That is one crazy powerful ship you have there!",
		alien= friendlyGreetTable }
	greetings[5] = {
		action="attack",
		player="Greetings.  Your ship seems to be very powerful.",
		alien= friendlyGreetTable }
	greetings[6] = {
		action="attack",
		player="Hello there.  Your ship appears very elaborate.",
		alien= friendlyGreetTable }
	greetings[7] = {
		action="attack",
		player="We come in peace from Myrrdan, please trust me.",
		alien= friendlyGreetTable }
	greetings[8] = {
		action="attack",
		player="Greetings friend!  There is no limit to what both our races can gain from mutual exchange.",
		alien= friendlyGreetTable }


end

end

------------------------------------------------------------------------
-- HOSTILE DIALOGUE ----------------------------------------------------
------------------------------------------------------------------------
function HostileDialogue()
	--add as many player greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack


if (plot_stage == 1) then -- initial plot state

		hostileGreetTable= {
		"You have made a grave mistake in angering the Thrynn.  We can be the best of friends but we are certainly the worst of enemies.",
		"We Thrynn were prepared to accept you fully as allies.  You have proven that you are not suitable.  Know we must list you amongst our enemies.",
		"We are the Thrynn.  We ask you not to incite trouble between our races.",
		"We Thrynn claim the right of free passage azz guaranteed all neutral races in the interplanetary treaty of 3190."
	}

elseif (plot_stage == 2) then -- virus plot state

		hostileGreetTable= {
			"Your ship's origin has been traced to the center of the outlaw territories.  You species is classified as pirates and you will be treated as such.  You are not welcome in this space."
	}

elseif (plot_stage == 3) then -- war plot state

		hostileGreetTable= {
		"You have made a grave mistake in angering the Thrynn.  We can be the best of friends but we are certainly the worst of enemies.",
		"We Thrynn were prepared to accept you fully as allies.  You have proven that you are not suitable.  Know we must list you amongst our enemies.",
		"We are the Thrynn.  We ask you not to incite trouble between our races.",
		"We Thrynn claim the right of free passage azz guaranteed all neutral races in the interplanetary treaty of 3190."
	}

elseif (plot_stage == 4) then -- ancients plot state

		hostileGreetTable= {
			"Our suspicions are correct.  You are Uyo!  Your people created and released this virus.  Your timing upon entering this sector, your advanced technology, your control of the Minex, your physical descriptions at the ancient sites all correspond.  We will exterminate your people!"
	}
end


if (plot_stage == 1) or (plot_stage == 3) then -- initial or war plot states

	greetings[1] = {
		action="attack",
		player="This is captain [CAPTAIN] of the starship [SHIPNAME]. Identify yourselves immediately or be destroyed.",
		alien= hostileGreetTable }
	greetings[2] = {
		action="attack",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien= hostileGreetTable }
	greetings[3] = {
		action="attack",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien= hostileGreetTable }
	greetings[4] = {
		action="attack",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien= hostileGreetTable }
	greetings[5] = {
		action="attack",
		player="We require information. Comply or be destroyed.",
		alien= hostileGreetTable }
	greetings[6] = {
		action="attack",
		player="Your ship is simple and weak.",
		alien= hostileGreetTable }
	greetings[7] = {
		action="attack",
		player="What an sorry excuse for a misshapen creature.",
		alien= hostileGreetTable }
	greetings[8] = {
		action="attack",
		player="Your ship looks like a flying garbage scow.",
		alien= hostileGreetTable }


elseif (plot_stage == 2) or (plot_stage == 4) then -- virus or ancients plot states

	greetings[1] = {
		action="attack",
		player="This is captain [CAPTAIN] of the starship [SHIPNAME]. Identify yourselves immediately or be destroyed.",
		alien= hostileGreetTable }
	greetings[2] = {
		action="attack",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien= hostileGreetTable }
	greetings[3] = {
		action="attack",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien= hostileGreetTable }
	greetings[4] = {
		action="attack",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien= hostileGreetTable }
	greetings[5] = {
		action="attack",
		player="We require information. Comply or be destroyed.",
		alien= hostileGreetTable }
	greetings[6] = {
		action="attack",
		player="Your ship is simple and weak.",
		alien= hostileGreetTable }
	greetings[7] = {
		action="attack",
		player="What an sorry excuse for a misshapen creature.",
		alien= hostileGreetTable }
	greetings[8] = {
		action="attack",
		player="Your ship looks like a flying garbage scow.",
		alien= hostileGreetTable }


end


end

function StandardQuestions()

	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

if (plot_stage == 1) or (plot_stage == 3) then

	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"As your senses tell you, we Thrynn are a reptilian carnivorous race, warm-blooded, with binocular vision and an internal skeletons as you.  We are however oviparous."}
	}
	questions[30000] = {
		action="jump", goto=30001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about your history",
		alien={"The colonization group which established this empire was sent out using an experimental artificial wormhole generating jump pod.  Unfortunately navigational coherency was lost and we have no idea how far or in what direction we traveled from.  Our colony ship contained the greatest leaders, scientists, and industrialists from our society."}
	}

	questions[40000] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"There are a lot of myths concerning the ancient ones.  We do not waste our time with legends and stories. The only relevant information is that they have left behind lumps of high energy crystal.  We are most concerned with locating their ruins for their energy resource value." }
	}
end

if (plot_stage == 1) then -- initial plot state

	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"We are currently embroiled in a conflict with a contagion known as the Elowan, a mutated plant strain which seeks the destruction of all animal life."}
	}
	questions[30001] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Unfortunately we carried to this sector a number of headfruit, seeds of a genetically engineered servant species known as the Elowan.  These Elowan recently rebelled and attempted to destroy all animal life.  Don't be deceived by the claims of the Elowan.  For the first time in this drawn-out conflict we hold the advantage and must pursue aggression against a plant monsters before they have a chance to regroup."}
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ title="Stop attacking the Elowan!", text="We demand that your race cease attacking the Elowan!",  goto=51000 },
--			{ text="Where is your home world?", goto=52000 },
			{ text="Are you looking for any technologies or artifacts?", goto=53000 },
			{ text="<Back>",  goto=1 }
		}
	}

elseif (plot_stage == 2) then -- virus plot state

	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"By the agreement of 17439 one is warned not to interfere in our affairs nor encroach upon our territory."}
	}
	questions[20000] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"By the agreement of 17439 one is warned not to interfere in our affairs nor encroach upon our territory."}
	}
	questions[30000] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"By the agreement of 17439 one is warned not to interfere in our affairs nor encroach upon our territory."}
	}
	questions[40000] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"By the agreement of 17439 one is warned not to interfere in our affairs nor encroach upon our territory."}
	}

	questions[50000] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		playerFragment="..",
		alien={"By the agreement of 17439 one is warned not to interfere in our affairs nor encroach upon our territory."}
	}

elseif (plot_stage == 3) then -- war plot state

	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"We are currently embroiled in a major conflict with the Minex.  We seek your aid in this endeavor."}
	}
	questions[30001] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Numerous threats throughout our history have imperiled our people in this region of space.  Only by eliminating hostile races do we ensure our survival."}
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ title="Stop attacking the Elowan !", text="We demand that your race cease attacking the Elowan!",  goto=51000 },
--			{ text="Where is your home world?", goto=52000 },
			{ text="Technologies or artifacts", goto=53000 },
			{ text="Current news", goto=60000 },
			{ text="<Back>",  goto=1 }
		}
	}
end


if (plot_stage == 1) or (plot_stage == 3) then

	questions[52000] = {
		action="jump", goto=50000,
		player="[AUTO_REPEAT]",
		alien={"Our home world is located at Semias 3 - 5,66."}
	}
	questions[53000] = {
		action="jump", goto=53001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about technology or artifacts you want",
		alien={"The Thrynn Confederacy values technological progress as the primary goal of our society.  We will pay well for the following items:"}
	}
	questions[53001] = {
		action="branch",
		choices = {
			{ text="Elowan Shield Capacitor",  goto=53100 },
			{ text="The Spiral Lens", goto=53200 },
			{ text="Bar-zhon Data Core", goto=53300 },
			{ text="Coalition Afterburner Unit", goto=53400 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[53100] = {
		action="jump", goto=53001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"The Elowan salvaged and duplicate a very advanced shielding module to protect their ships.  We will pay well for any Shield Capacitors that you are able to salvage." }
	}
	questions[53200] = {
		action="jump", goto=53001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"We have been made aware of a device known as The Spiral Lens.  This device was stolen from us by pirates.  Our intelligence has located it on the planet Eocho in the Etarlam (172,118) system at coordinates 47S X 95W.  We will pay well for its return." }
	}
	questions[53300] = {
		action="jump", goto=53001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"The Bar-zhon store considerable information on this sector inside a massive computer system in their ship.  If you are fortunate enough to retrieve an intact data core we will pay well for your efforts." }
	}
	questions[53400] = {
		action="jump", goto=53001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"The Bar-zhon pirates have developed an interesting new technology similar to our own superior propulsion systems.  If you happen to salvage a coalition afterburner unit we will purchase it because it's function is of great interest to us." }
	}

end

if (plot_stage == 1) then -- initial plot state

	questions[51000] = {
		action="jump", goto=51001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Hmm.  I would be most interested in the basis of your demand."}
	}
	questions[51001] = {
		action="branch",
		choices = {
			{ title="Demand with force", text="We will attack you if you do not cease.",  goto=51100 },
			{ title="Appeal to morality", text="Your attacks upon them are wrong!", goto=51200 },
			{ title="Appeal to reason", text="The Elowan are no threat to you.", goto=51300 },
			{ title="Offer to help", text="We will do anything you ask to bring about peace.", goto=51400 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[51100] = {
		action="jump", goto=999, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Do you challenge us of the elite guard with the supreme delete functionality?  Prepare to feel the full force of our weaponry!" }
	}
	questions[51200] = {
		action="jump", goto=50001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"The Thrynn greatly regret the necessity to bring destruction to another alien species.  Unfortunately war is the only possible method to resolve conflicts if diplomats fail and negotiations break down.  We were unjustly attacked first and if we do not end this conflict now it may continue indefinitely causing a much greater loss of life.  This responsibility we must not leave for our grandchildren." }
	}
	questions[51300] = {
		action="jump", goto=50001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"At the current time this may be true, but it was not true in the recent past and may not be true in the future.  This universe is ruled by the aggressive use of force and the only true source of peace is victory." }
	}
	questions[51400] = {
		action="jump", goto=50001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"Perhaps this idea has merit.  Profess to the Elowan an interest in their ships and defenses and take appropriate actions from their response." }
	}

elseif (plot_stage == 3) then -- war plot state

	questions[51000] = {
		action="jump", goto=51001,
		player="[AUTO_REPEAT]",
		alien={"We already have.  Although Elowan weaponry is almost useless against the Minex, we have persuaded them to act as cannon fodder when we are attacked."}
	}
	questions[51001] = {
		action="branch",
		choices = {
			{ text="Convince the Elowan",  goto=51100 },
			{ text="War against the Minex", goto=51200 },
			{ text="Why they have attacked", goto=51300 },
			{ text="Minex tactics", goto=51400 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[51100] = {
		action="jump", goto=51001,
		player="[AUTO_REPEAT]",
		playerFragment="about how you were able to convince the Elowan to help you against the Minex",
		alien={"Stress of extended war has produced highly accelerated natural selection and resulted in a reasonable Elowan.  The other races in this area are not as advanced in diplomacy as we Thrynn, and we have been able to take advantage of the Elowan survival drive with the new threats of the Minex to bring them to our defense." }
	}
	questions[51200] = {
		action="jump", goto=51001,
		player="[AUTO_REPEAT]",
		playerFragment="how the war goes against the Minex",
		alien={"We have very little news at present because we are still withstanding the initial onslaught of the Minex.  When their fleets start wearing thin we will retaliate before their shipyards are able to respond." }
	}
	questions[51300] = {
		action="jump", goto=51001,
		player="[AUTO_REPEAT]",
		playerFragment="about why they have attacked you",
		alien={"One irrational xenophobic race is much like another xenophobic aquatic race..." }
	}
	questions[51400] = {
		action="jump", goto=51001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the tactics the Minex use",
		alien={"The Minex blindly circle our territory with huge fleets and attack anything they run across.  Our coordinated counterattacks have wrecked vast devastation upon their numbers.  Beware, if we detect your ship attempting to salvage any vessel in our territory, we will respond with deadly force.  No tolerance is given to pirates." }
	}

	questions[60000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about an unnatural virus",
		alien={"Yes, we have seen the insidious sickness. It has begun to infect our people as well as all other races.  The technology behind the sickness shares similar characteristics to certain artifacts found in extremely old ruins in this area.  We are investigating to discover who is responsible for uncovering and spreading this virus." }
	}
	questions[60001] = {
		action="branch",
		choices = {
			{ text="Source of the virus", goto=61000 },
			{ text="Artifacts that resemble the virus technology", goto=62000 },
			{ text="Minex responsible?", goto=63000 },
			{ text="Elowan responsible?", goto=64000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=60001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="concerning any leads to the source of the virus",
		alien={"Not any definitive proof yet.  The guilty party would be a well-traveled race and would themselves not bear any sign of infection.  They also would have much to gain by destabilizing this region.  Perhaps a newcomer, hmm?" }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about the artifacts developed with the same technology as a virus",
		alien={"The now captive BX from their former headquarters at 58N X 96E were known to scavenge and adapt nightmarish technologies taken from an underground city millions of years old.  If this virus originated from anywhere it would be there. The exact system location was lost after the Bar-Zhon war, but was known to be in an M class system on the outward edge of this region of space." }
	}
	questions[63000] = {
		action="jump", goto=60001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="if you think the Minex could be responsible", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Possible but unlikely.  Those infected and driven mad by the virus appear to go out of their way to find and attack the Minex.  Not a particularly wise trait to pursue if they were the guilty party.  Besides, the true guilty party would attempt to remain neutral to all and let the sickness ravage and weaken without drawing suspicion to themselves." }
	}
	questions[64000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="if you think the Elowan could be responsible", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"No.  Elowan ships do not explore since they huddle together for mutual defense.  We have contained and prevented their spread for many years. In addition they do not possess the intelligence to commit this crime.  Besides even though they are simply plants, they also have been ravaged by the infection even as they deny it." }
	}
end


if (plot_stage == 1) or (plot_stage == 3) then
	questions[11001] = {
		action="branch",
		choices = {
			{ text="Your society",  goto=11000 },
			{ text="Oviparous?", goto=12000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about your society",
		alien={"We are a practical people with a complete and total trust in the concept called fate.  With the goal of increasing the length our own species' survival, we have embraced in our social structure the concepts of progression, growth, survival of the fittest, and have a disdain for mercy of any type." }
	}
	questions[12000] = {
		action="jump", goto=11001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="on the meaning of oviparous",
		alien={"Such matters are better left not discussed." }
	}


	questions[11101] = {
		action="branch",
		choices = {
			{ text="Merciless?",  goto=11110 },
			{ text="The poor & the outcasts",  goto=11120 },
			{ text="Government",  goto=11130 },
			{ text="Such inhumanity is hard to imagine.",  goto=11140 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[11110] = {
		action="jump", goto=11101,
		player="[AUTO_REPEAT]",
		playerFragment="if you think yourselves completely merciless", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"No, of course not.  A good example is the children. They are given a chance to grow and so is any process, individual, or philosophy which may at some time improve the strengths of society at some point in the future.  Unlike nature, we understand patience.  However like nature we have absolutely no tolerance for what is truly weak and ineffective." }
	}
	questions[11120] = {
		action="jump", goto=11101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="what you do with the poor, the outcasts, et cetera", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"The very concept of welfare is abhorrent.  It is not always easy to accept the fact that the weak must die. But this is the way of the universe is it not?  Strengthening the weak so they can survive only saps the strength of the strong and weakens all.  Would you work for an ungrateful, demanding mob for the rest of your life who think it is their right for you to work for them?" }
	}
	questions[11130] = {
		action="jump", goto=11101,
		player="[AUTO_REPEAT]",
		playerFragment="how your society is governed", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"Our government system has changed many times over the years.  Our system is currently organized in a military hierarchy with extreme upward mobility based on ability and nothing else.  Diplomatic skill, ability to form temporary alliances based on mutual goals is the key to success yet Mavericks are also given a free hand." }
	}
	questions[11140] = {
		action="jump", goto=11141, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"Wait, did you say human?  Your physical appearance matches our records of empire humanity." }
	}
	questions[11141] = {
		action="branch",
		choices = {
			{ text="Empire humanity?",  goto=11142 },
			{ text="News from Earth?",  goto=11143 },
			{ text="Our ancestors trace our history to Noah 3.",  goto=11144 },
			{ title="You are allies of humanity?", text="So you were close allies with humanity in the past?", goto=11145 },
			{ text="<Back>", goto=11101 }
		}
	}
	questions[11142] = {
		action="jump", goto=11141,
		player="[AUTO_REPEAT]",
		playerFragment="about ancient humanity",
		alien={"Humanity and the Thrynn once ruled a vast interstellar empire together and will do so again.  Aid us with your undistorted and effective empire technology and we will aid you in manpower and industrial might." }
	}
	questions[11143] = {
		action="jump", goto=11141,
		player="[AUTO_REPEAT]",
		playerFragment="what happened to the Empire after we left", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"Internal strife combined with the migration of xenophobic and technologically mighty species directly through Empire space ripped the cohesion of the Empire apart.  The human taskforces were utterly destroyed and it was believed that none of their population survived the wave of flaring stars.  Obviously we were mistaken." }
	}
end

if (plot_stage == 1) then -- initial plot state

	questions[11144] = {
		action="jump", goto=11141, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"We have heard of this.  It was widely believed that all Noah colony ships were destroyed by the collaboration of the Laytonites and the Elowan.  In the past we were allies, your race and mine, united in a common cause.  We must unite to rid the galaxy of those who would oppose us." }
	}

elseif (plot_stage == 3) then -- war plot state

	questions[11144] = {
		action="jump", goto=11141, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"We have heard of this.  It was widely believed that all Noah colony ships were destroyed by the the Laytonites.  In the past we were allies, your race and mine, united in a common cause.  We must collaborate to stop the Minex." }
	}

end

if (plot_stage == 1) or (plot_stage == 3) then


	questions[11145] = {
		action="jump", goto=11141, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"Indeed, even though that Empire was no more, its legacy shines the way to a bright future.  We shall build another empire and you shall be our allies and rule with us.  Commerce and mutual aid against a common cause - these are the important things to remember." }
	}
end

if (plot_stage == 1) then -- initial plot state

	questions[21001] = {
		action="branch",
		choices = {
			{ text="The Elowan",  goto=21000 },
			{ text="Other alien races",  goto=22000 },
			{ text="Why can't you just all get along?",  goto=23000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="[AUTO_REPEAT]",  ftest= 3, -- aggravating
		alien={"Leave us now you pacifist alien thrawling." }
	}
	questions[23001] = {
		action="jump", goto=999,  ftest= 3, -- aggravating, attack the player
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"(Roar!)" }
	}
elseif (plot_stage == 3) then -- war plot state


	questions[21001] = {
		action="branch",
		choices = {
			{ text="The Elowan",  goto=21000 },
			{ text="Other alien races",  goto=22000 },
			{ text="Assist in stopping the Minex",  goto=23000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[23000] = {
		action="jump", goto=21001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how we can help stop the Minex",
		alien={"Your people must aid us with the exchange of military technology.  If you do not possess adequate technology than we will consider a mutual defense pact if your people can provide us with raw materials such as radioactives.  Please convey our request to your leaders." }
	}

end

if (plot_stage == 1) or (plot_stage == 3) then


	questions[21000] = {
		action="jump", goto=21101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the Elowan",
		alien={"The Elowan are deceitful and untrustworthy carnivorous plant creatures, mutated into an aggressive race which seeks the destruction of their creators, the benevolent Thrynn." }
	}
	questions[22000] = {
		action="jump", goto=22101,
		player="[AUTO_REPEAT]",
		playerFragment="about other alien races",
		alien={"Beside the Elowan, we have knowledge of the Minex, the Bar-Zhon, the Spemin, and the Tafel.  Of whom do you direct your attention?" }
	}

	questions[21101] = {
		action="branch",
		choices = {
			{ title="Intelligent plants", 	text="The Elowan are intelligent plants?", goto=21100 },
			{ text="The Elowan are dangerous?",  goto=21200 },
			{ text="Elowan warships",  goto=21300 },
			{ text="Why fight them",  goto=21400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[21100] = {
		action="jump", goto=21101,
		player="[AUTO_REPEAT]",
		alien={"Yes.  The Elowan were created by a mad genius seeking to create both a rapidly multiplying planetary terraforming tool and create a sufficiently intelligent servant which could guard his holdings and be immune to treachery and deceit.  Only the first goal was obtained, and most regrettably a rebellion ended his life and threatened to wipe out life on our home world and on several of our colonies." }
	}
	questions[21200] = {
		action="jump", goto=21101,
		player="[AUTO_REPEAT]",
		alien={"Yes indeed.  Only a few seads can rapidly spread across an entire planetary surface crowding out and stifling all of the plant growth and covering it with carnivorous growth seeking to devour and destroy all animal life." }
	}
	questions[21300] = {
		action="jump", goto=21101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the Elowan warships",
		alien={"The Elowan are not necessarily intelligent but are more than clever.  Spreading through several sparsely inhabited Thrynn worlds they discovered on one ancient technological artifact that formed the basis of their incredibly powerful shielding.  Quickly they adapted several small scout vessels with this technology and began to build them en mass.  It is necessary to isolate their ships and attack them quickly with high-powered lasers at close range before their shields recharge." }
	}
	questions[21400] = {
		action="jump", goto=21101,
		player="[AUTO_REPEAT]",
		playerFragment="why you continue to fight them", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"The Elowan speak fairly but they are contagion, and would spread quickly and declare war if they had not been contained by the selfless Thrynn.  They seek to deceive others into becoming their allies out of the desperation of their present condition only.  If free they would be aggressively destroying all animal life." }
	}
	questions[22101] = {
		action="branch",
		choices = {
			{ text="The Minex",  goto=22100 },
			{ text="The Bar-Zhon",  goto=22200 },
			{ text="The Spemin",  goto=22300 },
			{ text="The Tafel",  goto=22400 },
			{ text="<Back>", goto=21001 }
		}
	}
end

if (plot_stage == 1) then -- initial plot state

	questions[22100] = {
		action="jump", goto=22101,
		player="[AUTO_REPEAT]",
		playerFragment="about the Minex",
		alien={"The Minex used to be more open in the past but have closed their borders due to Elowan treachery.  Unfortunately they have left the selfishly abandoned the burden upon us to control the spreading contagion." }
	}

elseif (plot_stage == 3) then -- war plot state

	questions[22100] = {
		action="jump", goto=22105,
		player="[AUTO_REPEAT]",
		playerFragment="about the Minex",
		alien={"The Minex used to be isolationist industrialists but have set their sights on conquering the galaxy.  Besides circling the center of the Tower constellation, they engage our fleets almost daily.  Their ships are almost as dangerous as the Gazurtoid and possess similar resistance to missile weaponry.  We have experienced a minor inconvenience at repulsing their waves of ships." }
	}
	questions[22105] = {
		action="jump", goto=22101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="who the Gazurtoid are", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The Gazurtoid are truly a dangerous enemy who passed through our original territory about a thousand years ago.  Unlike the Minex who possess partial missile resistance, the Gazurtoid exhibited complete immunity from projectile weaponry.  Fortunately they do not inhabit this region of space." }
	}

end

if (plot_stage == 1) or (plot_stage == 3) then


	questions[22200] = {
		action="jump", goto=22101,
		player="[AUTO_REPEAT]",
		playerFragment="about the Bar-Zhon",
		alien={"The Bar-Zhon are the degenerate descendents of a race of proud empire builders.  They have delusions of grandeur but can be safely ignored." }
	}
	questions[22300] = {
		action="jump", goto=22101,
		player="[AUTO_REPEAT]",
		playerFragment="about the Spemin",
		alien={"The Spemin are a race of barely sentient blob creatures, and their ships are easily defeated.  They are truly not worth the effort to destroy, but for some reason their ships are extremely numerous.  We are investigating why they have not run out of fuel a long time ago." }
	}
	questions[22400] = {
		action="jump", goto=22101,
		player="[AUTO_REPEAT]",
		playerFragment="about the Tafel",
		alien={"The Tafel are an insidious but weak nuisance in this area of space.  You should destroy them as we do." }
	}
end

end

function QuestDialogueinitial()


--[[
title="Military Mission #31:  The Thrynn / Elowan Conflict - Initial"
--]]
	questions[74000] = {
		action="jump", goto=997,
		player="The Thrynn / Elowan Conflict",
		introFragment= "Thrynn vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment= "...",
		alien={"Do not detain us.  We are currently attempting to repulse an unprovoked Elowan offensive." }
	}
--[[
title="Military Mission #31:  The Thrynn / Elowan Conflict - Shield Capacitor"
--]]
	questions[74100] = {
		action="jump", goto=1, ftest= 1,
--		artifact10 = 0
--		active_quest = active_quest + 1
--		ship_laser_class = ship_laser_class + 2
		player="Elowan Shield Capacitor",
		introFragment= "Thrynn vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have battled many Elowan and prevailed in the conflict.",
		playerFragment= "something in exchange for an Elowan Shield Capacitor",  fragmentTable= preQuestion.desire,
		alien={"Very well.  You have shown your willingness to assist us against irrational aggression [CAPTAIN]." }
	}
		questions[74105] = {
		action="jump", goto=1, ftest= 1,
		player="Transporting device now.",
		alien={"We are transmitting specifications for our advanced laser cannons.  Your people should be able to adapt the technology easily.  (Mission Completed)" }
	}
	questions[74106] = {
		action="jump", goto=1, ftest= 1,
		player="Transporting device now.",
		alien={"We assess that your vessel's energy weapon technology is equivalent to ours.  Most unfortunate.  We are transporting a number of energy crystals instead of what to you would be superfluous technology.  (Mission Completed)" }
	}
--[[
title="Military Mission #35:  Minex Electronics"
--]]

	questions[79000] = {
		action="jump", goto=79001,
		player="Minex electronics system",
		introFragment= "Thrynn vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment= "something in exchange for a Minex electronics system",  fragmentTable= preQuestion.desire,
		alien={"Yes [CAPTAIN].  We will pay well for Minex technology.  We will be willing to provide you complete access to all our technical information on energy weaponry and a working sample of our most advanced laser cannon for the device." }
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
--		ship_laser_class = 6,
		player="[AUTO_REPEAT]",
		alien={"Our engineers are being sent over your ship as we speak.  Installation of our advanced technology will be completed shortly. (Mission Completed)" }
	}
	questions[79200] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Very well." }
	}

--[[
title="Scientific Mission #31:  Whining Orb"
--]]
	questions[85000] = {
		action="jump", goto=85001,
		player="The Bar-zhon orb",
		introFragment= "Thrynn vessel.  This is Captain [CAPTAIN].  Did you transmit information about a Whining orb to us?",
		playerFragment="about it",
		alien={"Yes, our records do show an attempted contact with your race concerning this artifact." }
	}
	questions[85001] = {
		action="jump", goto=85002,
		player="Specifics?  Your transmitted message was not very clear.",
		alien={"We destroyed a pirate ship about a week ago encroaching in our territory.  In their ship log we recovered an entry reporting that they had stolen a valuable Whining Orb from the Bar-zhon and stashed it on 'Lazerarp' directly on the northernmost rotational pole of the planet.  We not know where Lazerarp is, so we relay this information to others who might find it useful. " }
	}
	questions[85002] = {
		action="jump", goto=1,
		player="Do you perhaps know who might know where Lazerarp is?",
		playerFragment="who might know where Lazerarp is", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"No, or else we would have asked them instead of you." }
	}
--[[
title="Freelance Mission #28:  Obtain Data Crystals - obtaining a reaper
--]]

	questions[92000] = {
		action="jump", goto=92001,
		player="Acquiring Nyssian Data Crystals.",
		introFragment= "Thrynn vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].  ",
		playerFragment="a reaper", fragmentTable= preQuestion.desire,
		alien={"We are actively engaged in a deadly struggle against monstrous creatures which hate all animal life and you want us to give away military technology to you?  Why should we give you such a device?" }
	}
	questions[92001] = {
		action="branch",
		choices = {
			{ title="Truth", text="The Nyssian want the technology.",  goto=92100 },
			{ title="Bribe", text="What about in exchange for 20 endurium?",  goto=92200 },
			{ title="Force", text="You will give us a copy of this device now! ",  goto=92300 },
			{ text="Forget this.  I'm not going to bother.", goto=92400 }
		}
	}
	questions[92100] = {
--		active_quest = active_quest + 1
		action="jump", goto=997,  ftest=1,
		player="[AUTO_REPEAT]",
		alien={"The Nyssian do nothing but spy for the other races.  I will politely suggest that you never inquire of any Thrynn concerning this subject again.  We will remember those who try to act as stooges for our enemies and will not tolerate any smaller action in the future.   (Mission Completed)" }
	}
	questions[92200] = {
		action="jump", goto=92201,
		player="[AUTO_REPEAT]",
		alien={"I may be persuaded not with energy crystals but with radioactives.  Do you possess at least 10 units of radium and/or uranium?" }
	}
	questions[92201] = {
		action="branch",
		choices = {
			{ text="Yes, transporting now.",  goto=92202 },
			{ text="No.",  goto=92203 },
		}
	}
	questions[92202] = {
--		Chuck the quantity of radium and uranium
--		if player has at least 10 units of radium and uranium
-- 		artifact19 = 1 -- reaper
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Commencing exchange. " }
	}
	questions[92203] = {
		action="jump", goto=92001,
		player="[AUTO_REPEAT]",
		alien={"Very well. " }
	}
	questions[92205] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		alien={"You are admonished not to distribute Thrynn war technology. This sample is for your own personal use only." }
	}
	questions[92206] = {
--		Chuck the quantity of radium and uranium - less than 10
		action="jump", goto=997, -- terminate
		player="[AUTO_REPEAT]",
		alien={"Do not attempt deception. Return when you have sufficient quantities." }
	}

	questions[92300] = {
		action="jump", goto= 999, -- attack
		player="[AUTO_REPEAT]",
		alien={"Roar!" }
	}
	questions[92400] = {
--		active_quest = active_quest + 1
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Very well. (Mission Completed)" }
	}

--[[
title="Freelance Mission #32:  The Thrynn / Elowan conflict -  Initial"
--]]
	questions[96000] = {
		action="jump", goto=997,
		introFragment= "Thrynn vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		player="I understand you want a shield capacitor?",
		alien={"You understand correctly.  Bring one to us and we will upgrade your laser weaponry if possible. I do not have the time to elaborate further as we are currently attempting to repulse an unprovoked Elowan offensive." }
	}

--[[
title="Freelance Mission #32:  The Thrynn / Elowan conflict -  Shield Capacitor"
--]]

	questions[96100] = {
		action="jump", goto=96101, ftest= 1,
--		artifact10 = 0
--		active_quest = active_quest + 1
--		ship_laser_class = ship_laser_class + 1 or 2
		player="Elowan Shield Capacitor",
		introFragment= "Thrynn vessel.  This is Captain [CAPTAIN].",
		playerFragment= "something in exchange for an Elowan Shield Capacitor",  fragmentTable= preQuestion.desire,
		alien={"Very well.  You have shown your willingness to assist us against irrational aggression.  We are transmitting specifications for our advanced laser cannons.  Your people should be able to adapt the technology easily. " }
	}
	questions[96105] = {
		action="jump", goto=96101, ftest= 1,
		player="Transporting device now.",
		alien={"We are transmitting specifications for our advanced laser cannons.  Your people should be able to adapt the technology easily.  (Mission Completed)" }
	}

	questions[96106] = {
		action="jump", goto=96101, ftest= 1,
		player="Transporting device now.",
		alien={"We assess that your vessel's energy weapon technology is equivalent to ours.  Most unfortunate.  We are transporting a number of energy crystals instead of what to you would be superfluous technology.  (Mission Completed)" }
	}

	questions[96101] = {
		action="jump", goto=1, ftest= 1,
--	    endurium = endurium + 2
		player="Why do you need one?",
	    playerFragment="why you not been able to obtain one yourselves",
		alien={"We do not truly need the unit.  Your actions have increased the Elowan's distrust of Myrrdan.  This is not a negative thing.   The Thrynn Confederacy is willing to enter into a profitable alliance with your people now that you have demonstrated your fortitude." }
	}
--[[
title="Freelance Mission #34:  Artistic Containers"
--]]
	questions[98000] = {
		action="jump", goto=98001,
		introFragment= "Thrynn vessel.  This is Captain [CAPTAIN].",
		player="Artistic containers",
		playerFragment= "something in exchange for these incredibly ancient artistic containers",  fragmentTable= preQuestion.desire,
		alien={"Hmm.  I confirm the age of the artifacts and their unusual structure.  The artistic design does not match up anything in our databases of known alien races.  I am willing to offer an amount of 16 cubic earth units of energy crystals.  Do you concur?" }
	}
	questions[98001] = {
		action="branch",
		choices = {
			{ text="Yes, I agree to 16 endurium.",  goto=98100 },
			{ text="No.",  goto=98200 },
		}
	}
	questions[98100] = {
--		artifact18 = 0
--		endurium = endurium + 12
--		active_quest = active_quest + 1
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Commencing exchange.  (Mission Completed)" }
	}
	questions[98200] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Very well. " }
	}

--[[
title="Freelance Mission #35:  Resolving the Bar-zhon Elowan conflict -  after probe"
--]]

	questions[99000] = {
		action="jump", goto=99001,
		player="Tell us about the Elowan Bar-zhon conflict",
		introFragment= "Thrynn vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="about the Elowan Bar-zhon conflict",
		alien={"The Elowan are untrustworthy, deceitful, and that is all.  The Bar-zhon staked first claim to Aircthech III and the Elowan aggressively invaded and now are attempting to justify their aggression with fraudulent claims.  We have notified the Bar-zhon of our full tactical support if they decide on military action to resolve the conflict." }
	}
	questions[99001] = {
		action="jump", goto=1,
		player="Do you know how the conflict started?",
		playerFragment="about how the conflict started",
		alien={"No, we have only recently focused our interest on the situation." }
	}

--[[
title="Freelance Mission #35:  Resolving the Bar-zhon Elowan conflict -  after probe"
--]]

	questions[99500] = {
		action="jump", goto=1,
		introFragment= "Thrynn vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		player="Thrynn Drone?",
		playerFragment="about this drone that one of your ships launched",
		alien={"Our databanks contained no reference to any drone of that type and it is far too primitive to be of Thrynn manufacture.  A guess would be that it is of Bar-zhon or pirate manufacture." }
	}

end

function QuestDialoguevirus()

--[[
title="Mission #37:  Catching the Smugglers.",
--]]
	questions[77000] = {
		action="jump", goto=999, -- Attack the player
		title="Catching the Smugglers",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are on official Myrrdan business to track down two dangerous criminal starships of our own race.",
		playerFragment="any information that could help us find them",
		alien={"Growl !!" }
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
		alien={"Growl !!" }
	}


--[[
title="Mission #43:  Desperate Measures
--]]

	questions[83000] = {
		action="jump", goto=999, -- attack the player
		title="Desperate Measures",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  It is extremely important that we talk to you about this fabricated Bar-Zhon / Myrrdan incident.",
		playerFragment="any information that could help us", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Flee you pirates!  Your time is coming soon!" }
	}


--[[
title="Mission #44:  Decontamination transporter
--]]

	questions[84000] = {
		action="jump", goto=997, -- terminate
		title="Decontamination Transporter",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="about this decontamination transporter you guys requested our help with",
		alien={"You should not be seen with us. Please contact the Bar-zhon concerning our joint venture." }
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
		alien={"You have performed for us a useful service. Perhaps the condemnation our leaders have placed upon you may no longer be appropriate" }
	}
	questions[84301] = {
		action="jump", goto=997,  ftest= 1, --  provide artifact264, a data cube
		player="Please talk to your leaders",
		alien={"We will do this. For now I will provide a working sample transporter in exchange for the Elowan data. The reconstruction filters should immediately be operational if their modeling data is complete and accurate." }
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
		alien={"You have performed for us a useful service. Perhaps the condemnation our leaders have placed upon you may no longer be appropriate." }
	}
	questions[84601] = {
		action="jump", goto=997, -- Terminate communications
		player="Please talk to your leaders",
		alien={"Perhaps I spoke too hastily.  This software in operation is not useful.  Basic lifeforms are completely scrambled by this useless Elowan code.  We will provide you with one more opportunity to confront the Elowan concerning their failure.  Do not disappoint us." }
	}

--[[
title="Mission #45:  Alien Healthcare Scam - no sample
--]]

	questions[85000] = {
		action="jump", goto=997, -- Terminate
		title="Plague Treatment",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are investigating reports of a medical treatment that minimizes or stops the periods of madness caused by the plague.",
		playerFragment="about it",
		alien={"Rumors and mystical concoctions that not even the Nyssian worms are interested in are quite beneath our attention.  Scram!" }
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
		alien={"Chemical analysis shows that this is nothing but a soup of mind altering poisons.  Mixing it in with biological strains of the virus show that the virus is not affected.  Since this plague does not affect non-sentents, we are unable and unwilling to test it.  My crew declines the opportunity to rot out their minds." }
	}



end

function QuestDialoguewar()


--[[
title="Mission #48:  Intelligence Collaboration
--]]

	questions[78000] = {
		action="jump", goto=78001,
		title="Intelligence Collaboration",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have compiled a datacube of technological, tactical, and strategic observations of the Minex war machine.  In the interests of all of our survival, we are willing to share this information freely.",
		playerFragment="a collection of similar observations by your people", fragmentTable=preQuestion.desire,
		alien={"Your data is appreciated. The Minex utilize large maneuverable vessels and aggressively attack isolated targets, strongly avoiding casualties and fleet action. Either they must be destroyed or we all will be destroyed.  In exchange for your data, I am authorized to give you one sample of any of the following: a Minex targeting system, power core, beam mount, missile turret, or a silver gadget." }
	}
	questions[78001] = {
		action="branch",
		choices = {
			{ title="Targeting System", text="Sounds good, please transport over the Minex targeting system.", goto=78100 },
			{ title="Power Core", text="Sounds good, please transport over the Minex power core.", goto=78200 },
			{ title="Beam Mount", text="Sounds good, please transport over the Minex beam mount.", goto=78300 },
			{ title="Missile Turret", text="Sounds good, please transport over the Minex missile turret.", goto=78400 },
			{ title="Silver Gadget", text="Sounds good, please transport over the Minex silver gadget.", goto=78500 },
		}
	}
	questions[78100] = {
		action="jump", goto=997,  ftest= 1,-- terminate
		player="[AUTO_REPEAT]",
		alien={"Transporting now.  Good voyage to you.  We must now depart." }
	}
	questions[78200] = {
		action="jump", goto=997,  ftest= 1,-- terminate
		player="[AUTO_REPEAT]",
		alien={"Transporting now.  Good voyage to you.  We must now depart." }
	}
	questions[78300] = {
		action="jump", goto=997,  ftest= 1,-- terminate
		player="[AUTO_REPEAT]",
		alien={"Transporting now.  Good voyage to you.  We must now depart." }
	}
	questions[78400] = {
		action="jump", goto=997,  ftest= 1,-- terminate
		player="[AUTO_REPEAT]",
		alien={"Transporting now.  Good voyage to you.  We must now depart." }
	}
	questions[78500] = {
		action="jump", goto=997,  ftest= 1,-- terminate
		player="[AUTO_REPEAT]",
		alien={"Transporting now.  Good voyage to you.  We must now depart." }
	}

--[[
title="Mission #49:  Unrest - no flight recorders
--]]

	questions[79000] = {
		action="jump", goto=1, ftest= 1, -- artifact281 Thrynn Flight Recording
		title="Unrest",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have heard that Coalition have been raiding the Elowan and yourselves.",
		playerFragment="about the situation",
		alien={"The Coalition is not a force to be concerned about. A few of their ships attacked one of our patrols within Spemin territory and were dispatched without difficulty. If you wish to confront them, I will transmit the flight recorder data to you immediately." }
	}

--[[
title="Mission #49:  Unrest - at least one flight recorder
--]]

	questions[79500] = {
		action="jump", goto=1, ftest= 1, -- artifact281 Thrynn Flight Recording
		title="Unrest",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have heard that Coalition have been raiding the Elowan and yourselves.",
		playerFragment="about the situation",
		alien={"Do not be overly concerned over the Coalition's useless antagonism.  As long as they are foolish enough to blindly attack large military patrols as you already may see in the Elowan flight recorder data you possess, our concern is minimal.  Here is our recording of the same event." }
	}


--[[
title="Mission #51: Wreck salvaging initial
--]]

	questions[81000] = {
		action="jump", goto=81001,
		title="Wreck salvaging",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="about this wreck salvaging task",
		alien={"Welcome Myrrdan. You have proven your steel. We seek strong and confident allies for the difficult days ahead. Are you up to the challenge?" }
	}
	questions[81001] = {
		action="branch",
		choices = {
			{ title="Yes", text="Yes, we are ready.", goto=81010 },
			{ title="No", text="No, not right now.", goto=81020 },
			{ title="Challenge?", text="What challenge do you mean?", goto=81030 },
		}
	}
	questions[81010] = {
		action="jump", goto=81050,
		player="[AUTO_REPEAT]",
		alien={"The Thissaliss Corporation has been contracted for salvage and research in the aftermath of Alliance battles with the Minex." }
	}
	questions[81020] = {
		action="jump", goto=997, ftest= 1, -- terminate
		player="[AUTO_REPEAT]",
		alien={"Get lost weakling! (Mission Completed)" }
	}
	questions[81030] = {
		action="jump", goto=81001,
		player="[AUTO_REPEAT]",
		alien={"Do not play foolish human. You were briefed before being dispatched." }
	}


	questions[81050] = {
		action="jump", goto=81051,
		player="Okay.  And?",
		alien={"Our number of atmosphere capable vessels has been sharply reduced by recent unfortunate loses during hostilities. Myrrdan was recently allowed into our market and your government's bid for your services was ... competitive." }
	}
	questions[81051] = {
		action="branch",
		choices = {
			{ title="Bid?", text="What was our bid?", goto=81060 },
			{ title="Task", text="What task do you have for us?", goto=81070 },
			{ title="Terminate", text="Something urgent has come up, we'll be back later", goto=81080 },
		}
	}
	questions[81060] = {
		action="jump", goto=81061,
		player="[AUTO_REPEAT]",
		alien={"That is restricted, need to know only." }
	}
	questions[81061] = {
		action="jump", goto=81051,
		player="I need to know",
		alien={"No you do not. Your superiors dictate what you are told. We will not supply you the claws for premature advancement." }
	}

	questions[81070] = {
		action="jump", goto=81071,
		player="[AUTO_REPEAT]",
		alien={"Investigation of post re-entry debris from a number of smaller skirmishes. Tracer scouts have already investigated locations and verified surface debris from orbital scans." }
	}
	questions[81071] = {
		action="jump", goto=81072,
		player="Okay.  Send us the list of sites.",
		alien={"Per your contract locations will be revealed one at a time. You will be required to bring holos and any artifacts to any Thrynn ship before the next site will be disclosed." }
	}
	questions[81072] = {
		action="jump", goto=997, -- terminate
		player="Ok, where do we go first?",
		alien={"The first location is Glaistig (22N X 104W) in the Net system (55, 114)" }
	}


	questions[81080] = {
		action="jump", goto=997, -- terminate
		player="[AUTO_REPEAT]",
		alien={"Our patience is limited." }
	}


--[[
title="Mission #51: Wreck salvaging - returning melted composite debris
--]]

	questions[81100] = {
		action="jump", goto=997, ftest= 1, -- remove artifacts 296-300 Melted Composite
		title="Wreck Salvaging 2",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  These melted composites are the only significant items we found. Transporting over samples plus a holo survey of the site.",
		playerFragment="about them",
		alien={"Disappointing but not unexpected.  The composites are simply sections of nonconductive fragments of Minex armor superheated and sheared off by laser.  Must have shadowed larger debris during reentry. The next site is Magmor 1. (31S X 88E) (18,117)" }
	}

--[[
title="Mission #51: Wreck salvaging - returning artifact308 Geometric Crystals
--]]

	questions[81200] = {
		action="jump", goto=997, ftest= 1, -- remove artifact308 Geometric Crystals
		title="Wreck Salvaging 3",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  These geometric crystals are the only significant items we found. Transporting over samples plus a holo survey of the site.",
		playerFragment="about them",
		alien={"More useless inert material. The next site is Inghean (118S X 72E) in the Anu system. (65, 110)" }
	}

--[[
title="Mission #51: Wreck salvaging - returning artifact312 and 313
--]]

	questions[81300] = {
		action="jump", goto=997, ftest= 1, -- remove artifact312-313 engine components and gravity field generator
		title="Wreck Salvaging 4",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We located these two artifacts, Engine components and a gravity field generator.  Transporting over samples plus a holo survey of the site.",
		playerFragment="about them",
		alien={"This intact Minex inertia compensator is quite a find. Far more efficient than our designs. The next location is Kygwyn (85S X 139E) also in the Anu system. (65, 110)" }
	}

--[[
title="Mission #51: Wreck salvaging - returning artifact324 organic growth
--]]

	questions[81400] = {
		action="jump", goto=997, ftest= 1, -- remove artifact324 organic growth
		title="Wreck Salvaging 5",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  The only interesting item we found at this site was this unusual organic growth",
		playerFragment="about it",
		alien={"This fungal growth has no significance. The next site is Conn (33N X 145W) in the Lairgnen system. (70, 142)" }
	}


--[[
title="Mission #51: Wreck salvaging - returning artifact327 Cone device
--]]

	questions[81500] = {
		action="jump", goto=81501, ftest= 1, -- remove artifact327 Cone device
		title="Wreck Salvaging 6",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  The only interesting item we found at this site was Conical device. Appears to have been attached to a laser turret.",
		playerFragment="about it",
		alien={"Very fortunate find. We have recovered a number of intact turrets before but these amplifiers are usually overloaded during the destruction of a Minex vessel." }
	}
	questions[81501] = {
		action="jump", goto=997, -- terminate
		title="How valuable is it?",
		player="[AUTO_REPEAT]",
		playerFragment="how valuable this artifact is",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Since the Minex use gas lasers with massive power requirements these amplifiers are probably not much use to Myrrdan. The next site is Jurlagh III. (18N X 12W) (16, 70)" }
	}

--[[
title="Mission #51: Wreck salvaging - returning artifacts329-334 Radioactive Exotic Elements
--]]

	questions[81600] = {
		action="jump", goto=997, ftest= 1, -- remove artifacts329-334 Radioactive Exotic Elements, provide 50 endurium, end the mission
		title="Wreck Salvaging 7",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  The only interesting items we found at this site are these exotic radioactive elements.",
		playerFragment="about it",
		alien={"You seem to have picked up the stock of supplies for a Minex reactor. Interesting but not terribly useful. That was the last location. You have discharged your contract adequately. You quality for the agreed upon bonus. (Quest Completed)" }
	}

--[[
title="Mission #51: Wreck salvaging - returning artifacts329-334 Radioactive Exotic Elements
--]]

	questions[81600] = {
		action="jump", goto=997, ftest= 1, -- remove artifacts329-334 Radioactive Exotic Elements, provide 50 endurium, end the mission
		title="Wreck Salvaging 7",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  The only interesting items we found at this site are these exotic radioactive elements.",
		playerFragment="about it",
		alien={"You seem to have picked up the stock of supplies for a Minex reactor. Interesting but not terribly useful. That was the last location. You have discharged your contract adequately. You quality for the agreed upon bonus. (Quest Completed)" }
	}

--[[
title="Mission #52: Prototype Testing
--]]

	questions[82000] = {
		action="jump", goto=82001,
		title="Prototype Testing",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="about these prototype weapons",
		alien={"Welcome [SHIPNAME].  I have prototype high speed repeater missiles and lasers turrets for you to test in combat. If you wish to keep them afterwards you may do so. If not, return to us to remount your original weapons or to offload your camera footage when you are done with your testing." }
	}

	questions[82001] = {
		action="branch",
		choices = {
			{ title="Install experimental lasers", text="I am ready for you to install the prototype laser turrets.", goto=82100 },
			{ title="Remove experimental lasers", text="Please return my original laser turrets.", goto=82200 },
			{ title="Install experimental missiles", text="I am ready for you to install the prototype missile launchers.", goto=82300 },
			{ title="Remove experimental missiles", text="Please return my original missile launchers.", goto=82400 },
			{ title="End Mission", text="I am done with my testing, sending over camera footage now.", goto=82500 },
		}
	}
	questions[82100] = {
		action="jump", goto=82001,  ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Sending engineers over to your ship now." }
	}
	questions[82200] = {
		action="jump", goto=82001,  ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Sending engineers over to your ship now." }
	}
	questions[82300] = {
		action="jump", goto=82001,  ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Sending engineers over to your ship now." }
	}
	questions[82400] = {
		action="jump", goto=82001,  ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Sending engineers over to your ship now." }
	}
	questions[82500] = {
		action="jump", goto=997,  ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Receiving camera footage now.  Good work.  We must now depart.  (Quest Completed)" }
	}

--[[
title="Mission #53:  Tactical Coordination
--]]


	questions[83000] = {
		action="jump", goto=1,  ftest= 1, -- artifact337 Thrynn response
		title="Tactical Coordination",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are working with the Bar-zhon to discover fleet combinations that would be most effective in countering the Minex onslaught.",
		playerFragment="if you would commit a few ships to tactical exercises being conducted for this purpose", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Strength and survival requires diversity and adaptation under pressure. This is a difficult lesson but a critical one.  We must first consult with our leaders but I foresee no difficulty in sending representatives to the Bar-zhon rendezvous." }
	}


--[[
title="Mission #57:  The Shimmering Ball
--]]

	questions[87000] = {
		action="jump", goto=87002,
		title="The Shimmering Ball",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  The Spemin mentioned that you were interested in this Shimmering Ball artifact?",
		playerFragment="the device", fragmentTable=preQuestion.desire,
		alien={"Do not attempt to deceive us.  If this cloaking device was operational you would never part with it." }
	}
	questions[87002] = {
		action="jump", goto=87001,
		player="All right, I admit it's broken",
		alien={"Know that for millennia we have searched for this prototype. In mass production it could have saved the human empire.  All we knew is that it was stolen by the Gazurtoid who could not reverse engineer it.  Just in case this fraud is a broken version of the genuine article, I offer you 50 Quorsitanium in exchange for it." }
	}
	questions[87001] = {
		action="branch",
		choices = {
			{ title="Yes", text="I accept your offer.  Transporting now.",  goto=87100 },
			{ text="No thanks",  goto=87200 },
		}
	}
	questions[87100] = {
		action="jump", goto=1, ftest= 1, -- artifact363 = 0. 50 Quorsitanium, end mission
		player="[AUTO_REPEAT]",
		alien={"Commencing exchange." }
	}
	questions[87200] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Very well. " }
	}

end

function QuestDialogueancients()


end

function OtherDialogue()

--[[
title="Universal Missions"
--]]

	questions[400] = {
		action="jump", goto=401,
		player="Can you tell me about...",
		playerFragment="...",
		alien={"Our scanners indicate that you are carrying some plutonium.  We will pay well for this. Let us say 3 cubic earth units of energy crystals per cubic meter of plutonium.  Agreed?" }
	}
	questions[401] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=410 },
			{ text="No.",  goto=420 },
		}
	}
	questions[410] = {
--		endurium = endurium + plutonium * 3
--		plutonium = 0
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Commencing exchange. " }
	}
	questions[420] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Very well. " }
	}


	questions[500] = {
		action="jump", goto=501,
		player="Can you tell me about...",
		playerFragment="...",
		alien={"Our scanners indicate that you have aboard your ship an Elowan Shield Capacitor.  This device is of interest to us.  We will buy such a device from you for 5 cubic earth units of energy crystals.  Agreed?" }
	}
	questions[501] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=510 },
			{ text="No.",  goto=520 },
		}
	}
	questions[510] = {
--		endurium = endurium + artifact10 * 4
--		artifact10 = 0
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Commencing exchange. " }
	}
	questions[520] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Very well. " }
	}

	questions[600] = {
		action="jump", goto=601,
		player="Can you tell me about...",
		playerFragment="...",
		alien={"Our scanners indicate that you have aboard your ship a Spiral Lens.  This device is of interest to us.  We will buy it from you for 3 cubic earth units of energy crystals.  Agreed?" }
	}
	questions[601] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=610 },
			{ text="No.",  goto=620 },
		}
	}
	questions[610] = {
--		endurium = endurium + 7
--		artifact13 = 0
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Commencing exchange. " }
	}
	questions[620] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Very well. " }
	}

	questions[700] = {
		action="jump", goto=701,
		player="Can you tell me about...",
		playerFragment="...",
		alien={"Our scanners indicate that you have aboard your ship a Bar-Zhon Data Cube.  This device is of interest to us.  We will buy all such a device from you for 5 cubic earth units of energy crystals.  Agreed?" }
	}
	questions[701] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=710 },
			{ text="No.",  goto=720 },
		}
	}
	questions[710] = {
--		endurium = endurium + artifact15 * 3
--		artifact15 = 0
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Commencing exchange. " }
	}
	questions[720] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Very well. " }
	}

	questions[800] = {
		action="jump", goto=801,
		player="Can you tell me about...",
		playerFragment="...",
		alien={"Our scanners indicate that you have aboard your ship a Coalition Afterburner.  This device is of interest to us.  We will buy such a device from you for 4 cubic earth units of energy crystals.  Agreed?" }
	}
	questions[801] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=810 },
			{ text="No.",  goto=820 },
		}
	}
	questions[810] = {
--		endurium = endurium + artifact20 * 4
--		artifact20 = 0
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Commencing exchange. " }
	}
	questions[820] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Very well. " }
	}
	-- attack the player because attitude is too low
	questions[910] = {
		action="jump", goto=999,
		player="What can you tell us about...",
		alien={"Few enemies have lived to regret their provocations of the Thrynn.  We will give no further warnings.  Flee and do not provoke us further." }
	}
	-- hostile termination question
	questions[920] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"We now gives additional warning as required by galactic interspecies protocol.  You must depart." }
	}
	-- neutral termination question
	questions[930] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"Our races are much alike.  We must depart at this time, but look forward towards future negotiations." }
	}
	-- friendly termination question
	questions[940] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"Farewell friends.  We are united in a common cause.  We must go and rid the galaxy of those who would oppose us." }
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

    health = 100                    -- 100=baseline minimum
    mass = 5                        -- 1=tiny, 10=huge

if (plot_stage == 1) then -- initial plot state

	engineclass= gen_random(4)
	if (engineclass < 2) then						engineclass= 2						end

	shieldclass = 3
	armorclass = 1
	laserclass = 3
	missileclass = 0
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100%
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%

elseif (plot_stage == 2) then -- virus plot state

	engineclass= gen_random(4)
	if (engineclass < 2) then						engineclass= 2						end

	shieldclass = 3
	armorclass = 1
	laserclass = 3
	missileclass = 0
	laser_modifier = 20				-- % of damage received, used for racial abilities, 0-100%
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%


elseif (plot_stage == 3) then -- war plot state

	engineclass= gen_random(5)
	if (engineclass < 2) then						engineclass= 2						end

	shieldclass = 3
	armorclass = 2
	laserclass = 5
	missileclass = 0
	laser_modifier = 0				-- % of damage received, used for racial abilities, 0-100%
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%


elseif (plot_stage == 4) then -- ancients plot state

	engineclass= gen_random(5)
	if (engineclass < 2) then						engineclass= 2						end

	shieldclass = 3
	armorclass = 3
	laserclass = 6
	missileclass = 0
	laser_modifier = 0				-- % of damage received, used for racial abilities, 0-100%
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%


end


	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in

if (plot_stage == 1) then -- initial plot state

	DROPITEM1 = 14;	    DROPRATE1 = 80;		DROPQTY1 = 1 -- Thrynn Battle Machine
	DROPITEM2 = 16;		DROPRATE2 = 90;	    DROPQTY2 = 1 -- Whining Orb
	DROPITEM5 = 54;		DROPRATE5 = 50;		DROPQTY5 = 2 -- Endurium
	DROPITEM3 = 34;		DROPRATE3 = 20;		DROPQTY3 = 4
	DROPITEM4 = 35;		DROPRATE4 = 0;		DROPQTY4 = 2

elseif (plot_stage == 2) then -- virus plot state

	DROPITEM1 = 234;	DROPRATE1 = 80;		DROPQTY1 = 1 -- Thrynn genetic material
	DROPITEM2 = 14;		DROPRATE2 = 90;	    DROPQTY2 = 1 -- Thrynn Battle Machine
	DROPITEM5 = 54;		DROPRATE5 = 50;		DROPQTY5 = 2 -- Endurium
	DROPITEM3 = 34;		DROPRATE3 = 20;		DROPQTY3 = 4
	DROPITEM4 = 35;		DROPRATE4 = 0;		DROPQTY4 = 2

elseif (plot_stage == 3) then -- war plot state

	DROPITEM1 = 14;	    DROPRATE1 = 80;		DROPQTY1 = 1 -- Thrynn Battle Machine
	DROPITEM2 = 16;		DROPRATE2 = 90;	    DROPQTY2 = 1 -- Whining Orb
	DROPITEM5 = 54;		DROPRATE5 = 50;		DROPQTY5 = 2 -- Endurium
	DROPITEM3 = 34;		DROPRATE3 = 20;		DROPQTY3 = 4
	DROPITEM4 = 35;		DROPRATE4 = 0;		DROPQTY4 = 2

elseif (plot_stage == 4) then -- ancients plot state

	DROPITEM1 = 14;	    DROPRATE1 = 80;		DROPQTY1 = 1 -- Thrynn Battle Machine
	DROPITEM2 = 16;		DROPRATE2 = 90;	    DROPQTY2 = 1 -- Whining Orb
	DROPITEM5 = 54;		DROPRATE5 = 50;		DROPQTY5 = 2 -- Endurium
	DROPITEM3 = 34;		DROPRATE3 = 20;		DROPQTY3 = 4
	DROPITEM4 = 35;		DROPRATE4 = 00;		DROPQTY4 = 2

end

	SetPlayerTables()

	FTEST= -1	--FTEST is used to activate the commFxn, for decision making during conversations.

	--active_quest = 35 	--  debugging use
	--artifact18 = 1		--  debugging use

if (plot_stage == 1) then -- initial plot state

	--initialize dialog
	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low
	elseif player_profession == "military" and active_quest == 31 and artifact10 == 0 then
		first_question = 74000
	elseif player_profession == "military" and active_quest == 31 and artifact10 > 0 then
		first_question = 74100
	elseif player_profession == "military" and active_quest == 35 and artifact22 > 0 then
		first_question = 79000
	elseif player_profession == "scientific" and active_quest == 31 and artifact16 == 0 then
		first_question = 85000
	elseif player_profession == "freelance" and active_quest == 28 and artifact219 == 0 then
		first_question = 92000
	elseif player_profession == "freelance" and active_quest == 32 and artifact10 == 0 then
		first_question = 96000
	elseif player_profession == "freelance" and active_quest == 32 and artifact10 > 0 then
		first_question = 96100
	elseif player_profession == "freelance" and active_quest == 34 and artifact18 == 1 then
		first_question = 98000
	elseif player_profession == "freelance" and active_quest == 35 and artifact27 == 0 and artifact28 == 0 then
		first_question = 99000
	elseif player_profession == "freelance" and active_quest == 35 and artifact27 == 1 and artifact28 == 0 then
		first_question = 99500
	elseif artifact10 > 0 then
		first_question = 500
	elseif artifact13 > 0 then
		first_question = 600
	elseif artifact15 > 0 then
		first_question = 700
	elseif artifact20 > 0 then
		first_question = 800
	else
		first_question = 1
	end

elseif (plot_stage == 2) then -- virus plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low
	elseif active_quest == 37 then
		first_question = 77000

-- Mission #37: catching the smugglers
	elseif active_quest == 37 then
		first_question = 77000

-- Mission #38: Medical samples
	elseif active_quest == 38 then
		first_question = 78000

-- Mission #43:  Framed!
	elseif active_quest == 43 then
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



	else
		first_question = 1
	end

elseif (plot_stage == 3) then -- war plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low


-- Mission #48:  Intelligence Gathering
	elseif active_quest == 48 and artifact275 == 0 and artifact276 == 0 and artifact277 == 0 and artifact278 == 0 and artifact279 == 0 then -- no power core or any other provided artifact besides the silver gadget
		first_question = 78000


-- Mission #49:  Unrest
	elseif active_quest == 49 and artifact280 == 0 and artifact281 == 0 then -- no flight recorders
		first_question = 79000
	elseif active_quest == 49 and (artifact280 == 1 or artifact281 == 1) then -- at least one flight recorder
		first_question = 79500

-- Mission #51: Wreck Salvaging
	elseif active_quest == 51 and (artifact329 == 1 or artifact330 == 1 or artifact331 == 1 or artifact332 == 1 or artifact333 == 1 or artifact334 == 1) then
		first_question = 81600
	elseif active_quest == 51 and artifact327 == 1 then
		first_question = 81500
	elseif active_quest == 51 and artifact324 == 1 then
		first_question = 81400
	elseif active_quest == 51 and artifact312 == 1 and artifact313 == 1 then
		first_question = 81300
	elseif active_quest == 51 and artifact308 == 1 then
		first_question = 81200
	elseif active_quest == 51 and (artifact296 == 1 or artifact297 == 1 or artifact298 == 1 or artifact299 == 1 or artifact300 == 1) then
		first_question = 81100
	elseif active_quest == 51 then
		first_question = 81000

-- Mission #52: Wreck Salvaging
	elseif active_quest == 52 then
		first_question = 82000

-- Mission #53:  Tactical coordination
	elseif active_quest == 53 and artifact335 == 1 then
		first_question = 83000

-- Mission #57:  The Shimmering Ball
	elseif active_quest == 57 and artifact363 == 1 then
		first_question = 87000



	else
		first_question = 1
	end

elseif (plot_stage == 4) then -- ancients plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low
	else
		first_question = 1
	end

end

	starting_attitude = 100
	starting_posture = "obsequious"
	current_question = first_question
	next_question = first_question

	-- Attitude this value and higher unlocks all questions, alien lowers their shields, maximum number of questions may be asked
	friendlyattitude = 80
	-- Attitude this value and higher is a neutral attitude, alien disarmed weapons but has raised shields
	neutralattitude = 35


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
			{ text="GENERAL INFO", goto = 50000 }
		}
	}


	StandardQuestions() -- load questions

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
	if (type == 0) then							--greeting
		if (POSTURE == "friendly") then
			ATTITUDE = ATTITUDE + 6
		elseif (POSTURE == "obsequious") then
			ATTITUDE = ATTITUDE + 0
		elseif (POSTURE == "hostile") then
			ATTITUDE = ATTITUDE - 10
		end

	elseif (type == 1) then							--statement
		if (POSTURE == "friendly") then
			ATTITUDE = ATTITUDE + 2
		elseif (POSTURE == "obsequious") then
			ATTITUDE = ATTITUDE + 0
		elseif (POSTURE == "hostile") then
			ATTITUDE = ATTITUDE - 6
		end


	elseif (ftest == 4) then   --  Terminating question
		L_Terminate()
		return
	elseif (ftest == 5) then   --  Attack the player question
		L_Attack()
		return

	elseif (ATTITUDE < neutralattitude and number_of_actions > 4) then
		goto_question = 920 -- jump to hostile termination question
		number_of_actions = 0

	elseif (ATTITUDE < friendlyattitude and number_of_actions > 10) then
		goto_question = 930  -- jump to neutral termination question
		number_of_actions = 0

	elseif (number_of_actions > 20) then
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
				ATTITUDE = ATTITUDE - 5
			end

		elseif (ftest == 2) then  --  Insightful question
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE + 3
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 5
			end
		elseif (ftest == 3) then   --  Aggravating question
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE - 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE - 1
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 8
			end
		end

		if (n == 410) then
				player_Endurium = player_Endurium + player_Plutonium * 3
				player_Plutonium = 0
				ATTITUDE = ATTITUDE + 15
		elseif (n == 510) then
				player_Endurium = player_Endurium + 5
				artifact10 = 0
				ATTITUDE = ATTITUDE + 15
		elseif (n == 610) then
				player_Endurium = player_Endurium + 3
				artifact13 = 0
				ATTITUDE = ATTITUDE + 10
		elseif (n == 710) then
				player_Endurium = player_Endurium + 5
				artifact15 = 0
				ATTITUDE = ATTITUDE + 10
		elseif (n == 810) then
				player_Endurium = player_Endurium + 4
				artifact20 = 0
				ATTITUDE = ATTITUDE + 10
		elseif (plot_stage == 1) then -- initial plot state

			if (n == 74100) then
				if (ship_laser_class < max_laser_class) then
					goto_question = 74105 -- provide player with laser upgrade
				else
					goto_question = 74106 -- player already has best possible laser class, provide energy crystals instead
				end
				ATTITUDE = ATTITUDE + 10
			elseif (n == 74105) then
				artifact10 = 0
				active_quest = active_quest + 1
				ship_laser_class = ship_laser_class + 1
				ATTITUDE = ATTITUDE + 10
			elseif (n == 74106) then
				artifact10 = 0
				active_quest = active_quest + 1
				player_Endurium = player_Endurium + 5
				ATTITUDE = ATTITUDE + 20

			elseif (n == 79100) then
				artifact22 = 0
				active_quest = active_quest + 1
				ship_laser_class = max_laser_class
				ATTITUDE = ATTITUDE + 20

			elseif (n == 92100) then
				ATTITUDE = ATTITUDE - 10
				active_quest = active_quest + 1

			-- Freelance Quest 28 - exchange 10 radioactives for a reaper

			elseif (n == 92202) then
				if (player_Radium + player_Uranium >= 10) then
					player_Radium = 0
					player_Uranium = 0
					artifact219 = 1
					goto_question = 92205 -- give the player a reaper for  radioactives
					ATTITUDE = ATTITUDE + 5
				else
					goto_question = 92206 -- complain about lack of radioactives
					ATTITUDE = ATTITUDE - 5
				end

			elseif (n == 96100) then
				if (ship_laser_class < max_laser_class) then
					goto_question = 96105 -- provide player with laser upgrade
				else
					goto_question = 96106 -- player already has best possible laser class, provide energy crystals instead
				end
				ATTITUDE = ATTITUDE + 5
			elseif (n == 96105) then
				artifact10 = 0
				active_quest = active_quest + 1
				ATTITUDE = ATTITUDE + 20
				if (ship_laser_class == max_laser_class - 1) then  -- increment lasers only one class if only one class below maximum
					ship_laser_class = ship_laser_class + 1
				else
					ship_laser_class = ship_laser_class + 2
				end
			elseif (n == 96106) then
				artifact10 = 0
				active_quest = active_quest + 1
				player_Endurium = player_Endurium + 12
			elseif (n == 96101) then
				player_Endurium = player_Endurium +  2
			elseif (n == 98100) then
				artifact18 = 0
				player_Endurium = player_Endurium + 16
				active_quest = active_quest + 1
				ATTITUDE = ATTITUDE + 15
			end

		elseif (plot_stage == 2) then -- virus plot state

		-- title="Mission #44: Decontamination Transporter
			if (n == 84150) then
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
			if (n == 78100) then
				artifact277 = 1 -- Minex targeting system (broken)
			elseif (n == 78200) then
				artifact275 = 1 -- Minex Power Core
			elseif (n == 78300) then
				artifact278 = 1 -- Beam Mount (broken)
			elseif (n == 78400) then
				artifact279 = 1 -- Minex Missile Turret (broken)
			elseif (n == 78500) then
				artifact23 = 1 -- Minex Silver gadget

-- title="Mission #49: Unrest
			elseif (n == 79000) then
				artifact281 = 1 -- Thrynn Flight Recording
			elseif (n == 79500) then
				artifact281 = 1 -- Thrynn Flight Recording

-- title="Mission #51: Wreck salvaging
			elseif (n == 81020) then
				active_quest = active_quest + 1
			elseif (n == 81100) then
				artifact296 = 0 -- Melted Composite
				artifact297 = 0 -- Melted Composite
				artifact298 = 0 -- Melted Composite
				artifact299 = 0 -- Melted Composite
				artifact300 = 0 -- Melted Composite
			elseif (n == 81200) then
				artifact308 = 0 -- Geometric Crystals
			elseif (n == 81300) then
				artifact312 = 0 -- engine components
				artifact313 = 0 -- gravity field generator
			elseif (n == 81400) then
				artifact324 = 0 -- organic growth
			elseif (n == 81500) then
				artifact327 = 0 -- Cone device
			elseif (n == 81600) then
				artifact329 = 0 -- Radioactive Exotic Elements
				artifact330 = 0 -- Radioactive Exotic Elements
				artifact331 = 0 -- Radioactive Exotic Elements
				artifact332 = 0 -- Radioactive Exotic Elements
				artifact333 = 0 -- Radioactive Exotic Elements
				artifact334 = 0 -- Radioactive Exotic Elements
				player_Endurium = player_Endurium + 50

				if player_profession == "scientific" then
					active_quest = active_quest + 7
				elseif player_profession == "freelance" then
					active_quest = active_quest + 3
				else -- military
					active_quest = active_quest + 1
				end

-- title="Mission #52: Prototypes

			elseif (n == 82100) then
				if player_profession == "scientific" then
					ship_laser_class = 7
				elseif player_profession == "freelance" then
					ship_laser_class = 8
				elseif player_profession == "military" then
					ship_laser_class = 9
				end

			elseif (n == 82200) then
				ship_laser_class = max_laser_class

			elseif (n == 82300) then

				if player_profession == "scientific" then
					ship_missile_class = 7
				elseif player_profession == "freelance" then
					ship_missile_class = 8
				elseif player_profession == "military" then
					ship_missile_class = 9
				end

			elseif (n == 82400) then
				ship_missile_class = max_missile_class

			elseif (n == 82500) then
				active_quest = active_quest + 1

-- title="Mission #53: Tactical coordination
			elseif (n == 83000) then
				artifact337 = 1 -- Thrynn response

-- title="Mission #57: The Shimmering Ball
			elseif (n == 87100) then
				artifact363 = 0
				player_Quorsitanium = player_Quorsitanium + 50
				active_quest = active_quest + 1







			end
		elseif (plot_stage == 4) then -- ancients plot state



		end

	end
end

