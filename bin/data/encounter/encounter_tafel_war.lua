--[[
	ENCOUNTER SCRIPT FILE: TAFEL WAR

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

