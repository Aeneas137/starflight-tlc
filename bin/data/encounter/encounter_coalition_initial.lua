--[[
	ENCOUNTER SCRIPT FILE: COALITION  INITIAL

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

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"The Coalition was created because the Bar-zhon empire survives on slave labor, more the fools they are to provide us with constant recruits.  From the millions of Sabion, Bx, and Transmodra, a few escape to join us every day.  None of them possess the coordination and flying skills of those of us of the Bar-zhon race, but at least here they are treated right."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Ehh?  We know a bit concerning a few of the races in the sector.  Are you interested in the Tafel, the Nyssian, the Minex, the Bar-zhon, the Elowan, the Thrynn, or other pirates?"}
	}
	questions[30000] = {
		action="jump", goto=31001,
		player="What can you tell us about the past?",
		alien={"The past?  Go bother the Nyssian about the past.  Feel free to also pester the Bar-zhon, they tell a decently honest history story even though it's slanted their way a bit."}
	}
	questions[40000] = {
		action="jump", goto=41001,
		player="Tell us about the Ancients.",
		alien={"Fah!  I guess I could scoop the dirt on a few endurium planets." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Where is your home base?",  goto=51000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=1,
		player="Where is your home base?",
		alien={"Don't you be thinking that we'd be some simple dolts now, you hear?"}
	}
	
		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="Why do members of the Bar-zhon race rebel against them?",  goto=11000 },
			{ text="Who are the Sabion, Bx, and Transmodra?", goto=12000 },
			{ text="What can you tell us about your biology?", goto=13000 },
			{ text="What are your goals?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="Why do members of the Bar-zhon race rebel against them?",
		alien={"Because our fabulous government is a military dictatorship, and if you're not born into a family of noble birth, you are shuffled into the technician or worker caste and have no role in either the government or the military.  Our rebellion is as much from a desire to live in freedom as it is for anything else." }
	}
	questions[12000] = {
		action="jump", goto=12101,
		player="Who are the Sabion, Bx, and Transmodra?",
		alien={"Losers of the last great war.  Their three home worlds were razed and made entirely uninhabitable, but radiation levels have finally started to drop to the point where those with decent equipment can explore their planets without kneeling over instantly from Delta radiation." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="What can you tell us about your biology?",
		alien={"Kaak!  Go bother someone who cares!" }
	}
	questions[14000] = {
		action="jump", goto=14101,
		player="What are your goals?",
		alien={"To survive by blending into the Bar-Zhon empire as best possible.  Our military and technological capacities have grown much further than the Bar-Zhon suspect.  Oh I don't care if you are a Bar-Zhon infiltrator or sympathizer, they already disbelieve their own reports thinking us shortsighted revolutionaries and nothing else." }
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
		alien={"Not so hasty grave robbers.  Don't expect to fool us with your platitudes either." }
	}
	questions[12120] = {
		action="jump", goto=12101,
		player="Where is the home world of the Bx?",
		alien={"The superb ground pounders.  None of their low level dueling abilities helped them in space. However don't be expecting us to assist grave robbers loot their world." }
	}
	questions[12130] = {
		action="jump", goto=12101,
		player="Where is the home world of the Transmodra?",
		alien={"The mighty industrialists, oh how they fell quickly to deception.  We will not be the ones opening their world to scavengers." }
	}
	
	questions[14101] = {
		action="branch",
		choices = {
			{ text="Why do you attack the Bar-zhon?",  goto=14110 },
			{ text="What are you if not revolutionaries?",  goto=14120 },
			{ text="Why don't you simply leave Bar-zhon space?",  goto=14130 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[14110] = {
		action="jump", goto=14101,
		player="Why do you attack the Bar-zhon?",
		alien={"Maintenance of the status quo.  If we stopped attacking they would get worried and to start to investigate.  If we declared all-out war there is no guarantee we would win.  Guerrilla attacks keep the mighty implacable and inflexible Bar-zhon Navy busy while we make progress elsewhere." }
	}
	questions[14120] = {
		action="jump", goto=14101,
		player="What are you if not revolutionaries?",
		alien={"<Sigh>   I told you already you slow alien.  We want to live in freedom, not die in war.  Beyond that our aims are our own." }
	}
	questions[14130] = {
		action="jump", goto=14101,
		player="Why don't you simply leave Bar-zhon space?",
		alien={"Commit a mass exodus of population under the noses of a hostile force?  Expose every single ship and resource we have to counterattack?  Simply ask to remove a slave population and see if the slave masters let them go willingly?  I assume you see the problems by now." }
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
		alien={"They are simple folk, yet quite dangerous in large numbers.  Fortunately a single Tafel ship has weak shields and paper thin armor.  They blow quite nicely." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="Tell us about the Nyssian.",
		alien={"Arrogant Nyssian wanderers travel alone in their weird organic vessels.  There vessels always travel alone and have very weak weaponry.  They make good target practice if you want to shoot something more difficult than a rock, but their ships are made up virtually no salvageable material, and they're strangely effective shields take quite a beating, and no one has ever salvaged or reverse engineered them." }
	}
	questions[24000] = {
		action="jump", goto=24100,
		player="Tell us about the Minex.",
		alien={"The Minex are too much trouble, yet some fool always tries to go after them to prove themselves.  The few that return often salvage amazing technologies and are highly respected.   Of course ones so daft are often raided themselves when they return, just in case they happened to have some amazing technologies." }
	}
	questions[24100] = {
		action="jump", goto=21002,
		player="<More>",
		alien={"If you try to tangle with those blokes, keep to your lasers.  Some blasted energy field diverts missile explosions away from them, making your missiles much less effective." }
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
		alien={"Never heard of them." }
	}
	questions[27000] = {
		action="jump", goto=21002,
		player="Tell us about other pirates.",
		alien={"General outlaws and pirates tend to inhabit the center of this sector, sort of where you guys came from.  Their equipment is patchy and badly worn, and they are not seriously a threat to anyone except the weakest merchant vessel." }
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
		alien={"Do I look like a blasted recruiter?  Go bother someone who cares." }
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
		alien={"I don't know or care.  Pester someone else."}
	}
	questions[42000] = {
		action="jump", goto=42001,
		player="Could you tell us where endurium can be found?",
		alien={"Try investigating Tafel space around Mag Rein1 - 101,15 or Aoi 4 - 167,16.  Bar-zhon space was stripmined long ago.  Strangely enough, endurium is never located below ground, but I guess the ancients wanted us to find them easily enough!"}
	}
	questions[42001] = {
		action="jump", goto=41001,
		player="<More>",
		alien={"Not that anyone has ever returned from there recently, but in the past there have been rumors that additional endurium rich planets can be found in the area of space past Thrynn territory."}
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

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"Why thank you kind sir or madame.  Your ship doesn't."} }
	statements[2] = {
		action="",
		player="Your ship appears very irregular.",
		alien={"Why thank you very much.  It is my own custom model transport freighter outfitted with afterburners and state-of-the-art weaponry just ready to slice and dice and even make julian fries."} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"Oh we believe you, believe me that we believe you."} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"I would wholeheartedly agree, as long as to exchange is kept in our direction."} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"How did you come up with a whopper like that one?"} }
		 



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"The Coalition was created because the Bar-zhon empire survives on slave labor, more the fools they are to provide us with constant recruits.  From the millions of Sabion, Bx, and Transmodra, a few escape to join us every day.  None of them possess the coordination and flying skills of those of us of the Bar-zhon race, but at least here they are treated right."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Ehh?  We know a bit concerning a few of the races in the sector.  Are you interested in the Tafel, the Nyssian, the Minex, the Bar-zhon, the Elowan, the Thrynn, or other pirates?"}
	}
	questions[30000] = {
		action="jump", goto=31001,
		player="What can you tell us about the past?",
		alien={"The past?  Go bother the Nyssian about the past.  Feel free to also pester the Bar-zhon, they tell a decently honest history story even though it's slanted their way a bit."}
	}
	questions[40000] = {
		action="jump", goto=41001,
		player="Tell us about the Ancients.",
		alien={"Fah!  I guess I could scoop the dirt on a few endurium planets." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Where is your home base?",  goto=51000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=1,
		player="Where is your home base?",
		alien={"Don't you be thinking that we'd be some simple dolts now, you hear?"}
	}
	
		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="Why do members of the Bar-zhon race rebel against them?",  goto=11000 },
			{ text="Who are the Sabion, Bx, and Transmodra?", goto=12000 },
			{ text="What can you tell us about your biology?", goto=13000 },
			{ text="What are your goals?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="Why do members of the Bar-zhon race rebel against them?",
		alien={"Because our fabulous government is a military dictatorship, and if you're not born into a family of noble birth, you are shuffled into the technician or worker caste and have no role in either the government or the military.  Our rebellion is as much from a desire to live in freedom as it is for anything else." }
	}
	questions[12000] = {
		action="jump", goto=12101,
		player="Who are the Sabion, Bx, and Transmodra?",
		alien={"Losers of the last great war.  Their three home worlds were razed and made entirely uninhabitable, but radiation levels have finally started to drop to the point where those with decent equipment can explore their planets without kneeling over instantly from Delta radiation." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="What can you tell us about your biology?",
		alien={"Kaak!  Go bother someone who cares!" }
	}
	questions[14000] = {
		action="jump", goto=14101,
		player="What are your goals?",
		alien={"To survive by blending into the Bar-Zhon empire as best possible.  Our military and technological capacities have grown much further than the Bar-Zhon suspect.  Oh I don't care if you are a Bar-Zhon infiltrator or sympathizer, they already disbelieve their own reports thinking us shortsighted revolutionaries and nothing else." }
	}
	questions[12101] = {
		action="branch",
		choices = {
			{ text="Where is the home world of the Sabion?",  goto=12110 },
			{ text="Where is the home world of the Bx?",  goto=12120 },
			{ text="Where is the home world of the Transmodra?",  goto=12130 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[12110] = {
		action="jump", goto=12101,
		player="Where is the home world of the Sabion?",
		alien={"Not so hasty grave robbers.  Don't expect to fool us with your platitudes either." }
	}
	questions[12120] = {
		action="jump", goto=12101,
		player="Where is the home world of the Bx?",
		alien={"The superb ground pounders.  None of their low level dueling abilities helped them in space. However don't be expecting us to assist grave robbers loot their world." }
	}
	questions[12130] = {
		action="jump", goto=12101,
		player="Where is the home world of the Transmodra?",
		alien={"The mighty industrialists, oh how they fell quickly to deception.  We will not be the ones opening their world to scavengers." }
	}
	
	questions[14101] = {
		action="branch",
		choices = {
			{ text="Why do you attack the Bar-zhon?",  goto=14110 },
			{ text="What are you if not revolutionaries?",  goto=14120 },
			{ text="Why don't you simply leave Bar-zhon space?",  goto=14130 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[14110] = {
		action="jump", goto=14101,
		player="Why do you attack the Bar-zhon?",
		alien={"Maintenance of the status quo.  If we stopped attacking they would get worried and to start to investigate.  If we declared all-out war there is no guarantee we would win.  Guerrilla attacks keep the mighty implacable and inflexible Bar-zhon Navy busy while we make progress elsewhere." }
	}
	questions[14120] = {
		action="jump", goto=14101,
		player="What are you if not revolutionaries?",
		alien={"<Sigh>   I told you already you slow alien.  We want to live in freedom, not die in war.  Beyond that our aims are our own." }
	}
	questions[14130] = {
		action="jump", goto=14101,
		player="Why don't you simply leave Bar-zhon space?",
		alien={"Commit a mass exodus of population under the noses of a hostile force?  Expose every single ship and resource we have to counterattack?  Simply ask to remove a slave population and see if the slave masters let them go willingly?  I assume you see the problems by now." }
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
		alien={"They are simple folk, yet quite dangerous in large numbers.  Fortunately a single Tafel ship has weak shields and paper thin armor.  They blow quite nicely." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="Tell us about the Nyssian.",
		alien={"Arrogant Nyssian wanderers travel alone in their weird organic vessels.  There vessels always travel alone and have very weak weaponry.  They make good target practice if you want to shoot something more difficult than a rock, but their ships are made up virtually no salvageable material, and they're strangely effective shields take quite a beating, and no one has ever salvaged or reverse engineered them." }
	}
	questions[24000] = {
		action="jump", goto=24100,
		player="Tell us about the Minex.",
		alien={"The Minex are too much trouble, yet some fool always tries to go after them to prove themselves.  The few that return often salvage amazing technologies and are highly respected.   Of course ones so daft are often raided themselves when they return, just in case they happened to have some amazing technologies." }
	}
	questions[24100] = {
		action="jump", goto=21002,
		player="<More>",
		alien={"If you try to tangle with those blokes, keep to your lasers.  Some blasted energy field diverts missile explosions away from them, making your missiles much less effective." }
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
		alien={"Never heard of them." }
	}
	questions[27000] = {
		action="jump", goto=21002,
		player="Tell us about other pirates.",
		alien={"General outlaws and pirates tend to inhabit the center of this sector, sort of where you guys came from.  Their equipment is patchy and badly worn, and they are not seriously a threat to anyone except the weakest merchant vessel." }
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
		alien={"Do I look like a blasted recruiter?  Go bother someone who cares." }
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
		alien={"I don't know or care.  Pester someone else."}
	}
	questions[42000] = {
		action="jump", goto=42001,
		player="Could you tell us where endurium can be found?",
		alien={"Try investigating Tafel space around Mag Rein1 - 101,15 or Aoi 4 - 167,16.  Bar-zhon space was stripmined long ago.  Strangely enough, endurium is never located below ground, but I guess the ancients wanted us to find them easily enough!"}
	}
	questions[42001] = {
		action="jump", goto=41001,
		player="<More>",
		alien={"Not that anyone has ever returned from there recently, but in the past there have been rumors that additional endurium rich planets can be found in the area of space past Thrynn territory."}
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
	
	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"The Coalition was created because the Bar-zhon empire survives on slave labor, more the fools they are to provide us with constant recruits.  From the millions of Sabion, Bx, and Transmodra, a few escape to join us every day.  None of them possess the coordination and flying skills of those of us of the Bar-zhon race, but at least here they are treated right."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Ehh?  We know a bit concerning a few of the races in the sector.  Are you interested in the Tafel, the Nyssian, the Minex, the Bar-zhon, the Elowan, the Thrynn, or other pirates?"}
	}
	questions[30000] = {
		action="jump", goto=31001,
		player="What can you tell us about the past?",
		alien={"The past?  Go bother the Nyssian about the past.  Feel free to also pester the Bar-zhon, they tell a decently honest history story even though it's slanted their way a bit."}
	}
	questions[40000] = {
		action="jump", goto=41001,
		player="Tell us about the Ancients.",
		alien={"Fah!  I guess I could scoop the dirt on a few endurium planets." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Where is your home base?",  goto=51000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=1,
		player="Where is your home base?",
		alien={"Don't you be thinking that we'd be some simple dolts now, you hear?"}
	}
	
		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="Why do members of the Bar-zhon race rebel against them?",  goto=11000 },
			{ text="Who are the Sabion, Bx, and Transmodra?", goto=12000 },
			{ text="What can you tell us about your biology?", goto=13000 },
			{ text="What are your goals?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="Why do members of the Bar-zhon race rebel against them?",
		alien={"Because our fabulous government is a military dictatorship, and if you're not born into a family of noble birth, you are shuffled into the technician or worker caste and have no role in either the government or the military.  Our rebellion is as much from a desire to live in freedom as it is for anything else." }
	}
	questions[12000] = {
		action="jump", goto=12101,
		player="Who are the Sabion, Bx, and Transmodra?",
		alien={"Losers of the last great war.  Their three home worlds were razed and made entirely uninhabitable, but radiation levels have finally started to drop to the point where those with decent equipment can explore their planets without kneeling over instantly from Delta radiation." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="What can you tell us about your biology?",
		alien={"Kaak!  Go bother someone who cares!" }
	}
	questions[14000] = {
		action="jump", goto=14101,
		player="What are your goals?",
		alien={"To survive by blending into the Bar-Zhon empire as best possible.  Our military and technological capacities have grown much further than the Bar-Zhon suspect.  Oh I don't care if you are a Bar-Zhon infiltrator or sympathizer, they already disbelieve their own reports thinking us shortsighted revolutionaries and nothing else." }
	}
	questions[12101] = {
		action="branch",
		choices = {
			{ text="Where is the home world of the Sabion?",  goto=12110 },
			{ text="Where is the home world of the Bx?",  goto=12120 },
			{ text="Where is the home world of the Transmodra?",  goto=12130 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[12110] = {
		action="jump", goto=12101,
		player="Where is the home world of the Sabion?",
		alien={"Not so hasty grave robbers.  Don't expect to fool us with your platitudes either." }
	}
	questions[12120] = {
		action="jump", goto=12101,
		player="Where is the home world of the Bx?",
		alien={"The superb ground pounders.  None of their low level dueling abilities helped them in space. However don't be expecting us to assist grave robbers loot their world." }
	}
	questions[12130] = {
		action="jump", goto=12101,
		player="Where is the home world of the Transmodra?",
		alien={"The mighty industrialists, oh how they fell quickly to deception.  We will not be the ones opening their world to scavengers." }
	}
	
	questions[14101] = {
		action="branch",
		choices = {
			{ text="Why do you attack the Bar-zhon?",  goto=14110 },
			{ text="What are you if not revolutionaries?",  goto=14120 },
			{ text="Why don't you simply leave Bar-zhon space?",  goto=14130 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[14110] = {
		action="jump", goto=14101,
		player="Why do you attack the Bar-zhon?",
		alien={"Maintenance of the status quo.  If we stopped attacking they would get worried and to start to investigate.  If we declared all-out war there is no guarantee we would win.  Guerrilla attacks keep the mighty implacable and inflexible Bar-zhon Navy busy while we make progress elsewhere." }
	}
	questions[14120] = {
		action="jump", goto=14101,
		player="What are you if not revolutionaries?",
		alien={"<Sigh>   I told you already you slow alien.  We want to live in freedom, not die in war.  Beyond that our aims are our own." }
	}
	questions[14130] = {
		action="jump", goto=14101,
		player="Why don't you simply leave Bar-zhon space?",
		alien={"Commit a mass exodus of population under the noses of a hostile force?  Expose every single ship and resource we have to counterattack?  Simply ask to remove a slave population and see if the slave masters let them go willingly?  I assume you see the problems by now." }
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
		alien={"They are simple folk, yet quite dangerous in large numbers.  Fortunately a single Tafel ship has weak shields and paper thin armor.  They blow quite nicely." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="Tell us about the Nyssian.",
		alien={"Arrogant Nyssian wanderers travel alone in their weird organic vessels.  There vessels always travel alone and have very weak weaponry.  They make good target practice if you want to shoot something more difficult than a rock, but their ships are made up virtually no salvageable material, and they're strangely effective shields take quite a beating, and no one has ever salvaged or reverse engineered them." }
	}
	questions[24000] = {
		action="jump", goto=24100,
		player="Tell us about the Minex.",
		alien={"The Minex are too much trouble, yet some fool always tries to go after them to prove themselves.  The few that return often salvage amazing technologies and are highly respected.   Of course ones so daft are often raided themselves when they return, just in case they happened to have some amazing technologies." }
	}
	questions[24100] = {
		action="jump", goto=21002,
		player="<More>",
		alien={"If you try to tangle with those blokes, keep to your lasers.  Some blasted energy field diverts missile explosions away from them, making your missiles much less effective." }
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
		alien={"Never heard of them." }
	}
	questions[27000] = {
		action="jump", goto=21002,
		player="Tell us about other pirates.",
		alien={"General outlaws and pirates tend to inhabit the center of this sector, sort of where you guys came from.  Their equipment is patchy and badly worn, and they are not seriously a threat to anyone except the weakest merchant vessel." }
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
		alien={"Do I look like a blasted recruiter?  Go bother someone who cares." }
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
		alien={"I don't know or care.  Pester someone else."}
	}
	questions[42000] = {
		action="jump", goto=42001,
		player="Could you tell us where endurium can be found?",
		alien={"Try investigating Tafel space around Mag Rein1 - 101,15 or Aoi 4 - 167,16.  Bar-zhon space was stripmined long ago.  Strangely enough, endurium is never located below ground, but I guess the ancients wanted us to find them easily enough!"}
	}
	questions[42001] = {
		action="jump", goto=41001,
		player="<More>",
		alien={"Not that anyone has ever returned from there recently, but in the past there have been rumors that additional endurium rich planets can be found in the area of space past Thrynn territory."}
	}
	
end

------------------------------------------------------------------------
-- SCRIPT INITIALIZATION -----------------------------------------------
------------------------------------------------------------------------
function Initialize()
    -- COMBAT VALUES FOR THIS ALIEN RACE
    health = 100                    -- 100=baseline minimum
    mass = 2                        -- 1=tiny, 10=huge
	engineclass = 6
	shieldclass = 3
	armorclass = 2
	laserclass = 4
	missileclass = 0
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 70			-- % of damage received, used for racial abilities, 0-100%

	
	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in
	--  20 Coalition Afterburner
	
	DROPITEM1 = 20;	    DROPRATE1 = 95;		DROPQTY1 = 1
	DROPITEM2 = 31;		DROPRATE2 = 0;	    DROPQTY2 = 4
	DROPITEM3 = 35;		DROPRATE3 = 25;		DROPQTY3 = 3
	DROPITEM4 = 38;		DROPRATE4 = 50;		DROPQTY4 = 3
	DROPITEM5 = 54;		DROPRATE5 = 80;		DROPQTY5 = 3

	--initialize dialog

	if player_profession == "military" and active_quest == 30 and artifact20 == 0 and player_money >= 5000 then
		first_question = 74000
	elseif player_profession == "scientific" and active_quest == 35 then
		first_question = 89000
	elseif player_profession == "freelance" and active_quest == 29 and artifact16 == 0 then
		first_question = 93000
	elseif player_profession == "freelance" and active_quest == 29 and artifact16 == 1 then
		first_question = 93500
	elseif player_profession == "freelance" and active_quest == 30 and artifact23 == 0 then
		first_question = 94000
	elseif player_profession == "freelance" and active_quest == 30 and artifact23 == 0 and artifact13 == 1 then
		first_question = 94500
	elseif player_profession == "freelance" and active_quest == 31 and artifact20 == 0 and player_money >= 5000 then
		first_question = 95000
	elseif player_profession == "freelance" and active_quest == 33 and artifact17 == 1 then
		first_question = 97000
	elseif player_profession == "freelance" and active_quest == 34 and artifact18 == 1 then
		first_question = 98000
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

	if player_profession == "military" and active_quest == 27 then
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




	questions[74000] = {
		action="jump", goto=74001,
		player="Coalition vessel.  This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have heard of your superlative propulsion technology and wish to acquire a sample for ourselves.  Would you be willing to part with a sample we can purchase?",
		alien={"I can smell an enforcer when I hear one.  Why should we deal with you and why should we give you our technology?" }
	}
	questions[74001] = {
		action="branch",
		choices = {
			{ text="We are prepared to pay well.  5000 M.U.'s  of resources.",  goto=74100 },
			{ text="We have no conflict with you.  4000 M.U.'s  and our gratitude.",  goto=74200 },
			{ text="If you do not agree to an exchange we will destroy you.",  goto=74300 },
			{ text="Nevermind, let me ask you about something else.", goto=1 }
		}
	}
	questions[74100] = {
		action="jump", goto=1,
		player="",
		alien={"We don't actually have any technologies like that.  Don't bother asking again." }
	}
	questions[74200] = {
		action="jump", goto=1,
		--player_money = player_money - 4000,
		--artifact20 = artifact20 + 1,
		player="",
		alien={"Okay, well maybe I could let you a little something.  You did not obtain this from me, you ran across this and salvaged it, okay? " }
	}
	questions[74300] = {
		action="attack",
		player="",
		alien={"Ha!  Good luck attempting that!  Let me give you a chance to try!" }
	}
	
	
	questions[89000] = {
		action="jump", goto=89001,
		player="This is Captain [CAPTAIN] of the starship [SHIPNAME].  Will you help us decode this fragmentary data showing the location of a planet possibly containing exotic particles?",
		alien={"What's in it for me?" }
	}
	questions[89001] = {
		action="jump", goto=1,
		player="Umm, the planet is rare, possibly unique, and likely to contain treasures.",
		alien={"Transmit the data now.  …  Wow this is really trashed.  The planet itself matches up descriptions of acidic planets but I cannot tell you anything else about its location.  " }
	}
	
		questions[93000] = {
		action="jump", goto=93001,
		player="Do you know anything about a Bar-zhon orb?",
		alien={"Now why would someone like me be aware of a fine artifact like that?" }
	}
	questions[93001] = {
		action="branch",
		choices = {
			{ text="We are friends, aren't we?",  goto=93100 },-- if attitude > 60 then 		goto=93100 	else 		goto=93101		endif },
			{ text="Maybe you could use some extra resources. (2500 M.U.)",  goto=93200 },
			{ text="You will tell me what you know immediately.",  goto=93300 },
			{ text="Forget this.  I'm not going to bother. ", goto=1 }
		}
	}
	questions[93100] = {
		action="jump", goto=1,
		player="",
		alien={"I wouldn't say as much as good friends, but I'd rather you look into this then I would rather have others, if you know what I mean.  One of our contacts ran across information about an unusual communication artifact that was stashed on a planet known as Lazerarp at the north pole of the planet.  Now if we knew what planet that was, we would obtain the device ourselves.  Unfortunately our sources have turned up nothing." }
	}
	questions[93101] = {
		action="terminate",
		player="",
		alien={"Get lost!" }
	}
	questions[93200] = {
		--player_money = player_money - 2500,
		action="jump", goto=1,
		player="",
			alien={"That is quite generous of you.  One of our contacts ran across information about an unusual communication artifact that was stashed on a planet known as Lazerarp at the north pole of the planet.  Now if we knew what planet that was, we would obtain the device ourselves.  Unfortunately our sources have turned up nothing." }
	}
	questions[93300] = {
		action="attack",
		player="",
		alien={"You think that I am worried about some sort of upstart such as yourself and your race?   I have principles and am not worried about your type.  Keep that in mind if you survive." }
	}


	questions[93500] = {
		action="jump", goto=93501,
		player="Can you tell us about… ",
		alien={"Our scanners indicate that you are carrying the whining orb.  If you are willing to sell this to me I am ready to transport 15,000 M.U. resources." }
	}
	questions[93501] = {
		action="branch",
		choices = {
			{ text="Yes, I'll sell it for 15,000 M.U..",  goto=93600 },
			{ text="No.",  goto=1 },
			{ text="Are you able to give us anything else for it?",  goto=93700 },
		}
	}
	questions[93600] = {
		artifact16 = 0,
		--player_money = player_money + 15000,
		--active_quest = active_quest + 1,
		action="jump", goto=1,
		player="",
		alien={"Very nice device this is.  Good doing business with you." }
	}
	questions[93700] = {
		artifact16 = 0,
		--ship_laser_class = ship_laser_class + 1,
		--active_quest = active_quest + 1,
		action="jump", goto=1,
		player="",
		alien={"I'm sending over my chief engineer to take a look at your weapon systems.  We might just find a way to upgrade your lasers in exchange for this device." }
	}

	
	
	questions[94000] = {
		action="jump", goto=94001,
		player="I hear that one of you possess a Minex silver gadget.",
		alien={"Very astute of your  people to discover this.  I take it you are interested in buying it?" }
	}
	questions[94001] = {
		action="jump", goto=94002,
		player="Yes.",
		alien={"It so happens that I have access to the artifact in question.  It is very advanced technology.  If you were to bring us the spiral lens device that the Thrynn are interested in I could be persuaded to make an exchange." }
	}
	questions[94002] = {
		action="branch",
		choices = {
			{ text="Would you take material resources, say like 5000 M.U.?",  goto=94100 },
			{ text="Where could I find the spiral lens?",  goto=94200 },
			{ text="I already turned over the lens to the Thrynn.",  goto=94300 },
			{ text="Let me ask about something else for now.", goto=1 }
		}
	}
	questions[94100] = {
		action="jump", goto=94002,
		player="",
		alien={"Such minor amounts of resources are not worth bothering with.  Bring us this technology or forget it all together." }
	}
	questions[94200] = {
		action="jump", goto=94002,
		player="",
			alien={"Ask the Thrynn.  We heard rumors that they tracked down its location but have not bothered to get it themselves foolishly enough." }
	}
	questions[94300] = {
		action="jump", goto=94002,
		player="",
		alien={"If this is true then you can obtain your own Minex technology the hard way. " }
	}



	questions[94500] = {
		artifact23 = 1,
		artifact13 = 0,
		action="jump", goto=1,
		player="I have a spiral lens in exchange for a Minex silver gadget.",
		alien={"I am transporting the Minex silver gadget in exchange." }
	}

	questions[95000] = {
		action="jump", goto=95001,
		player="Would it be possible to purchase one of your afterburners?",
		alien={"You would want us to give up our great new technological advantage?  This new technology is secret and proprietary.  I could never turn it over to an alien like yourself." }
	}
	questions[95001] = {
		action="branch",
		choices = {
			{ text="Turn over a sample or you're not going to survive.",  goto=95100 },
			{ text="4000 M.U. for your afterburner.",  goto=95200 },
			{ text="Understood, we never meet.  I've got 5000 M.U.",  goto=95300 },
			{ text="Nevermind, let me ask you about something else.", goto=1 }
		}
	}
	questions[95100] = {
		action="attack",
		player="",
		alien={"Not likely.  Let me demonstrate its capacities for you." }
	}

	questions[95200] = {
		action="jump", goto=1,
		player="",
		alien={"I'm sorry, I can't hear you.  If I did hear you, it sounded like you were trying to purchase restricted technology, which I am not allowed to do." }
	}

		
	questions[95300] = {
		action="jump", goto=95301,
		--player_money = player_money - 5000,
		player="",
		alien={"Thanks for your contribution to our war fund.  Most generous of you." }
	}
	questions[95301] = {
		action="jump", goto=1,
		--artifact20 = artifact20 + 1,
		player="Hey, can't you send us a few spare parts.  We seem to be having engine problems here.",
		alien={"Of course.  Always happy to assist generous friends.  Transporting some extra components to you now. " }
	}

	
	
	questions[97000] = {
		action="jump", goto=97001,
		player="Can you tell us about… ",
		alien={" I'm detecting that you have on board an erratic energy device.  Would you be interested in selling it?" }
	}
	questions[97001] = {
		action="branch",
		choices = {
			{ text="I'll sell it for 40,000 M.U.",  goto=97100 }, --	if attitude > 60 then 	goto=97100		else 		goto=97101
			{ text="Could you enhance our ships defensive technology?",  goto=97200 },
			{ text="Could you enhance our ships offensive technology?",  goto=97300 },
			{ text="No, our scientists want this device themselves. ", goto=1 }
		}
	}
	questions[97100] = {
		artifact17 = 0,
		--player_money = player_money + 40000,
		--active_quest = active_quest + 1,
		action="terminate",
		player="",
		alien={"Deal!  You realize that ..umm.. nevermind, I have some urgent business elsewhere." }
	}
	questions[97101] = {
		action="terminate",
		player="",
		alien={"Get lost!" }
	}
	questions[97200] = {
		artifact17 = 0, 
		--ship_shield_class = ship_shield_class + 1,
		--active_quest = active_quest + 1,
		action="terminate",
		player="",
		alien={"Deal!  I'm transmitting data on our latest shielding enhancements.  Your engineer should be able to make use of this data. You realize that ..umm.. nevermind, I have some urgent business elsewhere." }
	}
	questions[97300] = {
		artifact17 = 0, 
		--ship_laser_class = ship_laser_class + 1,
		--active_quest = active_quest + 1,
		action="terminate",
		player="",
		alien={"Deal!  I'm transmitting data on our latest shielding enhancements.  Your engineer should be able to make use of this data. You realize that ..umm.. nevermind, I have some urgent business elsewhere." }
	}
	questions[97700] = {
		artifact16 = 0,
		--ship_laser_class = ship_laser_class + 1,
		--active_quest = active_quest + 1,
		action="jump", goto=1,
		player="",
		alien={"I'm sending over my chief engineer to take a look at your weapon systems.  We might just find a way to upgrade your lasers in exchange for this device." }
	}
	questions[98000] = {
		action="jump", goto=1,
		player="Would you be interested in purchasing incredibly old artistic containers?",
		alien={"I can't really say that I would be interested in spending resources on worthless pottery." }
	}

	questions[500] = {
		action="jump", goto=501,
		player="Can you tell me about...",
		alien={"Hey mate!  You ran across a Thrynn Battle Machine?  I'll buy any you have for 4500 M.U. Myrrdan resources each." }
	}
	questions[501] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=510 },
			{ text="No.",  goto=520 },
		}
	}
	questions[510] = {
		--player_money = player_money + artifact14 * 4500,
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

