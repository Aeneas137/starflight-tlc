--[[
	ENCOUNTER SCRIPT FILE: SPEMIN VIRUS

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
		alien={"Recognition at last! it is wonderful that you recognize the Spemin by reputation!  Actually who did you talk to?","The mighty and powerful Spemin place ourselves at your disposal.","Welcome supplicants, we have waited long for your arrival.  Actually we have waited forever for your arrival."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"Recognition at last! it is wonderful that you recognize the Spemin by reputation!  Actually who did you talk to?","The mighty and powerful Spemin place ourselves at your disposal.","Welcome supplicants, we have waited long for your arrival.  Actually we have waited forever for your arrival."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"Recognition at last! it is wonderful that you recognize the Spemin by reputation!  Actually who did you talk to?","The mighty and powerful Spemin place ourselves at your disposal.","Welcome supplicants, we have waited long for your arrival.  Actually we have waited forever for your arrival."} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"Recognition at last! it is wonderful that you recognize the Spemin by reputation!  Actually who did you talk to?","The mighty and powerful Spemin place ourselves at your disposal.","Welcome supplicants, we have waited long for your arrival.  Actually we have waited forever for your arrival."} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"Recognition at last! it is wonderful that you recognize the Spemin by reputation!  Actually who did you talk to?","The mighty and powerful Spemin place ourselves at your disposal.","Welcome supplicants, we have waited long for your arrival.  Actually we have waited forever for your arrival."} }


		
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"I know, call us crazy, but I guess we're pretty lovable.","We assist only to exist you.","Really!  We are glad to know that!"} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien={"I know, call us crazy, but I guess we're pretty lovable.","We assist only to exist you.","Really!  We are glad to know that!"} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"I know, call us crazy, but I guess we're pretty lovable.","We assist only to exist you.","Really!  We are glad to know that!"} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"I know, call us crazy, but I guess we're pretty lovable.","We assist only to exist you.","Really!  We are glad to know that!"} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"I know, call us crazy, but I guess we're pretty lovable.","We assist only to exist you.","Really!  We are glad to know that!"} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"I know, call us crazy, but I guess we're pretty lovable.","We assist only to exist you.","Really!  We are glad to know that!"} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"I know, call us crazy, but I guess we're pretty lovable.","We assist only to exist you.","Really!  We are glad to know that!"} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"I know, call us crazy, but I guess we're pretty lovable.","We assist only to exist you.","Really!  We are glad to know that!"} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"I know, call us crazy, but I guess we're pretty lovable.","We assist only to exist you.","Really!  We are glad to know that!"} }
		
	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"We are the awesome Spemin.  Masters of this galaxy.  Rulers of all galaxies in fact.  We are also known as the Ancients.  We mearly let you hostile aliens think that you were destroying our ships, I mean our automated craft, I mean our holograms."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"We were born onboard this generational ship sent out to explore the stars and meet other races.  No other Spemin is as successful as we are!"}
	}
	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about the past?",
		alien={"You mean stuff that happened before we were alive?  Maybe we will and maybe we won't.  Well, ask something and see if we answer."}
	}
	questions[40000] = {
		action="jump", goto=40001,
		player="Tell us about the Ancients.",
		alien={"We Spemin are the Ancients.  I have kept this information to myself until now.  You would be wise not to antagonize me." }
	}
	questions[40001] = {
		action="jump", goto=1,
		player="Why are your ships so weak if you are the Ancients?",
		alien={"These forms you see before you are merely holographic projections.  Do not think to provoke us because we, uhh..., really value our holographic projections!" }
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
		action="jump", goto=60002,
		player="",
		alien={"Excuse us we are very busy." }
	}
	questions[60002] = {
		action="jump", goto=60001,
		player="Very busy with what?",
		alien={"Transporting minerals to our home world to build more ships.  We are repelling a strange coalition of alien attacks." }
	}
	questions[60001] = {
			action="branch",
			choices = {
				{ text="What do you know about these strange attackers?", goto=61000 },
				{ text="Can you identify any of the alien ships?", goto=62000 },
				{ text="Why are they attacking you?", goto=63000 },
				{ text="<Back>", goto=50000 }
			}
		}
		questions[61000] = {
			action="jump", goto=61001,
			player="",
			alien={"Menageries of alien fleets all working together.  They make up strange collections of ships of all different types, all hostile, all talking to each other." }
		}
		questions[61001] = {
			action="jump", goto=60001,
			player="What do they say to each other?",
			alien={"Not any communication we can decipher.  Our antenna receive a strange buzz from their ships on Channel 9000 whenever we are near them.  The buzz means they attack us when we get too close, but do not go out of their way to attack us like the Thrynn and Minex normally do." }
		}
		questions[62000] = {
			action="jump", goto=60001,
			player="",
			alien={"Sometimes we can identify them.  Actually we can identify any ship.  We know everything so do not test us." }
		}
		questions[63000] = {
			action="jump", goto=60001,
			player="",
			alien={"We do not know.  They do not seem to do a good job though.  They are very good at killing our ships, but do not really fly towards our territory and do not pursue us when we flee.  We do not think they intend to kill us, but just attack anything that happens to be in their way." }
		}


	questions[11001] = {
		action="branch",
		choices = {
			{ text="What type of government do you have?",  goto=11000 },
			{ text="What can you tell us about your biology?", goto=12000 },
			{ text="Why would we want to become your disciples?", goto=13000 }, 
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11101,
		player="What type of government do you have?",
		alien={"We follow the SSSS, also known as saw Secret Society of Spemin Superiority.  We extend our secret and unknowable knowledge to all who wish to become disciples and study under us, and give us all their posessions.  It is our goal and aim of existence to spread the wisdom of the great Blob Goddess, Gertblunk.  Unto us she spews her love in never ending chunks. " }
	}
	questions[12000] = {
		action="jump", goto=12001,
		player="What can you tell us about your biology?",
		alien={"Of course you stare in wonderment at our beautiful antennae.  These antennae allow us to get 32,000 channels with no need for cable.  In addition they pick up the cosmic vibrations that give us our god-like powers.  They also happen to be very fashionable." }
	}
	questions[12001] = {
		action="jump", goto=11001,
		player="<More>",
		alien={"The brain of a spemin is the most complex thing in the universe. In fact, it is so complex that our spemin doctors have, as yet, been unable to determine the exact location of it in the spemin body." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="",
		alien={"Because truly the other races are deprived.   No other race can know the pleasures of a spemin. Ahh, to engulf a fresh glob of protein substance, to bounce a newly budded blobbie on one's pseudopod.  There is a saying among the spemin that sums up our whole philosophy of life. It is - blukbluk durt, smeg! Roughly translated it means 'quivering particle secretes enzyme.' this is just a rough translation." }
	}
	
	questions[11101] = {
		action="branch",
		choices = {
			{ text="Tell us about the Great Blob Goddess.",  goto=11110 },
			{ text="How do you communicate with your goddess?",  goto=11120 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[11110] = {
		action="jump", goto=11111,
		player="",
		alien={"Our race reproduces by budding, so the first commandment of the Great Blob Goddess is to subtract the hostile then add the friendly, or was it divide and multiply?  I'm pretty sure it was to subtract and divide and then multiply." }
	}
	questions[11111] = {
		action="jump", goto=11112,
		player="<More>",
		alien={"Our second commandment is to teach all interior beings.  Your senses are crippled.  Your antennae are small and mounted on the sides of your head.  You have fewer than seven eyes.  You cannot ooze and lack the most rudimentary slime.  You are most absolutely inferior beings. " }
	}
	questions[11112] = {
		action="jump", goto=11101,
		player="<More>",
		alien={"She decreed that we should boldly go to other races in the galaxy, spreading her message of peace and love and all would envy and admire us as you do.  Unfortunately most have not.  In fact, you are the first who have listened for this long." }
	}
	questions[11120] = {
		action="jump", goto=11101,
		player="",
		alien={"Cosmic vibrations travel through the heavens and speak to us directly.  This is not to be questioned for you cannot understand." }
	}

	questions[20001] = {
		action="branch",
		choices = {
			{ text="Great, what other races have you encountered?",  goto=21000 },
			{ text="Do you encounter any races outward of this area of space?",  goto=22000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[21000] = {
		action="jump", goto=21002,
		player="Great, what other races have you encountered?",
		alien={"Such knowledge is classified, top secret, and unknown.  I mean unknown to you, not unknown to us.  Of course we know of the races we encountered." }
	}
	questions[21002] = {
		action="jump", goto=21001,
		player="Why won't you tell us about other races?",
		alien={"What other races?  We demand to know what you know of the other faction of Spemin!  What do you know about the Thrynn and Elowan factions attacking each other and themselves?  Why the migrations to the Minex?  You must answer now, please??" }
	}
	questions[21001] = {
		action="branch",
		choices = {
		
			{ text="What do you mean, the other Spemin faction?",  goto=21100 },
			{ text="Thrynn and Elowan attacking themselves?",  goto=21200 },
			{ text="What migrations to the Minex?",  goto=21300 },
			{ text="Why are you being so demanding?",  goto=21400 },
			{ text="<Back>", goto=20001 }
		}
	}

		questions[21100] = {
			action="jump", goto=21101,
			player="",
			alien={"We never do this normally, but some of our ships stopped talking and then attacked us.  Defecting Spemin sometimes return to normal with no memory of their rogueish behavior.  Other times these ships run off and we never see them again." }
		}
		questions[21101] = {
			action="jump", goto=21102,
			player="Are they infected with the virus?",
			alien={"Ohh an infection?  No, a madness!  Maybe that is why everyone is both killing each other and themselves.  Actually your people are not, how come?" }
		}
		questions[21102] = {
			action="jump", goto=21001,
			player="We are not infected.",
			alien={"Tell us when you are so we can stay away from you." }
		}
		questions[21200] = {
			action="jump", goto=21201,
			player="",
			alien={"Yes, we see many new races now.  All behaving inconsistently and crazy.  Most common are Elowan attacking Elowan, fleeing from Thrynn, or Thrynn attacking Thrynn." }
		}
		questions[21201] = {
			action="jump", goto=21001,
			player="What other alien races have you identified?",
			alien={"Why should we answer your questions?  Well I guess there is no reason we should not.  We identify Thrynn, Elowan, Bar-Zhon, and some strange others.  Minex are always alone.  Actually many groups of Bar-Zhon by themselves also. They have had many conflicts with the Thrynn just upspin from us. They fly in search patterns between systems.  You would think that they wished to locate something." }
		}
		questions[21300] = {
			action="jump", goto=21301,
			player="",
			alien={"Many strange collections of ships appear we have never seen before.  Some days there are many of them, other days there are none.  Sometimes they attack each other, other times they just attack us.  Maybe a war of madness?  Maybe some crazy migration heading downspin?" }
		}
		questions[21301] = {
			action="jump", goto=21001,
			player="Heading downspin?",
			alien={"Yes, the ships that do not attack each other generally are heading all in the downspin direction towards those the Thrynn call Minex." }
		}
		questions[21400] = {
			action="jump", goto=21001,
			player="",
			alien={"Ohh, we are too demanding?  Sorry.  Please don't attack us." }
		}


	questions[22000] = {
		action="jump", goto=20001,
		player="Do you encounter any races outward of your area of space?",
		alien={"No.  Outward of this area lies a vast dead zone where systems are filled with planets scorched clean of life.  No intelligent spacefaring races have ever approached us from this area, and no life bearing planets have we ever found." }
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
		action="jump", goto=30001,
		player="What can you tell us about Spemin history?",
		alien={"At first many of the degenerate races tried to make us into slaves.  Our passive resistance prevented them from doing so.  Unfortunately it did not stop them from simply killing huge numbers of us, so we are developing new and improved secret techniques for preventing alien incursions and conspiracies." }
	}
	questions[32000] = {
		action="jump", goto=30001,
		player="What about the ancient past?",
		alien={"Historical fact shows us that the Spemin, then known as Ancients once ruled the galaxy.  This was when all races knew peace and love.  Since then fighting and death have separated us all and have deluded many into thinking that force is the answer to everything.  Since then we have forgotten, I mean we choose not to create any more endurium" }
	}
	questions[33000] = {
		action="jump", goto=33001,
		player="Can you tell us about any historic events?",
		alien={"Almost 500,000 cycles, uhh...2000 Myrrdan years ago a strange migrating race appeared out of nowhere and captured a number of our ships and took them away.  Actually they captured all of our ships and took them away.  Since then we figured out what other races use weapons for." }
	}
	questions[33001] = {
		action="jump", goto=30001,
		player="Do you know the name of the race that did this?",
		alien={"No." }
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
		alien={"Greetings from the Spemin.  We always come in peace.","We are the Spemin in case you have not heard of us.  Our godlike senses picked you up long ago but we waited until now to contact you.","Welcome seekers.  We are the Spemin."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Greetings from the Spemin.  We always come in peace.","We are the Spemin in case you have not heard of us.  Our godlike senses picked you up long ago but we waited until now to contact you.","Welcome seekers.  We are the Spemin."} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Greetings from the Spemin.  We always come in peace.","We are the Spemin in case you have not heard of us.  Our godlike senses picked you up long ago but we waited until now to contact you.","Welcome seekers.  We are the Spemin."} }
	greetings[4] = {
		action="",
		player="Dude, that is one funky ship you have there!",
		alien={"Greetings from the Spemin.  We always come in peace.","We are the Spemin in case you have not heard of us.  Our godlike senses picked you up long ago but we waited until now to contact you.","Welcome seekers.  We are the Spemin."} }
	greetings[5] = {
		action="",
		player="How's it going, blob thing?",
		alien={"Greetings from the Spemin.  We always come in peace.","We are the Spemin in case you have not heard of us.  Our godlike senses picked you up long ago but we waited until now to contact you.","Welcome seekers.  We are the Spemin."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"We are pleased at your perception.","Reflections of grand Spemin thoughts have penetrated your thinking.","Blessings to the Great Blob Goddess."} }
	statements[2] = {
		action="",
		player="Your ship appears very simple yet functional.",
		alien={"We are pleased at your perception.","Reflections of grand Spemin thoughts have penetrated your thinking.","Blessings to the Great Blob Goddess."} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"We are pleased at your perception.","Reflections of grand Spemin thoughts have penetrated your thinking.","Blessings to the Great Blob Goddess."} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"We are pleased at your perception.","Reflections of grand Spemin thoughts have penetrated your thinking.","Blessings to the Great Blob Goddess."} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together...uhh...nevermind...let us be friends.",
		alien={"We are pleased at your perception.","Reflections of grand Spemin thoughts have penetrated your thinking.","Blessings to the Great Blob Goddess."} }
		 



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"We are the awesome Spemin.  Masters of this galaxy.  Rulers of all galaxies in fact.  We are also known as the Ancients.  We mearly let you hostile aliens think that you were destroying our ships, I mean our automated craft, I mean our holograms."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"We were born onboard this generational ship sent out to explore the stars and meet other races.  No other Spemin is as successful as we are!"}
	}
	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about the past?",
		alien={"You mean stuff that happened before we were alive?  Maybe we will and maybe we won't.  Well, ask something and see if we answer."}
	}
	questions[40000] = {
		action="jump", goto=40001,
		player="Tell us about the Ancients.",
		alien={"We Spemin are the Ancients.  I have kept this information to myself until now.  You would be wise not to antagonize me." }
	}
	questions[40001] = {
		action="jump", goto=1,
		player="Why are your ships so weak if you are the Ancients?",
		alien={"These forms you see before you are merely holographic projections.  Do not think to provoke us because we, uhh..., really value our holographic projections!" }
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
		action="jump", goto=60002,
		player="",
		alien={"Excuse us we are very busy." }
	}
	questions[60002] = {
		action="jump", goto=60001,
		player="Very busy with what?",
		alien={"Transporting minerals to our home world to build more ships.  We are repelling a strange coalition of alien attacks." }
	}
	questions[60001] = {
			action="branch",
			choices = {
				{ text="What do you know about these strange attackers?", goto=61000 },
				{ text="Can you identify any of the alien ships?", goto=62000 },
				{ text="Why are they attacking you?", goto=63000 },
				{ text="<Back>", goto=50000 }
			}
		}
		questions[61000] = {
			action="jump", goto=61001,
			player="",
			alien={"Menageries of alien fleets all working together.  They make up strange collections of ships of all different types, all hostile, all talking to each other." }
		}
		questions[61001] = {
			action="jump", goto=60001,
			player="What do they say to each other?",
			alien={"Not any communication we can decipher.  Our antenna receive a strange buzz from their ships on Channel 9000 whenever we are near them.  The buzz means they attack us when we get too close, but do not go out of their way to attack us like the Thrynn and Minex normally do." }
		}
		questions[62000] = {
			action="jump", goto=60001,
			player="",
			alien={"Sometimes we can identify them.  Actually we can identify any ship.  We know everything so do not test us." }
		}
		questions[63000] = {
			action="jump", goto=60001,
			player="",
			alien={"We do not know.  They do not seem to do a good job though.  They are very good at killing our ships, but do not really fly towards our territory and do not pursue us when we flee.  We do not think they intend to kill us, but just attack anything that happens to be in their way." }
		}


	questions[11001] = {
		action="branch",
		choices = {
			{ text="What type of government do you have?",  goto=11000 },
			{ text="What can you tell us about your biology?", goto=12000 },
			{ text="Why would we want to become your disciples?", goto=13000 }, 
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11101,
		player="What type of government do you have?",
		alien={"We follow the SSSS, also known as saw Secret Society of Spemin Superiority.  We extend our secret and unknowable knowledge to all who wish to become disciples and study under us, and give us all their posessions.  It is our goal and aim of existence to spread the wisdom of the great Blob Goddess, Gertblunk.  Unto us she spews her love in never ending chunks. " }
	}
	questions[12000] = {
		action="jump", goto=12001,
		player="What can you tell us about your biology?",
		alien={"Of course you stare in wonderment at our beautiful antennae.  These antennae allow us to get 32,000 channels with no need for cable.  In addition they pick up the cosmic vibrations that give us our god-like powers.  They also happen to be very fashionable." }
	}
	questions[12001] = {
		action="jump", goto=11001,
		player="<More>",
		alien={"The brain of a spemin is the most complex thing in the universe. In fact, it is so complex that our spemin doctors have, as yet, been unable to determine the exact location of it in the spemin body." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="",
		alien={"Because truly the other races are deprived.   No other race can know the pleasures of a spemin. Ahh, to engulf a fresh glob of protein substance, to bounce a newly budded blobbie on one's pseudopod.  There is a saying among the spemin that sums up our whole philosophy of life. It is - blukbluk durt, smeg! Roughly translated it means 'quivering particle secretes enzyme.' this is just a rough translation." }
	}
	
	questions[11101] = {
		action="branch",
		choices = {
			{ text="Tell us about the Great Blob Goddess.",  goto=11110 },
			{ text="How do you communicate with your goddess?",  goto=11120 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[11110] = {
		action="jump", goto=11111,
		player="",
		alien={"Our race reproduces by budding, so the first commandment of the Great Blob Goddess is to subtract the hostile then add the friendly, or was it divide and multiply?  I'm pretty sure it was to subtract and divide and then multiply." }
	}
	questions[11111] = {
		action="jump", goto=11112,
		player="<More>",
		alien={"Our second commandment is to teach all interior beings.  Your senses are crippled.  Your antennae are small and mounted on the sides of your head.  You have fewer than seven eyes.  You cannot ooze and lack the most rudimentary slime.  You are most absolutely inferior beings. " }
	}
	questions[11112] = {
		action="jump", goto=11101,
		player="<More>",
		alien={"She decreed that we should boldly go to other races in the galaxy, spreading her message of peace and love and all would envy and admire us as you do.  Unfortunately most have not.  In fact, you are the first who have listened for this long." }
	}
	questions[11120] = {
		action="jump", goto=11101,
		player="",
		alien={"Cosmic vibrations travel through the heavens and speak to us directly.  This is not to be questioned for you cannot understand." }
	}

	questions[20001] = {
		action="branch",
		choices = {
			{ text="Great, what other races have you encountered?",  goto=21000 },
			{ text="Do you encounter any races outward of this area of space?",  goto=22000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[21000] = {
		action="jump", goto=21002,
		player="Great, what other races have you encountered?",
		alien={"Such knowledge is classified, top secret, and unknown.  I mean unknown to you, not unknown to us.  Of course we know of the races we encountered." }
	}
	questions[21002] = {
		action="jump", goto=21001,
		player="Why won't you tell us about other races?",
		alien={"What other races?  We demand to know what you know of the other faction of Spemin!  What do you know about the Thrynn and Elowan factions attacking each other and themselves?  Why the migrations to the Minex?  You must answer now, please??" }
	}
	questions[21001] = {
		action="branch",
		choices = {
		
			{ text="What do you mean, the other Spemin faction?",  goto=21100 },
			{ text="Thrynn and Elowan attacking themselves?",  goto=21200 },
			{ text="What migrations to the Minex?",  goto=21300 },
			{ text="Why are you being so demanding?",  goto=21400 },
			{ text="<Back>", goto=20001 }
		}
	}

		questions[21100] = {
			action="jump", goto=21101,
			player="",
			alien={"We never do this normally, but some of our ships stopped talking and then attacked us.  Defecting Spemin sometimes return to normal with no memory of their rogueish behavior.  Other times these ships run off and we never see them again." }
		}
		questions[21101] = {
			action="jump", goto=21102,
			player="Are they infected with the virus?",
			alien={"Ohh an infection?  No, a madness!  Maybe that is why everyone is both killing each other and themselves.  Actually your people are not, how come?" }
		}
		questions[21102] = {
			action="jump", goto=21001,
			player="We are not infected.",
			alien={"Tell us when you are so we can stay away from you." }
		}
		questions[21200] = {
			action="jump", goto=21201,
			player="",
			alien={"Yes, we see many new races now.  All behaving inconsistently and crazy.  Most common are Elowan attacking Elowan, fleeing from Thrynn, or Thrynn attacking Thrynn." }
		}
		questions[21201] = {
			action="jump", goto=21001,
			player="What other alien races have you identified?",
			alien={"Why should we answer your questions?  Well I guess there is no reason we should not.  We identify Thrynn, Elowan, Bar-Zhon, and some strange others.  Minex are always alone.  Actually many groups of Bar-Zhon by themselves also. They have had many conflicts with the Thrynn just upspin from us. They fly in search patterns between systems.  You would think that they wished to locate something." }
		}
		questions[21300] = {
			action="jump", goto=21301,
			player="",
			alien={"Many strange collections of ships appear we have never seen before.  Some days there are many of them, other days there are none.  Sometimes they attack each other, other times they just attack us.  Maybe a war of madness?  Maybe some crazy migration heading downspin?" }
		}
		questions[21301] = {
			action="jump", goto=21001,
			player="Heading downspin?",
			alien={"Yes, the ships that do not attack each other generally are heading all in the downspin direction towards those the Thrynn call Minex." }
		}
		questions[21400] = {
			action="jump", goto=21001,
			player="",
			alien={"Ohh, we are too demanding?  Sorry.  Please don't attack us." }
		}


	questions[22000] = {
		action="jump", goto=20001,
		player="Do you encounter any races outward of your area of space?",
		alien={"No.  Outward of this area lies a vast dead zone where systems are filled with planets scorched clean of life.  No intelligent spacefaring races have ever approached us from this area, and no life bearing planets have we ever found." }
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
		action="jump", goto=30001,
		player="What can you tell us about Spemin history?",
		alien={"At first many of the degenerate races tried to make us into slaves.  Our passive resistance prevented them from doing so.  Unfortunately it did not stop them from simply killing huge numbers of us, so we are developing new and improved secret techniques for preventing alien incursions and conspiracies." }
	}
	questions[32000] = {
		action="jump", goto=30001,
		player="What about the ancient past?",
		alien={"Historical fact shows us that the Spemin, then known as Ancients once ruled the galaxy.  This was when all races knew peace and love.  Since then fighting and death have separated us all and have deluded many into thinking that force is the answer to everything.  Since then we have forgotten, I mean we choose not to create any more endurium" }
	}
	questions[33000] = {
		action="jump", goto=33001,
		player="Can you tell us about any historic events?",
		alien={"Almost 500,000 cycles, uhh...2000 Myrrdan years ago a strange migrating race appeared out of nowhere and captured a number of our ships and took them away.  Actually they captured all of our ships and took them away.  Since then we figured out what other races use weapons for." }
	}
	questions[33001] = {
		action="jump", goto=30001,
		player="Do you know the name of the race that did this?",
		alien={"No." }
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
		alien={"Please don't be aggressive.  Talk to our elders.  We spemin live to the age of 600. Some of the oldest spemin perhaps to 1000. In your Myrrdan years this would equate to....uh....approximately....4.","We Spemin only wish for peace, love, joy, happiness, and lots of money.","Hi, we're Spemin, not the hostile aliens you think we are."} }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"Please don't be aggressive.  Talk to our elders.  We spemin live to the age of 600. Some of the oldest spemin perhaps to 1000. In your Myrrdan years this would equate to....uh....approximately....4.","We Spemin only wish for peace, love, joy, happiness, and lots of money.","Hi, we're Spemin, not the hostile aliens you think we are."}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"Please don't be aggressive.  Talk to our elders.  We spemin live to the age of 600. Some of the oldest spemin perhaps to 1000. In your Myrrdan years this would equate to....uh....approximately....4.","We Spemin only wish for peace, love, joy, happiness, and lots of money.","Hi, we're Spemin, not the hostile aliens you think we are."} }
	greetings[4] = {
		action="",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"Please don't be aggressive.  Talk to our elders.  We spemin live to the age of 600. Some of the oldest spemin perhaps to 1000. In your Myrrdan years this would equate to....uh....approximately....4.","We Spemin only wish for peace, love, joy, happiness, and lots of money.","Hi, we're Spemin, not the hostile aliens you think we are."} }
	greetings[5] = {
		action="",
		player="We require information. Comply or be destroyed.",
		alien={"Please don't be aggressive.  Talk to our elders.  We spemin live to the age of 600. Some of the oldest spemin perhaps to 1000. In your Myrrdan years this would equate to....uh....approximately....4.","We Spemin only wish for peace, love, joy, happiness, and lots of money.","Hi, we're Spemin, not the hostile aliens you think we are."} }
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship is simple and weak.",
		alien={"Don't be mad, we're really just a happy-go-lucky race of zany guys.","Can we be friends instead?","I know, call us crazy, but I guess we're pretty lovable if you get to know us."} }
	statements[2] = {
		action="",
		player="What an ugly and worthless creature.",
		alien={"Don't be mad, we're really just a happy-go-lucky race of zany guys.","Can we be friends instead?","I know, call us crazy, but I guess we're pretty lovable if you get to know us."} }
	statements[3] = {
		action="",
		player="Your ship looks like a flying garbage doughnut.",
		alien={"Don't be mad, we're really just a happy-go-lucky race of zany guys.","Can we be friends instead?","I know, call us crazy, but I guess we're pretty lovable if you get to know us."} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"We are the awesome Spemin.  Masters of this galaxy.  Rulers of all galaxies in fact.  We are also known as the Ancients.  We mearly let you hostile aliens think that you were destroying our ships, I mean our automated craft, I mean our holograms."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"We were born onboard this generational ship sent out to explore the stars and meet other races.  No other Spemin is as successful as we are!"}
	}
	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about the past?",
		alien={"You mean stuff that happened before we were alive?  Maybe we will and maybe we won't.  Well, ask something and see if we answer."}
	}
	questions[40000] = {
		action="jump", goto=40001,
		player="Tell us about the Ancients.",
		alien={"We Spemin are the Ancients.  I have kept this information to myself until now.  You would be wise not to antagonize me." }
	}
	questions[40001] = {
		action="jump", goto=1,
		player="Why are your ships so weak if you are the Ancients?",
		alien={"These forms you see before you are merely holographic projections.  Do not think to provoke us because we, uhh..., really value our holographic projections!" }
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
		action="jump", goto=60002,
		player="",
		alien={"Excuse us we are very busy." }
	}
	questions[60002] = {
		action="jump", goto=60001,
		player="Very busy with what?",
		alien={"Transporting minerals to our home world to build more ships.  We are repelling a strange coalition of alien attacks." }
	}
	questions[60001] = {
			action="branch",
			choices = {
				{ text="What do you know about these strange attackers?", goto=61000 },
				{ text="Can you identify any of the alien ships?", goto=62000 },
				{ text="Why are they attacking you?", goto=63000 },
				{ text="<Back>", goto=50000 }
			}
		}
		questions[61000] = {
			action="jump", goto=61001,
			player="",
			alien={"Menageries of alien fleets all working together.  They make up strange collections of ships of all different types, all hostile, all talking to each other." }
		}
		questions[61001] = {
			action="jump", goto=60001,
			player="What do they say to each other?",
			alien={"Not any communication we can decipher.  Our antenna receive a strange buzz from their ships on Channel 9000 whenever we are near them.  The buzz means they attack us when we get too close, but do not go out of their way to attack us like the Thrynn and Minex normally do." }
		}
		questions[62000] = {
			action="jump", goto=60001,
			player="",
			alien={"Sometimes we can identify them.  Actually we can identify any ship.  We know everything so do not test us." }
		}
		questions[63000] = {
			action="jump", goto=60001,
			player="",
			alien={"We do not know.  They do not seem to do a good job though.  They are very good at killing our ships, but do not really fly towards our territory and do not pursue us when we flee.  We do not think they intend to kill us, but just attack anything that happens to be in their way." }
		}


	questions[11001] = {
		action="branch",
		choices = {
			{ text="What type of government do you have?",  goto=11000 },
			{ text="What can you tell us about your biology?", goto=12000 },
			{ text="Why would we want to become your disciples?", goto=13000 }, 
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11101,
		player="What type of government do you have?",
		alien={"We follow the SSSS, also known as saw Secret Society of Spemin Superiority.  We extend our secret and unknowable knowledge to all who wish to become disciples and study under us, and give us all their posessions.  It is our goal and aim of existence to spread the wisdom of the great Blob Goddess, Gertblunk.  Unto us she spews her love in never ending chunks. " }
	}
	questions[12000] = {
		action="jump", goto=12001,
		player="What can you tell us about your biology?",
		alien={"Of course you stare in wonderment at our beautiful antennae.  These antennae allow us to get 32,000 channels with no need for cable.  In addition they pick up the cosmic vibrations that give us our god-like powers.  They also happen to be very fashionable." }
	}
	questions[12001] = {
		action="jump", goto=11001,
		player="<More>",
		alien={"The brain of a spemin is the most complex thing in the universe. In fact, it is so complex that our spemin doctors have, as yet, been unable to determine the exact location of it in the spemin body." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="",
		alien={"Because truly the other races are deprived.   No other race can know the pleasures of a spemin. Ahh, to engulf a fresh glob of protein substance, to bounce a newly budded blobbie on one's pseudopod.  There is a saying among the spemin that sums up our whole philosophy of life. It is - blukbluk durt, smeg! Roughly translated it means 'quivering particle secretes enzyme.' this is just a rough translation." }
	}
	
	questions[11101] = {
		action="branch",
		choices = {
			{ text="Tell us about the Great Blob Goddess.",  goto=11110 },
			{ text="How do you communicate with your goddess?",  goto=11120 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[11110] = {
		action="jump", goto=11111,
		player="",
		alien={"Our race reproduces by budding, so the first commandment of the Great Blob Goddess is to subtract the hostile then add the friendly, or was it divide and multiply?  I'm pretty sure it was to subtract and divide and then multiply." }
	}
	questions[11111] = {
		action="jump", goto=11112,
		player="<More>",
		alien={"Our second commandment is to teach all interior beings.  Your senses are crippled.  Your antennae are small and mounted on the sides of your head.  You have fewer than seven eyes.  You cannot ooze and lack the most rudimentary slime.  You are most absolutely inferior beings. " }
	}
	questions[11112] = {
		action="jump", goto=11101,
		player="<More>",
		alien={"She decreed that we should boldly go to other races in the galaxy, spreading her message of peace and love and all would envy and admire us as you do.  Unfortunately most have not.  In fact, you are the first who have listened for this long." }
	}
	questions[11120] = {
		action="jump", goto=11101,
		player="",
		alien={"Cosmic vibrations travel through the heavens and speak to us directly.  This is not to be questioned for you cannot understand." }
	}

	questions[20001] = {
		action="branch",
		choices = {
			{ text="Great, what other races have you encountered?",  goto=21000 },
			{ text="Do you encounter any races outward of this area of space?",  goto=22000 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[21000] = {
		action="jump", goto=21002,
		player="Great, what other races have you encountered?",
		alien={"Such knowledge is classified, top secret, and unknown.  I mean unknown to you, not unknown to us.  Of course we know of the races we encountered." }
	}
	questions[21002] = {
		action="jump", goto=21001,
		player="Why won't you tell us about other races?",
		alien={"What other races?  We demand to know what you know of the other faction of Spemin!  What do you know about the Thrynn and Elowan factions attacking each other and themselves?  Why the migrations to the Minex?  You must answer now, please??" }
	}
	questions[21001] = {
		action="branch",
		choices = {
		
			{ text="What do you mean, the other Spemin faction?",  goto=21100 },
			{ text="Thrynn and Elowan attacking themselves?",  goto=21200 },
			{ text="What migrations to the Minex?",  goto=21300 },
			{ text="Why are you being so demanding?",  goto=21400 },
			{ text="<Back>", goto=20001 }
		}
	}

		questions[21100] = {
			action="jump", goto=21101,
			player="",
			alien={"We never do this normally, but some of our ships stopped talking and then attacked us.  Defecting Spemin sometimes return to normal with no memory of their rogueish behavior.  Other times these ships run off and we never see them again." }
		}
		questions[21101] = {
			action="jump", goto=21102,
			player="Are they infected with the virus?",
			alien={"Ohh an infection?  No, a madness!  Maybe that is why everyone is both killing each other and themselves.  Actually your people are not, how come?" }
		}
		questions[21102] = {
			action="jump", goto=21001,
			player="We are not infected.",
			alien={"Tell us when you are so we can stay away from you." }
		}
		questions[21200] = {
			action="jump", goto=21201,
			player="",
			alien={"Yes, we see many new races now.  All behaving inconsistently and crazy.  Most common are Elowan attacking Elowan, fleeing from Thrynn, or Thrynn attacking Thrynn." }
		}
		questions[21201] = {
			action="jump", goto=21001,
			player="What other alien races have you identified?",
			alien={"Why should we answer your questions?  Well I guess there is no reason we should not.  We identify Thrynn, Elowan, Bar-Zhon, and some strange others.  Minex are always alone.  Actually many groups of Bar-Zhon by themselves also. They have had many conflicts with the Thrynn just upspin from us. They fly in search patterns between systems.  You would think that they wished to locate something." }
		}
		questions[21300] = {
			action="jump", goto=21301,
			player="",
			alien={"Many strange collections of ships appear we have never seen before.  Some days there are many of them, other days there are none.  Sometimes they attack each other, other times they just attack us.  Maybe a war of madness?  Maybe some crazy migration heading downspin?" }
		}
		questions[21301] = {
			action="jump", goto=21001,
			player="Heading downspin?",
			alien={"Yes, the ships that do not attack each other generally are heading all in the downspin direction towards those the Thrynn call Minex." }
		}
		questions[21400] = {
			action="jump", goto=21001,
			player="",
			alien={"Ohh, we are too demanding?  Sorry.  Please don't attack us." }
		}


	questions[22000] = {
		action="jump", goto=20001,
		player="Do you encounter any races outward of your area of space?",
		alien={"No.  Outward of this area lies a vast dead zone where systems are filled with planets scorched clean of life.  No intelligent spacefaring races have ever approached us from this area, and no life bearing planets have we ever found." }
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
		action="jump", goto=30001,
		player="What can you tell us about Spemin history?",
		alien={"At first many of the degenerate races tried to make us into slaves.  Our passive resistance prevented them from doing so.  Unfortunately it did not stop them from simply killing huge numbers of us, so we are developing new and improved secret techniques for preventing alien incursions and conspiracies." }
	}
	questions[32000] = {
		action="jump", goto=30001,
		player="What about the ancient past?",
		alien={"Historical fact shows us that the Spemin, then known as Ancients once ruled the galaxy.  This was when all races knew peace and love.  Since then fighting and death have separated us all and have deluded many into thinking that force is the answer to everything.  Since then we have forgotten, I mean we choose not to create any more endurium" }
	}
	questions[33000] = {
		action="jump", goto=33001,
		player="Can you tell us about any historic events?",
		alien={"Almost 500,000 cycles, uhh...2000 Myrrdan years ago a strange migrating race appeared out of nowhere and captured a number of our ships and took them away.  Actually they captured all of our ships and took them away.  Since then we figured out what other races use weapons for." }
	}
	questions[33001] = {
		action="jump", goto=30001,
		player="Do you know the name of the race that did this?",
		alien={"No." }
	}


end

------------------------------------------------------------------------
-- SCRIPT INITIALIZATION -----------------------------------------------
------------------------------------------------------------------------
function Initialize()
    -- COMBAT VALUES FOR THIS ALIEN RACE
    health = 100                    -- 100=baseline minimum
    mass = 5                        -- 1=tiny, 10=huge
	engineclass = 3
	shieldclass = 0
	armorclass = 5
	laserclass = 0
	missileclass = 2
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%


	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in
	--12 -  Crystallized Spemin 
	
	DROPITEM1 = 12;	    DROPRATE1 = 98;		DROPQTY1 = 1
	DROPITEM2 = 30;		DROPRATE2 = 20;	    DROPQTY2 = 3
	DROPITEM3 = 31;		DROPRATE3 = 40;		DROPQTY3 = 2
	DROPITEM4 = 39;		DROPRATE4 = 50;		DROPQTY4 = 1
	DROPITEM5 = 54;		DROPRATE5 = 90;		DROPQTY5 = 1

	
	--initialize dialog
	first_question = 1
	starting_attitude = 100
	starting_posture = "obsequious"
	current_question = first_question
	next_question = first_question

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

