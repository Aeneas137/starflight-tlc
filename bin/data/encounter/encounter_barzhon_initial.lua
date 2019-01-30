--[[
	ENCOUNTER SCRIPT FILE: BARZHON INITIAL

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
		alien={"We are Bar-zhon.  Please stop this foolish demeaning of yourself.","We are Bar-zhon.  I would formally request that conventional attitudes be taken."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"We Bar-zhon are civilized and not prone to precipitous action."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"We are Bar-zhon.  Please stop this foolish demeaning of yourself.","We are Bar-zhon.  I would formally request that conventional attitudes be taken."} 	}
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"We are Bar-zhon.  Please stop this foolish demeaning of yourself.","We are Bar-zhon.  I would formally request that conventional attitudes be taken."} 	}
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"We are Bar-zhon.  Please stop this foolish demeaning of yourself.","We are Bar-zhon.  I would formally request that conventional attitudes be taken."} 	}

		
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"Please stop this foolish demeaning of yourself, there is no point to it."} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien={"Please stop this foolish demeaning of yourself, there is no point to it."} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"Foolish perceptions are the result of immature or distorted minds."} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"Foolish perceptions are the result of immature or distorted minds."} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"Please stop this foolish demeaning of yourself, there is no point to it."} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"Please stop this foolish demeaning of yourself, there is no point to it."} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"Foolish perceptions are the result of immature or distorted minds."} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"Please stop this foolish demeaning of yourself, there is no point to it."} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"Foolish perceptions are the result of immature or distorted minds."} }

		
	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"The Bar-zhon people and our Navy are matched by none other.  Many other races inhabit this area of space but none come close to our strength and power.  Well, maybe only the Minex come close to our strength."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Please be more specific.  Are you interested in the rabble known as the coalition?  Or the other races, the Tafel, the Nyssian, the Minex, the Thrynn and Elowan, or the Spemin?  Or Do you want to know about other pirates?"}
	}
	questions[30000] = {
		action="jump", goto=31001,
		player="What can you tell us about the past?",
		alien={"A few centicycles ago, in your own system of time about 1500 years ago, this entire region of space was enveloped by sector wide warfare known to historians as The Great War.   It is a lengthy story, are you sure you want to hear it?"}
	}
	questions[40000] = {
		action="jump", goto=1,
		player="Tell us about the Ancients.",
		alien={"The ancients traveled through this area of space several millennia ago, leaving strange uniformly shaped ruins and endurium crystals for whatever reason at the time.  Seek out some Nyssian story monger if you wish to learn more about them." }
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
		action="jump", goto=50000,
		player="We are interested in becoming allies of your great empire.  Where are your leaders?",
		alien={"The benefits of citizenship to the player in the great Bar-zhon empire cannot be counted.  Please visit our primary naval station at Midir V - 201,105."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="Where is your home world?",
		alien={"Our primary naval station at Midir V - 201,105."}
	}
	
		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your empire?",  goto=11000 },
			{ text="What can you tell us about your biology?", goto=12000 },
			{ text="What system of government do you have?", goto=13000 },
			{ text="What does your people offer for trade?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="What can you tell us about your empire?",
		alien={"Our territory is vast and our industrial and military might unmatched by all.  Freedom and justice prevail throughout the system of industrialized planets and their colonies, for no planet is taken advantage of or unfairly taxed by another." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="What can you tell us about your biology?",
		alien={"Our biology is our concern and no interest of yours." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="What system of government do you have?",
		alien={"A centralized imperium, however in practice our government operates as a coordinated federation.  The cohesiveness we share is not a matter of taxation or enslavement by the multitude of worlds united by a similar cultural system." }
	}
	questions[14000] = {
		action="jump", goto=14101,
		player="What does your people offer for trade?",
		alien={"Our people have a strict noninterference policy towards less developed races such as yourselves.  Your world was discovered and has been shielded by our fleet until which time you developed space flight.  The unexpectedly advanced technology and weaponry your ship possesses must be analyzed." }
	}
	
	questions[14101] = {
		action="branch",
		choices = {
			{ text="Are you saying that your race will not trade with us?",  goto=14110 },
			{ text="Less developed?  I'll show you how less-developed we are!",  goto=14120 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[14110] = {
		action="jump", goto=14101,
		player="Are you saying that your race will not trade with us?",
		alien={"Of course we will, but first your species must be categorized properly and trade goods which will not be unnecessarily disruptive to your species must be found." }
	}
	questions[14120] = {
		action="jump", goto=14121,
		player="Less developed?  I'll show you how less-developed we are.",
		alien={"Terrorist threats will not be tolerated.  Force must be met with force." }
	}
	questions[14121] = {
		action="attack",
		player="Less developed?  I'll show you how less-developed we are.",
		alien={"Terrorist threats will not be tolerated.  Force must be met with force." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Coalition.",  goto=21000 },
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
		action="jump", goto=21100,
		player="Tell us about the Coalition.",
		alien={"We must warn you about an annoyance you may find in our area of space.  Currently our empire is experiencing minor guerrilla warfare from a minor faction of malcontents, self-titled 'The Coalition.'" }
	}
	questions[21100] = {
		action="jump", goto=21001,
		player="<More>",
		alien={"The rebels are a group of malcontents and pirates which hide inside our vast territory.  Utilizing and rebuilding many of the scrapped mining equipment and shipyards of the three imperialists they pose a constant but minimal threat to the law-abiding sentients of this sector." }
	}
	questions[22000] = {
		action="jump", goto=22100,
		player="Tell us about the Tafel.",
		alien={"The Tafel are a disgustingly primitive group of collectivists.  Their primitive and emotional culture has a penchant for extreme shifts which makes them untrustworthy. The sole redeeming value is their incredible mining ability." }
	}
	questions[22100] = {
		action="jump", goto=21001,
		player="<More>",
		alien={"We trade the Tafel antiquated trinkets and junk for vast amounts of radioactive wastes and other trinkets.  They are a prolific and insidious species which one day may become dangerous.  We suggest you treat them warily as we do." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="Tell us about the Nyssian.",
		alien={"The Nyssian are a harmless nomadic and secretive people who number in the low thousands.  Their technologies are antiquated, their people weak willed and divided, and their wisdom fractured and contradictory.  Do not bother with them." }
	}
	questions[24000] = {
		action="jump", goto=24100,
		player="Tell us about the Minex.",
		alien={"Minex culture is an enigma.  They do not travel and have never expanded their territory.  Encroaching on space yields fierce opposition, yet they hold no apparent hostility." }
	}
	questions[24100] = {
		action="jump", goto=21002,
		player="<More>",
		alien={"As far as we can determine, the Minex culture has been static and unchanging since our earliest days of space travel.  From what are a few successful probes have shown their populations and fleets are vast." }
	}
	questions[25000] = {
		action="jump", goto=21002,
		player="Tell us about the Thrynn and Elowan.",
		alien={"The Thrynn and Elowan savages are both barely sentient warmongers with no industrial base to speak of.  Their frail industries barely support their tattered ships.  One day if an empire decided to conquer them, they would discover how similar they actually are to each other." }
	}
	questions[26000] = {
		action="jump", goto=21002,
		player="Tell us about the Spemin.",
		alien={"The Spemin blobs are innocent and truly nonsentient organisms which only mimic communication, technology and behavior.  They rely on insane breeding rates and Darwinism to kill off the non-effective.  They truly cannot think for themselves, so don't bother with them." }
	}
	questions[27000] = {
		action="jump", goto=21002,
		player="Tell us about other pirates.",
		alien={"Various pirate clans composed of members from all the alien species occasionally traverses the unpatrolled areas of space.  Don't take it personally if an alien ship simply decides to attack you.  It's likely not affiliated with the hierarchy of its species." }
	}

	questions[21101] = {
		action="branch",
		choices = {
			{ text="How are they able to hide inside your territory?",  goto=21100 },
			{ text="Where are they located?",  goto=21200 },
			{ text="How dangerous is the coalition?",  goto=21300 },
			{ text="So members of the Bar-zhon people make up the coalition?",  goto=21400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[21100] = {
		action="jump", goto=21101,
		player="How are they able to hide inside your territory?",
		alien={"Only with constant espionage to keep up with our technological advances and through careful random and emissionless construction.  Silhouettes of their ships and structures are extremely erratic and disguised as asteroids or floating debris." }
	}
	questions[21200] = {
		action="jump", goto=21201,
		player="Where are they located?",
		alien={"They primarily roaming platforms and ships in asteroid fields or a large asteroids, making them very difficult to find and eliminate.  Many attempts have been made to wipe them out but have only served to cull their numbers." }
	}
	questions[21201] = {
		action="jump", goto=21101,
		player="Surely sensors can detect life or energy signatures?",
		alien={"Life signs can be masked with sufficient shielding.  Energy signatures can be hidden as long as no propulsion is used.  Efforts to dragnet sectors are discovered and patrols avoided.  Simple communication signals can be undetectably embedded inside our own communication network." }
	}
	questions[21300] = {
		action="jump", goto=21101,
		player="How dangerous is the coalition?",
		alien={"The coalition is not a true threat to us, only an annoyance.  They are wise enough to avoid clashes with our military, but we tell you about them since they often seek out and attack individual vessels, especially newcomers to this area." }
	}
	questions[21400] = {
		action="jump", goto=21101,
		player="So members of the Bar-zhon people make up the coalition?",
		alien={"Only malcontents from the worker caste working with technicians of the alien cultures in our populations.  This pattern of rebellion has occurred before.  Unfortunately it is impossible to keep determined individuals earthbound, and this pirating culture has formed." }
	}

	questions[31001] = {
		action="branch",
		choices = {
		
			{ text="Which races were involved in this Great War?",  goto=31002 },
			{ text="Yes, tell me the full story of The Great War.",  goto=31003 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[31002] = {
		action="jump", goto=31101,
		player="Which races were involved in this Great War?",
		alien={"The Great War involved a conflict between four of the five major powers in the region.  Ourselves, the Minex, the Transmodra, the Sabion, and the Bx.  The last three races were known collectively as the Three Imperialists." }
	}
	questions[31003] = {
		action="jump", goto=31004,
		player="Yes, tell me the full story of The Great War.",
		alien={"The Transmodra formed the backbone of the imperialist alliance against us and the most terrible atrocities did they commit.  Biological warfare was their specialty.  Over a dozen Bar-zhon worlds did they extinguish before our people could fully mobilize." }
	}
	questions[31004] = {
		action="jump", goto=31005,
		player="<More>",
		alien={"The elite corps of the Bar-zhon Navy was created, replacing the old Guardian Corp. the noblest families in the finest tradition of our history have been trained since birth to glide and fight in the starry skies." }
	}
	questions[31005] = {
		action="jump", goto=31006,
		player="<More>",
		alien={"The workers party was thrown down from office and control of our glorious empire given back to its rightful heirs.  The temporary slave camps and razing of the useless extravagances of the past were fully necessary and saved countless lives despite the minor cultural turmoil they caused." }
	}
	questions[31006] = {
		action="jump", goto=31007,
		player="<More>",
		alien={"Within five years the Bar-zhon held their own and completely halted the imperialists advance.  A holding force was maintained while our people secretly built a tremendous fleet." }
	}
	questions[31007] = {
		action="jump", goto=31008,
		player="<More>",
		alien={"After a particularly powerful wave was repelled, our people took a desperate gamble.  The entire defensive fleet was consolidated with the secret fleet and sent at flank speed to the Transmodra home world." }
	}
	questions[31008] = {
		action="jump", goto=31009,
		player="<More>",
		alien={"After overwhelming defensive forces, mass drivers razed all population and industrial centers.  Mop up operations took little effort and the entire Transmodra industrial machine was quickly under Bar-zhon control." }
	}
	questions[31009] = {
		action="jump", goto=31010,
		player="<More>",
		alien={"This maneuver split the Sabion and the Bx forces in half and effectively won the tactical war.  Unfortunately the Sabion and the Bx refused to surrender." }
	}
	questions[31010] = {
		action="jump", goto=31011,
		player="<More>",
		alien={"The two remaining races maintained unprovoked hit-and-run attacks for an additional two years before their home worlds were overrun and industrial forces stopped." }
	}
	questions[31011] = {
		action="jump", goto=31012,
		player="<More>",
		alien={"Unwilling to let these races ever become a threat again, the entire populations of the three industrialists were relocated onto Bar-zhon colony worlds, where they continue to thrive to this day." }
	}
	questions[31012] = {
		action="jump", goto=31013,
		player="<More>",
		alien={"Control of our government has remained firmly in the claws of the Imperial Navy, and we have successfully prevented any catastrophic mistakes from ever threatening our people again." }
	}
	questions[31013] = {
		action="jump", goto=31001,
		player="The aftermath of the war has something to do with The Coalition, right?",
		alien={"An insightful question indeed, and it is true.  The worker caste working with technicians of the alien cultures in our populations at several times in our  recent history attempted to form rebellions which always failed miserably.  The coalition is their latest attempt." }
	}
	questions[31101] = {
		action="branch",
		choices = {
			{ text="What do you mean about only four of the five powers?",  goto=31100 },
			{ text="What started off the war?",  goto=31200 },
			{ text="What about the other races now in this sector, where were they?",  goto=31300 },
			{ text="So your people defeated a coalition of races allied against you?",  goto=31400 },
			{ text="<Back>", goto=31001 }
		}
	}
	questions[31100] = {
		action="jump", goto=31102,
		player="What do you mean about only four of the five powers?",
		alien={"The Minex remained neutral throughout the conflict, neither worrying nor caring of the consequences to their own empire if we lost.  We discovered later that they repulsed several skirmishes into their territory but only fought defensively." }
	}
	questions[31102] = {
		action="jump", goto=31101,
		player="What about the Nyssian?  Aren't they an ancient race?",
		alien={"Ha!  Ancient, maybe.  Relevant, no.  Those so-called anti-materialists strip mined their world and polluted it to the point that only a few escaped the devastation.  Their lifespan and their race are only maintained through cryogenic stasis." }
	}
	questions[31200] = {
		action="jump", goto=31101,
		player="What started off the war?",
		alien={"In the ancient past our sphere of influence was far less and much greater challenges were our people faced with.  A coalition of three upstart imperialists decided, completely unprovoked, to expand their territory directly into our area space." }
	}
	questions[31300] = {
		action="jump", goto=31101,
		player="What about the other races now in this sector, where were they?",
		alien={"Your people had yet to develop space flight.  The Tafel were also still mucking around scratching dirt on their lava world.  The Spemin?  Weaponless incomprehensible savages.  The Thrynn and the Elowan did not show up on the scene until later." }
	}
	questions[31400] = {
		action="jump", goto=31101,
		player="So your people defeated a coalition of races allied against you?",
		alien={"Yes, the Bar-zhon people met this challenge unwaveringly and without hesitance.  Only we accepted the challenge of defending the liberty of the sector.  Great and heroic our countrymen acted in those days.  Glorious were our many victories." }
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
		alien={"Greetings representative from Myrrdan.  This patrol vessel is a representative of the Bar-Zhon Imperial Navy.","This is the Imperial Bar-Zhon starship.  Welcome.","Alien craft, you have encountered the Barzhon."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Greetings representative from Myrrdan.  This patrol vessel is a representative of the Bar-Zhon Imperial Navy.","This is the Imperial Bar-Zhon starship.  Welcome.","Alien craft, you have encountered the Barzhon."} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Greetings representative from Myrrdan.  This patrol vessel is a representative of the Bar-Zhon Imperial Navy.","This is the Imperial Bar-Zhon starship.  Welcome.","Alien craft, you have encountered the Barzhon."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"We reservedly accept your complement."} }
	statements[2] = {
		action="",
		player="Your ship appears very elaborate.  Do all those protrusions have some purpose?",
		alien={"Indeed the purpose of this vessel is the protection of our empire."} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"We also extend greetings and the wish for peaceful relations from the Bar-Zhon peoples."} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"We completely agree."} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"A ridiculous notion, but we return similar sentiments."} }
		 



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"The Bar-zhon people and our Navy are matched by none other.  Many other races inhabit this area of space but none come close to our strength and power.  Well, maybe only the Minex come close to our strength."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Please be more specific.  Are you interested in the rabble known as the coalition?  Or the other races, the Tafel, the Nyssian, the Minex, the Thrynn and Elowan, or the Spemin?  Or Do you want to know about other pirates?"}
	}
	questions[30000] = {
		action="jump", goto=31001,
		player="What can you tell us about the past?",
		alien={"A few centicycles ago, in your own system of time about 1500 years ago, this entire region of space was enveloped by sector wide warfare known to historians as The Great War.   It is a lengthy story, are you sure you want to hear it?"}
	}
	questions[40000] = {
		action="jump", goto=1,
		player="Tell us about the Ancients.",
		alien={"The ancients traveled through this area of space several millennia ago, leaving strange uniformly shaped ruins and endurium crystals for whatever reason at the time.  Seek out some Nyssian story monger if you wish to learn more about them." }
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
		action="jump", goto=50000,
		player="We are interested in becoming allies of your great empire.  Where are your leaders?",
		alien={"The benefits of citizenship to the player in the great Bar-zhon empire cannot be counted.  Please visit our primary naval station at Midir V - 201,105."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="Where is your home world?",
		alien={"Our primary naval station at Midir V - 201,105."}
	}
	
		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your empire?",  goto=11000 },
			{ text="What can you tell us about your biology?", goto=12000 },
			{ text="What system of government do you have?", goto=13000 },
			{ text="What does your people offer for trade?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="What can you tell us about your empire?",
		alien={"Our territory is vast and our industrial and military might unmatched by all.  Freedom and justice prevail throughout the system of industrialized planets and their colonies, for no planet is taken advantage of or unfairly taxed by another." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="What can you tell us about your biology?",
		alien={"Our biology is our concern and no interest of yours." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="What system of government do you have?",
		alien={"A centralized imperium, however in practice our government operates as a coordinated federation.  The cohesiveness we share is not a matter of taxation or enslavement by the multitude of worlds united by a similar cultural system." }
	}
	questions[14000] = {
		action="jump", goto=14101,
		player="What does your people offer for trade?",
		alien={"Our people have a strict noninterference policy towards less developed races such as yourselves.  Your world was discovered and has been shielded by our fleet until which time you developed space flight.  The unexpectedly advanced technology and weaponry your ship possesses must be analyzed." }
	}
	
	questions[14101] = {
		action="branch",
		choices = {
			{ text="Are you saying that your race will not trade with us?",  goto=14110 },
			{ text="Less developed?  I'll show you how less-developed we are!",  goto=14120 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[14110] = {
		action="jump", goto=14101,
		player="Are you saying that your race will not trade with us?",
		alien={"Of course we will, but first your species must be categorized properly and trade goods which will not be unnecessarily disruptive to your species must be found." }
	}
	questions[14120] = {
		action="jump", goto=14121,
		player="Less developed?  I'll show you how less-developed we are.",
		alien={"Terrorist threats will not be tolerated.  Force must be met with force." }
	}
	questions[14121] = {
		action="attack",
		player="Less developed?  I'll show you how less-developed we are.",
		alien={"Terrorist threats will not be tolerated.  Force must be met with force." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Coalition.",  goto=21000 },
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
		action="jump", goto=21100,
		player="Tell us about the Coalition.",
		alien={"We must warn you about an annoyance you may find in our area of space.  Currently our empire is experiencing minor guerrilla warfare from a minor faction of malcontents, self-titled 'The Coalition.'" }
	}
	questions[21100] = {
		action="jump", goto=21001,
		player="<More>",
		alien={"The rebels are a group of malcontents and pirates which hide inside our vast territory.  Utilizing and rebuilding many of the scrapped mining equipment and shipyards of the three imperialists they pose a constant but minimal threat to the law-abiding sentients of this sector." }
	}
	questions[22000] = {
		action="jump", goto=22100,
		player="Tell us about the Tafel.",
		alien={"The Tafel are a disgustingly primitive group of collectivists.  Their primitive and emotional culture has a penchant for extreme shifts which makes them untrustworthy. The sole redeeming value is their incredible mining ability." }
	}
	questions[22100] = {
		action="jump", goto=21001,
		player="<More>",
		alien={"We trade the Tafel antiquated trinkets and junk for vast amounts of radioactive wastes and other trinkets.  They are a prolific and insidious species which one day may become dangerous.  We suggest you treat them warily as we do." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="Tell us about the Nyssian.",
		alien={"The Nyssian are a harmless nomadic and secretive people who number in the low thousands.  Their technologies are antiquated, their people weak willed and divided, and their wisdom fractured and contradictory.  Do not bother with them." }
	}
	questions[24000] = {
		action="jump", goto=24100,
		player="Tell us about the Minex.",
		alien={"Minex culture is an enigma.  They do not travel and have never expanded their territory.  Encroaching on space yields fierce opposition, yet they hold no apparent hostility." }
	}
	questions[24100] = {
		action="jump", goto=21002,
		player="<More>",
		alien={"As far as we can determine, the Minex culture has been static and unchanging since our earliest days of space travel.  From what are a few successful probes have shown their populations and fleets are vast." }
	}
	questions[25000] = {
		action="jump", goto=21002,
		player="Tell us about the Thrynn and Elowan.",
		alien={"The Thrynn and Elowan savages are both barely sentient warmongers with no industrial base to speak of.  Their frail industries barely support their tattered ships.  One day if an empire decided to conquer them, they would discover how similar they actually are to each other." }
	}
	questions[26000] = {
		action="jump", goto=21002,
		player="Tell us about the Spemin.",
		alien={"The Spemin blobs are innocent and truly nonsentient organisms which only mimic communication, technology and behavior.  They rely on insane breeding rates and Darwinism to kill off the non-effective.  They truly cannot think for themselves, so don't bother with them." }
	}
	questions[27000] = {
		action="jump", goto=21002,
		player="Tell us about other pirates.",
		alien={"Various pirate clans composed of members from all the alien species occasionally traverses the unpatrolled areas of space.  Don't take it personally if an alien ship simply decides to attack you.  It's likely not affiliated with the hierarchy of its species." }
	}

	questions[21101] = {
		action="branch",
		choices = {
			{ text="How are they able to hide inside your territory?",  goto=21100 },
			{ text="Where are they located?",  goto=21200 },
			{ text="How dangerous is the coalition?",  goto=21300 },
			{ text="So members of the Bar-zhon people make up the coalition?",  goto=21400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[21100] = {
		action="jump", goto=21101,
		player="How are they able to hide inside your territory?",
		alien={"Only with constant espionage to keep up with our technological advances and through careful random and emissionless construction.  Silhouettes of their ships and structures are extremely erratic and disguised as asteroids or floating debris." }
	}
	questions[21200] = {
		action="jump", goto=21201,
		player="Where are they located?",
		alien={"They primarily roaming platforms and ships in asteroid fields or a large asteroids, making them very difficult to find and eliminate.  Many attempts have been made to wipe them out but have only served to cull their numbers." }
	}
	questions[21201] = {
		action="jump", goto=21101,
		player="Surely sensors can detect life or energy signatures?",
		alien={"Life signs can be masked with sufficient shielding.  Energy signatures can be hidden as long as no propulsion is used.  Efforts to dragnet sectors are discovered and patrols avoided.  Simple communication signals can be undetectably embedded inside our own communication network." }
	}
	questions[21300] = {
		action="jump", goto=21101,
		player="How dangerous is the coalition?",
		alien={"The coalition is not a true threat to us, only an annoyance.  They are wise enough to avoid clashes with our military, but we tell you about them since they often seek out and attack individual vessels, especially newcomers to this area." }
	}
	questions[21400] = {
		action="jump", goto=21101,
		player="So members of the Bar-zhon people make up the coalition?",
		alien={"Only malcontents from the worker caste working with technicians of the alien cultures in our populations.  This pattern of rebellion has occurred before.  Unfortunately it is impossible to keep determined individuals earthbound, and this pirating culture has formed." }
	}

	questions[31001] = {
		action="branch",
		choices = {
		
			{ text="Which races were involved in this Great War?",  goto=31002 },
			{ text="Yes, tell me the full story of The Great War.",  goto=31003 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[31002] = {
		action="jump", goto=31101,
		player="Which races were involved in this Great War?",
		alien={"The Great War involved a conflict between four of the five major powers in the region.  Ourselves, the Minex, the Transmodra, the Sabion, and the Bx.  The last three races were known collectively as the Three Imperialists." }
	}
	questions[31003] = {
		action="jump", goto=31004,
		player="Yes, tell me the full story of The Great War.",
		alien={"The Transmodra formed the backbone of the imperialist alliance against us and the most terrible atrocities did they commit.  Biological warfare was their specialty.  Over a dozen Bar-zhon worlds did they extinguish before our people could fully mobilize." }
	}
	questions[31004] = {
		action="jump", goto=31005,
		player="<More>",
		alien={"The elite corps of the Bar-zhon Navy was created, replacing the old Guardian Corp. the noblest families in the finest tradition of our history have been trained since birth to glide and fight in the starry skies." }
	}
	questions[31005] = {
		action="jump", goto=31006,
		player="<More>",
		alien={"The workers party was thrown down from office and control of our glorious empire given back to its rightful heirs.  The temporary slave camps and razing of the useless extravagances of the past were fully necessary and saved countless lives despite the minor cultural turmoil they caused." }
	}
	questions[31006] = {
		action="jump", goto=31007,
		player="<More>",
		alien={"Within five years the Bar-zhon held their own and completely halted the imperialists advance.  A holding force was maintained while our people secretly built a tremendous fleet." }
	}
	questions[31007] = {
		action="jump", goto=31008,
		player="<More>",
		alien={"After a particularly powerful wave was repelled, our people took a desperate gamble.  The entire defensive fleet was consolidated with the secret fleet and sent at flank speed to the Transmodra home world." }
	}
	questions[31008] = {
		action="jump", goto=31009,
		player="<More>",
		alien={"After overwhelming defensive forces, mass drivers razed all population and industrial centers.  Mop up operations took little effort and the entire Transmodra industrial machine was quickly under Bar-zhon control." }
	}
	questions[31009] = {
		action="jump", goto=31010,
		player="<More>",
		alien={"This maneuver split the Sabion and the Bx forces in half and effectively won the tactical war.  Unfortunately the Sabion and the Bx refused to surrender." }
	}
	questions[31010] = {
		action="jump", goto=31011,
		player="<More>",
		alien={"The two remaining races maintained unprovoked hit-and-run attacks for an additional two years before their home worlds were overrun and industrial forces stopped." }
	}
	questions[31011] = {
		action="jump", goto=31012,
		player="<More>",
		alien={"Unwilling to let these races ever become a threat again, the entire populations of the three industrialists were relocated onto Bar-zhon colony worlds, where they continue to thrive to this day." }
	}
	questions[31012] = {
		action="jump", goto=31013,
		player="<More>",
		alien={"Control of our government has remained firmly in the claws of the Imperial Navy, and we have successfully prevented any catastrophic mistakes from ever threatening our people again." }
	}
	questions[31013] = {
		action="jump", goto=31001,
		player="The aftermath of the war has something to do with The Coalition, right?",
		alien={"An insightful question indeed, and it is true.  The worker caste working with technicians of the alien cultures in our populations at several times in our  recent history attempted to form rebellions which always failed miserably.  The coalition is their latest attempt." }
	}
	questions[31101] = {
		action="branch",
		choices = {
			{ text="What do you mean about only four of the five powers?",  goto=31100 },
			{ text="What started off the war?",  goto=31200 },
			{ text="What about the other races now in this sector, where were they?",  goto=31300 },
			{ text="So your people defeated a coalition of races allied against you?",  goto=31400 },
			{ text="<Back>", goto=31001 }
		}
	}
	questions[31100] = {
		action="jump", goto=31102,
		player="What do you mean about only four of the five powers?",
		alien={"The Minex remained neutral throughout the conflict, neither worrying nor caring of the consequences to their own empire if we lost.  We discovered later that they repulsed several skirmishes into their territory but only fought defensively." }
	}
	questions[31102] = {
		action="jump", goto=31101,
		player="What about the Nyssian?  Aren't they an ancient race?",
		alien={"Ha!  Ancient, maybe.  Relevant, no.  Those so-called anti-materialists strip mined their world and polluted it to the point that only a few escaped the devastation.  Their lifespan and their race are only maintained through cryogenic stasis." }
	}
	questions[31200] = {
		action="jump", goto=31101,
		player="What started off the war?",
		alien={"In the ancient past our sphere of influence was far less and much greater challenges were our people faced with.  A coalition of three upstart imperialists decided, completely unprovoked, to expand their territory directly into our area space." }
	}
	questions[31300] = {
		action="jump", goto=31101,
		player="What about the other races now in this sector, where were they?",
		alien={"Your people had yet to develop space flight.  The Tafel were also still mucking around scratching dirt on their lava world.  The Spemin?  Weaponless incomprehensible savages.  The Thrynn and the Elowan did not show up on the scene until later." }
	}
	questions[31400] = {
		action="jump", goto=31101,
		player="So your people defeated a coalition of races allied against you?",
		alien={"Yes, the Bar-zhon people met this challenge unwaveringly and without hesitance.  Only we accepted the challenge of defending the liberty of the sector.  Great and heroic our countrymen acted in those days.  Glorious were our many victories." }
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
		alien={"Bar-Zhon patrol vessel engaging hostile pirate."} }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"Bar-Zhon Naval ships do not respond to threats.  You are given warning."}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"This a heavily armed patrol vessel of the Bar-Zhon Imperial Navy."} }
	greetings[4] = {
		action="",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"Threats are taken very seriously by the Bar-zhon Navy.  Any action will be met by equal amounts of force."} }
	greetings[5] = {
		action="attack",
		player="We require information. Comply or be destroyed.",
		alien={"Bar-Zhon patrol vessel engaging hostile pirate."} }
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship is useless and weak.",
		alien={"Take no hostile or evasive action unless you want to suffer the wrath of the imperial Barzhon Navy."} }
	statements[2] = {
		action="",
		player="What an ugly and worthless creature.",
		alien={"Bar-Zhon Naval ships do not respond to threats or insults."} }
	statements[3] = {
		action="",
		player="Your ship looks like a flying garbage scow.",
		alien={"By the laws of the Barzhon Imperial Confederacy we hereby present you with the sole warning.  Cease this aggressive attitude."} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	
	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"The Bar-zhon people and our Navy are matched by none other.  Many other races inhabit this area of space but none come close to our strength and power.  Well, maybe only the Minex come close to our strength."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Please be more specific.  Are you interested in the rabble known as the coalition?  Or the other races, the Tafel, the Nyssian, the Minex, the Thrynn and Elowan, or the Spemin?  Or Do you want to know about other pirates?"}
	}
	questions[30000] = {
		action="jump", goto=31001,
		player="What can you tell us about the past?",
		alien={"A few centicycles ago, in your own system of time about 1500 years ago, this entire region of space was enveloped by sector wide warfare known to historians as The Great War.   It is a lengthy story, are you sure you want to hear it?"}
	}
	questions[40000] = {
		action="jump", goto=1,
		player="Tell us about the Ancients.",
		alien={"The ancients traveled through this area of space several millennia ago, leaving strange uniformly shaped ruins and endurium crystals for whatever reason at the time.  Seek out some Nyssian story monger if you wish to learn more about them." }
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
		action="jump", goto=50000,
		player="We are interested in becoming allies of your great empire.  Where are your leaders?",
		alien={"The benefits of citizenship to the player in the great Bar-zhon empire cannot be counted.  Please visit our primary naval station at Midir V - 201,105."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="Where is your home world?",
		alien={"Our primary naval station at Midir V - 201,105."}
	}
	
		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your empire?",  goto=11000 },
			{ text="What can you tell us about your biology?", goto=12000 },
			{ text="What system of government do you have?", goto=13000 },
			{ text="What does your people offer for trade?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="What can you tell us about your empire?",
		alien={"Our territory is vast and our industrial and military might unmatched by all.  Freedom and justice prevail throughout the system of industrialized planets and their colonies, for no planet is taken advantage of or unfairly taxed by another." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="What can you tell us about your biology?",
		alien={"Our biology is our concern and no interest of yours." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="What system of government do you have?",
		alien={"A centralized imperium, however in practice our government operates as a coordinated federation.  The cohesiveness we share is not a matter of taxation or enslavement by the multitude of worlds united by a similar cultural system." }
	}
	questions[14000] = {
		action="jump", goto=14101,
		player="What does your people offer for trade?",
		alien={"Our people have a strict noninterference policy towards less developed races such as yourselves.  Your world was discovered and has been shielded by our fleet until which time you developed space flight.  The unexpectedly advanced technology and weaponry your ship possesses must be analyzed." }
	}
	
	questions[14101] = {
		action="branch",
		choices = {
			{ text="Are you saying that your race will not trade with us?",  goto=14110 },
			{ text="Less developed?  I'll show you how less-developed we are!",  goto=14120 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[14110] = {
		action="jump", goto=14101,
		player="Are you saying that your race will not trade with us?",
		alien={"Of course we will, but first your species must be categorized properly and trade goods which will not be unnecessarily disruptive to your species must be found." }
	}
	questions[14120] = {
		action="jump", goto=14121,
		player="Less developed?  I'll show you how less-developed we are.",
		alien={"Terrorist threats will not be tolerated.  Force must be met with force." }
	}
	questions[14121] = {
		action="attack",
		player="Less developed?  I'll show you how less-developed we are.",
		alien={"Terrorist threats will not be tolerated.  Force must be met with force." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Coalition.",  goto=21000 },
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
		action="jump", goto=21100,
		player="Tell us about the Coalition.",
		alien={"We must warn you about an annoyance you may find in our area of space.  Currently our empire is experiencing minor guerrilla warfare from a minor faction of malcontents, self-titled 'The Coalition.'" }
	}
	questions[21100] = {
		action="jump", goto=21001,
		player="<More>",
		alien={"The rebels are a group of malcontents and pirates which hide inside our vast territory.  Utilizing and rebuilding many of the scrapped mining equipment and shipyards of the three imperialists they pose a constant but minimal threat to the law-abiding sentients of this sector." }
	}
	questions[22000] = {
		action="jump", goto=22100,
		player="Tell us about the Tafel.",
		alien={"The Tafel are a disgustingly primitive group of collectivists.  Their primitive and emotional culture has a penchant for extreme shifts which makes them untrustworthy. The sole redeeming value is their incredible mining ability." }
	}
	questions[22100] = {
		action="jump", goto=21001,
		player="<More>",
		alien={"We trade the Tafel antiquated trinkets and junk for vast amounts of radioactive wastes and other trinkets.  They are a prolific and insidious species which one day may become dangerous.  We suggest you treat them warily as we do." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="Tell us about the Nyssian.",
		alien={"The Nyssian are a harmless nomadic and secretive people who number in the low thousands.  Their technologies are antiquated, their people weak willed and divided, and their wisdom fractured and contradictory.  Do not bother with them." }
	}
	questions[24000] = {
		action="jump", goto=24100,
		player="Tell us about the Minex.",
		alien={"Minex culture is an enigma.  They do not travel and have never expanded their territory.  Encroaching on space yields fierce opposition, yet they hold no apparent hostility." }
	}
	questions[24100] = {
		action="jump", goto=21002,
		player="<More>",
		alien={"As far as we can determine, the Minex culture has been static and unchanging since our earliest days of space travel.  From what are a few successful probes have shown their populations and fleets are vast." }
	}
	questions[25000] = {
		action="jump", goto=21002,
		player="Tell us about the Thrynn and Elowan.",
		alien={"The Thrynn and Elowan savages are both barely sentient warmongers with no industrial base to speak of.  Their frail industries barely support their tattered ships.  One day if an empire decided to conquer them, they would discover how similar they actually are to each other." }
	}
	questions[26000] = {
		action="jump", goto=21002,
		player="Tell us about the Spemin.",
		alien={"The Spemin blobs are innocent and truly nonsentient organisms which only mimic communication, technology and behavior.  They rely on insane breeding rates and Darwinism to kill off the non-effective.  They truly cannot think for themselves, so don't bother with them." }
	}
	questions[27000] = {
		action="jump", goto=21002,
		player="Tell us about other pirates.",
		alien={"Various pirate clans composed of members from all the alien species occasionally traverses the unpatrolled areas of space.  Don't take it personally if an alien ship simply decides to attack you.  It's likely not affiliated with the hierarchy of its species." }
	}

	questions[21101] = {
		action="branch",
		choices = {
			{ text="How are they able to hide inside your territory?",  goto=21100 },
			{ text="Where are they located?",  goto=21200 },
			{ text="How dangerous is the coalition?",  goto=21300 },
			{ text="So members of the Bar-zhon people make up the coalition?",  goto=21400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[21100] = {
		action="jump", goto=21101,
		player="How are they able to hide inside your territory?",
		alien={"Only with constant espionage to keep up with our technological advances and through careful random and emissionless construction.  Silhouettes of their ships and structures are extremely erratic and disguised as asteroids or floating debris." }
	}
	questions[21200] = {
		action="jump", goto=21201,
		player="Where are they located?",
		alien={"They primarily roaming platforms and ships in asteroid fields or a large asteroids, making them very difficult to find and eliminate.  Many attempts have been made to wipe them out but have only served to cull their numbers." }
	}
	questions[21201] = {
		action="jump", goto=21101,
		player="Surely sensors can detect life or energy signatures?",
		alien={"Life signs can be masked with sufficient shielding.  Energy signatures can be hidden as long as no propulsion is used.  Efforts to dragnet sectors are discovered and patrols avoided.  Simple communication signals can be undetectably embedded inside our own communication network." }
	}
	questions[21300] = {
		action="jump", goto=21101,
		player="How dangerous is the coalition?",
		alien={"The coalition is not a true threat to us, only an annoyance.  They are wise enough to avoid clashes with our military, but we tell you about them since they often seek out and attack individual vessels, especially newcomers to this area." }
	}
	questions[21400] = {
		action="jump", goto=21101,
		player="So members of the Bar-zhon people make up the coalition?",
		alien={"Only malcontents from the worker caste working with technicians of the alien cultures in our populations.  This pattern of rebellion has occurred before.  Unfortunately it is impossible to keep determined individuals earthbound, and this pirating culture has formed." }
	}

	questions[31001] = {
		action="branch",
		choices = {
		
			{ text="Which races were involved in this Great War?",  goto=31002 },
			{ text="Yes, tell me the full story of The Great War.",  goto=31003 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[31002] = {
		action="jump", goto=31101,
		player="Which races were involved in this Great War?",
		alien={"The Great War involved a conflict between four of the five major powers in the region.  Ourselves, the Minex, the Transmodra, the Sabion, and the Bx.  The last three races were known collectively as the Three Imperialists." }
	}
	questions[31003] = {
		action="jump", goto=31004,
		player="Yes, tell me the full story of The Great War.",
		alien={"The Transmodra formed the backbone of the imperialist alliance against us and the most terrible atrocities did they commit.  Biological warfare was their specialty.  Over a dozen Bar-zhon worlds did they extinguish before our people could fully mobilize." }
	}
	questions[31004] = {
		action="jump", goto=31005,
		player="<More>",
		alien={"The elite corps of the Bar-zhon Navy was created, replacing the old Guardian Corp. the noblest families in the finest tradition of our history have been trained since birth to glide and fight in the starry skies." }
	}
	questions[31005] = {
		action="jump", goto=31006,
		player="<More>",
		alien={"The workers party was thrown down from office and control of our glorious empire given back to its rightful heirs.  The temporary slave camps and razing of the useless extravagances of the past were fully necessary and saved countless lives despite the minor cultural turmoil they caused." }
	}
	questions[31006] = {
		action="jump", goto=31007,
		player="<More>",
		alien={"Within five years the Bar-zhon held their own and completely halted the imperialists advance.  A holding force was maintained while our people secretly built a tremendous fleet." }
	}
	questions[31007] = {
		action="jump", goto=31008,
		player="<More>",
		alien={"After a particularly powerful wave was repelled, our people took a desperate gamble.  The entire defensive fleet was consolidated with the secret fleet and sent at flank speed to the Transmodra home world." }
	}
	questions[31008] = {
		action="jump", goto=31009,
		player="<More>",
		alien={"After overwhelming defensive forces, mass drivers razed all population and industrial centers.  Mop up operations took little effort and the entire Transmodra industrial machine was quickly under Bar-zhon control." }
	}
	questions[31009] = {
		action="jump", goto=31010,
		player="<More>",
		alien={"This maneuver split the Sabion and the Bx forces in half and effectively won the tactical war.  Unfortunately the Sabion and the Bx refused to surrender." }
	}
	questions[31010] = {
		action="jump", goto=31011,
		player="<More>",
		alien={"The two remaining races maintained unprovoked hit-and-run attacks for an additional two years before their home worlds were overrun and industrial forces stopped." }
	}
	questions[31011] = {
		action="jump", goto=31012,
		player="<More>",
		alien={"Unwilling to let these races ever become a threat again, the entire populations of the three industrialists were relocated onto Bar-zhon colony worlds, where they continue to thrive to this day." }
	}
	questions[31012] = {
		action="jump", goto=31013,
		player="<More>",
		alien={"Control of our government has remained firmly in the claws of the Imperial Navy, and we have successfully prevented any catastrophic mistakes from ever threatening our people again." }
	}
	questions[31013] = {
		action="jump", goto=31001,
		player="The aftermath of the war has something to do with The Coalition, right?",
		alien={"An insightful question indeed, and it is true.  The worker caste working with technicians of the alien cultures in our populations at several times in our  recent history attempted to form rebellions which always failed miserably.  The coalition is their latest attempt." }
	}
	questions[31101] = {
		action="branch",
		choices = {
			{ text="What do you mean about only four of the five powers?",  goto=31100 },
			{ text="What started off the war?",  goto=31200 },
			{ text="What about the other races now in this sector, where were they?",  goto=31300 },
			{ text="So your people defeated a coalition of races allied against you?",  goto=31400 },
			{ text="<Back>", goto=31001 }
		}
	}
	questions[31100] = {
		action="jump", goto=31102,
		player="What do you mean about only four of the five powers?",
		alien={"The Minex remained neutral throughout the conflict, neither worrying nor caring of the consequences to their own empire if we lost.  We discovered later that they repulsed several skirmishes into their territory but only fought defensively." }
	}
	questions[31102] = {
		action="jump", goto=31101,
		player="What about the Nyssian?  Aren't they an ancient race?",
		alien={"Ha!  Ancient, maybe.  Relevant, no.  Those so-called anti-materialists strip mined their world and polluted it to the point that only a few escaped the devastation.  Their lifespan and their race are only maintained through cryogenic stasis." }
	}
	questions[31200] = {
		action="jump", goto=31101,
		player="What started off the war?",
		alien={"In the ancient past our sphere of influence was far less and much greater challenges were our people faced with.  A coalition of three upstart imperialists decided, completely unprovoked, to expand their territory directly into our area space." }
	}
	questions[31300] = {
		action="jump", goto=31101,
		player="What about the other races now in this sector, where were they?",
		alien={"Your people had yet to develop space flight.  The Tafel were also still mucking around scratching dirt on their lava world.  The Spemin?  Weaponless incomprehensible savages.  The Thrynn and the Elowan did not show up on the scene until later." }
	}
	questions[31400] = {
		action="jump", goto=31101,
		player="So your people defeated a coalition of races allied against you?",
		alien={"Yes, the Bar-zhon people met this challenge unwaveringly and without hesitance.  Only we accepted the challenge of defending the liberty of the sector.  Great and heroic our countrymen acted in those days.  Glorious were our many victories." }
	}


end

------------------------------------------------------------------------
-- SCRIPT INITIALIZATION -----------------------------------------------
------------------------------------------------------------------------
function Initialize()
    -- COMBAT VALUES FOR THIS ALIEN RACE
    health = 100                    -- 100=baseline minimum
    mass = 6                        -- 1=tiny, 10=huge
	engineclass = 3
	shieldclass = 6
	armorclass = 3
	laserclass = 3
	missileclass = 5
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 100			-- % of damage received, used for racial abilities, 0-100%

	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in
	
	--  15 Bar-Zhon Data Cube
	
	DROPITEM1 = 15;	    DROPRATE1 = 90;		DROPQTY1 = 1
	DROPITEM2 = 31;		DROPRATE2 = 0;	    DROPQTY2 = 15
	DROPITEM3 = 34;		DROPRATE3 = 25;		DROPQTY3 = 9
	DROPITEM4 = 50;		DROPRATE4 = 50;		DROPQTY4 = 2
	DROPITEM5 = 54;		DROPRATE5 = 70;		DROPQTY5 = 4

	active_quest = 25
	artifact20 = 1

	--initialize dialog
	if player_profession == "military" and active_quest == 30 and artifact20 > 0 then
		first_question = 74000
	elseif player_profession == "military" and active_quest == 35 and artifact22 > 0 then
		first_question = 79000
	elseif player_profession == "freelance" and active_quest == 29 and artifact16 == 0 then
		first_question = 93000
	elseif player_profession == "freelance" and active_quest == 29 and artifact16 == 1 then
		first_question = 93500
	elseif player_profession == "scientific" and active_quest == 31 and artifact16 == 0 then
		first_question = 85000
	elseif player_profession == "scientific" and active_quest == 35 then
		first_question = 89000
	elseif player_profession == "military" and active_quest == 31 and artifact20 > 0 then
		first_question = 95000
	elseif player_profession == "freelance" and active_quest == 34 and artifact18 == 1 then
		first_question = 98000
	elseif player_profession == "freelance" and active_quest == 35 and artifact27 == 0 and artifact28 == 0 then
		first_question = 99000
--	elseif artifact14 > 0 then
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
		action="jump", goto=1,
		artifact20 = 0,
		active_quest = active_quest + 1,
--		ship_shield_class = ship_shield_class + 1,
		player="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have a coalition afterburner unit for you.",
		alien={"Excellent work.  Your species shows considerable promise.  For your efforts I have been authorized to enhance the defensive shielding of your vessel. " }
	}
	
	
	
	questions[79000] = {
		action="jump", goto=79001,
		player="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have a Minex electronics system here.  Are you interested in it?",
		alien={"Yes [CAPTAIN].  We are very interested in Minex technology.  We will be willing to upgrade your missiles to class 6 in exchange for the artifact." }
			}
	questions[79001] = {
		action="branch",
		choices = {
			{ text="Okay, it's yours.",  goto=79100 },
			{ text="No thanks.",  goto=79200 },
		}
	}
	questions[79100] = {
		action="jump", goto=1,
		artifact22 = 0,
		active_quest = active_quest + 1,
--		ship_missile_class = 6,
		player=" ",
		alien={"You will not regret this decision.  Our  engineers are being sent over your ship as we speak. " }
	}
	questions[79200] = {
		action="jump", goto=1,
		player="",
		alien={"Very well." }
	}

	
	
	questions[85000] = {
		action="jump", goto=85001,
		player="Do you know anything about a Whining orb?",
		alien={"Yes.  Such a device is a primitive communications code breaker for one unique type of code that we've never been able to find.  Our current communication systems far surpasses its capacity we have fully integrated it's abilities into our software centuries ago on the chance we would ever found a use for it.   The original device was stolen out of one of our museums. " }
	}
	questions[85001] = {
		action="jump", goto=85002,
		player="Can you tell us where Lazerarp is? ",
		alien={"Please classify that label.  Our systems do not understand the word.  What is a Lazerarp? " }
	}
	questions[85002] = {
		action="jump", goto=1,
		player="Lazerarp is supposedly a planet.",
		alien={"I still am unable to find any reference or even a partial match utilizing any derivation of that label.  Go bother the Nyssian.  A few of their ships wander the empty territory downspin of our own.  If any race knows unusual or dead languages it would be them." }
	}
	
	
	
	questions[89000] = {
		action="jump", goto=89001,
		player="This is Captain [CAPTAIN] of the starship [SHIPNAME].  Will you help us decode this fragmentary data showing the location of a planet possibly containing exotic particles?",
		alien={"Your search is foolhardy.  Exotic matter has been proven not to exist and this scan data is most likely a forgery." }
	}
	questions[89001] = {
		action="jump", goto=1,
		player="Could you analyze the data anyway? ",
		alien={"The broken nature of this information further suggests an attempt to hide discrepancy in the data.  Oh well, if you wish to pursue this further I am able to match the planet type against known acidic planets in our database.  Don't bother me with this anymore." }
	}
	
		questions[93000] = {
		action="jump", goto=93001,
		player="Do you know anything about a Whining orb?",
		alien={"Yes.  Such a device is a primitive communications code breaker for one unique type of code that we've never been able to find.  Our current communication systems far surpasses its capacity we have fully integrated it's abilities into our software centuries ago on the chance we would ever found a use for it.   The original device was stolen out of one of our museums. " }
	}
	questions[93001] = {
		action="jump", goto=93002,
		player="Can you tell us where Lazerarp is? ",
		alien={"Please classify that label.  Our systems do not understand the word.  What is a Lazerarp? " }
	}
	questions[93002] = {
		action="jump", goto=1,
		player="Lazerarp is supposedly a planet.",
		alien={"I still am unable to find any reference or even a partial match utilizing any derivation of that label.  Go bother the Nyssian.  A few of their ships wander the empty territory downspin of our own.  If any race knows unusual or dead languages it would be them." }
	}

	questions[93500] = {
		action="jump", goto=93501,
		player="Can you tell us about… ",
		alien={"Halt!  Our scanners indicate that you are trafficking in stolen merchandise.  You will immediately return the whining orb or face consequences. " }
	}
	questions[93501] = {
		action="branch",
		choices = {
			{ text="Sure, go ahead and take it.",  goto=93600 },
			{ text="No.",  goto=93700 },
			{ text="We are willing to return this device for 20,000 M.U.",  goto=93800 },
		}
	}
	questions[93600] = {
		artifact16 = 0,
		active_quest = active_quest + 1,
		action="jump", goto=1,
		player="",
		alien={"I wouldn't say as much as good friends, but I'd rather you look into this then I would rather have others, if you know what I mean.  One of our contacts ran across information about an unusual communication artifact that was stashed on a planet known as Lazerarp at the north pole of the planet.  Now if we knew what planet that was, we would obtain the device ourselves.  Unfortunately our sources have turned up nothing." }
	}
	
	
	questions[93700] = {
		attitude = 20,
		action="attack",
		player="",
		alien={"You have been classified as a pirate and appropriate measures will be taken." }
	}
	questions[93800] = {
		action="jump", goto=93501,
		player="",
		alien={"No reimbursement will be made for stolen merchandise.  You must return this artifact immediately." }
	}

	
	questions[95000] = {
		action="jump", goto=1,
		artifact20 = 0,
		active_quest = active_quest + 1,
--		ship_shield_class = ship_shield_class + 1,
		player="I have a coalition afterburner unit for you.",
		alien={"Excellent work.  Your species shows considerable promise.  I have been authorized to enhance the defensive shielding of your vessel in exchange. " }
	}

	questions[98000] = {
		action="jump", goto=98001,
		player="Would you be interested in purchasing incredibly old artistic containers?",
		alien={"Perhaps … yes.  These appear to be of primitive Nyssian origin." }
	}
	questions[98001] = {
		action="branch",
		choices = {
			{ text="Nyssian?  I would not accept less than 20000 M.U. for them.",  goto=98100 },
			{ text="I am willing to sell them for 16,000 M.U.",  goto=98200 },
			{ text="Nevermind", goto=1 }
		}
	}
	questions[98100] = {
		artifact18 = 0,
--		player_money = player_money + 15000,
		active_quest = active_quest + 1,
		action="jump", goto=1,
		player="",
		alien={"Confirmed." }
	}
	questions[98200] = {
		artifact18 = 0,
--		player_money = player_money + 12000,
		active_quest = active_quest + 1,
		action="jump", goto=1,
		player="",
		alien={"Agreed.  This pottery is nearly identical to fragments we traced back to the Nyssian homeworld.  Good exchange." }
	}
	
	questions[99000] = {
		action="jump", goto=99001,
		player="Tell us about the Elowan – Tafel conflict.",
		alien={"A most regrettable and unnecessary conflict.  A report leads us to think that the conflict might be instigated by the Thrynn." }
	}
	questions[99001] = {
		action="jump", goto=1,
		player="Tell us about that report.",
		alien={"One of our ships observed a Thrynn vessel approaching the Aircthech system a few months ago.  The ship launched a probe of some sort from extreme range before fleeing back into hyperspace.  Curious, the captain entered the system and approached the drone.  Scans showed no high energy sources or biologicals so no action was taken." }
	}

	questions[99001] = {
		action="jump", goto=1,
		player="What happened to the probe?",
		alien={"The probe entered the atmosphere of the third planet briefly but then skipped off and headed on a trajectory that would cause it to land on the second planet.  Detecting multiple ships in the system, the captain declined to pursue.  A representative told the Elowan this but they want evidence." }
	}

	questions[500] = {
		action="jump", goto=501,
		player="Can you tell me about...",
		alien={"Would you be interested in selling your Thrynn Battle Machine?  I'll buy all of them for 3500 M.U. Myrrdan resources each." }
	}
	questions[501] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=510 },
			{ text="No.",  goto=520 },
		}
	}
	questions[510] = {
--		player_money = player_money + artifact14 * 3500,
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

