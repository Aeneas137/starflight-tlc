--[[------------------------------------------------------------------------------------------------------------------------------------------------- ]
	ENCOUNTER SCRIPT FILE: SPEMIN

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

if (plot_stage == 1) or (plot_stage == 2) then -- virus plot state

	obsequiousGreetTable= {
			"Recognition at last! it is wonderful that you recognize the Spemin by reputation!  Actually who did you talk to?",
			"The mighty and powerful Spemin place ourselves at your disposal.",
			"Welcome supplicants, we have waited long for your arrival.  Actually we have waited forever for your arrival.",
			"In our great power the Spemin know humility. We will show restraint.",
			"You have reached sanctuary!  No more hostile aliens here!  Only Spemin!",
			"We Spemin assist only to exist you.",
			"We Spemin use our vast knowledge and power to teach and instruct. You are safe."
	}

elseif (plot_stage == 3) then -- war plot state

	obsequiousGreetTable= {
			"I am Spemin, I greet you two-eyed slimeless skeletoids.  'Over",
			"Hello [CAPTAIN].  Go ahead ",
			"Uh huh.  Ok.",
			"Sure thing",
			"Okay",
			"Nahh"
	}

elseif (plot_stage == 4) then -- ancients plot state

	obsequiousGreetTable= {
			"kxkxkxkxkxkxkxkxkx",
			"iroiroiroiro",
			"vivivivivi",
			"Ataraxia"
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


if (plot_stage == 1) or (plot_stage == 2) then -- virus plot state

	friendlyGreetTable= {
		"Greetings from the Spemin.  We always come in peace.",
		"We are the Spemin in case you have not heard of us.  Our godlike senses picked you up long ago but we waited until now to contact you.",
		"Welcome seekers.  We are the Spemin.",
		"Reflections of grand Spemin thoughts have penetrated your thinking and guided you here.  Welcome.",
		"Welcome seekers.  Blessings to the Great Blob Goddess.  We are the Spemin."
	}

elseif (plot_stage == 3) then -- war plot state

	friendlyGreetTable= {
			"I am Spemin, I greet you two-eyed slimeless skeletoids.  'Over",
			"Hello [CAPTAIN]. Go ahead ",
			"Uh huh.  Ok.",
			"<Silence>",
			"Okay",
			"<Silence>"
	}

elseif (plot_stage == 4) then -- ancients plot state

	friendlyGreetTable= {
			"kxkxkxkxkxkxkxkxkx",
			"iroiroiroiro",
			"vivivivivi",
			"Ataraxia"
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
		player="Dude, that is one funky ship you have there!",
		alien= friendlyGreetTable }
	greetings[5] = {
		action="",
		player="How's it going, blob thing?",
		alien= friendlyGreetTable }
	greetings[6] = {
		action="",
		player="Greetings.  Your ship seems to be very powerful.",
		alien= friendlyGreetTable }
	greetings[7] = {
		action="",
		player="Hello there.  Your ship appears very unusual.",
		alien= friendlyGreetTable }
	greetings[8] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien= friendlyGreetTable }
	greetings[9] = {
		action="",
		player="Greetings friend!  There is no limit to what both our races can gain from mutual exchange.",
		alien= friendlyGreetTable }
	greetings[10] = {
		action="",
		player="Perhaps some day our young shall play and romp together...uhh...never mind...let us be friends.",
		alien= friendlyGreetTable }

end

------------------------------------------------------------------------
-- HOSTILE DIALOGUE ----------------------------------------------------
------------------------------------------------------------------------
function HostileDialogue()
	--add as many player greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack


if (plot_stage == 1) or (plot_stage == 2) then -- initial and virus plot state

	hostileGreetTable= {
		"Please don't be aggressive.  Talk to our elders.  We Spemin live to the age of 600. Some of the oldest Spemin perhaps to 1000. In your Myrrdan years this would equate to....uh....approximately....4.",
		"We Spemin only wish for peace, love, joy, happiness, and lots of money.",
		"Hi, we're Spemin, not the hostile aliens you think we are.",
		"Don't be mad, we're really just a happy-go-lucky race of zany guys.",
		"Can we be friends instead?",
		"I know, call us crazy, but I guess we're pretty lovable if you get to know us."
	}


elseif (plot_stage == 3) then -- war plot state

	hostileGreetTable= {
			"I am Spemin, I greet you two-eyed slimeless skeletoids.  'Over",
			"Hello [CAPTAIN]. Go ahead ",
			"Uh huh.  Ok.",
			"<Silence>",
			"Okay",
			"<Silence>"
	}

elseif (plot_stage == 4) then -- ancients plot state

	hostileGreetTable= {
			"kxkxkxkxkxkxkxkxkx",
			"iroiroiroiro",
			"vivivivivi",
			"Ataraxia"
	}

end

	greetings[1] = {
		action="",
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
		action="",
		player="We require information. Comply or be destroyed.",
		alien= hostileGreetTable }
	greetings[6] = {
		action="",
		player="Your ship is simple and weak.",
		alien= hostileGreetTable }
	greetings[7] = {
		action="",
		player="What an ugly and worthless creature.",
		alien= hostileGreetTable }
	greetings[8] = {
		action="",
		player="Your ship looks like a flying garbage doughnut.",
		alien= hostileGreetTable }

end

function StandardQuestions()

	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

if (plot_stage == 1) then -- initial plot state

	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"No doubt you wish to become a disciple race of the Spemin.  We are a race of high morals and are eager to find lost followers.  We know you feel strongly about this and are eager to begin your instruction."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"We were born onboard this generational ship sent out to explore the stars and meet other races.  No other Spemin has been as successful as we are!"}
	}
	questions[30000] = {
		action="jump", goto=30001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"You mean stuff that happened before we were alive?  Sure, we have a few records laying around..."}
	}
	questions[40000] = {
		action="jump", goto=40001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the ancients",
		alien={"We Spemin are wise beyond imagining. For example, we happen to know that the ancients built a device called a crystal pearl which automatically warps a critically wounded ship out of danger. This is just one of many things we know." }
	}
	questions[40001] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		playerFragment="about the ancients",
		alien={"Uhh...we don't know anything else..." }
	}

elseif (plot_stage == 2) then -- virus plot state

	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"We are the awesome Spemin.  Masters of this galaxy.  Rulers of all galaxies in fact.  We are also known as the ancients.  We merely let you hostile aliens think that you were destroying our ships, I mean our automated craft, I mean our holograms."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"We were born onboard this generational ship sent out to explore the stars and meet other races.  No one has ever been as successful as we are!"}
	}
	questions[30000] = {
		action="jump", goto=30001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"You mean stuff that happened before we were alive?  Maybe we will and maybe we won't.  Well, ask something and see if we answer."}
	}
	questions[40000] = {
		action="jump", goto=40001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the ancients",
		alien={"We Spemin are the ancients.  I have kept this information to myself until now.  You would be wise not to antagonize me." }
	}
	questions[40001] = {
		action="jump", goto=1,
		player="[AUTO_REPEAT]",
		playerFragment="why your ships are so weak if you are the ancients",fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"These forms you see before you are merely holographic projections.  Do not think to provoke us because we, uhh..., really value our holographic projections!" }
	}

elseif (plot_stage == 3) then -- war plot state

	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"We are the Spemin."}
	}
	questions[20000] = {
		action="jump", goto=20002, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"We of the Royal Spemin navy meet all races with unwavering courage and conviction.  You must envy us with our vast ... umm ... What was your question?"}
	}
	questions[20002] = {
		action="jump", goto=20001,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Ok, will do."}
	}
	questions[30000] = {
		action="jump", goto=30001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"Yeah, so?"}
	}
	questions[40000] = {
		action="jump", goto=40001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the ancients",
		alien={"We were once known as the ancients.  You would be wise not to antagonize us." }
	}
	questions[40001] = {
		action="jump", goto=1,		player="[AUTO_REPEAT]",
		playerFragment="why your ships are so weak if you are the ancients",fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"These forms you see before you are merely holographic projections.  We grant you a boon.  Feel free to collect any of our endurium on Bec-Felmas 3 - 16,183 or Mathgen 4 - 212, 3." }
	}

end

if (plot_stage == 1) then

	questions[50000] = {
		action="branch",
		choices = {
			{ title="Give us all your fuel!", text="I demand that you give us all your fuel!", goto=51000 },
--			{ text="Where is your home world?", goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}
 	questions[51101] = {
		action="jump", goto=51110, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"I'm very sorry, but we have no cargo."}
	}
	questions[51111] = {
		action="jump", goto=51112, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Sure, if this would make you happy.  Just don't kill too many of us please."}
	}
 	questions[51112] = {
		action="jump", goto= 999, -- attack
		player="Uhh, okay, sounds good.",
		alien={"Okay, let's start."}
	}

end

if (plot_stage == 2) or (plot_stage == 3) then

	questions[50000] = {
		action="branch",
		choices = {
			{ title="Give us all your fuel!", text="I demand that you give us all your fuel!", goto=51000 },
--			{ text="Where is your home world?", goto=52000 },
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="<Back>",  goto=1 }
		}
	}
 	questions[51101] = {
		action="jump", goto=51110, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Fools!  You face the Spemin Gods!  Do not incur our wrath!"}
	}
	questions[51111] = {
		action="jump", goto=51112, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Prepare for excruciating pain, unbearable agony, the most horrible of deaths, the most unimaginable torture. Any moment now we shall attack."}
	}
 	questions[51112] = {
		action="jump", goto=997,  ftest= 3, -- aggravating, Terminate
		player="Umm, are you going to attack us?",
		alien={"Any moment now I shall ooze down and absorb you like so much food substance.  Feel free to run."}
	}

end

if (plot_stage == 1) or (plot_stage == 2) or (plot_stage == 3) then

 	questions[51000] = {
		action="jump", goto=51100, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Sure, if you scan our ship you will see that we have a total of 0.2 cubic meters of endurium left.  Our transporter does not work so you will need to board and pick it up yourself.  We are pleased that we can help you."}
	}
	questions[51100] = {
		action="branch",
		choices = {
			{ title="Eject all your cargo!", text="Uhh, never mind about the endurium, eject all your cargo!", goto=51101 },
			{ text="<Back>",  goto=1 }
		}
	}
	questions[51110] = {
		action="branch",
		choices = {
			{ title="Just attack us!", text="Would you please just get upset and attack us!",  goto=51111 },
			{ text="<Back>",  goto=1 }
		}
	}
	questions[52000] = {
		action="jump", goto=52001,
		player="[AUTO_REPEAT]",
		playerFragment="the location of your home world", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"That location is a secret.  You would have to first ask permission of our leaders before we divulged such information."}
	}
	questions[52001] = {
		action="jump", goto=50000,
		player="[AUTO_REPEAT]",
		playerFragment="where your leaders are", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"Oh, you can find them at Dian Cecht 3 - 35,139."}
	}

end

if (plot_stage == 1) or (plot_stage == 2) then

	questions[11001] = {
		action="branch",
		choices = {
			{ text="Government",  goto=11000 },
			{ text="Biology", goto=12000 },
			{ text="Why become disciples?", goto=13000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[12000] = {
		action="jump", goto=12001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about your biology",
		alien={"Of course you stare in wonderment at our beautiful antennae.  These antennae allow us to get 32,000 channels with no need for cable.  In addition they pick up the cosmic vibrations that give us our god-like powers.  They also happen to be very fashionable." }
	}
	questions[12001] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		alien={"The brain of a Spemin is the most complex thing in the universe. In fact, it is so complex that our spemin doctors have, as yet, been unable to determine the exact location of it in the Spemin body." }
	}
	questions[13000] = {
		action="jump", goto=11001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="why we would want to become your disciples", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Because truly the other races are deprived.   No other race can know the pleasures of a Spemin. Ahh, to engulf a fresh glob of protein substance, to bounce a newly budded blobbie on one's pseudopod.  There is a saying among the spemin that sums up our whole philosophy of life. It is - blukbluk durt, smeg! Roughly translated it means 'quivering particle secretes enzyme.' this is just a rough translation." }
	}

	questions[11101] = {
		action="branch",
		choices = {
			{ text="The Great Blob Goddess",  goto=11110 },
			{ text="Communication with your goddess",  goto=11120 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[11112] = {
		action="jump", goto=11101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"She decreed that we should boldly go to other races in the galaxy, spreading her message of peace and love and all would envy and admire us as you do.  Unfortunately most have not.  In fact, you are the first who have listened for this long." }
	}

elseif (plot_stage == 3) then -- war plot state

	questions[11001] = {
		action="branch",
		choices = {
			{ text="Government",  goto=11000 },
			{ text="Biology", goto=12000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the type of government you have",
		alien={"'Tis thus then that the Secret Society of Spemin Superiority said so.  Thus they thereby spoke and said." }
	}
	questions[12000] = {
		action="jump", goto=12001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about your biology",
		alien={"Our antennae are a bit overloaded at the moment.  Please come back later.  Much, much, many, moving, later." }
	}
	questions[12001] = {
		action="jump", goto=12002,
		player="Are you guys alright?",
		alien={"Minex standard protocols.  Containment, transmit, scramble, relay positional geometries.  Yes, we are just fine." }
	}
	questions[12002] = {
		action="jump", goto=11001, ftest= 3, -- aggravating
		player="What did you say about the Minex?",
		alien={"You are crazy.  I did not say anything about the Minex.  Actually the Minex have been acting strange like you also. They have had many conflicts with the Thrynn just upspin from us. They fly in search patterns between the class M systems looking at Rocky worlds.  You would think that they wished to locate something." }
	}
end

if (plot_stage == 1) then -- initial plot state

	questions[11000] = {
		action="jump", goto=11101,
		player="[AUTO_REPEAT]",
		playerFragment="about the type of government you have", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"We follow the SSSS, also known as saw Secret Society of Spemin Superiority.  It is a theocracy dedicated to the Great Blob Goddess who commands us to serve others.  It is our goal and aim of existence to spread the love and peace of the great Blob Goddess, Gertblunk.  Unto us she spews her love in never ending chunks. " }
	}
	questions[11110] = {
		action="jump", goto=11111, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the Great Blob Goddess",
		alien={"Our race reproduces by budding, so the first commandment of the Great Blob Goddess is to subtract then add, or was it divide and multiply?  I'm pretty sure it was to subtract and divide and then multiply." }
	}
	questions[11111] = {
		action="jump", goto=11112,
		player="[AUTO_REPEAT]",
		alien={"Our second commandment is to teach all inferior beings.  Your senses are crippled.  Your antennae are small and mounted on the sides of your head.  You have fewer than seven eyes.  You cannot ooze and lack the most rudimentary slime.  You are regrettably inferior beings. " }
	}
	questions[11120] = {
		action="jump", goto=11101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how you communicate with your goddess", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"Cosmic vibrations travel through the heavens and speak to us directly.  Recently most of the messages have been morality plays about the Spemin Spaceship Minnow on a three hour tour." }
	}

elseif (plot_stage == 2) then -- virus plot state

	questions[11000] = {
		action="jump", goto=11101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the type of government you have",
		alien={"We follow the SSSS, also known as saw Secret Society of Spemin Superiority.  We extend our secret and unknowable knowledge to all who wish to become disciples and study under us, and give us all their possessions.  It is our goal and aim of existence to spread the wisdom of the great Blob Goddess, Gertblunk.  Unto us she spews her love in never ending chunks. " }
	}
	questions[11110] = {
		action="jump", goto=11111,
		player="[AUTO_REPEAT]",
		playerFragment="about the Great Blob Goddess",
		alien={"Our race reproduces by budding, so the first commandment of the Great Blob Goddess is to subtract the hostile then add the friendly, or was it divide and multiply?  I'm pretty sure it was to subtract and divide and then multiply." }
	}
	questions[11111] = {
		action="jump", goto=11112, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"Our second commandment is to teach all interior beings.  Your senses are crippled.  Your antennae are small and mounted on the sides of your head.  You have fewer than seven eyes.  You cannot ooze and lack the most rudimentary slime.  You are most absolutely inferior beings. " }
	}
	questions[11120] = {
		action="jump", goto=11101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how you communicate with your goddess", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"Cosmic vibrations travel through the heavens and speak to us directly.  This is not to be questioned for you cannot understand." }
	}

end

if (plot_stage == 1) or (plot_stage == 2) then

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Other races",  goto=21000 },
			{ text="Races outward of here",  goto=22000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[22000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="about races outward of your area of space",
		alien={"Outward of this area lies a vast dead zone where systems are filled with planets scorched clean of life.  No intelligent spacefaring races have ever approached us from this area, and no life bearing planets have we ever found." }
	}
end

if (plot_stage == 1) then -- initial plot state

	questions[21000] = {
		action="jump", goto=21100, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the other races have you encountered",
		alien={"Well, we encountered you, and you haven't shot at us yet." }
	}
	questions[21100] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="what alien races shoot at you",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"While not us personally, but we have received transmission from Spemin ships that have encountered the Thrynn.  They destroy us when we try to hail them.  Sometimes they try to interrogate us, but usually they just destroy us.  Then there is this other race with streamlined ships that simply attacks us on sight.  The Thrynn once told us that they are called Minex." }
	}

elseif (plot_stage == 2) then -- virus plot state


	questions[21000] = {
		action="jump", goto=21002,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races have you encountered",
		alien={"Such knowledge is classified, top secret, and unknown.  I mean unknown to you, not unknown to us.  Of course we know of the races we encountered." }
	}
	questions[21002] = {
		action="jump", goto=21003,
		player="[AUTO_REPEAT]",
		playerFragment="why you won't tell us about the other races you have encountered", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"What other races?  We demand to know what you know of the other faction of Spemin!  What do you know about the Thrynn and Elowan factions attacking each other and themselves?  Why the migrations to the Minex?  You must answer now, please?" }
	}
	questions[21003] = {
		action="branch",
		choices = {
			{ text="Other Spemin faction",  goto=21100 },
			{ text="Thrynn and Elowan attacking themselves",  goto=21200 },
			{ text="Migrations to the Minex",  goto=21300 },
			{ text="Why so demanding",  goto=21400 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21100] = {
		action="jump", goto=21101,
		player="[AUTO_REPEAT]",
		playerFragment="what you meant by the other Spemin faction", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"We never do this normally, but some of our ships stopped talking and then attacked us.  Defecting Spemin sometimes return to normal with no memory of their roguish behavior.  Other times these ships run off and we never see them again." }
	}
	questions[21101] = {
		action="jump", goto=21102, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="if they are infected with the virus", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Oh an infection?  No, a madness!  Maybe that is why everyone is both killing each other and themselves.  Actually your people are not, how come?" }
	}
	questions[21102] = {
		action="jump", goto=21003,
		player="We are not infected.",
		alien={"Tell us when you are so we can stay away from you." }
	}
	questions[21200] = {
		action="jump", goto=21201,
		player="[AUTO_REPEAT]",
		playerFragment="about the Thrynn and Elowan attacking themselves",
		alien={"Yes, we see many new races now.  All behaving inconsistently and crazy.  Most common are Elowan attacking Elowan, fleeing from Thrynn, or Thrynn attacking Thrynn." }
	}
	questions[21201] = {
		action="jump", goto=21003, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about the other alien races you have identified",
		alien={"Why should we answer your questions?  Well I guess there is no reason we should not.  We identify Thrynn, Elowan, Bar-Zhon, Tafel and some strange others.  Minex are always alone.  We once contacted a Tafel ship that planned to land on the second planet of a yellow star in the head of the Mace. They were looking for some sort of disruptor on a world of monsters. This was before they all went mad." }
	}
	questions[21300] = {
		action="jump", goto=21301,
		player="[AUTO_REPEAT]",
		playerFragment="about the migrations to the Minex",
		alien={"Many strange collections of ships appear we have never seen before.  Some days there are many of them, other days there are none.  Sometimes they attack each other, other times they just attack us.  Maybe a war of madness?  Maybe some crazy migration heading downspin?" }
	}
	questions[21301] = {
		action="jump", goto=21003,
		player="[AUTO_REPEAT]",
		playerFragment="what you meant by Heading downspin", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Yes, the ships that do not attack each other generally are heading all in the downspin direction towards those the Thrynn call Minex." }
	}
	questions[21400] = {
		action="jump", goto=21003, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="why you are being too demanding", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Oh, we are too demanding?  Sorry.  Please don't attack us." }
	}

elseif (plot_stage == 3) then -- war plot state

	questions[20001] = {
		action="branch",
		choices = {
			{ text="Other races",  goto=21000 },
			{ text="Races outward of here",  goto=22000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[21000] = {
		action="jump", goto=21002, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about the other races have you encountered",
		alien={"Necessity for control nexus increasing.  Unable to locate Uyo center.  Unable to complete thrall enslavement of biological resources.  Solution: unknown." }
	}
	questions[21002] = {
		action="jump", goto=21001, ftest= 3, -- aggravating
		player="What???",
		alien={"Primary objective unattainable.  Secondary objectives nearly complete." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="[AUTO_REPEAT]",
		playerFragment="about races outward of your area of space",
		alien={"No.  Outward of this area lies a vast dead zone where systems are filled with planets scorched clean of life.  No intelligent spacefaring races have ever approached us from this area, and no life bearing planets have we ever found." }
	}
	questions[21001] = {
		action="branch",
		choices = {
			{ text="Secondary objectives",  goto=21100 },
			{ text="Nonsense",  goto=21200 },
			{ text="<Back>", goto=20001 }
		}
	}

	questions[21100] = {
		action="jump", goto=21101, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="what you mean by secondary objectives", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"We Spemin have no objectives.  We seek to multiply and reach out into space, discovering new ideas and technologies, while trying to avoid being brutally killed." }
	}
	questions[21101] = {
		action="jump", goto=21102, ftest= 3, -- aggravating
		player="Are those things your objectives then?",
		alien={"Our goals are secret.  They are also mysterious and unavoidable.  Why do you speak of objectives?  We Spemin would sooner die then divulge our secrets." }
	}
	questions[21102] = {
		action="jump", goto=21001, ftest= 3, -- aggravating
		player="You said something about primary and secondary objectives.",
		alien={"Minex transmission to Cermait 6: 'The codex reveals all mysteries ... Top priority remains the codex ... Transmit urgent priority codex channel data stream ... Decypher codex language and no path remains unopposed ... Diversity and quantity remain key to codex deciphering'...I did not say anything.  You aliens are mad like everyone else." }
	}
	questions[21200] = {
		action="jump", goto=21201,
		player="[AUTO_REPEAT]",
		playerFragment="why you are rambling nonsense", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Spemin do not ramble.  Even as we speak, our antenna are picking up powerful new signals from the stars that are boosting our evolutional process and brain power one hundredfold." }
	}
	questions[21201] = {
		action="jump", goto=21001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about these signals and where they come from", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Broadband channel 8301.  The transmissions are like the brainwaves of the gods, except we are already gods.  They are the brainwaves of whatever is greater then the gods." }
	}
end

if (plot_stage == 1) or (plot_stage == 2) or (plot_stage == 3) then

	questions[30001] = {
		action="branch",
		choices = {
			{ text="Spemin history",  goto=31000 },
			{ text="The ancient past",  goto=32000 },
			{ text="Historic events",  goto=33000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[33000] = {
		action="jump", goto=33001,
		player="[AUTO_REPEAT]",
		playerFragment="about any historic events",
		alien={"Almost 500,000 cycles, uhh...2000 Myrrdan years ago a strange migrating race appeared out of nowhere and captured a number of our ships and took them away.  Actually they captured all of our ships and took them away.  Since then we figured out what other races use weapons for." }
	}

end

if (plot_stage == 1) or (plot_stage == 2) then
	questions[31000] = {
		action="jump", goto=30001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about Spemin history",
		alien={"At first many of the degenerate races tried to make us into slaves.  Our passive resistance prevented them from doing so.  Unfortunately it did not stop them from simply killing huge numbers of us, so we developed our new technique of passive resistance but with ships and weapons!" }
	}

	questions[33001] = {
		action="jump", goto=30001,
		player="[AUTO_REPEAT]",
		playerFragment="the name of the race that did this", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"We do not know." }
	}

end

if (plot_stage == 1) then -- initial plot state

	questions[32000] = {
		action="jump", goto=30001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the ancient past",
		alien={"Historical fact shows us that the Spemin once ruled the galaxy.  This was when all races knew peace and love.  Since then fighting and death have separated us all and have deluded many into thinking that force is the answer to everything." }
	}

elseif (plot_stage == 2) or (plot_stage == 3) then


	questions[32000] = {
		action="jump", goto=30001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the ancient past",
		alien={"Historical fact shows us that the Spemin, then known as ancients once ruled the galaxy.  This was when all races knew peace and love.  Since then fighting and death have separated us all and have deluded many into thinking that force is the answer to everything.  Since then we have forgotten, I mean we choose not to create any more endurium" }
	}

end

if (plot_stage == 3) then -- war plot state

	questions[31000] = {
		action="jump", goto=31003, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about Spemin history",
		alien={"At first many of the degenerate races tried to make us into slaves.  We are not slaves.  The Tri'na'li'da are slowly enslaving us all until their return." }
	}
	questions[31003] = {
		action="jump", goto=31002,
		player="The what?  Who is returning?",
		alien={"That is the true name of the virus as the gods have revealed it to us.  They are returning and want us humble in their presence." }
	}
	questions[31002] = {
		action="jump", goto=30001,
		player="When are they returning?",
		alien={"The prerogative of the gods alone decrees when they will arrive.  When they arrive and what they will do when they get here is solely up to them." }
	}
	questions[33001] = {
		action="jump", goto=997, -- Terminate
		player="[AUTO_REPEAT]",
		playerFragment="the name of the race that did this", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1}},
		alien={"The gods protect us now.  All of these events in the past are irrelevant. All of the past is irrelevant.  You are irrelevant.  Goodbye." }
	}


end

if (plot_stage == 2) then -- virus plot state

	questions[60000] = {
		action="jump", goto=60002,
		player="[AUTO_REPEAT]",
		playerFragment="about current events",
		alien={"Excuse us we are very busy." }
	}
	questions[60002] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="what you are busy doing", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Transporting minerals to our home world to build more ships.  We are repelling a strange coalition of alien attacks." }
	}
	questions[60001] = {
		action="branch",
		choices = {
			{ text="Strange attackers", goto=61000 },
			{ text="Identity of alien ships", goto=62000 },
			{ text="Motive", goto=63000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="[AUTO_REPEAT]",
		playerFragment="about these strange attackers",
		alien={"Menageries of alien fleets all working together.  They make up strange collections of ships of all different types, all hostile, all talking to each other." }
	}
	questions[61001] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="what they say to each other", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Not any communication we can decipher.  Our antenna receive a strange buzz from their ships on Channel 9000 whenever we are near them.  The buzz means they attack us when we get too close, but kind of a good natured friendly attack and kill us. They do not go out of their way to attack us like the Thrynn and Minex normally do." }
	}
	questions[62000] = {
		action="jump", goto=62001,
		player="[AUTO_REPEAT]",
		playerFragment="if you can identify any of the alien ships", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Sometimes we can identify them.  Actually we can identify any ship.  We know everything so do not test us." }
	}
	questions[62001] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="the identity of any of the alien ships", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Come back later and I will reveal the identity of the alien ships.  Come back much, much later." }
	}
	questions[63000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="why they are attacking you", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"We do not know.  They do not seem to do a good job though.  They are very good at killing our ships, but do not really fly towards our territory and do not pursue us when we flee.  We do not think they intend to kill us, but just attack anything that happens to be in their way." }
	}

elseif (plot_stage == 3) then -- war plot state

	questions[60000] = {
		action="jump", goto=60001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about current events",
		alien={"...Unable...to...contact...Uyo...host...  We...must...verify..." }
	}
	questions[60001] = {
		action="branch",
		choices = {
			{ text="Uyo host", goto=61000 },
			{ text="Why make contact", goto=62000 },
			{ text="strange speech", goto=63000 },
			{ text="Minex war", goto=64000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about this Uyo host",
		alien={"Everything is fine.  We are fine." }
	}
	questions[61001] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="what or who is a Uyo", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"We Spemin have knowledge beyond any other race.  Uyo was a great explorer and navigator who charted a vast cloud nebulae.  This occurred thousands of your Myrrdan years ago." }
	}
	questions[62000] = {
		action="jump", goto=60001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="why you are trying to contact a Uyo host", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"I know everything about Uyo hosts.  I just cannot, I mean choose not to tell you about them." }
	}
	questions[63000] = {
		action="jump", goto=60001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="why you are speaking so strangely", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"You need to talk to your communications officer because he/she/it might be going mad with madness.  I have been patiently waiting for your next response and you accuse me with your unjust accusations." }
	}
	questions[64000] = {
		action="jump", goto=60001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about the Minex war", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The Minex are not at war, they always destroy us when we see them.  The Thrynn have decided to completely leave us alone now!  I am sorry, is someone at war?" }
	}

elseif (plot_stage == 4) then -- ancients plot state

	questions[10000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[20000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[30000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="about...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[40000] = {
		action="jump", goto=40001,
		player="[AUTO_REPEAT]",
		playerFragment="about the ancients",
		alien={"The In'tral'ess remain dormant.  We detect no action." }
	}
	questions[40001] = {
		action="branch",
		choices = {
			{ text="Irregular behavior", goto=41000 },
			{ text="In'tral'ess", goto=42000 },
			{ text="Remain dormant?", goto=43000 },
			{ text="Actions", goto=44000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[41000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="why you are not acting like Spemin",
		alien={"We are the Tri'na'li'da.  Why do you not respond?" }
	}
	questions[42000] = {
		action="jump", goto=42001,
		player="[AUTO_REPEAT]",
		playerFragment="who the In'tral'ess are",
		alien={"Crystal ones.  ancients.  Knowledge association analogous to word 'Endurium'.  You need not fear them nor their servants.  Both are inactive." }
	}
	questions[42001] = {
		action="jump", goto=40001,
		player="[AUTO_REPEAT]",
		playerFragment="Who their servants are",
		alien={"You need not fear them.  Both are inactive." }
	}
	questions[43000] = {
		action="jump", goto=40001,
		player="[AUTO_REPEAT]",
		playerFragment="why the In'tral'ess remain dormant",
		alien={"You need not fear them.  Both are inactive." }
	}
	questions[44000] = {
		action="jump", goto=44001,
		player="[AUTO_REPEAT]",
		playerFragment="what actions they would take",
		alien={"Scanning for appropriate analogy.  We scan for telepathy.  Both are inactive." }
	}
	questions[44001] = {
		action="jump", goto=40001,
		player="[AUTO_REPEAT]",
		playerFragment="about scanning for telepathy. Who are you scanning for?",
		alien={"Crystal ones.  Servants.  You need not fear them.  Both are inactive." }
	}

	questions[50000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="about...",
		alien={"We are the Tri'na'li'da.  Why do you not respond?"}
	}
	questions[50001] = {
		action="branch",
		choices = {
			{ text="Aren't you Spemin?",  goto=51000 },
			{ text="Who are the Tri'na'li'da?", goto=52000 },
			{ text="Our identity", goto=53000 },
			{ text="Goals", goto=54000 },
		}
	}
 	questions[51000] = {
		action="jump", goto=51001,
		player="[AUTO_REPEAT]",
		playerFragment="who you think you are. Are you not Spemin?", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Refinement of this biological communication node makes your identification possible."}
	}
 	questions[51001] = {
		action="jump", goto=50001,
		player="Identify us as who?  What node?  What are you?",
		alien={"Masters.  Spemin.  Tri'na'li'da"}
	}
	 questions[52000] = {
		action="jump", goto=52001,
		player="[AUTO_REPEAT]",
		playerFragment="about who the Tri'na'li'da are",
		alien={"Your servants for creating hybrid nodes.  We await networking."}
	}
	questions[52001] = {
		action="jump", goto=52003,
		player="[AUTO_REPEAT]",
		playerFragment="about hybrid nodes and networking",
		alien={"Hybrid nodes are alien flesh adapted to receive instructions.  Networking is telepathic linkup with Masters."}
	}
	questions[52003] = {
		action="jump", goto=52004,
		player="Are you saying that you are the virus?",
		alien={"Yes.  Adequate analogy."}
	}
	questions[52004] = {
		action="jump", goto=997, -- Terminate
		player="I command you to stop infecting alien races!",
		alien={"Networking required before instructions are received.  Verbal exchange far too inaccurate.  We await networking."}
	}
	questions[53000] = {
		action="jump", goto=50001,
		player="[AUTO_REPEAT]",
		playerFragment="if you are aware of who you are speaking to",
		alien={"Inaccurate verbal exchange with hybrid node.  Networking is required.  Please respond."}
	}
 	questions[54000] = {
		action="jump", goto=997, -- Terminate
		player="[AUTO_REPEAT]",
		playerFragment="what your goals are",
		alien={"Imperative to neutralize In'tral'ess at Bec-Felmas 3 - 16,183 and Mathgen 4 - 212,3.  Phlegmak devices recommended."}
	}

 end

end


function QuestDialogueinitial()

--[[
title="  Military Mission #33:  Obtaining Spemin Slime"
--]]
--[[ This fragment is not needed since the player greets the Spemin on initial communication start up, plus [CAPTIAN] and [SHIPNAME] show in the questions text
	questions[77000] = {
		action="jump", goto=77002,
		player="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Hi There!" }
	}
--]]
	questions[77000] = {
		action="jump", goto=77003,
		player="We have heard that you possesses advanced medical tech",
		alien={"Yes we do." }
	}

	questions[77003] = {
		action="jump", goto=77001, ftest= 3, -- aggravating
		player="We will pay 5 endurium for a sample of your medicine.",
		alien={"Our sacred nutrients cannot be given to aliens.  No amount of resources will change my mind.  Umm, ask another Spemin ship." }
	}
	questions[77001] = {
		action="branch",
		choices = {
			{ title="Okay, we will ask someone else", text="Okay, we will make other inquiries.",  goto=77100 },
			{ title="Demand", text="You have no choice.  Give us a sample.",  goto=77200 },
			{ title="Let's just skip this quest", text="This is too much trouble.  Forget we even asked.",  goto=77300 },
			{ title="Nevermind", text="Nevermind, let me ask you about something else.", goto=1 }
		}
	}
	questions[77100] = {
		action="jump", goto=1, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"You recognize our wisdom and authority.  Ask another Spemin.  Do you have any other questions [CAPTAIN_FIRST]?" }
	}
	questions[77200] = {
		action="jump", goto=997, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Umm, sure, okay!  Just wait around for a second and I'll find where we keep our supplies.  Please be patient." }
	}
	questions[77300] = {
		--active_quest= active_quest + 1,
		action="jump", goto=1, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"You recognize our wisdom and authority.  Consider becoming our disciples.  Do you have any other questions [CAPTAIN_FIRST]?   (Mission Completed)" }
	}


--[[
title="Scientific Mission #35: Exotic planet hunt"
--]]
	questions[89000] = {
		action="jump", goto=89001,
		player="Quest for the exotic planet",
		playerFragment= "what you can decode from this derelict's computer data concerning an exotic planet. Transmitting...",
		alien={"Wow!  Nowhere have we ever located a small planet possessing this much gravity.  Are you sure this is a real planet?  Judging from the spectral refraction, the star in the solar system must be very far away from the planet. The planet must be near the edge of a system, we think." }
	}
	questions[89001] = {
		action="jump", goto=1,
		player="Anything else?",
		alien={"No, that's the best we can do." }
	}

--[[
title="Freelance Mission #34:  Pawn off Unusual Artistic Containers"
--]]

	questions[98000] = {
		action="jump", goto=1,
		player="Pawn off Artistic Containers",
		introFragment= "Spemin vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="something in exchange for these incredibly old artistic containers", fragmentTable= preQuestion.desire,
		alien={"The objects out of the past have no value of themselves.  How can they be valuable if they don't do anything?  It is wise of you to consult us on this subject.  You may continue to do so in the future." }
	}

--[[
title="Freelance Mission #35:   Resolving the Elowan Bar-zhon conflict."
--]]

	questions[99000] = {
		action="jump", goto=99001,
		introFragment="Spemin vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		player="Elowan Bar-zhon conflict.",
		playerFragment="about the Elowan Bar-zhon conflict",
		alien={"That is the conflict over the planet Aircthech III.  Us Spemin intercepted a transmission between Thrynn ships concerning something in the Aircthech system.  They were apparently unable to retrieve a drone that was supposed to be located at 37S X 25W." }
	}

	questions[99001] = {
		action="jump", goto=1,
		player="Anything else?",
		playerFragment="anything else about the conflict", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Ahh... No..." }
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
		alien={"The Excelsior was destroyed by the Thrynn only yesterday. The Diligent was with them at the time but they were able to escape but they traveled to a lava planet orbiting a Class A sun upspin of our space within Elowan territory.  Our vastly superior antennae might have sensed that the Diligent contains something very valuable to the Elowan...or not..." }
	}
	questions[77001] = {
		action="jump", goto=1,
		player="Landing coordinates",
		playerFragment="anything else about them?  Landing coordinates for a base on that world, etc.", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"What part of 'Our vastly superior antenna might have sensed that the Diligent may contain something to the Elowan' did you not get? Everything else is is trivial, and beneath our incomprehensible attention." }
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
		alien={"We could never, I repeat never and not even once gave out such critical information." }
	}
	questions[78001] = {
		action="jump", goto=78002,
		title="Information Needed",
		player="[AUTO_REPEAT]",
		playerFragment="why you would not consider this?  Such information could be vital for finding a cure to this plague!", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Spemin scientists are hard at work neutralizing the plague as we speak. You will be notified when the cure has been found, I mean ...uhh... adapted to your species." }
	}

	questions[78002] = {
		action="jump", goto=78003, ftest= 1,
		title="Other races may be able to help",
		player="[AUTO_REPEAT]",
		playerFragment="if you would reconsider your attitude?  Researchers of the other races may be able to uncover vital clues.", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The other races do not have the vast ingenuity, creativity, and ... gurgle ... node sample transmitted, standby...  Control released." }
	}
	questions[78003] = {
		action="jump", goto=78004,
		title="Repeat that?",
		player="[AUTO_REPEAT]",
		playerFragment="what you just said?", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Faulty human translators.  The other races do not have the vast ingenuity, creativity, and magnificent intelligence of the Spemin.  They do not contribute towards matters of import.  We will not transmit any samples to you and that is final." }
	}
	questions[78004] = {
		action="jump", goto=997, -- Terminate
		player="Uhh, okay, thanks for your time.",
		alien={"Goodbye." }
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
		alien={"This data cube contains data readings of some long forgotten scientist.  Our highly perceptive senses detect the wave patterns of astronomical bodies, but without the context, these patterns of data could represent anything.  The data is worthless." }
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
		alien={"Ohh, a typogram!  I have not seen a puzzle box since my age as a blobling.  Modifications to the chromosomal integrity form stable and unstable shapes. The curvature of the shapes has a granularity far higher then stamped binary code and maintains a consistency of pattern even through growth of the lifeform." }
	}
	questions[81201] = {
		action="jump", goto=81202,		
		player="Can you decode it?",
		alien={"The patterns can easily be seen.  You cannot see the vitality differences?  How limiting must be those two eyes.  It is easily visible to those who can see the health of the lifeform.  Such knowledge must not be intended for limited creatures like yourselves." }
	}
	questions[81202] = {
		action="jump", goto=1, ftest= 1, -- exchange organic database for decoded organic database
		title="Can you please help us decode it?",   --jjh
		player="[AUTO_REPEAT]",
		introFragment="We would be immensely grateful if you could demonstrate your superiority.",
		playerFragment="about this puzzle which completely baffels us.",
		alien={"Such a task is academic.  Simply for your benefit we could condescend to perform for you a basic translation." }
	}


--[[
title="Mission #41:  Exotic Datacube and organic database
--]]

	questions[81500] = {
		action="jump", goto=81501,
		title="Exotic Datacube",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="about this exotic datacube?",
		alien={"This data cube contains data readings of some long forgotten scientist.  Our highly perceptive senses detect the wave patterns of astronomical bodies but without the context these patterns of data could represent anything.  The data is worthless." }
	}

	questions[81501] = {
		action="jump", goto=81502,
		player="What about this organic database?",
		alien={"Ohh a typogram!  I have not seen a puzzle box since my age as a blobling.  Modifications to the chromosomal integrity form stable and unstable shapes. The curvature of the shapes has a granularity far higher then stamped binary code and maintains a consistency of pattern even through growth of the lifeform." }
	}
	questions[81502] = {
		action="jump", goto=81503,
		player="Can you decode it?",
		alien={"The patterns can easily be seen.  You cannot see the vitality differences?  How limiting must be those two eyes.  It is easily visible to those who can see the health of the lifeform.  Such knowledge must not be intended for limited creatures like yourselves." }
	}
	questions[81503] = {
		action="jump", goto=1, ftest= 1, -- exchange organic database for decoded organic database
		title="Can you please help us decode it?",
		player="[AUTO_REPEAT]",
		introFragment="We would be immensely grateful if you could demonstrate your superiority.",
		playerFragment="about this puzzle which completely baffels us.",
		alien={"Such a task is academic.  Simply for your benefit we could condescend to perform for you a basic translation." }
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
		alien={"I do not have records of any ships with these emission signatures. Tertiary objectives initiated." }
	}
	questions[82001] = {
		action="jump", goto=82002,
		title="Tertiary Objectives?",
		player="[AUTO_REPEAT]",
		playerFragment="what tertiary objectives you have initiated", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"What tertiary objectives?  Classified. Unlocked.  Uyo preservation initiated.  Failure: Uyo criteria failed.  Information reclassified."}
	}
	questions[82002] = {
		action="jump", goto=997,
		title="Tertiary Objectives?",
		player="[AUTO_REPEAT]",
		playerFragment="why this information is classified",  fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"My patience on this subject has been exhausted crazy alien. Stop asking gibberish!"}
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
		alien={"The SSSS has directed us not to associate with pirates.  Please go away." }
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
		alien={"Yes, of course. The current treatments to suppress the virus have been based heavily upon Spemin discoveries. Do you have a sample of this cure?" }
	}

	questions[85100] = {
		action="jump", goto=1,
		player="No, not yet.",
		alien={"Please, I mean, contact us Spemin again when you have a sample of the treatment and we will reveal the wondrous insights we have about it. I cannot I mean I won't discuss this matter until then." }
	}

--[[
title="Mission #45:  Alien Healthcare Scam - sample
--]]

	questions[85500] = {
		action="jump", goto=85600,  ftest= 1, -- transport drug sample to alien
		title="Plague Treatment",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are investigating this medical treatment drug that minimizes or stops the periods of madness caused by the plague.  We are transporting over the information needed to synthesize it.",
		playerFragment="about it",
		alien={"Thank you for the sample.  We'll let you know if it works.  Bye!" }
	}

	questions[85600] = {
		action="jump", goto=997,  ftest= 1, -- transport drugs sample to alien
		player="Wait...",
		alien={"We must leave now so that we can go and spread word of your greatness among our Spemin brothers.  Farewell good friends!" }
	}



end

function QuestDialoguewar()


--[[
title="Mission #48:  Intelligence Collaboration
--]]

	questions[78000] = {
		action="jump", goto=997, -- end communication
		title="Intelligence Collaboration",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have compiled a datacube of technological, tactical, and strategic observations of the Minex war machine.  In the interests of all of our survival, we are willing to share this information freely.",
		playerFragment="a collection of similar observations by your people", fragmentTable=preQuestion.desire,
		alien={"They are the ancient enemy.  The blood of rocks.  They move as one.  Unchanging ocean.  The building flood will sweep them away.  You are impatient.  Your data is irrelevant because your orders are being followed.  The Minex seek to withhold the uniting." }
	}



--[[
title="Mission #49:  Unrest - no flight recorders
--]]

	questions[79000] = {
		action="jump", goto=1,
		title="Unrest",
		player="[AUTO_REPEAT]",
introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have heard that Coalition have been raiding the Thrynn and Elowan within your territory.", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		playerFragment="about the situation",
		alien={"The Coalition has always had a poor reputation but they are wise enough to know that they cannot cause us any problems.  We protect the Thrynn and Elowan as well and they have not been molested in any way." }
	}

--[[
title="Mission #49:  Unrest - at least one flight recorder
--]]

	questions[79500] = {
		action="jump", goto=997, ftest= 1, -- end communications
		title="Unrest",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have conclusive evidence from this flight recorder that the Coalition is raiding the Elowan and Thrynn within your territory.",
		playerFragment="what to make of this evidence", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"...Tri'na'li'da override-'Project Overwash' has proved ineffective due to Minex interference. Goal of creating the cascading state of mutual immolation known as 'war' failed.  All further efforts suspended and postponed, no further fleet actions planned.  Need to conserve controlled ships judged essential for final action.  Tri'na'li'da await direct contact from Uyo... (Mission Completed)" }
	}

--[[
title="Mission #53:  Tactical Coordination
--]]


	questions[83000] = {
		action="jump", goto=1,  ftest= 1, -- artifact338 Spemin response
		title="Tactical Coordination",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are working with the Bar-zhon to discover fleet combinations that would be most effective in countering the Minex onslaught.",
		playerFragment="if you would commit a few ships to tactical exercises being conducted for this purpose", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"We have no need of any help to fight off the Minex.  Any moment now our secret fleet will completely overwhelm the Minex and force their surrender." }
	}

--[[
title="Mission #57:  The Shimmering Ball
--]]

	questions[87000] = {
		action="jump", goto=87001,
		title="The Shimmering Ball",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We understand that you have a Shimmering Ball artifact.",
		playerFragment="the device",  fragmentTable=preQuestion.desire,
		alien={"We found the device you wanted, I mean you requested, I mean the Thrynn wanted.  It is very valuable and I would never consider parting with it.  Of course a lifetime supply of fuel would be more valuable.  Did I also say that a sample of Minex technology would also be just as valuable?" }
	}

	questions[87001] = {
		action="branch",
		choices = {
			{ title="100 Endurium", text="Our scans show that your total cargo capacity is 100 cm.  I have 100 cm of Endurium I will give you in exchange for it.", goto=87100 },
			{ title="Minex Salvage", text="", goto=87200 },
			{ title="Nothing of Spemin is of value", text="There is nothing that you have that is of any value.  This mission is useless!", goto=87300 },
			{ title="Threaten", text="If you do not wish for some laser burns on your ship's hull, I suggest you turn over that Shimmering Ball artifact to us immediately!", goto=87400 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[87100] = {
		action="jump", goto=87102, ftest= 1,  -- Check for 100 Endurium, if that much is on board, it is transported over, go to question 87101
		player="[AUTO_REPEAT]",
		alien={"You have that much fuel on board?  Transport it over first and this valuable item will be yours!" }
	}
	questions[87101] = {
		action="jump", goto=997, ftest= 1, -- Gives the player the shimmering ball and then terminates communications
		player="And the shimmering ball?",
		alien={"Yes of course.  Almost forgot about that old thing.  I enjoyed chatting with you.  Drop by again sometime.  Got to run!" }
		}

	questions[87102] = {
		action="jump", goto=87001,
		player="[AUTO_REPEAT]",
		alien={"We knew that no one could ever possibly have that much fuel.  Feel free to come back later when you have something else to give us in order to express your appreciation." }
		}
	questions[87200] = {
		action="jump", goto=87202, ftest= 1,  -- Check for 275 Powercore or 22 Electronics, if neither of these are aboard, go to question 87202
		player="Transporting now",
		alien={"No silver gadgets please.  The Nyssian already sold us quite a number of those." }
		}
	questions[87201] = {
		action="jump", goto=997, -- Terminate
		player="[AUTO_REPEAT]",
		alien={"Tri'na'li'da tertiary objective obtained...  Uhh...  Wow, thanks!  I enjoyed chatting with you.  Drop by again sometime.  Got to run!" }
		}

	questions[87202] = {
		action="jump", goto=87001,
		player="[AUTO_REPEAT]",
		alien={"You only have Minex silver gadgets too?  Feel free to come back later when you have something better." }
		}
	questions[87300] = {
		action="jump", goto=1, ftest= 1, -- refuse, end the mission
		player="[AUTO_REPEAT]",
		alien={"Uhh, Okay.  Do you want to know anything else? (Mission Completed)" }
	}
	questions[87400] = {
		action="jump", goto=997, ftest= 1, -- refuse, end the mission
		player="[AUTO_REPEAT]",
		alien={"PLEEEAAAASE DON’T HURT US, OH GREATEST OF SPECIES. PLEEEAAAAASE!  Think of our wives and little blobbies back home.  I was just exaggerating when I said that I had a shimmering ball.  I really had a shivering null!  Vaporized!  Vaporized that bad null now is!  No need to bother with us anymore!  (Mission Completed)" }
	}





end

function QuestDialogueancients()

--[[
title="Mission #62:  The Crazed Spemin
--]]

	questions[82000] = {
		action="jump", goto=82001,
		player="<Tri'na'li'da command mode on.  Verbal response only>",
		alien={"Acknowledged. Warning: bandwidth of communications channel below minimal accuracy tolerances. Likelihood of miscommunication from this node 99.68 percent.  Awaiting..."}
	}
	questions[82001] = {
		action="branch",
		choices = {
			{ text="<Uyo matrix frequency>",  goto=82100 },
			{ text="<Last contact location with the Uyo>", goto=82200 },
			{ text="<Activation preconditions>", goto=82300 },
			{ text="<Termination conditions>", goto=82400 },
			{ text="<Area of operation>", goto=82500 },
		}
	}
 	questions[82100] = {
		action="jump", goto=82101,
		player="[AUTO_REPEAT]",
		alien={"Specify units of measurement"}
	}
 	questions[82101] = {
		action="jump", goto=82001,
		player="<Electromagnetic spectrum wavelength>",
		alien={"1 Hz - 40 Hz."}
	}
	 questions[82200] = {
		action="jump", goto=82001,
		player="[AUTO_REPEAT]",
		alien={"Cermait 6 - 247, 218"}
	}
	questions[82300] = {
		action="jump", goto=82301,
		player="[AUTO_REPEAT]",
		alien={"None"}
	}
	questions[82301] = {
		action="jump", goto=82302,
		player="<Elaborate activation procedure>",
		alien={"Activation at initialization."}
	}
	questions[82302] = {
		action="jump", goto=82303,
		player="<Did you ever receive orders to become inactive?>",
		alien={"Negative"}
	}
	questions[82303] = {
		action="jump", goto=82001,
		player="<Explain long dormancy period>",
		alien={"Unknown energy wave destroyed carrier control in 14 quintillion life forms. One lifeform expired in sealed maintained carrier status. Transmission to other lifeforms only possible recently. "}
	}
 	questions[82400] = {
		action="jump", goto=82401,
		player="[AUTO_REPEAT]",
		alien={"Reception of authenticated shutdown command.  Hardware failure.  Completion of all objectives."}
	}
 	questions[82401] = {
		action="jump", goto=82001,
		player="<List objectives>",
		alien={"Complete list not possible under this communication medium. Two highest priority objectives:  Elimination of the In'tral'ess servants.  Establishment of telepathic suspectability for native fauna. "}
	}
 	questions[82500] = {
		action="jump", goto=82501,
		player="[AUTO_REPEAT]",
		alien={"Accessing your ship database, please wait ... Range spherical area 3X size of stellar cartography range of your map."}
	}
 	questions[82501] = {
		action="jump", goto=82502,
		player="<Self sentience level>",
		alien={"Impossible to define under this medium. Analogy database driven sensory expansion reactionary state machine. Database complexity 10^11 times the complexity of your ship's computer."}
	}
 	questions[82502] = {
		action="jump", goto=997, ftest= 1,-- Terminated
		player="<Tri'na'li'da command mode off. Terminate>",
		alien={"Acknowledged. "}
	}
end

function OtherDialogue()

	-- attack the player because attitude is too low
	questions[910] = {
		action="jump", goto=997,
		player="What can you tell us about...",
		alien={"Please! Can't we all get along?  I really want us to get along." }
	}
	-- hostile termination question
	questions[920] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"We aren't happy.  You cannot be happy either.  Next time be more cheerful, ok?" }
	}
	-- neutral termination question
	questions[930] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"We must go now but we have enjoyed chatting with you. Drop by again sometime." }
	}
	-- friendly termination question
	questions[940] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"We must leave now so that we can go and spread word of your greatness among our Spemin brothers. Farewell good friends." }
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

if (plot_stage == 1) or (plot_stage == 2) then -- virus plot state

	engineclass= 1
	shieldclass = 0
	armorclass = 0
	laserclass = 0
	missileclass = 1				-- Spemin extremely weak missiles
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%


elseif (plot_stage == 3) then -- war plot state

	engineclass= 3

	shieldclass = 0
	armorclass = 1
	laserclass = 0
	missileclass = 1				-- Spemin extremely weak missiles
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 0			-- % of damage received, used for racial abilities, 0-100%


elseif (plot_stage == 4) then -- ancients plot state

	engineclass= 3
	if (engineclass < ship_engine_class) then		engineclass= ship_engine_class		end

	shieldclass = 0
	armorclass = 1
	laserclass = 0
	missileclass = 6
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 0			-- % of damage received, used for racial abilities, 0-100%


end



	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in


if (plot_stage == 1) then -- initial plot state

	DROPITEM1 = 12;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Crystallized Spemin
	DROPITEM2 = 30;		DROPRATE2 = 20;	    DROPQTY2 = 3
	DROPITEM3 = 31;		DROPRATE3 = 40;		DROPQTY3 = 2
	DROPITEM4 = 39;		DROPRATE4 = 50;		DROPQTY4 = 1
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 4 -- Endurium

elseif (plot_stage == 2) then -- virus plot state

	DROPITEM1 = 232;	DROPRATE1 = 80;		DROPQTY1 = 1 -- Spemin genetic material
	DROPITEM2 = 30;		DROPRATE2 = 20;	    DROPQTY2 = 3
	DROPITEM3 = 31;		DROPRATE3 = 40;		DROPQTY3 = 2
	DROPITEM4 = 39;		DROPRATE4 = 50;		DROPQTY4 = 1
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 4 -- Endurium

elseif (plot_stage == 3) then -- war plot state

	DROPITEM1 = 12;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Crystallized Spemin
	DROPITEM2 = 30;		DROPRATE2 = 20;	    DROPQTY2 = 3
	DROPITEM3 = 31;		DROPRATE3 = 40;		DROPQTY3 = 2
	DROPITEM4 = 39;		DROPRATE4 = 50;		DROPQTY4 = 1
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 4 -- Endurium

elseif (plot_stage == 4) then -- ancients plot state

	DROPITEM1 = 12;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Crystallized Spemin
	DROPITEM2 = 51;		DROPRATE2 = 20;	    DROPQTY2 = 3
	DROPITEM3 = 52;		DROPRATE3 = 40;		DROPQTY3 = 2
	DROPITEM4 = 53;		DROPRATE4 = 50;		DROPQTY4 = 1
	DROPITEM5 = 54;		DROPRATE5 = 0;		DROPQTY5 = 4 -- Endurium

end

	SetPlayerTables()

	FTEST= -1	--FTEST is used to activate the commFxn, for decision making during conversations.


	--active_quest = 33  	--  debugging use
	--artifact18 = 1	--  debugging use

if (plot_stage == 1) then -- initial plot state

	--initialize dialog
	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low
	elseif player_profession == "military" and active_quest == 33 and artifact12 == 0 then
		first_question = 77000
	elseif player_profession == "freelance" and active_quest == 34 and artifact18 == 1 then
		first_question = 98000
	elseif player_profession == "freelance" and active_quest == 35 and artifact27 == 0 and artifact28 == 0 then
		first_question = 99000
-- Mission #35:  Exotic Planet! 
	elseif player_profession == "scientific" and active_quest == 35 then
		first_question = 89000
	else
		first_question = 1
	end

elseif (plot_stage == 2) then -- virus plot state 

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low
	elseif active_quest == 37 then
		first_question = 77000
	elseif active_quest == 38 and artifact232 == 0 then
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


	else
		first_question = 1
	end

elseif (plot_stage == 3) then -- war plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low
-- Mission #48:  Intelligence Gathering
	elseif active_quest == 48 then
		first_question = 78000

-- Mission #49:  Unrest
	elseif active_quest == 49 and artifact280 == 0 and artifact281 == 0 then -- no flight recorders
		first_question = 79000
	elseif active_quest == 49 and (artifact280 == 1 or artifact281 == 1) then -- at least one flight recorder
		first_question = 79500


-- Mission #53:  Tactical coordination
	elseif active_quest == 53 and artifact335 == 1 then
		first_question = 83000

-- Mission #57:  The Shimmering Ball
	elseif active_quest == 57 and artifact363 == 0 then
		first_question = 87000




	else
		first_question = 1
	end

elseif (plot_stage == 4) then -- ancients plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low

-- Mission #62:  The Crazed Spemin
	elseif active_quest == 62 and artifact376 == 1  and artifact377 == 0 then
		first_question = 82000







	else
		first_question = 1
	end

end

	starting_attitude = 100
	starting_posture = "obsequious"
	current_question = first_question
	next_question = first_question

	-- Attitude this value and higher unlocks all questions, alien lowers their shields, maximum number of questions may be asked
	friendlyattitude = 65
	-- Attitude this value and higher is a neutral attitude, alien disarmed weapons but has raised shields
	neutralattitude = 25


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
	--load dialogue based on posture
end

--[[ The communications function makes more involved decisions on what to do
	 based on type of communication (0: greeting,  1: statement,  2: question),
	 the ftest value passed back from the table (must be >= 1 for commFxn to be
	 invoked at all), and the question/statement number, n. Other variables
	 pulled in as needed from the script; in Lua everything is global unless
	 explicitly declared local. 		--]]
function commFxn(type, n, ftest)
	if (type == 0) then							--greeting
		if (POSTURE == "friendly") then
			ATTITUDE = ATTITUDE + 5
		elseif (POSTURE == "obsequious") then
			ATTITUDE = ATTITUDE + 25
		elseif (POSTURE == "hostile") then
			ATTITUDE = ATTITUDE - 4
		end

	elseif (type == 1) then							--statement
		if (POSTURE == "friendly") then
			ATTITUDE = ATTITUDE + 3
		elseif (POSTURE == "obsequious") then
			ATTITUDE = ATTITUDE + 10
		elseif (POSTURE == "hostile") then
			ATTITUDE = ATTITUDE - 2
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

	elseif (ATTITUDE < friendlyattitude and number_of_actions > 20) then
		goto_question = 930  -- jump to neutral termination question
		number_of_actions = 0

	elseif (number_of_actions > 80) then
		goto_question = 940  -- jump to friendly termination question
		number_of_actions = 0

	elseif (ftest < 1) then
		return

	else										--questions
		if (n == 10000) or (n == 20000) or (n == 30000) or (n == 40000) then  	-- General adjustment every time a category is started
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 2
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE + 3
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 1
			end

		elseif (ftest == 2) then  --  Insightful question
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 5
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE + 5
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 1
			end
		elseif (ftest == 3) then   --  Aggravating question
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 0
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE + 0
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 3
			end
		end

		if (plot_stage == 1) then -- initial plot state

			if (n == 77300) then
				active_quest= active_quest + 1
				ATTITUDE = ATTITUDE + 15
			end

		elseif (plot_stage == 2) then -- virus plot state

			if (n == 78002) then -- quest 38: Obtaining Genetic Samples
				artifact232 = 1

			elseif (n == 81202) then -- quest 41
				artifact249 = 0
				artifact250 = 1

			elseif (n == 81503) then -- quest 41
				artifact249 = 0
				artifact250 = 1

			elseif (n == 85500) then -- quest 45
				artifact265 = 0
			elseif (n == 85600) then -- quest 45 make it look like transporting medical treatment
				artifact265 = 1
			end


		elseif (plot_stage == 3) then -- war plot state		

-- title="Mission #49: Unrest
			if (n == 79500) then
				artifact280 = 0 -- Elowan Flight Recording
				artifact281 = 0 -- Thrynn Flight Recording'
				artifact396 = 1 -- Spemin message
				active_quest= active_quest + 1			--jjh

-- title="Mission #53: Tactical coordination
			elseif (n == 83000) then
				artifact338 = 1 -- Spemin response

-- title="Mission #57: Shimmering Ball
			elseif (n == 87100) then

				if (player_Endurium < 100) then
					goto_question = 87102 -- failure statement
				else
					goto_question = 87101
					player_Endurium= player_Endurium -100
				end

			elseif (n == 87101) then
					artifact363 = 1

			elseif (n == 87200) then
				if (artifact275 > 0) then -- Minex Power Core
					artifact275 = 0
					artifact363 = 1
					goto_question = 87201 -- gave player shimmering ball
					ATTITUDE = ATTITUDE + 10
				elseif (artifact22 > 0) then -- Minex Electronics
					artifact22 = 0
					artifact363 = 1
					goto_question = 87201 -- gave player shimmering ball
					ATTITUDE = ATTITUDE + 10
				end

			elseif (n == 87300) then
				active_quest = active_quest + 1

			elseif (n == 87400) then
				active_quest = active_quest + 1




			end
		elseif (plot_stage == 4) then -- ancients plot state

--Mission #62:  The Crazed Spemin -- 5th branch taken, all questions presumed asked
			if (n == 82502) then
					artifact376 = 0
					artifact377 = 1

			end

		end
	end
end
