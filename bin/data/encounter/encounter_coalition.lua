--[[------------------------------------------------------------------------------------------------------------------------------------------------- ]
	ENCOUNTER SCRIPT FILE: COALITION

	Last Modified:  November 30, 2012

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

--[[ What do you think of this idea: I've dumped all the statements from the Coalition initial file,
	 plus a few from other files (most are the same) into this categorized statements table (could
	 do same for greetings). Using this (see below) would have one big advantage: if the statements
	 are categorized well, so that the same set of alien responses will suffice for each category,
	 we can make the player field a *table* (just like the alien response), thus greatly multiplying
	 the range of communications statement/response combinatoric possibilities. It also would allow
	 further dumping of additional statements and greetings into the categories to be propagated to
	 all scripts with essentially no effort at all (and extending communications variability yet
	 further). All the dialogue is also centralized into 1 spot for easy maintenance, saving a bit
	 on editing time.

	 The disadvantage is that then you no longer have the exact text you're replying to directly
	 above your reply, and would need to refer to the common file (where these would wind up).
	 There are not so many of many statements & greetings that this would be a big issue.

	 I put a few examples of using this into the friendly statements section; I've tested this &
	 it works OK. - ww
--]]
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


if (plot_stage == 1) then

	obsequiousGreetTable= {
		"We are the ancient and mighty Uhlek.  Bow and pay us homage!  Snicker, snicker.",
		"We ain't your father's Bar-zhon.",
		"Us is stupid alien the most delightful.  Now it is the message leave at the beep.",
		"Haha!  That is a laugh!  Don't try to make a chant, you berk!",
		"Silly humans, tricks are for us!",
		"Sure, we believe you.  Try pulling the wool over the goat somewhere else."
	}

elseif (plot_stage == 2) then

	obsequiousGreetTable= {
		"We are the powerful Leghk.  Upload your medical database if you want to live.",
		"We are the Bar-zhon Imperial guard.  Pay respects to us because you are among royalty.",
		"Drifting, dashing, dreaming.  We are the eternal ones. You will immediately transmit your database to us in homage.",
		"Haha!  That is a laugh!  Don't try to make a chant, you berk!",
	}

elseif (plot_stage == 3) then

	obsequiousGreetTable= {
		"We are the ancient and mighty Uhlek.  Bow and pay us homage!  Snicker, snicker.",
		"We ain't your father's Bar-zhon.",
		"Us is stupid alien the most delightful.  Now it is the message leave at the beep.",
		"Haha!  That is a laugh!  Don't try to make a chant, you berk!",
		"Silly humans, tricks are for us!",
		"Sure, we believe you.  Try pulling the wool over the goat somewhere else."
	}


elseif (plot_stage == 4) then

	obsequiousGreetTable= {
		"We are the ancient and mighty Uhlek.  Bow and pay us homage!  Snicker, snicker.",
		"We ain't your father's Bar-zhon.",
		"Us is stupid alien the most delightful.  Now it is the message leave at the beep."
	}

end


	greetings[1] = {
		action="",
		player="Hail oh mighty ones, masters of the universe.",
		alien= 	obsequiousGreetTable }
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien= obsequiousGreetTable	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien= obsequiousGreetTable }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien= obsequiousGreetTable }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien= obsequiousGreetTable }
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

if (plot_stage == 1) then

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
		alien={"What do you want?"} }
	greetings[4] = {
		action="",
		player="Dude, that is one odd ship you have there!",
		alien={"Why thank you very much.  It is my own custom model transport freighter outfitted with afterburners and state-of-the-art weaponry just ready to slice and dice and even make julian fries."} }
	greetings[5] = {
		action="",
		player="How's it going, umm ... aren't you Bar-zhon?",
		alien={"Nope."} }
	greetings[6] = {
		action="",
		--player="Your ship seems to be very powerful.",
		player= playerStatement.friendly.remark.ship[3], -- (could join ship[2] in table)
		alien={"Why thank you kind sir or madame.  Your ship doesn't."} }
	greetings[7] = {
		action="",
		--player="Your ship appears very irregular.",
		player= playerStatement.friendly.remark.ship[1], --(could join ship[2 & 3] in table)
		alien={"Why thank you very much.  It is my own custom model transport freighter outfitted with afterburners and state-of-the-art weaponry just ready to slice and dice and even make julian fries."} }
	greetings[8] = {
		action="",
		--player="We come in peace from Myrrdan, please trust me.",
		player= playerStatement.friendly.comment.trust[1], -- (could join trust[2])
		alien={"Oh we believe you, believe me that we believe you."} }
	greetings[9] = {
		action="",
		--player="There is no limit to what both our races can gain from mutual exchange.",
		player= playerStatement.friendly.comment.info_exchange[1], --answer needs this one.
		alien={"I would wholeheartedly agree, as long as to exchange is kept in our direction."} }
	greetings[10] = {
		action="",
		--player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		player= playerStatement.friendly.comment.trust[3], --answer needs this one :)
		alien={"How did you come up with a whopper like that one?"} }

--[[ So using the categorized table of statements with the minimal expansion I put in, #possibilities
   rises by ~ x2. If multiple alien responses here are put into the response table (like is done with
   the obsequious greetings: could imagine answering statements[1] with both the alien response
   to statements[1] and the response to statements[2] for an additional 2 possibilities, and the
   response to statements[3] could be added to the response to statements[4] for another 2 possibilities.
   So 5 -> 13 possibilites altogether in this little example.
--]]

elseif (plot_stage == 2) then

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
	greetings[6] = {
		action="",
		--player="Your ship seems to be very powerful.",
		player= playerStatement.friendly.remark.ship[3], -- (could join ship[2] in table)
		alien={"Why thank you kind sir or madame.  Your ship doesn't."} }
	greetings[7] = {
		action="",
		--player="Your ship appears very irregular.",
		player= playerStatement.friendly.remark.ship[1], --(could join ship[2 & 3] in table)
		alien={"Why thank you very much.  It is my own custom model transport freighter outfitted with afterburners and state-of-the-art weaponry just ready to slice and dice and even make julian fries."} }
	greetings[8] = {
		action="",
		--player="We come in peace from Myrrdan, please trust me.",
		player= playerStatement.friendly.comment.trust[1], -- (could join trust[2])
		alien={"Oh we believe you, believe me that we believe you."} }
	greetings[9] = {
		action="",
		--player="There is no limit to what both our races can gain from mutual exchange.",
		player= playerStatement.friendly.comment.info_exchange[1], --answer needs this one.
		alien={"I would wholeheartedly agree, as long as to exchange is kept in our direction."} }
	greetings[10] = {
		action="",
		--player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		player= playerStatement.friendly.comment.trust[3], --answer needs this one :)
		alien={"How did you come up with a whopper like that one?"} }


elseif (plot_stage == 3) then

	greetings[1] = {
		action="",
		player="Greetings from the planet Myrrdan. We come in peace...usually.",
		alien={"Greetings [CAPTAIN].  Coalition interceptor responding to your hail."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"This is Captain anonymous of the Coalition.  Responding to your hail."} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Hi [CAPTAIN].  Times are indeed troubling yet profitable.  Any news on this sickness?."} }
	greetings[4] = {
		action="",
		player="Dude, that is one odd ship you have there!",
		alien={"Why thank you very much.  It is my own custom model transport freighter outfitted with afterburners and state-of-the-art weaponry just ready to slice and dice and even make julian fries."} }
	greetings[5] = {
		action="",
		player="How's it going, umm ... aren't you Bar-zhon?",
		alien={"Nope, Coalition."} }
	greetings[6] = {
		action="",
		--player="Your ship seems to be very powerful.",
		player= playerStatement.friendly.remark.ship[3], -- (could join ship[2] in table)
		alien={"Why thank you kind sir or madame.  Your ship doesn't."} }
	greetings[7] = {
		action="",
		--player="Your ship appears very irregular.",
		player= playerStatement.friendly.remark.ship[1], --(could join ship[2 & 3] in table)
		alien={"Why thank you very much.  It is my own custom model transport freighter outfitted with afterburners and state-of-the-art weaponry just ready to slice and dice and even make julian fries."} }
	greetings[8] = {
		action="",
		--player="We come in peace from Myrrdan, please trust me.",
		player= playerStatement.friendly.comment.trust[1], -- (could join trust[2])
		alien={"Oh we believe you, believe me that we believe you."} }
	greetings[9] = {
		action="",
		--player="There is no limit to what both our races can gain from mutual exchange.",
		player= playerStatement.friendly.comment.info_exchange[1], --answer needs this one.
		alien={"I would wholeheartedly agree, as long as to exchange is kept in our direction."} }
	greetings[10] = {
		action="",
		--player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		player= playerStatement.friendly.comment.trust[3], --answer needs this one :)
		alien={"How did you come up with a whopper like that one?"} }


elseif (plot_stage == 4) then

	greetings[1] = {
		action="",
		player="Greetings from the planet Myrrdan. We come in peace...usually.",
		alien={"Ho Humans of the [SHIPNAME]."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Welcome [SHIPNAME].  Coalition representative responding to your hail."} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Hi [CAPTAIN].  We of the Coalition know the [SHIPNAME]."} }
	greetings[4] = {
		action="",
		player="Dude, that is one odd ship you have there!",
		alien={"Why thank you very much.  It is my own custom model transport freighter outfitted with afterburners and state-of-the-art weaponry just ready to slice and dice and even make julian fries."} }
	greetings[5] = {
		action="",
		player="How's it going, umm ... aren't you Bar-zhon?",
		alien={"Nope, Coalition.  Welcome Humans of the [SHIPNAME]."} }
	greetings[6] = {
		action="",
		--player="Your ship seems to be very powerful.",
		player= playerStatement.friendly.remark.ship[3], -- (could join ship[2] in table)
		alien={"Why thank you kind sir or madame.  It's an honor.."} }
	greetings[7] = {
		action="",
		--player="Your ship appears very irregular.",
		player= playerStatement.friendly.remark.ship[1], --(could join ship[2 & 3] in table)
		alien={"Why thank you very much.  It is my own custom model transport freighter outfitted with afterburners and state-of-the-art weaponry just ready to slice and dice and even make julian fries better then any Thrynn black box."} }
	greetings[8] = {
		action="",
		--player="We come in peace from Myrrdan, please trust me.",
		player= playerStatement.friendly.comment.trust[1], -- (could join trust[2])
		alien={"Ya did prove yourself already.  Welcome [SHIPNAME]."} }
	greetings[9] = {
		action="",
		--player="There is no limit to what both our races can gain from mutual exchange.",
		player= playerStatement.friendly.comment.info_exchange[1], --answer needs this one.
		alien={"Good deal.  Just ask."} }
	greetings[10] = {
		action="",
		--player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		player= playerStatement.friendly.comment.trust[3], --answer needs this one :)
		alien={"Umm, sure."} }

end

end
------------------------------------------------------------------------
-- HOSTILE DIALOGUE ----------------------------------------------------
------------------------------------------------------------------------
function HostileDialogue()
	--add as many player greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack

if (plot_stage == 1) or (plot_stage == 2) or (plot_stage == 3) then

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
	greetings[6] = {
		action="attack",
		player="Your ship is over-embellished and weak.",
		alien={"Over embellished, maybe.  Weak, never.  Here, let me demonstrate."} }
	greetings[7] = {
		action="attack",
		player="What an ugly and worthless creature.",
		alien={"I'm sorry I can't seem to hear you.  Please boost your gain knob.  Nevermind, we'll just get closer and call you right back."} }
	greetings[8] = {
		action="attack",
		player="Your ship looks like a flying garbage scow.",
		alien={"Incredible!  How could I have not noticed this?  Unfortunately our cargo bays are empty of garbage.  If you would not mind, we would greatly appreciate it if you could scrap your ship for us to haul."} }


elseif (plot_stage == 4) then

	greetings[1] = {
		action="attack",
		player="This is captain [CAPTAIN] of the starship [SHIPNAME]. Identify yourselves immediately or be destroyed.",
		alien={"If you want a romp, we're happy to accommodate."} }
	greetings[2] = {
		action="attack",
		player="This is the starship [SHIPNAME]. We are heavily armed.",
		alien={"Ohh, feel free to demonstrate."}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME].",
		alien={"This powerful Coalition interceptor is also well-armed."} }
	greetings[4] = {
		action="attack",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"Why not just ask to tangle things up?  Here we are."} }
	greetings[5] = {
		action="attack",
		player="We require information. Comply or be destroyed.",
		alien={"We will not comply."} }
	greetings[6] = {
		action="attack",
		player="Your ship is over-embellished and weak.",
		alien={"Over embellished, maybe.  Weak, never.  Here, let me demonstrate."} }
	greetings[7] = {
		action="attack",
		player="What an ugly and worthless creature.",
		alien={"I'm sorry I can't seem to hear you.  Please boost your gain knob.  Nevermind, we'll just get closer and call you right back."} }
	greetings[8] = {
		action="attack",
		player="Your ship looks like a flying garbage scow.",
		alien={"Incredible!  How could I have not noticed this?  Unfortunately our cargo bays are empty of garbage.  If you would not mind, we would greatly appreciate it if you could scrap your ship for us to haul."} }

end

end

function StandardQuestions()

	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

if (plot_stage == 1) then

	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"The Coalition was created because the Bar-zhon empire survives on slave labor, more the fools they are to provide us with constant recruits.  From the millions of Sabion, Bx, and Transmodra, a few escape to join us every day.  None of them possess the coordination and flying skills of those of us of the Bar-zhon race, but at least here they are treated right."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Ehh?  We know a bit concerning a few of the races in the sector.  Are you interested in the Tafel, the Nyssian, the Minex, the Bar-zhon, the Elowan, the Thrynn, or other pirates?"}
	}
	questions[30000] = {
		action="jump", goto=31001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"The past?  Go bother the Nyssian about the past.  Feel free to also pester the Bar-zhon, they tell a decently honest history story even though it's slanted their way a bit."}
	}
	questions[40000] = {
		action="jump", goto=41001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"Fah!  I guess I could scoop the dirt on a few endurium planets." }
	}

elseif (plot_stage == 2) then -- virus plot state

	questions[10000] = {
		action="jump", goto=60000,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[20000] = {
		action="jump", goto=60000,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[30000] = {
		action="jump", goto=60000,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[40000] = {
		action="jump", goto=60000,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}
	questions[50000] = {
		action="jump", goto=60000,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"Your resources are badly needed in these dark days.  Surrender now or we will take what we need."}
	}


elseif (plot_stage == 3) then -- war plot state

	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"The Coalition was created because the Bar-zhon empire survives on slave labor, more the fools they are to provide us with constant recruits.  From the millions of Sabion, Bx, and Transmodra, a few escape to join us every day.  The Bar-zhon's occupied workers are currently being grabbed up through their Empire to staff warships that are no more than death traps. The plague is taking ship after ship if the Minex don't get them first."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Ehh?  We know a bit concerning a few of the races in the sector.  More of us now in contact to survive the current onslaught.  Are you interested in the Tafel, the Nyssian, the damnable Minex, the Bar-zhon, the Elowan, the Thrynn, or other pirates?"}
	}
	questions[30000] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"The past?  Go bother the Nyssian about the past.  Feel free to also pester the Bar-zhon.  We are more concerned with the Minex invasion at the moment."}
	}
	questions[40000] = {
		action="jump", goto=41001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"Fah!  I guess I could scoop the dirt on a few endurium planets.  Travel is difficult enough with all of these rampaging Minex about." }
	}


elseif (plot_stage == 4) then -- ancients plot state

	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"The Coalition was created because the Bar-zhon empire survives on slave labor.  more the fools they are to provide us with constant recruits.  Now that the Infected Ones have picked up rampaging where the Minex left off, just about all of the remaining sane independents are coming to us for protection."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Ehh?  We know a bit concerning a few of the races in the sector, the ones that are still sane and haven't joined the men rampaging ones yet. Are you interested in the Tafel, the Nyssian, the Minex, the Bar-zhon, the Elowan, the Thrynn, or other pirates?"}
	}
	questions[30000] = {
		action="jump", goto=31001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"The past?  Go bother the Nyssian about the past.  Feel free to also pester the Bar-zhon. We are more worried about the present with all of the mad ones getting organized and coordinating their attacks."}
	}
	questions[40000] = {
		action="jump", goto=41001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"Fah!  I guess I could scoop the dirt on a few endurium planets.  No one else is traveling with the growing number of infected ships out there." }
	}


end

if (plot_stage == 1) then

	questions[50000] = {
		action="branch",
		choices = {
			{ text="Coalition home base location",  goto=51000 },
			{ text="<Back>",  goto=1 }
		}
	}

	questions[51000] = {
		action="jump", goto=1, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="where your home base is", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Don't you be thinking that we'd be some simple dolts now, you hear?"}
	}
end

if (plot_stage == 1) then

	questions[11001] = {
		action="branch",
		choices = {
			{ text="Why rebel?",  goto=11000 },
			{ text="Sabion, Bx, and Transmodra", goto=12000 },
			{ text="Your species", goto=13000 },
			{ text="Objectives of the Coalition", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		playerFragment="about why members of the Bar-zhon race rebel against them", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Because our fabulous government is a military dictatorship, and if you're not born into a family of noble birth, you are shuffled into the technician or worker caste and  given orders the rest of your life.  You have no chance to take a role in either the government or the military.  Our rebellion is as much from a desire to live in freedom as it is for anything else." }
	}

elseif (plot_stage == 3) or (plot_stage == 4) then

	questions[11001] = {
		action="branch",
		choices = {
			{ text="Why rebel?",  goto=11000 },
			{ text="Sabion, Bx, and Transmodra", goto=12000 },
			{ text="How has the virus affected you guys?", goto=13000 },
			{ text="What about the Minex warfare?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about why members of the Bar-zhon race rebel against them", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Because our fabulous government is a military dictatorship.  Technological advances threatened to make everyone's lives too convenient and then who would need government?  First private ownership of ships were outlawed, then weeapons, then the banks were taken over, and finally they dictated everything." }
	}
	questions[11101] = {
		action="branch",
		choices = {
			{ text="Inquire about Bar-zhon news", goto=11110 },
			{ text="Hostile coalition ships", goto=11120 },
			{ text="<Back>", goto=11001 }
		}
	}
end

if (plot_stage == 3) then

	questions[11110] = {
		action="jump", goto=11101,
		player="[AUTO_REPEAT]",
		playerFragment="how the virus is affecting the Bar-zhon",
		alien={"The Bar-zhon government is getting what they deserve.  This infection has decimated their control.  More rats than ever before are leaving a sinking ship and swelling our ranks daily." }
	}
	questions[11120] = {
		action="jump", goto=11121,
		player="[AUTO_REPEAT]",
		playerFragment="why your ships were hostile until recently",
		alien={"Sorry about that small misunderstanding.  New race appears, mysterious plague appears soon afterwards?  Looks like the Minex were behind it the whole time, softening everyone up before the invasion. " }
	}
	questions[11121] = {
		action="jump", goto=11101,
		player="Didn't you say that you needed resources?", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Actually we did say that, didn't we?  I guess that onslaught of Minex changed the situation around a bit and living allies are a bit more valuable now." }
	}

elseif (plot_stage == 4) then

	questions[11110] = {
		action="jump", goto=11101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how the virus affected the Bar-zhon",
		alien={"The Bar-zhon society has mostly shut down.  Rebellion and madness are increasing in intensity in their society, leaving them paralyzed and unable to stop us." }
	}
	questions[11120] = {
		action="jump", goto=11121,
		player="[AUTO_REPEAT]",
		playerFragment="why your ships were hostile until recently",
		alien={"Sorry about that small misunderstanding.  New race appears, mysterious plague appears soon afterwards?  It appeared like the Minex were behind it at first but who knows now? " }
	}
	questions[11121] = {
		action="jump", goto=11101,
		player="[AUTO_REPEAT]",
		playerFragment="if you didn't say that you needed resources", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Actually we did say that, didn't we?  I guess that onslaught of Minex and Infected changed the situation around a bit and living allies are more valuable now." }
	}

end


if (plot_stage == 1) then
	questions[14000] = {
		action="jump", goto=14101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="on your goals",
		alien={"To survive by blending into the Bar-Zhon empire as best possible.  Our military and technological capacities have grown much further than the Bar-Zhon suspect.  Oh I don't care if you are a Bar-Zhon infiltrator or sympathizer, they already disbelieve their own reports and think we are only shortsighted revolutionaries." }
	}
	questions[14110] = {
		action="jump", goto=14101,
		player="[AUTO_REPEAT]",
		playerFragment="why your ships attack the Bar-zhon",
		alien={"Maintenance of the status quo.  If we stopped attacking they would get worried and to start to investigate.  If we declared all-out war there is no guarantee we would win.  Guerrilla attacks keep the mighty implacable and inflexible Bar-zhon Navy busy while we make progress elsewhere." }
	}
elseif (plot_stage == 3) then

	questions[14000] = {
		action="jump", goto=14101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the Minex warfare",
		alien={"These Minex buggers are causing a bit of a pinch.  They are chasing down and attacking isolated forces away from well defended worlds.  We're surviving primarily through our afterburners and are fortunate they seem to currently ignore planets.  We believe that the Minex homeworld to be located somewhere within the Pearl cluster.  Find a way to stop them, will ya?" }
	}
	questions[14110] = {
		action="jump", goto=14101,
		player="[AUTO_REPEAT]",
		playerFragment="why your ships attack the Bar-zhon",
		alien={"Our forces are currently being caught between the Bar-zhon Navy and the Minex demons.  Combat is inevitable when you run out of room." }
	}
elseif (plot_stage == 4) then

	questions[14000] = {
		action="jump", goto=14101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the current Minex warfare",
		alien={"Heard your race was responsible for putting the brakes on the Minex.  Shame they didn't have a cure tucked away somewhere." }
	}

	questions[14110] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		playerFragment="why your ships attack the Bar-zhon",
		alien={"We aren't attacking anyone.  With the Minex gone and the Bar-zhon paralyzed we are finally getting around to long overdue strategic positioning of our own." }
	}

end

if (plot_stage == 1) or (plot_stage == 3) or (plot_stage == 4) then
	questions[12000] = {
		action="jump", goto=12101,
		player="[AUTO_REPEAT]",
		playerFragment="about the Sabion, Bx, and Transmodra", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Losers of the last great war.  Their three home worlds were razed and made entirely uninhabitable, but radiation levels have finally started to drop to the point where those with decent equipment can explore their planets without kneeling over instantly from Delta radiation." }
	}


	questions[12101] = {
		action="branch",
		choices = {
			{ text="Home world of the Sabion",  goto=12110 },
			{ text="Home world of the Bx",  goto=12120 },
			{ text="Home world of the Transmodra",  goto=12130 },
			{ text="<Back>", goto=11001 }
		}
	}
end

if (plot_stage == 1) then
	questions[13000] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]", ftest= 3, -- aggravating
		playerFragment="about your biology",
		alien={"Kaak!  Go bother someone who cares!" }
	}
	questions[12110] = {
		action="jump", goto=12101, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="the location of the home world of the Sabion", fragmentTable=preQuestion.desire,
		alien={"Not so hasty grave robbers.  Don't expect to fool us with your platitudes either." }
	}
	questions[12120] = {
		action="jump", goto=12101, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="the location of the home world of the Bx", fragmentTable=preQuestion.desire,
		alien={"The superb ground pounders.  Their headquarters at 58N X 96E was nigh impregnable, unfortunately none of their low level dueling abilities helped them in space. However don't be expecting us to assist grave robbers loot their world." }
	}
	questions[12130] = {
		action="jump", goto=12101, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="the location of the home world of the Transmodra", fragmentTable=preQuestion.desire,
		alien={"The mighty industrialists, oh how they fell quickly to deception.  We will not be the ones opening their world to scavengers." }
	}

	questions[14101] = {
		action="branch",
		choices = {
			{ text="Why attack the Bar-zhon?",  goto=14110 },
			{ text="Not revolutionaries?",  goto=14120 },
			{ text="Leave Bar-zhon space",  goto=14130 },
			{ text="<Back>", goto=11001 }
		}
	}

	questions[14120] = {
		action="jump", goto=14101, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="what are you if not revolutionaries",
		alien={"<Sigh>   I told you already you slow alien.  We want to live in freedom, not die in war.  Beyond that our aims are our own." }
	}
	questions[14130] = {
		action="jump", goto=14101, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="why you don't simply leave Bar-zhon space",
		alien={"Commit a mass exodus of population under the noses of a hostile force?  Expose every single ship and resource we have to counterattack?  Simply ask to remove a slave population and see if the slave masters let them go willingly?  I assume you see the problems by now." }
	}
elseif (plot_stage == 3) or (plot_stage == 4) then

	questions[13000] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		playerFragment="about how the virus has affected you guys",
		alien={"Quite the death toll until recently, however the death and madness hit everyone hard.  Keeping everyone away from each other and in isolated lockdown has limited the madness and almost stopped the death toll for the short-term." }
	}

	questions[12110] = {
		action="jump", goto=12101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="on the location of the home world of the Sabion", fragmentTable=preQuestion.desire,
		alien={"Gorias 3 - 5,16.  Their primary research station was located at their temperate northern pole of the planet." }
	}
	questions[12120] = {
		action="jump", goto=12101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="the location of the home world of the Bx", fragmentTable=preQuestion.desire,
		alien={"Cian 3 - 25,205" }
	}
	questions[12130] = {
		action="jump", goto=12101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="the location of the home world of the Transmodra", fragmentTable=preQuestion.desire,
		alien={"Dian Cecht 4 - 35,139.  Bar-zhon scavengers are searching all these worlds.  Beat them to whatever they are after, ok?" }
	}

	questions[14101] = {
		action="branch",
		choices = {
			{ text="Attacking the Bar-zhon",  goto=14110 },
			{ text="Stopping the Minex",  goto=14120 },
			{ text="Minex motivations",  goto=14130 },
			{ text="<Back>", goto=11001 }
		}
	}

	questions[14120] = {
		action="jump", goto=14101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how to stop the Minex", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"If we knew how we would have already done so.  You're new around here and still fairly neutral.  Talk to everyone else and put some ideas together." }
	}
	questions[14130] = {
		action="jump", goto=14101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="why the Minex have declared war", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Nope, but probably it is that those guys are just way too isolated and paranoid.  Maybe with all their advanced tech they just decided they could wipe us out with their biologics and their warships." }
	}

end

if (plot_stage == 1) or (plot_stage == 3) or (plot_stage == 4) then
	questions[21001] = {
		action="branch",
		choices = {
			{ text="The Bar-zhon",  goto=21000 },
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
	questions[21000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Bar-zhon",
		alien={"Ahh, the Bar-zhon.  Our favorite pals.  Their warships are a mite tough, but not too difficult to take down.  Missile barrages from a decent distance take them out easily enough.  If your ship is fast enough and your pilot skilled enough, keep in mind that all of their ships have only missile weapons and no close quarter lasers." }
	}
	questions[22000] = {
		action="jump", goto=22100,
		player="[AUTO_REPEAT]",
		playerFragment="about the Tafel",
		alien={"The Tafel are interesting lot.  Quite adaptive they have proven to be yet strangely unable to see the benefits of profitable ventures.  If you ever get in a scrape with them make sure you never leave a damaged or disabled ship behind you - those suckers have a uncanny ability to repair their ships faster than your shields can regenerate." }
	}
	questions[22100] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		alien={"Their ships have recently become aggressive, refusing to establish contact with outsiders,  This is not a problem since their ships are very weak yet quite dangerous in large numbers.  Fortunately a single Tafel ship has weak shields and paper thin armor.  They blow quite nicely." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Nyssian",
		alien={"Arrogant Nyssian wanderers travel alone in their weird organic vessels.  There vessels always travel alone and have very weak weaponry.  They make good target practice with missiles if you want to shoot something more difficult than a rock, but their ships are made up virtually no salvageable material, and they're strangely effective shields take quite a beating, and no one has ever salvaged or reverse engineered them." }
	}

	questions[25000] = {
		action="jump", goto=25100,
		player="[AUTO_REPEAT]",
		playerFragment="about the Elowan",
		alien={"The Elowan be a strange folk.  Transmitted genetic memories make them impossible to tame, even when grown from seed.  Their little petty conflict with the Thrynn has undergone shifts in fortune many a time but currently they be on the losing side.  They have just recently developed some strange laser reflective armor which makes their ships highly resistant to laser damage." }
	}
	questions[25100] = {
		action="jump", goto=21002,
		player="[AUTO_REPEAT]",
		playerFragment="about the Thrynn",
		alien={"The Thrynn are a nasty sort.  Endless warfare has ground down their ships and resources but they are nasty and tenacious, and refuse to ever surrender or give up a fight.  Unless you're capable of fighting off an empire for the next hundred years it's best not to mess with them.  Their ships are well rounded, recently added missile technology balancing out their powerful laser batteries." }
	}
	questions[27000] = {
		action="jump", goto=21002,
		player="[AUTO_REPEAT]",
		playerFragment="about other pirates",
		alien={"General outlaws and pirates tend to inhabit the center of this sector.  Isn't this where you guys came from by the way?  Their equipment is patchy and badly worn, and they are not seriously a threat to anyone except the weakest merchant vessel." }
	}
end

if (plot_stage == 1) then

	questions[24000] = {
		action="jump", goto=24100,
		player="[AUTO_REPEAT]",
		playerFragment="about the Minex",
		alien={"The Minex are too much trouble, yet some fool always tries to go after them to prove themselves.  The few that return often salvage amazing technologies and are highly respected.   Of course ones so daft are often raided themselves when they return, just in case they happened to have some amazing technologies." }
	}

	questions[24100] = {
		action="jump", goto=21002,
		player="[AUTO_REPEAT]",
		alien={"If you try to tangle with those blokes, keep to your lasers.  Some blasted energy field diverts missile explosions away from them, making your missiles much less effective.  Their weapons pack a tremendous punch." }
	}

	questions[26000] = {
		action="jump", goto=21002,
		player="[AUTO_REPEAT]",
		playerFragment="about the Spemin.",
		alien={"Strange rambling blob-like creatures?  Don't bother.  Their tech is trash and they don't know anything.  Fun target practice however." }
	}


end

if (plot_stage == 1) or (plot_stage == 3) or (plot_stage == 4) then
	questions[31001] = {
		action="branch",
		choices = {
			{ text="Coalition Foundation",  goto=31002 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31002] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		playerFragment="how the coalition was formed", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The coalition is just the most recent name to what once was a political movement in Bar-zhon society.  Once the other political party took firm control of the military and the media, all of our leaders were systematically neutralized through blackmail, lies, and underhanded techniques.  For a while we were a subversive resistance movement but now all we seek is independence." }
	}
	questions[41001] = {
		action="branch",
		choices = {
			{ text="Ancients Themselves",  goto=41000 },
			{ text="Endurium Planets",  goto=42000 },
			{ text="<Back>",  goto=1 }
		}
	}

	questions[41000] = {
		action="jump", goto=41001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about the ancients themselves",
		alien={"I don't know or care.  Pester someone else."}
	}
	questions[42000] = {
		action="jump", goto=42001,
		player="[AUTO_REPEAT]",
		playerFragment="where endurium can be found",
		alien={"Try investigating Tafel space around Mag Rein1 - 101,15 or Aoi 4 - 167,16.  Bar-zhon space was strip-mined long ago.  Strangely enough, endurium is never located below ground, but I guess the ancients wanted us to find them easily enough!"}
	}
	questions[42001] = {
		action="jump", goto=41001,
		player="[AUTO_REPEAT]",
		alien={"Not that anyone has ever returned from there recently, but in the past there have been rumors that additional endurium rich planets can be found in the area of space past Thrynn territory."}
	}
end

if (plot_stage == 2) then


	questions[60000] = {
		action="branch",
		choices = {
			{ text="Yes, we surrender.",  goto=60001 },
			{ text="No, we will not surrender!",  goto=60002 }
		}
	}
	questions[60001] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		alien={"Lower your shields and disarm any weapons and hold perfectly still for a minute, will ya?"}
	}
	questions[60002] = {
		action="jump", goto=999, -- attack
		player="[AUTO_REPEAT]",
		alien={"Have at 'em mate!"}
	}

elseif (plot_stage == 3) then


	questions[50000] = {
		action="branch",
		choices = {
			{ text="Your home base",  goto=51000 },
			{ text="Current news",  goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}

	questions[51000] = {
		action="jump", goto=50000, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="where your home base is located", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Home base?  You think we are fools?  Our outposts, population, and resources are scattered everywhere, even outside the region of space we patrol."}
	}

	questions[52000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about current events",
		alien={"You see this shiny new ship?  Minex technology, freshly salvaged.  We'll be taking over this sector if the plague doesn't wipe us off first!"}
	}

	questions[60001] = {
		action="branch",
		choices = {
			{ text="The plague", goto=61000 },
			{ text="Plague problems", goto=62000 },
			{ text="Minex technology?", goto=63000 },
			{ text="Taking over", goto=64000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="[AUTO_REPEAT]",
		playerFragment="about the plague",
		alien={"Insane thing, ghastly Minex technology that acts as a mobile biological warfare laboratory.  New strains of viruses pop up everywhere customized to decimate planetary populations and turn the survivors into zombies.  Of course zombies that recover frequently for some reason mind that." }
	}
	questions[61001] = {
		action="jump", goto=60001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"Strangest things just don't add up.  Zombie-controlled ships turn on the Minex and leave other aliens alone.  Considering the technology that causes this plague is so advanced and unstoppable, why is it so ineffective at killing isolated populations and why does it give up control of its victims?" }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about the problems that plague is causing",
		alien={"Problems?  How about filling every densely populated city or station with corpses?   Survivors all undergo some cyclical madness and turn on each other at unpredictable times.  Fully outfitted ships just stop communicating and desert never to return." }
	}
	questions[63000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="how you are obtaining Minex technology", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Battlefield salvage is everywhere.  Minex ships do get destroyed occasionally seeing that they up and decided to attack every single other race in the sector simultaneously.  The mad ones are particularly good at leaving unsalvaged hulks everywhere." }
	}
	questions[64000] = {
		action="jump", goto=64001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how you are taking over the sector", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Future?  Ehh, we HAD long-term plans.  The simpleminded Tafel were expanding faster than any thought possible.  We have been piecing them out more and more of our technology as they expand their territory, and prepare ourselves to be their allies when they finally clash with the foolish Bar-zhon aristocrats.  Unfortunately just like the Minex, they seemed to have recently decided that all races are the enemy." }
	}
	questions[64001] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		alien={"Insane Minex fleets and unstoppable plagues sort of limit our goals to simple survival at the moment.  But the Minex tech we're salvaging is incredible!  Now if we could only survive long enough to refit our ships..." }
	}

elseif (plot_stage == 4) then


	questions[50000] = {
		action="branch",
		choices = {
			{ text="Your home base",  goto=51000 },
			{ text="Current news",  goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}

	questions[51000] = {
		action="jump", goto=50000, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="where your home base is located", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Home base?   Our system is distributed not centralized.  Our outposts, population, and resources are scattered everywhere, even outside the region of space we patrol."}
	}

	questions[52000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about current events",
		alien={"Good job with the Minex.  Now all we have to do is figure out how to survive this plague."}
	}

	questions[60001] = {
		action="branch",
		choices = {
			{ text="The plague", goto=61000 },
			{ text="Plague problems", goto=62000 },
			{ text="<Reveal Minex Secret>", goto=63000 },
			{ text="Obtain Ancient technology", goto=64000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="[AUTO_REPEAT]",
		playerFragment="about the plague",
		alien={"Insane thing, ghastly technology that acts as a mobile biological warfare laboratory.  New strains of viruses pop up everywhere customized to decimate planetary populations and turn the survivors into zombies.  Of course zombies that recover, but not as frequently as before." }
	}
	questions[61001] = {
		action="jump", goto=60001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"Strangest things just don't add up.  Zombie-controlled ships turn on the Minex and leave other aliens alone.  Considering the technology that causes this plague is so advanced and unstoppable, why is it so ineffective at killing isolated populations and why does it give up control of its victims?" }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about the problems that plague is causing",
		alien={"Problems?  How about filling every densely populated city or station with corpses?   Survivors all undergo some cyclical madness and turn on each other at unpredictable times.  Fully outfitted ships just stop communicating and they're crews desert never to return." }
	}
	questions[63000] = {
		action="jump", goto=60001, ftest= 3, -- aggravating
		player="The Minex think that the ancients have a cure.",
		alien={"Insanity from the insane.  Feel free to correct us next time you talk to an Ancient one." }
	}
	questions[64000] = {
		action="jump", goto=64001,
		player="[AUTO_REPEAT]",
		playerFragment="where we could obtain ancient technology", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Well we did acquire some positively strange device that is nearly indestructible.  Acts as a sonic disruptor and shatters endurium.  Can't be used in space and has no penetration.  Appears positively ancient however." }
	}
	questions[64001] = {
		action="jump", goto=60001, ftest=1,
		player="May we have the device?",
		alien={"No, but we will send you a holo-schematic." }
	}

end


end

function QuestDialogueinitial()

--[[
title="Military Mission #30:  We are seeking an afterburner.",
--]]
	questions[74000] = {
		action="jump", goto=74001,
		title="We are seeking an afterburner.",
		player="[AUTO_REPEAT]",
		introFragment= "Coalition vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have heard of your superlative propulsion technology.",
		playerFragment= "one of your afterburner devices.", fragmentTable= preQuestion.desire,
		alien={"I can smell an enforcer when I hear one.  Why should we deal with you and why should we give you our technology?" }
	}
	questions[74001] = {
		action="branch",
		choices = {
			{ title= "Moolah!", text="We are prepared to pay well- 20 cubic meters of Endurium.",  goto=74100 },
			{ title= "Diplomacy and Moolah!", text="We have no conflict with you. 12 cubic meters of Endurium, and our gratitude.",  goto=74200 },
			{ title= "Force and Persuasion!", text="If you do not agree to an exchange we will destroy you.",  goto=74300 },
			{ text="Nevermind, let me ask you about something else.", goto=1 }
		}
	}


	questions[74100] = {
		action="jump", goto=74001, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"We don't actually have any technologies like that.  Don't bother asking again." }
	}
	questions[74200] = {
		action="jump", goto=74001, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Your gratitude?  Count it, go broke. Eat it, go hungry. Seek it, go mad!" }
	}
	--[[
				if (player_Endurium < 12) then
					goto_question = 74205
				elseif (ATTITUDE <= 35) then
					goto_question = 74206
				else
					goto_question = 74207
					player_Endurium= player_Endurium -12
					artifact20= artifact20 +1
				end
	]]--

	questions[74205] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Also you might just want to count your promises before you make them, you pauper!" }
	}
	questions[74206] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Besides you guys are not exactly friendly to begin with." }
	}
	questions[74207] = {
		action="jump", goto=74201,
		player="[AUTO_REPEAT]",
		alien={"Okay, well maybe I could give you a little something.  You did not obtain this from me, you ran across this and salvaged it, okay?" }
	}
	questions[74200] = {
		action="jump", goto=74201, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Okay, well maybe I could give you a little something.  You did not obtain this from me, you ran across this and salvaged it, okay?" }
	}

	questions[74201] = {
		action="jump", goto=1, ftest= 2, -- insightful
		player="Been a pleasure dealing with you.",
		alien={"I would suggest you treat it well and ensure it doesn't get lost." }
	}


	questions[74300] = {
		action="jump", goto=74301,
		player="[AUTO_REPEAT]",
		alien={"Ha!  Good luck attempting that!  Let me give you a chance to try!" }
	}
	questions[74301] = {
		action="jump", goto=999, -- attack
		player="We do not plan on being defeated.",
		alien={"<Silence>" }
	}

--[[
title="Scientific Mission #35:  locating an exotic small planet with a massive gravity field.",
--]]

	questions[89000] = {
		action="jump", goto=89001,
		player="Help decoding fragmentary data",
		introFragment= "Coalition vessel.  This is Captain [CAPTAIN] of the research vessel [SHIPNAME].  We have need of information you may have.",
		playerFragment="information to help decode this fragmentary data", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"What's it supposed to be?" }
	}
	questions[89001] = {
		action="jump", goto=89002,
		player="The location of a planet containing exotic particles.",
		alien={"What's in it for me?" }
	}
	questions[89002] = {
		action="jump", goto=1,
		player="Umm, a very unique planet likely to contain treasure.",
		alien={"Transmit the data now.....  Wow this data stream is really trashed.....  The planet itself matches up descriptions of acidic planets but I cannot tell you anything else about its location.  " }
	}

--[[
title="Freelance Mission #29:  Hunt for the Orb - before obtaining it
--]]

		questions[93000] = {
		action="jump", goto=93001,
		player="The Bar-zhon orb",
		introFragment= "Coalition vessel.  This is Captain [CAPTAIN].",
		playerFragment="a Bar-zhon orb", fragmentTable= preQuestion.desire,
		alien={"Now why would someone like me be aware of a fine artifact like that?" }
	}
	questions[93001] = {
		action="branch",
		choices = {
			{ title= "Please?", text="We are friends, aren't we?",  goto=93100 },
			{ title= "5 Endurium", text="Maybe you could use some extra resources (5 endurium)",  goto=93200 },
			{ title= "Demand!", text="You will tell me what you know immediately.",  goto=93300 },
			{ title= "Never mind", text="Forget this.  I'm not going to bother. ", goto=1 }
		}
	}
	questions[93100] = {
		action="jump", goto=1, ftest= 1,
-- if attitude > 60 then 		goto=93105 	else 	goto=93106
		player="[AUTO_REPEAT]",
		alien={"What is this?  Pleading and scraping?" }
	}
	questions[93105] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"I wouldn't say as much as good friends, but I'd rather you look into this then certain others, if you know what I mean.  One of our contacts ran across information about an unusual communication artifact that was stashed on a planet known as Lazerarp at the north pole of the planet.  Now if we knew where that planet was, we would obtain the device ourselves.  Unfortunately our sources have turned up nothing." }
	}
	questions[93106] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		alien={"I can't really say I'd ever be affected by such stupidity.  Get Lost!" }
	}
	questions[93200] = {
		--endurium - 5
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
			alien={"That is quite generous of you.  One of our contacts overheard information about an unusual communication artifact that was stashed on a planet known as Lazerarp at the north pole of the planet.  Now if we knew where that planet was, we would obtain the device ourselves." }
	}
	questions[93300] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		alien={"You think that I am worried about some sort of upstart such as yourself and your race?   I have principles and am not worried about your type.  Keep that in mind if you survive." }
	}
--[[
title="Freelance Mission #29:  Hunt for the Orb - after obtaining it
--]]


	questions[93500] = {
		action="jump", goto=93501,
		player="Can you tell us about...",
		alien={"Our scanners indicate that you are carrying the whining orb.  If you are willing to sell this to me I am ready to transport 15 cubic meters of endurium in exchange." }
	}
	questions[93501] = {
		action="branch",
		choices = {
			{ title= "15 endurium", text="Yes, I'll sell it for 15 endurium",  goto=93600 },
			{ text="No.",  goto=1 },
			{ title= "Suggest another offer", text="Are you able to give us anything else for it?",  goto=93700 },
		}
	}
	questions[93600] = {
		--artifact16 = 0,
		--endurium + 15,
		--active_quest = active_quest + 1,
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Very nice device this is.  Good doing business with you.  (Mission Completed)" }
	}
	questions[93700] = {
		--artifact16 = 0,
		--ship_laser_class = ship_laser_class + 1,
		--active_quest = active_quest + 1,
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"I'm sending over my chief engineer to take a look at your weapon systems.  We might just find a way to upgrade your lasers in exchange for this device.  (Mission Completed)" }
	}

--[[
title="Freelance Mission #30:  the amazing artifact - before obtaining the spiral lens
--]]


	questions[94000] = {
		action="jump", goto=94001,  ftest= 2, -- insightful
		player="Do you have a Minex silver gadget?",
		introFragment= "Coalition vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have heard of your reputation.",
		playerFragment= "a Minex silver gadget.", fragmentTable= preQuestion.desire,
		alien={"Very astute of your people to discover this.  I take it you are interested in buying it?" }
	}
	questions[94001] = {
		action="jump", goto=94002,
		player="Yes.",
		alien={"It so happens that I have access to the artifact in question.  It is very advanced technology.  If you were to bring us the spiral lens device that the Thrynn are interested in I could be persuaded to make an exchange." }
	}
	questions[94002] = {
		action="branch",
		choices = {
			{ title= "Moolah!", 	text="Would you take resources, say like 10 endurium?",  goto=94100 },
			{ title= "Where is it?", 	text="Where could I find the spiral lens?",  goto=94200 },
			{ title= "The spiral lens has been already given away.", 	text="I already turned over the lens to the Thrynn.",  goto=94300 },
			{ text="Let me ask about something else for now.", goto=1 }
		}
	}
	questions[94100] = {
		action="jump", goto=94002,
		player="[AUTO_REPEAT]",
		alien={"Such minor amounts of resources are not worth bothering with.  Bring us this technology or forget it." }
	}
	questions[94200] = {
		action="jump", goto=94002,
		player="[AUTO_REPEAT]",
			alien={"Ask the Thrynn.  We heard rumors that they tracked down its location but have not bothered to get it themselves.  Foolish for them." }
	}
	questions[94300] = {
		action="jump", goto=94002,
		player="[AUTO_REPEAT]",
		alien={"If this is true then you can obtain your own Minex technology the hard way. " }
	}

--[[
title="Freelance Mission #30:  the amazing artifact - after obtaining the spiral lens
--]]


	questions[94500] = {
		action="jump", goto=94501,
		title= "We have a spiral lens",
		player="I have a spiral lens in exchange for a Minex silver gadget.",
		alien={"I am prepared to send you our the Minex silver gadget." }
	}

	questions[94501] = {
		--artifact23 = 1,
		--artifact13 = 0,
		action="jump", goto=1, ftest= 1,
		player="Transmitting unit now.",
		alien={"I am transporting the silver gadget in exchange." }
	}

--[[
title="Freelance Mission #31:  Obtain a Coalition Afterburner
--]]


	questions[95000] = {
		action="jump", goto=95001,
		player="We are seeking an afterburner",
		introFragment= "Coalition vessel.  This is Captain [CAPTAIN].  We have heard of one of your recent innovations.",
		playerFragment= "one of your afterburners", fragmentTable= preQuestion.desire,
		alien={"You would want us to give up our great new technological advantage?  This new technology is secret and proprietary.  I could never turn it over to an alien like yourself." }
	}
	questions[95001] = {
		action="branch",
		choices = {
			{ title= "Demand", text="Turn over a sample or you're not going to survive.",  goto=95100 },
			{ title= "10 endurium", text="10 endurium for your afterburner.",  goto=95200 },
			{ title= "Secret deal", text="I Understood. We never met. I happened to be ejecting 10 endurium",  goto=95300 },
			{ text="Nevermind, let me ask you about something else.", goto=1 }
		}
	}
	questions[95100] = {
		action="jump", goto=999,
		player="[AUTO_REPEAT]",
		alien={"You are not likely to survive.  Let me demonstrate our afterburner's capacities for you." }
	}

	questions[95200] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"I'm sorry, I can't hear you.  If I did hear you, it sounded like you were trying to purchase restricted technology, which I am not allowed to do." }
	}

	questions[95300] = {
		action="jump", goto=95304, ftest= 1,
		-- if attitude is greater than 70, go to 95305, or else go to 95306
		--player_Endurium= player_Endurium -10
		--attitude = attitude + 10
		player="[AUTO_REPEAT]",
		alien={"Thanks for your contribution to our war fund.  Most generous of you." }
	}
	questions[95305] = {
		action="jump", goto=1, ftest= 1,
		--artifact20 = artifact20 + 1,
		player="Any spare parts? We seem to be having engine problems.",
		alien={"Of course.  Always happy to assist generous friends.  Transporting some extra components to you now. " }
	}

	questions[95306] = {
		action="jump", goto=997,
		player="Any spare parts? We seem to be having engine problems.",
		alien={"Nothing unfortunately available today.  Thanks for your contribution, we have got to get running along now. Things to do, sentients to take care of." }
	}


--[[
title="Freelance Mission #33:  Erratic Energy Devices
--]]

	questions[97000] = {
		action="jump", goto=97001,
		player="Can you tell us about...",
		alien={"I'm detecting that you have on board an erratic energy device.  Would you be interested in selling it?" }
	}

	questions[97001] = {
		action="branch",
		choices = {
			{ title= "40 Endurium", text="I'll sell it for 40 cubic meters of endurium.",  goto=97100 }, --	if attitude > 60 then 	goto=97100		else 		goto=97101
			{ title= "Shielding Tech", text="Could you enhance our ships defensive technology?",  goto=97200 },
			{ title= "Weapon Tech", text="Could you enhance our ships offensive technology?",  goto=97300 },
			{ text="No, our scientists want this device themselves ", goto=1 }
		}
	}
	questions[97100] = {
		--artifact17 = 0,
		--endurium +40
		--active_quest = active_quest + 1,
		action="jump", goto=997, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Deal!  You realize that ..umm.. never mind, I have some urgent business elsewhere.  (Mission Completed)" }
	}
	questions[97101] = {
		action="jump", goto=997, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Get lost!" }
	}
	questions[97200] = {
		--artifact17 = 0,
		--ship_shield_class = ship_shield_class + 1,
		--active_quest = active_quest + 1,
		action="jump", goto=997, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Deal!  I'm transmitting data on our latest shielding enhancements.  Your engineer should be able to make use of this data. You realize that ..umm.. never mind, I have some urgent business elsewhere." }
	}
	questions[97205] = {
		action="jump", goto=1, ftest= 1,
		player="Transporting device now.",
		alien={"I'm sending over my chief engineer to take a look at your shielding systems.  Send him back when he's done, eh?  (Mission Completed)" }
	}

	questions[97206] = {
		action="jump", goto=1, ftest= 1,
		player="Transporting device now.",
		alien={"Our chief engineer can't make heads or tails of your mess. Sorry Spud, can't help you out.  (Mission Completed)" }
	}


	questions[97300] = {
		--artifact17 = 0,
		--ship_laser_class = ship_laser_class + 1,
		--active_quest = active_quest + 1,
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"We might just find a way to upgrade your lasers in exchange for this device.  Send it to us first." }
	}
	questions[97305] = {
		action="jump", goto=1, ftest= 1,
		player="Transporting device now.",
		alien={"I'm sending over my chief engineer to take a look at your weapon systems.  Send her back when she's done, eh?  (Mission Completed)" }
	}

	questions[97306] = {
		action="jump", goto=1, ftest= 1,
		player="Transporting device now.",
		alien={"Our chief engineer can't make heads or tails of your mess. Sorry Spud, can't help you out.  (Mission Completed)" }
	}

--[[
title="Freelance Mission #34:  Pawn off Unusual Artistic Containers
--]]

	questions[98000] = {
		action="jump", goto=1,
		player="Pawn off Artistic Containers",
		introFragment= "Coalition vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].",

		playerFragment="something in exchange for these incredibly old artistic containers", fragmentTable= preQuestion.desire,
		alien={"I can't really say that I would be interested in spending resources on worthless pottery." }
	}

--[[
title="Freelance Mission #35:  Resolving the Bar-zhon Elowan conflict - Initial"
--]]

	questions[99000] = {
		action="jump", goto=1,
		player="Tell us about the Elowan Bar-zhon conflict",
		playerFragment="about the Elowan Bar-zhon conflict",
		alien={"That mess ehh?  Couldn't tell you much about it other than the obvious.  The imperialists are claiming another world not their own." }
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
		alien={"You would risk entering our space in order to pursue these criminals? Very well, for 10 units of fuel I will give you important information on both the Diligent and the Excelsior." }
	}
	questions[77001] = {
		action="branch",
		choices = {
			{ title="Yes", text="Ok, here are 10 cubic meters of Endurium.",  goto=77100 },
			{ title="Counteroffer", text="We can only spare 7 cubic meters of Endurium.",  goto=77200 },
			{ title="Threaten", text="If you do not agree to tell us we will destroy you.",  goto=77300 },
			{ text="Nevermind, let me ask you about something else.", goto=1 }
		}
	}
	questions[77100] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Good call." }
	}
	questions[77105] = {
		action="jump", goto=999,  ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"You might just want to count your promises before you make them, you pauper!" }
	}
	questions[77106] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		alien={"My information is this: both vessels are honorary members of the Coalition in good standing. Pass this on to your superiors: any encroachment on our space in order to track these vessels constitutes an act of war. You are allowed to leave but do not return." }
	}
	questions[77200] = {
		action="jump", goto=77001,  ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"I can't hear you..." }
	}
	questions[77300] = {
		action="jump", goto=999,  ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Ha!  Good luck attempting that!  Let me give you a chance to try!" }
	}

--[[
title="Mission #38:  Collecting Genetic Samples" -- Sabion, no other data collected
--]]
	questions[78000] = {
		action="jump", goto=78001,
		title="Genetic Samples",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are working with a team of medical researchers attempting to find a cure for this plague.",
		playerFragment="samples of genetic material from members of your race", fragmentTable=preQuestion.desire,
		alien={"Sure we could provide something for you but what's in it for us?" }
	}

	questions[78001] = {
		action="branch",
		choices = {
			{ title="The Cure", text="Our promise that you'll receive any benefits from this joint research.", goto=78100 },
			{ title="Moolah", text="20 units of energy crystals.", goto=78200 },
			{ text="Nevermind for now",  goto=1 },
		}
	}
	questions[78100] = {
		action="jump", goto=78001,  ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"What would that be worth?  You'd give out any cure for free and if not, we would just obtain it elsewhere." }
	}
	questions[78200] = {
		action="jump", goto=1,  ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Baah!  Bring us the reactor core from the city Talong (133S X 9E) on the planet Iuchar II (215, 44) and then we will deal!" }
	}

--[[
title="Mission #38:  Collecting Genetic Samples" -- Fusion reactor in exchange for Sabion genetic data
--]]

	questions[78250] = {
		action="jump", goto=78301,  ftest= 1,
		player="We have the Bar-Zhon reactor.",
		alien={"Well good for you, why should I care?  Ohh, The Jackal promised you some genetic data in exchange for blacking out a Bar-zhon capital city. Very well.  Here are sequences from 1000 members of the Sabionites." }
	}
--[[
title="Mission #38:  Collecting Genetic Samples" -- Thrynn data in exchange for BX genetic data, no Transmodra data
--]]

	questions[78750] = {
		action="jump", goto=78751,  ftest= 1,
		player="We have the Thrynn data.",
		alien={"Well good for you, why should I care?  Ohh, The Dredger promised you some genetic data in exchange for tweaking out the lizards of it. Very well.  Here are sequences from a couple dozen BX warriors." }
	}
	questions[78751] = {
		action="jump", goto=1,  ftest= 1,
		player="What about Transmodra data?",
		alien={"Sheesh!  My Transmodra officers are quite insistent that we provide this data to you.  No charge." }
	}
--[[
title="Mission #38:  Collecting Genetic Samples" -- Thrynn data in exchange for BX genetic data, Transmodra data already acquired
--]]

	questions[78850] = {
		action="jump", goto=1,  ftest= 1,
		player="We have the Thrynn data.",
		alien={"Well good for you, why should I care?  Ohh, The Dredger promised you some genetic data in exchange for tweaking out the lizards of it. Very well.  Here are sequences from a couple dozen BX warriors." }
	}


--[[
title="Mission #38:  Collecting Genetic Samples" -- Sabion collected, need BX
--]]
	questions[78300] = {
		action="jump", goto=78301,
		title="Genetic Samples",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are working with a team of medical researchers attempting to find a cure for this plague.",
		playerFragment="samples of genetic material from members of your race", fragmentTable=preQuestion.desire,
		alien={"Yeah, we heard you were doing altruistic work for those schizophrenic plant things." }
	}

	questions[78301] = {
		action="branch",
		choices = {
			{ title="BX Data", text="What do you want in exchange for the BX genetic data?", goto=78310 },
			{ title="Transmodra Data", text="What do you want in exchange for the Transmodra genetic data?", goto=78320 },
			{ text="Nevermind for now",  goto=1 },
		}
	}
	questions[78310] = {
		action="jump", goto=78301,
		player="[AUTO_REPEAT]",
		alien={"Bring us some of the Thrynn genetic material. You are collecting from all races, right?" }
	}
	questions[78320] = {
		action="jump", goto=997,  ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Sheesh!  My Transmodra officers are quite insistent that we provide this data to you.  No charge.  We will talk to you later." }
	}

--[[
title="Mission #38:  Collecting Genetic Samples" -- Sabion and BX collected, need Transmodra
--]]
	questions[78500] = {
		action="jump", goto=78501,
		title="Genetic Samples",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are working with a team of medical researchers attempting to find a cure for this plague.",
		playerFragment="samples of genetic material from members of your race", fragmentTable=preQuestion.desire,
		alien={"Sure we could provide something for you but what's in it for us?" }
	}

	questions[78501] = {
		action="branch",
		choices = {
			{ title="Transmodra Data", text="What do you want in exchange for the Transmodra genetic data?", goto=78320 },
			{ title="Nevermind", text="Nevermind for now", goto=1 }
		}
	}

--[[
title="Mission #42:  Tracking the Laytonites -- no Bar-zhon data
--]]

	questions[82000] = {
		action="jump", goto=999, -- attack the player
		title="Tracking the Laytonites",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are here as representatives of the Myrrdan government seeking a small fleet of rebel Myrrdan terrorists.",
		playerFragment="any information that could help us find them", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"I don't know anything about these Laytonite friends of yours, but I do know where one particularly vulnerable, unsupported Myrrdan ship is located." }
	}



--[[
title="Mission #42:  Tracking the Laytonites -- Bar-zhon data
--]]

	questions[82500] = {
		action="jump", goto=82501,
		title="Tracking the Laytonites",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We know that a group of rebel Myrrdan terrorists is within your territory.",
		playerFragment="about any contact your people have made with them",
		alien={"I have absolutely no information about any such contact.  Why do you make such a statement?" }
	}

	questions[82501] = {
		action="branch",
		choices = {
			{ title= "Evidence", text="We have sensor data showing that these terrorists left Bar-zhon territory and entered yours.",  goto=82100 },
			{ title= "Bribe", text="Let me offer something for this information",  goto=82301 },
			{ title= "Agreement", text="I Understood.  I'm hoping that we can come to some sort of agreement. Information about this group's whereabouts would be valuable to us.",  goto=82200 },
			{ text="Nevermind, let me ask you about something else.", goto=1 }
		}
	}
	questions[82100] = {
		action="jump", goto=82501,
		player="[AUTO_REPEAT]",
		alien={"Ha!  The data you transmitted is quite garbled and worthless and inconclusive even if I cared.  Such a group was never seen by us." }
	}
	questions[82200] = {
		action="jump", goto=82501,
		player="[AUTO_REPEAT]",
		alien={"So something is valuable to you.  This does not necessarily make it valuable to us. Valuable information is somewhat ... difficult for us to retrieve sometimes." }
	}
	questions[82301] = {
		action="branch",
		choices = {
			{ title= "5 endurium", text="5 endurium for any information on their location.",  goto=82310 },
			{ title= "10 endurium", text="10 endurium for any information on their location.",  goto=82320 },
			{ title= "25 endurium", text="25 endurium for any information on their location.",  goto=82330 },
			{ text="<Back>", goto=82501 }
		}
	}

	questions[82310] = {
		action="jump", goto=82301,
		player="[AUTO_REPEAT]",
		alien={"Such a paltry sum is not worth our attention." }
	}
	questions[82320] = {
		action="jump", goto=82400, ftest= 1, -- remove 10 Endurium
		player="[AUTO_REPEAT]",
		alien={"Indeed one of our sister ships ran across your lost friends, the Laytonites.  They were short on fuel and were overtaxed and underequipped for their journey if you catch my meaning.  They received upgrades to their engines in exchange for truly a massive collection of raw ore." }
	}
	questions[82330] = {
		action="jump", goto=82400, ftest= 1, -- remove 25 Endurium
		player="[AUTO_REPEAT]",
		alien={"How generous!  Indeed one of our sister ships ran across your Laytonites.  They were short on fuel and were overtaxed and underequipped for their journey if you catch my meaning.  They received upgrades to their engines in exchange for truly a massive collection of raw ore." }
	}
	questions[82340] = {
		action="jump", goto=999, -- player does not have enough Endurium, attack the player
		player="[AUTO_REPEAT]",
		alien={"Don't attempt to fool us, you berk!  Count your bribe before you offer it next time!" }
	}
	questions[82400] = {
		action="jump", goto=997, ftest= 1, --remove artifact254: Bar-zhon Pirate sensor data
		title="Location?",
		player="[AUTO_REPEAT]",
		playerFragment="what about their current location",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Don't be impatient!  They attempted to rob us after our transaction was completed, or I would not be even telling you this.  We destroyed a few of their interceptors but they fled and we discreetly traced them to the fifth planet of the Oende system. (134, 30)  There is no profit in revenge and even less profit in fighting our way through insane Tafel hordes.  Have fun tracking them down."}
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
		alien={"Ahoy fellow mates!  You ain't seen the whirlwind yet, but if you'd transport your undamaged equipment over to us, I'll save you the pain of that encounter." }
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
		alien={"Quite a scam ehh?  The so called visionary leading a drugged out group peddling this 'cure' stated that he had visions of some malevolent consciousness trying to manipulate us all by sending out telepathic commands.  Their idea was that this cure scrambled the heads of anyone taking it so they could not receive these commands." }
	}

	questions[85100] = {
		action="jump", goto=1,
		player="Do you know where is this group is?",
		alien={"Can't say that I do.  They camped out in our territory for months, but left towards Bar-zhon territory only a few weeks ago.  Can't say that they will be missed." }
	}

--[[
title="Mission #45:  Alien Healthcare Scam - sample
--]]

	questions[85500] = {
		action="jump", goto=1,  ftest= 1, -- transport drugs sample to alien
		title="Plague Treatment",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are investigating this medical treatment drug that minimizes or stops the periods of madness caused by the plague.  We are transporting over the information needed to synthesize it.",
		playerFragment="about it",
		alien={"Can't say that any of my crew want to test it and since animals are not affected, you'll need volunteers. Seek out that that race of doctors, the Eowar.  Ohh yeah, the Elowan. They should be able to analyze this stuff if anyone can." }
	}





end

function QuestDialoguewar()


--[[
title="Mission #48:  Intelligence Collaboration - no power core
--]]

	questions[78000] = {
		action="jump", goto=78001,
		title="Intelligence Collaboration",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME]. We have compiled a datacube of technological, tactical, and strategic observations of the Minex war machine.  In the interests of all of our survival, we are willing to share this information freely.",
		playerFragment="a collection of similar observations by your people", fragmentTable=preQuestion.desire,
		alien={"Just in case you haven't guessed, we are not particularly interested in fighting off fleets of superships.  Our ship's size, maneuverability, and acceleration keep us out of fights we don't want to be in.  I have observed their ships fighting the Bar-zhon and can tell you that you do not want to mess with them." }
	}
	questions[78001] = {
		action="jump", goto=78002,
		player="Can you tell us any specifics about Minex ships?",
		alien={"They are almost completely immune to missiles, and lasers are partially deflected from their ablative armor.  Many of their ships continue patrolling even after being heavily damaged so you may occasionally take one of them out quickly.  Beyond that they are fast, maneuverable, their missiles are unmatched by any race, and their lasers are only slightly less effective. Nasty customers." }
	}
	questions[78001] = {
		action="jump", goto=1,				
		player="Have you ever salvaged a Minex power core?",
		alien={"Intact?  No.  Those would likely be snapped up right quick but feel free to ask around." }
	}

--[[
title="Mission #48:  Intelligence Collaboration - obtained Powercore already
--]]

	questions[78500] = {
		action="jump", goto=78501,
		title="Intelligence Collaboration",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME]. We have compiled a datacube of technological, tactical, and strategic observations of the Minex war machine.  In the interests of all of our survival, we are willing to share this information freely.",
		playerFragment="a collection of similar observations by your people", fragmentTable=preQuestion.desire,
		alien={"Just in case you haven't guessed, we are not particularly interested in fighting of fleets of superships.  Our ship's size, maneuverability, and acceleration keep us out of fights we don't want to be in.  I have observed their ships fighting the Bar-zhon and can tell you that you do not want to mess with them." }
	}
	questions[78501] = {
		action="jump", goto=1,
		player="Can you tell us any specifics about Minex ships?",
		alien={"They are almost completely immune to missiles, and lasers are partially deflected from their ablative armor.  Many of their ships continue patrolling even after being heavily damaged so you may occasionally take one of them out quickly.  Beyond that they are fast, maneuverable, their missiles are unmatched by any race, and their lasers are only slightly less effective.  Nasty customers." }
	}


--[[
title="Mission #49:  Unrest - no flight recorders
--]]

	questions[79000] = {
		action="jump", goto=79001,
		title="Unrest",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have heard that your ships have been raiding the Thrynn and Elowan.  We are here to determine the truth behind such reports and to offer our services as mediators to any disputes.",
		playerFragment="about the situation",
		alien={"Are you nuts?  We have trouble enough avoiding Minex patrols and protecting and evacuating fragile outposts. We are also very busy collecting salvage and deciphering tech from both Minex and Bar-zhon warships.  Because of the war we are overextended within our own territory.  We can't afford to be antagonistic towards any outside party." }
	}
	questions[79001] = {
		action="jump", goto=79002,
		title="The Elowan and Thrynn say otherwise.",
		player="[AUTO_REPEAT]",
		playerFragment="why we should believe you?  The Elowan and Thrynn are under attack", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The crazy Minex are attacking all races including us.  Why would we help them by hurting potential allies?  We are already very busy with both the Minex and the Bar-zhon.  The Elowan and Thrynn have declared an end to their feud and are bunkering in tightly fortified positions.  Does that sound vulnerable to you?" }
	}
	questions[79002] = {
		action="jump", goto=1,
		title="are you sure?",
		player="[AUTO_REPEAT]",
		playerFragment="that you have no clue who's responsible", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Of course we have no clue - extended hyperspace travel is very dangerous right now.  It is probably some Minex false visual technology or some other trick." }
	}


--[[
title="Mission #49:  Unrest - at least one flight recorder
--]]

	questions[79500] = {
		action="jump", goto=79501,
		title="Unrest",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have conclusive evidence from this flight recorder that the coalition is reading the Elowan and Thrynn!",
		playerFragment="how you can deny this flight recorder evidence", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Very simple. The ships appearing to be Coalition vessels were lost months ago. Either the plague or the Minex are thought responsible.  Note the poor flying skills, the insanity of fighting to the death without any interest in preserving ships or lives, and the ineffective way the afterburners were utilized. The coalition ships in that video simply charged towards their opponents and stopped right in front of them to exchange fire.  We would never do that." }
	}
	questions[79501] = {
		action="jump", goto=997,
		player="<more>",
		alien={"We recognize the geometry of some of the stellar constellations shown in that sensor data.  That is Spemin territory.  We would not be raiding enemy ships, even if they were enemies, within Spemin territory where other races could observe our actions. Seek out the Spemin and they should be able to confirm this or reveal the guilty party." }
	}

--[[
title="Mission #53:  Tactical Coordination
--]]


	questions[83000] = {
		action="jump", goto=1,  ftest= 1, -- artifact340 Coalition response
		title="Tactical Coordination",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are working with the Bar-zhon to discover fleet combinations that would be most effective in countering the Minex onslaught.",
		playerFragment="if you would commit a few ships to tactical exercises being conducted for this purpose", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Are you completely daft?   This Coalition has no empire to defend. We are nothing but a collection of freedom seeking individuals under oppression. Now if the Bar-zhon were willing to enact certain reforms we would fight for our freedom but it is hard to fight for something you do not have!" }
	}

end

function QuestDialogueancients()

--[[
title="Mission #61:  Another Ruins Search
--]]

	questions[81000] = {
		action="jump", goto=81001, ftest= 1, -- give the player artifact375 Society of Ancient Studies Seal
		title="Another Ruins Search",
		player="[AUTO_REPEAT]",
		introFragment="Greetings. This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have been searching research sites on the worlds of the 3 Imperialists.",
		playerFragment="about the Society of Ancient Studies",
		alien={"Idealists do not survive long in slave labor camps. The last remnants of the society disappeared centuries ago.  They did carry around these trinkets, but nothing else about them survived." }
	}
	questions[81001] = {
		action="jump", goto=1,
		title="What is this engraving?",
		player="[AUTO_REPEAT]",
		playerFragment="what the engraving 'In search of the Crystal Pearl' means", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Hey, your guess is as good as mine. Run it by your eggheads at home if you really care." }
	}


end

function OtherDialogue()


--[[
title=" Universal exchanges"
--]]
	questions[500] = {
		action="jump", goto=501,  ftest= 2, -- insightful
		player="Can you tell me about...",
		alien={"Hey mate!  You ran across a Thrynn Battle Machine?  I'll buy it for ten units of endurium." }
	}
	questions[501] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=510 },
			{ text="No.",  goto=520 },
		}
	}
	questions[510] = {
		--endurium = endurium + 10,
		--artifact14 = 0,
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Transfering." }
	}
	questions[520] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Very well. " }
	}


	-- attack the player because attitude is too low
	questions[910] = {
		action="jump", goto=999,
		player="What can you tell us about...",
		alien={"We are friends.  We are such good friends.  Let me demonstrate how we treat such good friends." }
	}
	-- hostile termination question
	questions[920] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"Beat it scum.  You're not worth the energy necessary to blast you to pieces." }
	}
	-- neutral termination question
	questions[930] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"I've got more things to do than to sit around chatting.  See you later." }
	}
	-- friendly termination question
	questions[940] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"Nice chat [CAPTAIN] and good hunting.  We must be off." }
	}
		questions[997] = {
		action="jump", ftest=4, -- Generic terminate question
		player="placeholder",
		alien={"" }
	}
		questions[998] = {
		action="jump", goto=999,
		player="<Open Communication>", -- Generic I do not want to talk question
		playerFragment= "...",
		alien={"Get lost!" }
	}
		questions[999] = {
		action="jump", ftest=5, -- Generic attack question
		player="placeholder",
		alien={"" }
	}
end



--[[ -------------------------------------------------------------------
--Randomized ship characteristics, 1st pass:
----------------------------------------------------------------------]]
function GenerateShips()

    -- COMBAT VALUES FOR THIS ALIEN RACE
--[[
    health = 100                    -- 100=baseline minimum
    mass = 2                        -- 1=tiny, 10=huge
	engineclass = 6
	shieldclass = 3
	armorclass = 2
	laserclass = 4
	missileclass = 0
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 70			-- % of damage received, used for racial abilities, 0-100%
--]]


	health= gen_random(100)
	if (health < 60) then							health= 60							end

	mass= gen_random(7)
	if (mass < 2) then								mass= 2								end

	engineclass= gen_random(6)
	if (engineclass < 2) then						engineclass= 2						end
	if (engineclass < ship_engine_class) then		engineclass= ship_engine_class		end

	shieldclass= gen_random(6)
	if (shieldclass < 3) then						shieldclass= 3						end
	if (shieldclass < ship_shield_class -2) then	shieldclass= ship_shield_class -2	end

	armorclass= gen_random(5)
	if (armorclass < 2) then						armorclass= 2						end

	laserclass= gen_random(3)
	if (laserclass < 1) then						laserclass= 1						end
	if (laserclass < (ship_laser_class -2)) then	laserclass= (ship_laser_class -2)	end

	missileclass= gen_random(4)

	laser_modifier= gen_random(100)
	if (laser_modifier < 40) then					laser_modifier= 40					end

	missile_modifier= gen_random(100)
	if (missile_modifier < 20) then 				missile_modifier= 20				end


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

	DROPITEM1 = 20;	    DROPRATE1 = 80;		DROPQTY1 = 1 -- Coalition Afterburner
	DROPITEM2 = 54;		DROPRATE2 = 80;		DROPQTY2 = 3 -- Endurium
	DROPITEM3 = 31;		DROPRATE3 = 50;	    DROPQTY3 = 4
	DROPITEM4 = 35;		DROPRATE4 = 25;		DROPQTY4 = 3
	DROPITEM5 = 38;		DROPRATE5 = 0;		DROPQTY5 = 3

elseif (plot_stage == 2) then -- virus plot state

	DROPITEM1 = 236;	DROPRATE1 = 60;		DROPQTY1 = 1 -- Coalition  Computer
	DROPITEM2 = 54;		DROPRATE2 = 80;		DROPQTY2 = 3 -- Endurium
	DROPITEM3 = 225;	DROPRATE3 = 50;	    DROPQTY3 = 1 -- Bx genetic material
	DROPITEM4 = 226;	DROPRATE4 = 50;		DROPQTY4 = 1 -- Sabion genetic material
	DROPITEM5 = 227;	DROPRATE5 = 0;		DROPQTY5 = 1 -- Transmodra genetic material

elseif (plot_stage == 3) then -- war plot state

	DROPITEM1 = 20;	        DROPRATE1 = 90;		DROPQTY1 = 1 -- Coalition Afterburner
	DROPITEM2 = 54;		DROPRATE2 = 80;		DROPQTY2 = 3 -- Endurium
	DROPITEM3 = 31;		DROPRATE3 = 50;	    DROPQTY3 = 4
	DROPITEM4 = 35;		DROPRATE4 = 25;		DROPQTY4 = 3
	DROPITEM5 = 38;		DROPRATE5 = 0;		DROPQTY5 = 3

elseif (plot_stage == 4) then -- ancients plot state

	DROPITEM1 = 20;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Coalition Afterburner
	DROPITEM2 = 54;		DROPRATE2 = 80;		DROPQTY2 = 3 -- Endurium
	DROPITEM3 = 31;		DROPRATE3 = 50;	    DROPQTY3 = 4
	DROPITEM4 = 35;		DROPRATE4 = 25;		DROPQTY4 = 3
	DROPITEM5 = 38;		DROPRATE5 = 0;		DROPQTY5 = 3

end

	FTEST= -1	--FTEST is used to activate the commFxn, for decision making during conversations.

	--plot_stage = 1			--  debugging use
	--active_quest = 30  		--  debugging use
	--artifact16 = 1			--  debugging use
	--player_Endurium = 15    	--  debugging use
	--ATTITUDE = 2

if (plot_stage == 1) then -- initial plot state

	--active_quest => 25-35
	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low
	elseif player_profession == "military" and active_quest == 27 then
		first_question = 998
	elseif player_profession == "military" and active_quest == 30 and artifact20 == 0 then
		first_question = 74000
	elseif player_profession == "military" and active_quest == 32 then
		first_question = 999
	elseif player_profession == "scientific" and active_quest == 35 then
		first_question = 89000
	elseif player_profession == "freelance" and active_quest == 29 and artifact16 == 0 and player_Endurium >= 5 then
		first_question = 93000
	elseif player_profession == "freelance" and active_quest == 29 and artifact16 == 1 then
		first_question = 93500
	elseif player_profession == "freelance" and active_quest == 30 and artifact23 == 0 and artifact13 == 0 then
		first_question = 94000
	elseif player_profession == "freelance" and active_quest == 30 and artifact23 == 0 and artifact13 > 0 then
		first_question = 94500
	elseif player_profession == "freelance" and active_quest == 31 and artifact20 == 0 and player_Endurium >= 15 then
		first_question = 95000
	elseif player_profession == "freelance" and active_quest == 33 and artifact17 == 1 then
		first_question = 97000
	elseif player_profession == "freelance" and active_quest == 34 and artifact18 == 1 then
		first_question = 98000
	elseif player_profession == "freelance" and active_quest == 35 and artifact27 == 0 and artifact28 == 0 then
		first_question = 99000
	elseif artifact14 >= 1 then
		first_question = 500
	else
		first_question = 1
	end

elseif (plot_stage == 2) then -- virus plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low

	elseif active_quest == 37 then
		first_question = 77000

	elseif active_quest == 38 and artifact225 == 0 and artifact226 == 0 and artifact227 == 0 and artifact239 == 0 then
		first_question = 78000
	elseif active_quest == 38 and artifact239 == 1 then -- if Bar-zhon reactor core taken
		first_question = 78250
	elseif active_quest == 38 and artifact234 > 0 and artifact225 == 0 and artifact27 == 0 then -- Thrynn data provided by the player in exchange for BX data, no Transmodra data
		first_question = 78750
	elseif active_quest == 38 and artifact234 > 0 and artifact225 == 0 and artifact27 == 0 then -- Thrynn data provided by the player in exchange for BX data, Transmodra data already obtained
		first_question = 78850
	elseif active_quest == 38 and artifact226 > 0 and artifact225 == 0 and artifact234 == 0 then -- Sabion collected, need BX, reactor has not been obtained
		first_question = 78300

-- Mission #42:  Tracking the Laytonites
	elseif active_quest == 42 and artifact253 == 0 and artifact254 == 0 then -- Bar-zhon data not obtained
		first_question = 82000

	elseif active_quest == 42 and artifact253 == 0 and artifact254 == 1 then -- Bar-zhon data obtained
		first_question = 82500

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

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low

-- Mission #48:  Intelligence Gathering
	elseif active_quest == 48 and artifact275 == 0 and artifact276 == 0 then -- no power core
		first_question = 78000
	elseif active_quest == 48 and (artifact275 == 1 or artifact276 == 1) then -- obtained power core already
		first_question = 78500

-- Mission #49:  Unrest
	elseif active_quest == 49 and artifact280 == 0 and artifact281 == 0 then -- no flight recorders
		first_question = 79000
	elseif active_quest == 49 and (artifact280 == 1 or artifact281 == 1) then -- at least one flight recorder
		first_question = 79500


-- Mission #53:  Tactical coordination
	elseif active_quest == 53 and artifact335 == 1 then
		first_question = 83000


	else
		first_question = 1
	end

elseif (plot_stage == 4) then -- ancients plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low

	-- Mission #61: Another Ruins Search
	elseif active_quest == 61  and artifact375 == 0 then
		first_question = 81000





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
	neutralattitude = 55


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
	player_money, player_Endurium, player_Titanium, etc.
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
function commFxn(ctype, n, ftest)

	if (type == 0) then							-- greeting
		if (POSTURE == "friendly") then
			ATTITUDE = ATTITUDE + 4
		elseif (POSTURE == "obsequious") then
			ATTITUDE = ATTITUDE + 2
		elseif (POSTURE == "hostile") then
			ATTITUDE = ATTITUDE - 15
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

	elseif (ATTITUDE < friendlyattitude and number_of_actions > 8) then
		goto_question = 930  -- jump to neutral termination question
		number_of_actions = 0

	elseif (number_of_actions > 13) then
		goto_question = 940  -- jump to friendly termination question
		number_of_actions = 0

	elseif (ftest < 1) then
		return

	else -- General adjustment every time a category is started
		if (n == 10000) or (n == 20000) or (n == 30000) or (n == 40000) then
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE - 1
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 5
			end
--[[		if (n == 74100) then
			if (player_Cobalt >= 1) then
				player_Cobalt= player_Cobalt -1
			end
			]]--
		elseif (ftest == 2) then  --  Insightful question
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 3
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE - 3
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE + 2
			end
		elseif (ftest == 3) then   --  Aggravating question
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE - 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE - 4
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 8
			end
		end


		if (n == 510) then
			player_Endurium= player_Endurium + 10
			artifact14= 0
			ATTITUDE = ATTITUDE + 10

		elseif (plot_stage == 1) then -- initial plot state
--[[
title="Military Mission #30:  We are seeking an afterburner.",
--]]
			if (n == 74200) then

				if (player_Endurium < 12) then
					goto_question = 74205
				elseif (ATTITUDE <= 35) then
					goto_question = 74206
				else
					goto_question = 74207
					player_Endurium= player_Endurium -12
					artifact20= artifact20 +1
				end

			elseif (n == 93100) then  -- decide to tell about the orb or not
				if (ATTITUDE >= 60) then
					goto_question = 93105
				else
					goto_question = 93106
				end

			elseif (n == 93200) then
				player_Endurium= player_Endurium -5

			elseif (n == 93600) then
				artifact16= 0
				player_Endurium= player_Endurium +15
				active_quest= active_quest +1
				ATTITUDE = ATTITUDE + 8
			elseif (n == 93700) then
				if (ship_laser_class < max_laser_class) then
					goto_question = 93705
				else
					goto_question = 93706
				end
				ATTITUDE = ATTITUDE + 15
			elseif (n == 93705) then
				artifact16 = 0
				active_quest = active_quest + 1
				ship_laser_class= ship_laser_class +1
				ATTITUDE = ATTITUDE + 10
			elseif (n == 93706) then
				artifact16 = 0
				active_quest = active_quest + 1
				player_Endurium = player_Endurium + 15
				ATTITUDE = ATTITUDE + 20

			elseif (n == 94501) then
				artifact23= 1
				artifact13= 0
				ATTITUDE = ATTITUDE + 20


			elseif (n == 95300) then --  first exchange for afterburner
				player_Endurium= player_Endurium -10
				ATTITUDE = ATTITUDE + 10
				if (ATTITUDE >= 70) then
					goto_question = 95305
				else
					goto_question = 95306
				end
			elseif (n == 95305) then -- second exchange for afterburner
				artifact20= artifact20 +1
				ATTITUDE = ATTITUDE + 5
			elseif (n == 97100) then
				artifact17= 0
				player_Endurium= player_Endurium +40
				active_quest = active_quest+ 1
				ATTITUDE = ATTITUDE + 20
			elseif (n == 97200) then
				if (ship_shield_class < max_shield_class) then
					goto_question = 97205
				else
					goto_question = 97206
				end
				ATTITUDE = ATTITUDE + 20
			elseif (n == 97205) then
				artifact17 = 0
				active_quest = active_quest + 1
				ship_shield_class= ship_shield_class +1
				ATTITUDE = ATTITUDE + 20
			elseif (n == 97206) then
				artifact17 = 0
				active_quest = active_quest + 1
				ATTITUDE = ATTITUDE + 10
			elseif (n == 97300) then
				if (ship_laser_class < max_laser_class) then
					goto_question = 97305
				else
					goto_question = 97306
				end
				ATTITUDE = ATTITUDE + 15
			elseif (n == 97305) then
				artifact17 = 0
				active_quest = active_quest + 1
				ship_laser_class = ship_laser_class + 1
				ATTITUDE = ATTITUDE + 20
			elseif (n == 97306) then
				artifact17 = 0
				active_quest = active_quest + 1
				ATTITUDE = ATTITUDE + 15
			end

		elseif (plot_stage == 2) then -- virus plot state

			if (n == 77100) then -- Quest 37: Information about the smugglers

				if (player_Endurium < 10) then
					goto_question = 77105
				else
					goto_question = 77106
					player_Endurium= player_Endurium -10
				end

			elseif (n == 78250) then -- Quest 38: Sabion data in exchange for fusion reactor
				artifact239 = 0
				artifact226 = 1
				ATTITUDE = ATTITUDE + 5

			elseif (n == 78750) then -- Quest 38: BX data in exchange for Thrynn data
				artifact234 = 0
				artifact225 = 1
				ATTITUDE = ATTITUDE + 5

			elseif (n == 78751) then -- Quest 38: Transmodra data free
				artifact227 = 1

			elseif (n == 78850) then -- Quest 38: BX data in exchange for Thrynn data
				artifact234 = 0
				artifact225 = 1
				ATTITUDE = ATTITUDE + 5

			elseif (n == 78320) then  -- Quest 38: Transmodra data free
				artifact227 = 1

			elseif (n == 82320) then -- Quest 42: tracking the Laytonites, 10 Endurium

				if (player_Endurium < 10) then
					goto_question = 82340
				else
					player_Endurium= player_Endurium -10
				end

			elseif (n == 82330) then -- Quest 42: tracking the Laytonites, 25 Endurium

				if (player_Endurium < 25) then
					goto_question = 82340
				else
					player_Endurium= player_Endurium -25
				end

			elseif (n == 82400) then -- Quest 42: tracking the Laytonites, removing the Bar-zhon Pirate sensor data
				artifact254 = 0

			elseif (n == 85500) then -- quest 45 make it look like transporting medical treatment
				artifact265 = 0
				artifact265 = 1


			end
		elseif (plot_stage == 3) then -- war plot state

-- title="Mission #53: Tactical coordination
			if (n == 83000) then
				artifact340 = 1 -- Coalition response
			end

		elseif (plot_stage == 4) then -- ancients plot state

			if (n == 64001) then
				artifact218 = 1
			elseif (n == 81000) then
				artifact375 = 1 -- artifact375: Society of Ancient Studies Seal





			end

		end
	end
end
