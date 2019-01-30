--[[
	ENCOUNTER SCRIPT FILE: ELOWAN   INITIAL

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


------------------------------------------------------------------------
-- OBSEQUIOUS DIALOGUE -------------------------------------------------
------------------------------------------------------------------------
function ObsequiousDialogue()
	--add as many greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack

		greetings[1] = {
		action="",
		player="Hail oh mighty ones, masters of the universe.",
		alien={"Please thee not, false flattery be not our foresight","Of thee this I prognosticate: irrationality plagues thy inconsistent action.","Pray cease thy unnecessary dementia."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"Please thee not, false flattery be not our foresight","Of thee this I prognosticate: irrationality plagues thy inconsistent action.","Pray cease thy unnecessary dementia."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"Please thee not, false flattery be not our foresight","Of thee this I prognosticate: irrationality plagues thy inconsistent action.","Pray cease thy unnecessary dementia."} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"Please thee not, false flattery be not our foresight","Of thee this I prognosticate: irrationality plagues thy inconsistent action.","Pray cease thy unnecessary dementia."} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"Please thee not, false flattery be not our foresight","Of thee this I prognosticate: irrationality plagues thy inconsistent action.","Pray cease thy unnecessary dementia."} }


		
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
		
	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"We are those of the vine and spore, allies of the peaceful, concern'd with such things as may be called truth, survival and perhaps justice against the Thrynn."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"In tranquillity, an empty answer.  In the constant attacks of the Thrynn hadst we grown weary, and free knowledge we no longer ferry."}
	}
	questions[30000] = {
		action="jump", goto=1,
		player="What can you tell us about the past?",
		alien={"Nothing more will we tell trespassers and interlopers."}
	}
	questions[40000] = {
		action="jump", goto=1,
		player="Tell us about the Ancients.",
		alien={"Nothing more will we tell trespassers and interlopers." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="We are interested in becoming allies of your great empire.  Where are your leaders?",  goto=51000 },
			{ text="Where is your home world?", goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=53000,
		player="We are interested in becoming allies of your great empire.  Where are your leaders?",
		alien={"Thy true interests are made apparent.  Thou would’st speak falsely and take advantage on us."}
	}
	questions[52000] = {
		action="jump", goto=53000,
		player="Where is your home world?",
		alien={"Encroach upon our sacred colony at thy peril.  May thy existence pass into what thou may call'st thine third life for suggesting such an attempt."}
	}
	questions[53000] = {
		action="attack",
		player="We do not have any hostile intentions!  Hello?",
		alien={"<Silence>"}
	}

	questions[11001] = {
		action="branch",
		choices = {
			{ text="What else can you tell us about your race?",  goto=11000 },
			{ text="What truth do you seek?", goto=12000 },
			{ text="Where can the Thrynn be found?", goto=13000 },
			{ text="Where is your homeworld?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="What else can you tell us about your race?",
		alien={"We extend to thee no vine, if thou would have it otherwise, prove thy intentions against the Thrynn war machine." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="What truth do you seek?",
		alien={"Nothing more will we tell trespassers and interlopers." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="Where can the Thrynn be found?",
		alien={"Likewise the murderous Thrynn home system they call Tharsarnsss, in your coordinate system Semias 3 - 5,66, canst thou find the ignorant ones to this day." }
	}
	questions[14000] = {
		action="jump", goto=53000,
		player="Where is your homeworld?",
		alien={"Encroach upon our sacred colony at thy peril.  May thy existence pass into what thou may call'st thine third life for such an attempt." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about the Thrynn conflict?",  goto=21000 },
			{ text="Can you not at least tell us about nearby races?",  goto=22000 },
			{ text="What can you tell us about the Thrynn?",  goto=23000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[21000] = {
		action="jump", goto=21001,
		player="What can you tell us about the Thrynn conflict?",
		alien={"The Thrynn constant attacks keepest us on our guard, their malice and trickery all have seen.  Unless thou wouds't play a role, distrust you we will." }
	}

	questions[22000] = {
		action="jump", goto=21001,
		player="Can you not at least tell us about nearby races?",
		alien={"The Spemin knowest little and mostly do they wimper.  Upon driving them shalt thou gain'st only an enemy, yet one who shalt not a danger pose." }
	}
	questions[23000] = {
		action="jump", goto=23101,
		player="What can you tell us about the Thrynn?",
		alien={"An untrustworthy race, if thou hadst not already allied with them.  One that pretends, portraying to be what they are not.  They embrace the machine and would do thee harm shoud'st they be given the chance to do so." }
	}

	questions[23101] = {
		action="branch",
		choices = {
			{ text="Where can the Thrynn be found?",  goto=23100 },
			{ text="Do you consider the Thrynn enemies?",  goto=23200 },
			{ text="Why do you dislike the Thrynn?",  goto=23300 },
			{ text="Can't you leave, if you are located near the Thrynn?",  goto=23400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[23100] = {
		action="jump", goto=23101,
		player="Where can the Thrynn be found?",
		alien={"Likewise the murderous Thrynn home system they call Tharsarnsss, in your coordinate system Semias 3 - 5,66, canst thou find the ignorant ones to this day." }
	}
	questions[23200] = {
		action="jump", goto=23101,
		player="Do you consider the Thrynn enemies?",
		alien={"Constant and fierce have been the attack of the vile Thrynn from ancient times, e'er since the empire fell and could no longer judge them.  We seeketh only peace, from both they and freelancers/pirates such as yourself, rare as it could be found." }
	}
	questions[23300] = {
		action="jump", goto=23101,
		player="Why do you dislike the Thrynn?",
		alien={"Must such pirates profess ignorance?  Such a conundrum thou art, appearances be thee marred, yet answers and not violence doth thou seek." }
	}
	questions[23400] = {
		action="jump", goto=23101,
		player="Can't you leave, if you are located near the Thrynn?",
		alien={"None but a few of us remain, and only one location we defend, as the Thrynn pursue us to the end." }
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
		alien={"Thou doest now encounter the Elowan.  Pray that thy continued existence is assured.","Statest thou thine intentions immediately and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.","Turn back now interloper.  We are Elowan.  We greet thee with no malice, but distrust thy intent."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Thou doest now encounter the Elowan.  Pray that thy continued existence is assured.","Statest thou thine intentions immediately and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.","Turn back now interloper.  We are Elowan.  We greet thee with no malice, but distrust thy intent."} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Thou doest now encounter the Elowan.  Pray that thy continued existence is assured.","Statest thou thine intentions immediately and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.","Turn back now interloper.  We are Elowan.  We greet thee with no malice, but distrust thy intent."} }
	greetings[4] = {
		action="",
		player="Dude, that is one green ship you have there!",
		alien={"Thou doest now encounter the Elowan.  Pray that thy continued existence is assured.","Statest thou thine intentions immediately and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.","Turn back now interloper.  We are Elowan.  We greet thee with no malice, but distrust thy intent."} }
	greetings[5] = {
		action="",
		player="How's it going, weird, carnivorous plant things?",
		alien={"Thou doest now encounter the Elowan.  Pray that thy continued existence is assured.","Statest thou thine intentions immediately and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.","Turn back now interloper.  We are Elowan.  We greet thee with no malice, but distrust thy intent."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"Such concepts of respect doth we reflect in like measure upon thee.","Trust me like measure shall be granted upon the trustworthy.","Faith and understanding doth we extend to thine companions and thou kind."} }
	statements[2] = {
		action="",
		player="Your ship appears very unusual.",
		alien={"Such concepts of respect doth we reflect in like measure upon thee.","Trust me like measure shall be granted upon the trustworthy.","Faith and understanding doth we extend to thine companions and thou kind."} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"Such concepts of respect doth we reflect in like measure upon thee.","Trust me like measure shall be granted upon the trustworthy.","Faith and understanding doth we extend to thine companions and thou kind."} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"Such concepts of respect doth we reflect in like measure upon thee.","Trust me like measure shall be granted upon the trustworthy.","Faith and understanding doth we extend to thine companions and thou kind."} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"Such concepts of respect doth we reflect in like measure upon thee.","Trust me like measure shall be granted upon the trustworthy.","Faith and understanding doth we extend to thine companions and thou kind."} }
		 



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"We are those of the vine and spore, allies of the peaceful, concern'd with such things as may be called truth, survival and perhaps justice against the Thrynn."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"In tranquillity, an empty answer.  In the constant attacks of the Thrynn hadst we grown weary, and free knowledge we no longer ferry."}
	}
	questions[30000] = {
		action="jump", goto=1,
		player="What can you tell us about the past?",
		alien={"Nothing more will we tell trespassers and interlopers."}
	}
	questions[40000] = {
		action="jump", goto=1,
		player="Tell us about the Ancients.",
		alien={"Nothing more will we tell trespassers and interlopers." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="We are interested in becoming allies of your great empire.  Where are your leaders?",  goto=51000 },
			{ text="Where is your home world?", goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=53000,
		player="We are interested in becoming allies of your great empire.  Where are your leaders?",
		alien={"Thy true interests are made apparent.  Thou would’st speak falsely and take advantage on us."}
	}
	questions[52000] = {
		action="jump", goto=53000,
		player="Where is your home world?",
		alien={"Encroach upon our sacred colony at thy peril.  May thy existence pass into what thou may call'st thine third life for suggesting such an attempt."}
	}
	questions[53000] = {
		action="attack",
		player="We do not have any hostile intentions!  Hello?",
		alien={"<Silence>"}
	}

	questions[11001] = {
		action="branch",
		choices = {
			{ text="What else can you tell us about your race?",  goto=11000 },
			{ text="What truth do you seek?", goto=12000 },
			{ text="Where can the Thrynn be found?", goto=13000 },
			{ text="Where is your homeworld?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="What else can you tell us about your race?",
		alien={"We extend to thee no vine, if thou would have it otherwise, prove thy intentions against the Thrynn war machine." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="What truth do you seek?",
		alien={"Nothing more will we tell trespassers and interlopers." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="Where can the Thrynn be found?",
		alien={"Likewise the murderous Thrynn home system they call Tharsarnsss, in your coordinate system Semias 3 - 5,66, canst thou find the ignorant ones to this day." }
	}
	questions[14000] = {
		action="jump", goto=53000,
		player="Where is your homeworld?",
		alien={"Encroach upon our sacred colony at thy peril.  May thy existence pass into what thou may call'st thine third life for such an attempt." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about the Thrynn conflict?",  goto=21000 },
			{ text="Can you not at least tell us about nearby races?",  goto=22000 },
			{ text="What can you tell us about the Thrynn?",  goto=23000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[21000] = {
		action="jump", goto=21001,
		player="What can you tell us about the Thrynn conflict?",
		alien={"The Thrynn constant attacks keepest us on our guard, their malice and trickery all have seen.  Unless thou wouds't play a role, distrust you we will." }
	}

	questions[22000] = {
		action="jump", goto=21001,
		player="Can you not at least tell us about nearby races?",
		alien={"The Spemin knowest little and mostly do they wimper.  Upon driving them shalt thou gain'st only an enemy, yet one who shalt not a danger pose." }
	}
	questions[23000] = {
		action="jump", goto=23101,
		player="What can you tell us about the Thrynn?",
		alien={"An untrustworthy race, if thou hadst not already allied with them.  One that pretends, portraying to be what they are not.  They embrace the machine and would do thee harm shoud'st they be given the chance to do so." }
	}

	questions[23101] = {
		action="branch",
		choices = {
			{ text="Where can the Thrynn be found?",  goto=23100 },
			{ text="Do you consider the Thrynn enemies?",  goto=23200 },
			{ text="Why do you dislike the Thrynn?",  goto=23300 },
			{ text="Can't you leave, if you are located near the Thrynn?",  goto=23400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[23100] = {
		action="jump", goto=23101,
		player="Where can the Thrynn be found?",
		alien={"Likewise the murderous Thrynn home system they call Tharsarnsss, in your coordinate system Semias 3 - 5,66, canst thou find the ignorant ones to this day." }
	}
	questions[23200] = {
		action="jump", goto=23101,
		player="Do you consider the Thrynn enemies?",
		alien={"Constant and fierce have been the attack of the vile Thrynn from ancient times, e'er since the empire fell and could no longer judge them.  We seeketh only peace, from both they and freelancers/pirates such as yourself, rare as it could be found." }
	}
	questions[23300] = {
		action="jump", goto=23101,
		player="Why do you dislike the Thrynn?",
		alien={"Must such pirates profess ignorance?  Such a conundrum thou art, appearances be thee marred, yet answers and not violence doth thou seek." }
	}
	questions[23400] = {
		action="jump", goto=23101,
		player="Can't you leave, if you are located near the Thrynn?",
		alien={"None but a few of us remain, and only one location we defend, as the Thrynn pursue us to the end." }
	}


end

------------------------------------------------------------------------
-- HOSTILE DIALOGUE ----------------------------------------------------
------------------------------------------------------------------------
function HostileDialogue()
	--add as many player greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack
	greetings[1] = {
		action="attack",
		player="This is captain [CAPTAIN] of the starship [SHIPNAME]. Identify yourselves immediately or be destroyed.",
		alien={"'Tis our wish that no pirates nor interlopers disrespect the Elowan.","Despicable and untrustworthy monster, leave our space."} }
	greetings[2] = {
		action="attack",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"'Tis our wish that no pirates nor interlopers disrespect the Elowan.","Despicable and untrustworthy monster, leave our space."}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"Thou addresses the Elowan."} }
	greetings[4] = {
		action="attack",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"'Tis our wish that no pirates nor interlopers disrespect the Elowan.","Despicable and untrustworthy monster, leave our space."} }
	greetings[5] = {
		action="attack",
		player="We require information. Comply or be destroyed.",
		alien={"'Tis our wish that no pirates nor interlopers disrespect the Elowan.","Despicable and untrustworthy monster, leave our space."} }
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship is over-embellished and weak.",
		alien={"Nae, we refute this.","Ascetics be not thy forte."} }
	statements[2] = {
		action="",
		player="What an ugly and worthless creature.",
		alien={"Nae, we refute this.","Ascetics be not thy forte."} }
	statements[3] = {
		action="",
		player="Your ship looks like a flying garbage scow.",
		alien={"Nae, we refute this.","Ascetics be not thy forte."} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"We are those of the vine and spore, allies of the peaceful, concern'd with such things as may be called truth, survival and perhaps justice against the Thrynn."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"In tranquillity, an empty answer.  In the constant attacks of the Thrynn hadst we grown weary, and free knowledge we no longer ferry."}
	}
	questions[30000] = {
		action="jump", goto=1,
		player="What can you tell us about the past?",
		alien={"Nothing more will we tell trespassers and interlopers."}
	}
	questions[40000] = {
		action="jump", goto=1,
		player="Tell us about the Ancients.",
		alien={"Nothing more will we tell trespassers and interlopers." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your ships and defenses?",  goto=51000 },
			{ text="Where is your home world?", goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=53000,
		player="What can you tell us about your ships and defenses?",
		alien={"Thy true interests are made apparent.  Thou would’st speak falsely and take advantage on us."}
	}
	questions[52000] = {
		action="jump", goto=53000,
		player="Where is your home world?",
		alien={"Encroach upon our sacred colony at thy peril.  May thy existence pass into what thou may call'st thine third life for suggesting such an attempt."}
	}
	questions[53000] = {
		action="attack",
		player="We do not have any hostile intentions!  Hello?",
		alien={"<Silence>"}
	}

	questions[11001] = {
		action="branch",
		choices = {
			{ text="What else can you tell us about your race?",  goto=11000 },
			{ text="What truth do you seek?", goto=12000 },
			{ text="Where can the Thrynn be found?", goto=13000 },
			{ text="Where is your homeworld?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="What else can you tell us about your race?",
		alien={"We extend to thee no vine, if thou would have it otherwise, prove thy intentions against the Thrynn war machine." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="What truth do you seek?",
		alien={"Nothing more will we tell trespassers and interlopers." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="Where can the Thrynn be found?",
		alien={"Likewise the murderous Thrynn home system they call Tharsarnsss, in your coordinate system Semias 3 - 5,66, canst thou find the ignorant ones to this day." }
	}
	questions[14000] = {
		action="jump", goto=53000,
		player="Where is your homeworld?",
		alien={"Encroach upon our sacred colony at thy peril.  May thy existence pass into what thou may call'st thine third life for such an attempt." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about the Thrynn conflict?",  goto=21000 },
			{ text="Can you not at least tell us about nearby races?",  goto=22000 },
			{ text="What can you tell us about the Thrynn?",  goto=23000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[21000] = {
		action="jump", goto=21001,
		player="What can you tell us about the Thrynn conflict?",
		alien={"The Thrynn constant attacks keepest us on our guard, their malice and trickery all have seen.  Unless thou wouds't play a role, distrust you we will." }
	}

	questions[22000] = {
		action="jump", goto=21001,
		player="Can you not at least tell us about nearby races?",
		alien={"The Spemin knowest little and mostly do they wimper.  Upon driving them shalt thou gain'st only an enemy, yet one who shalt not a danger pose." }
	}
	questions[23000] = {
		action="jump", goto=23101,
		player="What can you tell us about the Thrynn?",
		alien={"An untrustworthy race, if thou hadst not already allied with them.  One that pretends, portraying to be what they are not.  They embrace the machine and would do thee harm shoud'st they be given the chance to do so." }
	}

	questions[23101] = {
		action="branch",
		choices = {
			{ text="Where can the Thrynn be found?",  goto=23100 },
			{ text="Do you consider the Thrynn enemies?",  goto=23200 },
			{ text="Why do you dislike the Thrynn?",  goto=23300 },
			{ text="Can't you leave, if you are located near the Thrynn?",  goto=23400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[23100] = {
		action="jump", goto=23101,
		player="Where can the Thrynn be found?",
		alien={"Likewise the murderous Thrynn home system they call Tharsarnsss, in your coordinate system Semias 3 - 5,66, canst thou find the ignorant ones to this day." }
	}
	questions[23200] = {
		action="jump", goto=23101,
		player="Do you consider the Thrynn enemies?",
		alien={"Constant and fierce have been the attack of the vile Thrynn from ancient times, e'er since the empire fell and could no longer judge them.  We seeketh only peace, from both they and freelancers/pirates such as yourself, rare as it could be found." }
	}
	questions[23300] = {
		action="jump", goto=23101,
		player="Why do you dislike the Thrynn?",
		alien={"Must such pirates profess ignorance?  Such a conundrum thou art, appearances be thee marred, yet answers and not violence doth thou seek." }
	}
	questions[23400] = {
		action="jump", goto=23101,
		player="Can't you leave, if you are located near the Thrynn?",
		alien={"None but a few of us remain, and only one location we defend, as the Thrynn pursue us to the end." }
	}

end

------------------------------------------------------------------------
-- SCRIPT INITIALIZATION -----------------------------------------------
------------------------------------------------------------------------
function Initialize()
    -- COMBAT VALUES FOR THIS ALIEN RACE
    health = 100                    -- 100=baseline minimum
    mass = 1                        -- 1=tiny, 10=huge
	engineclass = 6
	shieldclass = 6
	armorclass = 1
	laserclass = 0
	missileclass = 3
	laser_modifier = 0				-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%

	
	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in
	--10 -  Elowan Shield Capacitor
	
	DROPITEM1 = 10;	    DROPRATE1 = 96;		DROPQTY1 = 1
	DROPITEM2 = 33;		DROPRATE2 = 25;	    DROPQTY2 = 2
	DROPITEM3 = 36;		DROPRATE3 = 40;		DROPQTY3 = 2
	DROPITEM4 = 52;		DROPRATE4 = 75;		DROPQTY4 = 1
	DROPITEM5 = 54;		DROPRATE5 = 60;		DROPQTY5 = 1

	
	--initialize dialog
	if player_profession == "scientific" and active_quest == 35 then
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
--	elseif artifact14 > 1 then
--		first_question = 500
	else
		first_question = 1
	end
	
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


	questions[89000] = {
		action="jump", goto=1,
		player="This is Captain [CAPTAIN] of the starship [SHIPNAME].  Will you help us decode this fragmentary data showing the location of a planet possibly containing exotic particles?",
		alien={"Thou dost seek after the rare truth indeed.   'Tis our analysis that the location orbits a F or G class star.  Fragmentary lies all other data." }
	}
		
	questions[96000] = {
		action="jump", goto=96001,
		player="Could you use aid against the Thrynn?",
		alien={"We extend to thee no vine, if thou would have it otherwise, prove thy intentions against the Thrynn war machine.  Return with a Thrynn Battle Machine and thou willst earn our gratitude." }
	}
	questions[96001] = {
		action="jump", goto=96002,
		player="Why have you not been able to salvage one yourself?",
		alien={"Our small ships are not equipped for salvage operations." }
	}
	questions[96002] = {
		action="terminate",
		player="What would you give us for our efforts?",
		alien={"Thy shielding technology appears primitive and we mayst perchance improve on it.  No more do we have time at this junction." }
	}


	questions[96100] = {
		action="jump", goto=1,
		artifact14 = 0,
--		active_quest = active_quest + 1,
--		ship_shield_class = ship_shield_class + 1,
		player="I have brought a Thrynn Battle Machine.",
		alien={"We are transporting to thee specifications of our shielding technology." }
	}

	questions[98000] = {
		action="jump", goto=98001,
		player="Would you be interested in purchasing incredibly old artistic containers?",
		alien={"No." }
	}
	questions[98001] = {
		action="jump", goto=98002,
		player="Are you sure?  These containers are incredibly beautiful.",
		alien={"No. " }
	}
	questions[98002] = {
		action="jump", goto=1,
		player="I am willing to negotiate.  Can you not agree that these items interest you?",
		alien={"No." }
	}
	
	questions[99000] = {
		action="jump", goto=99001,
		player="Tell us about the Elowan – Tafel conflict",
		alien={"'Tis a sorrowful tale of woe.  Perchance this apparent bastion uncovered in the blackness of space.  Tranquil dreams thus extended of vine and root." }
	}
	questions[99001] = {
		action="jump", goto=99002,
		player="You are saying that you established a colony?",
		alien={"Indeed upon this world doth our young now abide.  Difficult but for many cycles now save from death's skythe to flee.  The miniature ones likewise doth have no such restriction." }
	}
	questions[99002] = {
		action="jump", goto=99003,
		player="So you cannot leave?  Why can't you get along with the Tafel?",
		alien={"The Tafel thou call'st were quiescent for an age.  E're long a blackening dust was spread through the skies, imperiling the songs of the young.  The Tafel woud'st deny their action, yet no other industries may be found."}
	}
	questions[99003] = {
		action="jump", goto=1,
		player="Could another source have caused the dust?",
		alien={"No other source encroached on this system.  A Bar-zhon warship mayhap traversed the system at one time, yet no action did they  take in this demesne."}
	}

	questions[99500] = {
		artifact27 = 0,
		artifact28 = 1,
		action="jump", goto=1,
		player="We located this Thrynn probe which delivered the dust.",
		alien={"The heinous Thrynn nurtured this profane seed?  Thou wouldst carry our thanks for thy heroic actions.  Conflict with the Tafel is over.  We give you this minor token of thanks and certification of your accomplishment."}
	}

	
	questions[500] = {
		action="jump", goto=501,
		player="Can you tell me about...",
		alien={"Pray have you have savaged a Thrynn Battle Machine?  I may extend to you, for all such devices, 3000 M.U. Myrrdan resources per unit." }
	}
	questions[501] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=510 },
			{ text="No.",  goto=520 },
		}
	}
	questions[510] = {
--		player_money = player_money + artifact14 * 3000,
		artifact14 = 0,
		action="jump", goto=1,
		player="",
		alien={"Transfering." }
	}
	questions[520] = {
		action="jump", goto=1,
		player="",
		alien={"Very well. " }
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

