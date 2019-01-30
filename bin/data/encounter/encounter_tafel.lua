--[[------------------------------------------------------------------------------------------------------------------------------------------------- ]
	ENCOUNTER SCRIPT FILE: TAFEL INITIAL

	Last Modified:  August 30th, 2009

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
		SHIELDS - status of player's shields (raised/lowered)
		WEAPONS - status of player's weapons (armed/disarmed)

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

	GreetTable= {
		"<Static>"
	}

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

--[[
	greetings[1] = {
		action="",
		player="Hail oh mighty ones, masters of the universe.",
		alien={"Umm. Hello there!  We Tafel!","Tafel ones not might yet, but we say hi.","Tafel ones not comprehend crazy alien.  Please restate request."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"Tafel bow to polite aliens, and seek no harm.","Is you silly alien, Tafel greet anyway","Wonderful magnificence is not Tafel.  We is Tafel."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"Tafel we are.  You strange one see someone else here?","Resistance is useful, prepare to be a greeting!"} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"We vastly selves Tafel.  We travel here in peace also.","Umm. Hello there!  We Tafel!"} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"Tafel take the o.k.  Not sure the humble.","Umm. Hello there!  We Tafel!"} }
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



	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"Okay, none the harm intended.","Us is in the same spatial vector, unless you wish us to mutually rotate our ships so we is above you?"} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful aliens.",
		alien={"You is the alien, but we accept greeting anyway"} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"Okay, us will not.","Us has not fired on silly alien.","Our weapons make the molten debris, well maybe and a few atomic particles, but mostly molten debris."} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"Gross alien find other species products.  We not provide ours."} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"We not understand, is there a false race?","Truth or negation?  You make no sense."} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"We diplomats, actually explores but not miners.  You find the geode crystals elsewhere","No enlightening today, you experience failure of luminescence/incandescence/fluorescence?"} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"Okay.  We not want to destroy anyway.","Less trouble not to destroy than to destroy.  Strange alien make truthful statement."} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"We speak fact, not create fountain.","Please strange alien makes sense not nonsense."} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"Us not deviant, we agree no destroy.","Us choosing negation of destruction choice."} }


]]--

end

------------------------------------------------------------------------
-- FRIENDLY DIALOGUE ---------------------------------------------------
------------------------------------------------------------------------
function FriendlyDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack

	GreetTable= {
		"<Static>"
	}

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


--[[
	greetings[1] = {
		action="",
		player="Greetings from the planet Myrrdan. We come in peace...usually.",
		alien={"We Tafel usually arrive this way too.  Us hopes that you depart in peace too."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Hello Captain [CAPTAIN].  Tafel ships are things and have no name but we say hello to your ship [SHIPNAME] too."}	}
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Hi explorers!  We Tafel are also all explorers.  We are fine."} }
	greetings[4] = {
		action="",
		player="Dude, that is one gnarly-looking ship you have there!",
		alien={"We Tafel.  Please define dude.  Please define gnarly."} }
	greetings[5] = {
		action="",
		player="How's it going, furry little cyber rodent dudes!",
		alien={"You be mistaken, we is Tafel and not rodent.  We offer assimilation and then you understand difference."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ships seem to be very simple, not very powerful.",
		alien={"Yes, but there are many of us in space, and only one of you."} }
	statements[2] = {
		action="",
		player="Your ships must be cheap to build.",
		alien={"Cheap? What is meaning of this word? Do you mean powerful? Yes, my ship is powerful! Thank you for kind word."} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"Okay sounds good."} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"Yes, yes this is our goal.  Exchange is very good.","Yes, we exchange words now, exchange more later"} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"Young need to work and not play.  Harmony and friendship are good.","You is strange alien, but words are nice."} }
]]--


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

end

------------------------------------------------------------------------
-- HOSTILE DIALOGUE ----------------------------------------------------
------------------------------------------------------------------------
function HostileDialogue()
	--add as many player greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack
	GreetTable= {
		"<Static>"
	}

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
		alien= hostileGreetTable }
	greetings[7] = {
		action="attack",
		player="Your ship looks like a flying garbage scow.",
		alien= hostileGreetTable }

--[[
	greetings[1] = {
		action="",
		player="This is captain [CAPTAIN] of the starship [SHIPNAME]. Identify yourselves immediately or be destroyed.",
		alien={"Not take destroyed.  Identify sound better.  Identity is Tafel.","Tafel is.  Risky statement is most"} }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"Is not comprehend.  We Tafel have legs and are not heavy, is floating in space."}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"Tafel is ignore powerful unless powerful and also crazy!  Is you be deviant?"} }
	greetings[4] = {
		action="attack",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"Crazed ones, may a star flare as you pass it!"} }
	greetings[5] = {
		action="attack",
		player="We require information. Comply or be destroyed.",
		alien={"Your insanity has no justification, kill yourselves for your people sake.  We will try to help."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ships are primitive and weak.",
		alien={"We have strength in numbers which you shall put to the test very soon!"} }
	statements[2] = {
		action="",
		player="Vermin desease carrying rodents we exterminate on our homeworld.",
		alien={"At Kayyai, you alien negatives! May your people judge you or save them time and crash into the sun."} }
	statements[3] = {
		action="attack",
		player="LOL! What a piece of junk!",
		alien={"What is meaning of 'Lol'? Is this form of flattery? What is junk?"} }
	statements[4] = {
		action="terminate",
		player="Your ship looks like a flying garbage scow.",
		alien={"YOU'RE a flying garbage scow, negative alien!"} }
]]--

end

function StandardQuestions()

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


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
--[[
	questions[10000] = {
		action="jump", goto=1101, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"'Tafel' means lives of the people. We do not use that name but you can."}
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ title="Explain your presence!", text="Ugly rat creatures.  Explain your presence here!",goto=2000 },
			{ text="Your ship design appears simple.", goto=3000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[2000] = {
		action="jump", goto=2101, ftest= 1, -- Aggravating
		player="[AUTO_REPEAT]",
		alien={"What are rats?"}
	}
	questions[3000] = {
		action="jump", goto=3101,
		player="[AUTO_REPEAT]",
		alien={"We like simple."}
	}
	questions[3101] = {
		action="jump", goto=1,
		player="I mean your ships must be cheap to build.", ftest= 1, -- Insightful
		alien={"Because we do this, there are many of us in space and only a few of you."}
	}
	questions[30000] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"We know little of the long past and do not dwell there.  The past is a distraction that traps the mind on something that prevents the trapped one from living and forming new action.  We only deal with fact and don't value stories which we have no way of verifying truth and have little relevance to our lives."}
	}
	questions[40000] = {
		action="jump", goto=4001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the ancients",
		alien={"No."}
	}
	questions[4001] = {
		action="jump", goto=4002,
		player="Sure you don't want to talk about Ancients?",
		alien={"No, again, no, again. Are you a negative?"}
	}
	questions[4002] = {
		action="jump", goto=4003,
		player="If you said something about the ancients what would it be?",
		alien={"Negative alien being quiet idiot, but friend is positive."}
	}
	questions[4003] = {
		action="jump", goto=4004,
		player="Do you know where ancient artifacts can be found?",
		playerfragment="where ancient artifacts can be found", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"We greatly desire to find alien artifacts and technology also."}
	}
	questions[4004] = {
		action="jump", goto=1,
		player="Really? Where can we find them?",
		alien={"We have found many ancient ruins in our travels but only rarely do we find technology up with them."}
	}
	questions[20000] = {
		action="jump", goto=20001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about other races",
		alien={"The alien race you wish to know is not stated.  You mean the Nyssian, the Minex, the Bar-zhon and Coalition, or the extinct races?"}
	}
	questions[20001] = {
		action="branch",
		choices = {
			{ text="Nyssian",  goto=21000 },
			{ text="Minex", goto=22000 },
			{ text="The Bar-zhon and the Coalition", goto=23000 },
			{ text="The extinct races", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Nyssian",
		alien={"The Nyssian race are an ancient and old one.  They have told us much but we understand very little of them.  Wisdom does not seem to serve any useful purpose or maybe does not apply to us.  We have not ever heard of or located the Nyssian home world." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Minex",
		alien={"The Minex are a mystery to us.  They do not share knowledge and will destroy our ships if we go to their territory, but they are not hostile if we leave them alone.  We have no knowledge of planets in Minex territory." }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Bar-zhon and the Coalition",
		alien={"The Bar-zhon we do trade with for many things.  They like the many unusual minerals we can mine from our worlds, and in exchange they sometimes give us technology.  We do not understand why then is that they act as if they do not like us.  The Bar-zhon home world is at Midir V - 201,105." }
	}
	questions[23001] = {
		action="jump", goto=23002,
		player="[AUTO_REPEAT]",
		alien={"The Coalition, we know as the Bar-zhon, yet different they act, and with great antagonism do they treat each other.  We have learned that as long as we do not mention our dealings with the other faction neither side will attack us.  Most of our best smartest technology has come from the Coalition." }
	}
	questions[23002] = {
		action="jump", goto=20001,
		player="[AUTO_REPEAT]",
		alien={"The Coalition organization is set up in independent cell groups, but they will not discuss it with outsiders.  They have a new trading center somewhere upspin of Bar-zhon territory.  Traditionally, their temporary bases have been located on asteroids." }
	}
	questions[24000] = {
		action="jump", goto=20001,
		player="[AUTO_REPEAT]",
		playerFragment="about the extinct races",
		alien={"We have learned of the extinct races, the Sabion, the Bx, and the Transmodra but are unable to find their old homeworlds or where they lived.  We know that the Bar-zhon know more about these races but they do not like to tell us for some reason." }
	}

	questions[1101] = {
		action="branch",
		choices = {
			{ text="Your history",  goto=1100 },
			{ title="Trade", text="What does your race offer us for trade?",goto=1200 },
			{ text="What system of government?", goto=1300 },
			{ text="Your technology", goto=1400 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[1100] = {
		action="jump", goto=1111,
		player="[AUTO_REPEAT]",
		playerFragment="about your history",
		alien={"First our people discovered reading and writing, next we discovered computers, then we discovered how to interface and live with our computers.  The heart of our people is adaptation and learning." }
	}
	questions[1200] = {
		action="jump", goto=1211,
		player="[AUTO_REPEAT]",
		alien={"Not here but at our home world we barter for minerals and fuel.  We don't understand what other races call money.  Some of us like to act, others like to view, still others like to create or produce." }
	}
	questions[1300] = {
		action="jump", goto=1311,
		player="[AUTO_REPEAT]",
		playerfragment="about your system of government",
		alien={"Government?  You mean Leaders?  We do not have a stratified society.  If there is a question then the best answer found will answer it.  If there is a dispute then the arguments are broadcast until the best answer is resulted.  The one who is confronted by the decision is the one who has to make the decision." }
	}
	questions[1400] = {
		action="jump", goto=1411,
		player="[AUTO_REPEAT]",
		playerFragment="about your technology",
		alien={"We only recently encapsulated space travel.  One who wanders discovered a bright star fall.  The star falls sometimes give us new medals if they do not kill people or misfortune in lava pools.  The star fall was a Bar-zhon supply ship which taught us shipbuilding." }
	}
	questions[1111] = {
		action="branch",
		choices = {
			{ text="Live with your computers?",  goto=1110 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1110] = {
		action="jump", goto=1112,
		player="[AUTO_REPEAT]",
		playerfragment="why you would need to live with your computers",  ftest= 1, -- Insightful
		alien={"We make short-term recordings of our experiences and if we choose can broadcast those experiences to our network.  When we are not working we enjoy browsing the broadcast experiences of others." }
	}
	questions[1112] = {
		action="branch",
		choices = {
			{ title="Experiences?", text="Experiences?  You mean you share stories?", goto=1113 },
			{ title="What are good experiences?", text="How would you find good experiences?", goto=1114 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1113] = {
		action="jump", goto=1112,
		player="[AUTO_REPEAT]",
		alien={"No, we transmit full complete sensory experiences with cybernetic jacked up. Good experiences we mark as good, and as these experiences get more marks.  With training simultaneous work of duties and feeling of experiences can be performed without the attention loss." }
	}
	questions[1114] = {
		action="jump", goto=1112,  ftest= 1, -- Insightful
		player="[AUTO_REPEAT]",
		alien={"We use a fuzzy logic adaptive ranking system based on feedback.  Some of our people spend almost their entire lives viewing and ranking the broadcasts of others, which in turn makes top-rated experiences more valuable." }
	}
	questions[1211] = {
		action="branch",
		choices = {
			{ text="You don't use money?",  goto=1220 },
			{ title="What do you trade", text="So what DOES your race offer us for trade?", goto=1230 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1220] = {
		action="jump", goto=1211, ftest= 1, -- Insightful
		player="[AUTO_REPEAT]",
		playerfragment="how you trade without using money",
		alien={"Barter we invent when you aliens start taking and never giving.  Is not money imaginary?  What can you do with it if the alien who gives it to you leaves?" }
	}
	questions[1230] = {
		action="jump", goto=1211,
		player="[AUTO_REPEAT]",
		alien={"Minerals and stuff. We are not merchants, we explore. Go find the merchants and ask them." }
	}

	questions[1311] = {
		action="branch",
		choices = {
			{ text="How do you handle criminals?",  goto=1310 },
			{ title="Anarchy", text="Won't your system have everyone killing each other?", goto=1320 },
			{ title="What about privacy?", text="So your people have thought police?", goto=1340 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1310] = {
		action="jump", goto=1312, ftest= 1, -- Insightful
		player="[AUTO_REPEAT]",
		playerfragment="about how you handle criminals with no government",
		alien={"Other races we know have this strange concept they call law.  What is law besides some bullies deciding that some deviancy is good, more deviancy is only a little bad, and some deviancy is very bad?" }
	}
	questions[1320] = {
		action="jump", goto=1330, ftest= 1, -- Insightful
		player="[AUTO_REPEAT]",
		alien={"Eventually the stable ones live and the unstable die.  All of us are born equal.  When we see other aliens with leaders all of them have two sets of laws.  The laws for leaders, which are lax and easy, and the laws for everyone else, which are strict.  Isn't that insane?" }
	}
	questions[1330] = {
		action="jump", goto=1311,
		player="Your system sounds like anarchy.",
		alien={"<Translating>. I understand. No it is not." }
	}
	questions[1340] = {
		action="jump", goto=1311,
		player="[AUTO_REPEAT]",
		alien={"No. The thoughts and experiences of all are cherished and protected, even the thoughts of deviants.  Only when the deviants act on their thoughts they are negative must be destroyed." }
	}
	questions[1312] = {
		action="branch",
		choices = {
			{ text="Determining deviancy?",  goto=1313 },
			{ title="Locating criminals", text="How do you find the criminals...  umm deviants?", goto=1314 },
			{ title="Warfare", text="Have your people never fought a war?",  goto=1315 },
			{ title="Strength in numbers?", text="Wouldn't a strong leader with a large organization willing to follow him anywhere be stronger than anyone else?", goto=1316 },
			{ text="<Back>", goto=1311 }
		}
	}
	questions[1313] = {
		action="jump", goto=1312,
		player="[AUTO_REPEAT]",
		playerFragment="how you know if someone is deviant if you don't use law", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Every youngling knows what is deviant or not deviant, and any act of deviancy results in the destruction of the deviant.  Enforcement is easy, a deviant act must hurt someone or make a victim or it is not any act of deviancy." }
	}
	questions[1314] = {
		action="jump", goto=1312,
		player="[AUTO_REPEAT]",
		alien={"All of us communicate.  A victim simply chooses to transmit their experience and then the act is discovered.  If there is no victim it is not deviant.  Self-destruction is not deviant, it is an act of choosing future inaction." }
	}
	questions[1315] = {
		action="jump", goto=1312,
		player="[AUTO_REPEAT]",
		alien={"We do understand the idea of rebels like the coalition, but not how they are tolerated. If one commits action that is negative, then we destroy the negative person." }
	}
	questions[1316] = {
		action="jump", goto=1312,  ftest= 1, -- Insightful
		player="[AUTO_REPEAT]",
		alien={"If a leader had a good idea then we would follow the idea, not the leader. If the leader ran out of ideas, we would leave him alone.  If some so-called leader tried to make others do deviant behavior, then his previous followers would ignore him." }
	}

	questions[1411] = {
		action="branch",
		choices = {
			{ title="Ships use Bar-zhon technology?", text="So your spaceships are built with Bar-zhon technology?", goto=1410 },
			{ title="Let's form an alliance.", text="Your people appear friendly. Let's form an alliance.", goto=1420 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1410] = {
		action="jump", goto=1411,
		player="[AUTO_REPEAT]",
		alien={"Yes, but much was lost. It took us 5 cycles of our sun to figure out bird flight with this technology, and another 70 cycles to figure out how to get into space.  We wish to learn from you and figure out more and will gladly share what we have learned with our friends." }
	}
	questions[1420] = {
		action="jump", goto=1411,
		player="[AUTO_REPEAT]",
		alien={"We greatly desire to find alien artifacts and technology also.  We have found many ancient ruins in our travels but only rarely do we find technology up with them. Our home world is the second lava planet of Oende 2 - 134,30.  You are welcome there." }
	}

	questions[2101] = {
		action="branch",
		choices = {
			{ title="Vermin desease carriers", text="Vermin desease carrying rodents we exterminate.", goto=2102 },
			{ text="Never mind", goto=1 }
		}
	}
	questions[2102] = {
		action="jump", goto=2103, ftest= 1, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Kayyai! Alien deviants!  May your people judge you or save them time and fly into a star." }
	}
	questions[2103] = {
		action="jump", goto=2104,
		player="We do not plan to fly into a star.  Hello?",
		alien={"<Silence>" }
	}
	questions[2104] = {
		action="attack",
		player="We do not plan to fly into a star.  Hello?",
		alien={"<Silence>" }
	}
--]]


end



function QuestDialogue()

--[[
title="Scientific Mission #29:  first contact"
--]]
--[[
	questions[83000] = {
		action="jump", goto=83002,
		player="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Tafel agree that you have established contact successfully." }
	}
	questions[83002] = {
		action="jump", goto=83001,
		player="We are on a mission to contact other sentient races!",
		alien={"You is new ship and new alien and we see you now.  What intentions do you have with Tafel? " }
	}
	questions[83001] = {
		action="jump", goto=1, ftest= 1,
--		ship_engine_class = ship_engine_class + 1
--		artifact7 = 0
--		active_quest = active_quest + 1
		player="We wanted to return the data system that we discovered.",
		alien={"We Tafel appreciate your efforts and your friendliness.  Us Tafel not having the resources to clear out the pirates from your territory, but we can gift you with better engine efficiency technology.  We also are explorers and wish to freely exchange knowledge and information.  When our engineers are done giving you new people gift we will share knowledge, okay?" }
	}


--title="Scientific Mission #31:  Whining Orb"

	questions[85000] = {
		action="jump", goto=85001,
		player="The Bar-zhon orb",
		introFragment= "Tafel vessel.  This is Captain [CAPTAIN].  Did you transmit information about a Whining orb to us?",
		playerFragment="about it",
		alien={"One moment ... Yes!  Tafel party did transmit information to you humans about a Whining Orb! " }
	}
	questions[85001] = {
		action="jump", goto=85002,
		player="Specifics?  Your transmitted message was not very clear.",
		alien={"We Tafel located, found, approached, fought, and then destroyed a pirate ship about a week ago.  In their computer log they say they steal a valuable Whining Orb from the Bar-zhon and stashed it on 'Lazerarp' directly on the northernmost rotational pole of the planet.  We not know where Lazerarp is, so we relay this information to others who might find it useful. " }
	}
	questions[85002] = {
		action="jump", goto=1,
		player="Do you perhaps know who might know where Lazerarp is?",
		playerFragment="who might know where Lazerarp is", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"No, or else we would have asked them instead of you. " }
	}


--title="Scientific Mission #35: Exotic planet hunt"

	questions[89000] = {
		action="jump", goto=1,
		player="Quest for the exotic planet.",
		playerFragment= "what you can decode from this derelict's computer data concerning an exotic planet",
		alien={"Nowhere have we ever located a small planet possessing a massive gravitational pull like this data shows.  Stellar distortion in this scan that you transmitted is very minor.  The planet must be near the edge of the system.  Talk to the Elowan directly outward from us.  They can probably analyze this information better." }
	}


--title="Freelance Mission #26:  Obtaining Star Charts"

	questions[90000] = {
		action="jump", goto=90001,
		title="Obtaining Star Charts",
		player="[AUTO_REPEAT]",
		introFragment= "Tafel vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have been seeking to contact one of your vessels.",
		playerFragment= "about this area of space",
		alien={"Tafel us acknowledge that we are 'found' by you.  What intentions do you have with Tafel? " }
	}
	questions[90001] = {
		action="jump", goto=90003,
		player="We are from Myrrdan and new in this region of space.",
		alien={"We Tafel desire to be helpful however your people are unknown and you come from the wastelands of pirates." }
	}
	questions[90003] = {
		action="jump", goto=90002,
		playerFragment="navigational data for this region of space", fragmentTable= preQuestion.desire,
		player="Could you give us navigational data for this region?",
		alien={"How do we know that you are not pirates? " }
	}
	questions[90002] = {
		action="branch",
		choices = {
			{ title="Demand", text="If you don't provide us what we want, we'll salvage what we need!  Give us your navigational data or we will open fire!",  goto=90101 },
			{ title="Insist", text="We are not pirates.  We have had to fight pirates in order to reach you.",  goto=90200 },
			{ title="Plead", text="I really need this information.  We could get lost without it!",  goto=90300 },
			{ text="Nevermind, let me ask you about something else.", goto=1 }
		}
	}
	questions[90101] = {
		action="jump", goto=90102, ftest= 1, -- aggregating
		player="[AUTO_REPEAT]",
		alien={"Kayyai! Alien deviants!  May your people judge you or save them time and fly into a star." }
	}

	questions[90102] = {
		action="attack",
		player="[AUTO_REPEAT]",
		alien={"Kayyai! Alien deviants!  May your people judge you or save them time and fly into a star." }
	}

	questions[90200] = {
--		active_quest = active_quest + 1
--		player_money = player_money + 5000
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"You alien appears to be honest.  We are now uploading star charts and gravitational data of this region.  (Employer note: extra 1500 credits awarded for keeping a low profile and not provoking an incident.)" }
	}
	questions[90300] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		alien={"Silly aliens.  Navigation does not require data, only sensors and computers.  Explore everything for yourself." }
	}

--title="Freelance Mission #34:  Pawn off Unusual Artistic Containers"


	questions[98000] = {
		action="jump", goto=98001,
		player="Pawn off Artistic Containers",
		introFragment= "Tafel vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		player="[AUTO_REPEAT]",
		playerFragment="something in exchange for these incredibly old artistic containers", fragmentTable= preQuestion.desire,
		alien={"Are those containers useful technology?  No?  We have interest in knowledge of all types and will be willing to contribute limited resources towards this.  We will offer you 4 endurium and no more." }
	}
	questions[98001] = {
		action="branch",
		choices = {
			{ text="You have a deal for 4 endurium.",  goto=98100 },
			{ text="Do you have any idea how old these containers are?",  goto=98200 },
			{ text="Nevermind", goto=1 }
		}
	}
	questions[98100] = {
--		artifact18 = 0,
--		endurium = endurium + 2,
--		active_quest = active_quest + 1,
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		alien={"Good trade. Do you want to know anything else? " }
	}
	questions[98200] = {
		action="jump", goto=98001,
		player="[AUTO_REPEAT]",
		alien={"Old.  We perceive old.  We do not perceive valuable." }
	}


--title="Freelance Mission #35:  Resolving the Tafel Elowan conflict - Initial"


	questions[99000] = {
		action="jump", goto=99001,
		player="Tell us about the Elowan Tafel conflict",
		playerFragment="about the Elowan Tafel conflict",
		alien={"Tafel establish a colony at Aircthech III.  Elowan carnivorous plants establish another colony after us on the other side of the planet.  Now they threaten us for no reason." }
	}
	questions[99001] = {
		action="jump", goto=99002,
		player="What do they threaten you with?",
		alien={"Elowan accuse us of making wasteful dirty industry to pollute the air.  Our industry does not generate visible pollution.  The primary output of our factories are noble gases and carbon dioxide, not any pollutant.  Elowan ships say that they will attack us if we do not stop something we do not do.  It is very irrational." }
	}
	questions[99002] = {
		action="jump", goto=1,
		player="Can't you negotiate with them?",
		alien={"It is not possible.  The Elowan want nothing else except what irrationality they demand that we already do not do.  Their ships  intercept our supplies and harass our scouts.  Please tell them that we do not pollute!"}
	}

--title="Freelance Mission #35:  Resolving the Tafel Elowan conflict -  after probe"


	questions[99500] = {
		action="jump", goto=1,
		player="We located this Thrynn probe which delivered the dust.",
		alien={"Good.  Take this to the Elowan and give it to them.  As long as the Elowan cease their harassment and protests, we are more than willing to peacefully cohabitate this planet."}
	}
]]--

end

--[[ -------------------------------------------------------------------
--Randomized ship characteristics, 1st pass:
----------------------------------------------------------------------]]
function GenerateShips()

    -- COMBAT VALUES FOR THIS ALIEN RACE
--[[
    -- COMBAT VALUES FOR THIS ALIEN RACE
    health = 100                    -- 100=baseline minimum
    mass = 2                        -- 1=tiny, 10=huge
	engineclass = 4
	shieldclass = 4
	armorclass = 2
	laserclass = 2
	missileclass = 4
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%
--]]

if (plot_stage == 1) then


    health = 100                    -- 100=baseline minimum
    mass = 1                        -- 1=tiny, 10=huge
	engineclass = 4
	shieldclass = 2
	armorclass = 1
	laserclass = 1
	missileclass = 2
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%

-- virus plot stage
elseif (plot_stage == 2) then

    health = 100                    -- 100=baseline minimum
    mass = 2                        -- 1=tiny, 10=huge
	engineclass = 4
	shieldclass = 2
	armorclass = 1
	laserclass = 2
	missileclass = 2
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 70			-- % of damage received, used for racial abilities, 0-100%

-- war and ancients plus pages
elseif (plot_stage == 3) or (plot_stage == 4) then


    health = 100                    -- 100=baseline minimum
    mass = 2                        -- 1=tiny, 10=huge
	engineclass = 4
	shieldclass = 3
	armorclass = 1
	laserclass = 2
	missileclass = 4
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 30			-- % of damage received, used for racial abilities, 0-100%

end

end

------------------------------------------------------------------------
-- SCRIPT INITIALIZATION -----------------------------------------------
------------------------------------------------------------------------
function Initialize()

	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in

if (plot_stage == 1) then -- initial plot state

	DROPITEM1 = 7;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Tafel Black Box
	DROPITEM2 = 54;		DROPRATE2 = 50;	    DROPQTY2 = 2
	DROPITEM3 = 37;		DROPRATE3 = 25;		DROPQTY3 = 3
	DROPITEM4 = 49;		DROPRATE4 = 50;		DROPQTY4 = 1
	DROPITEM5 = 32;		DROPRATE5 = 0;		DROPQTY5 = 4

elseif (plot_stage == 2) then -- virus plot state

	DROPITEM1 = 233;	DROPRATE1 = 80;		DROPQTY1 = 1 -- Tafel genetic material
	DROPITEM2 = 54;		DROPRATE2 = 50;	    DROPQTY2 = 2
	DROPITEM3 = 37;		DROPRATE3 = 25;		DROPQTY3 = 3
	DROPITEM4 = 49;		DROPRATE4 = 50;		DROPQTY4 = 1
	DROPITEM5 = 32;		DROPRATE5 = 0;		DROPQTY5 = 4

elseif (plot_stage == 3) then -- war plot state

	DROPITEM1 = 7;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Tafel Black Box
	DROPITEM2 = 54;		DROPRATE2 = 50;	    DROPQTY2 = 2
	DROPITEM3 = 37;		DROPRATE3 = 25;		DROPQTY3 = 3
	DROPITEM4 = 49;		DROPRATE4 = 50;		DROPQTY4 = 1
	DROPITEM5 = 32;		DROPRATE5 = 0;		DROPQTY5 = 4

elseif (plot_stage == 4) then -- ancients plot state

	DROPITEM1 = 7;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Tafel Black Box
	DROPITEM2 = 54;		DROPRATE2 = 50;	    DROPQTY2 = 2
	DROPITEM3 = 37;		DROPRATE3 = 25;		DROPQTY3 = 3
	DROPITEM4 = 49;		DROPRATE4 = 50;		DROPQTY4 = 1
	DROPITEM5 = 32;		DROPRATE5 = 0;		DROPQTY5 = 4

end

	GenerateShips()

	SetPlayerTables()

	FTEST= -1	--FTEST is used to activate the commFxn, for decision making during conversations.


	--active_quest = 29  	--  debugging use
	--artifact7 = 1		--  debugging use

	--[[
	--initialize dialog
	if player_profession == "scientific" and active_quest == 29 and artifact7 > 0 then
		first_question = 83000
	elseif player_profession == "scientific" and active_quest == 31 and artifact16 == 0 then
		first_question = 85000
	elseif player_profession == "scientific" and active_quest == 35 then
		first_question = 89000
	elseif player_profession == "freelance" and active_quest == 26 then
		first_question = 90000
	elseif player_profession == "freelance" and active_quest == 34 and artifact18 == 1 then
		first_question = 98000
	elseif player_profession == "freelance" and active_quest == 35 and artifact27 == 0 and artifact28 == 0 then
		first_question = 99000
	elseif player_profession == "freelance" and active_quest == 35 and artifact27 == 1 and artifact28 == 0 then
		first_question = 99500
	else
		first_question = 1
	end
	--]]
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
	if (ftest < 1) then
		return
	elseif (type == 0) then							--greeting
	elseif (type == 1) then							--statement
		--[[ (misc statement tests)
		if (n == 1) then
			player_money= player_money -ftest*100
		elseif (n == 2) then
			player_money= player_money -ftest*200
		elseif (n == 3) then
			player_money= player_money -ftest*300
		elseif (n == 4) then
			player_money= player_money -ftest*400
		elseif (n == 5) then
			player_money= player_money -ftest*500
		else
			player_money= player_money -ftest*4000
		end
		--]]
	else											--question
		if (n == 10000) or (n == 20000) or (n == 30000) or (n == 40000) then  -- General adjustment every time a category is started
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE + 0
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 4
			end
		elseif (n == 3101) or (n == 1110) or (n == 1114) or (n == 1220) or (n == 1310) or (n == 1320) or (n == 1316) then  --  Insightful question
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 5
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE + 1
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 3
			end
		elseif (n == 2000) or (n == 2102)  or (n == 90101) then   --  Aggravating question
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE - 6
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE - 6
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 12
			end

		elseif (n == 83001) then
			ship_engine_class = ship_engine_class + 1
			artifact7 = 0
			active_quest = active_quest + 1
--[[		elseif (n == --000) then
			if (ship_----_class < max_----_class) then
				goto_question = --005
			else\
				goto_question = --006
			end
			ATTITUDE = ATTITUDE + ---
		elseif (n == --005) then
			artifact-- = 0
			active_quest = active_quest + 1
			ship_----_class = ship_----_class + 1
		elseif (n == --006) then
			artifact-- = 0
			active_quest = active_quest + 1
			player_Endurium = player_Endurium + 15 --]]


		elseif (n == 90200) then
			active_quest = active_quest + 1
			player_money = player_money + 5000
			artifact7 = 1
		elseif (n == 98100) then
			artifact18 = 0
			player_Endurium = player_Endurium + 4
			active_quest = active_quest + 1
		end
	end
end

--[[

--  Previous dialogue files, virus, war, ancients


------------------------------------------------------------------------
-- OBSEQUIOUS DIALOGUE -------------------------------------------------
------------------------------------------------------------------------
function ObsequiousDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack
	greetings[1] = {
		action="",
		player="Hail oh mighty ones, masters of the universe.",
		alien={"Umm. Hello there!  We Tafel!","Tafel ones not might yet, we sick, not masters.","Tafel ones not comprehend crazy alien.  Please restate request."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"Tafel bow to polite aliens, and we ok right now.  Not mad-state seeking harm.","Tafel greet and say we in not harming others mood now","Wonderful magnificence is not Tafel.  We is sane Tafel."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"Tafel we are.  You strange one see someone else here?","Resistance is useful, prepare to be a greeting!"} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"We vastly selves Tafel.  We travel here in peace also.","Umm. Hello there!  We sane Tafel!"} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"Tafel take the o.k.  Not us crazy-time, not need the humble.","Umm. Hello there!  We sane Tafel!"} }



	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"Okay, we not mad right now.  None the harm.","Us is in the same spatial vector, unless you wish us to mutually rotate our ships so we is above you?"} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful aliens.",
		alien={"You is the alien, but we accept greeting anyway"} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"Okay, us will not.","No worries about sane right now. We not mad-state.","Our weapons make the molten debris, well maybe and a few atomic particles, but mostly molten debris."} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"Gross alien find other species products.  We not provide ours."} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"We not understand, is there a false race?","Truth or negation?  You make no sense."} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"We diplomats, actually explores but not miners.  You find the geode crystals elsewhere","No enlightening today, you experience failure of luminescence/incandescence/fluorescence?"} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"Okay.  We not want to destroy anyway.","No fear, sane us think that it is less trouble not to destroy than to destroy.  Strange alien make truthful statement."} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"We speak fact, not create fountain.","Please strange alien makes sense not nonsense."} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"Us not deviant, we agree no destroy.","Us choosing negation of destruction choice.  Mad ones just attack, we sane never decide to destroy."} }



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=1101,
		player="What can you tell us about yourselves?",
		alien={"'Tafel' information about us we can repeat if you wish.  If you want madness news we could provide some general info about that."}
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="Ugly rat creatures.  Explain your presence here!", goto=2000 },
			{ text="Your ship design appears simple.", goto=3000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[2000] = {
		action="jump", goto=2101,
		player="Ugly rat creatures.  Explain your presence here!",
		alien={"What are rats?"}
	}
	questions[3000] = {
		action="jump", goto=3101,
		player="Your ship design appears simple.",
		alien={"We like simple."}
	}
	questions[3101] = {
		action="jump", goto=1,
		player="I mean your ships must be cheap to build.",
		alien={"Because we do this, there are many of us in space and only a few of you."}
	}
	questions[30000] = {
		action="jump", goto=1,
		player="Can you tell us anything about the past?",
		alien={"We know little of the long past and do not dwell there.  The past is a distraction that traps the mind on something that prevents the trapped one from living and forming new action.  We only deal with fact and don't value stories which we have no way of verifying truth and have little relevance to our lives."}
	}
	questions[40000] = {
		action="jump", goto=4001,
		player="Can you tell us anything about the ancients?",
		alien={"No."}
	}
	questions[4001] = {
		action="jump", goto=4002,
		player="Sure you don't want to talk about Ancients?",
		alien={"No, again, no, again. Are you a negative?"}
	}
	questions[4002] = {
		action="jump", goto=4003,
		player="If you said something about the ancients what would it be?",
		alien={"Negative alien being quiet idiot, but friend is positive."}
	}
	questions[4003] = {
		action="jump", goto=4004,
		player="Do you know where ancient artifacts can be found?",
		alien={"We greatly desire to find alien artifacts and technology also."}
	}
	questions[4004] = {
		action="jump", goto=1,
		player="Really? Where can we find them?",
		alien={"We have found many ancient ruins in our travels but only rarely do we find technology up with them."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about other races?",
		alien={"The alien race you wish to know is not stated.  You mean the Nyssian, the Minex, the Bar-zhon and Coalition, or the extinct races?"}
	}
	questions[20001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Nyssian.",  goto=21000 },
			{ text="Tell us about the Minex.", goto=22000 },
			{ text="Tell us about the Bar-zhon and the Coalition.", goto=23000 },
			{ text="Tell us about the extinct races.", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="Tell us about the Nyssian.",
		alien={"The Nyssian race are an ancient and old one.  They have told us much but we understand very little of them.  Wisdom does not seem to serve any useful purpose or maybe does not apply to us.  We have not ever heard of or located the Nyssian home world." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="Tell us about the Minex.",
		alien={"The Minex are a mystery to us.  They do not share knowledge and will destroy our ships if we go to their territory, but they are not hostile if we leave them alone.  We have no knowledge of planets in Minex territory." }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="Tell us about the Bar-zhon and the Coalition.",
		alien={"The Bar-zhon we do trade with for many things.  They like the many unusual minerals we can mine from our worlds, and in exchange they sometimes give us technology.  We do not understand why then is that they act as if they do not like us.  The Bar-zhon home world is at Midir V - 201,105." }
	}
	questions[23001] = {
		action="jump", goto=23002,
		player="<More>",
		alien={"The Coalition, we know as the Bar-zhon, yet different they act, and with great antagonism do they treat each other.  We have learned that as long as we do not mention our dealings with the other faction neither side will attack us.  Most of our best smartest technology has come from the Coalition." }
	}
	questions[23002] = {
		action="jump", goto=20001,
		player="<More>",
		alien={"The Coalition organization is set up in independent cell groups, but they will not discuss it with outsiders.  They have a new trading center somewhere upspin of Bar-zhon territory.  Traditionally, their temporary bases have been located on asteroids." }
	}
	questions[24000] = {
		action="jump", goto=20001,
		player="Tell us about the extinct races.",
		alien={"We have learned of the extinct races, the Sabion, the Bx, and the Transmodra but are unable to find their old homeworlds or where they lived.  We know that the Bar-zhon know more about these races but they do not like to tell us for some reason." }
	}

	questions[1101] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your history?",  goto=1100 },
			{ text="What does your race offer us for trade?", goto=1200 },
			{ text="What system of government do you have?", goto=1300 },
			{ text="Can you tell us more about your technology?", goto=1400 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[1100] = {
		action="jump", goto=1111,
		player="What can you tell us about your history?",
		alien={"First our people discovered reading and writing, next we discovered computers, then we discovered how to interface and live with our computers.  The heart of our people is adaptation and learning." }
	}
	questions[1200] = {
		action="jump", goto=1211,
		player="What does your race offer us for trade?",
		alien={"Not here but at our home world we barter for minerals and fuel.  We don't understand what other races call money.  Some of us like to act, others like to view, still others like to create or produce." }
	}
	questions[1300] = {
		action="jump", goto=1311,
		player="What system of government do you have?",
		alien={"Government?  You mean Leaders?  We do not have a stratified society.  If there is a question then the best answer found will answer it.  If there is a dispute then the arguments are broadcast until the best answer is resulted.  The one who is confronted by the decision is the one who has to make the decision." }
	}
	questions[1400] = {
		action="jump", goto=1411,
		player="Can you tell us more about your technology?",
		alien={"We only recently encapsulated space travel.  One who wanders discovered a bright star fall.  The star falls sometimes give us new medals if they do not kill people or misfortune in lava pools.  The star fall was a Bar-zhon supply ship which taught us shipbuilding." }
	}
	questions[1111] = {
		action="branch",
		choices = {
			{ text="Why would you need to live with your computers?",  goto=1110 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1110] = {
		action="jump", goto=1112,
		player="Why would you need to live with your computers?",
		alien={"We make short-term recordings of our experiences and if we choose can broadcast those experiences to our network.  When we are not working we enjoy browsing the broadcast experiences of others." }
	}
	questions[1112] = {
		action="branch",
		choices = {
			{ text="Experiences?  You mean you share stories?",  goto=1113 },
			{ text="How would you find good experiences?",  goto=1114 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1113] = {
		action="jump", goto=1112,
		player="Experiences?  You mean you share stories?",
		alien={"No, we transmit full complete sensory experiences with cybernetic jacked up. Good experiences we mark as good, and as these experiences get more marks.  With training simultaneous work of duties and feeling of experiences can be performed without the attention loss." }
	}
	questions[1114] = {
		action="jump", goto=1112,
		player="How would you find good experiences?",
		alien={"We use a fuzzy logic adaptive ranking system based on feedback.  Some of our people spend almost their entire lives viewing and ranking the broadcasts of others, which in turn makes top-rated experiences more valuable." }
	}
	questions[1211] = {
		action="branch",
		choices = {
			{ text="How do you trade without using money?",  goto=1220 },
			{ text="So what DOES your race offer us for trade?",  goto=1230 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1220] = {
		action="jump", goto=1211,
		player="How do you trade without using money?",
		alien={"Barter we invent when you aliens start taking and never giving.  Is not money imaginary?  What can you do with it if the alien who gives it to you leaves?" }
	}
	questions[1230] = {
		action="jump", goto=1211,
		player="So what DOES your race offer us for trade?",
		alien={"Minerals and stuff. We are not merchants, we explore. Go find the merchants and ask them." }
	}

	questions[1311] = {
		action="branch",
		choices = {
			{ text="How do you handle criminals with no government?",  goto=1310 },
			{ text="Won't your system have everyone killing each other?", goto=1320 },
			{ text="Your system sounds like anarchy.", goto=1330 },
			{ text="So your people have thought police?", goto=1340 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1310] = {
		action="jump", goto=1312,
		player="How do you handle criminals with no government?",
		alien={"Other races we know have this strange concept they call law.  What is law besides some bullies deciding that some deviancy is good, more deviancy is only a little bad, and some deviancy is very bad?" }
	}
	questions[1320] = {
		action="jump", goto=1311,
		player="Won't your system have everyone killing each other?",
		alien={"Eventually the stable ones live and the unstable die.  All of us are born equal.  When we see other aliens with leaders all of them have two sets of laws.  The laws for leaders, which are lax and easy, and the laws for everyone else, which are strict.  Isn't that insane?" }
	}
	questions[1330] = {
		action="jump", goto=1311,
		player="Your system sounds like anarchy.",
		alien={"<Translating>. I understand. No it is not." }
	}
	questions[1340] = {
		action="jump", goto=1311,
		player="So your people have thought police?",
		alien={"No. The thoughts and experiences of all are cherished and protected, even the thoughts of deviants.  Only when the deviants act on their thoughts they are negative must be destroyed." }
	}
	questions[1312] = {
		action="branch",
		choices = {
			{ text="How do you know if someone is deviant if you don't use law?",  goto=1313 },
			{ text="How do you find the criminals...  umm deviants?", goto=1314 },
			{ text="Have your people never fought a war?", goto=1315 },
			{ text="Wouldn't a strong leader with organization be better?", goto=1316 },
			{ text="<Back>", goto=1311 }
		}
	}
	questions[1313] = {
		action="jump", goto=1312,
		player="How do you know if someone is deviant if you don't use law?",
		alien={"Every youngling knows what is deviant or not deviant, and any act of deviancy results in the destruction of the deviant.  Enforcement is easy, a deviant act must hurt someone or make a victim or it is not any act of deviancy." }
	}
	questions[1314] = {
		action="jump", goto=1312,
		player="How do you find the criminals...  umm deviants?",
		alien={"All of us communicate.  A victim simply chooses to transmit their experience and then the act is discovered.  If there is no victim it is not deviant.  Self-destruction is not deviant, it is an act of choosing future inaction." }
	}
	questions[1315] = {
		action="jump", goto=1312,
		player="Have your people never fought a war?",
		alien={"We do understand the idea of rebels like the coalition, but not how they are tolerated. If one commits action that is negative, then we destroy the negative person." }
	}
	questions[1316] = {
		action="jump", goto=1312,
		player="Wouldn't a strong leader with organization be better?",
		alien={"If a leader had a good idea then we would follow the idea, not the leader. If the leader ran out of ideas, we would leave him alone.  If some so-called leader tried to make others do deviant behavior, then his previous followers would ignore him." }
	}

	questions[1411] = {
		action="branch",
		choices = {
			{ text="So your spaceships are built with Bar-zhon technology?",  goto=1410 },
			{ text="Your people appear friendly. Let's form an alliance.", goto=1420 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1410] = {
		action="jump", goto=1411,
		player="So your spaceships are built with Bar-zhon technology?",
		alien={"Yes, but much was lost. It took us 5 cycles of our sun to figure out bird flight with this technology, and another 70 cycles to figure out how to get into space.  We wish to learn from you and figure out more and will gladly share what we have learned with our friends." }
	}
	questions[1420] = {
		action="jump", goto=1411,
		player="Your people appear friendly. Let's form an alliance.",
		alien={"We greatly desire to find alien artifacts and technology also.  We have found many ancient ruins in our travels but only rarely do we find technology up with them. Our home world is the second lava planet of Oende 2 - 134,30.  You are welcome there." }
	}

	questions[2101] = {
		action="branch",
		choices = {
			{ text="Vermin desease carrying rodents we exterminate.",  goto=2102 },
			{ text="Never mind", goto=1 }
		}
	}
	questions[2102] = {
		action="jump", goto=2103,
		player="Vermin desease carrying rodents we exterminate.",
		alien={"Kayyai! Alien deviants!  May your people judge you or save them time and fly into a star." }
	}
	questions[2103] = {
		action="attack",
		player="We do not plan to fly into a star.  Hello?",
		alien={"<Silence>" }
	}


	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"Collective suffering we still endure at least now.  Our minds control our actions at least temporarily, no madness at the moment.  The madness of our other brethren we apologize for.  If any of them harm to you the expression of sincerest regret and caution we offer." }
	}
	questions[60001] = {
	action="branch",
	choices = {
		{ text="Madness?  Suffering?  What is going on?", goto=61000 },
		{ text="You control your actions temporarily?", goto=62000 },
		{ text="What other races are affected?", goto=63000 },
		{ text="Have you observed unusual behavior in other races?", goto=64000 },
		{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"We do not understand why this happened but it did.  A great sickness has affected our people and made many of us act deviant.  We first tried to stop the deviant behavior by extinguishing the deviant ones, but it did not help and the sickness just spread faster and faster." }
	}
	questions[61001] = {
		action="jump", goto=60001,
		player="Why do you think this is a sickness?",
		alien={"Those afflicted, now almost all of us, feel tired and unhappy.  Sometimes and at strange times a sick one will become very very angry and attack all of those around." }
	}
	questions[62000] = {
		action="jump", goto=62001,
		player="",
		alien={"The angry time lasts a rotation or sometimes lasts three or four rotations and the angry one will become tired and unhappy again, but will stop acting deviant.  Our scientists say that a strange and constantly mutating virus is affecting the sick ones." }
	}
	questions[63000] = {
		action="jump", goto=60001,
		player="",
		alien={"Several others, but we lack definite information.  Few of our scouts have returned and many of them had been fired upon.  If your race is still unaffected and your defenses sound, we implore you to discover more about this plague from any who will speak with you." }
	}
	questions[64000] = {
		action="jump", goto=60001,
		player="",
		alien={"Bar-zhon and Coalition both have started a frenzy of code since this virus began affecting their populations. Many of their silly obfuscations began when their expeditions started using codenames instead of standard coordinates. For example, many destinations for their ships now include the pearl cluster = 20,210, the wee dipper = 115,180, and their favorite, the ruby tower = 10,90." }
	}
	questions[62001] = {
	action="branch",
	choices = {
		{ text="Do you have a genetic scan of the virus you can transmit?", goto=62100 },
		{ text="Have your people been able to quarantine the infected?", goto=62200 },
		{ text="Have your people made any progress towards a cure?", goto=62300 },
		{ text="Where do you think the virus originated?", goto=62400 },
		{ text="<Back>", goto=50000 }
		}
	}
	questions[62100] = {
		action="jump", goto=62101,
		player="",
		alien={"Yes, transmitting data now." }
	}
	questions[62101] = {
	action="branch",
	choices = {
		{ text="This virus appears very selective and specialized.       How could this be mutating on a scale that you describe?", goto=62110 },
		{ text="Several of these virus samples are drastically different.    How could they be mutations of the same virus?", goto=62120 },
		{ text="<Back>", goto=62001 }
		}
	}
	questions[62110] = {
		action="jump", goto=62101,
		player="",
		alien={"Different versions of the virus are appearing and all of them have similar symptoms.  New versions of the virus are appearing  many the number of times faster than we can adapt antibodies to the old ones." }
	}
	questions[62120] = {
		action="jump", goto=62101,
		player="",
		alien={"Our scientists have no idea.  We think that either some unknown agency is creating and dispersing new versions of the virus, but that cannot be since the new strains of virus appear everywhere at once." }
	}
	questions[62200] = {
		action="jump", goto=62001,
		player="",
		alien={"No.  It cannot be possible but somehow all of our people on all of our worlds and ships have been infected at the same time.  Or else an extremely long incubation period took place when the virus was dormant and unable to affect us." }
	}
	questions[62300] = {
		action="jump", goto=62301,
		player="",
		alien={"Nothing we have done seems to stop the virus or even slow it down.  Until now, none of us has shipside have died from the virus.  Unfortunately the sick ones and their deviant behavior have killed many of us already and we have heard reports of other races also becoming infected." }
	}
	questions[62301] = {
		action="jump", goto=62001,
		player="How can one virus infect different interstellar species?    Strands of genetic material like this Poxviridae strain can't possible mutate like that.",
		alien={"This can't be a normal virus in any sense of the word.  It appears on any surface ready to infect another.  Many correlations have tried to explain the source of the virus, but the purging of many deviants in the first days have left us without all available data." }
	}
	questions[62400] = {
		action="jump", goto=62401,
		player="",
		alien={"Many clues but no answer.  At the time of the infection our star was going through a period of unusual and unpredicted solar activity.  We obtained for the first time many new technologies from the Bar-zhon including new fertilizers and ionic transducers." }
	}
	questions[62401] = {
	action="branch",
	choices = {
		{ text="You were trading with the Bar-zhon?", goto=64210 },
		{ text="Unusual solar activity?", goto=64220 },
		{ text="New technologies?  Any tech from contaminated artifacts?", goto=64230 },
		{ text="<Back>", goto=62001 }
		}
	}
	questions[64210] = {
		action="jump", goto=62401,
		player="",
		alien={"Scouts had also returned from charting 20 unexplored parsecs in space.  We finished building a new model of advanced fusion reactors on our planet.  Trading with the Bar-zhon for the new products occured at their trading colony at Midir V - 201,105." }
	}
	questions[64220] = {
		action="jump", goto=62401,
		player="",
		alien={"Solar activity consisted of new sunspots and several minor solar flares which cause small disruptions in our communications network.  " }
	}
	questions[64230] = {
		action="jump", goto=62401,
		player="",
		alien={"Our new fusion reactors are simply power generation plants based on new laser technology and plasma compression simply refined from what we have learned from Bar-zhon technology already." }
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
		alien={"We Tafel usually arrive this way too.  If you go virus crazy we will not hold it against your species after we kill you."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Hello Captain [CAPTAIN].  Tafel ships are things and have no name but we say hello to your ship [SHIPNAME] too."}	}
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Hi explorers!  We Tafel are also all explorers.  We are sick but not mad right now."} }
	greetings[4] = {
		action="",
		player="Dude, that is one gnarly-looking ship you have there!",
		alien={"We Tafel.  Please define dude.  Please define gnarly."} }
	greetings[5] = {
		action="",
		player="How's it going, furry little cyber rodent dudes!",
		alien={"You be mistaken, we is Tafel and not rodent.  We offer assimilation and then you understand difference."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ships seem to be very simple, not very powerful.",
		alien={"Yes, but there are many of us in space, and only one of you."} }
	statements[2] = {
		action="",
		player="Your ships must be cheap to build.",
		alien={"Cheap? What is meaning of this word? Do you mean powerful? Yes, my ship is powerful! Thank you for kind word."} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"Trust hard with mad ones.  Both us appear to be normal so trust is ok."} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"Yes, yes this is our goal.  Exchange is very good.  We seek virus cure","Yes, we exchange words now, exchange more later"} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"Young need to work and not play.  Harmony and friendship are good.","You is strange alien, but words are nice."} }



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=1101,
		player="What can you tell us about yourselves?",
		alien={"'Tafel' information about us we can repeat if you wish.  If you want madness news we could provide some general info about that."}
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="Ugly rat creatures.  Explain your presence here!", goto=2000 },
			{ text="Your ship design appears simple.", goto=3000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[2000] = {
		action="jump", goto=2101,
		player="Ugly rat creatures.  Explain your presence here!",
		alien={"What are rats?"}
	}
	questions[3000] = {
		action="jump", goto=3101,
		player="Your ship design appears simple.",
		alien={"We like simple."}
	}
	questions[3101] = {
		action="jump", goto=1,
		player="I mean your ships must be cheap to build.",
		alien={"Because we do this, there are many of us in space and only a few of you."}
	}
	questions[30000] = {
		action="jump", goto=1,
		player="Can you tell us anything about the past?",
		alien={"We know little of the long past and do not dwell there.  The past is a distraction that traps the mind on something that prevents the trapped one from living and forming new action.  We only deal with fact and don't value stories which we have no way of verifying truth and have little relevance to our lives."}
	}
	questions[40000] = {
		action="jump", goto=4001,
		player="Can you tell us anything about the ancients?",
		alien={"No."}
	}
	questions[4001] = {
		action="jump", goto=4002,
		player="Sure you don't want to talk about Ancients?",
		alien={"No, again, no, again. Are you a negative?"}
	}
	questions[4002] = {
		action="jump", goto=4003,
		player="If you said something about the ancients what would it be?",
		alien={"Negative alien being quiet idiot, but friend is positive."}
	}
	questions[4003] = {
		action="jump", goto=4004,
		player="Do you know where ancient artifacts can be found?",
		alien={"We greatly desire to find alien artifacts and technology also."}
	}
	questions[4004] = {
		action="jump", goto=1,
		player="Really? Where can we find them?",
		alien={"We have found many ancient ruins in our travels but only rarely do we find technology up with them."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about other races?",
		alien={"The alien race you wish to know is not stated.  You mean the Nyssian, the Minex, the Bar-zhon and Coalition, or the extinct races?"}
	}
	questions[20001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Nyssian.",  goto=21000 },
			{ text="Tell us about the Minex.", goto=22000 },
			{ text="Tell us about the Bar-zhon and the Coalition.", goto=23000 },
			{ text="Tell us about the extinct races.", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="Tell us about the Nyssian.",
		alien={"The Nyssian race are an ancient and old one.  They have told us much but we understand very little of them.  Wisdom does not seem to serve any useful purpose or maybe does not apply to us.  We have not ever heard of or located the Nyssian home world." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="Tell us about the Minex.",
		alien={"The Minex are a mystery to us.  They do not share knowledge and will destroy our ships if we go to their territory, but they are not hostile if we leave them alone.  We have no knowledge of planets in Minex territory." }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="Tell us about the Bar-zhon and the Coalition.",
		alien={"The Bar-zhon we do trade with for many things.  They like the many unusual minerals we can mine from our worlds, and in exchange they sometimes give us technology.  We do not understand why then is that they act as if they do not like us.  The Bar-zhon home world is at Midir V - 201,105." }
	}
	questions[23001] = {
		action="jump", goto=23002,
		player="<More>",
		alien={"The Coalition, we know as the Bar-zhon, yet different they act, and with great antagonism do they treat each other.  We have learned that as long as we do not mention our dealings with the other faction neither side will attack us.  Most of our best smartest technology has come from the Coalition." }
	}
	questions[23002] = {
		action="jump", goto=20001,
		player="<More>",
		alien={"The Coalition organization is set up in independent cell groups, but they will not discuss it with outsiders.  They have a new trading center somewhere upspin of Bar-zhon territory.  Traditionally, their temporary bases have been located on asteroids." }
	}
	questions[24000] = {
		action="jump", goto=20001,
		player="Tell us about the extinct races.",
		alien={"We have learned of the extinct races, the Sabion, the Bx, and the Transmodra but are unable to find their old homeworlds or where they lived.  We know that the Bar-zhon know more about these races but they do not like to tell us for some reason." }
	}

	questions[1101] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your history?",  goto=1100 },
			{ text="What does your race offer us for trade?", goto=1200 },
			{ text="What system of government do you have?", goto=1300 },
			{ text="Can you tell us more about your technology?", goto=1400 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[1100] = {
		action="jump", goto=1111,
		player="What can you tell us about your history?",
		alien={"First our people discovered reading and writing, next we discovered computers, then we discovered how to interface and live with our computers.  The heart of our people is adaptation and learning." }
	}
	questions[1200] = {
		action="jump", goto=1211,
		player="What does your race offer us for trade?",
		alien={"Not here but at our home world we barter for minerals and fuel.  We don't understand what other races call money.  Some of us like to act, others like to view, still others like to create or produce." }
	}
	questions[1300] = {
		action="jump", goto=1311,
		player="What system of government do you have?",
		alien={"Government?  You mean Leaders?  We do not have a stratified society.  If there is a question then the best answer found will answer it.  If there is a dispute then the arguments are broadcast until the best answer is resulted.  The one who is confronted by the decision is the one who has to make the decision." }
	}
	questions[1400] = {
		action="jump", goto=1411,
		player="Can you tell us more about your technology?",
		alien={"We only recently encapsulated space travel.  One who wanders discovered a bright star fall.  The star falls sometimes give us new medals if they do not kill people or misfortune in lava pools.  The star fall was a Bar-zhon supply ship which taught us shipbuilding." }
	}
	questions[1111] = {
		action="branch",
		choices = {
			{ text="Why would you need to live with your computers?",  goto=1110 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1110] = {
		action="jump", goto=1112,
		player="Why would you need to live with your computers?",
		alien={"We make short-term recordings of our experiences and if we choose can broadcast those experiences to our network.  When we are not working we enjoy browsing the broadcast experiences of others." }
	}
	questions[1112] = {
		action="branch",
		choices = {
			{ text="Experiences?  You mean you share stories?",  goto=1113 },
			{ text="How would you find good experiences?",  goto=1114 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1113] = {
		action="jump", goto=1112,
		player="Experiences?  You mean you share stories?",
		alien={"No, we transmit full complete sensory experiences with cybernetic jacked up. Good experiences we mark as good, and as these experiences get more marks.  With training simultaneous work of duties and feeling of experiences can be performed without the attention loss." }
	}
	questions[1114] = {
		action="jump", goto=1112,
		player="How would you find good experiences?",
		alien={"We use a fuzzy logic adaptive ranking system based on feedback.  Some of our people spend almost their entire lives viewing and ranking the broadcasts of others, which in turn makes top-rated experiences more valuable." }
	}
	questions[1211] = {
		action="branch",
		choices = {
			{ text="How do you trade without using money?",  goto=1220 },
			{ text="So what DOES your race offer us for trade?",  goto=1230 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1220] = {
		action="jump", goto=1211,
		player="How do you trade without using money?",
		alien={"Barter we invent when you aliens start taking and never giving.  Is not money imaginary?  What can you do with it if the alien who gives it to you leaves?" }
	}
	questions[1230] = {
		action="jump", goto=1211,
		player="So what DOES your race offer us for trade?",
		alien={"Minerals and stuff. We are not merchants, we explore. Go find the merchants and ask them." }
	}

	questions[1311] = {
		action="branch",
		choices = {
			{ text="How do you handle criminals with no government?",  goto=1310 },
			{ text="Won't your system have everyone killing each other?", goto=1320 },
			{ text="Your system sounds like anarchy.", goto=1330 },
			{ text="So your people have thought police?", goto=1340 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1310] = {
		action="jump", goto=1312,
		player="How do you handle criminals with no government?",
		alien={"Other races we know have this strange concept they call law.  What is law besides some bullies deciding that some deviancy is good, more deviancy is only a little bad, and some deviancy is very bad?" }
	}
	questions[1320] = {
		action="jump", goto=1311,
		player="Won't your system have everyone killing each other?",
		alien={"Eventually the stable ones live and the unstable die.  All of us are born equal.  When we see other aliens with leaders all of them have two sets of laws.  The laws for leaders, which are lax and easy, and the laws for everyone else, which are strict.  Isn't that insane?" }
	}
	questions[1330] = {
		action="jump", goto=1311,
		player="Your system sounds like anarchy.",
		alien={"<Translating>. I understand. No it is not." }
	}
	questions[1340] = {
		action="jump", goto=1311,
		player="So your people have thought police?",
		alien={"No. The thoughts and experiences of all are cherished and protected, even the thoughts of deviants.  Only when the deviants act on their thoughts they are negative must be destroyed." }
	}
	questions[1312] = {
		action="branch",
		choices = {
			{ text="How do you know if someone is deviant if you don't use law?",  goto=1313 },
			{ text="How do you find the criminals...  umm deviants?", goto=1314 },
			{ text="Have your people never fought a war?", goto=1315 },
			{ text="Wouldn't a strong leader with organization be better?", goto=1316 },
			{ text="<Back>", goto=1311 }
		}
	}
	questions[1313] = {
		action="jump", goto=1312,
		player="How do you know if someone is deviant if you don't use law?",
		alien={"Every youngling knows what is deviant or not deviant, and any act of deviancy results in the destruction of the deviant.  Enforcement is easy, a deviant act must hurt someone or make a victim or it is not any act of deviancy." }
	}
	questions[1314] = {
		action="jump", goto=1312,
		player="How do you find the criminals...  umm deviants?",
		alien={"All of us communicate.  A victim simply chooses to transmit their experience and then the act is discovered.  If there is no victim it is not deviant.  Self-destruction is not deviant, it is an act of choosing future inaction." }
	}
	questions[1315] = {
		action="jump", goto=1312,
		player="Have your people never fought a war?",
		alien={"We do understand the idea of rebels like the coalition, but not how they are tolerated. If one commits action that is negative, then we destroy the negative person." }
	}
	questions[1316] = {
		action="jump", goto=1312,
		player="Wouldn't a strong leader with organization be better?",
		alien={"If a leader had a good idea then we would follow the idea, not the leader. If the leader ran out of ideas, we would leave him alone.  If some so-called leader tried to make others do deviant behavior, then his previous followers would ignore him." }
	}

	questions[1411] = {
		action="branch",
		choices = {
			{ text="So your spaceships are built with Bar-zhon technology?",  goto=1410 },
			{ text="Your people appear friendly. Let's form an alliance.", goto=1420 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1410] = {
		action="jump", goto=1411,
		player="So your spaceships are built with Bar-zhon technology?",
		alien={"Yes, but much was lost. It took us 5 cycles of our sun to figure out bird flight with this technology, and another 70 cycles to figure out how to get into space.  We wish to learn from you and figure out more and will gladly share what we have learned with our friends." }
	}
	questions[1420] = {
		action="jump", goto=1411,
		player="Your people appear friendly. Let's form an alliance.",
		alien={"We greatly desire to find alien artifacts and technology also.  We have found many ancient ruins in our travels but only rarely do we find technology up with them. Our home world is the second lava planet of Oende 2 - 134,30.  You are welcome there." }
	}

	questions[2101] = {
		action="branch",
		choices = {
			{ text="Vermin desease carrying rodents we exterminate.",  goto=2102 },
			{ text="Never mind", goto=1 }
		}
	}
	questions[2102] = {
		action="jump", goto=2103,
		player="Vermin desease carrying rodents we exterminate.",
		alien={"Kayyai! Alien deviants!  May your people judge you or save them time and fly into a star." }
	}
	questions[2103] = {
		action="attack",
		player="We do not plan to fly into a star.  Hello?",
		alien={"<Silence>" }
	}


	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"Collective suffering we still endure at least now.  Our minds control our actions at least temporarily, no madness at the moment.  The madness of our other brethren we apologize for.  If any of them harm to you the expression of sincerest regret and caution we offer." }
	}
	questions[60001] = {
	action="branch",
	choices = {
		{ text="Madness?  Suffering?  What is going on?", goto=61000 },
		{ text="You control your actions temporarily?", goto=62000 },
		{ text="What other races are affected?", goto=63000 },
		{ text="Have you observed unusual behavior in other races?", goto=64000 },
		{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"We do not understand why this happened but it did.  A great sickness has affected our people and made many of us act deviant.  We first tried to stop the deviant behavior by extinguishing the deviant ones, but it did not help and the sickness just spread faster and faster." }
	}
	questions[61001] = {
		action="jump", goto=60001,
		player="Why do you think this is a sickness?",
		alien={"Those afflicted, now almost all of us, feel tired and unhappy.  Sometimes and at strange times a sick one will become very very angry and attack all of those around." }
	}
	questions[62000] = {
		action="jump", goto=62001,
		player="",
		alien={"The angry time lasts a rotation or sometimes lasts three or four rotations and the angry one will become tired and unhappy again, but will stop acting deviant.  Our scientists say that a strange and constantly mutating virus is affecting the sick ones." }
	}
	questions[63000] = {
		action="jump", goto=60001,
		player="",
		alien={"Several others, but we lack definite information.  Few of our scouts have returned and many of them had been fired upon.  If your race is still unaffected and your defenses sound, we implore you to discover more about this plague from any who will speak with you." }
	}
	questions[64000] = {
		action="jump", goto=60001,
		player="",
		alien={"Bar-zhon and Coalition both have started a frenzy of code since this virus began affecting their populations. Many of their silly obfuscations began when their expeditions started using codenames instead of standard coordinates. For example, many destinations for their ships now include the pearl cluster = 20,210, the wee dipper = 115,180, and their favorite, the ruby tower = 10,90." }
	}
	questions[62001] = {
	action="branch",
	choices = {
		{ text="Do you have a genetic scan of the virus you can transmit?", goto=62100 },
		{ text="Have your people been able to quarantine the infected?", goto=62200 },
		{ text="Have your people made any progress towards a cure?", goto=62300 },
		{ text="Where do you think the virus originated?", goto=62400 },
		{ text="<Back>", goto=50000 }
		}
	}
	questions[62100] = {
		action="jump", goto=62101,
		player="",
		alien={"Yes, transmitting data now." }
	}
	questions[62101] = {
	action="branch",
	choices = {
		{ text="This virus appears very selective and specialized.       How could this be mutating on a scale that you describe?", goto=62110 },
		{ text="Several of these virus samples are drastically different.    How could they be mutations of the same virus?", goto=62120 },
		{ text="<Back>", goto=62001 }
		}
	}
	questions[62110] = {
		action="jump", goto=62101,
		player="",
		alien={"Different versions of the virus are appearing and all of them have similar symptoms.  New versions of the virus are appearing  many the number of times faster than we can adapt antibodies to the old ones." }
	}
	questions[62120] = {
		action="jump", goto=62101,
		player="",
		alien={"Our scientists have no idea.  We think that either some unknown agency is creating and dispersing new versions of the virus, but that cannot be since the new strains of virus appear everywhere at once." }
	}
	questions[62200] = {
		action="jump", goto=62001,
		player="",
		alien={"No.  It cannot be possible but somehow all of our people on all of our worlds and ships have been infected at the same time.  Or else an extremely long incubation period took place when the virus was dormant and unable to affect us." }
	}
	questions[62300] = {
		action="jump", goto=62301,
		player="",
		alien={"Nothing we have done seems to stop the virus or even slow it down.  Until now, none of us has shipside have died from the virus.  Unfortunately the sick ones and their deviant behavior have killed many of us already and we have heard reports of other races also becoming infected." }
	}
	questions[62301] = {
		action="jump", goto=62001,
		player="How can one virus infect different interstellar species?    Strands of genetic material like this Poxviridae strain can't possible mutate like that.",
		alien={"This can't be a normal virus in any sense of the word.  It appears on any surface ready to infect another.  Many correlations have tried to explain the source of the virus, but the purging of many deviants in the first days have left us without all available data." }
	}
	questions[62400] = {
		action="jump", goto=62401,
		player="",
		alien={"Many clues but no answer.  At the time of the infection our star was going through a period of unusual and unpredicted solar activity.  We obtained for the first time many new technologies from the Bar-zhon including new fertilizers and ionic transducers." }
	}
	questions[62401] = {
	action="branch",
	choices = {
		{ text="You were trading with the Bar-zhon?", goto=64210 },
		{ text="Unusual solar activity?", goto=64220 },
		{ text="New technologies?  Any tech from contaminated artifacts?", goto=64230 },
		{ text="<Back>", goto=62001 }
		}
	}
	questions[64210] = {
		action="jump", goto=62401,
		player="",
		alien={"Scouts had also returned from charting 20 unexplored parsecs in space.  We finished building a new model of advanced fusion reactors on our planet.  Trading with the Bar-zhon for the new products occured at their trading colony at Midir V - 201,105." }
	}
	questions[64220] = {
		action="jump", goto=62401,
		player="",
		alien={"Solar activity consisted of new sunspots and several minor solar flares which cause small disruptions in our communications network.  " }
	}
	questions[64230] = {
		action="jump", goto=62401,
		player="",
		alien={"Our new fusion reactors are simply power generation plants based on new laser technology and plasma compression simply refined from what we have learned from Bar-zhon technology already." }
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
		alien={"Not take destroyed.  Identify sound better.  Identity is not-mad Tafel.","Tafel is.  Not us virus deviant.  Risky statement is most"} }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"Is not comprehend.  We Tafel have legs and are not heavy, is floating in space."}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"Tafel is ignore powerful unless powerful and also crazy!  Is you be infected right now?"} }
	greetings[4] = {
		action="attack",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"Crazed infected ones, may a star flare as you pass it!"} }
	greetings[5] = {
		action="attack",
		player="We require information. Comply or be destroyed.",
		alien={"Your insanity has no justification, kill yourselves for your people sake.  We will try to help."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ships are primitive and weak.",
		alien={"We have strength in numbers which you shall put to the test very soon!"} }
	statements[2] = {
		action="",
		player="Vermin desease carrying rodents we exterminate on our homeworld.",
		alien={"At Kayyai, you alien negatives! Virus talking or you talking?  If only you then may your people judge you or save them time and crash into the sun."} }
	statements[3] = {
		action="",
		player="LOL! What a piece of junk!",
		alien={"What is meaning of 'Lol'? You mad infected right now or is this form of flattery?"} }
	statements[4] = {
		action="terminate",
		player="Your ship looks like a flying garbage scow.",
		alien={"YOU'RE a flying garbage scow, crazed alien!"} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=1101,
		player="What can you tell us about yourselves?",
		alien={"'Tafel' information about us we can repeat if you wish.  If you want madness news we could provide some general info about that."}
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="Ugly rat creatures.  Explain your presence here!", goto=2000 },
			{ text="Your ship design appears simple.", goto=3000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[2000] = {
		action="jump", goto=2101,
		player="Ugly rat creatures.  Explain your presence here!",
		alien={"What are rats?"}
	}
	questions[3000] = {
		action="jump", goto=3101,
		player="Your ship design appears simple.",
		alien={"We like simple."}
	}
	questions[3101] = {
		action="jump", goto=1,
		player="I mean your ships must be cheap to build.",
		alien={"Because we do this, there are many of us in space and only a few of you."}
	}
	questions[30000] = {
		action="jump", goto=1,
		player="Can you tell us anything about the past?",
		alien={"We know little of the long past and do not dwell there.  The past is a distraction that traps the mind on something that prevents the trapped one from living and forming new action.  We only deal with fact and don't value stories which we have no way of verifying truth and have little relevance to our lives."}
	}
	questions[40000] = {
		action="jump", goto=4001,
		player="Can you tell us anything about the ancients?",
		alien={"No."}
	}
	questions[4001] = {
		action="jump", goto=4002,
		player="Sure you don't want to talk about Ancients?",
		alien={"No, again, no, again. Are you a negative?"}
	}
	questions[4002] = {
		action="jump", goto=4003,
		player="If you said something about the ancients what would it be?",
		alien={"Negative alien being quiet idiot, but friend is positive."}
	}
	questions[4003] = {
		action="jump", goto=4004,
		player="Do you know where ancient artifacts can be found?",
		alien={"We greatly desire to find alien artifacts and technology also."}
	}
	questions[4004] = {
		action="jump", goto=1,
		player="Really? Where can we find them?",
		alien={"We have found many ancient ruins in our travels but only rarely do we find technology up with them."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about other races?",
		alien={"The alien race you wish to know is not stated.  You mean the Nyssian, the Minex, the Bar-zhon and Coalition, or the extinct races?"}
	}
	questions[20001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Nyssian.",  goto=21000 },
			{ text="Tell us about the Minex.", goto=22000 },
			{ text="Tell us about the Bar-zhon and the Coalition.", goto=23000 },
			{ text="Tell us about the extinct races.", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="Tell us about the Nyssian.",
		alien={"The Nyssian race are an ancient and old one.  They have told us much but we understand very little of them.  Wisdom does not seem to serve any useful purpose or maybe does not apply to us.  We have not ever heard of or located the Nyssian home world." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="Tell us about the Minex.",
		alien={"The Minex are a mystery to us.  They do not share knowledge and will destroy our ships if we go to their territory, but they are not hostile if we leave them alone.  We have no knowledge of planets in Minex territory." }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="Tell us about the Bar-zhon and the Coalition.",
		alien={"The Bar-zhon we do trade with for many things.  They like the many unusual minerals we can mine from our worlds, and in exchange they sometimes give us technology.  We do not understand why then is that they act as if they do not like us.  The Bar-zhon home world is at Midir V - 201,105." }
	}
	questions[23001] = {
		action="jump", goto=23002,
		player="<More>",
		alien={"The Coalition, we know as the Bar-zhon, yet different they act, and with great antagonism do they treat each other.  We have learned that as long as we do not mention our dealings with the other faction neither side will attack us.  Most of our best smartest technology has come from the Coalition." }
	}
	questions[23002] = {
		action="jump", goto=20001,
		player="<More>",
		alien={"The Coalition organization is set up in independent cell groups, but they will not discuss it with outsiders.  They have a new trading center somewhere upspin of Bar-zhon territory.  Traditionally, their temporary bases have been located on asteroids." }
	}
	questions[24000] = {
		action="jump", goto=20001,
		player="Tell us about the extinct races.",
		alien={"We have learned of the extinct races, the Sabion, the Bx, and the Transmodra but are unable to find their old homeworlds or where they lived.  We know that the Bar-zhon know more about these races but they do not like to tell us for some reason." }
	}

	questions[1101] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your history?",  goto=1100 },
			{ text="What does your race offer us for trade?", goto=1200 },
			{ text="What system of government do you have?", goto=1300 },
			{ text="Can you tell us more about your technology?", goto=1400 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[1100] = {
		action="jump", goto=1111,
		player="What can you tell us about your history?",
		alien={"First our people discovered reading and writing, next we discovered computers, then we discovered how to interface and live with our computers.  The heart of our people is adaptation and learning." }
	}
	questions[1200] = {
		action="jump", goto=1211,
		player="What does your race offer us for trade?",
		alien={"Not here but at our home world we barter for minerals and fuel.  We don't understand what other races call money.  Some of us like to act, others like to view, still others like to create or produce." }
	}
	questions[1300] = {
		action="jump", goto=1311,
		player="What system of government do you have?",
		alien={"Government?  You mean Leaders?  We do not have a stratified society.  If there is a question then the best answer found will answer it.  If there is a dispute then the arguments are broadcast until the best answer is resulted.  The one who is confronted by the decision is the one who has to make the decision." }
	}
	questions[1400] = {
		action="jump", goto=1411,
		player="Can you tell us more about your technology?",
		alien={"We only recently encapsulated space travel.  One who wanders discovered a bright star fall.  The star falls sometimes give us new medals if they do not kill people or misfortune in lava pools.  The star fall was a Bar-zhon supply ship which taught us shipbuilding." }
	}
	questions[1111] = {
		action="branch",
		choices = {
			{ text="Why would you need to live with your computers?",  goto=1110 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1110] = {
		action="jump", goto=1112,
		player="Why would you need to live with your computers?",
		alien={"We make short-term recordings of our experiences and if we choose can broadcast those experiences to our network.  When we are not working we enjoy browsing the broadcast experiences of others." }
	}
	questions[1112] = {
		action="branch",
		choices = {
			{ text="Experiences?  You mean you share stories?",  goto=1113 },
			{ text="How would you find good experiences?",  goto=1114 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1113] = {
		action="jump", goto=1112,
		player="Experiences?  You mean you share stories?",
		alien={"No, we transmit full complete sensory experiences with cybernetic jacked up. Good experiences we mark as good, and as these experiences get more marks.  With training simultaneous work of duties and feeling of experiences can be performed without the attention loss." }
	}
	questions[1114] = {
		action="jump", goto=1112,
		player="How would you find good experiences?",
		alien={"We use a fuzzy logic adaptive ranking system based on feedback.  Some of our people spend almost their entire lives viewing and ranking the broadcasts of others, which in turn makes top-rated experiences more valuable." }
	}
	questions[1211] = {
		action="branch",
		choices = {
			{ text="How do you trade without using money?",  goto=1220 },
			{ text="So what DOES your race offer us for trade?",  goto=1230 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1220] = {
		action="jump", goto=1211,
		player="How do you trade without using money?",
		alien={"Barter we invent when you aliens start taking and never giving.  Is not money imaginary?  What can you do with it if the alien who gives it to you leaves?" }
	}
	questions[1230] = {
		action="jump", goto=1211,
		player="So what DOES your race offer us for trade?",
		alien={"Minerals and stuff. We are not merchants, we explore. Go find the merchants and ask them." }
	}

	questions[1311] = {
		action="branch",
		choices = {
			{ text="How do you handle criminals with no government?",  goto=1310 },
			{ text="Won't your system have everyone killing each other?", goto=1320 },
			{ text="Your system sounds like anarchy.", goto=1330 },
			{ text="So your people have thought police?", goto=1340 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1310] = {
		action="jump", goto=1312,
		player="How do you handle criminals with no government?",
		alien={"Other races we know have this strange concept they call law.  What is law besides some bullies deciding that some deviancy is good, more deviancy is only a little bad, and some deviancy is very bad?" }
	}
	questions[1320] = {
		action="jump", goto=1311,
		player="Won't your system have everyone killing each other?",
		alien={"Eventually the stable ones live and the unstable die.  All of us are born equal.  When we see other aliens with leaders all of them have two sets of laws.  The laws for leaders, which are lax and easy, and the laws for everyone else, which are strict.  Isn't that insane?" }
	}
	questions[1330] = {
		action="jump", goto=1311,
		player="Your system sounds like anarchy.",
		alien={"<Translating>. I understand. No it is not." }
	}
	questions[1340] = {
		action="jump", goto=1311,
		player="So your people have thought police?",
		alien={"No. The thoughts and experiences of all are cherished and protected, even the thoughts of deviants.  Only when the deviants act on their thoughts they are negative must be destroyed." }
	}
	questions[1312] = {
		action="branch",
		choices = {
			{ text="How do you know if someone is deviant if you don't use law?",  goto=1313 },
			{ text="How do you find the criminals...  umm deviants?", goto=1314 },
			{ text="Have your people never fought a war?", goto=1315 },
			{ text="Wouldn't a strong leader with organization be better?", goto=1316 },
			{ text="<Back>", goto=1311 }
		}
	}
	questions[1313] = {
		action="jump", goto=1312,
		player="How do you know if someone is deviant if you don't use law?",
		alien={"Every youngling knows what is deviant or not deviant, and any act of deviancy results in the destruction of the deviant.  Enforcement is easy, a deviant act must hurt someone or make a victim or it is not any act of deviancy." }
	}
	questions[1314] = {
		action="jump", goto=1312,
		player="How do you find the criminals...  umm deviants?",
		alien={"All of us communicate.  A victim simply chooses to transmit their experience and then the act is discovered.  If there is no victim it is not deviant.  Self-destruction is not deviant, it is an act of choosing future inaction." }
	}
	questions[1315] = {
		action="jump", goto=1312,
		player="Have your people never fought a war?",
		alien={"We do understand the idea of rebels like the coalition, but not how they are tolerated. If one commits action that is negative, then we destroy the negative person." }
	}
	questions[1316] = {
		action="jump", goto=1312,
		player="Wouldn't a strong leader with organization be better?",
		alien={"If a leader had a good idea then we would follow the idea, not the leader. If the leader ran out of ideas, we would leave him alone.  If some so-called leader tried to make others do deviant behavior, then his previous followers would ignore him." }
	}

	questions[1411] = {
		action="branch",
		choices = {
			{ text="So your spaceships are built with Bar-zhon technology?",  goto=1410 },
			{ text="Your people appear friendly. Let's form an alliance.", goto=1420 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1410] = {
		action="jump", goto=1411,
		player="So your spaceships are built with Bar-zhon technology?",
		alien={"Yes, but much was lost. It took us 5 cycles of our sun to figure out bird flight with this technology, and another 70 cycles to figure out how to get into space.  We wish to learn from you and figure out more and will gladly share what we have learned with our friends." }
	}
	questions[1420] = {
		action="jump", goto=1411,
		player="Your people appear friendly. Let's form an alliance.",
		alien={"We greatly desire to find alien artifacts and technology also.  We have found many ancient ruins in our travels but only rarely do we find technology up with them. Our home world is the second lava planet of Oende 2 - 134,30.  You are welcome there." }
	}

	questions[2101] = {
		action="branch",
		choices = {
			{ text="Vermin desease carrying rodents we exterminate.",  goto=2102 },
			{ text="Never mind", goto=1 }
		}
	}
	questions[2102] = {
		action="jump", goto=2103,
		player="Vermin desease carrying rodents we exterminate.",
		alien={"Kayyai! Alien deviants!  May your people judge you or save them time and fly into a star." }
	}
	questions[2103] = {
		action="attack",
		player="We do not plan to fly into a star.  Hello?",
		alien={"<Silence>" }
	}

	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"Collective suffering we still endure at least now.  Our minds control our actions at least temporarily, no madness at the moment.  The madness of our other brethren we apologize for.  If any of them harm to you the expression of sincerest regret and caution we offer." }
	}
	questions[60001] = {
	action="branch",
	choices = {
		{ text="Madness?  Suffering?  What is going on?", goto=61000 },
		{ text="You control your actions temporarily?", goto=62000 },
		{ text="What other races are affected?", goto=63000 },
		{ text="Have you observed unusual behavior in other races?", goto=64000 },
		{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"We do not understand why this happened but it did.  A great sickness has affected our people and made many of us act deviant.  We first tried to stop the deviant behavior by extinguishing the deviant ones, but it did not help and the sickness just spread faster and faster." }
	}
	questions[61001] = {
		action="jump", goto=60001,
		player="Why do you think this is a sickness?",
		alien={"Those afflicted, now almost all of us, feel tired and unhappy.  Sometimes and at strange times a sick one will become very very angry and attack all of those around." }
	}
	questions[62000] = {
		action="jump", goto=62001,
		player="",
		alien={"The angry time lasts a rotation or sometimes lasts three or four rotations and the angry one will become tired and unhappy again, but will stop acting deviant.  Our scientists say that a strange and constantly mutating virus is affecting the sick ones." }
	}
	questions[63000] = {
		action="jump", goto=60001,
		player="",
		alien={"Several others, but we lack definite information.  Few of our scouts have returned and many of them had been fired upon.  If your race is still unaffected and your defenses sound, we implore you to discover more about this plague from any who will speak with you." }
	}
	questions[64000] = {
		action="jump", goto=60001,
		player="",
		alien={"Bar-zhon and Coalition both have started a frenzy of code since this virus began affecting their populations. Many of their silly obfuscations began when their expeditions started using codenames instead of standard coordinates. For example, many destinations for their ships now include the pearl cluster = 20,210, the wee dipper = 115,180, and their favorite, the ruby tower = 10,90." }
	}
	questions[62001] = {
	action="branch",
	choices = {
		{ text="Do you have a genetic scan of the virus you can transmit?", goto=62100 },
		{ text="Have your people been able to quarantine the infected?", goto=62200 },
		{ text="Have your people made any progress towards a cure?", goto=62300 },
		{ text="Where do you think the virus originated?", goto=62400 },
		{ text="<Back>", goto=50000 }
		}
	}
	questions[62100] = {
		action="jump", goto=62101,
		player="",
		alien={"Yes, transmitting data now." }
	}
	questions[62101] = {
	action="branch",
	choices = {
		{ text="This virus appears very selective and specialized.       How could this be mutating on a scale that you describe?", goto=62110 },
		{ text="Several of these virus samples are drastically different.    How could they be mutations of the same virus?", goto=62120 },
		{ text="<Back>", goto=62001 }
		}
	}
	questions[62110] = {
		action="jump", goto=62101,
		player="",
		alien={"Different versions of the virus are appearing and all of them have similar symptoms.  New versions of the virus are appearing  many the number of times faster than we can adapt antibodies to the old ones." }
	}
	questions[62120] = {
		action="jump", goto=62101,
		player="",
		alien={"Our scientists have no idea.  We think that either some unknown agency is creating and dispersing new versions of the virus, but that cannot be since the new strains of virus appear everywhere at once." }
	}
	questions[62200] = {
		action="jump", goto=62001,
		player="",
		alien={"No.  It cannot be possible but somehow all of our people on all of our worlds and ships have been infected at the same time.  Or else an extremely long incubation period took place when the virus was dormant and unable to affect us." }
	}
	questions[62300] = {
		action="jump", goto=62301,
		player="",
		alien={"Nothing we have done seems to stop the virus or even slow it down.  Until now, none of us has shipside have died from the virus.  Unfortunately the sick ones and their deviant behavior have killed many of us already and we have heard reports of other races also becoming infected." }
	}
	questions[62301] = {
		action="jump", goto=62001,
		player="How can one virus infect different interstellar species?    Strands of genetic material like this Poxviridae strain can't possible mutate like that.",
		alien={"This can't be a normal virus in any sense of the word.  It appears on any surface ready to infect another.  Many correlations have tried to explain the source of the virus, but the purging of many deviants in the first days have left us without all available data." }
	}
	questions[62400] = {
		action="jump", goto=62401,
		player="",
		alien={"Many clues but no answer.  At the time of the infection our star was going through a period of unusual and unpredicted solar activity.  We obtained for the first time many new technologies from the Bar-zhon including new fertilizers and ionic transducers." }
	}
	questions[62401] = {
	action="branch",
	choices = {
		{ text="You were trading with the Bar-zhon?", goto=64210 },
		{ text="Unusual solar activity?", goto=64220 },
		{ text="New technologies?  Any tech from contaminated artifacts?", goto=64230 },
		{ text="<Back>", goto=62001 }
		}
	}
	questions[64210] = {
		action="jump", goto=62401,
		player="",
		alien={"Scouts had also returned from charting 20 unexplored parsecs in space.  We finished building a new model of advanced fusion reactors on our planet.  Trading with the Bar-zhon for the new products occured at their trading colony at Midir V - 201,105." }
	}
	questions[64220] = {
		action="jump", goto=62401,
		player="",
		alien={"Solar activity consisted of new sunspots and several minor solar flares which cause small disruptions in our communications network.  " }
	}
	questions[64230] = {
		action="jump", goto=62401,
		player="",
		alien={"Our new fusion reactors are simply power generation plants based on new laser technology and plasma compression simply refined from what we have learned from Bar-zhon technology already." }
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

end



------------------------------------------------------------------------
-- OBSEQUIOUS DIALOGUE -------------------------------------------------
------------------------------------------------------------------------
function ObsequiousDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack
	greetings[1] = {
		action="",
		player="Hail oh mighty ones, masters of the universe.",
		alien={"Umm. Hello there!  We Tafel!  Minex attempt to be masters, not us.","Tafel ones not might yet, we sick, not masters.","Tafel ones not comprehend crazy alien.  Please restate request."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"Tafel bow to polite aliens, and we ok right now.  Not mad-state seeking harm.","Tafel greet and say we in not harming others mood now","Wonderful magnificence is not Tafel.  We is sane Tafel."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"Tafel we are.  You strange one see someone else here?","Resistance is useful, prepare to be a greeting!"} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"We vastly selves Tafel.  We travel here in peace also.","Umm. Hello there!  We sane Tafel!"} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"Tafel take the o.k.  We need the strong ally, not need the humble.","Umm. Hello there!  We sane Tafel!"} }



	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"Okay, we not mad right now.  None the harm.","Us is in the same spatial vector, unless you wish us to mutually rotate our ships so we is above you?"} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful aliens.",
		alien={"You is the alien, but we accept greeting anyway"} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"Okay, us will not.","No worries about sane right now. We not mad-state.","Our weapons make the molten debris, well maybe and a few atomic particles, but mostly molten debris."} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"Gross alien find other species products.  We not provide ours."} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"We not understand, is there a false race?","Truth or negation?  You make no sense."} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"We diplomats, actually explores but not miners.  You find the geode crystals elsewhere","No enlightening today, you experience failure of luminescence/incandescence/fluorescence?"} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"Okay.  We not want to destroy anyway.","No fear, sane us think that it is less trouble not to destroy than to destroy.  Strange alien make truthful statement."} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"We speak fact, not create fountain.","Please strange alien makes sense not nonsense."} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"Us not deviant, we agree no destroy.","Us choosing negation of destruction choice.  Mad ones just attack, we sane never decide to destroy."} }



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=1101,
		player="What can you tell us about yourselves?",
		alien={"'Tafel' information about us we can repeat if you wish.  If you want news of crazy rampaging Minex we could provide some general info about that."}
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="Ugly rat creatures.  Explain your presence here!", goto=2000 },
			{ text="Your ship design appears simple.", goto=3000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[2000] = {
		action="jump", goto=2101,
		player="Ugly rat creatures.  Explain your presence here!",
		alien={"What are rats?"}
	}
	questions[3000] = {
		action="jump", goto=3101,
		player="Your ship design appears simple.",
		alien={"We like simple."}
	}
	questions[3101] = {
		action="jump", goto=1,
		player="I mean your ships must be cheap to build.",
		alien={"Because we do this, there are many of us in space and only a few of you."}
	}
	questions[30000] = {
		action="jump", goto=1,
		player="Can you tell us anything about the past?",
		alien={"We know little of the long past and do not dwell there.  The past is a distraction that traps the mind on something that prevents the trapped one from living and forming new action.  We only deal with fact and don't value stories which we have no way of verifying truth and have little relevance to our lives."}
	}
	questions[40000] = {
		action="jump", goto=4001,
		player="Can you tell us anything about the ancients?",
		alien={"No."}
	}
	questions[4001] = {
		action="jump", goto=4002,
		player="Sure you don't want to talk about Ancients?",
		alien={"No, again, no, again. Are you a negative?"}
	}
	questions[4002] = {
		action="jump", goto=4003,
		player="If you said something about the ancients what would it be?",
		alien={"Negative alien being quiet idiot, but friend is positive."}
	}
	questions[4003] = {
		action="jump", goto=4004,
		player="Do you know where ancient artifacts can be found?",
		alien={"We greatly desire to find alien artifacts and technology also."}
	}
	questions[4004] = {
		action="jump", goto=1,
		player="Really? Where can we find them?",
		alien={"We have found many ancient ruins in our travels but only rarely do we find technology up with them."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about other races?",
		alien={"The alien race you wish to know is not stated.  You mean the Nyssian, the Minex, the Bar-zhon and Coalition, or the extinct races?"}
	}
	questions[20001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Nyssian.",  goto=21000 },
			{ text="Tell us about the Minex.", goto=22000 },
			{ text="Tell us about the Bar-zhon and the Coalition.", goto=23000 },
			{ text="Tell us about the extinct races.", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="Tell us about the Nyssian.",
		alien={"The Nyssian race are an ancient and old one.  They have told us much but we understand very little of them.  Wisdom does not seem to serve any useful purpose or maybe does not apply to us.  We have not ever heard of or located the Nyssian home world." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="Tell us about the Minex.",
		alien={"The Minex are a mystery to us.  They do not share knowledge and will destroy our ships if we go to their territory, but they are not hostile if we leave them alone.  We have no knowledge of planets in Minex territory." }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="Tell us about the Bar-zhon and the Coalition.",
		alien={"The Bar-zhon we do trade with for many things.  They like the many unusual minerals we can mine from our worlds, and in exchange they sometimes give us technology.  We do not understand why then is that they act as if they do not like us.  The Bar-zhon home world is at Midir V - 201,105." }
	}
	questions[23001] = {
		action="jump", goto=23002,
		player="<More>",
		alien={"The Coalition, we know as the Bar-zhon, yet different they act, and with great antagonism do they treat each other.  We have learned that as long as we do not mention our dealings with the other faction neither side will attack us.  Most of our best smartest technology has come from the Coalition." }
	}
	questions[23002] = {
		action="jump", goto=20001,
		player="<More>",
		alien={"The Coalition organization is set up in independent cell groups, but they will not discuss it with outsiders.  They have a new trading center somewhere upspin of Bar-zhon territory.  Traditionally, their temporary bases have been located on asteroids." }
	}
	questions[24000] = {
		action="jump", goto=20001,
		player="Tell us about the extinct races.",
		alien={"We have learned of the extinct races, the Sabion, the Bx, and the Transmodra but are unable to find their old homeworlds or where they lived.  We know that the Bar-zhon know more about these races but they do not like to tell us for some reason." }
	}

	questions[1101] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your history?",  goto=1100 },
			{ text="What does your race offer us for trade?", goto=1200 },
			{ text="What system of government do you have?", goto=1300 },
			{ text="Can you tell us more about your technology?", goto=1400 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[1100] = {
		action="jump", goto=1111,
		player="What can you tell us about your history?",
		alien={"First our people discovered reading and writing, next we discovered computers, then we discovered how to interface and live with our computers.  The heart of our people is adaptation and learning." }
	}
	questions[1200] = {
		action="jump", goto=1211,
		player="What does your race offer us for trade?",
		alien={"Not here but at our home world we barter for minerals and fuel.  We don't understand what other races call money.  Some of us like to act, others like to view, still others like to create or produce." }
	}
	questions[1300] = {
		action="jump", goto=1311,
		player="What system of government do you have?",
		alien={"Government?  You mean Leaders?  We do not have a stratified society.  If there is a question then the best answer found will answer it.  If there is a dispute then the arguments are broadcast until the best answer is resulted.  The one who is confronted by the decision is the one who has to make the decision." }
	}
	questions[1400] = {
		action="jump", goto=1411,
		player="Can you tell us more about your technology?",
		alien={"We only recently encapsulated space travel.  One who wanders discovered a bright star fall.  The star falls sometimes give us new medals if they do not kill people or misfortune in lava pools.  The star fall was a Bar-zhon supply ship which taught us shipbuilding." }
	}
	questions[1111] = {
		action="branch",
		choices = {
			{ text="Why would you need to live with your computers?",  goto=1110 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1110] = {
		action="jump", goto=1112,
		player="Why would you need to live with your computers?",
		alien={"We make short-term recordings of our experiences and if we choose can broadcast those experiences to our network.  When we are not working we enjoy browsing the broadcast experiences of others." }
	}
	questions[1112] = {
		action="branch",
		choices = {
			{ text="Experiences?  You mean you share stories?",  goto=1113 },
			{ text="How would you find good experiences?",  goto=1114 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1113] = {
		action="jump", goto=1112,
		player="Experiences?  You mean you share stories?",
		alien={"No, we transmit full complete sensory experiences with cybernetic jacked up. Good experiences we mark as good, and as these experiences get more marks.  With training simultaneous work of duties and feeling of experiences can be performed without the attention loss." }
	}
	questions[1114] = {
		action="jump", goto=1112,
		player="How would you find good experiences?",
		alien={"We use a fuzzy logic adaptive ranking system based on feedback.  Some of our people spend almost their entire lives viewing and ranking the broadcasts of others, which in turn makes top-rated experiences more valuable." }
	}
	questions[1211] = {
		action="branch",
		choices = {
			{ text="How do you trade without using money?",  goto=1220 },
			{ text="So what DOES your race offer us for trade?",  goto=1230 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1220] = {
		action="jump", goto=1211,
		player="How do you trade without using money?",
		alien={"Barter we invent when you aliens start taking and never giving.  Is not money imaginary?  What can you do with it if the alien who gives it to you leaves?" }
	}
	questions[1230] = {
		action="jump", goto=1211,
		player="So what DOES your race offer us for trade?",
		alien={"Minerals and stuff. We are not merchants, we explore. Go find the merchants and ask them." }
	}

	questions[1311] = {
		action="branch",
		choices = {
			{ text="How do you handle criminals with no government?",  goto=1310 },
			{ text="Won't your system have everyone killing each other?", goto=1320 },
			{ text="Your system sounds like anarchy.", goto=1330 },
			{ text="So your people have thought police?", goto=1340 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1310] = {
		action="jump", goto=1312,
		player="How do you handle criminals with no government?",
		alien={"Other races we know have this strange concept they call law.  What is law besides some bullies deciding that some deviancy is good, more deviancy is only a little bad, and some deviancy is very bad?" }
	}
	questions[1320] = {
		action="jump", goto=1311,
		player="Won't your system have everyone killing each other?",
		alien={"Eventually the stable ones live and the unstable die.  All of us are born equal.  When we see other aliens with leaders all of them have two sets of laws.  The laws for leaders, which are lax and easy, and the laws for everyone else, which are strict.  Isn't that insane?" }
	}
	questions[1330] = {
		action="jump", goto=1311,
		player="Your system sounds like anarchy.",
		alien={"<Translating>. I understand. No it is not." }
	}
	questions[1340] = {
		action="jump", goto=1311,
		player="So your people have thought police?",
		alien={"No. The thoughts and experiences of all are cherished and protected, even the thoughts of deviants.  Only when the deviants act on their thoughts they are negative must be destroyed." }
	}
	questions[1312] = {
		action="branch",
		choices = {
			{ text="How do you know if someone is deviant if you don't use law?",  goto=1313 },
			{ text="How do you find the criminals...  umm deviants?", goto=1314 },
			{ text="Have your people never fought a war?", goto=1315 },
			{ text="Wouldn't a strong leader with organization be better?", goto=1316 },
			{ text="<Back>", goto=1311 }
		}
	}
	questions[1313] = {
		action="jump", goto=1312,
		player="How do you know if someone is deviant if you don't use law?",
		alien={"Every youngling knows what is deviant or not deviant, and any act of deviancy results in the destruction of the deviant.  Enforcement is easy, a deviant act must hurt someone or make a victim or it is not any act of deviancy." }
	}
	questions[1314] = {
		action="jump", goto=1312,
		player="How do you find the criminals...  umm deviants?",
		alien={"All of us communicate.  A victim simply chooses to transmit their experience and then the act is discovered.  If there is no victim it is not deviant.  Self-destruction is not deviant, it is an act of choosing future inaction." }
	}
	questions[1315] = {
		action="jump", goto=1312,
		player="Have your people never fought a war?",
		alien={"We do understand the idea of rebels like the coalition, but not how they are tolerated. If one commits action that is negative, then we destroy the negative person." }
	}
	questions[1316] = {
		action="jump", goto=1312,
		player="Wouldn't a strong leader with organization be better?",
		alien={"If a leader had a good idea then we would follow the idea, not the leader. If the leader ran out of ideas, we would leave him alone.  If some so-called leader tried to make others do deviant behavior, then his previous followers would ignore him." }
	}

	questions[1411] = {
		action="branch",
		choices = {
			{ text="So your spaceships are built with Bar-zhon technology?",  goto=1410 },
			{ text="Your people appear friendly. Let's form an alliance.", goto=1420 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1410] = {
		action="jump", goto=1411,
		player="So your spaceships are built with Bar-zhon technology?",
		alien={"Yes, but much was lost. It took us 5 cycles of our sun to figure out bird flight with this technology, and another 70 cycles to figure out how to get into space.  We wish to learn from you and figure out more and will gladly share what we have learned with our friends." }
	}
	questions[1420] = {
		action="jump", goto=1411,
		player="Your people appear friendly. Let's form an alliance.",
		alien={"We greatly desire to find alien artifacts and technology also.  We have found many ancient ruins in our travels but only rarely do we find technology up with them. Our home world is the second lava planet of Oende 2 - 134,30.  You are welcome there." }
	}

	questions[2101] = {
		action="branch",
		choices = {
			{ text="Vermin desease carrying rodents we exterminate.",  goto=2102 },
			{ text="Never mind", goto=1 }
		}
	}
	questions[2102] = {
		action="jump", goto=2103,
		player="Vermin desease carrying rodents we exterminate.",
		alien={"Kayyai! Alien deviants!  May your people judge you or save them time and fly into a star." }
	}
	questions[2103] = {
		action="attack",
		player="We do not plan to fly into a star.  Hello?",
		alien={"<Silence>" }
	}


	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"The madness spreads.  The entire Minex race has gone completely mad and attacked us.  Our shipyards have been increased from 10 percent to 15 percent productive capacity to counter our ship losses to them." }
	}
	questions[60001] = {
	action="branch",
	choices = {
		{ text="15 percent capacity?  Isn't that fairly low?", goto=61000 },
		{ text="Do you know why the Minex would attack you?", goto=62000 },
		{ text="How are they attacking you?", goto=63000 },
		{ text="Any new progress fighting the virus?", goto=64000 },
		{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"We keep 100 percent capacity reserved if new technology requires us to refit all of our ships at once.  War we salvage the usual many technologies which balances the loss of life." }
	}
	questions[61001] = {
		action="jump", goto=60001,
		player="What do you mean, balance the loss of life?",
		alien={"Survival and progress of the species often is assisted by warfare competition of other species and salvage of their technology.  Calculations show that at our present level of technology, cooperation with other friendly species outweighs genocidal assimilation." }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="",
		alien={"No." }
	}
	questions[63000] = {
		action="jump", goto=63002,
		player="",
		alien={"The Minex are always hostile if we ventured into their space.  Now they are venturing out of their space, actively seeking out our ships and attacking them.  The Bar-zhon report that they too are also under attack.  Fortunately their ships have not found our homeworlds yet." }
	}
	questions[63002] = {
		action="jump", goto=63001,
		player="You have any suggestions on how to stop them?",
		alien={"Defeat their ships, make alliances, find and destroy their homeworlds, make alliances with races that may stop them, convince them to stop fighting us." }
	}
	questions[63001] = {
	action="branch",
	choices = {
		{ text="Which of these suggestions are the Tafel pursuing?", goto=63100 },
		{ text="Defeat their ships?", goto=63200 },
		{ text="Alliances?", goto=63300 },
		{ text="<More>", goto=63003 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[63003] = {
	action="branch",
	choices = {
		{ text="Destroy their homeworlds?", goto=63400 },
		{ text="Convince them to stop the war?", goto=63500 },
		{ text="How could someone convince them to stop the war?", goto=63600 },
		{ text="<Previous>", goto=63001 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[63100] = {
		action="jump", goto=63001,
		player="",
		alien={"All of them." }
	}
	questions[63200] = {
		action="jump", goto=63001,
		player="",
		alien={"Difficult.  Minex ships are very difficult to damage and even more difficult to damage with missiles.  Current predictions estimate that they have a 75 perccent chance of defeating the combined forces of all non-virus-infected races simultaneously." }
	}
	questions[63300] = {
		action="jump", goto=63001,
		player="",
		alien={"We have already secured a basic non-agression pact with Thrynn, Elowan, and Bar-zhon peoples to share virus research and to defend ourselves against Minex aggression." }
	}
	questions[63400] = {
		action="jump", goto=63003,
		player="",
		alien={"This would work.  Unfortunately no one has any weapon to destroy a world.  We also could not fight our way through Minex space.  Finally we have no idea where Minex homeworlds are." }
	}
	questions[63500] = {
		action="jump", goto=63003,
		player="",
		alien={"They just fire at us so we cannot talk to them.  They talked briefly when our races first met, maybe they will talk to you since you are new?" }
	}
	questions[63600] = {
		action="jump", goto=63003,
		player="",
		alien={"First it would be necessary to know why they started the war.  We lack this information.  Consensus states that they are just insane or all infected." }
	}
	questions[64000] = {
		action="jump", goto=64001,
		player="",
		alien={"Less progress.  After initial wave of death, loss of life has decreased but madness has increased." }
	}
	questions[64001] = {
	action="branch",
	choices = {
		{ text="How has the madness increased?", goto=64100 },
		{ text="To any other races been able to fight the virus?", goto=64200 },
		{ text="Any progress towards a cure?", goto=64300 },
		{ text="Do you have new information about the source of virus?", goto=64400 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[64100] = {
		action="jump", goto=64101,
		player="",
		alien={"Some of us have stopped recovering from cyclical madness.  At first war was assigned to the loss but tachyon broadcasts continue and ships continue to travel." }
	}
	questions[64101] = {
		action="jump", goto=64001,
		player="Where are the ships traveling to?",
		alien={"Different and non-consistent trajectories.  They seemed to average towards an overall downspin vector, but do not converge to any exact destination." }
	}
	questions[64200] = {
		action="jump", goto=64001,
		player="",
		alien={"All races have shown evidence of less starflight activity.  Except the Minex who now fight us.  Also additional exception of the privateers and pirates.  Final exception is the Coalition." }
	}
	questions[64300] = {
		action="jump", goto=64001,
		player="",
		alien={"Scientists make no progress.  Decimated planetary populations indicate that population density causes death.  Dispersed populations still go mad but do not die as often." }
	}
	questions[64400] = {
		action="jump", goto=64001,
		player="",
		alien={"Circumstantial evidence suggests the Minex.  Their secretive nature and technology superior to all others suggests the virus as a preemptive war activity.  If this is true they have been very successful." }
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
		alien={"We Tafel usually arrive this way too.  If you go virus crazy we will not hold it against your species after we kill you."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Hello Captain [CAPTAIN].  Tafel ships are things and have no name but we say hello to your ship [SHIPNAME] too."}	}
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Hi explorers!  We Tafel are also all explorers.  We are sick but not mad right now."} }
	greetings[4] = {
		action="",
		player="Dude, that is one gnarly-looking ship you have there!",
		alien={"We Tafel.  Please define dude.  Please define gnarly."} }
	greetings[5] = {
		action="",
		player="How's it going, furry little cyber rodent dudes!",
		alien={"You be mistaken, we is Tafel and not rodent.  We offer assimilation and then you understand difference."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ships seem to be very simple, not very powerful.",
		alien={"Yes, but there are many of us in space, and only one of you."} }
	statements[2] = {
		action="",
		player="Your ships must be cheap to build.",
		alien={"Cheap? What is meaning of this word? Do you mean powerful? Yes, my ship is powerful! Thank you for kind word."} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"Trust hard with mad ones.  Both us appear to be normal so trust is ok."} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"Yes, yes this is our goal.  Exchange is very good.  We seek virus cure","Yes, we exchange words now, exchange more later"} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"Young need to work and not play.  Harmony and friendship are good.","You is strange alien, but words are nice."} }



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
		questions[10000] = {
		action="jump", goto=1101,
		player="What can you tell us about yourselves?",
		alien={"'Tafel' information about us we can repeat if you wish.  If you want news of crazy rampaging Minex we could provide some general info about that."}
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="Ugly rat creatures.  Explain your presence here!", goto=2000 },
			{ text="Your ship design appears simple.", goto=3000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[2000] = {
		action="jump", goto=2101,
		player="Ugly rat creatures.  Explain your presence here!",
		alien={"What are rats?"}
	}
	questions[3000] = {
		action="jump", goto=3101,
		player="Your ship design appears simple.",
		alien={"We like simple."}
	}
	questions[3101] = {
		action="jump", goto=1,
		player="I mean your ships must be cheap to build.",
		alien={"Because we do this, there are many of us in space and only a few of you."}
	}
	questions[30000] = {
		action="jump", goto=1,
		player="Can you tell us anything about the past?",
		alien={"We know little of the long past and do not dwell there.  The past is a distraction that traps the mind on something that prevents the trapped one from living and forming new action.  We only deal with fact and don't value stories which we have no way of verifying truth and have little relevance to our lives."}
	}
	questions[40000] = {
		action="jump", goto=4001,
		player="Can you tell us anything about the ancients?",
		alien={"No."}
	}
	questions[4001] = {
		action="jump", goto=4002,
		player="Sure you don't want to talk about Ancients?",
		alien={"No, again, no, again. Are you a negative?"}
	}
	questions[4002] = {
		action="jump", goto=4003,
		player="If you said something about the ancients what would it be?",
		alien={"Negative alien being quiet idiot, but friend is positive."}
	}
	questions[4003] = {
		action="jump", goto=4004,
		player="Do you know where ancient artifacts can be found?",
		alien={"We greatly desire to find alien artifacts and technology also."}
	}
	questions[4004] = {
		action="jump", goto=1,
		player="Really? Where can we find them?",
		alien={"We have found many ancient ruins in our travels but only rarely do we find technology up with them."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about other races?",
		alien={"The alien race you wish to know is not stated.  You mean the Nyssian, the Minex, the Bar-zhon and Coalition, or the extinct races?"}
	}
	questions[20001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Nyssian.",  goto=21000 },
			{ text="Tell us about the Minex.", goto=22000 },
			{ text="Tell us about the Bar-zhon and the Coalition.", goto=23000 },
			{ text="Tell us about the extinct races.", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="Tell us about the Nyssian.",
		alien={"The Nyssian race are an ancient and old one.  They have told us much but we understand very little of them.  Wisdom does not seem to serve any useful purpose or maybe does not apply to us.  We have not ever heard of or located the Nyssian home world." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="Tell us about the Minex.",
		alien={"The Minex are a mystery to us.  They do not share knowledge and will destroy our ships if we go to their territory, but they are not hostile if we leave them alone.  We have no knowledge of planets in Minex territory." }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="Tell us about the Bar-zhon and the Coalition.",
		alien={"The Bar-zhon we do trade with for many things.  They like the many unusual minerals we can mine from our worlds, and in exchange they sometimes give us technology.  We do not understand why then is that they act as if they do not like us.  The Bar-zhon home world is at Midir V - 201,105." }
	}
	questions[23001] = {
		action="jump", goto=23002,
		player="<More>",
		alien={"The Coalition, we know as the Bar-zhon, yet different they act, and with great antagonism do they treat each other.  We have learned that as long as we do not mention our dealings with the other faction neither side will attack us.  Most of our best smartest technology has come from the Coalition." }
	}
	questions[23002] = {
		action="jump", goto=20001,
		player="<More>",
		alien={"The Coalition organization is set up in independent cell groups, but they will not discuss it with outsiders.  They have a new trading center somewhere upspin of Bar-zhon territory.  Traditionally, their temporary bases have been located on asteroids." }
	}
	questions[24000] = {
		action="jump", goto=20001,
		player="Tell us about the extinct races.",
		alien={"We have learned of the extinct races, the Sabion, the Bx, and the Transmodra but are unable to find their old homeworlds or where they lived.  We know that the Bar-zhon know more about these races but they do not like to tell us for some reason." }
	}

	questions[1101] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your history?",  goto=1100 },
			{ text="What does your race offer us for trade?", goto=1200 },
			{ text="What system of government do you have?", goto=1300 },
			{ text="Can you tell us more about your technology?", goto=1400 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[1100] = {
		action="jump", goto=1111,
		player="What can you tell us about your history?",
		alien={"First our people discovered reading and writing, next we discovered computers, then we discovered how to interface and live with our computers.  The heart of our people is adaptation and learning." }
	}
	questions[1200] = {
		action="jump", goto=1211,
		player="What does your race offer us for trade?",
		alien={"Not here but at our home world we barter for minerals and fuel.  We don't understand what other races call money.  Some of us like to act, others like to view, still others like to create or produce." }
	}
	questions[1300] = {
		action="jump", goto=1311,
		player="What system of government do you have?",
		alien={"Government?  You mean Leaders?  We do not have a stratified society.  If there is a question then the best answer found will answer it.  If there is a dispute then the arguments are broadcast until the best answer is resulted.  The one who is confronted by the decision is the one who has to make the decision." }
	}
	questions[1400] = {
		action="jump", goto=1411,
		player="Can you tell us more about your technology?",
		alien={"We only recently encapsulated space travel.  One who wanders discovered a bright star fall.  The star falls sometimes give us new medals if they do not kill people or misfortune in lava pools.  The star fall was a Bar-zhon supply ship which taught us shipbuilding." }
	}
	questions[1111] = {
		action="branch",
		choices = {
			{ text="Why would you need to live with your computers?",  goto=1110 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1110] = {
		action="jump", goto=1112,
		player="Why would you need to live with your computers?",
		alien={"We make short-term recordings of our experiences and if we choose can broadcast those experiences to our network.  When we are not working we enjoy browsing the broadcast experiences of others." }
	}
	questions[1112] = {
		action="branch",
		choices = {
			{ text="Experiences?  You mean you share stories?",  goto=1113 },
			{ text="How would you find good experiences?",  goto=1114 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1113] = {
		action="jump", goto=1112,
		player="Experiences?  You mean you share stories?",
		alien={"No, we transmit full complete sensory experiences with cybernetic jacked up. Good experiences we mark as good, and as these experiences get more marks.  With training simultaneous work of duties and feeling of experiences can be performed without the attention loss." }
	}
	questions[1114] = {
		action="jump", goto=1112,
		player="How would you find good experiences?",
		alien={"We use a fuzzy logic adaptive ranking system based on feedback.  Some of our people spend almost their entire lives viewing and ranking the broadcasts of others, which in turn makes top-rated experiences more valuable." }
	}
	questions[1211] = {
		action="branch",
		choices = {
			{ text="How do you trade without using money?",  goto=1220 },
			{ text="So what DOES your race offer us for trade?",  goto=1230 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1220] = {
		action="jump", goto=1211,
		player="How do you trade without using money?",
		alien={"Barter we invent when you aliens start taking and never giving.  Is not money imaginary?  What can you do with it if the alien who gives it to you leaves?" }
	}
	questions[1230] = {
		action="jump", goto=1211,
		player="So what DOES your race offer us for trade?",
		alien={"Minerals and stuff. We are not merchants, we explore. Go find the merchants and ask them." }
	}

	questions[1311] = {
		action="branch",
		choices = {
			{ text="How do you handle criminals with no government?",  goto=1310 },
			{ text="Won't your system have everyone killing each other?", goto=1320 },
			{ text="Your system sounds like anarchy.", goto=1330 },
			{ text="So your people have thought police?", goto=1340 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1310] = {
		action="jump", goto=1312,
		player="How do you handle criminals with no government?",
		alien={"Other races we know have this strange concept they call law.  What is law besides some bullies deciding that some deviancy is good, more deviancy is only a little bad, and some deviancy is very bad?" }
	}
	questions[1320] = {
		action="jump", goto=1311,
		player="Won't your system have everyone killing each other?",
		alien={"Eventually the stable ones live and the unstable die.  All of us are born equal.  When we see other aliens with leaders all of them have two sets of laws.  The laws for leaders, which are lax and easy, and the laws for everyone else, which are strict.  Isn't that insane?" }
	}
	questions[1330] = {
		action="jump", goto=1311,
		player="Your system sounds like anarchy.",
		alien={"<Translating>. I understand. No it is not." }
	}
	questions[1340] = {
		action="jump", goto=1311,
		player="So your people have thought police?",
		alien={"No. The thoughts and experiences of all are cherished and protected, even the thoughts of deviants.  Only when the deviants act on their thoughts they are negative must be destroyed." }
	}
	questions[1312] = {
		action="branch",
		choices = {
			{ text="How do you know if someone is deviant if you don't use law?",  goto=1313 },
			{ text="How do you find the criminals...  umm deviants?", goto=1314 },
			{ text="Have your people never fought a war?", goto=1315 },
			{ text="Wouldn't a strong leader with organization be better?", goto=1316 },
			{ text="<Back>", goto=1311 }
		}
	}
	questions[1313] = {
		action="jump", goto=1312,
		player="How do you know if someone is deviant if you don't use law?",
		alien={"Every youngling knows what is deviant or not deviant, and any act of deviancy results in the destruction of the deviant.  Enforcement is easy, a deviant act must hurt someone or make a victim or it is not any act of deviancy." }
	}
	questions[1314] = {
		action="jump", goto=1312,
		player="How do you find the criminals...  umm deviants?",
		alien={"All of us communicate.  A victim simply chooses to transmit their experience and then the act is discovered.  If there is no victim it is not deviant.  Self-destruction is not deviant, it is an act of choosing future inaction." }
	}
	questions[1315] = {
		action="jump", goto=1312,
		player="Have your people never fought a war?",
		alien={"We do understand the idea of rebels like the coalition, but not how they are tolerated. If one commits action that is negative, then we destroy the negative person." }
	}
	questions[1316] = {
		action="jump", goto=1312,
		player="Wouldn't a strong leader with organization be better?",
		alien={"If a leader had a good idea then we would follow the idea, not the leader. If the leader ran out of ideas, we would leave him alone.  If some so-called leader tried to make others do deviant behavior, then his previous followers would ignore him." }
	}

	questions[1411] = {
		action="branch",
		choices = {
			{ text="So your spaceships are built with Bar-zhon technology?",  goto=1410 },
			{ text="Your people appear friendly. Let's form an alliance.", goto=1420 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1410] = {
		action="jump", goto=1411,
		player="So your spaceships are built with Bar-zhon technology?",
		alien={"Yes, but much was lost. It took us 5 cycles of our sun to figure out bird flight with this technology, and another 70 cycles to figure out how to get into space.  We wish to learn from you and figure out more and will gladly share what we have learned with our friends." }
	}
	questions[1420] = {
		action="jump", goto=1411,
		player="Your people appear friendly. Let's form an alliance.",
		alien={"We greatly desire to find alien artifacts and technology also.  We have found many ancient ruins in our travels but only rarely do we find technology up with them. Our home world is the second lava planet of Oende 2 - 134,30.  You are welcome there." }
	}

	questions[2101] = {
		action="branch",
		choices = {
			{ text="Vermin desease carrying rodents we exterminate.",  goto=2102 },
			{ text="Never mind", goto=1 }
		}
	}
	questions[2102] = {
		action="jump", goto=2103,
		player="Vermin desease carrying rodents we exterminate.",
		alien={"Kayyai! Alien deviants!  May your people judge you or save them time and fly into a star." }
	}
	questions[2103] = {
		action="attack",
		player="We do not plan to fly into a star.  Hello?",
		alien={"<Silence>" }
	}


	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"The madness spreads.  The entire Minex race has gone completely mad and attacked us.  Our shipyards have been increased from 10 percent to 15 percent productive capacity to counter our ship losses to them." }
	}
	questions[60001] = {
	action="branch",
	choices = {
		{ text="15 percent capacity?  Isn't that fairly low?", goto=61000 },
		{ text="Do you know why the Minex would attack you?", goto=62000 },
		{ text="How are they attacking you?", goto=63000 },
		{ text="Any new progress fighting the virus?", goto=64000 },
		{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"We keep 100 percent capacity reserved if new technology requires us to refit all of our ships at once.  War we salvage the usual many technologies which balances the loss of life." }
	}
	questions[61001] = {
		action="jump", goto=60001,
		player="What do you mean, balance the loss of life?",
		alien={"Survival and progress of the species often is assisted by warfare competition of other species and salvage of their technology.  Calculations show that at our present level of technology, cooperation with other friendly species outweighs genocidal assimilation." }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="",
		alien={"No." }
	}
	questions[63000] = {
		action="jump", goto=63002,
		player="",
		alien={"The Minex are always hostile if we ventured into their space.  Now they are venturing out of their space, actively seeking out our ships and attacking them.  The Bar-zhon report that they too are also under attack.  Fortunately their ships have not found our homeworlds yet." }
	}
	questions[63002] = {
		action="jump", goto=63001,
		player="You have any suggestions on how to stop them?",
		alien={"Defeat their ships, make alliances, find and destroy their homeworlds, make alliances with races that may stop them, convince them to stop fighting us." }
	}
	questions[63001] = {
	action="branch",
	choices = {
		{ text="Which of these suggestions are the Tafel pursuing?", goto=63100 },
		{ text="Defeat their ships?", goto=63200 },
		{ text="Alliances?", goto=63300 },
		{ text="<More>", goto=63003 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[63003] = {
	action="branch",
	choices = {
		{ text="Destroy their homeworlds?", goto=63400 },
		{ text="Convince them to stop the war?", goto=63500 },
		{ text="How could someone convince them to stop the war?", goto=63600 },
		{ text="<Previous>", goto=63001 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[63100] = {
		action="jump", goto=63001,
		player="",
		alien={"All of them." }
	}
	questions[63200] = {
		action="jump", goto=63001,
		player="",
		alien={"Difficult.  Minex ships are very difficult to damage and even more difficult to damage with missiles.  Current predictions estimate that they have a 75 perccent chance of defeating the combined forces of all non-virus-infected races simultaneously." }
	}
	questions[63300] = {
		action="jump", goto=63001,
		player="",
		alien={"We have already secured a basic non-agression pact with Thrynn, Elowan, and Bar-zhon peoples to share virus research and to defend ourselves against Minex aggression." }
	}
	questions[63400] = {
		action="jump", goto=63003,
		player="",
		alien={"This would work.  Unfortunately no one has any weapon to destroy a world.  We also could not fight our way through Minex space.  Finally we have no idea where Minex homeworlds are." }
	}
	questions[63500] = {
		action="jump", goto=63003,
		player="",
		alien={"They just fire at us so we cannot talk to them.  They talked briefly when our races first met, maybe they will talk to you since you are new?" }
	}
	questions[63600] = {
		action="jump", goto=63003,
		player="",
		alien={"First it would be necessary to know why they started the war.  We lack this information.  Consensus states that they are just insane or all infected." }
	}
	questions[64000] = {
		action="jump", goto=64001,
		player="",
		alien={"Less progress.  After initial wave of death, loss of life has decreased but madness has increased." }
	}
	questions[64001] = {
	action="branch",
	choices = {
		{ text="How has the madness increased?", goto=64100 },
		{ text="To any other races been able to fight the virus?", goto=64200 },
		{ text="Any progress towards a cure?", goto=64300 },
		{ text="Do you have new information about the source of virus?", goto=64400 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[64100] = {
		action="jump", goto=64101,
		player="",
		alien={"Some of us have stopped recovering from cyclical madness.  At first war was assigned to the loss but tachyon broadcasts continue and ships continue to travel." }
	}
	questions[64101] = {
		action="jump", goto=64001,
		player="Where are the ships traveling to?",
		alien={"Different and non-consistent trajectories.  They seemed to average towards an overall downspin vector, but do not converge to any exact destination." }
	}
	questions[64200] = {
		action="jump", goto=64001,
		player="",
		alien={"All races have shown evidence of less starflight activity.  Except the Minex who now fight us.  Also additional exception of the privateers and pirates.  Final exception is the Coalition." }
	}
	questions[64300] = {
		action="jump", goto=64001,
		player="",
		alien={"Scientists make no progress.  Decimated planetary populations indicate that population density causes death.  Dispersed populations still go mad but do not die as often." }
	}
	questions[64400] = {
		action="jump", goto=64001,
		player="",
		alien={"Circumstantial evidence suggests the Minex.  Their secretive nature and technology superior to all others suggests the virus as a preemptive war activity.  If this is true they have been very successful." }
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
		alien={"Not take destroyed.  Identify sound better.  Identity is not-mad Tafel.","Tafel is.  We resists virus and Minex mad-ones.  Risky statement in bad times is most avoidable."} }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"Is not comprehend.  We Tafel have legs and are not heavy, is floating in space."}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"Tafel is ignore powerful unless powerful and also crazy!  Is you be infected right now?"} }
	greetings[4] = {
		action="attack",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"Crazed infected ones!  Cleanse them!"} }
	greetings[5] = {
		action="",
		player="We require information. Comply or be destroyed.",
		alien={"Focus aggression attention on genocidal Minex.  We both species loss if we fight ourselves."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ships are primitive and weak.",
		alien={"We have strength in numbers which you shall put to the test very soon!"} }
	statements[2] = {
		action="",
		player="Vermin desease carrying rodents we exterminate on our homeworld.",
		alien={"At Kayyai, you alien negatives! Virus talking or you talking?  If only you then may your people judge you or save them time and crash into the sun."} }
	statements[3] = {
		action="",
		player="LOL! What a piece of junk!",
		alien={"What is meaning of 'Lol'? You mad infected right now or is this form of flattery?"} }
	statements[4] = {
		action="terminate",
		player="Your ship looks like a flying garbage scow.",
		alien={"YOU'RE a flying garbage scow, crazed alien!"} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=1101,
		player="What can you tell us about yourselves?",
		alien={"'Tafel' information about us we can repeat if you wish.  If you want news of crazy rampaging Minex we could provide some general info about that."}
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="Ugly rat creatures.  Explain your presence here!", goto=2000 },
			{ text="Your ship design appears simple.", goto=3000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[2000] = {
		action="jump", goto=2101,
		player="Ugly rat creatures.  Explain your presence here!",
		alien={"What are rats?"}
	}
	questions[3000] = {
		action="jump", goto=3101,
		player="Your ship design appears simple.",
		alien={"We like simple."}
	}
	questions[3101] = {
		action="jump", goto=1,
		player="I mean your ships must be cheap to build.",
		alien={"Because we do this, there are many of us in space and only a few of you."}
	}
	questions[30000] = {
		action="jump", goto=1,
		player="Can you tell us anything about the past?",
		alien={"We know little of the long past and do not dwell there.  The past is a distraction that traps the mind on something that prevents the trapped one from living and forming new action.  We only deal with fact and don't value stories which we have no way of verifying truth and have little relevance to our lives."}
	}
	questions[40000] = {
		action="jump", goto=4001,
		player="Can you tell us anything about the ancients?",
		alien={"No."}
	}
	questions[4001] = {
		action="jump", goto=4002,
		player="Sure you don't want to talk about Ancients?",
		alien={"No, again, no, again. Are you a negative?"}
	}
	questions[4002] = {
		action="jump", goto=4003,
		player="If you said something about the ancients what would it be?",
		alien={"Negative alien being quiet idiot, but friend is positive."}
	}
	questions[4003] = {
		action="jump", goto=4004,
		player="Do you know where ancient artifacts can be found?",
		alien={"We greatly desire to find alien artifacts and technology also."}
	}
	questions[4004] = {
		action="jump", goto=1,
		player="Really? Where can we find them?",
		alien={"We have found many ancient ruins in our travels but only rarely do we find technology up with them."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about other races?",
		alien={"The alien race you wish to know is not stated.  You mean the Nyssian, the Minex, the Bar-zhon and Coalition, or the extinct races?"}
	}
	questions[20001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Nyssian.",  goto=21000 },
			{ text="Tell us about the Minex.", goto=22000 },
			{ text="Tell us about the Bar-zhon and the Coalition.", goto=23000 },
			{ text="Tell us about the extinct races.", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="Tell us about the Nyssian.",
		alien={"The Nyssian race are an ancient and old one.  They have told us much but we understand very little of them.  Wisdom does not seem to serve any useful purpose or maybe does not apply to us.  We have not ever heard of or located the Nyssian home world." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="Tell us about the Minex.",
		alien={"The Minex are a mystery to us.  They do not share knowledge and will destroy our ships if we go to their territory, but they are not hostile if we leave them alone.  We have no knowledge of planets in Minex territory." }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="Tell us about the Bar-zhon and the Coalition.",
		alien={"The Bar-zhon we do trade with for many things.  They like the many unusual minerals we can mine from our worlds, and in exchange they sometimes give us technology.  We do not understand why then is that they act as if they do not like us.  The Bar-zhon home world is at Midir V - 201,105." }
	}
	questions[23001] = {
		action="jump", goto=23002,
		player="<More>",
		alien={"The Coalition, we know as the Bar-zhon, yet different they act, and with great antagonism do they treat each other.  We have learned that as long as we do not mention our dealings with the other faction neither side will attack us.  Most of our best smartest technology has come from the Coalition." }
	}
	questions[23002] = {
		action="jump", goto=20001,
		player="<More>",
		alien={"The Coalition organization is set up in independent cell groups, but they will not discuss it with outsiders.  They have a new trading center somewhere upspin of Bar-zhon territory.  Traditionally, their temporary bases have been located on asteroids." }
	}
	questions[24000] = {
		action="jump", goto=20001,
		player="Tell us about the extinct races.",
		alien={"We have learned of the extinct races, the Sabion, the Bx, and the Transmodra but are unable to find their old homeworlds or where they lived.  We know that the Bar-zhon know more about these races but they do not like to tell us for some reason." }
	}

	questions[1101] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your history?",  goto=1100 },
			{ text="What does your race offer us for trade?", goto=1200 },
			{ text="What system of government do you have?", goto=1300 },
			{ text="Can you tell us more about your technology?", goto=1400 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[1100] = {
		action="jump", goto=1111,
		player="What can you tell us about your history?",
		alien={"First our people discovered reading and writing, next we discovered computers, then we discovered how to interface and live with our computers.  The heart of our people is adaptation and learning." }
	}
	questions[1200] = {
		action="jump", goto=1211,
		player="What does your race offer us for trade?",
		alien={"Not here but at our home world we barter for minerals and fuel.  We don't understand what other races call money.  Some of us like to act, others like to view, still others like to create or produce." }
	}
	questions[1300] = {
		action="jump", goto=1311,
		player="What system of government do you have?",
		alien={"Government?  You mean Leaders?  We do not have a stratified society.  If there is a question then the best answer found will answer it.  If there is a dispute then the arguments are broadcast until the best answer is resulted.  The one who is confronted by the decision is the one who has to make the decision." }
	}
	questions[1400] = {
		action="jump", goto=1411,
		player="Can you tell us more about your technology?",
		alien={"We only recently encapsulated space travel.  One who wanders discovered a bright star fall.  The star falls sometimes give us new medals if they do not kill people or misfortune in lava pools.  The star fall was a Bar-zhon supply ship which taught us shipbuilding." }
	}
	questions[1111] = {
		action="branch",
		choices = {
			{ text="Why would you need to live with your computers?",  goto=1110 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1110] = {
		action="jump", goto=1112,
		player="Why would you need to live with your computers?",
		alien={"We make short-term recordings of our experiences and if we choose can broadcast those experiences to our network.  When we are not working we enjoy browsing the broadcast experiences of others." }
	}
	questions[1112] = {
		action="branch",
		choices = {
			{ text="Experiences?  You mean you share stories?",  goto=1113 },
			{ text="How would you find good experiences?",  goto=1114 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1113] = {
		action="jump", goto=1112,
		player="Experiences?  You mean you share stories?",
		alien={"No, we transmit full complete sensory experiences with cybernetic jacked up. Good experiences we mark as good, and as these experiences get more marks.  With training simultaneous work of duties and feeling of experiences can be performed without the attention loss." }
	}
	questions[1114] = {
		action="jump", goto=1112,
		player="How would you find good experiences?",
		alien={"We use a fuzzy logic adaptive ranking system based on feedback.  Some of our people spend almost their entire lives viewing and ranking the broadcasts of others, which in turn makes top-rated experiences more valuable." }
	}
	questions[1211] = {
		action="branch",
		choices = {
			{ text="How do you trade without using money?",  goto=1220 },
			{ text="So what DOES your race offer us for trade?",  goto=1230 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1220] = {
		action="jump", goto=1211,
		player="How do you trade without using money?",
		alien={"Barter we invent when you aliens start taking and never giving.  Is not money imaginary?  What can you do with it if the alien who gives it to you leaves?" }
	}
	questions[1230] = {
		action="jump", goto=1211,
		player="So what DOES your race offer us for trade?",
		alien={"Minerals and stuff. We are not merchants, we explore. Go find the merchants and ask them." }
	}

	questions[1311] = {
		action="branch",
		choices = {
			{ text="How do you handle criminals with no government?",  goto=1310 },
			{ text="Won't your system have everyone killing each other?", goto=1320 },
			{ text="Your system sounds like anarchy.", goto=1330 },
			{ text="So your people have thought police?", goto=1340 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1310] = {
		action="jump", goto=1312,
		player="How do you handle criminals with no government?",
		alien={"Other races we know have this strange concept they call law.  What is law besides some bullies deciding that some deviancy is good, more deviancy is only a little bad, and some deviancy is very bad?" }
	}
	questions[1320] = {
		action="jump", goto=1311,
		player="Won't your system have everyone killing each other?",
		alien={"Eventually the stable ones live and the unstable die.  All of us are born equal.  When we see other aliens with leaders all of them have two sets of laws.  The laws for leaders, which are lax and easy, and the laws for everyone else, which are strict.  Isn't that insane?" }
	}
	questions[1330] = {
		action="jump", goto=1311,
		player="Your system sounds like anarchy.",
		alien={"<Translating>. I understand. No it is not." }
	}
	questions[1340] = {
		action="jump", goto=1311,
		player="So your people have thought police?",
		alien={"No. The thoughts and experiences of all are cherished and protected, even the thoughts of deviants.  Only when the deviants act on their thoughts they are negative must be destroyed." }
	}
	questions[1312] = {
		action="branch",
		choices = {
			{ text="How do you know if someone is deviant if you don't use law?",  goto=1313 },
			{ text="How do you find the criminals...  umm deviants?", goto=1314 },
			{ text="Have your people never fought a war?", goto=1315 },
			{ text="Wouldn't a strong leader with organization be better?", goto=1316 },
			{ text="<Back>", goto=1311 }
		}
	}
	questions[1313] = {
		action="jump", goto=1312,
		player="How do you know if someone is deviant if you don't use law?",
		alien={"Every youngling knows what is deviant or not deviant, and any act of deviancy results in the destruction of the deviant.  Enforcement is easy, a deviant act must hurt someone or make a victim or it is not any act of deviancy." }
	}
	questions[1314] = {
		action="jump", goto=1312,
		player="How do you find the criminals...  umm deviants?",
		alien={"All of us communicate.  A victim simply chooses to transmit their experience and then the act is discovered.  If there is no victim it is not deviant.  Self-destruction is not deviant, it is an act of choosing future inaction." }
	}
	questions[1315] = {
		action="jump", goto=1312,
		player="Have your people never fought a war?",
		alien={"We do understand the idea of rebels like the coalition, but not how they are tolerated. If one commits action that is negative, then we destroy the negative person." }
	}
	questions[1316] = {
		action="jump", goto=1312,
		player="Wouldn't a strong leader with organization be better?",
		alien={"If a leader had a good idea then we would follow the idea, not the leader. If the leader ran out of ideas, we would leave him alone.  If some so-called leader tried to make others do deviant behavior, then his previous followers would ignore him." }
	}

	questions[1411] = {
		action="branch",
		choices = {
			{ text="So your spaceships are built with Bar-zhon technology?",  goto=1410 },
			{ text="Your people appear friendly. Let's form an alliance.", goto=1420 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1410] = {
		action="jump", goto=1411,
		player="So your spaceships are built with Bar-zhon technology?",
		alien={"Yes, but much was lost. It took us 5 cycles of our sun to figure out bird flight with this technology, and another 70 cycles to figure out how to get into space.  We wish to learn from you and figure out more and will gladly share what we have learned with our friends." }
	}
	questions[1420] = {
		action="jump", goto=1411,
		player="Your people appear friendly. Let's form an alliance.",
		alien={"We greatly desire to find alien artifacts and technology also.  We have found many ancient ruins in our travels but only rarely do we find technology up with them. Our home world is the second lava planet of Oende 2 - 134,30.  You are welcome there." }
	}

	questions[2101] = {
		action="branch",
		choices = {
			{ text="Vermin desease carrying rodents we exterminate.",  goto=2102 },
			{ text="Never mind", goto=1 }
		}
	}
	questions[2102] = {
		action="jump", goto=2103,
		player="Vermin desease carrying rodents we exterminate.",
		alien={"Kayyai! Alien deviants!  May your people judge you or save them time and fly into a star." }
	}
	questions[2103] = {
		action="attack",
		player="We do not plan to fly into a star.  Hello?",
		alien={"<Silence>" }
	}


	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"The madness spreads.  The entire Minex race has gone completely mad and attacked us.  Our shipyards have been increased from 10 percent to 15 percent productive capacity to counter our ship losses to them." }
	}
	questions[60001] = {
	action="branch",
	choices = {
		{ text="15 percent capacity?  Isn't that fairly low?", goto=61000 },
		{ text="Do you know why the Minex would attack you?", goto=62000 },
		{ text="How are they attacking you?", goto=63000 },
		{ text="Any new progress fighting the virus?", goto=64000 },
		{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"We keep 100 percent capacity reserved if new technology requires us to refit all of our ships at once.  War we salvage the usual many technologies which balances the loss of life." }
	}
	questions[61001] = {
		action="jump", goto=60001,
		player="What do you mean, balance the loss of life?",
		alien={"Survival and progress of the species often is assisted by warfare competition of other species and salvage of their technology.  Calculations show that at our present level of technology, cooperation with other friendly species outweighs genocidal assimilation." }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="",
		alien={"No." }
	}
	questions[63000] = {
		action="jump", goto=63002,
		player="",
		alien={"The Minex are always hostile if we ventured into their space.  Now they are venturing out of their space, actively seeking out our ships and attacking them.  The Bar-zhon report that they too are also under attack.  Fortunately their ships have not found our homeworlds yet." }
	}
	questions[63002] = {
		action="jump", goto=63001,
		player="You have any suggestions on how to stop them?",
		alien={"Defeat their ships, make alliances, find and destroy their homeworlds, make alliances with races that may stop them, convince them to stop fighting us." }
	}
	questions[63001] = {
	action="branch",
	choices = {
		{ text="Which of these suggestions are the Tafel pursuing?", goto=63100 },
		{ text="Defeat their ships?", goto=63200 },
		{ text="Alliances?", goto=63300 },
		{ text="<More>", goto=63003 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[63003] = {
	action="branch",
	choices = {
		{ text="Destroy their homeworlds?", goto=63400 },
		{ text="Convince them to stop the war?", goto=63500 },
		{ text="How could someone convince them to stop the war?", goto=63600 },
		{ text="<Previous>", goto=63001 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[63100] = {
		action="jump", goto=63001,
		player="",
		alien={"All of them." }
	}
	questions[63200] = {
		action="jump", goto=63001,
		player="",
		alien={"Difficult.  Minex ships are very difficult to damage and even more difficult to damage with missiles.  Current predictions estimate that they have a 75 perccent chance of defeating the combined forces of all non-virus-infected races simultaneously." }
	}
	questions[63300] = {
		action="jump", goto=63001,
		player="",
		alien={"We have already secured a basic non-agression pact with Thrynn, Elowan, and Bar-zhon peoples to share virus research and to defend ourselves against Minex aggression." }
	}
	questions[63400] = {
		action="jump", goto=63003,
		player="",
		alien={"This would work.  Unfortunately no one has any weapon to destroy a world.  We also could not fight our way through Minex space.  Finally we have no idea where Minex homeworlds are." }
	}
	questions[63500] = {
		action="jump", goto=63003,
		player="",
		alien={"They just fire at us so we cannot talk to them.  They talked briefly when our races first met, maybe they will talk to you since you are new?" }
	}
	questions[63600] = {
		action="jump", goto=63003,
		player="",
		alien={"First it would be necessary to know why they started the war.  We lack this information.  Consensus states that they are just insane or all infected." }
	}
	questions[64000] = {
		action="jump", goto=64001,
		player="",
		alien={"Less progress.  After initial wave of death, loss of life has decreased but madness has increased." }
	}
	questions[64001] = {
	action="branch",
	choices = {
		{ text="How has the madness increased?", goto=64100 },
		{ text="To any other races been able to fight the virus?", goto=64200 },
		{ text="Any progress towards a cure?", goto=64300 },
		{ text="Do you have new information about the source of virus?", goto=64400 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[64100] = {
		action="jump", goto=64101,
		player="",
		alien={"Some of us have stopped recovering from cyclical madness.  At first war was assigned to the loss but tachyon broadcasts continue and ships continue to travel." }
	}
	questions[64101] = {
		action="jump", goto=64001,
		player="Where are the ships traveling to?",
		alien={"Different and non-consistent trajectories.  They seemed to average towards an overall downspin vector, but do not converge to any exact destination." }
	}
	questions[64200] = {
		action="jump", goto=64001,
		player="",
		alien={"All races have shown evidence of less starflight activity.  Except the Minex who now fight us.  Also additional exception of the privateers and pirates.  Final exception is the Coalition." }
	}
	questions[64300] = {
		action="jump", goto=64001,
		player="",
		alien={"Scientists make no progress.  Decimated planetary populations indicate that population density causes death.  Dispersed populations still go mad but do not die as often." }
	}
	questions[64400] = {
		action="jump", goto=64001,
		player="",
		alien={"Circumstantial evidence suggests the Minex.  Their secretive nature and technology superior to all others suggests the virus as a preemptive war activity.  If this is true they have been very successful." }
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

end



------------------------------------------------------------------------
-- OBSEQUIOUS DIALOGUE -------------------------------------------------
------------------------------------------------------------------------
function ObsequiousDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack
	greetings[1] = {
		action="",
		player="Hail oh mighty ones, masters of the universe.",
		alien={"Umm. Hello there!  We Tafel!","Tafel ones not might yet, we sick, not masters.","Tafel ones not comprehend crazy alien.  Please restate request."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"Tafel bow to polite aliens, and we ok right now.  Not mad-state seeking harm.","Tafel greet and say we in not harming others mood now","Wonderful magnificence is not Tafel.  We is sane Tafel."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"Tafel we are.  You strange one see someone else here?","Resistance is useful, prepare to be a greeting!"} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"We vastly selves Tafel.  We travel here in peace also.","Umm. Hello there!  We sane Tafel!"} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"Tafel take the o.k.  Not us crazy-time, not need the humble.","Umm. Hello there!  We sane Tafel!"} }



	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"Okay, we not mad right now.  None the harm.","Us is in the same spatial vector, unless you wish us to mutually rotate our ships so we is above you?"} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful aliens.",
		alien={"You is the alien, but we accept greeting anyway"} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"Okay, us will not.","No worries about sane right now. We not mad-state.","Our weapons make the molten debris, well maybe and a few atomic particles, but mostly molten debris."} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"Gross alien find other species products.  We not provide ours."} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"We not understand, is there a false race?","Truth or negation?  You make no sense."} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"We diplomats, actually explores but not miners.  You find the geode crystals elsewhere","No enlightening today, you experience failure of luminescence/incandescence/fluorescence?"} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"Okay.  We not want to destroy anyway.","No fear, sane us think that it is less trouble not to destroy than to destroy.  Strange alien make truthful statement."} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"We speak fact, not create fountain.","Please strange alien makes sense not nonsense."} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"Us not deviant, we agree no destroy.","Us choosing negation of destruction choice.  Mad ones just attack, we sane never decide to destroy."} }



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=1101,
		player="What can you tell us about yourselves?",
		alien={"'Tafel' information about us we can repeat if you wish.  If you want madness news we could provide some general info about that."}
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="Ugly rat creatures.  Explain your presence here!", goto=2000 },
			{ text="Your ship design appears simple.", goto=3000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[2000] = {
		action="jump", goto=2101,
		player="Ugly rat creatures.  Explain your presence here!",
		alien={"What are rats?"}
	}
	questions[3000] = {
		action="jump", goto=3101,
		player="Your ship design appears simple.",
		alien={"We like simple."}
	}
	questions[3101] = {
		action="jump", goto=1,
		player="I mean your ships must be cheap to build.",
		alien={"Because we do this, there are many of us in space and only a few of you."}
	}
	questions[30000] = {
		action="jump", goto=1,
		player="Can you tell us anything about the past?",
		alien={"We know little of the long past and do not dwell there.  The past is a distraction that traps the mind on something that prevents the trapped one from living and forming new action.  We only deal with fact and don't value stories which we have no way of verifying truth and have little relevance to our lives."}
	}
	questions[40000] = {
		action="jump", goto=4001,
		player="Can you tell us anything about the ancients?",
		alien={"No."}
	}
	questions[4001] = {
		action="jump", goto=4002,
		player="Sure you don't want to talk about Ancients?",
		alien={"No, again, no, again. Are you a negative?"}
	}
	questions[4002] = {
		action="jump", goto=4003,
		player="If you said something about the ancients what would it be?",
		alien={"Negative alien being quiet idiot, but friend is positive."}
	}
	questions[4003] = {
		action="jump", goto=4004,
		player="Do you know where ancient artifacts can be found?",
		alien={"We greatly desire to find alien artifacts and technology also."}
	}
	questions[4004] = {
		action="jump", goto=1,
		player="Really? Where can we find them?",
		alien={"We have found many ancient ruins in our travels but only rarely do we find technology up with them."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about other races?",
		alien={"The alien race you wish to know is not stated.  You mean the Nyssian, the Minex, the Bar-zhon and Coalition, or the extinct races?"}
	}
	questions[20001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Nyssian.",  goto=21000 },
			{ text="Tell us about the Minex.", goto=22000 },
			{ text="Tell us about the Bar-zhon and the Coalition.", goto=23000 },
			{ text="Tell us about the extinct races.", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="Tell us about the Nyssian.",
		alien={"The Nyssian race are an ancient and old one.  They have told us much but we understand very little of them.  Wisdom does not seem to serve any useful purpose or maybe does not apply to us.  We have not ever heard of or located the Nyssian home world." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="Tell us about the Minex.",
		alien={"The Minex are a mystery to us.  They do not share knowledge and will destroy our ships if we go to their territory, but they are not hostile if we leave them alone.  We have no knowledge of planets in Minex territory." }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="Tell us about the Bar-zhon and the Coalition.",
		alien={"The Bar-zhon we do trade with for many things.  They like the many unusual minerals we can mine from our worlds, and in exchange they sometimes give us technology.  We do not understand why then is that they act as if they do not like us.  The Bar-zhon home world is at Midir V - 201,105." }
	}
	questions[23001] = {
		action="jump", goto=23002,
		player="<More>",
		alien={"The Coalition, we know as the Bar-zhon, yet different they act, and with great antagonism do they treat each other.  We have learned that as long as we do not mention our dealings with the other faction neither side will attack us.  Most of our best smartest technology has come from the Coalition." }
	}
	questions[23002] = {
		action="jump", goto=20001,
		player="<More>",
		alien={"The Coalition organization is set up in independent cell groups, but they will not discuss it with outsiders.  They have a new trading center somewhere upspin of Bar-zhon territory.  Traditionally, their temporary bases have been located on asteroids." }
	}
	questions[24000] = {
		action="jump", goto=20001,
		player="Tell us about the extinct races.",
		alien={"We have learned of the extinct races, the Sabion, the Bx, and the Transmodra but are unable to find their old homeworlds or where they lived.  We know that the Bar-zhon know more about these races but they do not like to tell us for some reason." }
	}

	questions[1101] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your history?",  goto=1100 },
			{ text="What does your race offer us for trade?", goto=1200 },
			{ text="What system of government do you have?", goto=1300 },
			{ text="Can you tell us more about your technology?", goto=1400 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[1100] = {
		action="jump", goto=1111,
		player="What can you tell us about your history?",
		alien={"First our people discovered reading and writing, next we discovered computers, then we discovered how to interface and live with our computers.  The heart of our people is adaptation and learning." }
	}
	questions[1200] = {
		action="jump", goto=1211,
		player="What does your race offer us for trade?",
		alien={"Not here but at our home world we barter for minerals and fuel.  We don't understand what other races call money.  Some of us like to act, others like to view, still others like to create or produce." }
	}
	questions[1300] = {
		action="jump", goto=1311,
		player="What system of government do you have?",
		alien={"Government?  You mean Leaders?  We do not have a stratified society.  If there is a question then the best answer found will answer it.  If there is a dispute then the arguments are broadcast until the best answer is resulted.  The one who is confronted by the decision is the one who has to make the decision." }
	}
	questions[1400] = {
		action="jump", goto=1411,
		player="Can you tell us more about your technology?",
		alien={"We only recently encapsulated space travel.  One who wanders discovered a bright star fall.  The star falls sometimes give us new medals if they do not kill people or misfortune in lava pools.  The star fall was a Bar-zhon supply ship which taught us shipbuilding." }
	}
	questions[1111] = {
		action="branch",
		choices = {
			{ text="Why would you need to live with your computers?",  goto=1110 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1110] = {
		action="jump", goto=1112,
		player="Why would you need to live with your computers?",
		alien={"We make short-term recordings of our experiences and if we choose can broadcast those experiences to our network.  When we are not working we enjoy browsing the broadcast experiences of others." }
	}
	questions[1112] = {
		action="branch",
		choices = {
			{ text="Experiences?  You mean you share stories?",  goto=1113 },
			{ text="How would you find good experiences?",  goto=1114 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1113] = {
		action="jump", goto=1112,
		player="Experiences?  You mean you share stories?",
		alien={"No, we transmit full complete sensory experiences with cybernetic jacked up. Good experiences we mark as good, and as these experiences get more marks.  With training simultaneous work of duties and feeling of experiences can be performed without the attention loss." }
	}
	questions[1114] = {
		action="jump", goto=1112,
		player="How would you find good experiences?",
		alien={"We use a fuzzy logic adaptive ranking system based on feedback.  Some of our people spend almost their entire lives viewing and ranking the broadcasts of others, which in turn makes top-rated experiences more valuable." }
	}
	questions[1211] = {
		action="branch",
		choices = {
			{ text="How do you trade without using money?",  goto=1220 },
			{ text="So what DOES your race offer us for trade?",  goto=1230 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1220] = {
		action="jump", goto=1211,
		player="How do you trade without using money?",
		alien={"Barter we invent when you aliens start taking and never giving.  Is not money imaginary?  What can you do with it if the alien who gives it to you leaves?" }
	}
	questions[1230] = {
		action="jump", goto=1211,
		player="So what DOES your race offer us for trade?",
		alien={"Minerals and stuff. We are not merchants, we explore. Go find the merchants and ask them." }
	}

	questions[1311] = {
		action="branch",
		choices = {
			{ text="How do you handle criminals with no government?",  goto=1310 },
			{ text="Won't your system have everyone killing each other?", goto=1320 },
			{ text="Your system sounds like anarchy.", goto=1330 },
			{ text="So your people have thought police?", goto=1340 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1310] = {
		action="jump", goto=1312,
		player="How do you handle criminals with no government?",
		alien={"Other races we know have this strange concept they call law.  What is law besides some bullies deciding that some deviancy is good, more deviancy is only a little bad, and some deviancy is very bad?" }
	}
	questions[1320] = {
		action="jump", goto=1311,
		player="Won't your system have everyone killing each other?",
		alien={"Eventually the stable ones live and the unstable die.  All of us are born equal.  When we see other aliens with leaders all of them have two sets of laws.  The laws for leaders, which are lax and easy, and the laws for everyone else, which are strict.  Isn't that insane?" }
	}
	questions[1330] = {
		action="jump", goto=1311,
		player="Your system sounds like anarchy.",
		alien={"<Translating>. I understand. No it is not." }
	}
	questions[1340] = {
		action="jump", goto=1311,
		player="So your people have thought police?",
		alien={"No. The thoughts and experiences of all are cherished and protected, even the thoughts of deviants.  Only when the deviants act on their thoughts they are negative must be destroyed." }
	}
	questions[1312] = {
		action="branch",
		choices = {
			{ text="How do you know if someone is deviant if you don't use law?",  goto=1313 },
			{ text="How do you find the criminals...  umm deviants?", goto=1314 },
			{ text="Have your people never fought a war?", goto=1315 },
			{ text="Wouldn't a strong leader with organization be better?", goto=1316 },
			{ text="<Back>", goto=1311 }
		}
	}
	questions[1313] = {
		action="jump", goto=1312,
		player="How do you know if someone is deviant if you don't use law?",
		alien={"Every youngling knows what is deviant or not deviant, and any act of deviancy results in the destruction of the deviant.  Enforcement is easy, a deviant act must hurt someone or make a victim or it is not any act of deviancy." }
	}
	questions[1314] = {
		action="jump", goto=1312,
		player="How do you find the criminals...  umm deviants?",
		alien={"All of us communicate.  A victim simply chooses to transmit their experience and then the act is discovered.  If there is no victim it is not deviant.  Self-destruction is not deviant, it is an act of choosing future inaction." }
	}
	questions[1315] = {
		action="jump", goto=1312,
		player="Have your people never fought a war?",
		alien={"We do understand the idea of rebels like the coalition, but not how they are tolerated. If one commits action that is negative, then we destroy the negative person." }
	}
	questions[1316] = {
		action="jump", goto=1312,
		player="Wouldn't a strong leader with organization be better?",
		alien={"If a leader had a good idea then we would follow the idea, not the leader. If the leader ran out of ideas, we would leave him alone.  If some so-called leader tried to make others do deviant behavior, then his previous followers would ignore him." }
	}

	questions[1411] = {
		action="branch",
		choices = {
			{ text="So your spaceships are built with Bar-zhon technology?",  goto=1410 },
			{ text="Your people appear friendly. Let's form an alliance.", goto=1420 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1410] = {
		action="jump", goto=1411,
		player="So your spaceships are built with Bar-zhon technology?",
		alien={"Yes, but much was lost. It took us 5 cycles of our sun to figure out bird flight with this technology, and another 70 cycles to figure out how to get into space.  We wish to learn from you and figure out more and will gladly share what we have learned with our friends." }
	}
	questions[1420] = {
		action="jump", goto=1411,
		player="Your people appear friendly. Let's form an alliance.",
		alien={"We greatly desire to find alien artifacts and technology also.  We have found many ancient ruins in our travels but only rarely do we find technology up with them. Our home world is the second lava planet of Oende 2 - 134,30.  You are welcome there." }
	}

	questions[2101] = {
		action="branch",
		choices = {
			{ text="Vermin desease carrying rodents we exterminate.",  goto=2102 },
			{ text="Never mind", goto=1 }
		}
	}
	questions[2102] = {
		action="jump", goto=2103,
		player="Vermin desease carrying rodents we exterminate.",
		alien={"Kayyai! Alien deviants!  May your people judge you or save them time and fly into a star." }
	}
	questions[2103] = {
		action="attack",
		player="We do not plan to fly into a star.  Hello?",
		alien={"<Silence>" }
	}
	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"The virus continues to decimate us.  Minex no longer attack, and we hear humans are responsible for stopping them.  Thank you for this." }
	}
	questions[60001] = {
	action="branch",
	choices = {
		{ text="The Minex have stories of an a telepathic enemy 'The Uyo'  They supposedly created this virus but were stopped by the ancients.", goto=61000 },
		{ text="Any more concerning the virus?", goto=62000 },
		{ text="Do you know anything else related to the ancients?", goto=63000 },
		{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"Historical information the Tafel cannot verify.  We were not there." }
	}
	questions[62000] = {
		action="jump", goto=62001,
		player="",
		alien={"You want to know about cure research or the mad onea?" }
	}
	questions[63000] = {
		action="jump", goto=63001,
		player="",
		alien={"We discovered a sonic weapon found on long lost and also derelict Bx scout ship.  The weapon destroys endurium crystals but does nothing else.  Because sound does not travel in space, nor penetrate most storage containers, we cannot find any practical use for the device." }
	}
	questions[61001] = {
	action="branch",
	choices = {
		{ text="Do you know anything about how to contsct the ancients?", goto=61100 },
		{ text="Have you ever heard of a city of the ancients?", goto=61200 },
		{ text="Does any of your race know anything about telepathy?", goto=61300 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[61100] = {
		action="jump", goto=61001,
		player="",
		alien={"No.  Nothing.  Nada.  We again say no." }
	}
	questions[61200] = {
		action="jump", goto=61001,
		player="",
		alien={"The ancients never had cities that we ever found.  Ancient ruins always are spaced evenly apart from each other and planets containing ruins rarely show variance on ruin placement.  In our many travels we never found or heard a story of a city of the ancients." }
	}
	questions[61300] = {
		action="jump", goto=61301,
		player="",
		alien={"Telepathy?  Our cybernetic implants give us the ability to transmit our thoughts to others when we choose, but natural telepathy is a wishing story told to children." }
	}
	questions[61301] = {
		action="jump", goto=61001,
		player="What type of stories about telepathy?",
		alien={"False ones.  Many stories exist of unwilling mind transfers occurring and transfers without cybernetic technology, but we found no truth in any of these stories.  We often wonder why other races do not want to share our cybernetic mind transfer technology, and maybe some other race may have knowledge about this subject, but we do not know whom to ask." }
	}
	questions[62001] = {
	action="branch",
	choices = {
		{ text="Do you know of any progress towards a cure?", goto=62100 },
		{ text="What about the mad ones?", goto=62200 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[62100] = {
		action="jump", goto=62001,
		player="",
		alien={"No.  More and more strains appear daily.  No sterilization procedure seems to stop strains from appearing." }
	}
	questions[62200] = {
		action="jump", goto=62201,
		player="",
		alien={"Larger numbers of Tafel mad ones are not reverting back to normal.  Since the Minex stopped attacking everyone, huge waves of mad-ones of all species are uniting and attacking the Minex." }
	}
	questions[62201] = {
		action="jump", goto=62001,
		player="How could the mad ones coordinate their attacks?",
		alien={"They don't send electromagnetic signals to each other.  One theory is that some vast consciousness in space must be directing mad ones.  Another is that their minds are being rewritten with some predetermined instruction code." }
	}
	questions[63001] = {
	action="branch",
	choices = {
		{ text="May we have the device?  It may help us find the ancients.", goto=63100 },
		{ text="Where was the Bx derelict ship found?", goto=63200 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[63100] = {
		action="jump", goto=63300,
		player="",
		alien={"We have no use for the device so we do not have it anymore.  We do not keep technology that has no use.  We barter the device to the Coalition for various engine technologies." }
	}
	questions[63200] = {
		action="jump", goto=63001,
		player="",
		alien={"The ship was found at 25,96 but was scuttled for every resource and technology.  You will not find anything there now." }
	}
	questions[63300] = {
		action="jump", goto=63001,
		player="Do you know why the coalition wanted the technology?",
		alien={"Maybe they want to destroy endurium fuel?  All aliens are somewhat crazy insane even when they are not mad." }
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
		alien={"We Tafel usually arrive this way too.  If you go virus crazy we will not hold it against your species after we kill you."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Hello Captain [CAPTAIN].  Tafel ships are things and have no name but we say hello to your ship [SHIPNAME] too."}	}
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Hi explorers!  We Tafel are also all explorers.  We are sick but not mad right now."} }
	greetings[4] = {
		action="",
		player="Dude, that is one gnarly-looking ship you have there!",
		alien={"We Tafel.  Please define dude.  Please define gnarly."} }
	greetings[5] = {
		action="",
		player="How's it going, furry little cyber rodent dudes!",
		alien={"You be mistaken, we is Tafel and not rodent.  We offer assimilation and then you understand difference."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ships seem to be very simple, not very powerful.",
		alien={"Yes, but there are many of us in space, and only one of you."} }
	statements[2] = {
		action="",
		player="Your ships must be cheap to build.",
		alien={"Cheap? What is meaning of this word? Do you mean powerful? Yes, my ship is powerful! Thank you for kind word."} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"Trust hard with mad ones.  Both us appear to be normal so trust is ok."} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"Yes, yes this is our goal.  Exchange is very good.  We seek virus cure","Yes, we exchange words now, exchange more later"} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"Young need to work and not play.  Harmony and friendship are good.","You is strange alien, but words are nice."} }



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=1101,
		player="What can you tell us about yourselves?",
		alien={"'Tafel' information about us we can repeat if you wish.  If you want madness news we could provide some general info about that."}
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="Ugly rat creatures.  Explain your presence here!", goto=2000 },
			{ text="Your ship design appears simple.", goto=3000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[2000] = {
		action="jump", goto=2101,
		player="Ugly rat creatures.  Explain your presence here!",
		alien={"What are rats?"}
	}
	questions[3000] = {
		action="jump", goto=3101,
		player="Your ship design appears simple.",
		alien={"We like simple."}
	}
	questions[3101] = {
		action="jump", goto=1,
		player="I mean your ships must be cheap to build.",
		alien={"Because we do this, there are many of us in space and only a few of you."}
	}
	questions[30000] = {
		action="jump", goto=1,
		player="Can you tell us anything about the past?",
		alien={"We know little of the long past and do not dwell there.  The past is a distraction that traps the mind on something that prevents the trapped one from living and forming new action.  We only deal with fact and don't value stories which we have no way of verifying truth and have little relevance to our lives."}
	}
	questions[40000] = {
		action="jump", goto=4001,
		player="Can you tell us anything about the ancients?",
		alien={"No."}
	}
	questions[4001] = {
		action="jump", goto=4002,
		player="Sure you don't want to talk about Ancients?",
		alien={"No, again, no, again. Are you a negative?"}
	}
	questions[4002] = {
		action="jump", goto=4003,
		player="If you said something about the ancients what would it be?",
		alien={"Negative alien being quiet idiot, but friend is positive."}
	}
	questions[4003] = {
		action="jump", goto=4004,
		player="Do you know where ancient artifacts can be found?",
		alien={"We greatly desire to find alien artifacts and technology also."}
	}
	questions[4004] = {
		action="jump", goto=1,
		player="Really? Where can we find them?",
		alien={"We have found many ancient ruins in our travels but only rarely do we find technology up with them."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about other races?",
		alien={"The alien race you wish to know is not stated.  You mean the Nyssian, the Minex, the Bar-zhon and Coalition, or the extinct races?"}
	}
	questions[20001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Nyssian.",  goto=21000 },
			{ text="Tell us about the Minex.", goto=22000 },
			{ text="Tell us about the Bar-zhon and the Coalition.", goto=23000 },
			{ text="Tell us about the extinct races.", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="Tell us about the Nyssian.",
		alien={"The Nyssian race are an ancient and old one.  They have told us much but we understand very little of them.  Wisdom does not seem to serve any useful purpose or maybe does not apply to us.  We have not ever heard of or located the Nyssian home world." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="Tell us about the Minex.",
		alien={"The Minex are a mystery to us.  They do not share knowledge and will destroy our ships if we go to their territory, but they are not hostile if we leave them alone.  We have no knowledge of planets in Minex territory." }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="Tell us about the Bar-zhon and the Coalition.",
		alien={"The Bar-zhon we do trade with for many things.  They like the many unusual minerals we can mine from our worlds, and in exchange they sometimes give us technology.  We do not understand why then is that they act as if they do not like us.  The Bar-zhon home world is at Midir V - 201,105." }
	}
	questions[23001] = {
		action="jump", goto=23002,
		player="<More>",
		alien={"The Coalition, we know as the Bar-zhon, yet different they act, and with great antagonism do they treat each other.  We have learned that as long as we do not mention our dealings with the other faction neither side will attack us.  Most of our best smartest technology has come from the Coalition." }
	}
	questions[23002] = {
		action="jump", goto=20001,
		player="<More>",
		alien={"The Coalition organization is set up in independent cell groups, but they will not discuss it with outsiders.  They have a new trading center somewhere upspin of Bar-zhon territory.  Traditionally, their temporary bases have been located on asteroids." }
	}
	questions[24000] = {
		action="jump", goto=20001,
		player="Tell us about the extinct races.",
		alien={"We have learned of the extinct races, the Sabion, the Bx, and the Transmodra but are unable to find their old homeworlds or where they lived.  We know that the Bar-zhon know more about these races but they do not like to tell us for some reason." }
	}

	questions[1101] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your history?",  goto=1100 },
			{ text="What does your race offer us for trade?", goto=1200 },
			{ text="What system of government do you have?", goto=1300 },
			{ text="Can you tell us more about your technology?", goto=1400 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[1100] = {
		action="jump", goto=1111,
		player="What can you tell us about your history?",
		alien={"First our people discovered reading and writing, next we discovered computers, then we discovered how to interface and live with our computers.  The heart of our people is adaptation and learning." }
	}
	questions[1200] = {
		action="jump", goto=1211,
		player="What does your race offer us for trade?",
		alien={"Not here but at our home world we barter for minerals and fuel.  We don't understand what other races call money.  Some of us like to act, others like to view, still others like to create or produce." }
	}
	questions[1300] = {
		action="jump", goto=1311,
		player="What system of government do you have?",
		alien={"Government?  You mean Leaders?  We do not have a stratified society.  If there is a question then the best answer found will answer it.  If there is a dispute then the arguments are broadcast until the best answer is resulted.  The one who is confronted by the decision is the one who has to make the decision." }
	}
	questions[1400] = {
		action="jump", goto=1411,
		player="Can you tell us more about your technology?",
		alien={"We only recently encapsulated space travel.  One who wanders discovered a bright star fall.  The star falls sometimes give us new medals if they do not kill people or misfortune in lava pools.  The star fall was a Bar-zhon supply ship which taught us shipbuilding." }
	}
	questions[1111] = {
		action="branch",
		choices = {
			{ text="Why would you need to live with your computers?",  goto=1110 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1110] = {
		action="jump", goto=1112,
		player="Why would you need to live with your computers?",
		alien={"We make short-term recordings of our experiences and if we choose can broadcast those experiences to our network.  When we are not working we enjoy browsing the broadcast experiences of others." }
	}
	questions[1112] = {
		action="branch",
		choices = {
			{ text="Experiences?  You mean you share stories?",  goto=1113 },
			{ text="How would you find good experiences?",  goto=1114 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1113] = {
		action="jump", goto=1112,
		player="Experiences?  You mean you share stories?",
		alien={"No, we transmit full complete sensory experiences with cybernetic jacked up. Good experiences we mark as good, and as these experiences get more marks.  With training simultaneous work of duties and feeling of experiences can be performed without the attention loss." }
	}
	questions[1114] = {
		action="jump", goto=1112,
		player="How would you find good experiences?",
		alien={"We use a fuzzy logic adaptive ranking system based on feedback.  Some of our people spend almost their entire lives viewing and ranking the broadcasts of others, which in turn makes top-rated experiences more valuable." }
	}
	questions[1211] = {
		action="branch",
		choices = {
			{ text="How do you trade without using money?",  goto=1220 },
			{ text="So what DOES your race offer us for trade?",  goto=1230 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1220] = {
		action="jump", goto=1211,
		player="How do you trade without using money?",
		alien={"Barter we invent when you aliens start taking and never giving.  Is not money imaginary?  What can you do with it if the alien who gives it to you leaves?" }
	}
	questions[1230] = {
		action="jump", goto=1211,
		player="So what DOES your race offer us for trade?",
		alien={"Minerals and stuff. We are not merchants, we explore. Go find the merchants and ask them." }
	}

	questions[1311] = {
		action="branch",
		choices = {
			{ text="How do you handle criminals with no government?",  goto=1310 },
			{ text="Won't your system have everyone killing each other?", goto=1320 },
			{ text="Your system sounds like anarchy.", goto=1330 },
			{ text="So your people have thought police?", goto=1340 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1310] = {
		action="jump", goto=1312,
		player="How do you handle criminals with no government?",
		alien={"Other races we know have this strange concept they call law.  What is law besides some bullies deciding that some deviancy is good, more deviancy is only a little bad, and some deviancy is very bad?" }
	}
	questions[1320] = {
		action="jump", goto=1311,
		player="Won't your system have everyone killing each other?",
		alien={"Eventually the stable ones live and the unstable die.  All of us are born equal.  When we see other aliens with leaders all of them have two sets of laws.  The laws for leaders, which are lax and easy, and the laws for everyone else, which are strict.  Isn't that insane?" }
	}
	questions[1330] = {
		action="jump", goto=1311,
		player="Your system sounds like anarchy.",
		alien={"<Translating>. I understand. No it is not." }
	}
	questions[1340] = {
		action="jump", goto=1311,
		player="So your people have thought police?",
		alien={"No. The thoughts and experiences of all are cherished and protected, even the thoughts of deviants.  Only when the deviants act on their thoughts they are negative must be destroyed." }
	}
	questions[1312] = {
		action="branch",
		choices = {
			{ text="How do you know if someone is deviant if you don't use law?",  goto=1313 },
			{ text="How do you find the criminals...  umm deviants?", goto=1314 },
			{ text="Have your people never fought a war?", goto=1315 },
			{ text="Wouldn't a strong leader with organization be better?", goto=1316 },
			{ text="<Back>", goto=1311 }
		}
	}
	questions[1313] = {
		action="jump", goto=1312,
		player="How do you know if someone is deviant if you don't use law?",
		alien={"Every youngling knows what is deviant or not deviant, and any act of deviancy results in the destruction of the deviant.  Enforcement is easy, a deviant act must hurt someone or make a victim or it is not any act of deviancy." }
	}
	questions[1314] = {
		action="jump", goto=1312,
		player="How do you find the criminals...  umm deviants?",
		alien={"All of us communicate.  A victim simply chooses to transmit their experience and then the act is discovered.  If there is no victim it is not deviant.  Self-destruction is not deviant, it is an act of choosing future inaction." }
	}
	questions[1315] = {
		action="jump", goto=1312,
		player="Have your people never fought a war?",
		alien={"We do understand the idea of rebels like the coalition, but not how they are tolerated. If one commits action that is negative, then we destroy the negative person." }
	}
	questions[1316] = {
		action="jump", goto=1312,
		player="Wouldn't a strong leader with organization be better?",
		alien={"If a leader had a good idea then we would follow the idea, not the leader. If the leader ran out of ideas, we would leave him alone.  If some so-called leader tried to make others do deviant behavior, then his previous followers would ignore him." }
	}

	questions[1411] = {
		action="branch",
		choices = {
			{ text="So your spaceships are built with Bar-zhon technology?",  goto=1410 },
			{ text="Your people appear friendly. Let's form an alliance.", goto=1420 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1410] = {
		action="jump", goto=1411,
		player="So your spaceships are built with Bar-zhon technology?",
		alien={"Yes, but much was lost. It took us 5 cycles of our sun to figure out bird flight with this technology, and another 70 cycles to figure out how to get into space.  We wish to learn from you and figure out more and will gladly share what we have learned with our friends." }
	}
	questions[1420] = {
		action="jump", goto=1411,
		player="Your people appear friendly. Let's form an alliance.",
		alien={"We greatly desire to find alien artifacts and technology also.  We have found many ancient ruins in our travels but only rarely do we find technology up with them. Our home world is the second lava planet of Oende 2 - 134,30.  You are welcome there." }
	}

	questions[2101] = {
		action="branch",
		choices = {
			{ text="Vermin desease carrying rodents we exterminate.",  goto=2102 },
			{ text="Never mind", goto=1 }
		}
	}
	questions[2102] = {
		action="jump", goto=2103,
		player="Vermin desease carrying rodents we exterminate.",
		alien={"Kayyai! Alien deviants!  May your people judge you or save them time and fly into a star." }
	}
	questions[2103] = {
		action="attack",
		player="We do not plan to fly into a star.  Hello?",
		alien={"<Silence>" }
	}
	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"The virus continues to decimate us.  Minex no longer attack, and we hear humans are responsible for stopping them.  Thank you for this." }
	}
	questions[60001] = {
	action="branch",
	choices = {
		{ text="The Minex have stories of an a telepathic enemy 'The Uyo'  They supposedly created this virus but were stopped by the ancients.", goto=61000 },
		{ text="Any more concerning the virus?", goto=62000 },
		{ text="Do you know anything else related to the ancients?", goto=63000 },
		{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"Historical information the Tafel cannot verify.  We were not there." }
	}
	questions[62000] = {
		action="jump", goto=62001,
		player="",
		alien={"You want to know about cure research or the mad onea?" }
	}
	questions[63000] = {
		action="jump", goto=63001,
		player="",
		alien={"We discovered a sonic weapon found on long lost and also derelict Bx scout ship.  The weapon destroys endurium crystals but does nothing else.  Because sound does not travel in space, nor penetrate most storage containers, we cannot find any practical use for the device." }
	}
	questions[61001] = {
	action="branch",
	choices = {
		{ text="Do you know anything about how to contsct the ancients?", goto=61100 },
		{ text="Have you ever heard of a city of the ancients?", goto=61200 },
		{ text="Does any of your race know anything about telepathy?", goto=61300 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[61100] = {
		action="jump", goto=61001,
		player="",
		alien={"No.  Nothing.  Nada.  We again say no." }
	}
	questions[61200] = {
		action="jump", goto=61001,
		player="",
		alien={"The ancients never had cities that we ever found.  Ancient ruins always are spaced evenly apart from each other and planets containing ruins rarely show variance on ruin placement.  In our many travels we never found or heard a story of a city of the ancients." }
	}
	questions[61300] = {
		action="jump", goto=61301,
		player="",
		alien={"Telepathy?  Our cybernetic implants give us the ability to transmit our thoughts to others when we choose, but natural telepathy is a wishing story told to children." }
	}
	questions[61301] = {
		action="jump", goto=61001,
		player="What type of stories about telepathy?",
		alien={"False ones.  Many stories exist of unwilling mind transfers occurring and transfers without cybernetic technology, but we found no truth in any of these stories.  We often wonder why other races do not want to share our cybernetic mind transfer technology, and maybe some other race may have knowledge about this subject, but we do not know whom to ask." }
	}
	questions[62001] = {
	action="branch",
	choices = {
		{ text="Do you know of any progress towards a cure?", goto=62100 },
		{ text="What about the mad ones?", goto=62200 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[62100] = {
		action="jump", goto=62001,
		player="",
		alien={"No.  More and more strains appear daily.  No sterilization procedure seems to stop strains from appearing." }
	}
	questions[62200] = {
		action="jump", goto=62201,
		player="",
		alien={"Larger numbers of Tafel mad ones are not reverting back to normal.  Since the Minex stopped attacking everyone, huge waves of mad-ones of all species are uniting and attacking the Minex." }
	}
	questions[62201] = {
		action="jump", goto=62001,
		player="How could the mad ones coordinate their attacks?",
		alien={"They don't send electromagnetic signals to each other.  One theory is that some vast consciousness in space must be directing mad ones.  Another is that their minds are being rewritten with some predetermined instruction code." }
	}
	questions[63001] = {
	action="branch",
	choices = {
		{ text="May we have the device?  It may help us find the ancients.", goto=63100 },
		{ text="Where was the Bx derelict ship found?", goto=63200 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[63100] = {
		action="jump", goto=63300,
		player="",
		alien={"We have no use for the device so we do not have it anymore.  We do not keep technology that has no use.  We barter the device to the Coalition for various engine technologies." }
	}
	questions[63200] = {
		action="jump", goto=63001,
		player="",
		alien={"The ship was found at 25,96 but was scuttled for every resource and technology.  You will not find anything there now." }
	}
	questions[63300] = {
		action="jump", goto=63001,
		player="Do you know why the coalition wanted the technology?",
		alien={"Maybe they want to destroy endurium fuel?  All aliens are somewhat crazy insane even when they are not mad." }
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
		alien={"Not take destroyed.  Identify sound better.  Identity is not-mad Tafel.","Tafel is.  Not us virus deviant.  Risky statement is most"} }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"Is not comprehend.  We Tafel have legs and are not heavy, is floating in space."}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"Tafel is ignore powerful unless powerful and also crazy!  Is you be infected right now?"} }
	greetings[4] = {
		action="attack",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"Crazed infected ones, may a star flare as you pass it!"} }
	greetings[5] = {
		action="attack",
		player="We require information. Comply or be destroyed.",
		alien={"Your insanity has no justification, kill yourselves for your people sake.  We will try to help."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ships are primitive and weak.",
		alien={"We have strength in numbers which you shall put to the test very soon!"} }
	statements[2] = {
		action="",
		player="Vermin desease carrying rodents we exterminate on our homeworld.",
		alien={"At Kayyai, you alien negatives! Virus talking or you talking?  If only you then may your people judge you or save them time and crash into the sun."} }
	statements[3] = {
		action="",
		player="LOL! What a piece of junk!",
		alien={"What is meaning of 'Lol'? You mad infected right now or is this form of flattery?"} }
	statements[4] = {
		action="terminate",
		player="Your ship looks like a flying garbage scow.",
		alien={"YOU'RE a flying garbage scow, crazed alien!"} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=1101,
		player="What can you tell us about yourselves?",
		alien={"'Tafel' information about us we can repeat if you wish.  If you want madness news we could provide some general info about that."}
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="Ugly rat creatures.  Explain your presence here!", goto=2000 },
			{ text="Your ship design appears simple.", goto=3000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[2000] = {
		action="jump", goto=2101,
		player="Ugly rat creatures.  Explain your presence here!",
		alien={"What are rats?"}
	}
	questions[3000] = {
		action="jump", goto=3101,
		player="Your ship design appears simple.",
		alien={"We like simple."}
	}
	questions[3101] = {
		action="jump", goto=1,
		player="I mean your ships must be cheap to build.",
		alien={"Because we do this, there are many of us in space and only a few of you."}
	}
	questions[30000] = {
		action="jump", goto=1,
		player="Can you tell us anything about the past?",
		alien={"We know little of the long past and do not dwell there.  The past is a distraction that traps the mind on something that prevents the trapped one from living and forming new action.  We only deal with fact and don't value stories which we have no way of verifying truth and have little relevance to our lives."}
	}
	questions[40000] = {
		action="jump", goto=4001,
		player="Can you tell us anything about the ancients?",
		alien={"No."}
	}
	questions[4001] = {
		action="jump", goto=4002,
		player="Sure you don't want to talk about Ancients?",
		alien={"No, again, no, again. Are you a negative?"}
	}
	questions[4002] = {
		action="jump", goto=4003,
		player="If you said something about the ancients what would it be?",
		alien={"Negative alien being quiet idiot, but friend is positive."}
	}
	questions[4003] = {
		action="jump", goto=4004,
		player="Do you know where ancient artifacts can be found?",
		alien={"We greatly desire to find alien artifacts and technology also."}
	}
	questions[4004] = {
		action="jump", goto=1,
		player="Really? Where can we find them?",
		alien={"We have found many ancient ruins in our travels but only rarely do we find technology up with them."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about other races?",
		alien={"The alien race you wish to know is not stated.  You mean the Nyssian, the Minex, the Bar-zhon and Coalition, or the extinct races?"}
	}
	questions[20001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Nyssian.",  goto=21000 },
			{ text="Tell us about the Minex.", goto=22000 },
			{ text="Tell us about the Bar-zhon and the Coalition.", goto=23000 },
			{ text="Tell us about the extinct races.", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="Tell us about the Nyssian.",
		alien={"The Nyssian race are an ancient and old one.  They have told us much but we understand very little of them.  Wisdom does not seem to serve any useful purpose or maybe does not apply to us.  We have not ever heard of or located the Nyssian home world." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="Tell us about the Minex.",
		alien={"The Minex are a mystery to us.  They do not share knowledge and will destroy our ships if we go to their territory, but they are not hostile if we leave them alone.  We have no knowledge of planets in Minex territory." }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="Tell us about the Bar-zhon and the Coalition.",
		alien={"The Bar-zhon we do trade with for many things.  They like the many unusual minerals we can mine from our worlds, and in exchange they sometimes give us technology.  We do not understand why then is that they act as if they do not like us.  The Bar-zhon home world is at Midir V - 201,105." }
	}
	questions[23001] = {
		action="jump", goto=23002,
		player="<More>",
		alien={"The Coalition, we know as the Bar-zhon, yet different they act, and with great antagonism do they treat each other.  We have learned that as long as we do not mention our dealings with the other faction neither side will attack us.  Most of our best smartest technology has come from the Coalition." }
	}
	questions[23002] = {
		action="jump", goto=20001,
		player="<More>",
		alien={"The Coalition organization is set up in independent cell groups, but they will not discuss it with outsiders.  They have a new trading center somewhere upspin of Bar-zhon territory.  Traditionally, their temporary bases have been located on asteroids." }
	}
	questions[24000] = {
		action="jump", goto=20001,
		player="Tell us about the extinct races.",
		alien={"We have learned of the extinct races, the Sabion, the Bx, and the Transmodra but are unable to find their old homeworlds or where they lived.  We know that the Bar-zhon know more about these races but they do not like to tell us for some reason." }
	}

	questions[1101] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your history?",  goto=1100 },
			{ text="What does your race offer us for trade?", goto=1200 },
			{ text="What system of government do you have?", goto=1300 },
			{ text="Can you tell us more about your technology?", goto=1400 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[1100] = {
		action="jump", goto=1111,
		player="What can you tell us about your history?",
		alien={"First our people discovered reading and writing, next we discovered computers, then we discovered how to interface and live with our computers.  The heart of our people is adaptation and learning." }
	}
	questions[1200] = {
		action="jump", goto=1211,
		player="What does your race offer us for trade?",
		alien={"Not here but at our home world we barter for minerals and fuel.  We don't understand what other races call money.  Some of us like to act, others like to view, still others like to create or produce." }
	}
	questions[1300] = {
		action="jump", goto=1311,
		player="What system of government do you have?",
		alien={"Government?  You mean Leaders?  We do not have a stratified society.  If there is a question then the best answer found will answer it.  If there is a dispute then the arguments are broadcast until the best answer is resulted.  The one who is confronted by the decision is the one who has to make the decision." }
	}
	questions[1400] = {
		action="jump", goto=1411,
		player="Can you tell us more about your technology?",
		alien={"We only recently encapsulated space travel.  One who wanders discovered a bright star fall.  The star falls sometimes give us new medals if they do not kill people or misfortune in lava pools.  The star fall was a Bar-zhon supply ship which taught us shipbuilding." }
	}
	questions[1111] = {
		action="branch",
		choices = {
			{ text="Why would you need to live with your computers?",  goto=1110 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1110] = {
		action="jump", goto=1112,
		player="Why would you need to live with your computers?",
		alien={"We make short-term recordings of our experiences and if we choose can broadcast those experiences to our network.  When we are not working we enjoy browsing the broadcast experiences of others." }
	}
	questions[1112] = {
		action="branch",
		choices = {
			{ text="Experiences?  You mean you share stories?",  goto=1113 },
			{ text="How would you find good experiences?",  goto=1114 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1113] = {
		action="jump", goto=1112,
		player="Experiences?  You mean you share stories?",
		alien={"No, we transmit full complete sensory experiences with cybernetic jacked up. Good experiences we mark as good, and as these experiences get more marks.  With training simultaneous work of duties and feeling of experiences can be performed without the attention loss." }
	}
	questions[1114] = {
		action="jump", goto=1112,
		player="How would you find good experiences?",
		alien={"We use a fuzzy logic adaptive ranking system based on feedback.  Some of our people spend almost their entire lives viewing and ranking the broadcasts of others, which in turn makes top-rated experiences more valuable." }
	}
	questions[1211] = {
		action="branch",
		choices = {
			{ text="How do you trade without using money?",  goto=1220 },
			{ text="So what DOES your race offer us for trade?",  goto=1230 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1220] = {
		action="jump", goto=1211,
		player="How do you trade without using money?",
		alien={"Barter we invent when you aliens start taking and never giving.  Is not money imaginary?  What can you do with it if the alien who gives it to you leaves?" }
	}
	questions[1230] = {
		action="jump", goto=1211,
		player="So what DOES your race offer us for trade?",
		alien={"Minerals and stuff. We are not merchants, we explore. Go find the merchants and ask them." }
	}

	questions[1311] = {
		action="branch",
		choices = {
			{ text="How do you handle criminals with no government?",  goto=1310 },
			{ text="Won't your system have everyone killing each other?", goto=1320 },
			{ text="Your system sounds like anarchy.", goto=1330 },
			{ text="So your people have thought police?", goto=1340 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1310] = {
		action="jump", goto=1312,
		player="How do you handle criminals with no government?",
		alien={"Other races we know have this strange concept they call law.  What is law besides some bullies deciding that some deviancy is good, more deviancy is only a little bad, and some deviancy is very bad?" }
	}
	questions[1320] = {
		action="jump", goto=1311,
		player="Won't your system have everyone killing each other?",
		alien={"Eventually the stable ones live and the unstable die.  All of us are born equal.  When we see other aliens with leaders all of them have two sets of laws.  The laws for leaders, which are lax and easy, and the laws for everyone else, which are strict.  Isn't that insane?" }
	}
	questions[1330] = {
		action="jump", goto=1311,
		player="Your system sounds like anarchy.",
		alien={"<Translating>. I understand. No it is not." }
	}
	questions[1340] = {
		action="jump", goto=1311,
		player="So your people have thought police?",
		alien={"No. The thoughts and experiences of all are cherished and protected, even the thoughts of deviants.  Only when the deviants act on their thoughts they are negative must be destroyed." }
	}
	questions[1312] = {
		action="branch",
		choices = {
			{ text="How do you know if someone is deviant if you don't use law?",  goto=1313 },
			{ text="How do you find the criminals...  umm deviants?", goto=1314 },
			{ text="Have your people never fought a war?", goto=1315 },
			{ text="Wouldn't a strong leader with organization be better?", goto=1316 },
			{ text="<Back>", goto=1311 }
		}
	}
	questions[1313] = {
		action="jump", goto=1312,
		player="How do you know if someone is deviant if you don't use law?",
		alien={"Every youngling knows what is deviant or not deviant, and any act of deviancy results in the destruction of the deviant.  Enforcement is easy, a deviant act must hurt someone or make a victim or it is not any act of deviancy." }
	}
	questions[1314] = {
		action="jump", goto=1312,
		player="How do you find the criminals...  umm deviants?",
		alien={"All of us communicate.  A victim simply chooses to transmit their experience and then the act is discovered.  If there is no victim it is not deviant.  Self-destruction is not deviant, it is an act of choosing future inaction." }
	}
	questions[1315] = {
		action="jump", goto=1312,
		player="Have your people never fought a war?",
		alien={"We do understand the idea of rebels like the coalition, but not how they are tolerated. If one commits action that is negative, then we destroy the negative person." }
	}
	questions[1316] = {
		action="jump", goto=1312,
		player="Wouldn't a strong leader with organization be better?",
		alien={"If a leader had a good idea then we would follow the idea, not the leader. If the leader ran out of ideas, we would leave him alone.  If some so-called leader tried to make others do deviant behavior, then his previous followers would ignore him." }
	}

	questions[1411] = {
		action="branch",
		choices = {
			{ text="So your spaceships are built with Bar-zhon technology?",  goto=1410 },
			{ text="Your people appear friendly. Let's form an alliance.", goto=1420 },
			{ text="<Back>", goto=1101 }
		}
	}
	questions[1410] = {
		action="jump", goto=1411,
		player="So your spaceships are built with Bar-zhon technology?",
		alien={"Yes, but much was lost. It took us 5 cycles of our sun to figure out bird flight with this technology, and another 70 cycles to figure out how to get into space.  We wish to learn from you and figure out more and will gladly share what we have learned with our friends." }
	}
	questions[1420] = {
		action="jump", goto=1411,
		player="Your people appear friendly. Let's form an alliance.",
		alien={"We greatly desire to find alien artifacts and technology also.  We have found many ancient ruins in our travels but only rarely do we find technology up with them. Our home world is the second lava planet of Oende 2 - 134,30.  You are welcome there." }
	}

	questions[2101] = {
		action="branch",
		choices = {
			{ text="Vermin desease carrying rodents we exterminate.",  goto=2102 },
			{ text="Never mind", goto=1 }
		}
	}
	questions[2102] = {
		action="jump", goto=2103,
		player="Vermin desease carrying rodents we exterminate.",
		alien={"Kayyai! Alien deviants!  May your people judge you or save them time and fly into a star." }
	}
	questions[2103] = {
		action="attack",
		player="We do not plan to fly into a star.  Hello?",
		alien={"<Silence>" }
	}
	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"The virus continues to decimate us.  Minex no longer attack, and we hear humans are responsible for stopping them.  Thank you for this." }
	}
	questions[60001] = {
	action="branch",
	choices = {
		{ text="The Minex have stories of an a telepathic enemy 'The Uyo'  They supposedly created this virus but were stopped by the ancients.", goto=61000 },
		{ text="Any more concerning the virus?", goto=62000 },
		{ text="Do you know anything else related to the ancients?", goto=63000 },
		{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"Historical information the Tafel cannot verify.  We were not there." }
	}
	questions[62000] = {
		action="jump", goto=62001,
		player="",
		alien={"You want to know about cure research or the mad onea?" }
	}
	questions[63000] = {
		action="jump", goto=63001,
		player="",
		alien={"We discovered a sonic weapon found on long lost and also derelict Bx scout ship.  The weapon destroys endurium crystals but does nothing else.  Because sound does not travel in space, nor penetrate most storage containers, we cannot find any practical use for the device." }
	}
	questions[61001] = {
	action="branch",
	choices = {
		{ text="Do you know anything about how to contsct the ancients?", goto=61100 },
		{ text="Have you ever heard of a city of the ancients?", goto=61200 },
		{ text="Does any of your race know anything about telepathy?", goto=61300 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[61100] = {
		action="jump", goto=61001,
		player="",
		alien={"No.  Nothing.  Nada.  We again say no." }
	}
	questions[61200] = {
		action="jump", goto=61001,
		player="",
		alien={"The ancients never had cities that we ever found.  Ancient ruins always are spaced evenly apart from each other and planets containing ruins rarely show variance on ruin placement.  In our many travels we never found or heard a story of a city of the ancients." }
	}
	questions[61300] = {
		action="jump", goto=61301,
		player="",
		alien={"Telepathy?  Our cybernetic implants give us the ability to transmit our thoughts to others when we choose, but natural telepathy is a wishing story told to children." }
	}
	questions[61301] = {
		action="jump", goto=61001,
		player="What type of stories about telepathy?",
		alien={"False ones.  Many stories exist of unwilling mind transfers occurring and transfers without cybernetic technology, but we found no truth in any of these stories.  We often wonder why other races do not want to share our cybernetic mind transfer technology, and maybe some other race may have knowledge about this subject, but we do not know whom to ask." }
	}
	questions[62001] = {
	action="branch",
	choices = {
		{ text="Do you know of any progress towards a cure?", goto=62100 },
		{ text="What about the mad ones?", goto=62200 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[62100] = {
		action="jump", goto=62001,
		player="",
		alien={"No.  More and more strains appear daily.  No sterilization procedure seems to stop strains from appearing." }
	}
	questions[62200] = {
		action="jump", goto=62201,
		player="",
		alien={"Larger numbers of Tafel mad ones are not reverting back to normal.  Since the Minex stopped attacking everyone, huge waves of mad-ones of all species are uniting and attacking the Minex." }
	}
	questions[62201] = {
		action="jump", goto=62001,
		player="How could the mad ones coordinate their attacks?",
		alien={"They don't send electromagnetic signals to each other.  One theory is that some vast consciousness in space must be directing mad ones.  Another is that their minds are being rewritten with some predetermined instruction code." }
	}
	questions[63001] = {
	action="branch",
	choices = {
		{ text="May we have the device?  It may help us find the ancients.", goto=63100 },
		{ text="Where was the Bx derelict ship found?", goto=63200 },
		{ text="<Back>", goto=60001 }
		}
	}
	questions[63100] = {
		action="jump", goto=63300,
		player="",
		alien={"We have no use for the device so we do not have it anymore.  We do not keep technology that has no use.  We barter the device to the Coalition for various engine technologies." }
	}
	questions[63200] = {
		action="jump", goto=63001,
		player="",
		alien={"The ship was found at 25,96 but was scuttled for every resource and technology.  You will not find anything there now." }
	}
	questions[63300] = {
		action="jump", goto=63001,
		player="Do you know why the coalition wanted the technology?",
		alien={"Maybe they want to destroy endurium fuel?  All aliens are somewhat crazy insane even when they are not mad." }
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


--]]
