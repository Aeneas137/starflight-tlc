--[[
	ENCOUNTER SCRIPT FILE: MINEX ANCIENTS

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
		alien={"Hail allies."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"Hail allies."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"Hail allies."} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"Hail allies."} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"Hail allies."} }

		
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"<Whirl>"} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien={"<Silence>"} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"<Click>"} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"<Whirl>"} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"<Humm>"} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"<Silence>"} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"<Tick>"} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"<Click>"} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"<Whirl>"} }

		
	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[10000] = {
		action="jump", goto=10001,
		player="What can you tell us about yourselves?",
		alien={"The Minex are the shattered ones.  We struggle to defend and rebuild the lost unity of the age of sanity.  All actions are constructed to this goal."}
	}

	questions[10001] = {
		action="branch",
		choices = {
			{ text="Why do you consider yourselves shattered?", goto=11000 },
			{ text="What do your people offer for trade?", goto=12000 },
			{ text="What can you tell us about your biology?", goto=13000 },
			{ text="Where is your homeworld?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="",
		alien={"Unlike the enemy we have individuality and collective strength.  Collective strength was once powerful and our entire race could unite their thoughts at will bending reality itself.  This collective strength was lost." }
	}
	questions[12000] = {
		action="jump", goto=10001,
		player="",
		alien={"Irrelevant subject." }
	}
	questions[13000] = {
		action="jump", goto=10001,
		player="",
		alien={"Transitory state, irrelevant subject." }
	}
	questions[14000] = {
		action="jump", goto=10001,
		player="",
		alien={"Original unknown.  In this group of the scattering, several colony worlds lie within communication range.  Coordinates are irrelevant." }
	}
	questions[11001] = {
		action="branch",
		choices = {
			{ text="Who is the..", goto=11100 },
			{ text="How could you bend reality?", goto=11200 },
			{ text="Why was the collective..", goto=11300 },
			{ text="How long ago did this shattering occur?", goto=11400 },
			{ text="<Back>", goto=10001 }
		}
	}
	questions[11100] = {
		action="jump", goto=11001,
		player="",
		alien={"Enemy known as Uyo.  They had collective strength but no individuality." }
	}
	questions[11200] = {
		action="jump", goto=11001,
		player="",
		alien={"Translation into language is difficult.  Fabrication and manipulation of individual atoms is possible on a microscopic-scale with the collective simultaneous efforts of millions.  Technology is efficiency.  Psyonics may only be used for craftsmanship or to affect consciousness.  No longer do we have this power." }
	}
	questions[11300] = {
		action="jump", goto=11001,
		player="",
		alien={"Collective strength was lost near the end of the war against the Uyo.  Energy-based creatures you call Ancients intervened and ended the war.  Unknown reason for the loss.  Maybe Uyo action, maybe Ancient action  responsible." }
	}
	questions[11400] = {
		action="jump", goto=11401,
		player="",
		alien={"Exact records are lost.  Mental imprints of events destroy the timesense.  Estimate in your clock system would be hundreds of millions of years ago.  What you see as Minex is not who we have been in the past." }
	}
	questions[11401] = {
		action="jump", goto=11001,
		player="How could your race be hundreds of millions of years old?",
		alien={"Minex have taken on many genetic forms and developed many divergent technologies.  All change is rejected yet change takes place.  Mental imprints upon our young have preserved only the essential fragments of our history.  Our society has been destroyed, conquered, and transformed countless times.  Our history and knowledge is all that unites us with our past selves.  Everything else is transitory." }
	}

	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about other races?",
		alien={"Other races rise and fall.  They are irrelevant.  The contagion unifies and strengthens them to attack us.  We will not hold defense posture forever." }
	}

	questions[20001] = {
		action="branch",
		choices = {
			{ text="Why are you talking to us if other races are irrelevant?", goto=21000 },
			{ text="Will you help us with..", goto=22000 },
			{ text="Will you share your technology with us to stop the virus?", goto=23000 },
			{ text="We thought your race had stopped its warfare?", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="",
		alien={"Minex have never been in debt to an alien before.  Your species immunity to the contagion is also unique and not understood." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="",
		alien={"No.  Focus on finding the Ancients and/or stopping the contagion.  Your other concerns are irrelevant." }
	}
	questions[23000] = {
		action="jump", goto=20001,
		player="",
		alien={"No.  Your race is unknown to us.  You have no history in this sector.  Your technology is already refined.  Combining  technologies will not solve the problem.  We have scouted and controlled this particular region of space for tens of thousands of years.  If your species development did not occur here then you traveled here by some means unknown to us.  Re-creating that travel may be key to unlocking the mystery of your immunity.  Investigate it." }
	}
	questions[24000] = {
		action="jump", goto=24001,
		player="",
		alien={"Allowing contagion directed aliens freedom of movement allows them to gather strength and attack us more effectively.  We give you this window of time to work towards a cure.  If our existence is threatened further we will resume destroying fleets and start annihilating population centers." }
	}
	questions[24001] = {
		action="jump", goto=20001,
		player="What do you mean by population centers?",
		alien={"Planets.  We have a limited but sufficient number of artifacts that may destroy homeworlds.  These are last resort weaponry.  No further inquiries will be answered on this subject." }
	}

	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about the past?",
		alien={"Minex develop mind imprinting of offspring allow us accurate transmission of historical and technological knowledge.  The Uyo develop space transport technology and begin systematically eliminating all other sentient life.  Energy beings you call Ancients step in and destroy the Uyo completely.  The Ancients leave.  We begin the unending struggle to restore ourselves to our former state."}
	}

	questions[30001] = {
		action="branch",
		choices = {
			{ text="Tell us about your mind imprinting technology.", goto=31000 },
			{ text="Tell us about the Uyo.", goto=32000 },
			{ text="Why do your people need to restore yourselves?", goto=33000 },
			{ text="What was the war against the Uyo like?", goto=34000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31000] = {
		action="jump", goto=30001,
		player="",
		alien={"No." }
	}
	questions[32000] = {
		action="jump", goto=32001,
		player="",
		alien={"They were the enemy of all races.  They fought in planet bound environments only, specializing in telepathic destruction and biological warfare.  Every Uyo-inhabited planet acted as a single individual with every biological organism acting as a cell of the individual.  They emitted a powerful telepathic presence felt hundreds of sectors away by any one of us." }
	}
	questions[33000] = {
		action="jump", goto=30001,
		player="",
		alien={"The eternal ones or Ancients gifted us or enhanced us with the mental powers to fight the Uyo.  Much knowledge over the ages has been lost.  Either the Uyo genetically damaged us or the eternal ones may have withdrawn their gifts.  Without them, we are shattered and crippled." }
	}
	questions[34000] = {
		action="jump", goto=30001,
		player="",
		alien={"You have no concept of real war.  Your war consists of pushing buttons and watching technology fight.  With the gifts of the eternals we struggled endlessly against the minds of the destroyers simultaneously coordinated with our technological firepower." }
	}
	questions[32001] = {
		action="branch",
		choices = {
			{ text="Could the Uyo be the source of this virus?", goto=32100 },
			{ text="Are you saying that every Uyo planet acted like a person?", goto=32200 },
			{ text="Tell us about the Uyo 'transport technology'?", goto=32300 },
			{ text="How did the Ancients stop the Uyo?", goto=32400 },
			{ text="<Back>", goto=30001 }
		}
	}
	questions[32100] = {
		action="jump", goto=32001,
		player="",
		alien={"It is possible that they released this virus but not likely.  We do not feel their presence now.  Some other race may have simply uncovered their technology.  Just in case they have returned we have been searching for their telepathic signature.  Non-telepathic races cannot assist." }
	}
	questions[32200] = {
		action="jump", goto=32001,
		player="",
		alien={"Yes, an incredibly intelligent creature whose intelligent was proportional to the number of Uyo 'lifeforms' in communal telepathic communication.  The group mind could only focus on one thing at a time and was incredibly slow.  Individual Uyo had no awareness and could not respond or fight back.  The Uyo could only deal with individualistic races as a virus, and create an antibodies to fight them on a biological level.  This contagion bears their handiwork." }
	}
	questions[32300] = {
		action="jump", goto=32001,
		player="",
		alien={"The Uyo could only function as intelligent creatures in vast numbers.  They used circular vessels with incredibly powerful shielding and no weaponry to travel.  Somehow these vessels built up power over long periods of time before instantly jumping to their destination.  Occasionally we have found mysterious ships with organic computers still drifting in the cosmos matching this historical description." }
	}
	questions[32400] = {
		action="jump", goto=32001,
		player="",
		alien={"The Ancients were grand designers.  Although it took them ages before they intervened, they cured the virus on a galactic scale and somehow were able to neutralize the telepathic ability of the Uyo.  This neutralized and destroyed all known colonies in a single generation." }
	}

	questions[40000] = {
		action="jump", goto=40001,
		player="Tell us about the ancients.",
		alien={"The Ancients or the eternal ones are energy beings.  They have left this space-time continuum."}
	}

	questions[40001] = {
		action="branch",
		choices = {
			{ text="What were the Ancients like?", goto=41000 },
			{ text="What did the Ancients do?", goto=42000 },
			{ text="Where did the Ancients go?", goto=43000 },
			{ text="Do you know how to contact the Ancients?", goto=44000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[41000] = {
		action="jump", goto=40001,
		player="",
		alien={"Unknown.  Description lost over time." }
	}
	questions[42000] = {
		action="jump", goto=40001,
		player="",
		alien={"Explore and expand their territory.  Turn inwards and improve themselves.  Isolate themselves from influencing other races.  Declare war when forced.  We emulate their behavior as best we can." }
	}
	questions[43000] = {
		action="jump", goto=40001,
		player="",
		alien={"Unknown.  Beyond our understanding." }
	}
	questions[44000] = {
		action="jump", goto=44001,
		player="",
		alien={"This may be impossible.  We could communicate with them only in ancient times when our minds were at full strength and then only at research sites.  These sites have been lost.  No evidence has been seen of any Ancient activity in past eons." }
	}
	questions[44001] = {
		action="jump", goto=40001,
		player="Where can we find Ancient research sites?",
		alien={"Search out Ancient ruins.  Contact other alien races.  Ancients did not congregate for social reasons, but Ancient research sites often misnamed cities of the Ancients contained their most advanced technology and operated as communication junctions." }
	}
	questions[50000] = {
		action="branch",
		choices = { 
			{ text="What can we do to stop the virus?", goto=60000 },
			{ text="<Back>", goto=1 } 
		}
	}

	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"The eternals gifts are not completely restored by that which you have returned to us.  In ancient times we could feel the presence of the destroyers a galaxy span's away.  We must find the destroyers.  They controlled this virus in ancient times.  They may have returned again.  Find similar Ancient technology.  Find the Ancients.  Find the source of the Uyo technology." }
	}
	questions[60001] = {
		action="branch",
		choices = {
			{ text="How may we find Ancient technology?", goto=61000 },
			{ text="How may we find the Ancients?", goto=62000 },
			{ text="How may we find the source of the Uyo technology?", goto=63000 },
			{ text="Tell us about the virus or 'the contagion.'", goto=64000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[61000] = {
		action="jump", goto=60001,
		player="",
		alien={"Search out Ancient ruins.  Contact other alien races.  Ancients did not congregate for social reasons, but Ancient research sites often misnamed 'Cities of the Ancients' contained their most advanced technology." }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="",
		alien={"This may be impossible.  The eternal ones could shape matter but they themselves were never seen.  They manipulated stars, changed the mass of planets, wiped out whole solar systems where the destroyers gained strongholds.  We could communicate with them only in ancient times when our minds were at full strength and then only at research sites.  These sites have been lost.  No evidence has been seen of any Ancient activity in past eons." }
	}

	questions[63000] = {
		action="jump", goto=63001,
		player="",
		alien={"Unknown.  This virus is most likely a technological remnant of their existence.  Our mission now is to search the galaxy to find them and stop them if they still exist.  You may help us find them but only scout.  We alone have any hope of opposing them.  Report to us any progress." }
	}
	questions[63001] = {
		action="jump", goto=60001,
		player="<More>",
		alien={"The Uyo have only one remaining base that has yet to be penetrated and destroyed.  All other locations have been sterilized when defenses fell.  Only the base at the star that you know of as Cermait 6 has yet to be destroyed." }
	}
	questions[64000] = {
		action="jump", goto=64001,
		player="",
		alien={"All we know is that it is a stealthed nano assembler with two functions.  The first is to damage nothing with the exception of sentient beings.  When sentient beings are detected, create a continual flood of custom biological bacteria to reduce sentient populations and render them susceptible to telepathic control." }
	}
	questions[64001] = {
		action="branch",
		choices = {
			{ text="Do you know how to vaccinate against it?", goto=64100 },
			{ text="What does the virus do to the Minex?", goto=64200 },
			{ text="Do you know how to reverse the madness?", goto=64300 },
			{ text="Do you know how to cure it?", goto=64400 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[64100] = {
		action="jump", goto=64001,
		player="",
		alien={"No." }
	}
	questions[64200] = {
		action="jump", goto=64001,
		player="",
		alien={"It kills Minex instantly with no dormancy period.  Detection of infected areas and sterilization is easy for us." }
	}
	questions[64300] = {
		action="jump", goto=64001,
		player="",
		alien={"No." }
	}
	questions[64400] = {
		action="jump", goto=64001,
		player="",
		alien={"Find and ask the Ancients.  Only they know." }
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
		alien={"You bring a gift of the eternal ones.  We again feel, we see, we know.  This gift restores our minds and helps us remember the past.  We now remember, the virus is a creation of the demons long past, the Uyo.  In exchange for it we offer peace to all, an alliance with Humans, and our help in discovering the true source of the virus."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"You bring a gift of the eternal ones.  We again feel, we see, we know.  This gift restores our minds and helps us remember the past.  We now remember, the virus is a creation of the demons long past, the Uyo.  In exchange for it we offer peace to all, an alliance with Humans, and our help in discovering the true source of the virus."} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"You bring a gift of the eternal ones.  We again feel, we see, we know.  This gift restores our minds and helps us remember the past.  We now remember, the virus is a creation of the demons long past, the Uyo.  In exchange for it we offer peace to all, an alliance with Humans, and our help in discovering the true source of the virus."} }
	greetings[4] = {
		action="",
		player="Greetings.  There is a lot we can learn from each other.  Please respond.",
		alien={"You bring a gift of the eternal ones.  We again feel, we see, we know.  This gift restores our minds and helps us remember the past.  We now remember, the virus is a creation of the demons long past, the Uyo.  In exchange for it we offer peace to all, an alliance with Humans, and our help in discovering the true source of the virus."} } 
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"<Humm>"} }
	statements[2] = {
		action="",
		player="Your ship appears very elaborate.",
		alien={"<Click>"} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"<Whirl>"} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"<Humm>"} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"No."} }
		 


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 
	
	questions[10000] = {
		action="jump", goto=10001,
		player="What can you tell us about yourselves?",
		alien={"The Minex are the shattered ones.  We struggle to defend and rebuild the lost unity of the age of sanity.  All actions are constructed to this goal."}
	}

	questions[10001] = {
		action="branch",
		choices = {
			{ text="Why do you consider yourselves shattered?", goto=11000 },
			{ text="What do your people offer for trade?", goto=12000 },
			{ text="What can you tell us about your biology?", goto=13000 },
			{ text="Where is your homeworld?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="",
		alien={"Unlike the enemy we have individuality and collective strength.  Collective strength was once powerful and our entire race could unite their thoughts at will bending reality itself.  This collective strength was lost." }
	}
	questions[12000] = {
		action="jump", goto=10001,
		player="",
		alien={"Irrelevant subject." }
	}
	questions[13000] = {
		action="jump", goto=10001,
		player="",
		alien={"Transitory state, irrelevant subject." }
	}
	questions[14000] = {
		action="jump", goto=10001,
		player="",
		alien={"Original unknown.  In this group of the scattering, several colony worlds lie within communication range.  Coordinates are irrelevant." }
	}
	questions[11001] = {
		action="branch",
		choices = {
			{ text="Who is the..", goto=11100 },
			{ text="How could you bend reality?", goto=11200 },
			{ text="Why was the collective..", goto=11300 },
			{ text="How long ago did this shattering occur?", goto=11400 },
			{ text="<Back>", goto=10001 }
		}
	}
	questions[11100] = {
		action="jump", goto=11001,
		player="",
		alien={"Enemy known as Uyo.  They had collective strength but no individuality." }
	}
	questions[11200] = {
		action="jump", goto=11001,
		player="",
		alien={"Translation into language is difficult.  Fabrication and manipulation of individual atoms is possible on a microscopic-scale with the collective simultaneous efforts of millions.  Technology is efficiency.  Psyonics may only be used for craftsmanship or to affect consciousness.  No longer do we have this power." }
	}
	questions[11300] = {
		action="jump", goto=11001,
		player="",
		alien={"Collective strength was lost near the end of the war against the Uyo.  Energy-based creatures you call Ancients intervened and ended the war.  Unknown reason for the loss.  Maybe Uyo action, maybe Ancient action  responsible." }
	}
	questions[11400] = {
		action="jump", goto=11401,
		player="",
		alien={"Exact records are lost.  Mental imprints of events destroy the timesense.  Estimate in your clock system would be hundreds of millions of years ago.  What you see as Minex is not who we have been in the past." }
	}
	questions[11401] = {
		action="jump", goto=11001,
		player="How could your race be hundreds of millions of years old?",
		alien={"Minex have taken on many genetic forms and developed many divergent technologies.  All change is rejected yet change takes place.  Mental imprints upon our young have preserved only the essential fragments of our history.  Our society has been destroyed, conquered, and transformed countless times.  Our history and knowledge is all that unites us with our past selves.  Everything else is transitory." }
	}

	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about other races?",
		alien={"Other races rise and fall.  They are irrelevant.  The contagion unifies and strengthens them to attack us.  We will not hold defense posture forever." }
	}

	questions[20001] = {
		action="branch",
		choices = {
			{ text="Why are you talking to us if other races are irrelevant?", goto=21000 },
			{ text="Will you help us with..", goto=22000 },
			{ text="Will you share your technology with us to stop the virus?", goto=23000 },
			{ text="We thought your race had stopped its warfare?", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="",
		alien={"Minex have never been in debt to an alien before.  Your species immunity to the contagion is also unique and not understood." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="",
		alien={"No.  Focus on finding the Ancients and/or stopping the contagion.  Your other concerns are irrelevant." }
	}
	questions[23000] = {
		action="jump", goto=20001,
		player="",
		alien={"No.  Your race is unknown to us.  You have no history in this sector.  Your technology is already refined.  Combining  technologies will not solve the problem.  We have scouted and controlled this particular region of space for tens of thousands of years.  If your species development did not occur here then you traveled here by some means unknown to us.  Re-creating that travel may be key to unlocking the mystery of your immunity.  Investigate it." }
	}
	questions[24000] = {
		action="jump", goto=24001,
		player="",
		alien={"Allowing contagion directed aliens freedom of movement allows them to gather strength and attack us more effectively.  We give you this window of time to work towards a cure.  If our existence is threatened further we will resume destroying fleets and start annihilating population centers." }
	}
	questions[24001] = {
		action="jump", goto=20001,
		player="What do you mean by population centers?",
		alien={"Planets.  We have a limited but sufficient number of artifacts that may destroy homeworlds.  These are last resort weaponry.  No further inquiries will be answered on this subject." }
	}

	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about the past?",
		alien={"Minex develop mind imprinting of offspring allow us accurate transmission of historical and technological knowledge.  The Uyo develop space transport technology and begin systematically eliminating all other sentient life.  Energy beings you call Ancients step in and destroy the Uyo completely.  The Ancients leave.  We begin the unending struggle to restore ourselves to our former state."}
	}

	questions[30001] = {
		action="branch",
		choices = {
			{ text="Tell us about your mind imprinting technology.", goto=31000 },
			{ text="Tell us about the Uyo.", goto=32000 },
			{ text="Why do your people need to restore yourselves?", goto=33000 },
			{ text="What was the war against the Uyo like?", goto=34000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31000] = {
		action="jump", goto=30001,
		player="",
		alien={"No." }
	}
	questions[32000] = {
		action="jump", goto=32001,
		player="",
		alien={"They were the enemy of all races.  They fought in planet bound environments only, specializing in telepathic destruction and biological warfare.  Every Uyo-inhabited planet acted as a single individual with every biological organism acting as a cell of the individual.  They emitted a powerful telepathic presence felt hundreds of sectors away by any one of us." }
	}
	questions[33000] = {
		action="jump", goto=30001,
		player="",
		alien={"The eternal ones or Ancients gifted us or enhanced us with the mental powers to fight the Uyo.  Much knowledge over the ages has been lost.  Either the Uyo genetically damaged us or the eternal ones may have withdrawn their gifts.  Without them, we are shattered and crippled." }
	}
	questions[34000] = {
		action="jump", goto=30001,
		player="",
		alien={"You have no concept of real war.  Your war consists of pushing buttons and watching technology fight.  With the gifts of the eternals we struggled endlessly against the minds of the destroyers simultaneously coordinated with our technological firepower." }
	}
	questions[32001] = {
		action="branch",
		choices = {
			{ text="Could the Uyo be the source of this virus?", goto=32100 },
			{ text="Are you saying that every Uyo planet acted like a person?", goto=32200 },
			{ text="Tell us about the Uyo 'transport technology'?", goto=32300 },
			{ text="How did the Ancients stop the Uyo?", goto=32400 },
			{ text="<Back>", goto=30001 }
		}
	}
	questions[32100] = {
		action="jump", goto=32001,
		player="",
		alien={"It is possible that they released this virus but not likely.  We do not feel their presence now.  Some other race may have simply uncovered their technology.  Just in case they have returned we have been searching for their telepathic signature.  Non-telepathic races cannot assist." }
	}
	questions[32200] = {
		action="jump", goto=32001,
		player="",
		alien={"Yes, an incredibly intelligent creature whose intelligent was proportional to the number of Uyo 'lifeforms' in communal telepathic communication.  The group mind could only focus on one thing at a time and was incredibly slow.  Individual Uyo had no awareness and could not respond or fight back.  The Uyo could only deal with individualistic races as a virus, and create an antibodies to fight them on a biological level.  This contagion bears their handiwork." }
	}
	questions[32300] = {
		action="jump", goto=32001,
		player="",
		alien={"The Uyo could only function as intelligent creatures in vast numbers.  They used circular vessels with incredibly powerful shielding and no weaponry to travel.  Somehow these vessels built up power over long periods of time before instantly jumping to their destination.  Occasionally we have found mysterious ships with organic computers still drifting in the cosmos matching this historical description." }
	}
	questions[32400] = {
		action="jump", goto=32001,
		player="",
		alien={"The Ancients were grand designers.  Although it took them ages before they intervened, they cured the virus on a galactic scale and somehow were able to neutralize the telepathic ability of the Uyo.  This neutralized and destroyed all known colonies in a single generation." }
	}

	questions[40000] = {
		action="jump", goto=40001,
		player="Tell us about the ancients.",
		alien={"The Ancients or the eternal ones are energy beings.  They have left this space-time continuum."}
	}

	questions[40001] = {
		action="branch",
		choices = {
			{ text="What were the Ancients like?", goto=41000 },
			{ text="What did the Ancients do?", goto=42000 },
			{ text="Where did the Ancients go?", goto=43000 },
			{ text="Do you know how to contact the Ancients?", goto=44000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[41000] = {
		action="jump", goto=40001,
		player="",
		alien={"Unknown.  Description lost over time." }
	}
	questions[42000] = {
		action="jump", goto=40001,
		player="",
		alien={"Explore and expand their territory.  Turn inwards and improve themselves.  Isolate themselves from influencing other races.  Declare war when forced.  We emulate their behavior as best we can." }
	}
	questions[43000] = {
		action="jump", goto=40001,
		player="",
		alien={"Unknown.  Beyond our understanding." }
	}
	questions[44000] = {
		action="jump", goto=44001,
		player="",
		alien={"This may be impossible.  We could communicate with them only in ancient times when our minds were at full strength and then only at research sites.  These sites have been lost.  No evidence has been seen of any Ancient activity in past eons." }
	}
	questions[44001] = {
		action="jump", goto=40001,
		player="Where can we find Ancient research sites?",
		alien={"Search out Ancient ruins.  Contact other alien races.  Ancients did not congregate for social reasons, but Ancient research sites often misnamed cities of the Ancients contained their most advanced technology and operated as communication junctions." }
	}
	questions[50000] = {
		action="branch",
		choices = { 
			{ text="What can we do to stop the virus?", goto=60000 },
			{ text="<Back>", goto=1 } 
		}
	}

	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"The eternals gifts are not completely restored by that which you have returned to us.  In ancient times we could feel the presence of the destroyers a galaxy span's away.  We must find the destroyers.  They controlled this virus in ancient times.  They may have returned again.  Find similar Ancient technology.  Find the Ancients.  Find the source of the Uyo technology." }
	}
	questions[60001] = {
		action="branch",
		choices = {
			{ text="How may we find Ancient technology?", goto=61000 },
			{ text="How may we find the Ancients?", goto=62000 },
			{ text="How may we find the source of the Uyo technology?", goto=63000 },
			{ text="Tell us about the virus or 'the contagion.'", goto=64000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[61000] = {
		action="jump", goto=60001,
		player="",
		alien={"Search out Ancient ruins.  Contact other alien races.  Ancients did not congregate for social reasons, but Ancient research sites often misnamed 'Cities of the Ancients' contained their most advanced technology." }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="",
		alien={"This may be impossible.  The eternal ones could shape matter but they themselves were never seen.  They manipulated stars, changed the mass of planets, wiped out whole solar systems where the destroyers gained strongholds.  We could communicate with them only in ancient times when our minds were at full strength and then only at research sites.  These sites have been lost.  No evidence has been seen of any Ancient activity in past eons." }
	}

	questions[63000] = {
		action="jump", goto=63001,
		player="",
		alien={"Unknown.  This virus is most likely a technological remnant of their existence.  Our mission now is to search the galaxy to find them and stop them if they still exist.  You may help us find them but only scout.  We alone have any hope of opposing them.  Report to us any progress." }
	}
	questions[63001] = {
		action="jump", goto=60001,
		player="<More>",
		alien={"The Uyo have only one remaining base that has yet to be penetrated and destroyed.  All other locations have been sterilized when defenses fell.  Only the base at the star that you know of as Cermait 6 has yet to be destroyed." }
	}
	questions[64000] = {
		action="jump", goto=64001,
		player="",
		alien={"All we know is that it is a stealthed nano assembler with two functions.  The first is to damage nothing with the exception of sentient beings.  When sentient beings are detected, create a continual flood of custom biological bacteria to reduce sentient populations and render them susceptible to telepathic control." }
	}
	questions[64001] = {
		action="branch",
		choices = {
			{ text="Do you know how to vaccinate against it?", goto=64100 },
			{ text="What does the virus do to the Minex?", goto=64200 },
			{ text="Do you know how to reverse the madness?", goto=64300 },
			{ text="Do you know how to cure it?", goto=64400 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[64100] = {
		action="jump", goto=64001,
		player="",
		alien={"No." }
	}
	questions[64200] = {
		action="jump", goto=64001,
		player="",
		alien={"It kills Minex instantly with no dormancy period.  Detection of infected areas and sterilization is easy for us." }
	}
	questions[64300] = {
		action="jump", goto=64001,
		player="",
		alien={"No." }
	}
	questions[64400] = {
		action="jump", goto=64001,
		player="",
		alien={"Find and ask the Ancients.  Only they know." }
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
		alien={"<Silence>"} }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"<Silence>"}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"<Silence>"} }
	greetings[4] = {
		action="",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"<Silence>"} }
	greetings[5] = {
		action="",
		player="We require information. Comply or be destroyed.",
		alien={"<Silence>"} }
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="terminate",
		player="Your ship is oversized and weak.",
		alien={"<Silence>"} }
	statements[2] = {
		action="terminate",
		player="What an ugly and worthless creature.",
		alien={"<Silence>"} }
	statements[3] = {
		action="terminate",
		player="You do not frighten me. Surrender at once. ",
		alien={"<Silence>"} }
	statements[4] = {
		action="terminate",
		player="You will cooperate with us or you will be destroyed.",
		alien={"<Silence>"} }
	statements[5] = {
		action="terminate",
		player="We are prepared to spare you if you comply with our demands.",
		alien={"<Silence>"} }
	statements[6] = {
		action="terminate",
		player="Prepare yourselves for dissolution, alien scum dogs.",
		alien={"<Silence>"} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	
	questions[10000] = {
		action="jump", goto=10001,
		player="What can you tell us about yourselves?",
		alien={"The Minex are the shattered ones.  We struggle to defend and rebuild the lost unity of the age of sanity.  All actions are constructed to this goal."}
	}

	questions[10001] = {
		action="branch",
		choices = {
			{ text="Why do you consider yourselves shattered?", goto=11000 },
			{ text="What do your people offer for trade?", goto=12000 },
			{ text="What can you tell us about your biology?", goto=13000 },
			{ text="Where is your homeworld?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="",
		alien={"Unlike the enemy we have individuality and collective strength.  Collective strength was once powerful and our entire race could unite their thoughts at will bending reality itself.  This collective strength was lost." }
	}
	questions[12000] = {
		action="jump", goto=10001,
		player="",
		alien={"Irrelevant subject." }
	}
	questions[13000] = {
		action="jump", goto=10001,
		player="",
		alien={"Transitory state, irrelevant subject." }
	}
	questions[14000] = {
		action="jump", goto=10001,
		player="",
		alien={"Original unknown.  In this group of the scattering, several colony worlds lie within communication range.  Coordinates are irrelevant." }
	}
	questions[11001] = {
		action="branch",
		choices = {
			{ text="Who is the..", goto=11100 },
			{ text="How could you bend reality?", goto=11200 },
			{ text="Why was the collective..", goto=11300 },
			{ text="How long ago did this shattering occur?", goto=11400 },
			{ text="<Back>", goto=10001 }
		}
	}
	questions[11100] = {
		action="jump", goto=11001,
		player="",
		alien={"Enemy known as Uyo.  They had collective strength but no individuality." }
	}
	questions[11200] = {
		action="jump", goto=11001,
		player="",
		alien={"Translation into language is difficult.  Fabrication and manipulation of individual atoms is possible on a microscopic-scale with the collective simultaneous efforts of millions.  Technology is efficiency.  Psyonics may only be used for craftsmanship or to affect consciousness.  No longer do we have this power." }
	}
	questions[11300] = {
		action="jump", goto=11001,
		player="",
		alien={"Collective strength was lost near the end of the war against the Uyo.  Energy-based creatures you call Ancients intervened and ended the war.  Unknown reason for the loss.  Maybe Uyo action, maybe Ancient action  responsible." }
	}
	questions[11400] = {
		action="jump", goto=11401,
		player="",
		alien={"Exact records are lost.  Mental imprints of events destroy the timesense.  Estimate in your clock system would be hundreds of millions of years ago.  What you see as Minex is not who we have been in the past." }
	}
	questions[11401] = {
		action="jump", goto=11001,
		player="How could your race be hundreds of millions of years old?",
		alien={"Minex have taken on many genetic forms and developed many divergent technologies.  All change is rejected yet change takes place.  Mental imprints upon our young have preserved only the essential fragments of our history.  Our society has been destroyed, conquered, and transformed countless times.  Our history and knowledge is all that unites us with our past selves.  Everything else is transitory." }
	}

	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about other races?",
		alien={"Other races rise and fall.  They are irrelevant.  The contagion unifies and strengthens them to attack us.  We will not hold defense posture forever." }
	}

	questions[20001] = {
		action="branch",
		choices = {
			{ text="Why are you talking to us if other races are irrelevant?", goto=21000 },
			{ text="Will you help us with..", goto=22000 },
			{ text="Will you share your technology with us to stop the virus?", goto=23000 },
			{ text="We thought your race had stopped its warfare?", goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=20001,
		player="",
		alien={"Minex have never been in debt to an alien before.  Your species immunity to the contagion is also unique and not understood." }
	}
	questions[22000] = {
		action="jump", goto=20001,
		player="",
		alien={"No.  Focus on finding the Ancients and/or stopping the contagion.  Your other concerns are irrelevant." }
	}
	questions[23000] = {
		action="jump", goto=20001,
		player="",
		alien={"No.  Your race is unknown to us.  You have no history in this sector.  Your technology is already refined.  Combining  technologies will not solve the problem.  We have scouted and controlled this particular region of space for tens of thousands of years.  If your species development did not occur here then you traveled here by some means unknown to us.  Re-creating that travel may be key to unlocking the mystery of your immunity.  Investigate it." }
	}
	questions[24000] = {
		action="jump", goto=24001,
		player="",
		alien={"Allowing contagion directed aliens freedom of movement allows them to gather strength and attack us more effectively.  We give you this window of time to work towards a cure.  If our existence is threatened further we will resume destroying fleets and start annihilating population centers." }
	}
	questions[24001] = {
		action="jump", goto=20001,
		player="What do you mean by population centers?",
		alien={"Planets.  We have a limited but sufficient number of artifacts that may destroy homeworlds.  These are last resort weaponry.  No further inquiries will be answered on this subject." }
	}

	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about the past?",
		alien={"Minex develop mind imprinting of offspring allow us accurate transmission of historical and technological knowledge.  The Uyo develop space transport technology and begin systematically eliminating all other sentient life.  Energy beings you call Ancients step in and destroy the Uyo completely.  The Ancients leave.  We begin the unending struggle to restore ourselves to our former state."}
	}

	questions[30001] = {
		action="branch",
		choices = {
			{ text="Tell us about your mind imprinting technology.", goto=31000 },
			{ text="Tell us about the Uyo.", goto=32000 },
			{ text="Why do your people need to restore yourselves?", goto=33000 },
			{ text="What was the war against the Uyo like?", goto=34000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31000] = {
		action="jump", goto=30001,
		player="",
		alien={"No." }
	}
	questions[32000] = {
		action="jump", goto=32001,
		player="",
		alien={"They were the enemy of all races.  They fought in planet bound environments only, specializing in telepathic destruction and biological warfare.  Every Uyo-inhabited planet acted as a single individual with every biological organism acting as a cell of the individual.  They emitted a powerful telepathic presence felt hundreds of sectors away by any one of us." }
	}
	questions[33000] = {
		action="jump", goto=30001,
		player="",
		alien={"The eternal ones or Ancients gifted us or enhanced us with the mental powers to fight the Uyo.  Much knowledge over the ages has been lost.  Either the Uyo genetically damaged us or the eternal ones may have withdrawn their gifts.  Without them, we are shattered and crippled." }
	}
	questions[34000] = {
		action="jump", goto=30001,
		player="",
		alien={"You have no concept of real war.  Your war consists of pushing buttons and watching technology fight.  With the gifts of the eternals we struggled endlessly against the minds of the destroyers simultaneously coordinated with our technological firepower." }
	}
	questions[32001] = {
		action="branch",
		choices = {
			{ text="Could the Uyo be the source of this virus?", goto=32100 },
			{ text="Are you saying that every Uyo planet acted like a person?", goto=32200 },
			{ text="Tell us about the Uyo 'transport technology'?", goto=32300 },
			{ text="How did the Ancients stop the Uyo?", goto=32400 },
			{ text="<Back>", goto=30001 }
		}
	}
	questions[32100] = {
		action="jump", goto=32001,
		player="",
		alien={"It is possible that they released this virus but not likely.  We do not feel their presence now.  Some other race may have simply uncovered their technology.  Just in case they have returned we have been searching for their telepathic signature.  Non-telepathic races cannot assist." }
	}
	questions[32200] = {
		action="jump", goto=32001,
		player="",
		alien={"Yes, an incredibly intelligent creature whose intelligent was proportional to the number of Uyo 'lifeforms' in communal telepathic communication.  The group mind could only focus on one thing at a time and was incredibly slow.  Individual Uyo had no awareness and could not respond or fight back.  The Uyo could only deal with individualistic races as a virus, and create an antibodies to fight them on a biological level.  This contagion bears their handiwork." }
	}
	questions[32300] = {
		action="jump", goto=32001,
		player="",
		alien={"The Uyo could only function as intelligent creatures in vast numbers.  They used circular vessels with incredibly powerful shielding and no weaponry to travel.  Somehow these vessels built up power over long periods of time before instantly jumping to their destination.  Occasionally we have found mysterious ships with organic computers still drifting in the cosmos matching this historical description." }
	}
	questions[32400] = {
		action="jump", goto=32001,
		player="",
		alien={"The Ancients were grand designers.  Although it took them ages before they intervened, they cured the virus on a galactic scale and somehow were able to neutralize the telepathic ability of the Uyo.  This neutralized and destroyed all known colonies in a single generation." }
	}

	questions[40000] = {
		action="jump", goto=40001,
		player="Tell us about the ancients.",
		alien={"The Ancients or the eternal ones are energy beings.  They have left this space-time continuum."}
	}

	questions[40001] = {
		action="branch",
		choices = {
			{ text="What were the Ancients like?", goto=41000 },
			{ text="What did the Ancients do?", goto=42000 },
			{ text="Where did the Ancients go?", goto=43000 },
			{ text="Do you know how to contact the Ancients?", goto=44000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[41000] = {
		action="jump", goto=40001,
		player="",
		alien={"Unknown.  Description lost over time." }
	}
	questions[42000] = {
		action="jump", goto=40001,
		player="",
		alien={"Explore and expand their territory.  Turn inwards and improve themselves.  Isolate themselves from influencing other races.  Declare war when forced.  We emulate their behavior as best we can." }
	}
	questions[43000] = {
		action="jump", goto=40001,
		player="",
		alien={"Unknown.  Beyond our understanding." }
	}
	questions[44000] = {
		action="jump", goto=44001,
		player="",
		alien={"This may be impossible.  We could communicate with them only in ancient times when our minds were at full strength and then only at research sites.  These sites have been lost.  No evidence has been seen of any Ancient activity in past eons." }
	}
	questions[44001] = {
		action="jump", goto=40001,
		player="Where can we find Ancient research sites?",
		alien={"Search out Ancient ruins.  Contact other alien races.  Ancients did not congregate for social reasons, but Ancient research sites often misnamed cities of the Ancients contained their most advanced technology and operated as communication junctions." }
	}
	questions[50000] = {
		action="branch",
		choices = { 
			{ text="What can we do to stop the virus?", goto=60000 },
			{ text="<Back>", goto=1 } 
		}
	}

	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"The eternals gifts are not completely restored by that which you have returned to us.  In ancient times we could feel the presence of the destroyers a galaxy span's away.  We must find the destroyers.  They controlled this virus in ancient times.  They may have returned again.  Find similar Ancient technology.  Find the Ancients.  Find the source of the Uyo technology." }
	}
	questions[60001] = {
		action="branch",
		choices = {
			{ text="How may we find Ancient technology?", goto=61000 },
			{ text="How may we find the Ancients?", goto=62000 },
			{ text="How may we find the source of the Uyo technology?", goto=63000 },
			{ text="Tell us about the virus or 'the contagion.'", goto=64000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[61000] = {
		action="jump", goto=60001,
		player="",
		alien={"Search out Ancient ruins.  Contact other alien races.  Ancients did not congregate for social reasons, but Ancient research sites often misnamed 'Cities of the Ancients' contained their most advanced technology." }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="",
		alien={"This may be impossible.  The eternal ones could shape matter but they themselves were never seen.  They manipulated stars, changed the mass of planets, wiped out whole solar systems where the destroyers gained strongholds.  We could communicate with them only in ancient times when our minds were at full strength and then only at research sites.  These sites have been lost.  No evidence has been seen of any Ancient activity in past eons." }
	}

	questions[63000] = {
		action="jump", goto=63001,
		player="",
		alien={"Unknown.  This virus is most likely a technological remnant of their existence.  Our mission now is to search the galaxy to find them and stop them if they still exist.  You may help us find them but only scout.  We alone have any hope of opposing them.  Report to us any progress." }
	}
	questions[63001] = {
		action="jump", goto=60001,
		player="<More>",
		alien={"The Uyo have only one remaining base that has yet to be penetrated and destroyed.  All other locations have been sterilized when defenses fell.  Only the base at the star that you know of as Cermait 6 has yet to be destroyed." }
	}
	questions[64000] = {
		action="jump", goto=64001,
		player="",
		alien={"All we know is that it is a stealthed nano assembler with two functions.  The first is to damage nothing with the exception of sentient beings.  When sentient beings are detected, create a continual flood of custom biological bacteria to reduce sentient populations and render them susceptible to telepathic control." }
	}
	questions[64001] = {
		action="branch",
		choices = {
			{ text="Do you know how to vaccinate against it?", goto=64100 },
			{ text="What does the virus do to the Minex?", goto=64200 },
			{ text="Do you know how to reverse the madness?", goto=64300 },
			{ text="Do you know how to cure it?", goto=64400 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[64100] = {
		action="jump", goto=64001,
		player="",
		alien={"No." }
	}
	questions[64200] = {
		action="jump", goto=64001,
		player="",
		alien={"It kills Minex instantly with no dormancy period.  Detection of infected areas and sterilization is easy for us." }
	}
	questions[64300] = {
		action="jump", goto=64001,
		player="",
		alien={"No." }
	}
	questions[64400] = {
		action="jump", goto=64001,
		player="",
		alien={"Find and ask the Ancients.  Only they know." }
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
	    RESPONSE = "No more warnings will be given."
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
			{ text="OTHER RACES", goto=10000 },
			{ text="THE PAST", goto=10000 },
			{ text="THE ANCIENTS", goto=10000 },
			{ text="GENERAL INFO", goto=10000 }
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

