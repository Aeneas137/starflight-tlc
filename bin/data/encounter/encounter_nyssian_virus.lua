--[[
	ENCOUNTER SCRIPT FILE: NYSSIAN VIRUS

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
		alien={"Reverence appropriately placed acquires shocking momentum.  Perfection would negate all need, but the universe is collapsing.","Abundance of concern at the most appropriate time.","Appropriate understanding of your role and everyone's need is commendable.","I am Nyssian.  Your submission to truth will be repaid during this dark hour."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"Reverence appropriately placed acquires shocking momentum.  Perfection would negate all need, but the universe is collapsing.","Abundance of concern at the most appropriate time.","Appropriate understanding of your role and everyone's need is commendable.","I am Nyssian.  Your submission to truth will be repaid during this dark hour."} 	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"Reverence appropriately placed acquires shocking momentum.  Perfection would negate all need, but the universe is collapsing.","Abundance of concern at the most appropriate time.","Appropriate understanding of your role and everyone's need is commendable.","I am Nyssian.  Your submission to truth will be repaid during this dark hour."} 	}
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"Reverence appropriately placed acquires shocking momentum.  Perfection would negate all need, but the universe is collapsing.","Abundance of concern at the most appropriate time.","Appropriate understanding of your role and everyone's need is commendable.","I am Nyssian.  Your submission to truth will be repaid during this dark hour."} 	}
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"Reverence appropriately placed acquires shocking momentum.  Perfection would negate all need, but the universe is collapsing.","Abundance of concern at the most appropriate time.","Appropriate understanding of your role and everyone's need is commendable.","I am Nyssian.  Your submission to truth will be repaid during this dark hour."} 	}

		
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"Indeed your concern is appropriate."} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien={"'Fayai"} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"No harm shall befall you oh supplicant."} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"'Tyana via legan."} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"Indeed."} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"Be welcome here."} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"No harm shall befall you oh supplicant."} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"Wisdom and recognition is a rare combination","Nothing will be denied."} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"No harm shall befall you oh supplicant."} }

		
	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD

	questions[50000] = {
		action="branch",
		choices = {
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="What type of freak are you?",  goto=51000 },
			{ text="Where is your home world?", goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=51001,
		player="",
		alien={"Wisdom drifts on endless winds, pausing, and is gone."}
	}
	questions[51001] = {
		action="terminate",
		player="What does that mean?",
		alien={"<Silence>"}
	}
	
	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"Impertinent question, yet allowances must be made during this deadly era.  I am an ambassador piloting this grand Nyssian explorer vessel.  I do have some general information about the infection plaguing the sector, but I am willing to repeat information about ourselves."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Many aspects of the all can be seen in the other fragments of all.  I learn from others in the same way that I learn from you and your race: by every action you take, your every gesture and motion, your questions, your desires and hidden motives.  If you wish current event news instead, please address this as a general inquiry."}
	}
	questions[30000] = {
		action="jump", goto=31001,
		player="What can you tell us about the past?",
		alien={"Many things to we know, seeker of the wastes, and many things I will reveal for the asking.  Are you interested in the Great War, the Golden Ages, the Ancients, Ourselves, or perhaps more about the history of your own people of the Empire?"}
	}
	questions[52000] = {
		action="jump", goto=1,
		player="",
		alien={"Our colony worlds are legion.  Those who lack the material wealth to achieve this material utopia as seen in this vessel continue to strive materialistically on them to this day.  I do not bother with them, neither should you."}
	}
	
	questions[20001] = {
		action="jump", goto=20002,
		player="<More>",
		alien={"The Tafel balance on the knife's edge of good and evil.  Much twisted by greed and control are they, yet they still maintain the openness of children and accept teaching.  As difficult as they are to reach, I still try to instruct them. Through their cybernetics the Tafel achieve a degree of information sharing and insightful deduction unmatched by anyone, yet they're embrace of the machine mind hath left them blind spots to numerous to count."}
	}
	questions[20002] = {
		action="jump", goto=20003,
		player="<More>",
		alien={"The Minex are a race almost as ancient as our own.  Great strain have they endured in the conflaguration of species, the great war of ancient times.  I worry about our brothers as they have fallen into fear and wish not to interact with others.  The day will arrive when the Minex conquer their fear and on this day the eighth Golden age will arrive and the entire sector will unite in peace and prosperity."}
	}
	questions[20003] = {
		action="jump", goto=20004,
		player="<More>",
		alien={"The Barzhon are a courageous and warlike race undergoing a minimal civil war of their own.  Great strength and cunning are seen from them and they treat other races with honor and respect.  Their opposition does not share their morals however."}
	}
	questions[20004] = {
		action="jump", goto=20005,
		player="<More>",
		alien={"A good percentage of the Barzhon population simply rebelled 40 years ago and have survived to this day in hiding.  May the privateers of other races have joined them over the years and a menace they are to those who they perceive as new or weak.  This opposition is known as The Coalition, and their once high-minded principles have degraded into open piracy to obtain the technologies and resources they need to continue.  I have trained them to think otherwise of me, yet you may also have to train them."}
	}
	questions[20005] = {
		action="jump", goto=20006,
		player="<More>",
		alien={"The Spemin are an overly friendly childlike race who wishes the acceptance of all.  Their misfortune of isolation between Minex and Thrynn space has not dampened their zeal for exploration.  Their immaturity is obvious, yet surprising knowledge have they uncovered."}
	}
	questions[20006] = {
		action="jump", goto=20007,
		player="<More>",
		alien={"The Thrynn are disdainful of others, until you prove to them your militaristic strength.  Their race and the Elowan appeared only a few millennia ago yet have been locked in an eternal conflict with each other." }
	}
	questions[20007] = {
		action="jump", goto=20008,
		player="<More>",
		alien={"Neither the Thrynn and Elowan has much concern for anything other than the conflict between themselves anymore, yet neither has either side been capable of making progress against the other." }
	}
	questions[20008] = {
		action="jump", goto=20009,
		player="<More>",
		alien={"The Thrynn militaristic code values technology and industry, while the Elowan value secrecy and defense.  The majority of skirmishes begin with the Thrynn launching barely adequate offensive forces too early against the isolationist Elowan." }
	}
	questions[20009] = {
		action="jump", goto=1,
		player="<More>",
		alien={"The feud between the Thrynn and Elowan has spanned an almost infinite number of skirmishes plus several major battles.  At several times both races have driven each other to the brink of extinction yet somehow both continue to survive.  The powerful defenses and tightly concentrated fleets of the Elowan eventually win through concentration of firepower in their battles." }
	}
		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about Nyssian history?",  goto=11000 },
			{ text="What can you tell us about Nyssian biology?", goto=12000 },
			{ text="What is your agenda?", goto=13000 },
			{ text="Can you tell us more about your technology?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="",
		alien={"As the universe exists, so have the Nyssian existed, drifting along infinite paths towards the continual, twisting, changing future." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="",
		alien={"Nothing other than what your own eyes reveal.  More profitable inqueries lie elsewhere." }
	}
	questions[13000] = {
		action="jump", goto=13101,
		player="",
		alien={"I drift through the stars for the winds pull me, acquiring knowledge and wisdom as I go.  Our oracle directs the paths to the infinite the achievable impossibility.  Those of us who remain in this mortal realm are those who are still seeking.  I only trade in wisdom.  For material concerns, seek out others." }
	}
	questions[14000] = {
		action="jump", goto=11001,
		player="",
		alien={"Our technology for dealing with the physical world was perfected as far as we wish it to be back in the ancient past in the third golden age.  Once material desires are met, is foolishness to continue to pursue that beyond what what you as an individual need and want." }
	}
	
	questions[13101] = {
		action="branch",
		choices = {
			{ text="So you are some type of mystic?",  goto=13110 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[13110] = {
		action="jump", goto=13112,
		player="",
		alien={"Yes." }
	}
	questions[13112] = {
		action="branch",
		choices = {
			{ text="Mystics are self-deluded individuals who do not accept the objective reality of physical laws in a physical universe.",  goto=13113 },
			{ text="Reality is harsh.   Mystics die when others make demands on them.",  goto=13114 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[13113] = {
		action="terminate",
		player="",
		alien={"Acceptance of physical laws is a requirement, however acceptance of those close minded to possibility is not.  Return when your opaqueness of vision has changed." }
	}
	questions[13114] = {
		action="attack",
		player="",
		alien={"<Silence>" }
	}
	
	questions[31001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Great War.",  goto=31100 },
			{ text="Tell us about the Golden Ages.",  goto=31200 },
			{ text="<More>",  goto=31002 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31002] = {
		action="branch",
		choices = {
			{ text="Tell us about the Ancients.",  goto=40000 },
			{ text="Tell us about yourselves.",  goto=31400 },
			{ text="Tell us about the Empire.",  goto=31500 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[31100] = {
		action="jump", goto=31101,
		player="",
		alien={"The great war began many thousands of cycles ago, ending the seventh golden age. Ill winds of psychic energy poured in from coreward and drove madness into all the races.  We of course were immune but were unable to stop the downfall of many civilizations." }
	}
	questions[31200] = {
		action="jump", goto=31001,
		player="",
		alien={"The study of these periods is extensive and long does not have relevance to activities today other than the demonstratable rise and fall of high civilization among the stars followed by a grand collapse time and time again. Another collapse draws nigh, or maybe a golden age?" }
	}
	questions[40000] = {
		action="jump", goto=31301,
		player="",
		alien={"The ancient ones permeated this area billions upon billions of years ago before all of the races.  They obtained mental, physical and technological perfection in all forms until they simply existed, needing nothing, occupying the simple uniform ruins we find across the galaxy to this day." }
	}
	questions[31400] = {
		action="jump", goto=31401,
		player="",
		alien={"I am as all spacefaring Nyssian are, watchers of the grand dance.  How could there not be an audience for the greatest of all tragedies?" }
	}
	questions[31500] = {
		action="jump", goto=31501,
		player="",
		alien={"I am actually surprised to encounter one of your race, but we have knowledge of your people and your history.  You empirians formed an alliance of spacefaring races that survived little over a millennium." }
	}
	
	questions[31101] = {
		action="branch",
		choices = {
			{ text="Downfall of the civilizations?",  goto=31110 },
			{ text="How did the war start?", goto=31120 },
			{ text="What civilizations collapsed?", goto=31130 },
			{ text="What does any of that have to do with today?", goto=31140 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31110] = {
		action="jump", goto=31101,
		player="",
		alien={"Before this time great trading convoys filled the stars between the six great races.  These races were ourselves, the Minex, the Barzhon, the Sabion, the Bx, and the Transmodra." }
	}
	questions[31120] = {
		action="jump", goto=31101,
		player="",
		alien={"Peaceful neighbors suddenly attacked each other for no reason, and the fighting escalated to levels which threaten to blot out stars.  When the great shift occurred, and reason and understanding flowed back into the minds of sentients, three races were gone." }
	}
	questions[31130] = {
		action="jump", goto=31101,
		player="",
		alien={"These three races were the Sabion, the Bx, and the Transmodra were discovered to have been brought past the point of extinction, never to be heard from again.  Only we exist untouched by the consequences of this insanity." }
	}
	questions[31140] = {
		action="jump", goto=31101,
		player="",
		alien={"Learn from history, don't just listen.  The Barzhon still to this day fear open war and despite their warlike outlook, has yet to find a nerve to squash the open rebellion under their beaks.  The Minex retreated inwards to themselves and have yet to look outward again." }
	}
	questions[31301] = {
		action="branch",
		choices = {
			{ text="Where did the ancients come from?",  goto=31310 },
			{ text="Where did the ancients go?",  goto=31320 },
			{ text="<More>",  goto=31302 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31302] = {
		action="branch",
		choices = {
			{ text="How the ancients achieve perfection?",  goto=31330 },
			{ text="Why did they leave endurium behind?",  goto=31340 },
			{ text="Tell us about the Empire.",  goto=31350 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31310] = {
		action="jump", goto=31301,
		player="",
		alien={"From a galaxy far far away, a long long time ago.  Already the ancients were near their peak before they entered our galaxy.  The absolute uniformity of their ruins demonstrates this." }
	}
	questions[31320] = {
		action="jump", goto=31301,
		player="",
		alien={"They obtained perfection and jumped into a higher dimension, or else they became pure energy, or else they transcended time and space.  All answers are equally valid as finite beings cannot comprehend infinity." }
	}
	questions[31330] = {
		action="jump", goto=31302,
		player="",
		alien={"No mortal being has this knowledge but the Nyssian have many insights.  Primarily they developed incredible prophetic powers even to the point of being able to follow our existence in their distant future.  Proof of this is their decision to seed the galaxy with endurium." }
	}
	questions[31340] = {
		action="jump", goto=31302,
		player="",
		alien={"To jumpstart our own development by making it possible to develop interstellar spaceflight by lesser beings such as ourselves.  It is the goal of each of us to develop our own prophetic abilities and to one day obtain a similar state of perfection." }
	}
	questions[31350] = {
		action="jump", goto=31302,
		player="",
		alien={"No race has the answer to this question, as even in the chronicles of the ancient Leghk vague to the point of mirroring the observations of races today.  We know they were once threatened by a demonic entity or race, and that they developed incredible mental powers to survive." }
	}
	
	questions[31401] = {
		action="branch",
		choices = {
			{ text="Can you tell us about the Nyssian people, not just you?",  goto=31410 },
			{ text="How many crew does one of your ships hold?",  goto=31420 },
			{ text="What to your people trade?",  goto=31430 },
			{ text="What kind of government does your people have?",  goto=31440 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31410] = {
		action="jump", goto=31401,
		player="",
		alien={"Dirt grubbing money pinchers, the lot of us.  In early times our race attempted to build huge commercial interstellar enterprises, great concordances of sentiants.  Each time war tore down what was built.  Finally some of us learned and traveled to develop the mind only." }
	}
	questions[31420] = {
		action="jump", goto=31401,
		player="",
		alien={"Unlike your primitive vessel, one.  The progression of all societies is to concentrate more and more power in fewer and fewer individuals until each individual is all-powerful.  The only next step which our people pursue in all humility is godhood." }
	}
	questions[31430] = {
		action="jump", goto=31401,
		player="",
		alien={"Information in the form of knowledge or wisdom.  We are trading now.  Do not bother asking of crass physical possessions.  You do not have what I want and nothing of mine would be understandable by you." }
	}
	questions[31440] = {
		action="jump", goto=31401,
		player="",
		alien={"Right before my personal ascension to space a technological feudalism.  Since then who knows and who cares.  Dwellers of the heavens do not concern themselves with dirt-bound slaves." }
	}
	questions[31501] = {
		action="branch",
		choices = {
			{ text="Survived?  Past tense?  Do you know that all other humans are extinct?",  goto=31510 },
			{ text="You mentioned that my race formed an alliance?",  goto=31520 },
			{ text="Where did this empire exist?",  goto=31530 },
			{ text="<More>",  goto=31502 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31502] = {
		action="branch",
		choices = {
			{ text="Can you tell me anything about what humans are like?",  goto=31540 },
			{ text="Can you tell me anything of what the future holds?",  goto=31550 },
			{ text="Do you have any advice?",  goto=31560 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31510] = {
		action="jump", goto=31501,
		player="",
		alien={"Certainty?  No.  But I know that your race developed in a distant sector that was scouted by one of our ships 200 years ago and neither did he find any living humans nor had any indigenous alien race seen any of your race in the prior 900 years." }
	}
	questions[31520] = {
		action="jump", goto=31501,
		player="",
		alien={"Yes, a group of Thrynn, Elowan, some insectoid race and a slave race of synthetic mechanicals cooperated in a limited fashion over that period of time.  A moralistic crusade of anti-slavers destroyed your corrupt people, aided by a holy vanguard.  This is all we know." }
	}
	questions[31530] = {
		action="jump", goto=31501,
		player="",
		alien={"The ruins of your home world live in a dead region of space, too far a distance for one of your ships to travel without at least 12 times as much fuel as your maximum cargo capacity.  Fate transported your race here.  Your people must be satisfied with the here." }
	}
	questions[31540] = {
		action="jump", goto=31502,
		player="",
		alien={"Your provincial nature never attracted our attention in the past.  Our secondhand reports indicate that your people have remained static and refused to learn to travel great distances to learn and grow.  Lest you misunderstand, travel in the mind, not physical distance." }
	}
	questions[31550] = {
		action="jump", goto=31502,
		player="",
		alien={"Only your future and none other may be revealed to one.  A great future awaits you.  Audatious and precipitous action will be needed by you soon.  The great races gradually settle and peace and prosperity will resume based upon your actions." }
	}
	questions[31560] = {
		action="jump", goto=31502,
		player="",
		alien={"An individual sentient is a moat, a flick of dust in this great universe.  Only by accepting your insignificance and inability to affect anything will you and your people begin to learn from others." }
	}
	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"A dark age is now upon us all.  A hell-borne infection has appeared everywhere and threatens the existence of all life. Benefit from my wisdom quickly as I plan to depart this area." }
	}

	questions[60001] = {
		action="branch",
		choices = {
			{ text="What do you know about this infection?", goto=61000 },
			{ text="What brought about this dark age?", goto=62000 },
			{ text="Can this infection be stopped?", goto=63000 },
			{ text="Can you tell us anything else about the infection?", goto=64000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"It is death, simultaneously destroying all without reservation." }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="",
		alien={"A mystic darkness now contaminates this region of space.  This is all that can be said.  No causes, no solutions, only hope that it will pass." }
	}
	questions[63000] = {
		action="jump", goto=60001,
		player="",
		alien={"No.  The virus which infects us all mutates drastically and is nearly immune to any types of radiation.  It is supernatural and could not have been created by any science nor evolved from any other form." }
	}
	questions[64000] = {
		action="jump", goto=60001,
		player="",
		alien={"Those who being spared death enter madness.  During these mad phases those near the Minex border go out of their way to attack the Minex.  We do not know the reason for this." }
	}
	questions[61001] = {
		action="branch",
		choices = {
			{ text="How could it spread everywhere before anyone noticed?    How long of an incubation period does it have?", goto=61100 },
			{ text="How does this infection spread if it causes death?", goto=61200 },
			{ text="Are your people working towards any cure?", goto=61300 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[61100] = {
		action="jump", goto=61001,
		player="",
		alien={"Incubation period?   Nothing can contain Vissah, the black wind of death that follows prosperity.  Sometimes she is war, others madness, this time she is pure death." }
	}
	questions[61200] = {
		action="jump", goto=61001,
		player="",
		alien={"The touch of Vissah does not kill all.  Some live but endure periods of madness, others are instantly destroyed.  Those aboard ships are usually spared.  Over three quarters of planet-bound infected simply die within hours." }
	}
	questions[61300] = {
		action="jump", goto=61001,
		player="",
		alien={"Science will not stop this.  Vissah will not be denied.  Maybe in time, the madness will pass.  The few survivors, if we have been choosen to survive will rebuild.  Nothing can stop fate, we may be choosen to vacate reality to make room for new forms." }
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
		alien={"Krryai the ancient way unveils the universe's only constant.  Uncertain yet predicted this encounter has been.  Respond now.", "Spiraling forces yet intersect.  Perfection would negate all need, but the universe is imperfect and extensive need remains.  Time draws short.", "Communication is a weary duty, yet all have their role to play.   May our wisdom yet save another from destruction?"} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Krryai the ancient way unveils the universe's only constant.  Uncertain yet predicted this encounter has been.  Respond now.", "Spiraling forces yet intersect.  Perfection would negate all need, but the universe is imperfect and extensive need remains.  Time draws short.", "Communication is a weary duty, yet all have their role to play.   May our wisdom yet save another from destruction?"} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Krryai the ancient way unveils the universe's only constant.  Uncertain yet predicted this encounter has been.  Respond now.", "Spiraling forces yet intersect.  Perfection would negate all need, but the universe is imperfect and extensive need remains.  Time draws short.", "Communication is a weary duty, yet all have their role to play.   May our wisdom yet save another from destruction?"} }
	greetings[4] = {
		action="",
		player="Dude, that is one funky ship you have there!",
		alien={"Krryai the ancient way unveils the universe's only constant.  Uncertain yet predicted this encounter has been.  Respond now.", "Spiraling forces yet intersect.  Perfection would negate all need, but the universe is imperfect and extensive need remains.  Time draws short.", "Communication is a weary duty, yet all have their role to play.   May our wisdom yet save another from destruction?"} }
	greetings[5] = {
		action="",
		player="How's it going, weird, umm ... something?",
		alien={"Krryai the ancient way unveils the universe's only constant.  Uncertain yet predicted this encounter has been.  Respond now.", "Spiraling forces yet intersect.  Perfection would negate all need, but the universe is imperfect and extensive need remains.  Time draws short.", "Communication is a weary duty, yet all have their role to play.   May our wisdom yet save another from destruction?"} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"Yes."} }
	statements[2] = {
		action="",
		player="Your ship appears very elaborate.  Do all those protrusions have some purpose?",
		alien={"Yes."} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"Trust is illusionary"} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"Limitations are illusionary, but your contemplation of this truth is commendable."} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"No interest is paid to our young.","Distractions are irrelevent."} }
		 


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 

	questions[50000] = {
		action="branch",
		choices = {
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="What type of freak are you?",  goto=51000 },
			{ text="Where is your home world?", goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=51001,
		player="",
		alien={"Wisdom drifts on endless winds, pausing, and is gone."}
	}
	questions[51001] = {
		action="terminate",
		player="What does that mean?",
		alien={"<Silence>"}
	}
	
	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"Impertinent question, yet allowances must be made during this deadly era.  I am an ambassador piloting this grand Nyssian explorer vessel.  I do have some general information about the infection plaguing the sector, but I am willing to repeat information about ourselves."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Many aspects of the all can be seen in the other fragments of all.  I learn from others in the same way that I learn from you and your race: by every action you take, your every gesture and motion, your questions, your desires and hidden motives.  If you wish current event news instead, please address this as a general inquiry."}
	}
	questions[30000] = {
		action="jump", goto=31001,
		player="What can you tell us about the past?",
		alien={"Many things to we know, seeker of the wastes, and many things I will reveal for the asking.  Are you interested in the Great War, the Golden Ages, the Ancients, Ourselves, or perhaps more about the history of your own people of the Empire?"}
	}
	questions[52000] = {
		action="jump", goto=1,
		player="",
		alien={"Our colony worlds are legion.  Those who lack the material wealth to achieve this material utopia as seen in this vessel continue to strive materialistically on them to this day.  I do not bother with them, neither should you."}
	}
	
	questions[20001] = {
		action="jump", goto=20002,
		player="<More>",
		alien={"The Tafel balance on the knife's edge of good and evil.  Much twisted by greed and control are they, yet they still maintain the openness of children and accept teaching.  As difficult as they are to reach, I still try to instruct them. Through their cybernetics the Tafel achieve a degree of information sharing and insightful deduction unmatched by anyone, yet they're embrace of the machine mind hath left them blind spots to numerous to count."}
	}
	questions[20002] = {
		action="jump", goto=20003,
		player="<More>",
		alien={"The Minex are a race almost as ancient as our own.  Great strain have they endured in the conflaguration of species, the great war of ancient times.  I worry about our brothers as they have fallen into fear and wish not to interact with others.  The day will arrive when the Minex conquer their fear and on this day the eighth Golden age will arrive and the entire sector will unite in peace and prosperity."}
	}
	questions[20003] = {
		action="jump", goto=20004,
		player="<More>",
		alien={"The Barzhon are a courageous and warlike race undergoing a minimal civil war of their own.  Great strength and cunning are seen from them and they treat other races with honor and respect.  Their opposition does not share their morals however."}
	}
	questions[20004] = {
		action="jump", goto=20005,
		player="<More>",
		alien={"A good percentage of the Barzhon population simply rebelled 40 years ago and have survived to this day in hiding.  May the privateers of other races have joined them over the years and a menace they are to those who they perceive as new or weak.  This opposition is known as The Coalition, and their once high-minded principles have degraded into open piracy to obtain the technologies and resources they need to continue.  I have trained them to think otherwise of me, yet you may also have to train them."}
	}
	questions[20005] = {
		action="jump", goto=20006,
		player="<More>",
		alien={"The Spemin are an overly friendly childlike race who wishes the acceptance of all.  Their misfortune of isolation between Minex and Thrynn space has not dampened their zeal for exploration.  Their immaturity is obvious, yet surprising knowledge have they uncovered."}
	}
	questions[20006] = {
		action="jump", goto=20007,
		player="<More>",
		alien={"The Thrynn are disdainful of others, until you prove to them your militaristic strength.  Their race and the Elowan appeared only a few millennia ago yet have been locked in an eternal conflict with each other." }
	}
	questions[20007] = {
		action="jump", goto=20008,
		player="<More>",
		alien={"Neither the Thrynn and Elowan has much concern for anything other than the conflict between themselves anymore, yet neither has either side been capable of making progress against the other." }
	}
	questions[20008] = {
		action="jump", goto=20009,
		player="<More>",
		alien={"The Thrynn militaristic code values technology and industry, while the Elowan value secrecy and defense.  The majority of skirmishes begin with the Thrynn launching barely adequate offensive forces too early against the isolationist Elowan." }
	}
	questions[20009] = {
		action="jump", goto=1,
		player="<More>",
		alien={"The feud between the Thrynn and Elowan has spanned an almost infinite number of skirmishes plus several major battles.  At several times both races have driven each other to the brink of extinction yet somehow both continue to survive.  The powerful defenses and tightly concentrated fleets of the Elowan eventually win through concentration of firepower in their battles." }
	}
		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about Nyssian history?",  goto=11000 },
			{ text="What can you tell us about Nyssian biology?", goto=12000 },
			{ text="What is your agenda?", goto=13000 },
			{ text="Can you tell us more about your technology?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="",
		alien={"As the universe exists, so have the Nyssian existed, drifting along infinite paths towards the continual, twisting, changing future." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="",
		alien={"Nothing other than what your own eyes reveal.  More profitable inqueries lie elsewhere." }
	}
	questions[13000] = {
		action="jump", goto=13101,
		player="",
		alien={"I drift through the stars for the winds pull me, acquiring knowledge and wisdom as I go.  Our oracle directs the paths to the infinite the achievable impossibility.  Those of us who remain in this mortal realm are those who are still seeking.  I only trade in wisdom.  For material concerns, seek out others." }
	}
	questions[14000] = {
		action="jump", goto=11001,
		player="",
		alien={"Our technology for dealing with the physical world was perfected as far as we wish it to be back in the ancient past in the third golden age.  Once material desires are met, is foolishness to continue to pursue that beyond what what you as an individual need and want." }
	}
	
	questions[13101] = {
		action="branch",
		choices = {
			{ text="So you are some type of mystic?",  goto=13110 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[13110] = {
		action="jump", goto=13112,
		player="",
		alien={"Yes." }
	}
	questions[13112] = {
		action="branch",
		choices = {
			{ text="Mystics are self-deluded individuals who do not accept the objective reality of physical laws in a physical universe.",  goto=13113 },
			{ text="Reality is harsh.   Mystics die when others make demands on them.",  goto=13114 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[13113] = {
		action="terminate",
		player="",
		alien={"Acceptance of physical laws is a requirement, however acceptance of those close minded to possibility is not.  Return when your opaqueness of vision has changed." }
	}
	questions[13114] = {
		action="attack",
		player="",
		alien={"<Silence>" }
	}
	
	questions[31001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Great War.",  goto=31100 },
			{ text="Tell us about the Golden Ages.",  goto=31200 },
			{ text="<More>",  goto=31002 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31002] = {
		action="branch",
		choices = {
			{ text="Tell us about the Ancients.",  goto=40000 },
			{ text="Tell us about yourselves.",  goto=31400 },
			{ text="Tell us about the Empire.",  goto=31500 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[31100] = {
		action="jump", goto=31101,
		player="",
		alien={"The great war began many thousands of cycles ago, ending the seventh golden age. Ill winds of psychic energy poured in from coreward and drove madness into all the races.  We of course were immune but were unable to stop the downfall of many civilizations." }
	}
	questions[31200] = {
		action="jump", goto=31001,
		player="",
		alien={"The study of these periods is extensive and long does not have relevance to activities today other than the demonstratable rise and fall of high civilization among the stars followed by a grand collapse time and time again. Another collapse draws nigh, or maybe a golden age?" }
	}
	questions[40000] = {
		action="jump", goto=31301,
		player="",
		alien={"The ancient ones permeated this area billions upon billions of years ago before all of the races.  They obtained mental, physical and technological perfection in all forms until they simply existed, needing nothing, occupying the simple uniform ruins we find across the galaxy to this day." }
	}
	questions[31400] = {
		action="jump", goto=31401,
		player="",
		alien={"I am as all spacefaring Nyssian are, watchers of the grand dance.  How could there not be an audience for the greatest of all tragedies?" }
	}
	questions[31500] = {
		action="jump", goto=31501,
		player="",
		alien={"I am actually surprised to encounter one of your race, but we have knowledge of your people and your history.  You empirians formed an alliance of spacefaring races that survived little over a millennium." }
	}
	
	questions[31101] = {
		action="branch",
		choices = {
			{ text="Downfall of the civilizations?",  goto=31110 },
			{ text="How did the war start?", goto=31120 },
			{ text="What civilizations collapsed?", goto=31130 },
			{ text="What does any of that have to do with today?", goto=31140 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31110] = {
		action="jump", goto=31101,
		player="",
		alien={"Before this time great trading convoys filled the stars between the six great races.  These races were ourselves, the Minex, the Barzhon, the Sabion, the Bx, and the Transmodra." }
	}
	questions[31120] = {
		action="jump", goto=31101,
		player="",
		alien={"Peaceful neighbors suddenly attacked each other for no reason, and the fighting escalated to levels which threaten to blot out stars.  When the great shift occurred, and reason and understanding flowed back into the minds of sentients, three races were gone." }
	}
	questions[31130] = {
		action="jump", goto=31101,
		player="",
		alien={"These three races were the Sabion, the Bx, and the Transmodra were discovered to have been brought past the point of extinction, never to be heard from again.  Only we exist untouched by the consequences of this insanity." }
	}
	questions[31140] = {
		action="jump", goto=31101,
		player="",
		alien={"Learn from history, don't just listen.  The Barzhon still to this day fear open war and despite their warlike outlook, has yet to find a nerve to squash the open rebellion under their beaks.  The Minex retreated inwards to themselves and have yet to look outward again." }
	}
	questions[31301] = {
		action="branch",
		choices = {
			{ text="Where did the ancients come from?",  goto=31310 },
			{ text="Where did the ancients go?",  goto=31320 },
			{ text="<More>",  goto=31302 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31302] = {
		action="branch",
		choices = {
			{ text="How the ancients achieve perfection?",  goto=31330 },
			{ text="Why did they leave endurium behind?",  goto=31340 },
			{ text="Tell us about the Empire.",  goto=31350 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31310] = {
		action="jump", goto=31301,
		player="",
		alien={"From a galaxy far far away, a long long time ago.  Already the ancients were near their peak before they entered our galaxy.  The absolute uniformity of their ruins demonstrates this." }
	}
	questions[31320] = {
		action="jump", goto=31301,
		player="",
		alien={"They obtained perfection and jumped into a higher dimension, or else they became pure energy, or else they transcended time and space.  All answers are equally valid as finite beings cannot comprehend infinity." }
	}
	questions[31330] = {
		action="jump", goto=31302,
		player="",
		alien={"No mortal being has this knowledge but the Nyssian have many insights.  Primarily they developed incredible prophetic powers even to the point of being able to follow our existence in their distant future.  Proof of this is their decision to seed the galaxy with endurium." }
	}
	questions[31340] = {
		action="jump", goto=31302,
		player="",
		alien={"To jumpstart our own development by making it possible to develop interstellar spaceflight by lesser beings such as ourselves.  It is the goal of each of us to develop our own prophetic abilities and to one day obtain a similar state of perfection." }
	}
	questions[31350] = {
		action="jump", goto=31302,
		player="",
		alien={"No race has the answer to this question, as even in the chronicles of the ancient Leghk vague to the point of mirroring the observations of races today.  We know they were once threatened by a demonic entity or race, and that they developed incredible mental powers to survive." }
	}
	
	questions[31401] = {
		action="branch",
		choices = {
			{ text="Can you tell us about the Nyssian people, not just you?",  goto=31410 },
			{ text="How many crew does one of your ships hold?",  goto=31420 },
			{ text="What to your people trade?",  goto=31430 },
			{ text="What kind of government does your people have?",  goto=31440 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31410] = {
		action="jump", goto=31401,
		player="",
		alien={"Dirt grubbing money pinchers, the lot of us.  In early times our race attempted to build huge commercial interstellar enterprises, great concordances of sentiants.  Each time war tore down what was built.  Finally some of us learned and traveled to develop the mind only." }
	}
	questions[31420] = {
		action="jump", goto=31401,
		player="",
		alien={"Unlike your primitive vessel, one.  The progression of all societies is to concentrate more and more power in fewer and fewer individuals until each individual is all-powerful.  The only next step which our people pursue in all humility is godhood." }
	}
	questions[31430] = {
		action="jump", goto=31401,
		player="",
		alien={"Information in the form of knowledge or wisdom.  We are trading now.  Do not bother asking of crass physical possessions.  You do not have what I want and nothing of mine would be understandable by you." }
	}
	questions[31440] = {
		action="jump", goto=31401,
		player="",
		alien={"Right before my personal ascension to space a technological feudalism.  Since then who knows and who cares.  Dwellers of the heavens do not concern themselves with dirt-bound slaves." }
	}
	questions[31501] = {
		action="branch",
		choices = {
			{ text="Survived?  Past tense?  Do you know that all other humans are extinct?",  goto=31510 },
			{ text="You mentioned that my race formed an alliance?",  goto=31520 },
			{ text="Where did this empire exist?",  goto=31530 },
			{ text="<More>",  goto=31502 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31502] = {
		action="branch",
		choices = {
			{ text="Can you tell me anything about what humans are like?",  goto=31540 },
			{ text="Can you tell me anything of what the future holds?",  goto=31550 },
			{ text="Do you have any advice?",  goto=31560 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31510] = {
		action="jump", goto=31501,
		player="",
		alien={"Certainty?  No.  But I know that your race developed in a distant sector that was scouted by one of our ships 200 years ago and neither did he find any living humans nor had any indigenous alien race seen any of your race in the prior 900 years." }
	}
	questions[31520] = {
		action="jump", goto=31501,
		player="",
		alien={"Yes, a group of Thrynn, Elowan, some insectoid race and a slave race of synthetic mechanicals cooperated in a limited fashion over that period of time.  A moralistic crusade of anti-slavers destroyed your corrupt people, aided by a holy vanguard.  This is all we know." }
	}
	questions[31530] = {
		action="jump", goto=31501,
		player="",
		alien={"The ruins of your home world live in a dead region of space, too far a distance for one of your ships to travel without at least 12 times as much fuel as your maximum cargo capacity.  Fate transported your race here.  Your people must be satisfied with the here." }
	}
	questions[31540] = {
		action="jump", goto=31502,
		player="",
		alien={"Your provincial nature never attracted our attention in the past.  Our secondhand reports indicate that your people have remained static and refused to learn to travel great distances to learn and grow.  Lest you misunderstand, travel in the mind, not physical distance." }
	}
	questions[31550] = {
		action="jump", goto=31502,
		player="",
		alien={"Only your future and none other may be revealed to one.  A great future awaits you.  Audatious and precipitous action will be needed by you soon.  The great races gradually settle and peace and prosperity will resume based upon your actions." }
	}
	questions[31560] = {
		action="jump", goto=31502,
		player="",
		alien={"An individual sentient is a moat, a flick of dust in this great universe.  Only by accepting your insignificance and inability to affect anything will you and your people begin to learn from others." }
	}
	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"A dark age is now upon us all.  A hell-borne infection has appeared everywhere and threatens the existence of all life. Benefit from my wisdom quickly as I plan to depart this area." }
	}

	questions[60001] = {
		action="branch",
		choices = {
			{ text="What do you know about this infection?", goto=61000 },
			{ text="What brought about this dark age?", goto=62000 },
			{ text="Can this infection be stopped?", goto=63000 },
			{ text="Can you tell us anything else about the infection?", goto=64000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"It is death, simultaneously destroying all without reservation." }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="",
		alien={"A mystic darkness now contaminates this region of space.  This is all that can be said.  No causes, no solutions, only hope that it will pass." }
	}
	questions[63000] = {
		action="jump", goto=60001,
		player="",
		alien={"No.  The virus which infects us all mutates drastically and is nearly immune to any types of radiation.  It is supernatural and could not have been created by any science nor evolved from any other form." }
	}
	questions[64000] = {
		action="jump", goto=60001,
		player="",
		alien={"Those who being spared death enter madness.  During these mad phases those near the Minex border go out of their way to attack the Minex.  We do not know the reason for this." }
	}
	questions[61001] = {
		action="branch",
		choices = {
			{ text="How could it spread everywhere before anyone noticed?    How long of an incubation period does it have?", goto=61100 },
			{ text="How does this infection spread if it causes death?", goto=61200 },
			{ text="Are your people working towards any cure?", goto=61300 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[61100] = {
		action="jump", goto=61001,
		player="",
		alien={"Incubation period?   Nothing can contain Vissah, the black wind of death that follows prosperity.  Sometimes she is war, others madness, this time she is pure death." }
	}
	questions[61200] = {
		action="jump", goto=61001,
		player="",
		alien={"The touch of Vissah does not kill all.  Some live but endure periods of madness, others are instantly destroyed.  Those aboard ships are usually spared.  Over three quarters of planet-bound infected simply die within hours." }
	}
	questions[61300] = {
		action="jump", goto=61001,
		player="",
		alien={"Science will not stop this.  Vissah will not be denied.  Maybe in time, the madness will pass.  The few survivors, if we have been choosen to survive will rebuild.  Nothing can stop fate, we may be choosen to vacate reality to make room for new forms." }
	}



end

------------------------------------------------------------------------
-- HOSTILE DIALOGUE ----------------------------------------------------
------------------------------------------------------------------------
function HostileDialogue()
	--add as many player greetings as you want and one will be chosen randomly
	--VALID ACTIONS: terminate, attack
	greetings[1] = {
		action="terminate",
		player="This is captain [CAPTAIN] of the starship [SHIPNAME]. Identify yourselves immediately or be destroyed.",
		alien={"Krryai of the ancients spiral cascades of destruction","Nei-vaivai","Insanity cannot bargain","I will return when madness abates"} }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"Krryai of the ancients spiral cascades of destruction","Nei-vaivai","Insanity cannot bargain","I will return when madness abates"} }
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"Krryai of the ancients spiral cascades of destruction","Nei-vaivai","Insanity cannot bargain","I will return when madness abates"} }
	greetings[4] = {
		action="",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"Krryai of the ancients spiral cascades of destruction","Nei-vaivai","Insanity cannot bargain","I will return when madness abates"} }
	greetings[5] = {
		action="terminate",
		player="We require information. Comply or be destroyed.",
		alien={"Krryai of the ancients spiral cascades of destruction","Nei-vaivai","Insanity cannot bargain","I will return when madness abates"} }
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="terminate",
		player="Your ship is over-embellished and weak.",
		alien={"Krryai!  The reason starts it's inevitable decline","Violence drifts extinction showers"} }
	statements[2] = {
		action="terminate",
		player="What an ugly and worthless creature.",
		alien={"Physical is transient, and so are we."} }
	statements[3] = {
		action="terminate",
		player="Your ship looks like a flying garbage scow.",
		alien={"Nei-vaivai.  Madness comes, sanity flees"} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	
	questions[50000] = {
		action="branch",
		choices = {
			{ text="Can you tell us any current news?", goto=60000 },
			{ text="What type of freak are you?",  goto=51000 },
			{ text="Where is your home world?", goto=52000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=51001,
		player="",
		alien={"Wisdom drifts on endless winds, pausing, and is gone."}
	}
	questions[51001] = {
		action="terminate",
		player="What does that mean?",
		alien={"<Silence>"}
	}
	
	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"Impertinent question, yet allowances must be made during this deadly era.  I am an ambassador piloting this grand Nyssian explorer vessel.  I do have some general information about the infection plaguing the sector, but I am willing to repeat information about ourselves."}
	}
	questions[20000] = {
		action="jump", goto=20001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"Many aspects of the all can be seen in the other fragments of all.  I learn from others in the same way that I learn from you and your race: by every action you take, your every gesture and motion, your questions, your desires and hidden motives.  If you wish current event news instead, please address this as a general inquiry."}
	}
	questions[30000] = {
		action="jump", goto=31001,
		player="What can you tell us about the past?",
		alien={"Many things to we know, seeker of the wastes, and many things I will reveal for the asking.  Are you interested in the Great War, the Golden Ages, the Ancients, Ourselves, or perhaps more about the history of your own people of the Empire?"}
	}
	questions[52000] = {
		action="jump", goto=1,
		player="",
		alien={"Our colony worlds are legion.  Those who lack the material wealth to achieve this material utopia as seen in this vessel continue to strive materialistically on them to this day.  I do not bother with them, neither should you."}
	}
	
	questions[20001] = {
		action="jump", goto=20002,
		player="<More>",
		alien={"The Tafel balance on the knife's edge of good and evil.  Much twisted by greed and control are they, yet they still maintain the openness of children and accept teaching.  As difficult as they are to reach, I still try to instruct them. Through their cybernetics the Tafel achieve a degree of information sharing and insightful deduction unmatched by anyone, yet they're embrace of the machine mind hath left them blind spots to numerous to count."}
	}
	questions[20002] = {
		action="jump", goto=20003,
		player="<More>",
		alien={"The Minex are a race almost as ancient as our own.  Great strain have they endured in the conflaguration of species, the great war of ancient times.  I worry about our brothers as they have fallen into fear and wish not to interact with others.  The day will arrive when the Minex conquer their fear and on this day the eighth Golden age will arrive and the entire sector will unite in peace and prosperity."}
	}
	questions[20003] = {
		action="jump", goto=20004,
		player="<More>",
		alien={"The Barzhon are a courageous and warlike race undergoing a minimal civil war of their own.  Great strength and cunning are seen from them and they treat other races with honor and respect.  Their opposition does not share their morals however."}
	}
	questions[20004] = {
		action="jump", goto=20005,
		player="<More>",
		alien={"A good percentage of the Barzhon population simply rebelled 40 years ago and have survived to this day in hiding.  May the privateers of other races have joined them over the years and a menace they are to those who they perceive as new or weak.  This opposition is known as The Coalition, and their once high-minded principles have degraded into open piracy to obtain the technologies and resources they need to continue.  I have trained them to think otherwise of me, yet you may also have to train them."}
	}
	questions[20005] = {
		action="jump", goto=20006,
		player="<More>",
		alien={"The Spemin are an overly friendly childlike race who wishes the acceptance of all.  Their misfortune of isolation between Minex and Thrynn space has not dampened their zeal for exploration.  Their immaturity is obvious, yet surprising knowledge have they uncovered."}
	}
	questions[20006] = {
		action="jump", goto=20007,
		player="<More>",
		alien={"The Thrynn are disdainful of others, until you prove to them your militaristic strength.  Their race and the Elowan appeared only a few millennia ago yet have been locked in an eternal conflict with each other." }
	}
	questions[20007] = {
		action="jump", goto=20008,
		player="<More>",
		alien={"Neither the Thrynn and Elowan has much concern for anything other than the conflict between themselves anymore, yet neither has either side been capable of making progress against the other." }
	}
	questions[20008] = {
		action="jump", goto=20009,
		player="<More>",
		alien={"The Thrynn militaristic code values technology and industry, while the Elowan value secrecy and defense.  The majority of skirmishes begin with the Thrynn launching barely adequate offensive forces too early against the isolationist Elowan." }
	}
	questions[20009] = {
		action="jump", goto=1,
		player="<More>",
		alien={"The feud between the Thrynn and Elowan has spanned an almost infinite number of skirmishes plus several major battles.  At several times both races have driven each other to the brink of extinction yet somehow both continue to survive.  The powerful defenses and tightly concentrated fleets of the Elowan eventually win through concentration of firepower in their battles." }
	}
		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about Nyssian history?",  goto=11000 },
			{ text="What can you tell us about Nyssian biology?", goto=12000 },
			{ text="What is your agenda?", goto=13000 },
			{ text="Can you tell us more about your technology?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="",
		alien={"As the universe exists, so have the Nyssian existed, drifting along infinite paths towards the continual, twisting, changing future." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="",
		alien={"Nothing other than what your own eyes reveal.  More profitable inqueries lie elsewhere." }
	}
	questions[13000] = {
		action="jump", goto=13101,
		player="",
		alien={"I drift through the stars for the winds pull me, acquiring knowledge and wisdom as I go.  Our oracle directs the paths to the infinite the achievable impossibility.  Those of us who remain in this mortal realm are those who are still seeking.  I only trade in wisdom.  For material concerns, seek out others." }
	}
	questions[14000] = {
		action="jump", goto=11001,
		player="",
		alien={"Our technology for dealing with the physical world was perfected as far as we wish it to be back in the ancient past in the third golden age.  Once material desires are met, is foolishness to continue to pursue that beyond what what you as an individual need and want." }
	}
	
	questions[13101] = {
		action="branch",
		choices = {
			{ text="So you are some type of mystic?",  goto=13110 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[13110] = {
		action="jump", goto=13112,
		player="",
		alien={"Yes." }
	}
	questions[13112] = {
		action="branch",
		choices = {
			{ text="Mystics are self-deluded individuals who do not accept the objective reality of physical laws in a physical universe.",  goto=13113 },
			{ text="Reality is harsh.   Mystics die when others make demands on them.",  goto=13114 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[13113] = {
		action="terminate",
		player="",
		alien={"Acceptance of physical laws is a requirement, however acceptance of those close minded to possibility is not.  Return when your opaqueness of vision has changed." }
	}
	questions[13114] = {
		action="attack",
		player="",
		alien={"<Silence>" }
	}
	
	questions[31001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Great War.",  goto=31100 },
			{ text="Tell us about the Golden Ages.",  goto=31200 },
			{ text="<More>",  goto=31002 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31002] = {
		action="branch",
		choices = {
			{ text="Tell us about the Ancients.",  goto=40000 },
			{ text="Tell us about yourselves.",  goto=31400 },
			{ text="Tell us about the Empire.",  goto=31500 },
			{ text="<Back>", goto=1 }
		}
	}

	questions[31100] = {
		action="jump", goto=31101,
		player="",
		alien={"The great war began many thousands of cycles ago, ending the seventh golden age. Ill winds of psychic energy poured in from coreward and drove madness into all the races.  We of course were immune but were unable to stop the downfall of many civilizations." }
	}
	questions[31200] = {
		action="jump", goto=31001,
		player="",
		alien={"The study of these periods is extensive and long does not have relevance to activities today other than the demonstratable rise and fall of high civilization among the stars followed by a grand collapse time and time again. Another collapse draws nigh, or maybe a golden age?" }
	}
	questions[40000] = {
		action="jump", goto=31301,
		player="",
		alien={"The ancient ones permeated this area billions upon billions of years ago before all of the races.  They obtained mental, physical and technological perfection in all forms until they simply existed, needing nothing, occupying the simple uniform ruins we find across the galaxy to this day." }
	}
	questions[31400] = {
		action="jump", goto=31401,
		player="",
		alien={"I am as all spacefaring Nyssian are, watchers of the grand dance.  How could there not be an audience for the greatest of all tragedies?" }
	}
	questions[31500] = {
		action="jump", goto=31501,
		player="",
		alien={"I am actually surprised to encounter one of your race, but we have knowledge of your people and your history.  You empirians formed an alliance of spacefaring races that survived little over a millennium." }
	}
	
	questions[31101] = {
		action="branch",
		choices = {
			{ text="Downfall of the civilizations?",  goto=31110 },
			{ text="How did the war start?", goto=31120 },
			{ text="What civilizations collapsed?", goto=31130 },
			{ text="What does any of that have to do with today?", goto=31140 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31110] = {
		action="jump", goto=31101,
		player="",
		alien={"Before this time great trading convoys filled the stars between the six great races.  These races were ourselves, the Minex, the Barzhon, the Sabion, the Bx, and the Transmodra." }
	}
	questions[31120] = {
		action="jump", goto=31101,
		player="",
		alien={"Peaceful neighbors suddenly attacked each other for no reason, and the fighting escalated to levels which threaten to blot out stars.  When the great shift occurred, and reason and understanding flowed back into the minds of sentients, three races were gone." }
	}
	questions[31130] = {
		action="jump", goto=31101,
		player="",
		alien={"These three races were the Sabion, the Bx, and the Transmodra were discovered to have been brought past the point of extinction, never to be heard from again.  Only we exist untouched by the consequences of this insanity." }
	}
	questions[31140] = {
		action="jump", goto=31101,
		player="",
		alien={"Learn from history, don't just listen.  The Barzhon still to this day fear open war and despite their warlike outlook, has yet to find a nerve to squash the open rebellion under their beaks.  The Minex retreated inwards to themselves and have yet to look outward again." }
	}
	questions[31301] = {
		action="branch",
		choices = {
			{ text="Where did the ancients come from?",  goto=31310 },
			{ text="Where did the ancients go?",  goto=31320 },
			{ text="<More>",  goto=31302 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31302] = {
		action="branch",
		choices = {
			{ text="How the ancients achieve perfection?",  goto=31330 },
			{ text="Why did they leave endurium behind?",  goto=31340 },
			{ text="Tell us about the Empire.",  goto=31350 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31310] = {
		action="jump", goto=31301,
		player="",
		alien={"From a galaxy far far away, a long long time ago.  Already the ancients were near their peak before they entered our galaxy.  The absolute uniformity of their ruins demonstrates this." }
	}
	questions[31320] = {
		action="jump", goto=31301,
		player="",
		alien={"They obtained perfection and jumped into a higher dimension, or else they became pure energy, or else they transcended time and space.  All answers are equally valid as finite beings cannot comprehend infinity." }
	}
	questions[31330] = {
		action="jump", goto=31302,
		player="",
		alien={"No mortal being has this knowledge but the Nyssian have many insights.  Primarily they developed incredible prophetic powers even to the point of being able to follow our existence in their distant future.  Proof of this is their decision to seed the galaxy with endurium." }
	}
	questions[31340] = {
		action="jump", goto=31302,
		player="",
		alien={"To jumpstart our own development by making it possible to develop interstellar spaceflight by lesser beings such as ourselves.  It is the goal of each of us to develop our own prophetic abilities and to one day obtain a similar state of perfection." }
	}
	questions[31350] = {
		action="jump", goto=31302,
		player="",
		alien={"No race has the answer to this question, as even in the chronicles of the ancient Leghk vague to the point of mirroring the observations of races today.  We know they were once threatened by a demonic entity or race, and that they developed incredible mental powers to survive." }
	}
	
	questions[31401] = {
		action="branch",
		choices = {
			{ text="Can you tell us about the Nyssian people, not just you?",  goto=31410 },
			{ text="How many crew does one of your ships hold?",  goto=31420 },
			{ text="What to your people trade?",  goto=31430 },
			{ text="What kind of government does your people have?",  goto=31440 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31410] = {
		action="jump", goto=31401,
		player="",
		alien={"Dirt grubbing money pinchers, the lot of us.  In early times our race attempted to build huge commercial interstellar enterprises, great concordances of sentiants.  Each time war tore down what was built.  Finally some of us learned and traveled to develop the mind only." }
	}
	questions[31420] = {
		action="jump", goto=31401,
		player="",
		alien={"Unlike your primitive vessel, one.  The progression of all societies is to concentrate more and more power in fewer and fewer individuals until each individual is all-powerful.  The only next step which our people pursue in all humility is godhood." }
	}
	questions[31430] = {
		action="jump", goto=31401,
		player="",
		alien={"Information in the form of knowledge or wisdom.  We are trading now.  Do not bother asking of crass physical possessions.  You do not have what I want and nothing of mine would be understandable by you." }
	}
	questions[31440] = {
		action="jump", goto=31401,
		player="",
		alien={"Right before my personal ascension to space a technological feudalism.  Since then who knows and who cares.  Dwellers of the heavens do not concern themselves with dirt-bound slaves." }
	}
	questions[31501] = {
		action="branch",
		choices = {
			{ text="Survived?  Past tense?  Do you know that all other humans are extinct?",  goto=31510 },
			{ text="You mentioned that my race formed an alliance?",  goto=31520 },
			{ text="Where did this empire exist?",  goto=31530 },
			{ text="<More>",  goto=31502 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31502] = {
		action="branch",
		choices = {
			{ text="Can you tell me anything about what humans are like?",  goto=31540 },
			{ text="Can you tell me anything of what the future holds?",  goto=31550 },
			{ text="Do you have any advice?",  goto=31560 },
			{ text="<Back>", goto=31002 }
		}
	}
	questions[31510] = {
		action="jump", goto=31501,
		player="",
		alien={"Certainty?  No.  But I know that your race developed in a distant sector that was scouted by one of our ships 200 years ago and neither did he find any living humans nor had any indigenous alien race seen any of your race in the prior 900 years." }
	}
	questions[31520] = {
		action="jump", goto=31501,
		player="",
		alien={"Yes, a group of Thrynn, Elowan, some insectoid race and a slave race of synthetic mechanicals cooperated in a limited fashion over that period of time.  A moralistic crusade of anti-slavers destroyed your corrupt people, aided by a holy vanguard.  This is all we know." }
	}
	questions[31530] = {
		action="jump", goto=31501,
		player="",
		alien={"The ruins of your home world live in a dead region of space, too far a distance for one of your ships to travel without at least 12 times as much fuel as your maximum cargo capacity.  Fate transported your race here.  Your people must be satisfied with the here." }
	}
	questions[31540] = {
		action="jump", goto=31502,
		player="",
		alien={"Your provincial nature never attracted our attention in the past.  Our secondhand reports indicate that your people have remained static and refused to learn to travel great distances to learn and grow.  Lest you misunderstand, travel in the mind, not physical distance." }
	}
	questions[31550] = {
		action="jump", goto=31502,
		player="",
		alien={"Only your future and none other may be revealed to one.  A great future awaits you.  Audatious and precipitous action will be needed by you soon.  The great races gradually settle and peace and prosperity will resume based upon your actions." }
	}
	questions[31560] = {
		action="jump", goto=31502,
		player="",
		alien={"An individual sentient is a moat, a flick of dust in this great universe.  Only by accepting your insignificance and inability to affect anything will you and your people begin to learn from others." }
	}
	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"A dark age is now upon us all.  A hell-borne infection has appeared everywhere and threatens the existence of all life. Benefit from my wisdom quickly as I plan to depart this area." }
	}

	questions[60001] = {
		action="branch",
		choices = {
			{ text="What do you know about this infection?", goto=61000 },
			{ text="What brought about this dark age?", goto=62000 },
			{ text="Can this infection be stopped?", goto=63000 },
			{ text="Can you tell us anything else about the infection?", goto=64000 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[61000] = {
		action="jump", goto=61001,
		player="",
		alien={"It is death, simultaneously destroying all without reservation." }
	}
	questions[62000] = {
		action="jump", goto=60001,
		player="",
		alien={"A mystic darkness now contaminates this region of space.  This is all that can be said.  No causes, no solutions, only hope that it will pass." }
	}
	questions[63000] = {
		action="jump", goto=60001,
		player="",
		alien={"No.  The virus which infects us all mutates drastically and is nearly immune to any types of radiation.  It is supernatural and could not have been created by any science nor evolved from any other form." }
	}
	questions[64000] = {
		action="jump", goto=60001,
		player="",
		alien={"Those who being spared death enter madness.  During these mad phases those near the Minex border go out of their way to attack the Minex.  We do not know the reason for this." }
	}
	questions[61001] = {
		action="branch",
		choices = {
			{ text="How could it spread everywhere before anyone noticed?    How long of an incubation period does it have?", goto=61100 },
			{ text="How does this infection spread if it causes death?", goto=61200 },
			{ text="Are your people working towards any cure?", goto=61300 },
			{ text="<Back>", goto=60001 }
		}
	}
	questions[61100] = {
		action="jump", goto=61001,
		player="",
		alien={"Incubation period?   Nothing can contain Vissah, the black wind of death that follows prosperity.  Sometimes she is war, others madness, this time she is pure death." }
	}
	questions[61200] = {
		action="jump", goto=61001,
		player="",
		alien={"The touch of Vissah does not kill all.  Some live but endure periods of madness, others are instantly destroyed.  Those aboard ships are usually spared.  Over three quarters of planet-bound infected simply die within hours." }
	}
	questions[61300] = {
		action="jump", goto=61001,
		player="",
		alien={"Science will not stop this.  Vissah will not be denied.  Maybe in time, the madness will pass.  The few survivors, if we have been choosen to survive will rebuild.  Nothing can stop fate, we may be choosen to vacate reality to make room for new forms." }
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
