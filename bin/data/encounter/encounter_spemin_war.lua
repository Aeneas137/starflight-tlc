--[[
	ENCOUNTER SCRIPT FILE: SPEMIN  WAR

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
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."} }


		
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
		
	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"We are the Spemin."}
	}
	questions[20000] = {
		action="jump", goto=20002,
		player="What can you tell us about the other races in the galaxy?",
		alien={"We of the Royal Spemin navy meet all races with unwavering courage and conviction.  You must envy us with our vast ... umm ... What was your question?"}
	}
	questions[20002] = {
		action="jump", goto=20001,
		player="Tell us about other alien races.",
		alien={"Ok, will do."}
	}
	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about the past?",
		alien={"Yeah, so?"}
	}
	questions[40000] = {
		action="jump", goto=40001,
		player="Tell us about the Ancients.",
		alien={"We were once known as the Ancients.  You would be wise not to antagonize us." }
	}
	questions[40001] = {
		action="jump", goto=1,
		player="Why are your ships so weak if you are the Ancients?",
		alien={"These forms you see before you are merely holographic projections.  We grant you a boon.  Feel free to collect any of our endurium on Bec-Felmas 3 - 16,183 or Mathgen 4 - 212,3." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="I demand that you give us all your cargo!",  goto=51000 },
			{ text="Where is your home world?", goto=52000 },
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="<Back>",  goto=1 }
		}
	}
 	questions[51000] = {
		action="jump", goto=51100,
		player="",
		alien={"No."}
	}
	questions[51100] = {
		action="branch",
		choices = {
			{ text="If you do not give us your cargo, we will destroy you.",  goto=51101 },
			{ text="<Back>",  goto=50000 }
		}
	}
 	questions[51101] = {
		action="jump", goto=51110,
		player="",
		alien={"Fools!  You face the Spemin Gods!  Do not incur our wrath!"}
	}
	questions[51110] = {
		action="branch",
		choices = {
			{ text="Give us your cargo.  Now!",  goto=51111 },
			{ text="<Back>",  goto=50000 }
		}
	}	
	 questions[51111] = {
		action="jump", goto=51112,
		player="",
		alien={"Prepare for excruciating pain, unbearable agony, the most horrible of deaths, the most unimaginable torture. Any moment now we shall attack."}
	}
 	questions[51112] = {
		action="terminate",
		player="Umm, are you going to attack us?",
		alien={"Any moment now I shall ooze down and absorb you like so much food substance.  Feel free to run."}
	}
	questions[52000] = {
		action="jump", goto=52001,
		player="Where is your home world?",
		alien={"That location is a secret.  You would have to first ask permission of our leaders before we divulged such information."}
	}
	questions[52001] = {
		action="jump", goto=50000,
		player="So where are your leaders?",
		alien={"Oh, you can find them at Dian Cecht 3 - 35,139."}
	}
	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"...Unable...to...contact...Uyo...host...  We...must...verify..." }
	}
	questions[60001] = {
			action="branch",
			choices = {
				{ text="What do you mean Uyo host?", goto=61000 },
				{ text="Why are you trying to contact a Uyo host?", goto=62000 },
				{ text="Why are you mumbling so strangely?", goto=63000 },
				{ text="What about the Minex war?", goto=64000 },
				{ text="<Back>", goto=50000 }
			}
		}
		questions[61000] = {
			action="jump", goto=61001,
			player="",
			alien={"Everything is fine.  We are fine." }
		}
		questions[61001] = {
			action="jump", goto=60001,
			player="What or who is Uyo?",
			alien={"We Spemin have knowledge beyond any other race.  Uyo was a great explorer and navigator who charted a vast cloud nebulae.  This occurred thousands of your Myrrdan years ago." }
		}
		questions[62000] = {
			action="jump", goto=60001,
			player="",
			alien={"I know everything about Uyo hosts.  I just cannot, I mean choose not to tell you about them." }
		}
		questions[63000] = {
			action="jump", goto=60001,
			player="",
			alien={"You need to talk to your communications officer because he/she/it might be going mad with madness.  I have been patiently waiting for your next response and you accuse me with your unjust accusations." }
		}
		questions[64000] = {
			action="jump", goto=60001,
			player="",
			alien={"The Minex are not at war, they always destroy us when we see them.  The Thrynn have decided to completely leave us alone now!  I am sorry, is someone at war?" }
		}


	questions[11001] = {
		action="branch",
		choices = {
			{ text="What type of government do you have?",  goto=11000 },
			{ text="What can you tell us about your biology?", goto=12000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="What type of government do you have?",
		alien={"'Tis thus then that the Secret Society of Spemin Superiority said so.  Thus they thereby spoke and said." }
	}
	questions[12000] = {
		action="jump", goto=12001,
		player="What can you tell us about your biology?",
		alien={"Our antennae are a bit overloaded at the moment.  Please come back later.  Much, much, many, moving, later." }
	}
	questions[12001] = {
		action="jump", goto=12002,
		player="Are you guys alright?",
		alien={"Minex standard protocols.  Containment, transmit, scramble, relay positional geometries.  Yes, we are just fine." }
	}
	questions[12002] = {
		action="jump", goto=11001,
		player="What did you say about the Minex?",
		alien={"You are crazy.  I did not say anything about the Minex." }
	}
	
	questions[20001] = {
		action="branch",
		choices = {
			{ text="What other races have you encountered?",  goto=21000 },
			{ text="Do you encounter any races outward of your area of space?",  goto=22000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[21000] = {
		action="jump", goto=21002,
		player="",
		alien={"Necessity for control nexus increasing.  Unabe to locate Uyo center.  Unable to complete thrall enslavement of biological resources.  Solution: unknown." }
	}
	questions[21002] = {
		action="jump", goto=21001,
		player="What???",
		alien={"Primary objective unattainable.  Secondary objectives nearly complete." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="",
		alien={"No.  Outward of this area lies a vast dead zone where systems are filled with planets scorched clean of life.  No intelligent spacefaring races have ever approached us from this area, and no life bearing planets have we ever found." }
	}
	questions[21001] = {
		action="branch",
		choices = {
		
			{ text="What do you mean, secondary objectives?",  goto=21100 },
			{ text="Why are you rambling nonsense?",  goto=21200 },
			{ text="<Back>", goto=20001 }
		}
	}

		questions[21100] = {
			action="jump", goto=21101,
			player="",
			alien={"We Spemin have no objectives.  We seek to multiply and reach out into space, discovering new ideas and technologies, while trying to avoid being brutally killed." }
		}
		questions[21101] = {
			action="jump", goto=21102,
			player="Are those things your objectives then?",
			alien={"Our goals are secret.  They are also mysterious and unavoidable.  Why do you speak of objectives?  We Spemin would sooner die then divulge our secrets." }
		}
		questions[21102] = {
			action="jump", goto=21001,
			player="You said something about primary and secondary objectives.",
			alien={"I did not.  You aliens are mad like everyone else." }
		}
		questions[21200] = {
			action="jump", goto=21201,
			player="",
			alien={"Spemin do not ramble.  Even as we speak, our antenna are picking up powerful new signals from the stars that are boosting our evolutional process and brain power one hundredfold." }
		}
		questions[21201] = {
			action="jump", goto=21001,
			player="What signals?",
			alien={"Broadband channel 8301.  The transmissions are like the brainwaves of the gods, except we are already gods.  They are the brainwaves of whatever is greater then the gods." }
		}

	questions[30001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about Spemin history?",  goto=31000 },
			{ text="What about the ancient past?",  goto=32000 },
			{ text="Can you tell us about any historic events?",  goto=33000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[31000] = {
		action="jump", goto=31001,
		player="",
		alien={"At first many of the degenerate races tried to make us into slaves.  We are not slaves.  The Tri'na'li'da is slowly enslaving us all until their return." }
	}
	questions[31001] = {
		action="jump", goto=31002,
		player="The what?  Who is returning?",
		alien={"That is the true name of the virus as the gods have revealed it to us.  They are returning and want us humble in their presence." }
	}
	questions[31002] = {
		action="jump", goto=30001,
		player="When are they returning?",
		alien={"The prerogative of the gods alone decrees when they will arrive.  When they arrive and what they will do when they get here is solely up to them." }
	}
	questions[32000] = {
		action="jump", goto=30001,
		player="What about the ancient past?",
		alien={"Historical fact shows us that the Spemin, then known as Ancients once ruled the galaxy.  This was when all races knew peace and love.  Since then fighting and death have separated us all and have deluded many into thinking that force is the answer to everything.  Since then we have forgotten, I mean we choose not to create any more endurium." }
	}
	questions[33000] = {
		action="jump", goto=30001,
		player="Can you tell us about any historic events?",
		alien={"No.  The past is before.  The future is ahead.  The present is now.  We must watch the future with an eye on the past even as the present oozes ahead.  This is only a sample of our profound wisdom." }
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
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."} }
	greetings[4] = {
		action="",
		player="Dude, that is one funky ship you have there!",
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."} }
	greetings[5] = {
		action="",
		player="How's it going, blob thing?",
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[2] = {
		action="",
		player="Your ship appears very simple yet functional.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together...uhh...nevermind...let us be friends.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
		 



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"We are the Spemin."}
	}
	questions[20000] = {
		action="jump", goto=20002,
		player="What can you tell us about the other races in the galaxy?",
		alien={"We of the Royal Spemin navy meet all races with unwavering courage and conviction.  You must envy us with our vast ... umm ... What was your question?"}
	}
	questions[20002] = {
		action="jump", goto=20001,
		player="Tell us about other alien races.",
		alien={"Ok, will do."}
	}
	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about the past?",
		alien={"Yeah, so?"}
	}
	questions[40000] = {
		action="jump", goto=40001,
		player="Tell us about the Ancients.",
		alien={"We were once known as the Ancients.  You would be wise not to antagonize us." }
	}
	questions[40001] = {
		action="jump", goto=1,
		player="Why are your ships so weak if you are the Ancients?",
		alien={"These forms you see before you are merely holographic projections.  We grant you a boon.  Feel free to collect any of our endurium on Bec-Felmas 3 - 16,183 or Mathgen 4 - 212,3." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="I demand that you give us all your cargo!",  goto=51000 },
			{ text="Where is your home world?", goto=52000 },
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="<Back>",  goto=1 }
		}
	}
 	questions[51000] = {
		action="jump", goto=51100,
		player="",
		alien={"No."}
	}
	questions[51100] = {
		action="branch",
		choices = {
			{ text="If you do not give us your cargo, we will destroy you.",  goto=51101 },
			{ text="<Back>",  goto=50000 }
		}
	}
 	questions[51101] = {
		action="jump", goto=51110,
		player="",
		alien={"Fools!  You face the Spemin Gods!  Do not incur our wrath!"}
	}
	questions[51110] = {
		action="branch",
		choices = {
			{ text="Give us your cargo.  Now!",  goto=51111 },
			{ text="<Back>",  goto=50000 }
		}
	}	
	 questions[51111] = {
		action="jump", goto=51112,
		player="",
		alien={"Prepare for excruciating pain, unbearable agony, the most horrible of deaths, the most unimaginable torture. Any moment now we shall attack."}
	}
 	questions[51112] = {
		action="terminate",
		player="Umm, are you going to attack us?",
		alien={"Any moment now I shall ooze down and absorb you like so much food substance.  Feel free to run."}
	}
	questions[52000] = {
		action="jump", goto=52001,
		player="Where is your home world?",
		alien={"That location is a secret.  You would have to first ask permission of our leaders before we divulged such information."}
	}
	questions[52001] = {
		action="jump", goto=50000,
		player="So where are your leaders?",
		alien={"Oh, you can find them at Dian Cecht 3 - 35,139."}
	}
	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"...Unable...to...contact...Uyo...host...  We...must...verify..." }
	}
	questions[60001] = {
			action="branch",
			choices = {
				{ text="What do you mean Uyo host?", goto=61000 },
				{ text="Why are you trying to contact a Uyo host?", goto=62000 },
				{ text="Why are you mumbling so strangely?", goto=63000 },
				{ text="What about the Minex war?", goto=64000 },
				{ text="<Back>", goto=50000 }
			}
		}
		questions[61000] = {
			action="jump", goto=61001,
			player="",
			alien={"Everything is fine.  We are fine." }
		}
		questions[61001] = {
			action="jump", goto=60001,
			player="What or who is Uyo?",
			alien={"We Spemin have knowledge beyond any other race.  Uyo was a great explorer and navigator who charted a vast cloud nebulae.  This occurred thousands of your Myrrdan years ago." }
		}
		questions[62000] = {
			action="jump", goto=60001,
			player="",
			alien={"I know everything about Uyo hosts.  I just cannot, I mean choose not to tell you about them." }
		}
		questions[63000] = {
			action="jump", goto=60001,
			player="",
			alien={"You need to talk to your communications officer because he/she/it might be going mad with madness.  I have been patiently waiting for your next response and you accuse me with your unjust accusations." }
		}
		questions[64000] = {
			action="jump", goto=60001,
			player="",
			alien={"The Minex are not at war, they always destroy us when we see them.  The Thrynn have decided to completely leave us alone now!  I am sorry, is someone at war?" }
		}


	questions[11001] = {
		action="branch",
		choices = {
			{ text="What type of government do you have?",  goto=11000 },
			{ text="What can you tell us about your biology?", goto=12000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="What type of government do you have?",
		alien={"'Tis thus then that the Secret Society of Spemin Superiority said so.  Thus they thereby spoke and said." }
	}
	questions[12000] = {
		action="jump", goto=12001,
		player="What can you tell us about your biology?",
		alien={"Our antennae are a bit overloaded at the moment.  Please come back later.  Much, much, many, moving, later." }
	}
	questions[12001] = {
		action="jump", goto=12002,
		player="Are you guys alright?",
		alien={"Minex standard protocols.  Containment, transmit, scramble, relay positional geometries.  Yes, we are just fine." }
	}
	questions[12002] = {
		action="jump", goto=11001,
		player="What did you say about the Minex?",
		alien={"You are crazy.  I did not say anything about the Minex." }
	}
	
	questions[20001] = {
		action="branch",
		choices = {
			{ text="What other races have you encountered?",  goto=21000 },
			{ text="Do you encounter any races outward of your area of space?",  goto=22000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[21000] = {
		action="jump", goto=21002,
		player="",
		alien={"Necessity for control nexus increasing.  Unabe to locate Uyo center.  Unable to complete thrall enslavement of biological resources.  Solution: unknown." }
	}
	questions[21002] = {
		action="jump", goto=21001,
		player="What???",
		alien={"Primary objective unattainable.  Secondary objectives nearly complete." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="",
		alien={"No.  Outward of this area lies a vast dead zone where systems are filled with planets scorched clean of life.  No intelligent spacefaring races have ever approached us from this area, and no life bearing planets have we ever found." }
	}
	questions[21001] = {
		action="branch",
		choices = {
		
			{ text="What do you mean, secondary objectives?",  goto=21100 },
			{ text="Why are you rambling nonsense?",  goto=21200 },
			{ text="<Back>", goto=20001 }
		}
	}

		questions[21100] = {
			action="jump", goto=21101,
			player="",
			alien={"We Spemin have no objectives.  We seek to multiply and reach out into space, discovering new ideas and technologies, while trying to avoid being brutally killed." }
		}
		questions[21101] = {
			action="jump", goto=21102,
			player="Are those things your objectives then?",
			alien={"Our goals are secret.  They are also mysterious and unavoidable.  Why do you speak of objectives?  We Spemin would sooner die then divulge our secrets." }
		}
		questions[21102] = {
			action="jump", goto=21001,
			player="You said something about primary and secondary objectives.",
			alien={"I did not.  You aliens are mad like everyone else." }
		}
		questions[21200] = {
			action="jump", goto=21201,
			player="",
			alien={"Spemin do not ramble.  Even as we speak, our antenna are picking up powerful new signals from the stars that are boosting our evolutional process and brain power one hundredfold." }
		}
		questions[21201] = {
			action="jump", goto=21001,
			player="What signals?",
			alien={"Broadband channel 8301.  The transmissions are like the brainwaves of the gods, except we are already gods.  They are the brainwaves of whatever is greater then the gods." }
		}

	questions[30001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about Spemin history?",  goto=31000 },
			{ text="What about the ancient past?",  goto=32000 },
			{ text="Can you tell us about any historic events?",  goto=33000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[31000] = {
		action="jump", goto=31001,
		player="",
		alien={"At first many of the degenerate races tried to make us into slaves.  We are not slaves.  The Tri'na'li'da is slowly enslaving us all until their return." }
	}
	questions[31001] = {
		action="jump", goto=31002,
		player="The what?  Who is returning?",
		alien={"That is the true name of the virus as the gods have revealed it to us.  They are returning and want us humble in their presence." }
	}
	questions[31002] = {
		action="jump", goto=30001,
		player="When are they returning?",
		alien={"The prerogative of the gods alone decrees when they will arrive.  When they arrive and what they will do when they get here is solely up to them." }
	}
	questions[32000] = {
		action="jump", goto=30001,
		player="What about the ancient past?",
		alien={"Historical fact shows us that the Spemin, then known as Ancients once ruled the galaxy.  This was when all races knew peace and love.  Since then fighting and death have separated us all and have deluded many into thinking that force is the answer to everything.  Since then we have forgotten, I mean we choose not to create any more endurium." }
	}
	questions[33000] = {
		action="jump", goto=30001,
		player="Can you tell us about any historic events?",
		alien={"No.  The past is before.  The future is ahead.  The present is now.  We must watch the future with an eye on the past even as the present oozes ahead.  This is only a sample of our profound wisdom." }
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
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."} }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."} }
	greetings[4] = {
		action="",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."} }
	greetings[5] = {
		action="",
		player="We require information. Comply or be destroyed.",
		alien={"I am Spemin, I great you two-eyed slimeless skeletoids.","Hello [CAPTAIN].","Uh huh.  Ok."} }
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship is simple and weak.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[2] = {
		action="",
		player="What an ugly and worthless creature.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }
	statements[3] = {
		action="",
		player="Your ship looks like a flying garbage doughnut.",
		alien={"Sure thing","Okay","Nahh","Go ahead","'Over"} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	
	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"We are the Spemin."}
	}
	questions[20000] = {
		action="jump", goto=20002,
		player="What can you tell us about the other races in the galaxy?",
		alien={"We of the Royal Spemin navy meet all races with unwavering courage and conviction.  You must envy us with our vast ... umm ... What was your question?"}
	}
	questions[20002] = {
		action="jump", goto=20001,
		player="Tell us about other alien races.",
		alien={"Ok, will do."}
	}
	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about the past?",
		alien={"Yeah, so?"}
	}
	questions[40000] = {
		action="jump", goto=40001,
		player="Tell us about the Ancients.",
		alien={"We were once known as the Ancients.  You would be wise not to antagonize us." }
	}
	questions[40001] = {
		action="jump", goto=1,
		player="Why are your ships so weak if you are the Ancients?",
		alien={"These forms you see before you are merely holographic projections.  We grant you a boon.  Feel free to collect any of our endurium on Bec-Felmas 3 - 16,183 or Mathgen 4 - 212,3." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="I demand that you give us all your cargo!",  goto=51000 },
			{ text="Where is your home world?", goto=52000 },
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="<Back>",  goto=1 }
		}
	}
 	questions[51000] = {
		action="jump", goto=51100,
		player="",
		alien={"No."}
	}
	questions[51100] = {
		action="branch",
		choices = {
			{ text="If you do not give us your cargo, we will destroy you.",  goto=51101 },
			{ text="<Back>",  goto=50000 }
		}
	}
 	questions[51101] = {
		action="jump", goto=51110,
		player="",
		alien={"Fools!  You face the Spemin Gods!  Do not incur our wrath!"}
	}
	questions[51110] = {
		action="branch",
		choices = {
			{ text="Give us your cargo.  Now!",  goto=51111 },
			{ text="<Back>",  goto=50000 }
		}
	}	
	 questions[51111] = {
		action="jump", goto=51112,
		player="",
		alien={"Prepare for excruciating pain, unbearable agony, the most horrible of deaths, the most unimaginable torture. Any moment now we shall attack."}
	}
 	questions[51112] = {
		action="terminate",
		player="Umm, are you going to attack us?",
		alien={"Any moment now I shall ooze down and absorb you like so much food substance.  Feel free to run."}
	}
	questions[52000] = {
		action="jump", goto=52001,
		player="Where is your home world?",
		alien={"That location is a secret.  You would have to first ask permission of our leaders before we divulged such information."}
	}
	questions[52001] = {
		action="jump", goto=50000,
		player="So where are your leaders?",
		alien={"Oh, you can find them at Dian Cecht 3 - 35,139."}
	}
	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"...Unable...to...contact...Uyo...host...  We...must...verify..." }
	}
	questions[60001] = {
			action="branch",
			choices = {
				{ text="What do you mean Uyo host?", goto=61000 },
				{ text="Why are you trying to contact a Uyo host?", goto=62000 },
				{ text="Why are you mumbling so strangely?", goto=63000 },
				{ text="What about the Minex war?", goto=64000 },
				{ text="<Back>", goto=50000 }
			}
		}
		questions[61000] = {
			action="jump", goto=61001,
			player="",
			alien={"Everything is fine.  We are fine." }
		}
		questions[61001] = {
			action="jump", goto=60001,
			player="What or who is Uyo?",
			alien={"We Spemin have knowledge beyond any other race.  Uyo was a great explorer and navigator who charted a vast cloud nebulae.  This occurred thousands of your Myrrdan years ago." }
		}
		questions[62000] = {
			action="jump", goto=60001,
			player="",
			alien={"I know everything about Uyo hosts.  I just cannot, I mean choose not to tell you about them." }
		}
		questions[63000] = {
			action="jump", goto=60001,
			player="",
			alien={"You need to talk to your communications officer because he/she/it might be going mad with madness.  I have been patiently waiting for your next response and you accuse me with your unjust accusations." }
		}
		questions[64000] = {
			action="jump", goto=60001,
			player="",
			alien={"The Minex are not at war, they always destroy us when we see them.  The Thrynn have decided to completely leave us alone now!  I am sorry, is someone at war?" }
		}


	questions[11001] = {
		action="branch",
		choices = {
			{ text="What type of government do you have?",  goto=11000 },
			{ text="What can you tell us about your biology?", goto=12000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="What type of government do you have?",
		alien={"'Tis thus then that the Secret Society of Spemin Superiority said so.  Thus they thereby spoke and said." }
	}
	questions[12000] = {
		action="jump", goto=12001,
		player="What can you tell us about your biology?",
		alien={"Our antennae are a bit overloaded at the moment.  Please come back later.  Much, much, many, moving, later." }
	}
	questions[12001] = {
		action="jump", goto=12002,
		player="Are you guys alright?",
		alien={"Minex standard protocols.  Containment, transmit, scramble, relay positional geometries.  Yes, we are just fine." }
	}
	questions[12002] = {
		action="jump", goto=11001,
		player="What did you say about the Minex?",
		alien={"You are crazy.  I did not say anything about the Minex." }
	}
	
	questions[20001] = {
		action="branch",
		choices = {
			{ text="What other races have you encountered?",  goto=21000 },
			{ text="Do you encounter any races outward of your area of space?",  goto=22000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[21000] = {
		action="jump", goto=21002,
		player="",
		alien={"Necessity for control nexus increasing.  Unabe to locate Uyo center.  Unable to complete thrall enslavement of biological resources.  Solution: unknown." }
	}
	questions[21002] = {
		action="jump", goto=21001,
		player="What???",
		alien={"Primary objective unattainable.  Secondary objectives nearly complete." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="",
		alien={"No.  Outward of this area lies a vast dead zone where systems are filled with planets scorched clean of life.  No intelligent spacefaring races have ever approached us from this area, and no life bearing planets have we ever found." }
	}
	questions[21001] = {
		action="branch",
		choices = {
		
			{ text="What do you mean, secondary objectives?",  goto=21100 },
			{ text="Why are you rambling nonsense?",  goto=21200 },
			{ text="<Back>", goto=20001 }
		}
	}

		questions[21100] = {
			action="jump", goto=21101,
			player="",
			alien={"We Spemin have no objectives.  We seek to multiply and reach out into space, discovering new ideas and technologies, while trying to avoid being brutally killed." }
		}
		questions[21101] = {
			action="jump", goto=21102,
			player="Are those things your objectives then?",
			alien={"Our goals are secret.  They are also mysterious and unavoidable.  Why do you speak of objectives?  We Spemin would sooner die then divulge our secrets." }
		}
		questions[21102] = {
			action="jump", goto=21001,
			player="You said something about primary and secondary objectives.",
			alien={"I did not.  You aliens are mad like everyone else." }
		}
		questions[21200] = {
			action="jump", goto=21201,
			player="",
			alien={"Spemin do not ramble.  Even as we speak, our antenna are picking up powerful new signals from the stars that are boosting our evolutional process and brain power one hundredfold." }
		}
		questions[21201] = {
			action="jump", goto=21001,
			player="What signals?",
			alien={"Broadband channel 8301.  The transmissions are like the brainwaves of the gods, except we are already gods.  They are the brainwaves of whatever is greater then the gods." }
		}

	questions[30001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about Spemin history?",  goto=31000 },
			{ text="What about the ancient past?",  goto=32000 },
			{ text="Can you tell us about any historic events?",  goto=33000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[31000] = {
		action="jump", goto=31001,
		player="",
		alien={"At first many of the degenerate races tried to make us into slaves.  We are not slaves.  The Tri'na'li'da is slowly enslaving us all until their return." }
	}
	questions[31001] = {
		action="jump", goto=31002,
		player="The what?  Who is returning?",
		alien={"That is the true name of the virus as the gods have revealed it to us.  They are returning and want us humble in their presence." }
	}
	questions[31002] = {
		action="jump", goto=30001,
		player="When are they returning?",
		alien={"The prerogative of the gods alone decrees when they will arrive.  When they arrive and what they will do when they get here is solely up to them." }
	}
	questions[32000] = {
		action="jump", goto=30001,
		player="What about the ancient past?",
		alien={"Historical fact shows us that the Spemin, then known as Ancients once ruled the galaxy.  This was when all races knew peace and love.  Since then fighting and death have separated us all and have deluded many into thinking that force is the answer to everything.  Since then we have forgotten, I mean we choose not to create any more endurium." }
	}
	questions[33000] = {
		action="jump", goto=30001,
		player="Can you tell us about any historic events?",
		alien={"No.  The past is before.  The future is ahead.  The present is now.  We must watch the future with an eye on the past even as the present oozes ahead.  This is only a sample of our profound wisdom." }
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

