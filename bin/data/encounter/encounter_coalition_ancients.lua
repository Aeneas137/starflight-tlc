--[[
	ENCOUNTER SCRIPT FILE: COALITION  ANCIENTS

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
		alien={"We are the ancient and mighty Uhlek.  Bow and pay us homage!  Snicker, snicker.","We ain't your father's Bar-zhon.","Us is stupid alien the most delightful.  Now it is the message leave at the beep."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"We are the ancient and mighty Uhlek.  Bow and pay us homage!  Snicker, snicker.","We ain't your father's Bar-zhon.","Us is stupid alien the most delightful.  Now it is the message leave at the beep."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"We are the ancient and mighty Uhlek.  Bow and pay us homage!  Snicker, snicker.","We ain't your father's Bar-zhon.","Us is stupid alien the most delightful.  Now it is the message leave at the beep."} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"We are the ancient and mighty Uhlek.  Bow and pay us homage!  Snicker, snicker.","We ain't your father's Bar-zhon.","Us is stupid alien the most delightful.  Now it is the message leave at the beep."} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"We are the ancient and mighty Uhlek.  Bow and pay us homage!  Snicker, snicker.","We ain't your father's Bar-zhon.","Us is stupid alien the most delightful.  Now it is the message leave at the beep."} }
		
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"Haha!  That is a laugh!","Don't try to make a chant, you berk!","Silly humans, tricks are for us!","Sure, we believe you.  Try pulling the wool over the goat somewhere else."} }
		
	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	

	questions[50000] = {
		action="branch",
		choices = {
			{ text="Where is your home base?",  goto=51000 },
			{ text="Can you tell us any current news?",  goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=50000,
		player="Where is your home base?",
		alien={"Home base?   Our system is distributed not centralized.  Our outposts, population, and resources are scattered everywhere, even outside the region of space we patrol."}
	}

	questions[52000] = {
		action="jump", goto=60001,
		player="",
		alien={"Good job with the Minex.  Now all we have to do is figure out this plague."}
	}

	questions[60001] = {
		action="branch",
		choices = {
			{ text="What do you know about the plague?", goto=61000 },
			{ text="What problems is the plague causing?", goto=62000 },
			{ text="The Minex think that the ancients have a cure.", goto=63000 },
			{ text="Do you know of any Ancient technology?", goto=64000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"Insane thing, ghastly technology that acts as a mobile biological warfare laboratory.  New strains of viruses pop up everywhere customized to decimate planetary populations and turn the survivors into zombies.  Of course zombies that recover frequently, but not as frequently as before." }
	}
	questions[61001] = {
		action="jump", goto=60001,
		player="<More>",
		alien={"Strangest things just don't add up.  Zombie-controlled ships turn on the Minex and leave other aliens alone.  Considering the technology that causes this plague is so advanced and unstoppable, why is it so ineffective at killing isolated populations and why does it give up control of its victims?" }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="",
		alien={"Problems?  How about filling every densely populated city or station with corpses?   Survivors all undergo some cyclical madness and turn on each other at unpredictable times.  Fully outfitted ships just stop communicating and desert never to return." }
	}
	questions[63000] = {
		action="jump", goto=60001,
		player="",
		alien={"Insanity from the insane.  Feel free to correct us next time you talk to an Ancient one." }
	}
	questions[64000] = {
		action="jump", goto=64001,
		player="",
		alien={"Well we did acquire some positively strange device that is nearly indestructible.  Acts as a sonic disruptor and shatters endurium.  Can't be used in space and has no penetration.  Appears positively ancient however." }
	}
	questions[64001] = {
		action="jump", goto=60001,
		player="May we have the device?",
		alien={"No, but we will send you a holo-schematic." }
	}
	
		questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"The Coalition was created because the Bar-zhon empire survives on slave labor, more the fools they are to provide us with constant recruits.  From the millions of Sabion, Bx, and Transmodra, a few escape to join us every day.  None of them possess the coordination and flying skills of those of us of the Bar-zhon race, but at least here they are treated right."}
	}
		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="Why do members of the Bar-zhon race rebel against them?",  goto=11000 },			
			{ text="Who are the Sabion, Bx, and Transmodra?", goto=12000 },
			{ text="How has the virus affected you guys?", goto=13000 },
			{ text="What about the Minex warfare?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11101,
		player="Why do members of the Bar-zhon race rebel against them?",
		alien={"Because our fabulous government is a military dictatorship.  Technological advances threatened to make everyone's lives too convenient and then who would need government?  First private ownership of ships were outlawed, then weeapons, then the banks were taken over, and finally they dictated everything." }
	}
	questions[11101] = {
		action="branch",
		choices = {
			{ text="How has the virus affected the Bar-zhon?", goto=11110 },
			{ text="Why were your ships hostile until recently?", goto=11120 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[11110] = {
		action="jump", goto=11101,
		player="",
		alien={"The Bar-zhon society has mostly shut down.  Rebellion and madness are increasing in intensity in their society, leaving them paralyzed and unable to stop us." }
	}
	questions[11120] = {
		action="jump", goto=11101,
		player="",
		alien={"Sorry about that small misunderstanding.  New race appears, mysterious plague appears soon afterwards?  It appeared like the Minex were behind it, but who knows now? " }
	}
	questions[12000] = {
		action="jump", goto=12101,
		player="Who are the Sabion, Bx, and Transmodra?",
		alien={"Losers of the last great war.  Their three home worlds were razed and made entirely uninhabitable, but radiation levels have finally started to drop to the point where those with decent equipment can explore their planets without kneeling over instantly from Delta radiation." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="",
		alien={"Quite the death toll until recently, however the death and madness hit everyone hard.  Keeping everyone away from each other and in isolated lockdown has limited the madness and almost stopped the death toll for the short-term." }
	}

	questions[14000] = {
		action="jump", goto=14101,
		player="",
		alien={"Heard your race was responsible for putting the brakes on the Minex.  Shame they didn't have a cure tucked away somewhere." }
	}
	questions[12101] = {
		action="branch",
		choices = {
			{ text="Where is the home  of the Sabion?",  goto=12110 },
			{ text="Where is the home world of the Bx?",  goto=12120 },
			{ text="Where is the home world of the Transmodra?",  goto=12130 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[12110] = {
		action="jump", goto=12101,
		player="Where is the home world of the Sabion?",
		alien={"Gorias 3 - 5,16" }
	}
	questions[12120] = {
		action="jump", goto=12101,
		player="Where is the home world of the Bx?",
		alien={"Cian 3 - 25,205" }
	}
	questions[12130] = {
		action="jump", goto=12101,
		player="Where is the home world of the Transmodra?",
		alien={"Dian Cecht 4 - 35,139.  Bar-zhon scavengers are searching all these worlds.  Beat them to whatever they are after, ok?" }
	}
	
	questions[14101] = {
		action="branch",
		choices = {
			{ text="Why do you still attack the Bar-zhon?",  goto=14110 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[14110] = {
		action="jump", goto=11001,
		player="",
		alien={"We aren't attacking anyone.  With the Minex gone and the Bar-zhon paralyzed we are finally getting around to long overdue strategic positioning of our own." }
	}

	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Ehh?  We know a bit concerning a few of the races in the sector.  Are you interested in the Tafel, the Nyssian, the Minex, the Bar-zhon, the Elowan, the Thrynn, or other pirates?"}
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Bar-zhon.",  goto=21000 },
			{ text="Tell us about the Tafel.",  goto=22000 },
			{ text="Tell us about the Nyssian.",  goto=23000 },
			{ text="<More>",  goto=21002 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21002] = {
		action="branch",
		choices = {
			{ text="Tell us about the Minex.",  goto=24000 },
			{ text="Tell us about the Thrynn and Elowan.",  goto=25000 },
			{ text="Tell us about the Spemin.",  goto=26000 },
			{ text="Tell us about other pirates.",  goto=27000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=21001,
		player="Tell us about the Bar-zhon.",
		alien={"Ahh, the Bar-zhon.  Our favorite pals.  Their warships are a mite tough, but not too difficult to take down.  Missile barrages from a decent distance take them out easily enough.  If your ship is fast enough and your pilot skilled enough, keep in mind that all of their ships have only missile weapons and no close quarter lasers." }
	}
	questions[22000] = {
		action="jump", goto=22100,
		player="Tell us about the Tafel.",
		alien={"The Tafel are interesting lot.  Quite adaptive they have proven to be yet strangely unable to see the benefits of profitable ventures.  If you ever get in a scrape with them make sure you never leave a damaged or disabled ship behind you - those suckers have a uncanny ability to repair their ships faster than your shields can regenerate." }
	}
	questions[22100] = {
		action="jump", goto=21001,
		player="<More>",
		alien={"They are simple folk, yet quite dangerous in large numbers.  Fortunately a single Tafel ship has weak shields and paper thin armor." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="Tell us about the Nyssian.",
		alien={"Arrogant Nyssian wanderers travel alone in their weird organic vessels.  There vessels always travel alone and have very weak weaponry.  They make good target practice if you want to shoot something more difficult than a rock, but their ships are made up virtually no salvageable material, and they're strangely effective shields take quite a beating, and no one has ever salvaged or reverse engineered them." }
	}
	questions[24000] = {
		action="jump", goto=21002,
		player="Tell us about the Minex.",
		alien={"The Minex are a psychotic bunch.  They never communicated with anyone until you came along.  You probably should be telling us about them not the other way around.    Actually one thing you might not know.  Attempted incursions during the great war led many to believe that the Minex homeworld to be located somewhere within the Pearl cluster." }
	}
	questions[25000] = {
		action="jump", goto=25100,
		player="Tell us about the Elowan.",
		alien={"The Elowan be a strange folk.  Transmitted genetic memories make them impossible to tame, even when grown from seed.  Their little petty conflict with the Thrynn has come back and forth many a time but currently they be on the losing side.  They have just recently developed some strange laser reflective armor which makes their ships highly resistant to laser damage." }
	}
	questions[25100] = {
		action="jump", goto=21002,
		player="Tell us about the Thrynn.",
		alien={"The Thrynn are a nasty sort.  Endless warfare has ground down their ships and resources but they are nasty and tenacious, and refuse to ever surrender or give up a fight.  Unless you're capable of fighting off an empire for the next hundred years it's best not to mess with them.  Their ships are well rounded, recently added missile technology balancing out their powerful laser batteries." }
	}
	questions[26000] = {
		action="jump", goto=21002,
		player="Tell us about the Spemin.",
		alien={"Strange rambling blob-like creatures?  Don't bother.  Their tech is trash and they don't know anything.  Fun target practice however." }
	}
	questions[27000] = {
		action="jump", goto=21002,
		player="Tell us about other pirates.",
		alien={"The unaligned pirates have been mostly subverted by the mad ones uniting in the area around your home world.  Without the Minex culling their numbers, huge waves of them have united to invade Minex space.  Better them than us." }
	}

	questions[30000] = {
		action="jump", goto=31001,
		player="What can you tell us about the past?",
		alien={"The past?  Go bother the Nyssian about the past.  Feel free to also pester the Bar-zhon, they tell a decently honest history story even though it's slanted their way a bit."}
	}

	questions[31001] = {
		action="branch",
		choices = {
			{ text="Can you tell me how the coalition was formed?",  goto=31002 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[31002] = {
		action="jump", goto=1,
		player="Can you tell me how the coalition was formed?",
		alien={"The coalition is just the most recent name to what once was a political movement in Bar-zhon society.  Once the other political party took firm control of the military and the media, all of our leaders were systematically neutralized through blackmail, lies, and underhanded techniques.  For a while we were a subversive resistance movement but now all we seek is independence." }
	}
	questions[40000] = {
		action="jump", goto=41001,
		player="Tell us about the Ancients.",
		alien={"What do you want to know?" }
	}
	questions[41001] = {
		action="branch",
		choices = {
			{ text="Could you tell us about the ancients themselves?",  goto=41000 },
			{ text="Could you tell us where endurium can be found?",  goto=42000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[41000] = {
		action="jump", goto=41001,
		player="Could you tell us about the ancients themselves?",
		alien={"Very old race, gone, gave us endurium."}
	}
	questions[42000] = {
		action="jump", goto=42001,
		player="Could you tell us where endurium can be found?",
		alien={"Try investigating Tafel space around Mag Rein1 - 101,15 or Aoi 4 - 167,16.  Bar-zhon space was strip mined long ago.  Strangely enough, endurium is never located below ground, but I guess the ancients wanted us to find the stuff easily enough."}
	}
	questions[42001] = {
		action="jump", goto=41001,
		player="<More>",
		alien={"Not that anyone has ever returned from there recently, but in the past there have been rumors that additional endurium rich planets can be found in the area of space past Thrynn territory near the Spemin."}
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

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"Why thank you.  Recent Minex tech fits us nicely."} }
	statements[2] = {
		action="",
		player="Your ship appears very irregular.",
		alien={"Why thank you very much.  It is my own custom model interceptor outfitted with afterburners and state-of-the-art Minex weaponry just ready to slice and dice and even make julian fries."} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"Oh we believe you, believe me that we believe you."} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"As long as you help us discover a cure to this illness,  almost any exchange is fine."} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"How did you come up with a whopper like that one?"} }
		 



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 

	questions[50000] = {
		action="branch",
		choices = {
			{ text="Where is your home base?",  goto=51000 },
			{ text="Can you tell us any current news?",  goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=50000,
		player="Where is your home base?",
		alien={"Home base?   Our system is distributed not centralized.  Our outposts, population, and resources are scattered everywhere, even outside the region of space we patrol."}
	}

	questions[52000] = {
		action="jump", goto=60001,
		player="",
		alien={"Good job with the Minex.  Now all we have to do is figure out this plague."}
	}

	questions[60001] = {
		action="branch",
		choices = {
			{ text="What do you know about the plague?", goto=61000 },
			{ text="What problems is the plague causing?", goto=62000 },
			{ text="The Minex think that the ancients have a cure.", goto=63000 },
			{ text="Do you know of any Ancient technology?", goto=64000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"Insane thing, ghastly technology that acts as a mobile biological warfare laboratory.  New strains of viruses pop up everywhere customized to decimate planetary populations and turn the survivors into zombies.  Of course zombies that recover frequently, but not as frequently as before." }
	}
	questions[61001] = {
		action="jump", goto=60001,
		player="<More>",
		alien={"Strangest things just don't add up.  Zombie-controlled ships turn on the Minex and leave other aliens alone.  Considering the technology that causes this plague is so advanced and unstoppable, why is it so ineffective at killing isolated populations and why does it give up control of its victims?" }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="",
		alien={"Problems?  How about filling every densely populated city or station with corpses?   Survivors all undergo some cyclical madness and turn on each other at unpredictable times.  Fully outfitted ships just stop communicating and desert never to return." }
	}
	questions[63000] = {
		action="jump", goto=60001,
		player="",
		alien={"Insanity from the insane.  Feel free to correct us next time you talk to an Ancient one." }
	}
	questions[64000] = {
		action="jump", goto=64001,
		player="",
		alien={"Well we did acquire some positively strange device that is nearly indestructible.  Acts as a sonic disruptor and shatters endurium.  Can't be used in space and has no penetration.  Appears positively ancient however." }
	}
	questions[64001] = {
		action="jump", goto=60001,
		player="May we have the device?",
		alien={"No, but we will send you a holo-schematic." }
	}
	
		questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"The Coalition was created because the Bar-zhon empire survives on slave labor, more the fools they are to provide us with constant recruits.  From the millions of Sabion, Bx, and Transmodra, a few escape to join us every day.  None of them possess the coordination and flying skills of those of us of the Bar-zhon race, but at least here they are treated right."}
	}
		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="Why do members of the Bar-zhon race rebel against them?",  goto=11000 },			
			{ text="Who are the Sabion, Bx, and Transmodra?", goto=12000 },
			{ text="How has the virus affected you guys?", goto=13000 },
			{ text="What about the Minex warfare?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11101,
		player="Why do members of the Bar-zhon race rebel against them?",
		alien={"Because our fabulous government is a military dictatorship.  Technological advances threatened to make everyone's lives too convenient and then who would need government?  First private ownership of ships were outlawed, then weeapons, then the banks were taken over, and finally they dictated everything." }
	}
	questions[11101] = {
		action="branch",
		choices = {
			{ text="How has the virus affected the Bar-zhon?", goto=11110 },
			{ text="Why were your ships hostile until recently?", goto=11120 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[11110] = {
		action="jump", goto=11101,
		player="",
		alien={"The Bar-zhon society has mostly shut down.  Rebellion and madness are increasing in intensity in their society, leaving them paralyzed and unable to stop us." }
	}
	questions[11120] = {
		action="jump", goto=11101,
		player="",
		alien={"Sorry about that small misunderstanding.  New race appears, mysterious plague appears soon afterwards?  It appeared like the Minex were behind it, but who knows now? " }
	}
	questions[12000] = {
		action="jump", goto=12101,
		player="Who are the Sabion, Bx, and Transmodra?",
		alien={"Losers of the last great war.  Their three home worlds were razed and made entirely uninhabitable, but radiation levels have finally started to drop to the point where those with decent equipment can explore their planets without kneeling over instantly from Delta radiation." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="",
		alien={"Quite the death toll until recently, however the death and madness hit everyone hard.  Keeping everyone away from each other and in isolated lockdown has limited the madness and almost stopped the death toll for the short-term." }
	}

	questions[14000] = {
		action="jump", goto=14101,
		player="",
		alien={"Heard your race was responsible for putting the brakes on the Minex.  Shame they didn't have a cure tucked away somewhere." }
	}
	questions[12101] = {
		action="branch",
		choices = {
			{ text="Where is the home  of the Sabion?",  goto=12110 },
			{ text="Where is the home world of the Bx?",  goto=12120 },
			{ text="Where is the home world of the Transmodra?",  goto=12130 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[12110] = {
		action="jump", goto=12101,
		player="Where is the home world of the Sabion?",
		alien={"Gorias 3 - 5,16" }
	}
	questions[12120] = {
		action="jump", goto=12101,
		player="Where is the home world of the Bx?",
		alien={"Cian 3 - 25,205" }
	}
	questions[12130] = {
		action="jump", goto=12101,
		player="Where is the home world of the Transmodra?",
		alien={"Dian Cecht 4 - 35,139.  Bar-zhon scavengers are searching all these worlds.  Beat them to whatever they are after, ok?" }
	}
	
	questions[14101] = {
		action="branch",
		choices = {
			{ text="Why do you still attack the Bar-zhon?",  goto=14110 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[14110] = {
		action="jump", goto=11001,
		player="",
		alien={"We aren't attacking anyone.  With the Minex gone and the Bar-zhon paralyzed we are finally getting around to long overdue strategic positioning of our own." }
	}

	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Ehh?  We know a bit concerning a few of the races in the sector.  Are you interested in the Tafel, the Nyssian, the Minex, the Bar-zhon, the Elowan, the Thrynn, or other pirates?"}
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Bar-zhon.",  goto=21000 },
			{ text="Tell us about the Tafel.",  goto=22000 },
			{ text="Tell us about the Nyssian.",  goto=23000 },
			{ text="<More>",  goto=21002 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21002] = {
		action="branch",
		choices = {
			{ text="Tell us about the Minex.",  goto=24000 },
			{ text="Tell us about the Thrynn and Elowan.",  goto=25000 },
			{ text="Tell us about the Spemin.",  goto=26000 },
			{ text="Tell us about other pirates.",  goto=27000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=21001,
		player="Tell us about the Bar-zhon.",
		alien={"Ahh, the Bar-zhon.  Our favorite pals.  Their warships are a mite tough, but not too difficult to take down.  Missile barrages from a decent distance take them out easily enough.  If your ship is fast enough and your pilot skilled enough, keep in mind that all of their ships have only missile weapons and no close quarter lasers." }
	}
	questions[22000] = {
		action="jump", goto=22100,
		player="Tell us about the Tafel.",
		alien={"The Tafel are interesting lot.  Quite adaptive they have proven to be yet strangely unable to see the benefits of profitable ventures.  If you ever get in a scrape with them make sure you never leave a damaged or disabled ship behind you - those suckers have a uncanny ability to repair their ships faster than your shields can regenerate." }
	}
	questions[22100] = {
		action="jump", goto=21001,
		player="<More>",
		alien={"They are simple folk, yet quite dangerous in large numbers.  Fortunately a single Tafel ship has weak shields and paper thin armor." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="Tell us about the Nyssian.",
		alien={"Arrogant Nyssian wanderers travel alone in their weird organic vessels.  There vessels always travel alone and have very weak weaponry.  They make good target practice if you want to shoot something more difficult than a rock, but their ships are made up virtually no salvageable material, and they're strangely effective shields take quite a beating, and no one has ever salvaged or reverse engineered them." }
	}
	questions[24000] = {
		action="jump", goto=21002,
		player="Tell us about the Minex.",
		alien={"The Minex are a psychotic bunch.  They never communicated with anyone until you came along.  You probably should be telling us about them not the other way around.    Actually one thing you might not know.  Attempted incursions during the great war led many to believe that the Minex homeworld to be located somewhere within the Pearl cluster." }
	}
	questions[25000] = {
		action="jump", goto=25100,
		player="Tell us about the Elowan.",
		alien={"The Elowan be a strange folk.  Transmitted genetic memories make them impossible to tame, even when grown from seed.  Their little petty conflict with the Thrynn has come back and forth many a time but currently they be on the losing side.  They have just recently developed some strange laser reflective armor which makes their ships highly resistant to laser damage." }
	}
	questions[25100] = {
		action="jump", goto=21002,
		player="Tell us about the Thrynn.",
		alien={"The Thrynn are a nasty sort.  Endless warfare has ground down their ships and resources but they are nasty and tenacious, and refuse to ever surrender or give up a fight.  Unless you're capable of fighting off an empire for the next hundred years it's best not to mess with them.  Their ships are well rounded, recently added missile technology balancing out their powerful laser batteries." }
	}
	questions[26000] = {
		action="jump", goto=21002,
		player="Tell us about the Spemin.",
		alien={"Strange rambling blob-like creatures?  Don't bother.  Their tech is trash and they don't know anything.  Fun target practice however." }
	}
	questions[27000] = {
		action="jump", goto=21002,
		player="Tell us about other pirates.",
		alien={"The unaligned pirates have been mostly subverted by the mad ones uniting in the area around your home world.  Without the Minex culling their numbers, huge waves of them have united to invade Minex space.  Better them than us." }
	}

	questions[30000] = {
		action="jump", goto=31001,
		player="What can you tell us about the past?",
		alien={"The past?  Go bother the Nyssian about the past.  Feel free to also pester the Bar-zhon, they tell a decently honest history story even though it's slanted their way a bit."}
	}

	questions[31001] = {
		action="branch",
		choices = {
			{ text="Can you tell me how the coalition was formed?",  goto=31002 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[31002] = {
		action="jump", goto=1,
		player="Can you tell me how the coalition was formed?",
		alien={"The coalition is just the most recent name to what once was a political movement in Bar-zhon society.  Once the other political party took firm control of the military and the media, all of our leaders were systematically neutralized through blackmail, lies, and underhanded techniques.  For a while we were a subversive resistance movement but now all we seek is independence." }
	}
	questions[40000] = {
		action="jump", goto=41001,
		player="Tell us about the Ancients.",
		alien={"What do you want to know?" }
	}
	questions[41001] = {
		action="branch",
		choices = {
			{ text="Could you tell us about the ancients themselves?",  goto=41000 },
			{ text="Could you tell us where endurium can be found?",  goto=42000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[41000] = {
		action="jump", goto=41001,
		player="Could you tell us about the ancients themselves?",
		alien={"Very old race, gone, gave us endurium."}
	}
	questions[42000] = {
		action="jump", goto=42001,
		player="Could you tell us where endurium can be found?",
		alien={"Try investigating Tafel space around Mag Rein1 - 101,15 or Aoi 4 - 167,16.  Bar-zhon space was strip mined long ago.  Strangely enough, endurium is never located below ground, but I guess the ancients wanted us to find the stuff easily enough."}
	}
	questions[42001] = {
		action="jump", goto=41001,
		player="<More>",
		alien={"Not that anyone has ever returned from there recently, but in the past there have been rumors that additional endurium rich planets can be found in the area of space past Thrynn territory near the Spemin."}
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
		alien={"If you want a romp, we're happy to accommodate."} }
	greetings[2] = {
		action="attack",
		player="This is the starship [SHIPNAME]. We are heavily armed.",
		alien={"Ohh feel free to demonstrate."}	}
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
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="attack",
		player="Your ship is over-embellished and weak.",
		alien={"Over embellished, maybe.  Weak, never.  Here, let me demonstrate."} }
	statements[2] = {
		action="attack",
		player="What an ugly and worthless creature.",
		alien={"I'm sorry I can't seem to hear you.  Please boost your gain knob.  Nevermind, we'll just get closer and call you right back."} }
	statements[3] = {
		action="attack",
		player="Your ship looks like a flying garbage scow.",
		alien={"Incredible!  How could I have not noticed this?  Unfortunately our cargo bays are empty of garbage.  If you would not mind, we would greatly appreciate it if you could scrap your ship for us to haul.."} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD


	questions[50000] = {
		action="branch",
		choices = {
			{ text="Where is your home base?",  goto=51000 },
			{ text="Can you tell us any current news?",  goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=50000,
		player="Where is your home base?",
		alien={"Home base?   Our system is distributed not centralized.  Our outposts, population, and resources are scattered everywhere, even outside the region of space we patrol."}
	}

	questions[52000] = {
		action="jump", goto=60001,
		player="",
		alien={"Good job with the Minex.  Now all we have to do is figure out this plague."}
	}

	questions[60001] = {
		action="branch",
		choices = {
			{ text="What do you know about the plague?", goto=61000 },
			{ text="What problems is the plague causing?", goto=62000 },
			{ text="The Minex think that the ancients have a cure.", goto=63000 },
			{ text="Do you know of any Ancient technology?", goto=64000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"Insane thing, ghastly technology that acts as a mobile biological warfare laboratory.  New strains of viruses pop up everywhere customized to decimate planetary populations and turn the survivors into zombies.  Of course zombies that recover frequently, but not as frequently as before." }
	}
	questions[61001] = {
		action="jump", goto=60001,
		player="<More>",
		alien={"Strangest things just don't add up.  Zombie-controlled ships turn on the Minex and leave other aliens alone.  Considering the technology that causes this plague is so advanced and unstoppable, why is it so ineffective at killing isolated populations and why does it give up control of its victims?" }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="",
		alien={"Problems?  How about filling every densely populated city or station with corpses?   Survivors all undergo some cyclical madness and turn on each other at unpredictable times.  Fully outfitted ships just stop communicating and desert never to return." }
	}
	questions[63000] = {
		action="jump", goto=60001,
		player="",
		alien={"Insanity from the insane.  Feel free to correct us next time you talk to an Ancient one." }
	}
	questions[64000] = {
		action="jump", goto=64001,
		player="",
		alien={"Well we did acquire some positively strange device that is nearly indestructible.  Acts as a sonic disruptor and shatters endurium.  Can't be used in space and has no penetration.  Appears positively ancient however." }
	}
	questions[64001] = {
		action="jump", goto=60001,
		player="May we have the device?",
		alien={"No, but we will send you a holo-schematic." }
	}
	
		questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"The Coalition was created because the Bar-zhon empire survives on slave labor, more the fools they are to provide us with constant recruits.  From the millions of Sabion, Bx, and Transmodra, a few escape to join us every day.  None of them possess the coordination and flying skills of those of us of the Bar-zhon race, but at least here they are treated right."}
	}
		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="Why do members of the Bar-zhon race rebel against them?",  goto=11000 },			
			{ text="Who are the Sabion, Bx, and Transmodra?", goto=12000 },
			{ text="How has the virus affected you guys?", goto=13000 },
			{ text="What about the Minex warfare?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11101,
		player="Why do members of the Bar-zhon race rebel against them?",
		alien={"Because our fabulous government is a military dictatorship.  Technological advances threatened to make everyone's lives too convenient and then who would need government?  First private ownership of ships were outlawed, then weeapons, then the banks were taken over, and finally they dictated everything." }
	}
	questions[11101] = {
		action="branch",
		choices = {
			{ text="How has the virus affected the Bar-zhon?", goto=11110 },
			{ text="Why were your ships hostile until recently?", goto=11120 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[11110] = {
		action="jump", goto=11101,
		player="",
		alien={"The Bar-zhon society has mostly shut down.  Rebellion and madness are increasing in intensity in their society, leaving them paralyzed and unable to stop us." }
	}
	questions[11120] = {
		action="jump", goto=11101,
		player="",
		alien={"Sorry about that small misunderstanding.  New race appears, mysterious plague appears soon afterwards?  It appeared like the Minex were behind it, but who knows now? " }
	}
	questions[12000] = {
		action="jump", goto=12101,
		player="Who are the Sabion, Bx, and Transmodra?",
		alien={"Losers of the last great war.  Their three home worlds were razed and made entirely uninhabitable, but radiation levels have finally started to drop to the point where those with decent equipment can explore their planets without kneeling over instantly from Delta radiation." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="",
		alien={"Quite the death toll until recently, however the death and madness hit everyone hard.  Keeping everyone away from each other and in isolated lockdown has limited the madness and almost stopped the death toll for the short-term." }
	}

	questions[14000] = {
		action="jump", goto=14101,
		player="",
		alien={"Heard your race was responsible for putting the brakes on the Minex.  Shame they didn't have a cure tucked away somewhere." }
	}
	questions[12101] = {
		action="branch",
		choices = {
			{ text="Where is the home  of the Sabion?",  goto=12110 },
			{ text="Where is the home world of the Bx?",  goto=12120 },
			{ text="Where is the home world of the Transmodra?",  goto=12130 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[12110] = {
		action="jump", goto=12101,
		player="Where is the home world of the Sabion?",
		alien={"Gorias 3 - 5,16" }
	}
	questions[12120] = {
		action="jump", goto=12101,
		player="Where is the home world of the Bx?",
		alien={"Cian 3 - 25,205" }
	}
	questions[12130] = {
		action="jump", goto=12101,
		player="Where is the home world of the Transmodra?",
		alien={"Dian Cecht 4 - 35,139.  Bar-zhon scavengers are searching all these worlds.  Beat them to whatever they are after, ok?" }
	}
	
	questions[14101] = {
		action="branch",
		choices = {
			{ text="Why do you still attack the Bar-zhon?",  goto=14110 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[14110] = {
		action="jump", goto=11001,
		player="",
		alien={"We aren't attacking anyone.  With the Minex gone and the Bar-zhon paralyzed we are finally getting around to long overdue strategic positioning of our own." }
	}

	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Ehh?  We know a bit concerning a few of the races in the sector.  Are you interested in the Tafel, the Nyssian, the Minex, the Bar-zhon, the Elowan, the Thrynn, or other pirates?"}
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Bar-zhon.",  goto=21000 },
			{ text="Tell us about the Tafel.",  goto=22000 },
			{ text="Tell us about the Nyssian.",  goto=23000 },
			{ text="<More>",  goto=21002 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21002] = {
		action="branch",
		choices = {
			{ text="Tell us about the Minex.",  goto=24000 },
			{ text="Tell us about the Thrynn and Elowan.",  goto=25000 },
			{ text="Tell us about the Spemin.",  goto=26000 },
			{ text="Tell us about other pirates.",  goto=27000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=21001,
		player="Tell us about the Bar-zhon.",
		alien={"Ahh, the Bar-zhon.  Our favorite pals.  Their warships are a mite tough, but not too difficult to take down.  Missile barrages from a decent distance take them out easily enough.  If your ship is fast enough and your pilot skilled enough, keep in mind that all of their ships have only missile weapons and no close quarter lasers." }
	}
	questions[22000] = {
		action="jump", goto=22100,
		player="Tell us about the Tafel.",
		alien={"The Tafel are interesting lot.  Quite adaptive they have proven to be yet strangely unable to see the benefits of profitable ventures.  If you ever get in a scrape with them make sure you never leave a damaged or disabled ship behind you - those suckers have a uncanny ability to repair their ships faster than your shields can regenerate." }
	}
	questions[22100] = {
		action="jump", goto=21001,
		player="<More>",
		alien={"They are simple folk, yet quite dangerous in large numbers.  Fortunately a single Tafel ship has weak shields and paper thin armor." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="Tell us about the Nyssian.",
		alien={"Arrogant Nyssian wanderers travel alone in their weird organic vessels.  There vessels always travel alone and have very weak weaponry.  They make good target practice if you want to shoot something more difficult than a rock, but their ships are made up virtually no salvageable material, and they're strangely effective shields take quite a beating, and no one has ever salvaged or reverse engineered them." }
	}
	questions[24000] = {
		action="jump", goto=21002,
		player="Tell us about the Minex.",
		alien={"The Minex are a psychotic bunch.  They never communicated with anyone until you came along.  You probably should be telling us about them not the other way around.    Actually one thing you might not know.  Attempted incursions during the great war led many to believe that the Minex homeworld to be located somewhere within the Pearl cluster." }
	}
	questions[25000] = {
		action="jump", goto=25100,
		player="Tell us about the Elowan.",
		alien={"The Elowan be a strange folk.  Transmitted genetic memories make them impossible to tame, even when grown from seed.  Their little petty conflict with the Thrynn has come back and forth many a time but currently they be on the losing side.  They have just recently developed some strange laser reflective armor which makes their ships highly resistant to laser damage." }
	}
	questions[25100] = {
		action="jump", goto=21002,
		player="Tell us about the Thrynn.",
		alien={"The Thrynn are a nasty sort.  Endless warfare has ground down their ships and resources but they are nasty and tenacious, and refuse to ever surrender or give up a fight.  Unless you're capable of fighting off an empire for the next hundred years it's best not to mess with them.  Their ships are well rounded, recently added missile technology balancing out their powerful laser batteries." }
	}
	questions[26000] = {
		action="jump", goto=21002,
		player="Tell us about the Spemin.",
		alien={"Strange rambling blob-like creatures?  Don't bother.  Their tech is trash and they don't know anything.  Fun target practice however." }
	}
	questions[27000] = {
		action="jump", goto=21002,
		player="Tell us about other pirates.",
		alien={"The unaligned pirates have been mostly subverted by the mad ones uniting in the area around your home world.  Without the Minex culling their numbers, huge waves of them have united to invade Minex space.  Better them than us." }
	}

	questions[30000] = {
		action="jump", goto=31001,
		player="What can you tell us about the past?",
		alien={"The past?  Go bother the Nyssian about the past.  Feel free to also pester the Bar-zhon, they tell a decently honest history story even though it's slanted their way a bit."}
	}

	questions[31001] = {
		action="branch",
		choices = {
			{ text="Can you tell me how the coalition was formed?",  goto=31002 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[31002] = {
		action="jump", goto=1,
		player="Can you tell me how the coalition was formed?",
		alien={"The coalition is just the most recent name to what once was a political movement in Bar-zhon society.  Once the other political party took firm control of the military and the media, all of our leaders were systematically neutralized through blackmail, lies, and underhanded techniques.  For a while we were a subversive resistance movement but now all we seek is independence." }
	}
	questions[40000] = {
		action="jump", goto=41001,
		player="Tell us about the Ancients.",
		alien={"What do you want to know?" }
	}
	questions[41001] = {
		action="branch",
		choices = {
			{ text="Could you tell us about the ancients themselves?",  goto=41000 },
			{ text="Could you tell us where endurium can be found?",  goto=42000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[41000] = {
		action="jump", goto=41001,
		player="Could you tell us about the ancients themselves?",
		alien={"Very old race, gone, gave us endurium."}
	}
	questions[42000] = {
		action="jump", goto=42001,
		player="Could you tell us where endurium can be found?",
		alien={"Try investigating Tafel space around Mag Rein1 - 101,15 or Aoi 4 - 167,16.  Bar-zhon space was strip mined long ago.  Strangely enough, endurium is never located below ground, but I guess the ancients wanted us to find the stuff easily enough."}
	}
	questions[42001] = {
		action="jump", goto=41001,
		player="<More>",
		alien={"Not that anyone has ever returned from there recently, but in the past there have been rumors that additional endurium rich planets can be found in the area of space past Thrynn territory near the Spemin."}
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

