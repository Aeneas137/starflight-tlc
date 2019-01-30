--[[------------------------------------------------------------------------------------------------------------------------------------------------- ]
	ENCOUNTER SCRIPT FILE: ELOWAN

	Last Modified:  December 23, 2009

	Globals shared with C++ module:
		ACTION - actions invoked by script (see below)
		POSTURE - obsequious, friendly, hostile
		ATTITUDE - this alien's ATTITUDE toward player (1 to 100)
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

if (plot_stage == 1) then

	obsequiousGreetTable= {
		"Please thee not, false flattery be not our foresight",
		"Of thee this I prognosticate: irrationality plagues thy inconsistent action.",
		"Pray cease thy unnecessary dementia."
	}


elseif (plot_stage == 2) then

	obsequiousGreetTable= {
		"Please thee not, false flattery be not our foresight",
		"Of thee this I prognosticate: irrationality plagues thy inconsistent action.",
		"Pray cease thy unnecessary dementia."
	}


elseif (plot_stage == 3) then

	obsequiousGreetTable= {
		"Please thee not, false flattery be not our foresight",
		"Of thee this I prognosticate: irrationality plagues thy inconsistent action.",
		"Pray cease thy unnecessary dementia."
	}


elseif (plot_stage == 4) then

	obsequiousGreetTable= {
		"Please thee not, false flattery be not our foresight",
		"Of thee this I prognosticate: irrationality plagues thy inconsistent action.",
		"Pray cease thy unnecessary dementia."
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


if (plot_stage == 1) then

	obsequiousStatementTable= {
		"We ask only that you could either violence nor trespass against us.",
		"'Tis but false concepts art thou laboring under."
	}

		obsequiousFearTable= {
		"Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.",
		"'Tis but false concepts art thou laboring under."
	}

elseif (plot_stage == 2) then

	obsequiousStatementTable= {
		"We ask only that you could either violence nor trespass against us.",
		"'Tis but false concepts art thou laboring under."
	}

		obsequiousFearTable= {
		"Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.",
		"'Tis but false concepts art thou laboring under."
	}

elseif (plot_stage == 3) then

	obsequiousStatementTable= {
		"We ask only that you could either violence nor trespass against us.",
		"'Tis but false concepts art thou laboring under."
	}

		obsequiousFearTable= {
		"Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.",
		"'Tis but false concepts art thou laboring under."
	}

elseif (plot_stage == 4) then

	obsequiousStatementTable= {
		"We ask only that you could either violence nor trespass against us.",
		"'Tis but false concepts art thou laboring under."
	}

		obsequiousFearTable= {
		"Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.",
		"'Tis but false concepts art thou laboring under."
	}

end

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien= obsequiousFearTable }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien= obsequiousStatementTable }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien= obsequiousFearTable }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien= obsequiousFearTable }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien= obsequiousStatementTable }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien= obsequiousStatementTable }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien= obsequiousFearTable }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien= obsequiousStatementTable }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien= obsequiousFearTable }


end

------------------------------------------------------------------------
-- FRIENDLY DIALOGUE ---------------------------------------------------
------------------------------------------------------------------------
function FriendlyDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack

if (plot_stage == 1) then

	friendlyGreetTable= {
		"Thou doest now encounter the Elowan.  Pray that thy continued existence is assured.",
		"Statest thou thine intentions immediately and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.",
		"Turn back now interloper.  We are Elowan.  We greet thee with no malice, but distrust thy intent."
	}

elseif (plot_stage == 2) then

	friendlyGreetTable= {
		"Thou doest now encounter the Elowan.  Pray that thy continued existence is assured.",
		"Statest thou thine intentions immediately and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.",
		"Turn back now interloper.  We are Elowan.  We greet thee with no malice, but distrust thy intent.",
		"We are Elowan.  Such concepts of respect doth we reflect in like measure upon thee.",
		"We are Elowan.  Trust me like measure shall be granted upon the trustworthy.",
		"Thou doest now encounter the Elowan.  Faith and understanding doth we extend to thine companions and thou kind."
	}

elseif (plot_stage == 3) then

	friendlyGreetTable= {
		"Thou doest now encounter the Elowan.  'Tis a difficult yet hopeful age we endure.",
		"Statest thou thine intentions and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.",
		"We are Elowan.  We greet thee with no malice, and bear thee no ill will.",
		"We are Elowan.  Such concepts of respect doth we reflect in like measure upon thee.",
		"We are Elowan.  Trust me like measure shall be granted upon the trustworthy.",
		"Thou doest now encounter the Elowan.  Faith and understanding doth we extend to thine companions and thou kind."
	}

elseif (plot_stage == 4) then

	friendlyGreetTable= {
		"Thou doest now encounter the Elowan.  'Tis a difficult yet hopeful age we endure.",
		"Statest thou thine intentions and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.",
		"We are Elowan.  We greet thee with no malice, and bear thee no ill will.",
		"We are Elowan.  Such concepts of respect doth we reflect in like measure upon thee.",
		"We are Elowan.  Trust me like measure shall be granted upon the trustworthy.",
		"Thou doest now encounter the Elowan.  Faith and understanding doth we extend to thine companions and thou kind."
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
		player="Dude, that is one green ship you have there!",
		alien= friendlyGreetTable }
	greetings[5] = {
		action="",
		player="How's it going, weird, carnivorous plant things?",
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

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack

if (plot_stage == 1) then

	friendlyStatementTable= {
		"Such concepts of respect doth we reflect in like measure upon thee.",
		"Trust me like measure shall be granted upon the trustworthy.",
		"Faith and understanding doth we extend to thine companions and thou kind."
	}

elseif (plot_stage == 2) then

	friendlyStatementTable= {
		"Such concepts of respect doth we reflect in like measure upon thee.",
		"Trust me like measure shall be granted upon the trustworthy.",
		"Faith and understanding doth we extend to thine companions and thou kind."
	}

elseif (plot_stage == 3) then

	friendlyStatementTable= {
		"Such concepts of respect doth we reflect in like measure upon thee.",
		"Trust me like measure shall be granted upon the trustworthy.",
		"Faith and understanding doth we extend to thine companions and thou kind."
	}

elseif (plot_stage == 4) then

	friendlyStatementTable= {
		"Such concepts of respect doth we reflect in like measure upon thee.",
		"Trust me like measure shall be granted upon the trustworthy.",
		"Faith and understanding doth we extend to thine companions and thou kind."
	}

end

end

------------------------------------------------------------------------
-- HOSTILE DIALOGUE ----------------------------------------------------
------------------------------------------------------------------------
function HostileDialogue()
	--add as many player greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack


	hostileGreetTable= {
		"'Tis our wish that no pirates nor interlopers disrespect the Elowan.",
		"Despicable and untrustworthy monster, leave our space.",
		"Thou addresses the Elowan.  Do not do so in such a manner."
	}

	greetings[1] = {
		action="terminate",
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
		action="terminate",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien= hostileGreetTable }
	greetings[5] = {
		action="terminate",
		player="We require information. Comply or be destroyed.",
		alien= hostileGreetTable }
	greetings[6] = {
		action="",
		player="Your ship is over-embellished and weak.",
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

function StandardQuestions()

	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

if (plot_stage == 1) then

	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"We are those of the vine and spore, allies of the peaceful, concern'd with such things as may be called truth, survival and perhaps justice against the Thrynn."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"In tranquillity, an empty answer.  In the constant attacks of the Thrynn hadst we grown weary, and free knowledge we no longer ferry."}
	}
	questions[30000] = {
		action="jump", goto=1, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"Nothing more will we tell trespassers and interlopers."}
	}
	questions[40000] = {
		action="jump", goto=1, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"Nothing more will we tell trespassers and interlopers." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Ships and defenses",  goto=51000 },
			{ text="Your home world?", goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}

	questions[51000] = {
		action="jump", goto=53000, ftest= 6, -- very aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about your ships and defenses",
		alien={"Thy true interests are made apparent!  Thou wouldst speak falsely and take advantage of us!"}
	}
	questions[52000] = {
		action="jump", goto=50000, ftest= 6, -- very aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about the location of your home world",
		alien={"Encroach upon our sacred colony at thy peril.  May thy existence pass into what thou may call'st thine third life for suggesting such an attempt."}
	}
	questions[53000] = {
		action="jump", goto=999,  ftest= 6, -- very aggravating, attack the player
		player="We do not have any hostile intentions!",
		alien={"<Silence>"}
	}

	questions[11001] = {
		action="branch",
		choices = {
			{ text="Yourselves",  goto=11000 },
			{ text="Truth?", goto=12000 },
			--{ text="Thrynn homeworld", goto=13000 },
			{ text="Elowan homeworld", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		playerFragment="about your race",
		alien={"We extend to thee no vine, if thou would have it otherwise, prove thy intentions against the Thrynn war machine." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="[AUTO_REPEAT]",
		playerFragment="what truth you seek", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Nothing more will we tell trespassers and interlopers." }
	}
	questions[13000] = {
		action="jump", goto=11001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about where can the Thrynn be found",
		alien={"Likewise the murderous Thrynn home system they call Tharsarnsss, in your coordinate system Semias 3 - 5,66, canst thou find the ignorant ones to this day." }
	}
	questions[14000] = {
		action="jump", goto=53000, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="the location of your homeworld", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Encroach upon our sacred colony at thy peril.  May thy existence pass into what thou may call'st thine third life for such an attempt." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Thrynn conflict",  goto=21000 },
			{ text="Other aliens",  goto=22000 },
			{ text="The Thrynn",  goto=23000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[21000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="about the Thrynn conflict",
		alien={"The Thrynn constant attacks keepest us on our guard, their malice and trickery all have seen.  Unless thou wouds't play a role, distrust you we will." }
	}

	questions[22000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="about nearby races",
		alien={"The Spemin downspin of us knowest little and mostly do they whimper.  Upon driving them shalt thou gain'st only an enemy, yet one who shalt not a danger pose." }
	}
	questions[23000] = {
		action="jump", goto=23101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the Thrynn",
		alien={"An untrustworthy race, if thou hadst not already allied with them.  One that pretends, portraying to be what they are not.  They embrace the machine and would do thee harm shoud'st they be given the chance to do so." }
	}

	questions[23101] = {
		action="branch",
		choices = {
			--{ text="Thrynn home world",  goto=23100 },
			{ text="Are they enemies?",  goto=23200 },
			{ text="Why dislike the Thrynn?",  goto=23300 },
			{ text="Why not abandon the area?",  goto=23400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[23100] = {
		action="jump", goto=23101, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="where the Thrynn be found",
		alien={"Likewise the murderous Thrynn home system they call Tharsarnsss, in your coordinate system Semias 3 - 5,66, canst thou find the ignorant ones to this day." }
	}
	questions[23200] = {
		action="jump", goto=23101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="on your relationship with the Thrynn.  Do you consider them enemies?",
		alien={"Constant and fierce have been the attack of the vile Thrynn from ancient times, e'er since the empire fell and could no longer judge them.  We seeketh only peace, from both they and freelancers/pirates such as yourself, rare as it could be found." }
	}
	questions[23300] = {
		action="jump", goto=23101,
		player="[AUTO_REPEAT]",
		playerFragment="why you dislike the Thrynn",
		alien={"Must such pirates profess ignorance?  Such a conundrum thou art, appearances be thee marred, yet answers and not violence doth thou seek." }
	}
	questions[23400] = {
		action="jump", goto=23101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="why you don't simply leave this area of space to escape from the Thrynn",
		alien={"None but a few of us remain, and only one location we defend, as the Thrynn pursue us to the end." }
	}
end
if (plot_stage == 2)  then
	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"We are the Elowan, those of the vine and spore, allies of the peaceful, concern'd with such things as may be called beauty and perhaps truth."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"In tranquillity, an empty answer.  In the constant attacks of the Thrynn hadst we grown weary.  The little we know we share freely."}
	}
	questions[30000] = {
		action="jump", goto=31001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the past",
		alien={"Preytell thy every inquiry will be answered."}
	}
	questions[40000] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the ancients",
		alien={"Nay.  Too much has been lost from our racial knowledge, as little r'mained from the days of scattering." }
	}

elseif  (plot_stage == 3) then
	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"We are the Elowan, those of the vine and spore, concern'd with such things as may be called beauty and perhaps truth, allies of all who resist the tide of the Minex."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"In necessity grows the strength of survival.  The Minex had'st provoked the ire of all in their foolishness.  Provincial 'twas their mistake of provoking both the Thrynn and ourselves with this onslaught.  The feudal conflict of the Thrynn hadst been transformed into a provisional alliance for withstanding this peril."}
	}
	questions[30000] = {
		action="jump", goto=31001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about your history",
		alien={"Preytell thy every inquiry will be answered. 'Tis our hope that thy fortunes entwine with ours in this difficult era."}
	}
	questions[40000] = {
		action="jump", goto=1, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"Too much has been lost from our racial knowledge, as little r'mained from the days of scattering." }
	}

elseif (plot_stage == 4) then
	questions[10000] = {
		action="jump", goto=11001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about yourselves",
		alien={"We are the Elowan, those of the vine and spore, allies of those who remain sane and resisting the ill, concern'd with such things as may be called beauty and perhaps truth."}
	}
	questions[20000] = {
		action="jump", goto=21001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the other races in the galaxy",
		alien={"Interesting indeed doth this new era portend.  The Minex hath stilled their war machine and the Thrynn conflict hadst e're remained complacent for the moment."}
	}
	questions[30000] = {
		action="jump", goto=31001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about your history",
		alien={"Thy every inquiry will be answered in this hopeful era."}
	}
	questions[40000] = {
		action="jump", goto=40001, ftest= 1,
		player="[AUTO_REPEAT]",
		playerFragment="about the Ancients",
		alien={"Much has been lost from our racial knowledge, as little r'mained from the days of scattering.  'Tis available to you what little we maintain in this new hopeful era." }
	}


end

if (plot_stage == 2) or (plot_stage == 3) then -- virus or war plot states

	questions[50000] = {
		action="branch",
		choices = {
			{ text="Ships and defenses",  goto=51000 },
			{ text="Your homeworld",  goto=52000 }, -- disable until something is implemented at home worlds
			{ text="Current news",  goto=60000 },
			{ text="<Back>",  goto=1 }
		}
	}

elseif (plot_stage == 4) then -- ancients plot state

	questions[50000] = {
		action="branch",
		choices = {
			{ text="Ships and defenses",  goto=51000 },
			{ text="Your homeworld",  goto=52000 },
			{ text="Telepathy",  goto=60000 },
			{ text="<Back>",  goto=1 }
		}
	}

end


if (plot_stage == 2) or (plot_stage == 3) or (plot_stage == 4) then

	questions[51000] = {
		action="jump", goto=51101,
		player="[AUTO_REPEAT]",
		playerFragment="about your ships and defenses",
		alien={"In truth, essentials will we not to divulge.  Abstractions befitting allies we have no trouble sharing."}
	}
	questions[52000] = {
		action="jump", goto=50000, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="the location of your homeworld", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Encroach upon our sacred colony Cailte 4 - 61,22 at thy peril.  Thy existence shall pass into what thou may call'st thine third life if any betrayal doth proceed." }
	}
	questions[51101] = {
		action="branch",
		choices = {
			{ text="Your ships",  goto=51100 },
			{ text="Your ship's combat ability", goto=51200 },
			{ title="Tight formations", text="I can't help but notice your tight formations", goto=51300 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[51100] = {
		action="jump", goto=51101, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about your ships",
		alien={"Doth thy ship not possess sensors?  Our tiny but incredibly sophisticated vessels are equipped with powerful shielding and nearly endless supply of energy projectile weaponry."}
	}

end


if (plot_stage == 2) then -- virus plot state

	questions[51200] = {
		action="jump", goto=997, ftest= 6, -- very aggravating -- terminate
		player="[AUTO_REPEAT]",
		playerFragment="how your ships do in battle", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Such an inquiry hath only one possible response.  Provoke us not into a demonstration."}
	}
	questions[51300] = {
		action="jump", goto=51101,
		player="[AUTO_REPEAT]",
		alien={"Patterns of strength unfold endlessly and the Thrynn lack the innate cooperation the military mind implies.  The rotation of the wounded permit refreshment of their screens, as the Thrynn lack the spatial coordination to control effectively any but the most simple of particle beam weaponry."}
	}

elseif (plot_stage == 3) then -- war plot state


	questions[51200] = {
		action="jump", goto=51101,
		player="[AUTO_REPEAT]",
		playerFragment="how your ships do in battle", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"'Tis a dance of thy greatest dreams united with the ugliness of death.  Perchance nothing demonstrates the truth of existence in like spirit.  We fly the abstract patterns of infinity with the precision of rain watering the ground with projectiles of death 'ere our young may'st continue to stand under the rain of life."}
	}

	questions[51300] = {
		action="jump", goto=51101,
		player="[AUTO_REPEAT]",
		alien={"Patterns of strength unfold endlessly and the Thrynn lack the innate cooperation the military mind implies.  The rotation of the wounded permit refreshment of their screens, as the Thrynn lack the spatial coordination to control effectively any but the most simple of particle beam weaponry."}
	}


elseif (plot_stage == 4) then -- ancients plot state


	questions[51200] = {
		action="jump", goto=51101,
		player="[AUTO_REPEAT]",
		playerFragment="how your ships do in battle", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"'Tis a dance of thy greatest dreams united with the ugliness of death.  Perchance nothing demonstrates the truth of existence in like spirit.  We fly the abstract patterns of infinity with the precision of rain watering the ground with projectiles of death 'ere our young may'st continue to stand under the rain of life."}
	}
	questions[51300] = {
		action="jump", goto=51101,
		player="[AUTO_REPEAT]",
		alien={"Patterns of strength unfold endlessly and most others lack the innate cooperation required.  The rotation of the wounded permit refreshment of their screens."}
	}

end


if (plot_stage == 2) then -- virus plot state

	questions[60000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about current events",
		alien={"'Tis nothing truly of note changed under the stars." }
	}
	questions[60001] = {
		action="branch",
		choices = {
			{ text="The Plague", goto=61000 },
			{ text="<Forceful Assertion concerning ignorance>", goto=62000 },
			{ title="Other races are infected", text="Every other race we contacted is affected by a plague.", goto=63000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=60001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about the plague devastating all the races",
		alien={"Of any plague, we nothing may say, as nothing doth afflict us nor of those who we know." }
	}
	questions[62000] = {
		action="jump", goto=60001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="the truth, your people are not stricken by a terrible plague like all others?",
		alien={"Of many things doth the slanderous Thrynn profess to others.  Our defenses continue to withstand their every thrust and lie." }
	}
	questions[63000] = {
		action="jump", goto=60001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		alien={"Rumors of such doth carry widely.  The truth behind such stories has yet to be determined." }
	}

elseif (plot_stage == 3) then -- war plot state

	questions[60000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="about current events",
		alien={"In necessity grows the strength of survival.  The Minex had'st provoked the ire of all in their foolishness.  Provincial 'twas their mistake of provoking both the Thrynn and ourselves with this onslaught.  The feudal conflict of the Thrynn hadst been transformed into a provisional alliance for withstanding this peril."}
	}

elseif (plot_stage == 4) then -- ancients plot state

	questions[60000] = {
		action="jump", goto=60001,
		player="[AUTO_REPEAT]",
		playerFragment="about telepathy or purely mental communication",
		alien={"The insectoid Veloxi of our home sector sector possessed a hive mind of limited range.  Drones could communicate over a distance of several miles.  Queens could instantaneously, without restrictions, control vast fleets in space.  The Spemin in both our home sector and this doth claim perception above the norm.  In sooth they knowest little and mostly do they bluster.  Such claims of all should one with skepticism pursue."}
	}
	questions[60001] = {
		action="jump", goto=50000,
		player="[AUTO_REPEAT]",
		playerFragment="where the Spemin could be found",
		alien={"Seek thee downspin and slightly outward of thy current position."}
	}

end




if (plot_stage == 2) or (plot_stage == 3) or (plot_stage == 4) then

	questions[11001] = {
		action="branch",
		choices = {
			{ text="Your people",  goto=11000 },
			{ text="Sentient plant reproduction", goto=12000 },
			{ text="Allies of the peaceful", goto=13000 },
			{ text="Your homeworld", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about your race",
		alien={"At a time when we reach an age of adolescence we are uprooted. In so doing we are become omniverous producers, capable of sustaining ourselves thusly upon photosynthesis with the occasional consumption of meat or plant products." }
	}
	questions[12000] = {
		action="jump", goto=11001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how a race of sentient plants reproduce", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Mayhap one of every 300 of our number doth stay rooted within the ground, and in so doing is its head then transformed into a melon-like fruit called headfruit wherein lie the many seeds of our future.  The sacred harvest festival doth temporarily a third of our race incapacitate, and dwell upon us the duty of traversing and scattering the code of life." }
	}
	questions[13000] = {
		action="jump", goto=11001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="why you say you are allies of the peaceful", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Is not violence, above all things, most base and vile?  Surely only as a final measure, against those who use it without hesitation, can it be condoned." }
	}
	questions[14000] = {
		action="jump", goto=11001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="where your homeworld is", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Encroach upon our sacred colony Cailte 4 - 61,22 at thy peril.  Thy existence shall pass into what thou may call'st thine third life if any betrayal doth proceed." }
	}
end



if (plot_stage == 2) or (plot_stage == 3) then -- virus and war plot states

	questions[21001] = {
		action="branch",
		choices = {
			{ text="The Thrynn",  goto=21000 },
			{ text="Other nearby races",  goto=22000 },
			{ text="Small Elowan territory",  goto=23000 },
			{ text="Thrynn location",  goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[22000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="about other nearby races",
		alien={"The Spemin knowest little and mostly do they whimper.  Upon driving them shalt thou gain'st only an enemy, yet one who shalt not a danger pose." }
	}
	questions[23000] = {
		action="jump", goto=21001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="why your territory is so small", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"For the guardianship of where our young doth dwell, our adopted home world, our primary concern always lies." }
	}
	questions[24000] = {
		action="jump", goto=21001, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="where the Thrynn may be found", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Likewise the murderous Thrynn home system they call Tharsarnsss, in your coordinate system Semias 3 - 5,66, canst thou find the ignorant ones to this day." }
	}

elseif (plot_stage == 4) then -- ancients plot state

	questions[21001] = {
		action="branch",
		choices = {
			{ text="The Thrynn",  goto=21000 },
			{ text="Why the Minex attacked you",  goto=22000 },
			{ text="Interspecies virus revisited",  goto=23000 },
			{ text="Other races being attacked",  goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[22000] = {
		action="jump", goto=21001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about any possible reason that could explain why the Minex decided to attack your people",
		alien={"'Tis an unprovoked action, in all regards, that the Minex hath wrought.  Yet in hope the danger presented by an enemy in truth, unlike ourselves, doest sway the aggressions of the Thrynn away from us." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="[AUTO_REPEAT]",
		playerFragment="if you have discovered anything new concerning the plague", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Indeed the great devastation of this affliction had'st begun its work and spared naught many.  Little do we know of that lies within any resolution to this matter." }
	}
	questions[24000] = {
		action="jump", goto=21001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="if you have made contact with any other races under siege in this way", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"'Twas only recently that representatives of the Coalition and Bar-zhon did us contact.  Seeking aid and strength we hath not in spare to provide to them, nor they to us.  Yet not in vain their efforts were made, as agreements to share technology and intelligence would'st perhaps all be saved." }
	}
end

if (plot_stage == 2) then -- virus plot state

	questions[21000] = {
		action="jump", goto=21101, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="who the Thrynn are",
		alien={"An untrustworthy race, one that pretends, portraying to be what they are not.  They embrace the machine, and would do thee harm should they be given the chance to do so." }
	}

elseif (plot_stage == 3) then -- war plot state

	questions[21000] = {
		action="jump", goto=21101,
		player="[AUTO_REPEAT]",
		playerFragment="about who the Thrynn are",
		alien={"An untrustworthy race, one that hath pursued the most vile injustices against us.  In necessity thou shalt observe their aid in our survival, as we now intercede in theirs." }
	}

elseif (plot_stage == 4) then -- ancients plot state

	questions[21000] = {
		action="jump", goto=21101,
		player="[AUTO_REPEAT]",
		playerFragment="about who the Thrynn are",
		alien={"A sly and untrustworthy race, one that hath pursued the most vile injustices against us.  In necessity thou shalt observe their aid in our survival, as we now intercede in theirs.  Knowest thou that tranquility hadst temporarily encompassed our demesne." }
	}


end

if (plot_stage == 2) then -- virus plot state


	questions[21101] = {
		action="branch",
		choices = {
			{ text="War with the Thrynn",  goto=21100 },
			{ text="Allies",  goto=21200 },
			{ text="How do you believe you are superior to the Thrynn?",  goto=21300 },
			{ text="Have you considered giving peace a chance?",  goto=21400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[21100] = {
		action="jump", goto=21101,
		player="[AUTO_REPEAT]",
		playerFragment="if you are at war with the Thrynn", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"No other state is known, for a feud begun in ancient times.  The constraints on their aggression, namely the influence of a now fallen Empire and antagonism of the crusading Gazurtoid, no longer remain to curtail their excesses as we both passed and were pursued hither." }
	}

	questions[21200] = {
		action="jump", goto=21101,
		player="[AUTO_REPEAT]",
		playerFragment="if you have any allies", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"'Twas none but the vilest opportunists and pirates who would willingly enter a war zone.  The wretched Thrynn provide the materialism to inspire constant trickery from marauding pirates of all races." }
	}
	questions[21300] = {
		action="jump", goto=21101, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about how you believe you are superior to the Thrynn",
		alien={"In truth doth our greatest strength lie within our greatest weakness, the precision of our recall, as both interpretation of patterns and a lack of focus contribute to our character." }
	}

	questions[21400] = {
		action="jump", goto=21101,
		player="[AUTO_REPEAT]",
		playerFragment="if you considered giving peace a chance", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Many aggressions upon our race arise from sources compounded by the Thrynn.  Our physical weakness constitutes to them the grounds for many of the most extreme slaughters, and our surrender is not an option." }
	}

elseif (plot_stage == 3) then -- war plot state


	questions[21101] = {
		action="branch",
		choices = {
			{ text="Creation of the Thrynn alliance",  goto=21100 },
			{ text="Resisting the Minex",  goto=21200 },
			{ text="What strengths complement Thrynn weaknesses",  goto=21300 },
			{ text="Minex battle strategy",  goto=21400 },
			{ text="<Back>", goto=21001 }
		}
	}


	questions[21200] = {
		action="jump", goto=21101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how you are able to withstand the Minex warships", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The Minex profane and vile attacks have cut bitterly.  Perchance with fortune, the Thrynn's fierce and ruthless attacks, balanced with our fleet support, has heretofore broken all waves. " }
	}
	questions[21300] = {
		action="jump", goto=21101, ftest= 3, -- aggravating
		player="[AUTO_REPEAT]",
		playerFragment="about how you are working with the Thrynn against the Minex",
		alien={"Thrynn lasers touched them most effectively, perchance our ships the greatest at coordination of defense was proven.   An unofficial alliance hath formed, with us as scouts and defense, and unified taskforces with both our fleets and the Thrynn countering in response." }
	}
	questions[21400] = {
		action="jump", goto=21101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about what strategy the Minex use against you",
		alien={"Great ignorance doth thou find in the Minex in their pursuit of war.  Only do they attack, with methodical precision, the outlines of our territory.  They speak only with their weapons fiercely, yet great tactical advantage abstain, from failing to thrust towards colony worlds." }
	}

elseif (plot_stage == 4) then -- ancients plot state

	questions[21101] = {
		action="branch",
		choices = {
			{ text="Creation of the alliance",  goto=21100 },
			{ text="After the war",  goto=21200 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[21200] = {
		action="jump", goto=21201, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="what happened since the Minex war ceased", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"'Twas our belief that the Minex and the virus were intertwined.  Knowest not how their influence was stifling its spread.  Likewise e're the Thrynn and Minex had their day, now doth the mad ones threaten all.  Our temporary alliance with the Thrynn continues to hold against this new threat" }
	}
end


if (plot_stage == 3) or (plot_stage == 4) then

	questions[21100] = {
		action="jump", goto=21101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about how this alliance with the Thrynn formed", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"A chance encroachment of our territory by the Minex occurred during an engagement with the Thrynn.  Indiscriminate was the slaughter of both Elowan and Thrynn by the sizable task force.  Upon knowledge of their peril, weary antagonism towards our ships withdrawn, and both forces unit'd in repulsing the unjust provocation.  A tender seed that day was planted." }
	}


end

if (plot_stage == 4) then

	questions[21201] = {
		action="branch",
		choices = {
			{ text="Mad ones", goto=21210 },
			{ text="How the mad ones threaten you", goto=21220 },
			{ text="Don't they revert back to normal?", goto=21230 },
			{ text="Insanity would mean disorganization", goto=21240 },
			{ text="<Back>", goto=21101 }
		}
	}
	questions[21210] = {
		action="jump", goto=21201,
		player="[AUTO_REPEAT]",
		playerFragment="about the mad ones",
		alien={"Those in every race possessed in illness to actions not of their normal intent.  Those who in foolishness encroach within their range experience, without exception, the furious speech of their weapons." }
	}
	questions[21220] = {
		action="jump", goto=21201, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how the mad ones threaten you", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Maphap only indirectly as greater numbers of all fall under its control.  The peril of thy neighbor suddenly provoking unjust hostility doest nurture a paranoia destabilizing all." }
		}
	questions[21230] = {
		action="jump", goto=21201, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="if those infected by the virus still revert to normal", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"'Twas once true but no longer.  Vast fleets of those perchance inflicted with this infection gather nay a short distance coreward our demesne.  Fewer and fewer recover and return to their senses as this virus enacts greater control." }
	}
	questions[21240] = {
		action="jump", goto=21201, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="how a large group of insane aliens are able to coordinate an attack", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"The mad ones may be possessed by the telepathic control of another.  The migrating Uhlek, far from here, mayst be a close analogy.  As if cells of one large creature, autonomous yet one, the Uhlek are possessed of a single mind which resides apart from them, buried deep in subterranean caverns.  Finding such a mind may free the mad ones in like manner." }
	}
end

if (plot_stage == 2) or (plot_stage == 3) or (plot_stage == 4) then

	questions[31001] = {
		action="branch",
		choices = {

			{ text="Other colonies",  goto=31000 },
			{ text="Conflict started",  goto=32000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[32000] = {
		action="jump", goto=32101,
		player="[AUTO_REPEAT]",
		playerFragment="how the conflict with the Thrynn started", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"'Twas in 2770 that the empire did discover our home system of Eleran and both races and eventually uplift. Contact first was made with the wretched Thrynn. Therefore we were not at first accepted as sentient for they spoke wrongly of us and were not questioned in their slander." }
	}

end

if (plot_stage == 2) then -- virus plot state

	questions[31000] = {
		action="jump", goto=31001,
		player="[AUTO_REPEAT]",
		playerFragment="if you have established any other colonies", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"None but a few of us remain, for this last location we defend, as the Thrynn pursue us to the end." }
	}

elseif (plot_stage == 3) then -- war plot state

	questions[31000] = {
		action="jump", goto=31001,
		player="[AUTO_REPEAT]",
		playerFragment="if you have established any other colonies", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"None but a few of us remain, for this last location we defend, as now the Minex assume the prior mantle of the Thrynn." }
	}


elseif (plot_stage == 4) then -- ancients plot state

	questions[31000] = {
		action="jump", goto=31001,
		player="[AUTO_REPEAT]",
		playerFragment="if you have established any other colonies", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"None but a few of us remain, for this last location we defend, as now the mad ones doth encroach upon us widely." }
	}

end

if (plot_stage == 2) or (plot_stage == 3) or (plot_stage == 4) then
	questions[32101] = {
		action="branch",
		choices = {
			{ text="When did the fighting start?",  goto=32100 },
			{ text="Eleran's location",  goto=32200 },
			{ text="<Back>", goto=31001 }
		}
	}

	questions[32100] = {
		action="jump", goto=32101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about how the actual conflict began",
		alien={"Both our races developed sub-luminal travel and the final bastion of our home world invaded.  Conflict thus arose from the hunting instinct of Thrynn: sentient beings being the most dangerous prey, and the headfruit of the planted Elowan the most defended and coveted prize." }
	}

end


if (plot_stage == 2) then

	questions[32200] = {
		action="jump", goto=32101, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the location of your original homeworld Eleran",
		alien={"Nay this expanse be not our origin.  'Twas only 450 festival cycles our flight from a dying Empire, a wave of flaring stars, and the machinations of the murderous Thrynn did we flee thither. Only the former two dangers were we successful in avoiding." }
	}


elseif (plot_stage == 3) or (plot_stage == 4) then


	questions[32200] = {
		action="jump", goto=32201, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="where Eleran is located",
		alien={"Nay this expanse be not our origin.  'Twas only 450 festival cycles our flight from a dying Empire, a wave of flaring stars, and the machinations of the murderous Thrynn did we flee thither.  Of only the former two dangers were we successful in avoiding." }
	}

	questions[32201] = {
		action="branch",
		choices = {
			{ text="Dying empire", goto=32210 },
			{ text="A wave of flaring stars", goto=32220 },
			{ text="<Back>", goto=32101 }
		}
	}
	questions[32210] = {
		action="jump", goto=32201,
		player="[AUTO_REPEAT]",
		playerFragment="about a dying empire",
		alien={"If the Nyssian tales be true, the Empire of Man, yourselves a scattered remnant, had'st been destroyed all heretofore save yourselves.  In sooth, the truth of this matter we know little."}
	}
	questions[32220] = {
		action="jump", goto=32221,
		player="[AUTO_REPEAT]",
		playerFragment="about a wave of flaring stars. Who or what be responsible for such a thing?  Are they still around?",
		alien={"'Tis not known whether any ancient ones survive still.  Mayhap only their heinous legacy, the crystal planet, has been left us.  Its evil task was to destroy all that lives within its range.  Why, we know not.  It's current influence is far from here." }
	}
	questions[32221] = {
		action="jump", goto=32222, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about why the ancients would give us endurium then try to kill us",
		alien={"Little is known to us on this subject.  The Nyssian storytellers, in their manner, describe an enemy of the ancient ones named Uyo.  This described homicidal race of withered beings may have been the target for such a device, with our ancestors and thine, only unintended victims."}
	}
	questions[32222] = {
		action="jump", goto=32201, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		alien={"'Tis possible the appearance of genocidal technologies and the ill-timed and irrational actions of the Minex may be mere harbingers of the Uyo's return.  If not responsible for their actions, e'er their innocence be shown, some slight knowledge of this matter may they possess." }
	}

end

if (plot_stage == 4) then -- ancients plot state

	questions[41001] = {
		action="jump", goto=40001, ftest= 2, -- insightful
		player="The Minex revealed that the ancients may have a cure.",
		alien={"Unfold we will what wisps of truth we may." }
	}
	questions[40001] = {
		action="branch",
		choices = {
			{ text="The ancients", goto=41000 },
			{ text="City of the ancients", goto=42000 },
			{ text="Contacting the ancients", goto=43000 },
			{ text="Anyone else have knowledge of the ancients", goto=44000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[41000] = {
		action="jump", goto=41005, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about the ancients",
		alien={"The ancient ones, who are no more, are the oldest of all races. Little do we know of them but for the songs of the Minstrels. T'was from another galaxy, far distant, that they came, or so it is sung.  If the Minstrel songs be true the span of an ancient one's life was measured not in years, but rather in millennium, so long-lived were they." }
	}
	questions[41005] = {
		action="jump", goto=40001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="about who the minstrels are",
		alien={"Wandering creatures of space called by many 'the Minstrels', and by some 'Delasa'Alia'.  They are old beyond counting and wise in like measure.  In our home sector these gentle spacebearing creatures, requiring no vessel, wander the depths of space.  None have been observed in this realm." }
	}
	questions[42000] = {
		action="jump", goto=40001,
		player="[AUTO_REPEAT]",
		playerFragment="if you have heard of a city of the ancients", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"We had ascertained that a city of the ancients existed in our home sector, within a system inside the rim of starforming nebulae, almost exactly 100 parsecs outward from the war-torn Veloxi homeworld.  Landing coordinates in empire terminology were 29N X 13W.  How thou couldst make use of this knowledge is not known since that realm is nay inaccessible." }
	}
	questions[43000] = {
		action="jump", goto=40001,
		player="[AUTO_REPEAT]",
		playerFragment="how to contact the ancients", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"'Tis not known whether any ancient ones survive still, nor how they may be contacted.  Mayhap none have known more of the ancient ones than the Institute of the old empire of Earth. But alack, with the fall of the empire the knowledge was lost, and the territory of the old empire unreachable save from a generational journey." }
	}
	questions[44000] = {
		action="jump", goto=40001, ftest= 2, -- insightful
		player="[AUTO_REPEAT]",
		playerFragment="if you know of any other race that has useful knowledge of the ancients", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"For every race that is possessed of some slight knowledge of the ancient ones there is another theory to explain their nature.  Perhaps only the Nyssian in their focus upon the past possess a hint of useful knowledge." }
	}

 end

end



function QuestDialogueinitial()

--[[
title="Science Mission #35:  An exotic planet.",
--]]

	questions[89000] = {
		action="jump", goto=1, ftest= 2, -- insightful
		player="Quest for the exotic planet.",
		introFragment= "Elowan vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].  We are on a quest to further the knowledge of all sentients.",
		playerFragment= "what you can decode from this derelict's computer data concerning an exotic planet",
		alien={"Thou dost seek after the rare truth indeed.  'Tis our analysis that the location orbits a F or G class star.  Fragmentary lies all other data." }
	}

--[[
title="Freelance Mission #32:  Elowan / Thrynn war zone.",
--]]

	questions[96000] = {
		action="jump", goto=96001, ftest= 2, -- insightful
		player="Could you use aid against the Thrynn?",
		introFragment= "Elowan Scout.  This is Captain [CAPTAIN].  We have heard of your current umm...tactical situation with the Thrynn.",
		playerFragment="something in exchange for our military support", fragmentTable= preQuestion.desire,
		alien={"We extend to thee no vine and if thou would have it otherwise you must prove thy intentions against the Thrynn war machine.  Return with a Thrynn Battle Machine and thou willst earn our gratitude." }
	}
	questions[96001] = {
		action="jump", goto=96002,
		player="Why don't you have one?",
		playerFragment="why you not been able to salvage one yourself", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Our small ships are not equipped for salvage operations." }
	}
	questions[96002] = {
		action="jump", goto=96003,
		player="What will you give us?",
		playerFragment="what would you give us for our efforts", fragmentVeto= {o= {1,2}, f= {1,2,3,4}, h={1,4}},
		alien={"Thy shielding technology appears primitive and we mayst perchance improve on it.  No more do we have time at this junction." }
	}
	questions[96003] = {
		action="jump", ftest= 4, -- terminate
		player="bugged",
		alien={"bugged" }
	}

--[[
title="Freelance Mission #32:  Elowan / Thrynn war zone. - Thrynn Battle Machine",
--]]

	questions[96100] = {
		action="jump", goto=1, ftest= 1,
--		artifact14 = 0
--		active_quest = active_quest + 1
--		ship_shield_class = ship_shield_class + 1
		player="I have brought a Thrynn Battle Machine.",
		introFragment= "Elowan Scout.  This is Captain [CAPTAIN].  We have acquired a Thrynn Battle Machine.",
		playerFragment="something in exchange it", fragmentTable= preQuestion.desire,
		alien={"We awaiteth receipt of said device." }
	}

		questions[96105] = {
--		artifact20 = 0,
--		active_quest = active_quest + 1,
--		ship_shield_class = ship_shield_class + 1,
		action="jump", goto=1, ftest= 1,
		player="I'm sending it now.",
		alien={"We are transporting to thee specifications of our shielding technology." }
	}
	questions[96106] = {
--		artifact20 = 0,
--		active_quest = active_quest + 1,
--		ship_shield_class = ship_shield_class + 1,
		action="jump", goto=1, ftest= 1,
		player="I'm sending it now.",
		alien={"Surpassed our own technology, your shielding has.  We offer instead an exchange of Myrrdan energy crystals." }
	}

--[[
title="Freelance Mission #34:  Unusual Artistic Containers ",
--]]
	questions[98000] = {
		action="jump", goto=98001,
		player="Are you interested in incredibly old artistic containers?",
		introFragment= "Elowan Scout.  This is Captain [CAPTAIN].  We have acquired a collection of artifacts of inestimable value.  You will be astounded by these incredibly old and wondrous artistic containers",
		playerFragment="something in exchange it",  fragmentTable= preQuestion.desire,
		alien={"No." }
	}
	questions[98001] = {
		action="jump", goto=98002,
		player="Are you sure?  These containers are incredibly beautiful.",
		alien={"No. " }
	}
	questions[98002] = {
		action="jump", goto=1,
		player="Can you not agree that these items interest you?",
		alien={"No." }
	}

--[[
title="Freelance Mission #35:  mediate between the Elowan and the Bar-zhon",
--]]
	questions[99000] = {
		action="jump", goto=99001,
		player="Tell us about the Elowan Bar-zhon conflict",
		introFragment= "Elowan Scout.  This is Captain [CAPTAIN].  We have heard of the recent conflict between yourselves and the Bar-zhon.",
		playerFragment="about the situation.",
		alien={"'Tis a sorrowful tale of woe.  Perchance this apparent bastion uncovered in the blackness of space.  Tranquil dreams thus extended of vine and root." }
	}
	questions[99001] = {
		action="jump", goto=99002,
		player="You are saying that you established a colony?",
		alien={"Indeed upon this world doth our young now abide.  Difficult but for many cycles now save from death's skythe to flee.  The prideful ones likewise doth have no such restriction." }
	}
	questions[99002] = {
		action="jump", goto=99003,
		player="Your young are rooted and immobile?  What else?",
		alien={"Those thou call'st Bar-zhon were quiescent for an age.  E're long a blackening dust was spread through the skies, imperiling the songs of the young.  The Bar-zhon woud'st deny their action, yet no other industries may be found."}
	}
	questions[99003] = {
		action="jump", goto=1, ftest= 2, -- insightful
		player="Could another source have caused the dust?",
		alien={"No other source encroached on this system.  A Nyssian Scout mayhap traversed the system at one time, yet no action did they take in this demesne."}
	}
--[[
title="Freelance Mission #35:  mediate between the Elowan and the Bar-zhon - found probe",
--]]
	questions[99500] = {
--		artifact27 = 0
--		artifact28 = 1
		action="jump", goto=1, ftest= 1,
		player="We located this Thrynn probe which delivered the dust.",
		alien={"The heinous Thrynn nurtured this profane seed?  Thou wouldst carry our thanks for thy heroic actions.  Conflict with the Bar-zhon is over.  We give you this minor token of thanks and certification of your accomplishment."}
	}


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
		alien={"In sooth, none of our race hath before encountered either of these vessels. We wish thee the best in thy pursuit for racial tranquility." }
	}

--[[
title="Mission #37:  Catching the Smugglers. After obtaining miniature funnel bushes",
--]]
	questions[77500] = {
		action="jump", goto=997,  ftest= 1, -- terminate
		title="Catching the Smugglers #2",
		player="[AUTO_REPEAT]",
		introFragment="This is Captain [CAPTAIN] of the starship [SHIPNAME].",
		playerFragment="the truth about the criminal smuggler vessel, The Diligent. We found a base of theirs in your space and they possessed this plant of Elowan manufacture!",
		alien={"Thy accusations we wish we could deny, for the Elowan neither tolerate nor condon lawlessness in any form. The air plant which thou doth possess was bestowed upon the Myrrdan vessel Intrepid. Their vessel did present quite a different sensor signature from the one which thou purports to be the Diligent. We urge much haste in bringing this signature data to thy government. Perhaps its use has been employed to deceive both of our peoples." }
	}

end

function QuestDialoguewar()


end

function QuestDialogueancients()


end

function OtherDialogue()


--[[
title=" Universal exchanges"
--]]

	questions[500] = {
		action="jump", goto=501,  ftest= 2, -- insightful
		player="Can you tell me about...",
		playerFragment="...",
		alien={"Pray hast thou salvaged a Thrynn Battle Machine?  I may extend to you, for a such devices, 8 unit Myrrdan energy crystals." }
	}
	questions[501] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=510 },
			{ text="No.",  goto=520 },
		}
	}
	questions[510] = {
--		player_money = player_money + artifact14 * 3000
--		artifact14 = 0
		action="jump", goto=1, ftest= 1,
		player="",
		alien={"Transfering." }
	}
	questions[520] = {
		action="jump", goto=1,
		player="",
		alien={"Very well. " }
	}



	-- attack the player because attitude is too low
	questions[910] = {
		action="jump", goto=999,
		player="What can you tell us about...",
		alien={"We wouldst have no dealings with thee, friends of our enemies." }
	}
	-- hostile termination question
	questions[920] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"We now depart." }
	}
	-- neutral termination question
	questions[930] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"We must now depart." }
	}
	-- friendly termination question
	questions[940] = {
		action="jump", goto=997,
		player="[AUTO_REPEAT]",
		playerFragment="...",
		alien={"We must now take our leave [CAPTAIN].  Fare thee well friends and let thy path be sure." }
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


--[[ -------------------------------------------------------------------
--Randomized ship characteristics, 1st pass:
----------------------------------------------------------------------]]
function GenerateShips()

    -- COMBAT VALUES FOR THIS ALIEN RACE
--[[
    health = 100                    -- 100=baseline minimum
    mass = 1                        -- 1=tiny, 10=huge
	engineclass = 6
	shieldclass = 6
	armorclass = 1
	laserclass = 0
	missileclass = 3
	laser_modifier = 30				-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%

--]]



if (plot_stage == 1) then -- initial plot state

	health= gen_random(100)
	if (health < 30) then							health= 30							end

	mass= 1

	engineclass= 3
	if (engineclass < ship_engine_class) then		engineclass= ship_engine_class		end

	shieldclass= gen_random(6)
	if (shieldclass < 3) then						shieldclass= 3						end


	armorclass= 1

	laserclass= 0

	missileclass= 1
	--ship_missile_class

	laser_modifier= 0

	missile_modifier= gen_random(100)
	if (missile_modifier < 80) then 				missile_modifier= 80				end

elseif (plot_stage == 2) then -- virus plot state

	health= gen_random(100)
	if (health < 30) then							health= 30							end

	mass= 1

	engineclass= gen_random(3)
	if (engineclass < ship_engine_class) then		engineclass= ship_engine_class		end

	shieldclass= gen_random(6)
	if (shieldclass < 3) then						shieldclass= 3						end
	if (shieldclass < ship_shield_class -2) then	shieldclass= ship_shield_class -2	end


	armorclass= 1

	laserclass= 0

	missileclass= 2
	--ship_missile_class

	laser_modifier= 0

	missile_modifier= gen_random(100)
	if (missile_modifier < 60) then 				missile_modifier= 60				end


elseif (plot_stage == 3) or (plot_stage == 4) then -- war and ancients plot states

	health= gen_random(100)
	if (health < 60) then							health= 60							end

	mass= 1

	engineclass= gen_random(6)
	if (engineclass < 4) then						engineclass= 4						end
	if (engineclass < ship_engine_class) then		engineclass= ship_engine_class		end

	shieldclass= gen_random(6)
	if (shieldclass < 3) then						shieldclass= 3						end
	if (shieldclass < ship_shield_class -2) then	shieldclass= ship_shield_class -2	end


	armorclass= 1

	laserclass= 1

	missileclass= 4
	--ship_missile_class

	laser_modifier= 0

	missile_modifier= gen_random(100)
	if (missile_modifier < 20) then 				missile_modifier= 20				end


end


end


------------------------------------------------------------------------
-- SCRIPT INITIALIZATION -----------------------------------------------
------------------------------------------------------------------------
function Initialize()
	GenerateShips()		--Build alien ships.
	SetPlayerTables()


	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in



if (plot_stage == 1) then -- initial plot state

	DROPITEM1 = 10;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Elowan Shield Capacitor
	DROPITEM2 = 54;		DROPRATE2 = 25;	    DROPQTY2 = 2 -- Endurium
	DROPITEM3 = 36;		DROPRATE3 = 40;		DROPQTY3 = 2
	DROPITEM4 = 52;		DROPRATE4 = 75;		DROPQTY4 = 1
	DROPITEM5 = 6;		DROPRATE5 = 0;		DROPQTY5 = 1

elseif (plot_stage == 2) then -- virus plot state

	DROPITEM1 = 228;	DROPRATE1 = 80;		DROPQTY1 = 1 -- Elowan genetic material
	DROPITEM2 = 54;		DROPRATE2 = 25;	    DROPQTY2 = 2 -- Endurium
	DROPITEM3 = 36;		DROPRATE3 = 40;		DROPQTY3 = 2
	DROPITEM4 = 52;		DROPRATE4 = 75;		DROPQTY4 = 1
	DROPITEM5 = 6;		DROPRATE5 = 0;		DROPQTY5 = 1

elseif (plot_stage == 3) then -- war plot state

	DROPITEM1 = 10;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Elowan Shield Capacitor
	DROPITEM2 = 54;		DROPRATE2 = 25;	    DROPQTY2 = 2 -- Endurium
	DROPITEM3 = 36;		DROPRATE3 = 40;		DROPQTY3 = 2
	DROPITEM4 = 52;		DROPRATE4 = 75;		DROPQTY4 = 1
	DROPITEM5 = 6;		DROPRATE5 = 0;		DROPQTY5 = 1

elseif (plot_stage == 4) then -- ancients plot state

	DROPITEM1 = 10;	    DROPRATE1 = 90;		DROPQTY1 = 1 -- Elowan Shield Capacitor
	DROPITEM2 = 54;		DROPRATE2 = 25;	    DROPQTY2 = 2 -- Endurium
	DROPITEM3 = 36;		DROPRATE3 = 40;		DROPQTY3 = 2
	DROPITEM4 = 52;		DROPRATE4 = 75;		DROPQTY4 = 1
	DROPITEM5 = 6;		DROPRATE5 = 0;		DROPQTY5 = 1

end


	FTEST= -1	--FTEST is used to activate the commFxn, for decision making during conversations.

	number_of_actions = 0   -- number_of_actions counts the number of questions asked during the encounter

	--active_quest = 31 	--  debugging use
	--artifact14 = 1		--  debugging use
	--plot_stage = 1

if (plot_stage == 1) then -- initial plot state

	--initialize dialog
	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low
	elseif player_profession == "military" and active_quest == 31 then
		first_question = 999
	elseif player_profession == "scientific" and active_quest == 35 then
		first_question = 89000
	elseif player_profession == "freelance" and active_quest == 32 and artifact14 == 0 then
		first_question = 96000
	elseif player_profession == "freelance" and active_quest == 32 and artifact14 > 0 then
		first_question = 96100
	elseif player_profession == "freelance" and active_quest == 34 and artifact18 == 1 then
		first_question = 98000
	elseif player_profession == "freelance" and active_quest == 35 and artifact27 == 0 and artifact28 == 0 then
		first_question = 99000
	elseif player_profession == "freelance" and active_quest == 35 and artifact27 == 1 and artifact28 == 0 then
		first_question = 99500
	elseif artifact14 > 0 then
		first_question = 500
	else
		first_question = 1
	end

elseif (plot_stage == 2) then -- virus plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low

	elseif active_quest == 37 and artifact220 == 0 then -- miniature funnel bush
		first_question = 77000
	elseif active_quest == 37 and artifact220 > 0 then -- miniature funnel bush
		first_question = 77500
	else
		first_question = 1
	end

elseif (plot_stage == 3) then -- war plot state

	if ATTITUDE < 10 then
		first_question = 910 -- alien attacks the player if attitude drops too low
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

	starting_ATTITUDE = 100
	starting_posture = "obsequious"
	current_question = first_question
	next_question = first_question

	-- Attitude this value and higher unlocks all questions, alien lowers their shields, maximum number of questions may be asked
	friendlyattitude = 80
	-- Attitude this value and higher is a neutral attitude, alien disarmed weapons but has raised shields
	neutralattitude = 51


	--initialize globals as needed
	if ATTITUDE == nil then ATTITUDE = starting_ATTITUDE end
	if POSTURE == nil then POSTURE = starting_posture end

	--special consideration for ATTITUDEs
	if ATTITUDE < 10 then
	    ACTION = "attack"
	    RESPONSE = "Die you vile murderous human!"
	    --return
	end

	if player_profession == "military" and active_quest == 26 then
		ACTION = "attack"
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
	ATTITUDE
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
			ATTITUDE = ATTITUDE + 4
		elseif (POSTURE == "obsequious") then
			ATTITUDE = ATTITUDE - 2
		elseif (POSTURE == "hostile") then
			ATTITUDE = ATTITUDE - 20
		end

	elseif (type == 1) then							--statement
		if (POSTURE == "friendly") then
			ATTITUDE = ATTITUDE + 1
		elseif (POSTURE == "obsequious") then
			ATTITUDE = ATTITUDE - 0
		elseif (POSTURE == "hostile") then
			ATTITUDE = ATTITUDE - 3
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

	elseif (number_of_actions > 25) then
		goto_question = 940  -- jump to friendly termination question
		number_of_actions = 0

	elseif (ftest < 1) then
		return

	else											--question
		if (n == 10000) or (n == 20000) then  -- General adjustment every time a category is started
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE + 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE - 0
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 3
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
				ATTITUDE = ATTITUDE + 1
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 1
			end
		elseif (ftest == 3) then   --  Aggravating question
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE - 1
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE - 4
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 8
			end

		elseif (ftest == 6) then   --  asked about ships and defenses, a major no-no
			if (POSTURE == "friendly") then
				ATTITUDE = ATTITUDE - 8
			elseif (POSTURE == "obsequious") then
				ATTITUDE = ATTITUDE - 3
			elseif (POSTURE == "hostile") then
				ATTITUDE = ATTITUDE - 30
			end
		end

		if (n == 510) then
			player_Endurium = player_Endurium + 8
			artifact14 = 0
			ATTITUDE = ATTITUDE + 15

		elseif (plot_stage == 1) then -- initial plot state

			if (n == 96100) then
				if (ship_shield_class < max_shield_class) then
					goto_question = 96105
				else
					goto_question = 96106
				end
				if (POSTURE == "friendly") then
					ATTITUDE = ATTITUDE + 5
				elseif (POSTURE == "obsequious") then
					ATTITUDE = ATTITUDE + 1
				end
			elseif (n == 96105) then
				artifact14 = 0
				active_quest = active_quest + 1
				ship_shield_class = ship_shield_class + 1
			elseif (n == 96106) then
				artifact14 = 0
				active_quest = active_quest + 1
				player_Endurium = player_Endurium + 7

			elseif (n == 99500) then
				artifact27 = 0
				artifact28 = 1
				if (POSTURE == "friendly") then
					ATTITUDE = ATTITUDE + 10
				elseif (POSTURE == "obsequious") then
					ATTITUDE = ATTITUDE + 4
				elseif (POSTURE == "hostile") then
					ATTITUDE = ATTITUDE + 2
				end

			end

		elseif (plot_stage == 2) then -- virus plot state


			if (n == 77500) then -- Quest 37: Information about the smugglers
				artifact223 = 1
			end

		elseif (plot_stage == 3) then -- war plot state



		elseif (plot_stage == 4) then -- ancients plot state



		end
	end
end
