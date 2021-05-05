--[[------------------------------------------------------------------------------------------------------------------------------------------------- ]
	ENCOUNTER SCRIPT FILE: NYSSIAN

	Last Modified:  May 28, 2014

	Globals shared with C++ module:
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
		"Reverence appropriately placed acquires shocking momentum.  Perfection would negate all need, but the universe is imperfect.",
		"Abundance of concern negates the shock of comprehension",
		"Appropriate understanding of your role is commendable.",
		"No harm shall befall you oh supplicant.",
		"I am Nyssian.  Your submission to truth will be rewarded.",
		"Indeed your concern is appropriate.  Be welcome here.",
		"'Fayai, 'Tyana via legan.  Wisdom and recognition is a rare combination"
	}

elseif (plot_stage == 2) then -- virus plot state

	obsequiousGreetTable= {
		"Reverence appropriately placed acquires shocking momentum.  Perfection would negate all need, but the universe is collapsing.",
		"Abundance of concern at the most appropriate time.",
		"Appropriate understanding of your role and everyone's need is commendable.",
		"I am Nyssian.  Your submission to truth will be repaid during this dark hour.",
		"No harm shall befall you oh supplicant.",
		"I am Nyssian.  Your submission to truth will be rewarded.",
		"Indeed your concern is appropriate.  Be welcome here.",
		"'Fayai, 'Tyana via legan.  Wisdom and recognition is a rare combination"
	}



elseif (plot_stage == 3) then -- war plot state


	obsequiousGreetTable= {
		"Reverence appropriately placed acquires shocking momentum.  Perfection would negate all need, but the universe is collapsing.",
		"Abundance of concern at the most appropriate time.",
"Appropriate understanding of your role and everyone's need is commendable.",
		"I am Nyssian.  Your submission to truth will be repaid during this dark hour.",
		"I am Nyssian.  Your submission to truth will be rewarded.",
		"Indeed your concern is appropriate.  Be welcome here."
	}

elseif (plot_stage == 4) then -- ancients plot state


	obsequiousGreetTable= {
		"Reverence appropriately placed may help displace this distressing momentum.  Perfection would negate all need, but the universe is collapsing.",
		"Appropriate understanding of everyone's need is commendable, do not underestimate your exploits Captain [CAPTAIN].",
		"Welcome [CAPTAIN], I recognized the [SHIPNAME]  I, a Nyssian ambassador, am more than willing to help your glorious quest",
		"Welcome.   I would not dare harm the famous [SHIPNAME]",
		"'Fayai Commander [CAPTAIN]",
		"I would not dare harm the famous [SHIPNAME]",
		"'Tyana via legan [CAPTAIN].",
		"Acknowledgments of your accomplishments are also recognized Commander [CAPTAIN]"
	}

end


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

if (plot_stage == 1) then -- initial plot state

	friendlyGreetTable= {
		"Krryai the ancient way unveils the universe's only constant.  Uncertain yet predicted this encounter has been.  Respond now.",
		"Spiraling forces yet intersect.  Perfection would negate all need, but the universe is imperfect and your need remains.  How may I assist?",
		"Communication is a weary duty, yet all have their role to play.  Shall I share our wisdom so that you might find yours?"
	}

elseif (plot_stage == 2) or (plot_stage == 3) then -- virus plot state

	friendlyGreetTable= {
		"Krryai the ancient way unveils the universe's only constant.  Uncertain yet predicted this encounter has been.  Respond now.",
		"Spiraling forces yet intersect.  Perfection would negate all need, but the universe is imperfect and extensive need remains.  Time draws short.",
		"Communication is a weary duty, yet all have their role to play.   May our wisdom yet save another from destruction?"
	}

elseif (plot_stage == 4) then -- ancients plot state

	friendlyGreetTable= {
		"Krryai the ancient way unveils the universe's only hope.  How may I assist you this day Commander [CAPTAIN]?",
		"Spiraling forces yet intersect.  Perfection would negate all need, but the universe is imperfect and extensive need remains.  Time draws short.",
		"May the wisdom of the Nyssian always be available to guide the famous [SHIPNAME].",


	}
end
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack




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
		player="Dude, that is one funky ship you have there!",
		alien= friendlyGreetTable }
	greetings[5] = {
		action="",
		player="How's it going, weird, umm ... something?",
		alien= friendlyGreetTable }

if (plot_stage == 1) or (plot_stage == 2)  then

	greetings[6] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"Yes it is.  I return your hail."} }
	greetings[7] = {
		action="",
		player="Your ship appears very elaborate.  Do all those protrusions have some purpose?",
		alien= friendlyGreetTable }
	greetings[8] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"Trust is illusionary. Only the Nyssian possess the truth."} }
	greetings[9] = {
		action="",
		player="Greetings.  There is no limit to what both our races can gain from mutual exchange.  Please respond.",
		alien={"The Nyssian do not recognize limitations as they are all illusionary, but your contemplation of this truth is commendable."} }

elseif (plot_stage == 3) or (plot_stage == 4) then -- ancients plot state

	greetings[6] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"Organic technology has many advantages."} }
	greetings[7] = {
		action="",
		player="Your ship appears very elaborate.  Do all those protrusions have some purpose?",
		alien={"Organic ships are crafted and extremely flexible.  Individual sections do not always have perfectly defined and categorized functions."} }
	greetings[8] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"The reputation of the [SHIPNAME] precedes you, [CAPTAIN]."} }
	greetings[9] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"Sentiments are reflected fully Commander [SHIPNAME]."} }
	greetings[10] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"Unity is a commendable goal."} }

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
		"Krryai of the ancients spiral outwards",
		"Nei-vaivai",
		"Nyssian",
		"Threats are unnecessary",
		"Strength is not physical",
		"Physical is transient, and so are we.",
		"Nei-vaivai.  Some contests are not worth entering."
	}

elseif (plot_stage == 2) or (plot_stage == 3) then -- virus and war plot states

	hostileGreetTable= {
		"Krryai of the ancients spiral cascades of destruction",
		"Nei-vaivai",
		"Insanity cannot bargain",
		"I will return when madness abates",
		"Krryai!  The reason starts it's inevitable decline",
		"Violence drifts extinction showers",
		"Nei-vaivai.  Madness comes, sanity flees"
	}

elseif (plot_stage == 4) then -- ancients plot state

	hostileGreetTable= {
		"Krryai-thyun of the Ancients!  Hear our cry!",
		"Krryai!  The universe reaches its end!",
		"Violence the cheese extinction showers.",
		"Nei-vaivai.  Madness needs, sanity flees, thought secedes."
	}


end



	greetings[1] = {
		action="jump", ftest= 4, -- terminate
		player="This is captain [CAPTAIN] of the starship [SHIPNAME]. Identify yourselves immediately or be destroyed.",
		alien= hostileGreetTable }
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
		action="jump", ftest= 4, -- terminate
		player="We require information. Comply or be destroyed.",
		alien= hostileGreetTable }
	greetings[6] = {
		action="jump", ftest= 4, -- terminate
		player="Flying garbage scow with all that weak embellishment.  Identify yourself.",
		alien= hostileGreetTable }

end

function StandardQuestions()

	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart


if (plot_stage == 1) then -- initial plot state

	questions[50000] = {
		action="branch",
		choices = {
			{ text="What type of freak are you?",  goto=51000 },
			{ text="Home world location", goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}

elseif (plot_stage == 2) or (plot_stage == 3) or (plot_stage == 4) then -- other plot states

	questions[50000] = {
		action="branch",
		choices = {
			{ text="Current news", goto=60000 },
			{ text="What type of freak are you?",  goto=51000 },
			{ text="Home world location", goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}

end
	questions[51000] = {
		action="jump", goto=51001, ftest= 6, -- very aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about what type of freak you are",
		alien={"Wisdom drifts on endless winds, pausing, and is gone."}
	}
	questions[51001] = {
		action="jump", goto=997, -- terminate
		player="What does that mean?",
		alien={"<Silence>"}
	}


if (plot_stage == 1) then -- initial plot state

	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"Impertinent question, yet allowances must be made.  I am an ambassador piloting this grand Nyssian explorer vessel.   The mysteries of the universe may be disclosed, or a curse of ignorance placed upon you at my whim.  Choose your next inquiry carefully."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Many aspects of the all can be seen in the other fragments of all.  I learn from others in the same way that I learn from you and your race: by every action you take, your every gesture and motion, your questions, your desires and hidden motives.  Observers of ours monitor most worlds and we share this information with you freely."}
	}
	questions[30000] = {
		action="jump", goto=31001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"Many things do we know, seeker of the wastes, and many things I will reveal for the asking.  Are you interested in the Great War, the Golden Ages, the Ancients, Ourselves, or perhaps more about the history of your own people of the Empire?"}
	}


elseif (plot_stage == 2) then -- virus plot state

	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"Impertinent question, yet allowances must be made during this deadly era.  I am an ambassador piloting this grand Nyssian explorer vessel.  I do have some general information about the infection plaguing the sector, but I am willing to repeat information about ourselves."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Many aspects of the all can be seen in the other fragments of all.  I learn from others in the same way that I learn from you and your race: by every action you take, your every gesture and motion, your questions, your desires and hidden motives.  If you wish current news on this infection instead please address this as a general inquiry."}
	}
	questions[30000] = {
		action="jump", goto=31001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"Many things do we know about the events prior to this current infection, and many things I will reveal for the asking.  Are you interested in the Great War, the Golden Ages, the Ancients, Ourselves, or perhaps more about the history of your own people of the Empire?"}
	}


elseif (plot_stage == 3) then -- war plot state

	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"Impertinent question, yet allowances must be made during this deadly era.  I am an ambassador piloting this grand Nyssian explorer vessel.  I do have some general information about the Minex War, but I am willing to repeat information about ourselves."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Many aspects of the all can be seen in the other fragments of all.  I learn from others in the same way that I learn from you and your race: by every action you take, your every gesture and motion, your questions, your desires and hidden motives.  If you wish current news about the warfare instead, please address this as a general inquiry."}
	}
	questions[30000] = {
		action="jump", goto=31001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"Many things do we know, brave warrior and seeker.  Are you interested in the previous Great War, the Golden Ages, the Ancients, Ourselves, or perhaps more about the history of your own people of the Empire?"}
	}

elseif (plot_stage == 4) then -- ancients plot state


	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"I am a formally represented ambassador of this grand Nyssian explorer vessel.  My databanks are at your disposal, and I do have some new general information about this new dark age and the repercussions of the war, but I am willing to repeat general information about ourselves."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Many aspects of the all can be seen in the other fragments of all.  I learn from others in the same way that I learn from you and your race: by every action you take, your every gesture and motion, your questions, your desires and hidden motives.  If you wish current news in this post-war period instead, please address this as a general inquiry."}
	}
	questions[30000] = {
		action="jump", goto=31001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"Many things do we know, mighty diplomatic and ender of wars.  Are you interested in the Great War, the Golden Ages, the Ancients, Ourselves, or perhaps more about the history of your own people of the Empire?"}
	}

end

	questions[52000] = {
		action="jump", goto=50000, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="the location of your home world", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Our colony worlds are legion.  Those who lack the material wealth to achieve this material utopia as seen in this vessel continue to strive materialistically on them to this day.  I do not bother with them, neither should you."}
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="The Tafel",  goto=21000 },
			{ text="The Minex",  goto=22000 },
			{ text="The Bar-zhon",  goto=23000 },
			{ text="<More>",  goto=21002 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21002] = {
		action="branch",
		choices = {
			{ text="The Spemin",  goto=24000 },
			{ text="The Thrynn and Elowan",  goto=25000 },
			{ text="The Thrynn and Elowan conflict",  goto=26000 },
			{ text="<Back>", goto=1 }
		}
	}
if (plot_stage == 1) then

	questions[21000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Tafel",
		alien={"The Tafel balance on the knife's edge of good and evil.  Much twisted by greed and control are they, yet they still maintain the openness of children and accept teaching.  As difficult as they are to reach, I still try to instruct them. Through their cybernetics the Tafel achieve a degree of information sharing and insightful deduction unmatched by anyone, yet their embrace of the machine mind hath left them blind spots to numerous to count."}
	}

elseif (plot_stage == 2) or (plot_stage == 3) or (plot_stage == 4) then

	questions[21000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Tafel",
		alien={"The Tafel balanced on the knife's edge of good and evil.  Their embrace of the machine mind hath left them blind spots that were exploited.  They have lost the racial battle for sanity and sunk into a permanent state of unreasonable aggression. I mourn for them."}
	}

end

if (plot_stage == 1) or (plot_stage == 2) then

	questions[22000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Minex",
		alien={"The Minex are a race almost as ancient as our own.  Great strain have they endured in the conflaguration of species, the great war of ancient times.  I worry about our brothers as they have fallen into fear and have decided not to interact with others.  The day will arrive when the Minex conquer their fear and on this day the eighth Golden age will arrive and the entire sector will unite in peace and prosperity."}
	}

elseif  (plot_stage == 3)  then

	questions[22000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Minex",
		alien={"The Minex are an ancient race driven mad by Vissah, the black wind of death.  Great strain have they endured in the conflaguration of species, the great war of ancient times.  They turned inward and build a tremendous military machine.  Now Vissah twists their paranoia in a foolhardy attempt to militarily defeat everyone simultaneously which will sooner or later exhaust the number of ships they have built"}
	}

end

if (plot_stage == 4) then

	questions[22000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Minex",
		alien={"The Minex are an ancient race which were mad by Vissah. Now that you have reached them, they may be this sector's only hope in containing the growing number of infected ones.  Time is short."}
	}

end



	questions[23000] = {
		action="jump", goto=23001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Bar-zhon",
		alien={"The Bar-zhon are a courageous and warlike race undergoing a minimal civil war of their own.  Great strength and cunning are seen from them and they treat other races with honor and respect.  Their opposition does not share their morals however."}
	}
	questions[23001] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		alien={"A good number of the Barzhon population simply rebelled 40 years ago and have survived to this day in hiding.  Many privateers of other races have joined them and a menace they are to those who they perceive as new or weak.  This opposition is known as The Coalition and their once high-minded principles have degraded into open piracy to obtain the technologies and resources they need to continue.  The Nyssian have trained them to think otherwise, yet you may also have to do the same."}
	}
	questions[24000] = {
		action="jump", goto=21002,
		player="[AUTO_REPEAT]",
		playerFragment="about the Spemin",
		alien={"The Spemin are an overly friendly childlike race who wishes the acceptance of all.  Their misfortune of isolation between Minex and Thrynn space has not dampened their zeal for exploration.  Their immaturity is obvious, yet surprising knowledge have they uncovered at times."}
	}
	questions[25000] = {
		action="jump", goto=25001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Thrynn and Elowan",
		alien={"The Thrynn are disdainful of others, until you prove to them your militaristic strength.  Their race and the Elowan appeared only a millennia ago yet during their entire space faring history both have been locked in an eternal conflict with each other." }
	}
	questions[25001] = {
		action="jump", goto=21002,
		player="[AUTO_REPEAT]",
		alien={"Neither the Thrynn and Elowan has much concern for anything other than the conflict between themselves anymore.   Neither has either side been capable of making progress against the other." }
	}
	questions[26000] = {
		action="jump", goto=26001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Thrynn and Elowan conflict",
		alien={"The Thrynn militaristic code values technology and industry, while the Elowan value secrecy and defense.  The majority of skirmishes begin with the Thrynn launching barely adequate offensive forces effectively too small to accomplish anything against the isolationist Elowan.  The pace of these attacks has been frantic and endless." }
	}
	questions[26001] = {
		action="jump", goto=21002,
		player="[AUTO_REPEAT]",
		alien={"The feud between the Thrynn and Elowan has spanned an almost infinite number of skirmishes plus several major battles.  At several times both races have driven each other to the brink of extinction yet somehow both continue to survive.  The powerful defenses and tightly concentrated fleets of the Elowan eventually win through concentration of firepower in their battles." }
	}

	questions[11001] = {
		action="branch",
		choices = {
			{ text="Nyssian history",  goto=11000 },
			{ text="Nyssian biology", goto=12000 },
			{ text="Your agenda", goto=13000 },
			{ text="Your technology", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		playerFragment="about Nyssian history",
		alien={"As the universe exists, so have the Nyssian existed, drifting along infinite paths towards the continual, twisting, changing future." }
	}
	questions[12000] = {
		action="jump", goto=11001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about Nyssian biology",
		alien={"Nothing other than what your own eyes reveal.  More inspiring inquiries lie elsewhere." }
	}
	questions[13000] = {
		action="jump", goto=13101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about your agenda",
		alien={"I drift through the stars for the winds pull me, acquiring knowledge and wisdom as I go.  Our oracle directs the paths to the infinite the achievable impossibility.  Those of us who remain in this mortal realm are those who are still seeking.  I only trade in wisdom.  For material concerns, seek out others." }
	}
	questions[14000] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		playerFragment="about your technology",
		alien={"Our technology for dealing with the physical world was perfected as far as we wish it to be back in the ancient past in the third golden age.  Once material desires are met, it is foolishness to continue to pursue that beyond what what you as an individual need and want." }
	}

	questions[13101] = {
		action="branch",
		choices = {
			{ title="You are a mystic?", text="So you consider yourself some type of mystic?", goto=13110 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[13110] = {
		action="jump", goto=13112, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"Yes." }
	}
	questions[13112] = {
		action="branch",
		choices = {
			{ title="Mystics are self-deluded.", text="Mystics are self-deluded individuals who do not accept the objective reality of physical laws in a physical universe.", goto=13113 },
			{ title="Reality is harsh.", text="Reality is harsh.  Mystics die when others make demands on them.", goto=13114 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[13113] = {
		action="jump", goto=997, ftest= 6, -- very aggregating
		player="[AUTO_REPEAT]",
		alien={"Acceptance of physical laws is a requirement, however acceptance of those close minded to possibility is not.  Return when your opaqueness of vision has changed." }
	}

	questions[13114] = {
		action="jump", goto=13115, ftest= 6, -- very aggravating
		player="[AUTO_REPEAT]",
		alien={"<Silence>" }
	}
	questions[13115] = {
		action="jump", ftest= 5, -- attack
		player="[AUTO_REPEAT]",
		alien={"<Silence>" }
	}
	questions[31001] = {
		action="branch",
		choices = {
			{ text="The Great War",  goto=31100 },
			{ text="The Golden Ages",  goto=31200 },
			{ text="<More>",  goto=31002 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31002] = {
		action="branch",
		choices = {
			{ text="The Ancients",  goto=40000 },
			{ text="Yourselves",  goto=31400 },
			{ text="The Empire",  goto=31500 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[31100] = {
		action="jump", goto=31101,
		player="[AUTO_REPEAT]",
		playerFragment="about the Great War",
		alien={"The great war began many thousands of cycles ago, ending the seventh golden age. Ill winds of psychic energy poured in from coreward and drove madness into all the races.  We of course were immune but were unable to stop the downfall of many civilizations." }
	}
	questions[31200] = {
		action="jump", goto=31001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Golden Ages",
		alien={"The study of these periods is extensive and long does not have relevance to activities today other than the demonstratable rise and fall of high civilization among the stars followed by a grand collapse time and time again. Another collapse draws nigh, or maybe a golden age?" }
	}
	questions[40000] = {
		action="jump", goto=31301,  ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"The ancient ones permeated this area billions upon billions of years ago before all of the races.  They obtained mental, physical and technological perfection in all forms until they simply existed, needing nothing, occupying the simple uniform ruins we find across the galaxy to this day." }
	}
	questions[31400] = {
		action="jump", goto=31401, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"I am as all spacefaring Nyssian are, watchers of the grand dance.  How could there not be an audience for the greatest of all tragedies?" }
	}
	questions[31500] = {
		action="jump", goto=31501,
		player="[AUTO_REPEAT]",
		playerFragment="about the Empire",
		alien={"I am actually surprised to encounter one of your race, but we have knowledge of your people and your history.  You empirians formed an alliance of spacefaring races that survived little over a millennium." }
	}

	questions[31101] = {
		action="branch",
		choices = {
			{ text="Downfall of the civilizations?",  goto=31110 },
			{ text="Start of the war", goto=31120 },
			{ text="What civilizations collapsed?", goto=31130 },
			{ title="Why is this relevant?", text="What does any of that have to do with today?",goto=31140 },
			{ text="<Back>", goto=31001 }
		}
	}
	questions[31110] = {
		action="jump", goto=31101,
		player="[AUTO_REPEAT]",
		playerFragment="about the downfall of the civilizations",
		alien={"Before this time great trading convoys filled the stars between the six great races.  These races were ourselves, the Minex, the Barzhon, the Sabion, the Bx, and the Transmodra." }
	}
	questions[31120] = {
		action="jump", goto=31101,
		player="[AUTO_REPEAT]",
		playerFragment="how the war started", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"Peaceful neighbors suddenly attacked each other for no reason, and the fighting escalated to levels which threaten to blot out stars.  When the great shift occurred, and reason and understanding flowed back into the minds of sentients, three races were gone." }
	}
	questions[31130] = {
		action="jump", goto=31101,
		player="[AUTO_REPEAT]",
		playerFragment="what civilizations collapsed",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"These three races were the Sabion, the Bx, and the Transmodra were discovered to have been brought past the point of extinction, never to be heard from again.  Only we exist untouched by the consequences of this insanity." }
	}
	questions[31140] = {
		action="jump", goto=31101, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Learn from history, don't just listen.  The Barzhon still to this day fear open war and despite their warlike outlook, have yet to find the nerve to squash the open rebellion under their chins.  The Minex retreated inwards to themselves and have yet to look outward again." }
	}
	questions[31301] = {
		action="branch",
		choices = {
			{ text="Origins of the ancients",  goto=31310 },
			{ text="Where did they go?",  goto=31320 },
			{ text="<More>",  goto=31302 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31302] = {
		action="branch",
		choices = {
			{ text="Perfection",  goto=31330 },
			{ text="Endurium",  goto=31340 },
			{ text="Personality of the ancients",  goto=31350 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31310] = {
		action="jump", goto=31301,
		player="[AUTO_REPEAT]",
		playerFragment="where the ancients came from", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"From a galaxy far far away, a long long time ago.  Already the ancients were near their peak before they entered our galaxy.  The absolute uniformity of their ruins demonstrates this." }
	}
	questions[31320] = {
		action="jump", goto=31301, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="where the ancients went", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"They obtained perfection and jumped into a higher dimension, or else they became pure energy, or else they transcended time and space.  All answers are equally valid as finite beings cannot comprehend infinity." }
	}
	questions[31330] = {
		action="jump", goto=31302, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how the ancients achieved perfection",
		alien={"No mortal being has this knowledge but the Nyssian have many insights.  Primarily they developed incredible prophetic powers even to the point of being able to follow our existence in their distant future.  Proof of this is their decision to seed the galaxy with endurium." }
	}
	questions[31340] = {
		action="jump", goto=31302,
		player="[AUTO_REPEAT]",
		playerFragment="why they left endurium behind", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"To jumpstart our own development by making it possible to develop interstellar spaceflight by lesser beings such as ourselves.  It is the goal of each of us to develop our own prophetic abilities and to one day obtain a similar state of perfection." }
	}
	questions[31350] = {
		action="jump", goto=31302,
		player="[AUTO_REPEAT]",
		playerFragment="about what the ancients were like",
		alien={"No race has the answer to this question, as even in the chronicles of the ancient Leghk vague to the point of mirroring the observations of races today.  We know they were once threatened by a demonic entity or race, and that they developed incredible mental powers to survive." }
	}

	questions[31401] = {
		action="branch",
		choices = {
			{ text="Nyssian people",  goto=31410 },
			{ text="Crew on board",  goto=31420 },
			{ text="Trade",  goto=31430 },
			{ text="Type of government",  goto=31440 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31410] = {
		action="jump", goto=31401, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about the Nyssian people, not just you",
		alien={"Dirt grubbing money pinchers, the lot of us.  In early times our race attempted to build huge commercial interstellar enterprises, great concordances of sentients.  Each time war tore down what was built.  Finally some of us learned and traveled solely to develop the mind." }
	}
	questions[31420] = {
		action="jump", goto=31401,
		player="[AUTO_REPEAT]",
		playerFragment="the number of crew members aboard your ship", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"Unlike your primitive vessel, one.  The progression of all societies is to concentrate more and more power in fewer and fewer individuals until each individual is all-powerful.  The only next step which our people pursue in all humility is godhood." }
	}
	questions[31430] = {
		action="jump", goto=31401,
		player="[AUTO_REPEAT]",
		playerFragment="what your people trade",
		alien={"Information in the form of knowledge or wisdom.  We are trading now.  Do not bother asking of crass physical possessions.  You do not have what I want and nothing of mine would be understandable by you.  I will grant you as a boon one valuable insight into this sector.  Many will refer to the ancient Hyperspace constellations: The Bow = 60,110, The Pearl Cluster = 20,210, The Wee Dipper = 115,180, The Mace = 200, 105, and the Ruby Tower = 10,90." }
	}
	questions[31440] = {
		action="jump", goto=31401,
		player="[AUTO_REPEAT]",
		playerFragment="about what kind of government your people have",
		alien={"Right before my personal ascension to space, my people followed a type of technological feudalism.  Since then who knows and who cares?  Dwellers of the heavens do not concern themselves with dirt-bound slaves." }
	}
	questions[31501] = {
		action="branch",
		choices = {
			{ title="Survived?  Past tense?", text="Survived?  Past tense?  Do you know that all other humans are extinct?", goto=31510 },
			{ title="Human alliance",  text="You mentioned that my race formed an alliance?", goto=31520 },
			{ text="Where was this empire?",  goto=31530 },
			{ text="<More>",  goto=31502 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31502] = {
		action="branch",
		choices = {
			{ text="Empire humanity",  goto=31540 },
			{ text="The future",  goto=31550 },
			{ text="Do you have any advice?",  goto=31560 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31510] = {
		action="jump", goto=31501,
		player="[AUTO_REPEAT]",
		alien={"Certainty?  No.  But I know that your race developed in a distant sector that was scouted by one of our ships 200 years ago and neither did he find any living humans nor had any indigenous alien race seen any of your race in the prior 900 years." }
	}
	questions[31520] = {
		action="jump", goto=31501,
		player="[AUTO_REPEAT]",
		alien={"Yes, a group of Thrynn, Elowan, some insectoid race and a slave race of synthetic mechanicals cooperated in a limited fashion over that period of time.  A moralistic crusade of anti-slavers destroyed your corrupt people, aided by a holy vanguard.  This is all we know." }
	}
	questions[31530] = {
		action="jump", goto=31501,
		player="[AUTO_REPEAT]",
		playerFragment="where this entire existed", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"The ruins of your home world live in a dead region of space, too far a distance for one of your ships to travel without at least 12 times as much fuel as your maximum cargo capacity.  Fate transported your race here.  Your people must be satisfied with the here." }
	}
	questions[31540] = {
		action="jump", goto=31502,
		player="[AUTO_REPEAT]",
		playerFragment="about what Empire humans are like",
		alien={"Your provincial nature never attracted our attention in the past.  Our secondhand reports indicate that your people have remained static and refused to learn to travel great distances to learn and grow.  Lest you misunderstand, travel in the mind, not physical distance." }
	}
	questions[31550] = {
		action="jump", goto=31502, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="what the future holds", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"Only your future and none other may be revealed to one.  A great future awaits you.  Audacious and precipitous action will be needed by you soon.  The great races gradually settle and peace and prosperity will resume based upon your actions." }
	}
	questions[31560] = {
		action="jump", goto=31502, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"An individual sentient is a moat, a flick of dust in this great universe.  Only by accepting your insignificance and inability to affect anything will you and your people begin to learn from others." }
	}

if (plot_stage == 2) then -- virus plot state


	questions[60000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about current events",
		alien={"A dark age is now upon us all.  A hell-borne infection has appeared everywhere and threatens the existence of all life. Benefit from my wisdom quickly as I plan to depart this area." }
	}

	questions[60001] = {
		action="branch",
		choices = {
			{ text="Infection", goto=61000 },
			{ text="Dark Age", goto=62000 },
			{ text="Curing this infection", goto=63000 },
			{ text="Specifics", goto=64000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="[AUTO_REPEAT]",
		playerFragment="about this infection",
		alien={"It is death, simultaneously destroying all without reservation.  The Tafel woke this blight shortly after they landed on a monstrous world, the second planet of a yellow star in the head of the Mace." }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="what brought about this dark age", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"A mystic darkness now contaminates this region of space.  This is all that can be said.  No causes, no solutions, only hope that it will pass." }
	}
	questions[63000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="how this infection could be stopped", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The virus which infects us all mutates drastically and is nearly immune to any types of radiation.  It is supernatural and could not have been created by any science nor evolved from any other form." }
	}
	questions[64000] = {
		action="jump", goto=60001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="any other specific details about the infection", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Those who being spared death enter madness.  During these mad phases those near the Minex border go out of their way to attack the Minex.  We do not know the reason for this." }
	}
	questions[61001] = {
		action="branch",
		choices = {
			{ text="Rapid transmission of the virus", goto=61100 },
			{ text="The virus causes death?", goto=61200 },
			{ text="Progress towards a cure", goto=61300 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[61100] = {
		action="jump", goto=61001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="how the virus could have spread so widely so quickly.  What type of incubation period would have allowed it to spread everywhere before anyone noticed?", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Incubation period?   Nothing can contain Vissah, the black wind of death that follows prosperity.  Sometimes she is war and other times she is madness.  This time she is pure death." }
	}
	questions[61200] = {
		action="jump", goto=61001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="how the infection spreads if it causes death to all. Wouldn't everyone now be dead?", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The touch of Vissah does not kill all.  Some live but endure periods of madness, others are instantly destroyed.  Those aboard ships are usually spared.  Over three quarters of planet-bound infected simply die within hours." }
	}
	questions[61300] = {
		action="jump", goto=61001,
		player="[AUTO_REPEAT]",
		playerFragment="about your scientist's progress towards a cure",
		alien={"Science will not stop this.  Vissah will not be denied.  Maybe in time the madness will pass.  The few survivors, if we have been chosen to survive, will rebuild civilization.  Nothing can stop fate.  It may be simply that we have been chosen to vacate reality to make room for new forms." }
	}


elseif (plot_stage == 3) then -- war plot state


	questions[60000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about current events",
		alien={"Ill winds blow again through the sector.  The Minex are given death's chariot and dominion to destroy all others.  Madness strikes all, but strikes the Minex most severely." }
	}
	questions[60001] = {
		action="branch",
		choices = {
			{ text="Why the Minex are going to war", goto=61000 },
			{ text="Stopping the Minex", goto=62000 },
			{ text="How great wars been resolved previously", goto=63000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="[AUTO_REPEAT]",
		playerFragment="why the Minex are attacking everyone", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The finger of Vissah is mysterious.  Mad ones infected by her touch have been uniting and attacking the Minex.  The Minex misguided or preemptive wave of destructive retaliation has been unusually successful.  Again a balanced conflagration ensures its continuity, since an imbalance would burn itself out quickly." }
	}
	questions[62000] = {
		action="jump", goto=62001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how we can stop the Minex", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Your part is not predetermined.  Wisdom and earnest effort may yet minimize the destruction.  The chaotic patterns best suited to unravel even the slightest part of this conflagration are impossible to foresee." }
	}
	questions[63000] = {
		action="jump", goto=63001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how these sector-wide wars been resolved in the past", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Waves of genocide and extinction are the rule in existence.  Chaos and war cleanse the stars in an unending tragic pattern.  So it always has it been even in ancient times and so it will always be.  They are burned out in time, not stopped." }
	}
	questions[61001] = {
		action="branch",
		choices = {
			{ text="Infected attacking the Minex", goto=61100 },
			{ text="Balanced conflagration", goto=61200 },
			{ text="Vissah", goto=61300 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[61100] = {
		action="jump", goto=61001,
		player="[AUTO_REPEAT]",
		playerFragment="why those who are infected go out of their way to attack the Minex", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Isolation has frustrated Vissah's influence, or perhaps revealed the next stage of her design.  If the virus cannot infect and kill the Minex, perhaps the virus-infected can.  Will you deny that glimpse of death's supernatural origin?" }
	}
	questions[61200] = {
		action="jump", goto=61201,
		player="[AUTO_REPEAT]",
		playerFragment="the meaning of a balanced conflagration", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"I perceive simplification is necessary.  In warfare equal forces will grind themselves down ensuring maximum destruction.  Unequal forces result in swift and decisive conclusions.  The force and technology of the Minex has now been demonstrated to equal that of every other race combined." }
	}
	questions[61201] = {
		action="jump", goto=61001, ftest= 3, -- aggravating
		player="So no one will win?",
		alien={"Your mind continues to cloud.  Inevitably one side will win, however the goal is maximum destruction.  No one wishes to obtain total destruction, yet the universe is mostly dead space.  Destructive forces are more than capable at halting life's offenses." }
	}
	questions[61300] = {
		action="jump", goto=61001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about who or what is Vissah",
		alien={"The personified force of death or anti-life.  Life is constantly divisive, countless goals all being pursued.  Anti-life is united at a single goal of entropy and clean destruction.  She always draws closest to areas where life has been the most successful, moving off once maximum energies are dissipated." }
	}
	questions[62001] = {
		action="branch",
		choices = {
			{ text="Stopping the the Minex War", goto=62100 },
			{ text="Convincing the Minex to stop fighting", goto=62200 },
			{ text="Talking to the Minex", goto=62300 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[62100] = {
		action="jump", goto=62001,
		player="[AUTO_REPEAT]",
		playerFragment="how to stop the Minex War", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"My knowledge on this matter is yet imperfect, but the answer lies most assuredly with the Minex themselves.  A stubborn people they are and unlikely it is that they will be stopped, but with proper convincing they may stop themselves." }
	}
	questions[62200] = {
		action="jump", goto=62201, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about how to convince the Minex to stop their warfare",
		alien={"The Minex people do not have any interest in words, only truth.  Evidence that shows that both their actions are unproductive and that a cure is possible must be presented by a supplicant." }
	}
	questions[62201] = {
		action="jump", goto=62001, ftest= 2, -- insightful
		player="Where is this evidence?",
		alien={"Death's minions bar our Oracle, but impressions point us in the direction of the Tafel.  They succumbed to this madness almost instantly while other races still struggle and survive.  Nothing else do we know." }
	}
	questions[62300] = {
		action="jump", goto=62001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how to talk to the Minex", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The Minex people do not listen to outsiders, however they have perceptions beyond the natural.  A message must be composed before it is sent.  Grasp the strongest and simplest truth at all times when dealing with them." }
	}
	questions[63001] = {
		action="jump", goto=63002,
		player="This occurred in ancient times as well?",
		alien={"Millennia ago an ancient race of withered beings perpetually fought a war against time itself. They extinguished all other living beings for countless ages until the ancients arrived and put a stop to their folly. We have several clues to their existence, a deserted city, the Minex, and yourselves." }
	}
	questions[63002] = {
		action="branch",
		choices = {
			{ text="A deserted city", goto=63100 },
			{ text="The Minex", goto=63200 },
			{ text="Ourselves?  You mean humans?", goto=63300 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[63100] = {
		action="jump", goto=63002,
		player="[AUTO_REPEAT]",
		playerFragment="about the deserted city",
		alien={"Back in the age of the ancients war, planetary surfaces were wiped clean by unimaginable forces.  A single city was once discovered in the Dagda system, but its location has been lost with time.  Those responsible for extinguishing the imperialists, The Bar-zhon, may retain further information." }
	}
	questions[63200] = {
		action="jump", goto=63002,
		player="[AUTO_REPEAT]",
		playerFragment="about the relationship between the Minex and these withered beings", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Our people have insights into the activities of all races, with the only exception of yours and the Minex.  The Minex appear conventional, but have an energy and form which we cannot emulate or fully understand.  Their biology is quite unique and follows patterns quite foreign to all others.  It is almost as if their life form was possibly, we dare say, designed." }
	}
	questions[63300] = {
		action="jump", goto=63002, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how humanity might be related to these withered beings", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Yes, yourselves. Descriptions from ancient texts describe the slaves of this homicidal race to closely manage the physical description of humans. Unfortunately the slaves were described as deaf, mute, and dumb, only needed for menial physical labor.  The arrival of humanity at this darkest hour may not be coincidence." }
	}

elseif (plot_stage == 4) then -- ancients plot state


	questions[60000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about current events",
		alien={"Many races have now isolated individual biological virus strains actively being created and controlled by infernal nanomachines.  You have halted the Minex War machine and much more is known about the super virus strains, yet there is still no progress towards a cure." }
	}
	questions[60001] = {
		action="branch",
		choices = {
			{ title="<Reveal Minex Secret>", text="The Minex revealed that the Ancients may have a base located at Lir IV.", goto=61000 },
			{ text="Nano-machines?", goto=62000 },
			{ text="Galactic Situation", goto=63000 },
			{ text="Ancients might be causing the problems", goto=64000 },
			{ text="<Back>", goto=6 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001, ftest= 2, -- insightful jjh
		--player="[AUTO_REPEAT]",
		player="...and the second?",
		alien={"I do not know anything about that particular planet, but our most prized lore concerning the Ancients reveals two clues that may be of use to locate information about them.  The first is that the largest and most densely concentrated ancient ruins are always found on the oldest m-class stars." }
	}
	questions[61001] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		alien={"The other clue is this: Interpolating patterns of ancient ruins show a particular focus and symmetry around the planetary coordinates of 47N X 74W and 37N X 8W.  Significant finds on many ancient worlds are often found at these coordinates.  I am not equipped for planetary expeditions. You will have to investigate yourself." }
	}
	questions[62000] = {
		action="jump", goto=62001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about nanomachines",
		alien={"An extremely advanced technology which is somehow sampling genetic material and creating organic control mechanisms to override default behaviors of individual sentients.  Death appears to be a side effect of multiple created strains interfering with each other.  Strict isolation protocols have curtailed the rate of death but not the madness the biological strains create." }
	}
	questions[63000] = {
		action="jump", goto=63001,
		player="[AUTO_REPEAT]",
		playerFragment="anything new about the galactic situation", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The Tafel have suffered devastating losses and seem most susceptible to the control of the nanovirus.  The Coalition has overplayed their hand and has suffered serious setbacks by the Minex and Bar-zhon.  The Bar-zhon with the easing of military pressures has grounded most of their fleet.  Thrynn and Elowan unity and their natural biological resistance have reversed many of their losses.  The Spemin just keep reproducing." }
	}
	questions[64000] = {
		action="jump", goto=64001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="if the Ancients could have possibly created this nano virus",
		alien={"From what is known about the Ancients it seems unlikely but not beyond their capacity to create or stop this nano virus.  A race known as the 'enemy of all life' seems to be a more likely candidate." }
	}
	questions[62001] = {
		action="branch",
		choices = {
			{ text="Races that possess the technology", goto=62100 },
			{ text="Races with advanced knowledge", goto=62200 },
			{ text="Alternative sources of advanced technology", goto=62300 },
			{ text="Supernatural source", goto=62400 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[62100] = {
		action="jump", goto=62001,
		player="[AUTO_REPEAT]",
		playerFragment="which alien races possess the nanomachine technology that could have created the virus", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The ability to create self-replicating nanomachines that use stealth technology to mask their presence, know enough about genetics to rewrite any known species consciousness, establish control mechanisms to coordinate the actions of the controlled, and continue to perfect their control is inconceivably advanced.  It would be easier to simply devise nanomachines to dismantle and rebuild the entire cosmos.  None of the known races could be this advanced" }
	}
	questions[62200] = {
		action="jump", goto=62201, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the alien races possessing any level of knowledge about nanotechnology",
		alien={"Several, but only on a extremely simple level, such as for constructing superconductive microprocessors or for matter duplication.  Straightforward preprogramming tasks cannot compare to this technology." }
	}
	questions[62201] = {
		action="jump", goto=62001,
		player="So which races use nanotechnology?",
		alien={"Ourselves and the Bar-zhon.  The Coalition doubtless has most Bar-Zhon technology as well.  All of it is light years behind anything like this nanovirus." }
	}
	questions[62300] = {
		action="jump", goto=62001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about any other possible source for this virus",
		alien={"Possibly the inaccessible rock planet of Cermait 6.  Shielding technology of incredible potency has prevented all known explorers from landing.  No one has any clue to the source of the shielding nor have observed any activity on the planet's surface to indicate habitation." }
	}
	questions[62400] = {
		action="jump", goto=62001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="why you are no longer claiming a supernatural source for this virus", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The machinations of death are obviously benefiting from this new dark age.  Unlike previous dark ages, a technological influence appears to be behind these actions and dealing with the technological problem may be possible.  Successfully opposing Vissah in her pure form is suicide and if she is directly controlling events then there is no hope.  Your past successes suggest however that Vissah may not be directly responsible." }
	}
	questions[63001] = {
		action="branch",
		choices = {
			{ text="Source of information", goto=63100 },
			{ text="Technology and ruins", goto=63200 },
			{ text="Telepathy", goto=63300 },
			{ text="Races most affected", goto=63400 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[63100] = {
		action="jump", goto=63101,
		player="[AUTO_REPEAT]",
		playerFragment="how you know so much about so many alien races", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"I like others of my kind have achieved perfection of form.  Our race can constantly renew our cells and change ourselves to any form, effectively making us immortal and allowing us to assume any shape or appearance.  Only mental and technological perfection remain to be achieved.  Be very honored, as none have merited this knowledge until now." }
	}
	questions[63101] = {
		action="jump", goto=63001,
		player="Do you have any spies among humans?", ftest= 3, -- aggravating
		alien={"Truly we do not.  At first we dismissed your race as recent upstarts.  More recently the plague has curtailed all physical contact and we dare not leave the isolation of vacuum until this crisis has passed." }
	}
	questions[63200] = {
		action="jump", goto=63001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="where you would recommend us to start looking for ancient technology and ruins", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The Coalition and Bar-zhon share the secret home world locations of the extinct Transmodra, Bx, and Sabion.   Many older civilization ruins are located near the landmark constellations:  The Bow = 60,110, The Pearl Cluster = 20,210, The Wee Dipper = 115,180, and The Ruby Tower = 10,90." }
	}
	questions[63300] = {
		action="jump", goto=63301,
		player="[AUTO_REPEAT]",
		playerFragment="on what you know about telepathy among the races", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The Tafel used cybernetic mind to mind communication on a very limited sense, but they can not be consulted now.  The Spemin can barely be described as self-aware, but appear to have senses beyond the normal.  The Minex appear to have a form of telepathy which resembles a highly refined form of empathy and truth sense.  Only the hostile Uhlek and precursor races appear to be truly telepathic." }
	}
	questions[63400] = {
		action="jump", goto=63001,
		player="[AUTO_REPEAT]",
		playerFragment="about which races have been affected the most by the infection",
		alien={"The Minex and the Tafel share one common trait that has caused them the most difficulty: the conformity and unity of their societies.  This disaster has disrupted the unity of all races and to them have been forced to undergo the greatest change, the greatest upheaval is created." }
	}
	questions[63301] = {
		action="branch",
		choices = {
			{ text="The precursor races", goto=63310 },
			{ text="The Uhlek", goto=63320 },
			{ text="<Back>", goto=63001 }
		}
	}
	questions[63310] = {
		action="jump", goto=63301,
		player="[AUTO_REPEAT]",
		playerFragment="about the precursor races",
		alien={"The Ancients and their contemporaries.  Very little definitive information is known about their telepathic abilities." }
	}
	questions[63320] = {
		action="jump", goto=63301,
		player="[AUTO_REPEAT]",
		playerFragment="about the Uhlek",
		alien={"An extremely hostile and xenophobic race far outward from here.  They have the ability to perfectly track alien vessels in their territory by tracing mental thought patterns alone instead of depending on technology or electromagnetic emission. Unfortunately their only concern is the complete destruction of any trespassing vessel." }
	}

	questions[64001] = {
		action="branch",
		choices = {
			{ text="The Ancients abilities", goto=64100 },
			{ text="The Enemy of the Ancients", goto=64200 },
			{ text="How the enemy was defeated", goto=64300 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[64100] = {
		action="jump", goto=64101,
		player="[AUTO_REPEAT]",
		playerFragment="about the abilities of the ancients",
		alien={"The Ancients were reported to have matter and energy manipulation abilities but they typically worked on massive projects, building entire planets or solar systems.  They also had capabilities of stellar manipulation, galactic transportation, prescience, and most agree have completely transcended the organic world." }
	}
	questions[64101] = {
		action="jump", goto=64001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"It seems unlikely that a race benevolent enough to seed the galaxy with endurium would want to manipulate, kill, or control carbon-based life during this latter age.  If the description of their abilities were accurate, they could just as easily detonate entire solar systems to destroy us all if they wanted to." }
	}
	questions[64200] = {
		action="jump", goto=64001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the enemy of the Ancients",
		alien={"Often described as a race of demons, this enemy labeled by the Minex as the Uyo were vampires, draining life and stealing technology from other races.  They were ascribed tremendous mental powers and reputed to have made slaves of many other races.  Technology such as this nano virus does fit their modus operandi but we have seen no other clue to their return." }
	}
	questions[64300] = {
		action="jump", goto=64001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how the Ancients defeated this enemy", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Only one account of dubious authority tells this story.  The Ancients constructed a brown dwarf star capable of banishing 'the demons' from reality itself.  Countless brown dwarf stars has been located and studied but none of them have shown any unusual traits beyond their slight radiation and their conventional lithium and methane signatures." }
	}


end


end


function QuestDialogueinitial()

--[[
title="Scientific Mission #31:  Whining Orb",
--]]


	questions[85000] = {
		action="jump", goto=85001,
		player="Seeking the Whining Orb",
		introFragment= "Nyssian vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have widely heard of your wisdom and knowledge.",
		playerFragment="about the location of the planet Lazerarp",
		alien={"Yes I am familiar with this planet. In order to correlate the location I will need your navigational computer data.  Will you be willing to transmit that data to me?" }
	}
	questions[85001] = {
		action="jump", goto=85002,
		player="Yes, transmitting now.",
		alien={"Lazerarp is known to you as Alastir, the first planet of the system Tat. (132,125)  What is the significance of this world?" }
	}
	questions[85002] = {
		action="jump", goto=1,
		player="Lazerarp has been used by pirates we are tracking.",
		alien={"Ahh.  Such mundane issues are beneath my attention.  You are welcome to pursue whatever revenge or vanity you wish.  This topic no longer is of interest." }
	}

--[[
title="Freelance Mission #27:  sell artifact from archaeological dig - ticking sphere
--]]

	questions[91000] = {
		action="jump", goto=91001,
		player="Can you tell us about...",
		playerFragment="...",
		alien={"Do you by random chance happen to have a ticking cylinder on board?  If so, I can give you 9 units of endurium for it." }
	}
	questions[91001] = {
		action="branch",
		choices = {
			{ text="Yes, we have that artifact and are willing to trade.",  goto=91100 },
			{ text="I could not let it go for less than 12 endurium.",  goto=91200 },
			{ text="No, we don't have that artifact.",  goto=91300 },
			{ text="I'm not willing to part with it right now.", goto=1 }
		}
	}
	questions[91100] = {
--		active_quest = active_quest + 1
--		artifact25 = 0
--		endurium = endurium + 9
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Very Good.  (Mission Completed)" }
	}
	questions[91200] = {
		action="jump", goto=91001,
		player="[AUTO_REPEAT]",
		alien={"I am not an individual subject to vagaries of negotiation.  I have only one offer and one offer alone.  Please accept it or reject it." }
	}
	questions[91300] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"No subterfuge is necessary.  If you wish to keep the artifact, I will no longer bother you about this matter." }
	}

--[[
title="Freelance Mission #28:  Obtain Data Crystals - no reaper
--]]

	questions[92000] = {
		action="jump", goto=92001,
		player="Acquiring Nyssian Data Crystals.",
		introFragment= "Nyssian vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have widely heard of your wisdom and knowledge.",
		playerFragment="your computer library of data crystals", fragmentTable= preQuestion.desire,
		alien={"My databank of stellar data spans thousands of years of information. You do not possess sufficient resources of any type worth considering.  Actually you may assist me in one way.  Obtain a Thrynn reaper for my study and I will be willing to part with a copy of my data crystal library." }
	}
	questions[92001] = {
		action="branch",
		choices = {
			{ title="Thrynn reaper", text="what a Thrynn reaper is",  goto=92100 },
			{ title="Bribe", text="What about in exchange for 20 endurium crystals?",  goto=92200 },
			{ text="You will turn over your data crystals, Now! ",  goto=92300 },
			{ text="Forget this.  I'm not going to bother.", goto=92400 }
		}
	}
	questions[92100] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		playerFragment="what a Thrynn reaper is",
		alien={"A Thrynn reaper is a very bulky, impractical hand combat device. It's atomic energy pack and high energy output make it too dangerous to use onboard spacecraft, but on a planet against unshielded targets it would be devastating.  It could clear an entire forest within minutes if you want to understand its purpose.  Seek one out and bring it back." }
	}
	questions[92200] = {
		action="jump", goto=92001,
		player="[AUTO_REPEAT]",
		alien={"Normally I would be interested in your generous offer.  I will unfortunately not compromise this time." }
	}
	questions[92300] = {
		action="jump", goto=999,  -- attack
		player="[AUTO_REPEAT]",
		alien={"Regrettably, I must decline your forceful persuasion.  Nyssians will never concede to forceful influence or threats of that nature." }
	}
	questions[92400] = {
--		active_quest = active_quest + 1
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Wise choice.  You would be unlikely to profit from this.  Perform other tasks and do not inquire again.  (Mission Completed)" }
	}
--[[
title="Freelance Mission #28:  Obtain Data Crystals - player possesses a reaper
--]]

	questions[92500] = {
		action="jump", goto=1, ftest= 1,
		player="Acquiring Nyssian Data Crystals.",
		introFragment= "Nyssian vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have obtained a Thrynn Reaper.",
		playerFragment="your computer library of data crystals", fragmentTable= preQuestion.desire,
		alien={"My thanks for your ingenuity. Transferring data crystals now." }
	}

--[[
title="Freelance Mission #29:  Locate the whining orb
--]]

	questions[93000] = {
		action="jump", goto=93001,
		player="Seeking the Whining Orb",
		introFragment= "Nyssian vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have widely heard of your wisdom and knowledge.",
		playerFragment="the location of the planet Lazerarp", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Yes, but in order to correlate the location I will need your navigational computer data.  Will you be willing to transmit that data to me?" }
	}
	questions[93001] = {
		action="jump", goto=93002,
		player="Yes, transmitting now.",
		alien={"Lazerarp is known to you as Alastir, the first planet of the system Tat. (132,125)  What is the significance of this world?" }
	}
	questions[93002] = {
		action="jump", goto=1,
		player="Lazerarp has been used by pirates we are tracking.",
		alien={"Ahh.  Such mundane issues are beneath my attention.  You are welcome to pursue whatever revenge or vanity you wish.  This topic no longer is of interest. " }
	}

--[[
title="Freelance Mission #30:   Obtaining The Amazing Artifact - initial"
--]]

	questions[94000] = {
		action="jump", goto=94001,
		player="Acquiring The Amazing Artifact.",
		introFragment= "Nyssian vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].  Rumors have reached us.",
		playerFragment="The Amazing Artifact", fragmentTable= preQuestion.desire,
		alien={"You would indeed!  This device is of ancient manufacture and is truly unique and will inspire countless technological discoveries." }
	}
	questions[94001] = {
		action="jump", goto=1,
		player="What do you want for it?",
		playerFragment="what you want in exchange for The Amazing Artifact", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Only one item and one item alone are we willing to accept.  Return with a Minex silver gadget and nothing else.  You may obtain such a device from destroying Minex warships but an easier alternative is possible.  I know that the Coalition has recently salvaged such a device on their own and may be willing to part with it." }
	}

--[[
title="Freelance Mission #30:   Obtaining the amazing artifact -  final trade"
--]]

	questions[94500] = {
--		artifact26 = 1
--		artifact23 = 0
		action="jump", goto=1, ftest= 1,
		player="I have a Minex silver gadget for you.",
		introFragment= "Nyssian vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].",

		playerFragment="The Amazing Artifact in exchange for this Minex silver gadget", fragmentTable= preQuestion.desire,
		alien={"You will be most pleased.  I am transporting The Amazing Artifact now in exchange." }
	}

--[[
title="Freelance Mission #34:  Pawn off Unusual Artistic Containers
--]]

	questions[98000] = {
		action="jump", goto=999, -- attack the player
		player="Pawn off Artistic Containers",
		introFragment= "Nyssian vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].",

		playerFragment="something in exchange for these incredibly old artistic containers", fragmentTable= preQuestion.desire,
		alien={"Thieves!!  Grave robbers!!  This goes too far!!" }
	}

--[[
title="Freelance Mission #35:  Diplomacy mission"
--]]

	questions[99000] = {
		action="jump", goto=99001,
		player="Tell us about the Elowan Bar-zhon conflict",
		introFragment= "Nyssian Scout.  This is Captain [CAPTAIN].  We have heard of the recent conflict between the Elowan and the Bar-zhon.",
		playerFragment="about the situation",
		alien={"A most regrettable and unnecessary conflict.  An observation by one of our scouts leads me to think that the conflict might be instigated by the Thrynn." }
	}
	questions[99001] = {
		action="jump", goto=99002,
		player="Tell us about that report.",
		playerFragment="about that report",
		alien={"One of our ships observed a Thrynn vessel approaching the Aircthech system a few months ago.  The Thrynn ship launched a probe of some sort from extreme range before fleeing back into hyperspace.  The curious captain decided to enter the system and follow the drone.  His scans showed no high energy sources nor biologicals on board the drone so no action was taken." }
	}

	questions[99002] = {
		action="jump", goto=1,
		player="What happened to the probe?",
		playerFragment="what happened to the probe", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The probe entered the atmosphere of the third planet briefly but then skipped off and headed on a trajectory that would cause it to land on the second planet.  Detecting multiple ships in the system, the captain declined to pursue.  A representative told the Elowan this but they want evidence." }
	}

end

function QuestDialoguevirus()

--[[
title="Mission #37:  Catching the Smugglers.",
--]]
	questions[77000] = {
		action="jump", goto=77001,
		title="Catching the Smugglers",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are on official Myrrdan business to track down two dangerous criminal starships of our own race.",
		playerFragment="any information that could help us find them",
		alien={"I may have some limited knowledge of this matter, yet my time is valuable and my need to pursue more urgent matters pressing." }
	}
	questions[77001] = {
		action="branch",
		choices = {
			{ title="Pressing Matters?", text="What pressing matters are you referring to?",  goto=77100 },
			{ title="Bribe", text="Perhaps five units of fuel may assist in your pressing matters.",  goto=77200 },
			{ title="Threaten", text="This is urgent! We demand that you tell us any information you may have concerning these criminals!",  goto=77300 },
			{ text="Nevermind, let me ask you about something else.", goto=1 }
		}
	}
	questions[77100] = {
		action="jump", goto=77001, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Oh supplies and of the sort, the basest of crass materialism.  I would hardly wish to drag your attention down to it.  Forget I mentioned anything." }
	}
	questions[77200] = {
		action="jump", goto=1,  ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Such generosity is quite unnecessary but I will accept your offer regardless.  My hesitancy is based on repeating uncomfortable rumors on a subject which your people have firsthand knowledge." }
	}
	questions[77205] = {
		action="jump", goto=997,  ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Your fuel tanks are in greater need of your attention then mine.  Perhaps you should attend to materialistic concerns of your own first." }
	}
	questions[77206] = {
		action="jump", goto=77207,
		player="[AUTO_REPEAT]",
		alien={"Your generosity is much appreciated and my knowledge most limited. A number of weeks ago the Spemin observed a pair of Myrrdan ships conducting multiple raids upon Thrynn territory and fleeing into Elowan space. I understand that this provoked a major diplomatic issue between the Thrynn and your race." }
	}
	questions[77207] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		playerFragment="about their location now",
		alien={"My apologies, this is the extent of my knowledge of the matter." }
	}
	questions[77300] = {
		action="jump", goto=997,  ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Your urgency is none of my concern.  All of our societies are approaching their end and your focus is upon trivial matters.  We have nothing more to say." }
	}

--[[
title="Mission #38:  Collecting Genetic Samples"
--]]
	questions[78000] = {
		action="jump", goto=78001,
		title="Genetic Samples",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are working with a team of medical researchers attempting to find a cure for this plague.",
		playerFragment="samples of genetic material from members of your race", fragmentTable=preQuestion.desire,
		alien={"I do indeed have such sampling of my race. It is yours for a trifle. Would you transmit a scan of the hypercube artifact which you obtained earlier?" }
	}
	questions[78001] = {
		action="branch",
		choices = {
			{ title="Yes", text="Yes, transmitting hypercube scanning data to you now.", goto=78002 },
			{ text="No",  goto=1 },
		}
	}
	questions[78002] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Transporting samples now." }
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
		alien={"This so-called device is nothing but random noise. There is no correlation between our vast databases of language and any recognizable pattern here." }
	}

--[[
title="Mission #41:  Organic Database
--]]

	questions[81200] = {
		action="jump", goto=81201,
		title="Organic Database",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="about this organic database",
		alien={"This is exquisite. What a breathtaking construction of primitive genius!  Such simplistic yet marvelous ingenuity created such a wonder!  And both of these artifacts at the site of an extinguished expedition?" }
	}
	questions[81201] = {
		action="jump", goto=1,
		player="Can you decode it?",
		alien={"Decode it?  This is not a database of words and language. It is a genetic piece of art!  Sublime in it's majesty and message of hope.  Does a sunset speak in words?  Yes, but not in words that a computer might understand and translate.  There is no secret decodable message here!" }
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
		alien={"This so-called device is nothing but random noise. There is no correlation between our vast databases of language and any recognizable pattern here." }
	}

	questions[81501] = {
		action="jump", goto=81502,
		player="What about this organic database?",
		alien={"This is exquisite. What a breathtaking construction of primitive genius!  Such simplistic yet marvelous ingenuity created such a wonder!  And both of these artifacts at the site of an extinguished expedition?" }
	}
	questions[81502] = {
		action="jump", goto=1,
		player="Can you decode it?",
		alien={"Decode it?  This is not a database of words and language. It is a genetic piece of art!  Sublime in it's majesty and message of hope.  Does a sunset speak in words?  Yes, but not in words that a computer might understand and translate.  There is no secret decodable message here!" }
	}

--[[
title="Mission #42:  Tracking the Laytonites
--]]

	questions[82000] = {
		action="jump", goto=1,
		title="Tracking the Laytonites",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are here as representatives of the Myrrdan government seeking a small fleet of rebel Myrrdan terrorists.",
		playerFragment="any information that could help us find them",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"None of the ship emission signatures or silloettes have been observed by any of our vessels. We will contact your government if they are spotted." }
	}


--[[
title="Mission #43:  Desperate Measures
--]]

	questions[83000] = {
		action="jump", goto=997, -- terminate communications
		title="Desperate Measures",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  It is extremely important that we talk to you about this fabricated Bar-Zhon / Myrrdan incident.",
		playerFragment="any information that could help us", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"We are assisting the Bar-zhon in the investigation of the incident.  Until this investigation is concluded we request that your ships maintain station only within your home system.  This statement in no way should be construed as any sort of threat, merely a helpful suggestion to prevent future unfortunate incidents." }
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
		alien={"The fools that try to contain Vissah have not even a sliver of a chance of success. This group of aliens trying to profit off of a treatment for reducing the side effects of the plague is no exception.  Their drug is not even medication, their members composed primarily of coalition exiles are not even doctors.  Only a Bar-zhon envoy fell for the deception." }
	}

	questions[85100] = {
		action="jump", goto=1,
		player="Bar-zhon Envoy?",
		alien={"Yes, a sole cruiser was sent to contact the group and obtain the treatment.  I have recently learned that shortly afterwards their ship crashed upon Lusmore I (227, 73) at 99N X 115E.  The hand of the black wind is very long." }
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
		alien={"This is an insane concoction of mind altering drugs.  I would rather drink reactor coolant.  The only crew foolish enough to try it went insane and crash dived into a planet.  What does that tell you?" }
	}

--[[
title="Mission #46:  Shield phase synchronizer
--]]

	questions[86000] = {
		action="jump", goto=86001,
		title="Shield phase synchronizer",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have been told that you have a special artifact for us.",
		playerFragment="for this unique device", fragmentTable=preQuestion.desire,
		alien={"Excellent, most excellent! I have this Na'tash disrupter available for you today for only 25 radioactives or 120 endurium. What currency do you want to pay with?" }
	}
	questions[86001] = {
		action="branch",
		choices = {
			{ text="25 radioactives", goto=86100 },
			{ text="120 endurium", goto=86200 },
			{ title="Barter", text="We don't quite have that many resources available. What about in exchange for 60 endurium?", goto=86300 },
			{ title="Request Further Details", text="Could you describe exactly what the Na'tash generator does?", goto=86400 },
			{ text="<New subject>", goto=1 }
		}
	}
	questions[86100] = {
		action="jump", goto=1, ftest= 1, -- artifact267 Na'tash generator
		player="[AUTO_REPEAT]",
		playerFragment="the device for 25 radioactives",  fragmentTable=preQuestion.desire,
		alien={"Indeed we are ready to receive your transport." }
	}
	questions[86110] = {
		action="jump", goto=997, -- terminate communications
		player="[AUTO_REPEAT]",
		alien={"Good exchange.  May you be ever pleased with your purchase." }
	}
	questions[86120] = {
		action="jump", goto=86001,
		player="[AUTO_REPEAT]",
		alien={"Our sensors indicate you do not have sufficient quantity of radioactive available. Perhaps you may wish to utilize an alternative payment method?" }
	}
	questions[86200] = {
		action="jump", goto=1, ftest= 1, -- artifact267 Na'tash generator
		player="[AUTO_REPEAT]",
		playerFragment="the device for 120 endurium",  fragmentTable=preQuestion.desire,
		alien={"Indeed we are ready to receive your transport." }
	}
	questions[86210] = {
		action="jump", goto=997, -- terminate communications
		player="[AUTO_REPEAT]",
		alien={"Good exchange.  May you be ever pleased with your purchase." }
	}
	questions[86220] = {
		action="jump", goto=86001,
		player="[AUTO_REPEAT]",
		alien={"Our sensors indicate you do not have sufficient quantity of fuel available. Perhaps you may wish to utilize an alternative payment method?" }
	}
	questions[86300] = {
		action="jump", goto=86001,
		player="[AUTO_REPEAT]",
		alien={"" }
	}
	questions[86400] = {
		action="jump", goto=86401,
		player="[AUTO_REPEAT]",
		alien={"The Na'tash generator creates a white noise jamming field that disrupts many long range devices." }
	}
	questions[86401] = {
		action="jump", goto=86402,
		player="Does it disrupt shields?",
		alien={"No, that is another unique artifact I have available: The Krang. A wondrous Shield phase synchronizer capable of allowing a ship to pass through most force shields.  Same price." }
	}
	questions[86402] = {
		action="jump", goto=86501,
		player="Why did you offer us the Na'tash first?",
		alien={"Because I have one.  So are you ready to purchase The Krang?" }
	}
--[[
title="Mission #46:  Shield phase synchronizer - player previously fooled into purchasing the Na'tash disrupter
--]]

	questions[86500] = {
		action="jump", goto=86501,
		title="Shield phase synchronizer",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  This Na'tash generator doesn't work. It fails to penetrate any of our test forcefields.",
		playerFragment="why you deceived us",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"I never said it would penetrate force fields. The Na'tash generator creates a white noise jamming field that disrupts many long range devices.  It has many other uses.  You are seeking another device known as the the Krang.  It is available for the same price: 25 radioactives or 120 endurium. " }
	}
	questions[86501] = {
		action="branch",
		choices = {
			{ text="25 radioactives", goto=86600 },
			{ text="120 endurium", goto=86700 },
			{ title="Why the Na'tash?", text="Why did you offer us the Na'tash first?", goto=86800 },
			{ title="Does it work?", text="Does this Krang device actually work to penetrate shields?", goto=86900 },
			{ text="<New subject>", goto=1 }
		}
	}
	questions[86600] = {
		action="jump", goto=1, ftest= 1, -- artifact268 The Krang
		player="[AUTO_REPEAT]",
		playerFragment="the device for 25 radioactives",  fragmentTable=preQuestion.desire,
		alien={"Indeed we are ready to receive your transport." }
	}
	questions[86610] = {
		action="jump", goto=997, -- terminate communications
		player="[AUTO_REPEAT]",
		alien={"Good exchange.  May you be ever pleased with your purchase." }
	}
	questions[86620] = {
		action="jump", goto=86501,
		player="[AUTO_REPEAT]",
		alien={"Our sensors indicate you do not have sufficient quantity of radioactives available. Perhaps you may wish to utilize an alternative payment method?" }
	}
	questions[86700] = {
		action="jump", goto=1, ftest= 1, -- artifact268 The Krang
		player="[AUTO_REPEAT]",
		playerFragment="the device for 120 endurium",  fragmentTable=preQuestion.desire,
		alien={"Indeed we are ready to receive your transport." }
	}
	questions[86710] = {
		action="jump", goto=997, -- terminate communications
		player="[AUTO_REPEAT]",
		alien={"Good exchange.  May you be ever pleased with your purchase." }
	}
	questions[86720] = {
		action="jump", goto=86501,
		player="[AUTO_REPEAT]",
		alien={"Our sensors indicate you do not have sufficient quantity of fuel available. Perhaps you may wish to utilize an alternative payment method?" }
	}
	questions[86800] = {
		action="jump", goto=86501,
		player="[AUTO_REPEAT]",
		alien={"Because I have one.  So are you ready to purchase The Krang?" }
	}
	questions[86900] = {
		action="jump", goto=86501,
		player="[AUTO_REPEAT]",
		alien={"Yes, I guarantee it will penetrate most shielding. It is a unique device that has changed hands throughout the ages but no modern science has yet to reverse engineer." }
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
		alien={"Fleet combat is not my forte. I have no tactical information on Minex warships since I have been completely successful at avoiding them. These things I have long known about the Minex psyche: they are sensitive to losses. If you overwhelm them with overwhelming opposition they will instantly change tactics from seeking the largest numbers of ships of yours to destroy to preserving the greatest number of their ships. They have absolutely no strategic goals." }
	}
	questions[78001] = {
		action="jump", goto=60001,
		title="Intelligence Collaboration",
		player="[AUTO_REPEAT]",
		playerFragment="why they have no strategic goals", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"This is unclear. I know only that the Minex have been given death's chariot and dominion to destroy all others." }
	}

--[[
title="Mission #53:  Tactical Coordination
--]]

	questions[83000] = {
		action="jump", goto=1,  ftest= 1, -- artifact339 Nyssian response
		title="Tactical Coordination",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are working with the Bar-zhon to discover fleet combinations that would be most effective in countering the Minex onslaught.",
		playerFragment="if you would commit a few ships to tactical exercises being conducted for this purpose", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Combat is not the purpose of our existence. Space is vast and observers like ourselves have no need to enter hopeless conflicts. When your race has learned the unavoidable inevitability of the cycles of prosperity and decline then you will at last know wisdom." }
	}


--[[
title="Mission #56:  Scavenger Hunt - 362 Bar-zhon Analyzed Organic Monstrosity
--]]

	questions[86000] = {
		action="jump", goto=86001, ftest= 1, -- remove and replace artifact362 Bar-zhon Analyzed Organic Monstrosity
		title="Scavenger Hunt",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="about this Organic Monstrosity we found at an archeological site.",
		alien={"You did not find this at an archaeological site, this is a ship fragment of an Gazurtoid vessel shot down a thousand years ago by the Sabion and kept at a secret underground lab. For decades this was their secret doomsday project.  If they were successful in deciphering its technology, they could have grown an organic ship with complete immunity to all projectile weaponry." }
	}
	questions[86001] = {
		action="jump", goto=1, ftest= 1,
		player="<More>",
		alien={"The Gazurtoid are very unorthodox and creative thinkers that few can ever hope to understand. They suffer a high level of insanity and counterbalance that with rigid laws and a rigid belief system in order to give their civilization a modicum of stability.  I tell you this knowing that Myrrdan engineers are still going to try to waste their time deciphering the secrets of this artifact. I wish them luck." }
	}


end

function QuestDialogueancients()


end

function OtherDialogue()

	-- attack the player because attitude is too low
	questions[910] = {
		action="jump", goto=997,
		player="What can you tell us about...",
		alien={"'Tis a rare event indeed to find one so disreputable.  Be thankful that vengeance is not in my nature. Leave me now." }
	}
	-- hostile termination question
	questions[920] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"You should depart.  My patience is at an end." }
	}
	-- neutral termination question
	questions[930] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"'Tyana via arrdis.  From the connectives of facts doth wisdom grow.  I leave you to form such connectives." }
	}
	-- friendly termination question
	questions[940] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"'Twas a pleasure [CAPTAIN] discoursing infinity.  I am sorry that my path draws me elsewhere.  Return whenever you wish." }
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


	engineclass = 2
	shieldclass = 8
	armorclass = 6
	laserclass = 1
	missileclass = 1
	laser_modifier = 10				-- % of damage received, used for racial abilities, 0-100%
	missile_modifier = 60			-- % of damage received, used for racial abilities, 0-100%

elseif (plot_stage == 2) then -- virus plot state


	engineclass = 3
	shieldclass = 8
	armorclass = 6
	laserclass = 1
	missileclass = 1
	laser_modifier = 0				-- % of damage received, used for racial abilities, 0-100%
	missile_modifier = 40			-- % of damage received, used for racial abilities, 0-100%

elseif (plot_stage == 3) then -- war plot state


	engineclass = 3
	shieldclass = 8
	armorclass = 6
	laserclass = 2
	missileclass = 1
	laser_modifier = 0				-- % of damage received, used for racial abilities, 0-100%
	missile_modifier = 30			-- % of damage received, used for racial abilities, 0-100%

elseif (plot_stage == 4) then -- ancients plot state


	engineclass = 4
	shieldclass = 8
	armorclass = 6
	laserclass = 4
	missileclass = 1
	laser_modifier = 0				-- % of damage received, used for racial abilities, 0-100%
	missile_modifier = 30			-- % of damage received, used for racial abilities, 0-100%

end


	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in


if (plot_stage == 1) then -- initial plot state

	DROPITEM1 = 19;	    DROPRATE1 = 60;		DROPQTY1 = 1 -- Nyssian Bauble
	DROPITEM2 = 18;		DROPRATE2 = 90;	    DROPQTY2 = 1 -- Flat Device
	DROPITEM3 = 16;		DROPRATE3 = 90;		DROPQTY3 = 1 -- Whining Orb
	DROPITEM4 = 15;		DROPRATE4 = 95;		DROPQTY4 = 1 -- Bar-Zhon Data Cube
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 5 -- Endurium

elseif (plot_stage == 2) then -- virus plot state

	DROPITEM1 = 230;	DROPRATE1 = 80;		DROPQTY1 = 1 -- Nyssian genetic material
	DROPITEM2 = 18;		DROPRATE2 = 90;	    DROPQTY2 = 1 -- Flat Device
	DROPITEM3 = 16;		DROPRATE3 = 90;		DROPQTY3 = 1 -- Whining Orb
	DROPITEM4 = 15;		DROPRATE4 = 95;		DROPQTY4 = 1 -- Bar-Zhon Data Cube
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 5 -- Endurium

elseif (plot_stage == 3) then -- war plot state

	DROPITEM1 = 19;	    DROPRATE1 = 60;		DROPQTY1 = 1 -- Nyssian Bauble
	DROPITEM2 = 18;		DROPRATE2 = 90;	    DROPQTY2 = 1 -- Flat Device
	DROPITEM3 = 16;		DROPRATE3 = 90;		DROPQTY3 = 1 -- Whining Orb
	DROPITEM4 = 15;		DROPRATE4 = 95;		DROPQTY4 = 1 -- Bar-Zhon Data Cube
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 5 -- Endurium

elseif (plot_stage == 4) then -- ancients plot state

	DROPITEM1 = 19;	    DROPRATE1 = 60;		DROPQTY1 = 1 -- Nyssian Bauble
	DROPITEM2 = 18;		DROPRATE2 = 90;	    DROPQTY2 = 1 -- Flat Device
	DROPITEM3 = 16;		DROPRATE3 = 90;		DROPQTY3 = 1 -- Whining Orb
	DROPITEM4 = 15;		DROPRATE4 = 95;		DROPQTY4 = 1 -- Bar-Zhon Data Cube
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 5 -- Endurium

end

	SetPlayerTables()

	FTEST= -1	--FTEST is used to activate the commFxn, for decision making during conversations.

	--player_Endurium= player_Endurium +15	--  debugging use
	--active_quest = 29 	--  debugging use
	--artifact18 = 1		--  debugging use

	--initialize dialog	else

if (plot_stage == 1) then -- initial plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low
	elseif player_profession == "scientific" and active_quest == 31 and artifact16 == 0 then
		first_question = 85000
	elseif player_profession == "freelance" and active_quest == 27 and artifact25 == 1 then
		first_question = 91000
	elseif player_profession == "freelance" and active_quest == 28 and artifact19 == 0 and artifact219 == 0 then
		first_question = 92000
	elseif player_profession == "freelance" and active_quest == 28 and artifact19 == 0 and artifact219 > 0 then
		first_question = 92500
	elseif player_profession == "freelance" and active_quest == 29 and artifact16 == 0 then
		first_question = 93000
	elseif player_profession == "freelance" and active_quest == 30 and artifact26 == 0 and artifact23 == 0 then
		first_question = 94000
	elseif player_profession == "freelance" and active_quest == 30 and artifact26 == 0 and artifact23 == 1 then
		first_question = 94500
	elseif player_profession == "freelance" and active_quest == 34 and artifact18 == 1 then
		first_question = 98000
	elseif player_profession == "freelance" and active_quest == 35 then
		first_question = 99000

	else
		first_question = 1
	end

elseif (plot_stage == 2) then -- virus plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low

	elseif active_quest == 37 then -- catching the smugglers
		first_question = 77000

	elseif active_quest == 38 then -- medical samples
		first_question = 78000


-- Quest 41: Medical Archaeology
	elseif active_quest == 41 and artifact247 > 0 and artifact249 == 0 then -- exotic dataCube only
		first_question = 81000

	elseif active_quest == 41 and artifact247 == 0 and artifact249 > 0 then -- organic database only
		first_question = 81200

	elseif active_quest == 41 and artifact247 > 0 and artifact249 > 0 then -- exotic dataCube and organic database
		first_question = 81500

	elseif active_quest == 42 and artifact253 == 0 then
		first_question = 82000

-- Mission #43:  Framed!
	elseif active_quest == 43 then
		first_question = 83000


-- Mission #45:  Healthcare Scam - no medical treatment sample
	elseif active_quest == 45 and artifact265 == 0 and artifact266 == 0 then
		first_question = 85000

-- Mission #45:  Healthcare Scam - medical treatment sample
	elseif active_quest == 45 and artifact265 == 1 and artifact266 == 0 then
		first_question = 85500

-- Mission #46:  Shield phase synchronizer initial
	elseif active_quest == 46 and artifact267 == 0 and artifact268 == 0 then
		first_question = 86000

-- Mission #46:  Shield phase synchronizer - purchased from device
	elseif active_quest == 46 and artifact267 == 1 and artifact268 == 0 then   --mark
		first_question = 86500

	else
		first_question = 1
	end

elseif (plot_stage == 3) then -- war plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low

-- Mission #48:  Intelligence Gathering
	elseif active_quest == 48 then
		first_question = 78000


-- Mission #53:  Tactical coordination
	elseif active_quest == 53 and artifact335 == 1 then
		first_question = 83000

-- Mission #56:  Scavenger Hunt - 362 Bar-zhon Analyzed Organic Monstrosity
	elseif active_quest == 56 and artifact362 == 1 then
		first_question = 86000


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
	friendlyattitude = 90
	-- Attitude this value and higher is a neutral attitude, alien disarmed weapons but has raised shields
	neutralattitude = 40


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
	if (type == 0) then							--greeting attitude adjustments
		if (POSTURE == "friendly") then
			ATTITUDE = ATTITUDE + 1
		elseif (POSTURE == "obsequious") then
			ATTITUDE = ATTITUDE + 8
		elseif (POSTURE == "hostile") then
			ATTITUDE = ATTITUDE - 15
		end

	elseif (type == 1) then							--statement attitude adjustments
		if (POSTURE == "friendly") then
			ATTITUDE = ATTITUDE + 1
		elseif (POSTURE == "obsequious") then
			ATTITUDE = ATTITUDE + 3
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

	elseif (ATTITUDE < friendlyattitude and number_of_actions > 12) then
		goto_question = 930  -- jump to neutral termination question
		number_of_actions = 0

	elseif (number_of_actions > 25) then
		goto_question = 940  -- jump to friendly termination question
		number_of_actions = 0


	elseif (ftest < 1) then
		return

	else											--question
		if (n == 10000) or (n == 20000) or (n == 30000) or (n == 40000) then  -- General adjustment every time a category is started
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE + 3
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 3
			end

		elseif (ftest == 6) then   -- Very Aggravating question
			ATTITUDE = ATTITUDE - 15
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
				ATTITUDE = ATTITUDE + 0
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 8
			end
		end


		if (plot_stage == 1) then -- initial plot state

			if (n == 91100) then
				active_quest = active_quest + 1
				artifact25 = 0
				player_Endurium= player_Endurium +9
				ATTITUDE = ATTITUDE + 15
				ATTITUDE = ATTITUDE + 20
			elseif (n == 92500) then
				artifact19 = 1
				artifact219 = 0
				ATTITUDE = ATTITUDE + 10
			elseif (n == 92400) then
				active_quest = active_quest + 1
			elseif (n == 94500) then
				artifact26 = 1
				artifact23 = 0
				ATTITUDE = ATTITUDE + 15
			end

		elseif (plot_stage == 2) then -- virus plot state

			if (n == 77200) then -- Quest 37: Information about the smugglers

				if (player_Endurium < 5) then
					goto_question = 77205
				else
					goto_question = 77206
					player_Endurium= player_Endurium -5
				end
			elseif (n == 78002) then -- quest 38: Obtaining Genetic Samples, player is assumed to have hypercube data
				artifact230 = 1

			elseif (n == 85500) then -- quest 45 make it look like transporting medical treatment
				artifact265 = 0
				artifact265 = 1

			elseif (n == 86100) then
				if (player_Radium + player_Uranium + player_Thorium >= 25) then
					player_Thorium = 0
					player_Radium = 0
					player_Uranium = 0
					artifact267 = 1
					goto_question = 86110 -- give the player the Na'tash generator for radioactives
					ATTITUDE = ATTITUDE + 10
				else
					goto_question = 86120 -- complain about lack of radioactives
					ATTITUDE = ATTITUDE - 5
				end

			elseif (n == 86200) then
				if (player_Endurium >= 120) then
					player_Endurium = player_Endurium - 120
					artifact267 = 1
					goto_question = 86210 -- give the player the Na'tash generator for fuel
					ATTITUDE = ATTITUDE + 10
				else
					goto_question = 86220 -- complain about lack of fuel
					ATTITUDE = ATTITUDE - 5
				end

			elseif (n == 86600) then
				if (player_Radium + player_Uranium >= 25) then
					player_Radium = 0
					player_Uranium = 0
					artifact268 = 1
					goto_question = 86610 -- give the player the Krang for radioactives
					ATTITUDE = ATTITUDE + 10
				else
					goto_question = 86620 -- complain about lack of radioactives
					ATTITUDE = ATTITUDE - 5
				end

			elseif (n == 86700) then
				if (player_Endurium >= 120) then
					player_Endurium = player_Endurium - 120
					artifact268 = 1
					goto_question = 86710 -- give the player the Krang for fuel
					ATTITUDE = ATTITUDE + 10
				else
					goto_question = 86720 -- complain about lack of fuel
					ATTITUDE = ATTITUDE - 5
				end

			end
		elseif (plot_stage == 3) then -- war plot state

-- Mission #53: Tactical coordination
			if (n == 83000) then
				artifact339 = 1 -- Nyssian response

-- Mission #56: Scavenger Hunt
			elseif (n == 86000) then
					artifact362 = 0
			elseif (n == 86001) then
					artifact362 = 1

			end
		elseif (plot_stage == 4) then -- ancients plot state


		end
	end
end
