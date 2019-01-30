--[[
	ENCOUNTER SCRIPT FILE: THRYNN  WAR

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
		alien={"We are thynynthrynn, the shield of the thrynn confederacy.  We are the elite guard.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.  Why are you here?","In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.","This is shield unit Thryssanyn, second force guard of the Thrynn.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"We are thynynthrynn, the shield of the thrynn confederacy.  We are the elite guard.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.  Why are you here?","In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.","This is shield unit Thryssanyn, second force guard of the Thrynn.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates."} 	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"We are thynynthrynn, the shield of the thrynn confederacy.  We are the elite guard.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.  Why are you here?","In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.","This is shield unit Thryssanyn, second force guard of the Thrynn.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates."} 	}
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"We are thynynthrynn, the shield of the thrynn confederacy.  We are the elite guard.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.  Why are you here?","In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.","This is shield unit Thryssanyn, second force guard of the Thrynn.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates."} 	}
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"We are thynynthrynn, the shield of the thrynn confederacy.  We are the elite guard.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.  Why are you here?","In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.","This is shield unit Thryssanyn, second force guard of the Thrynn.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates."} 	}


		
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"A Prophet once declared it is the destiny of the Thrynn to rule the galaxy.  Of course the Prophet was Thrynn, but what does that matter?","Appropriate resolve and understanding are necessary for the survival of all individuals and species alike.","The Thrynn military is a formidable force.  Consider aiding our military machine, for the benefits to you would be incalculable."} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien={"A Prophet once declared it is the destiny of the Thrynn to rule the galaxy.  Of course the Prophet was Thrynn, but what does that matter?","Appropriate resolve and understanding are necessary for the survival of all individuals and species alike.","The Thrynn military is a formidable force.  Consider aiding our military machine, for the benefits to you would be incalculable."} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"A Prophet once declared it is the destiny of the Thrynn to rule the galaxy.  Of course the Prophet was Thrynn, but what does that matter?","Appropriate resolve and understanding are necessary for the survival of all individuals and species alike.","The Thrynn military is a formidable force.  Consider aiding our military machine, for the benefits to you would be incalculable."} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"A Prophet once declared it is the destiny of the Thrynn to rule the galaxy.  Of course the Prophet was Thrynn, but what does that matter?","Appropriate resolve and understanding are necessary for the survival of all individuals and species alike.","The Thrynn military is a formidable force.  Consider aiding our military machine, for the benefits to you would be incalculable."} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"A Prophet once declared it is the destiny of the Thrynn to rule the galaxy.  Of course the Prophet was Thrynn, but what does that matter?","Appropriate resolve and understanding are necessary for the survival of all individuals and species alike.","The Thrynn military is a formidable force.  Consider aiding our military machine, for the benefits to you would be incalculable."} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"A Prophet once declared it is the destiny of the Thrynn to rule the galaxy.  Of course the Prophet was Thrynn, but what does that matter?","Appropriate resolve and understanding are necessary for the survival of all individuals and species alike.","The Thrynn military is a formidable force.  Consider aiding our military machine, for the benefits to you would be incalculable."} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"A Prophet once declared it is the destiny of the Thrynn to rule the galaxy.  Of course the Prophet was Thrynn, but what does that matter?","Appropriate resolve and understanding are necessary for the survival of all individuals and species alike.","The Thrynn military is a formidable force.  Consider aiding our military machine, for the benefits to you would be incalculable."} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"A Prophet once declared it is the destiny of the Thrynn to rule the galaxy.  Of course the Prophet was Thrynn, but what does that matter?","Appropriate resolve and understanding are necessary for the survival of all individuals and species alike.","The Thrynn military is a formidable force.  Consider aiding our military machine, for the benefits to you would be incalculable."} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"A Prophet once declared it is the destiny of the Thrynn to rule the galaxy.  Of course the Prophet was Thrynn, but what does that matter?","Appropriate resolve and understanding are necessary for the survival of all individuals and species alike.","The Thrynn military is a formidable force.  Consider aiding our military machine, for the benefits to you would be incalculable."} }
		
	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD


	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"As your senses tell you, we Thrynn are a reptilian carnivorous race, warm-blooded, with binocular vision and an internal skeletons as you.  We are however oviperous."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races?",
		alien={"We are currently embroiled in a major conflict with the Minex.  We seek your aid in this endeavor."}
	}
	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about your history?",
		alien={"The colonization group which established this empire was sent out using an experimental artificial wormhole generating jump pod.  Unfortunately navigational coherency was lost and we have no idea how far or in what direction we traveled from.  Our colony ship contained the greatest leaders, scientists, and industrialists from our society."}
	}
	questions[30001] = {
		action="jump", goto=1,
		player="<More>",
		alien={"Numerous threats throughout our history have imperiled our people in this region of space.  Only by eliminating hostile races do we ensure our survival."}
	}
	questions[40000] = {
		action="jump", goto=1,
		player="Tell us about the Ancients.",
		alien={"There are a lot of myths concerning the ancient ones.  We do not waste our time with legends and stories. The only relevant information is that they have left behind lumps of high energy crystal.  We are most concerned with locating their ruins for their energy resource value." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="We demand that your race cease attacking the Elowan!",  goto=51000 },
			{ text="Where is your home world?", goto=52000 },
			{ text="Do you know anything about an unnatural virus?", goto=60000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=51001,
		player="",
		alien={"We already have.  Although Elowan weaponry is almost useless against the Minex, we have persuaded them to act as cannon fodder in the Minex' war against us."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="Where is your home world?",
		alien={"Our home world is located at Semias 3 - 5,66."}
	}
	questions[51001] = {
		action="branch",
		choices = {
			{ text="How were you able to convince the Elowan?",  goto=51100 },
			{ text="How goes the war against the Minex?", goto=51200 },
			{ text="Do you know why they have attacked you?", goto=51300 },
			{ text="What tactics do the Minex follow?", goto=51400 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[51100] = {
		action="jump", goto=51001,
		player="",
		alien={"Stress of extended war has produced highly accelerated natural selection and resulted in a reasonable Elowan.  The other races in this area are not as advanced in diplomacy as we Thrynn, and we have been able to take advantage of the Elowan survival drive with the new threats of the Minex to bring them on our side." }
	}
	questions[51200] = {
		action="jump", goto=51001,
		player="",
		alien={"We have very little news at present because we are still withstanding the initial onslaught of the Minex.  When their fleets start wearing thin we will retaliate before their shipyards can respond." }
	}
	questions[51300] = {
		action="jump", goto=51001,
		player="",
		alien={"One irrational xenophobic aquatic race is much like another..." }
	}
	questions[51400] = {
		action="jump", goto=51001,
		player="",
		alien={"The Minex blindly circle our territory with huge fleets and attack anything they run across.  Our coordinated counterattacks have wrecked vast devastation upon their numbers.  Beware, if we detect your ship attempting to salvage any vessel in our territory, we will respond with deadly force.  No tolerance is given to pirates." }
	}

	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"An insidious sickness has begun to infect our people as well as all other races.  The technology behind the sickness matches with artifacts found in extremely old ruins in this area.  We are investigating to discover who is responsible for uncovering and spreading this virus." }
	}
	questions[60001] = {
			action="branch",
			choices = {
				{ text="Have you discovered any leads to the source of the virus?", goto=61000 },
				{ text="What artifacts resemble the virus technology?", goto=62000 },
				{ text="Could the Minex be responsible?", goto=63000 },
				{ text="Could the Elowan be responsible?", goto=64000 },
				{ text="<Back>", goto=50000 }
			}
		}
		questions[61000] = {
			action="jump", goto=60001,
			player="",
			alien={"Not any definitive proof yet.  The guilty party would be a well traveled race and would themselves not bear any sign of infection.  They also would have much to gain by destabilizing this region.  Perhaps a newcomer, hmm?" }
		}
		questions[62000] = {
			action="jump", goto=60001,
			player="",
			alien={"Artifacts from the Bx.  They were known to scavenge and adapt nightmarish technologies taken from an underground city millions of years old.  If this virus originated from anywhere it would be there. The exact system location was lost after the Bar-Zhon war, but was known to be in an M class system on the outward edge of this region of space." }
		}
		questions[63000] = {
			action="jump", goto=60001,
			player="",
			alien={"Possible but unlikely.  Those infected and driven mad by the virus appear to go out of their way to find and attack the Minex.  Not a particularly wise trait to pursue if they were the guilty party.  Besides, the true guilty party would attempt to remain neutral to all and let the sickness ravage and weaken without drawing suspicion to themselves." }
		}
		questions[64000] = {
			action="jump", goto=60001,
			player="",
			alien={"No.  Elowan ships do not explore since they huddle together for mutual defense.  We have continued their spread for many years and they do not possess the intelligence to commit this crime.  Besides they are also infected." }
		}


	questions[11001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your society?",  goto=11000 },
			{ text="What does oviperous mean?", goto=12000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11101,
		player="What can you tell us about your society?",
		alien={"We are a practical people with a complete and total trust in the concept called fate.  With the goal of increasing the length our own species' survival, we have embraced in our social structure the concepts of progression, growth, survival of the fittest, and have a disdain for mercy of any type." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="What does oviperous mean?",
		alien={"Such matters are better left not discussed." }
	}

	
	questions[11101] = {
		action="branch",
		choices = {
			{ text="Do you think of yourselves as merciless?",  goto=11110 },
			{ text="What do you do with the poor, the outcasts, et cetera?",  goto=11120 },
			{ text="How is your society governed?",  goto=11130 },
			{ text="Such inhumanity is hard to imagine.",  goto=11140 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[11110] = {
		action="jump", goto=11101,
		player="Do you think of yourselves as merciless?",
		alien={"No, of course not.  Children are given a chance to grow and so is any process, individual, or philosophy which may at some time improve the strengths of society at some point in the future.  Unlike nature, we understand patience.  However like nature we have absolutely no tolerance for the weak." }
	}
	questions[11120] = {
		action="jump", goto=11101,
		player="What do you do with the poor, the outcasts, et cetera?",
		alien={"The very concept of welfare is abhorrent.  It is not always easy to accept the fact that the weak must die. But this is the way of the universe is it not?  Strengthening the week so they can survive only saps the strength of the strong and weakens all.  Would you work for an ungrateful, demanding mob for the rest of your life who think it is their right for you to work for them?" }
	}
	questions[11130] = {
		action="jump", goto=11101,
		player="How is your society governed?",
		alien={"Our government system has changed many times over the years.  Our system currently organized in a military hierarchy with extreme upward mobility based ability and nothing else.  Diplomatic skill, ability to form temporary alliances based on mutual goals is the key to success yet mavericks are also given a free hand." }
	}
	questions[11140] = {
		action="jump", goto=11141,
		player="Such inhumanity is ...",
		alien={"Wait, did you say human?  Your physical appearance matches our records of empire humanity." }
	}
	questions[11141] = {
		action="branch",
		choices = {
			{ text="What do you know about ancient humanity?",  goto=11142 },
			{ text="Do you know what happened to the Empire after we left?",  goto=11143 },
			{ text="Our ancestors trace our history to Noah 3.",  goto=11144 },
			{ text="So you were close allies with humanity in the past?",  goto=11145 },
			{ text="<Back>", goto=11101 }
		}
	}
	questions[11142] = {
		action="jump", goto=11141,
		player="What do you know about ancient humanity?",
		alien={"Humanity and the Thrynn once ruled a vast interstellar empire together and will do so again.  Aid us with your undistorted and effective empire technology and we will aid you in manpower and industrial might." }
	}
	questions[11143] = {
		action="jump", goto=11141,
		player="Do you know what happened to the Empire after we left?",
		alien={"Internal strife combined with the migration of xenophobic and technologically mighty species directly through Empire space ripped the cohesion of the Empire apart.  The human taskforces were utterly destroyed and it was believed that none of their population survived the wave of flaring stars.  Obviously we were mistaken." }
	}
	questions[11144] = {
		action="jump", goto=11141,
		player="Our ancestors trace our history to Noah 3.",
		alien={"We have heard of this.  It was widely believed that all Noah colony ships were destroyed by the the Laytonites.  In the past we were allies, your race and mine, united in a common cause.  We must collaborate to stop the Minex." }
	}
	questions[11145] = {
		action="jump", goto=11141,
		player="So you were close allies with humanity in the past?",
		alien={"Indeed, even though that Empire was no more, its legacy shines the way to a bright future.  We shall build another empire and you shall be our allies and rule with us.  Commerce and mutual aid against a common cause - these are the important things to remember." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="What can we do to stop the Minex?",  goto=23000 },
			{ text="Tell us about the Elowan.",  goto=21000 },
			{ text="Tell us about other alien races.",  goto=22000 }, 
			{ text="<Back>", goto=1 }
		}
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="",
		alien={"Your people must aid us with the exchange of military technology.  If you do not possess adequate technology than we will consider a mutual defense pact if your people can provide us with raw materials such as radioactives.  Please convey our request to your leaders." }
	}
	questions[21000] = {
		action="jump", goto=21101,
		player="Tell us about the Elowan.",
		alien={"The Elowan are deceitful and untrustworthy carnivorous plant creatures, mutated into an aggressive race which seeks the destruction of their creators, the benevolent Thrynn.  They are currently in a temporary alliance with us to oppose the Minex." }
	}
	questions[22000] = {
		action="jump", goto=22101,
		player="Tell us about other alien races.",
		alien={"Beside the Elowan, we have knowledge of the Minex, the Bar-Zhon, the Spemin, and the Tafel.  Of whom do you direct your attention?" }
	} 
	questions[21101] = {
		action="branch",
		choices = {
			{ text="The Elowan are intelligent plants?",  goto=21100 },
			{ text="The Elowan are dangerous?",  goto=21200 },
			{ text="Tell us about the Elowan warships.",  goto=21300 }, 
			{ text="<Back>", goto=21001 }
		}
	}
	questions[21100] = {
		action="jump", goto=21101,
		player="The Elowan are intelligent plants?",
		alien={"Yes.  The Elowan were created by a mad genius seeking to create both a rapidly multipling planetary terraforming tool and create a sufficiently intelligent servant which could guard his holdings and be immune to treachery and deceit.  Only the first goal was obtained, and most regrettably a rebellion ended his life and threatened to wipe out life on our home world and on several of our colonies." }
	}
	questions[21200] = {
		action="jump", goto=21101,
		player="The Elowan are dangerous?",
		alien={"Yes indeed.  Only a few seads can rapidly spread across an entire planetary surface crowding out and stifling all of the plant growth and covering it with carnivorous growth seeking to devour and destroy all animal life." }
	}
	questions[21300] = {
		action="jump", goto=21101,
		player="Tell us about the Elowan warships.",
		alien={"The Elowan are not necessarily intelligent but are more than clever.  Spreading through several sparsely inhabited Thrynn worlds they discovered on one ancient technological artifact which formed the basis of their incredibly powerful shielding.  Quickly they adapted several small scout vessels with this technology and began to build them en mass.  It is necessary to isolate their ships and attack them quickly with high-powered lasers at close range before their shields recharge." }
	} 
	questions[22101] = {
		action="branch",
		choices = {
			{ text="Tell us about the Minex.",  goto=22100 },
			{ text="Tell us about the Bar-Zhon.",  goto=22200 },
			{ text="Tell us about the Spemin.",  goto=22300 },
			{ text="Tell us about the Tafel.",  goto=22400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[22100] = {
		action="jump", goto=22105,
		player="Tell us about the Minex.",
		alien={"The Minex used to be isolationist industrialists but have set their sights on conquering the galaxy.  Their ships are almost as dangerous as the Gazurtoid and possess similar resistance to missile weaponry.  We have experienced a minor inconvenience at repulsing their waves of ships." }
	}
	questions[22105] = {
		action="jump", goto=22101,
		player="Who are the Gazurtoid?",
		alien={"The Gazurtoid are truly a dangerous enemy who passed through our original territory about a thousand years ago.  Unlike the Minex who possess partial missile resistance, the Gazurtoid exhibited complete immunity from projectile weaponry.  They do not inhabit this region of space." }
	}
	questions[22200] = {
		action="jump", goto=22101,
		player="Tell us about the Bar-Zhon.",
		alien={"The Bar-Zhon are the degenerate descendents of a race of proud empire builders.  They have delusions of grandeur but can be safely ignored." }
	}
	questions[22300] = {
		action="jump", goto=22101,
		player="Tell us about the Spemin.",
		alien={"The Spemin are a race of barely sentient blob creatures, and their ships are easily defeated.  They are truly not worth the effort to destroy, but for some reason their ships are extremely numerous.  We are investigating why they have not run out of fuel a long time ago." }
	}
	questions[22400] = {
		action="jump", goto=22101,
		player="Tell us about the Tafel.",
		alien={"The Tafel are an insidious but weak nuisance in this area of space.  You should destroy them as we do." }
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
		alien={"Ahhh, just so.  We of the Thrynn order wish you peace as well.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.  I greet you and offer our hopes for friendship and mutual cooperation."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Ahhh, just so.  We of the Thrynn order wish you peace as well.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.  I greet you and offer our hopes for friendship and mutual cooperation."} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Ahhh, just so.  We of the Thrynn order wish you peace as well.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.  I greet you and offer our hopes for friendship and mutual cooperation."} }
	greetings[4] = {
		action="",
		player="Dude, that is one crazy powerful ship you have there!",
		alien={"Ahhh, just so.  We of the Thrynn order wish you peace as well.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.  I greet you and offer our hopes for friendship and mutual cooperation."} }
	greetings[5] = {
		action="",
		player="How's it going, lizard guys?",
		alien={"Ahhh, just so.  We of the Thrynn order wish you peace as well.  Your homeworld territory is unfortunate, but you should know we no longer classify your race as pirates.  I greet you and offer our hopes for friendship and mutual cooperation."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"Commerce and mutual aid against a common cause - these are the important things to remember.","Our races are much alike. We both know what is important. We must unite for the benefit of both our peoples.","Supreme technology is the most noble goal of sentience. Join us in helping the less astute races become aware of this."} }
	statements[2] = {
		action="",
		player="Your ship appears very elaborate.",
		alien={"Commerce and mutual aid against a common cause - these are the important things to remember.","Our races are much alike. We both know what is important. We must unite for the benefit of both our peoples.","Supreme technology is the most noble goal of sentience. Join us in helping the less astute races become aware of this."} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"Commerce and mutual aid against a common cause - these are the important things to remember.","Our races are much alike. We both know what is important. We must unite for the benefit of both our peoples.","Supreme technology is the most noble goal of sentience. Join us in helping the less astute races become aware of this."} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"Commerce and mutual aid against a common cause - these are the important things to remember.","Our races are much alike. We both know what is important. We must unite for the benefit of both our peoples.","Supreme technology is the most noble goal of sentience. Join us in helping the less astute races become aware of this."} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"Commerce and mutual aid against a common cause - these are the important things to remember.","Our races are much alike. We both know what is important. We must unite for the benefit of both our peoples.","Supreme technology is the most noble goal of sentience. Join us in helping the less astute races become aware of this."} }
		 



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"As your senses tell you, we Thrynn are a reptilian carnivorous race, warm-blooded, with binocular vision and an internal skeletons as you.  We are however oviperous."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races?",
		alien={"We are currently embroiled in a major conflict with the Minex.  We seek your aid in this endeavor."}
	}
	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about your history?",
		alien={"The colonization group which established this empire was sent out using an experimental artificial wormhole generating jump pod.  Unfortunately navigational coherency was lost and we have no idea how far or in what direction we traveled from.  Our colony ship contained the greatest leaders, scientists, and industrialists from our society."}
	}
	questions[30001] = {
		action="jump", goto=1,
		player="<More>",
		alien={"Numerous threats throughout our history have imperiled our people in this region of space.  Only by eliminating hostile races do we ensure our survival."}
	}
	questions[40000] = {
		action="jump", goto=1,
		player="Tell us about the Ancients.",
		alien={"There are a lot of myths concerning the ancient ones.  We do not waste our time with legends and stories. The only relevant information is that they have left behind lumps of high energy crystal.  We are most concerned with locating their ruins for their energy resource value." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="We demand that your race cease attacking the Elowan!",  goto=51000 },
			{ text="Where is your home world?", goto=52000 },
			{ text="Do you know anything about an unnatural virus?", goto=60000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=51001,
		player="",
		alien={"We already have.  Although Elowan weaponry is almost useless against the Minex, we have persuaded them to act as cannon fodder in the Minex' war against us."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="Where is your home world?",
		alien={"Our home world is located at Semias 3 - 5,66."}
	}
	questions[51001] = {
		action="branch",
		choices = {
			{ text="How were you able to convince the Elowan?",  goto=51100 },
			{ text="How goes the war against the Minex?", goto=51200 },
			{ text="Do you know why they have attacked you?", goto=51300 },
			{ text="What tactics do the Minex follow?", goto=51400 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[51100] = {
		action="jump", goto=51001,
		player="",
		alien={"Stress of extended war has produced highly accelerated natural selection and resulted in a reasonable Elowan.  The other races in this area are not as advanced in diplomacy as we Thrynn, and we have been able to take advantage of the Elowan survival drive with the new threats of the Minex to bring them on our side." }
	}
	questions[51200] = {
		action="jump", goto=51001,
		player="",
		alien={"We have very little news at present because we are still withstanding the initial onslaught of the Minex.  When their fleets start wearing thin we will retaliate before their shipyards can respond." }
	}
	questions[51300] = {
		action="jump", goto=51001,
		player="",
		alien={"One irrational xenophobic aquatic race is much like another..." }
	}
	questions[51400] = {
		action="jump", goto=51001,
		player="",
		alien={"The Minex blindly circle our territory with huge fleets and attack anything they run across.  Our coordinated counterattacks have wrecked vast devastation upon their numbers.  Beware, if we detect your ship attempting to salvage any vessel in our territory, we will respond with deadly force.  No tolerance is given to pirates." }
	}

	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"An insidious sickness has begun to infect our people as well as all other races.  The technology behind the sickness matches with artifacts found in extremely old ruins in this area.  We are investigating to discover who is responsible for uncovering and spreading this virus." }
	}
	questions[60001] = {
			action="branch",
			choices = {
				{ text="Have you discovered any leads to the source of the virus?", goto=61000 },
				{ text="What artifacts resemble the virus technology?", goto=62000 },
				{ text="Could the Minex be responsible?", goto=63000 },
				{ text="Could the Elowan be responsible?", goto=64000 },
				{ text="<Back>", goto=50000 }
			}
		}
		questions[61000] = {
			action="jump", goto=60001,
			player="",
			alien={"Not any definitive proof yet.  The guilty party would be a well traveled race and would themselves not bear any sign of infection.  They also would have much to gain by destabilizing this region.  Perhaps a newcomer, hmm?" }
		}
		questions[62000] = {
			action="jump", goto=60001,
			player="",
			alien={"Artifacts from the Bx.  They were known to scavenge and adapt nightmarish technologies taken from an underground city millions of years old.  If this virus originated from anywhere it would be there. The exact system location was lost after the Bar-Zhon war, but was known to be in an M class system on the outward edge of this region of space." }
		}
		questions[63000] = {
			action="jump", goto=60001,
			player="",
			alien={"Possible but unlikely.  Those infected and driven mad by the virus appear to go out of their way to find and attack the Minex.  Not a particularly wise trait to pursue if they were the guilty party.  Besides, the true guilty party would attempt to remain neutral to all and let the sickness ravage and weaken without drawing suspicion to themselves." }
		}
		questions[64000] = {
			action="jump", goto=60001,
			player="",
			alien={"No.  Elowan ships do not explore since they huddle together for mutual defense.  We have continued their spread for many years and they do not possess the intelligence to commit this crime.  Besides they are also infected." }
		}


	questions[11001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your society?",  goto=11000 },
			{ text="What does oviperous mean?", goto=12000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11101,
		player="What can you tell us about your society?",
		alien={"We are a practical people with a complete and total trust in the concept called fate.  With the goal of increasing the length our own species' survival, we have embraced in our social structure the concepts of progression, growth, survival of the fittest, and have a disdain for mercy of any type." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="What does oviperous mean?",
		alien={"Such matters are better left not discussed." }
	}

	
	questions[11101] = {
		action="branch",
		choices = {
			{ text="Do you think of yourselves as merciless?",  goto=11110 },
			{ text="What do you do with the poor, the outcasts, et cetera?",  goto=11120 },
			{ text="How is your society governed?",  goto=11130 },
			{ text="Such inhumanity is hard to imagine.",  goto=11140 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[11110] = {
		action="jump", goto=11101,
		player="Do you think of yourselves as merciless?",
		alien={"No, of course not.  Children are given a chance to grow and so is any process, individual, or philosophy which may at some time improve the strengths of society at some point in the future.  Unlike nature, we understand patience.  However like nature we have absolutely no tolerance for the weak." }
	}
	questions[11120] = {
		action="jump", goto=11101,
		player="What do you do with the poor, the outcasts, et cetera?",
		alien={"The very concept of welfare is abhorrent.  It is not always easy to accept the fact that the weak must die. But this is the way of the universe is it not?  Strengthening the week so they can survive only saps the strength of the strong and weakens all.  Would you work for an ungrateful, demanding mob for the rest of your life who think it is their right for you to work for them?" }
	}
	questions[11130] = {
		action="jump", goto=11101,
		player="How is your society governed?",
		alien={"Our government system has changed many times over the years.  Our system currently organized in a military hierarchy with extreme upward mobility based ability and nothing else.  Diplomatic skill, ability to form temporary alliances based on mutual goals is the key to success yet mavericks are also given a free hand." }
	}
	questions[11140] = {
		action="jump", goto=11141,
		player="Such inhumanity is ...",
		alien={"Wait, did you say human?  Your physical appearance matches our records of empire humanity." }
	}
	questions[11141] = {
		action="branch",
		choices = {
			{ text="What do you know about ancient humanity?",  goto=11142 },
			{ text="Do you know what happened to the Empire after we left?",  goto=11143 },
			{ text="Our ancestors trace our history to Noah 3.",  goto=11144 },
			{ text="So you were close allies with humanity in the past?",  goto=11145 },
			{ text="<Back>", goto=11101 }
		}
	}
	questions[11142] = {
		action="jump", goto=11141,
		player="What do you know about ancient humanity?",
		alien={"Humanity and the Thrynn once ruled a vast interstellar empire together and will do so again.  Aid us with your undistorted and effective empire technology and we will aid you in manpower and industrial might." }
	}
	questions[11143] = {
		action="jump", goto=11141,
		player="Do you know what happened to the Empire after we left?",
		alien={"Internal strife combined with the migration of xenophobic and technologically mighty species directly through Empire space ripped the cohesion of the Empire apart.  The human taskforces were utterly destroyed and it was believed that none of their population survived the wave of flaring stars.  Obviously we were mistaken." }
	}
	questions[11144] = {
		action="jump", goto=11141,
		player="Our ancestors trace our history to Noah 3.",
		alien={"We have heard of this.  It was widely believed that all Noah colony ships were destroyed by the the Laytonites.  In the past we were allies, your race and mine, united in a common cause.  We must collaborate to stop the Minex." }
	}
	questions[11145] = {
		action="jump", goto=11141,
		player="So you were close allies with humanity in the past?",
		alien={"Indeed, even though that Empire was no more, its legacy shines the way to a bright future.  We shall build another empire and you shall be our allies and rule with us.  Commerce and mutual aid against a common cause - these are the important things to remember." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="What can we do to stop the Minex?",  goto=23000 },
			{ text="Tell us about the Elowan.",  goto=21000 },
			{ text="Tell us about other alien races.",  goto=22000 }, 
			{ text="<Back>", goto=1 }
		}
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="",
		alien={"Your people must aid us with the exchange of military technology.  If you do not possess adequate technology than we will consider a mutual defense pact if your people can provide us with raw materials such as radioactives.  Please convey our request to your leaders." }
	}
	questions[21000] = {
		action="jump", goto=21101,
		player="Tell us about the Elowan.",
		alien={"The Elowan are deceitful and untrustworthy carnivorous plant creatures, mutated into an aggressive race which seeks the destruction of their creators, the benevolent Thrynn.  They are currently in a temporary alliance with us to oppose the Minex." }
	}
	questions[22000] = {
		action="jump", goto=22101,
		player="Tell us about other alien races.",
		alien={"Beside the Elowan, we have knowledge of the Minex, the Bar-Zhon, the Spemin, and the Tafel.  Of whom do you direct your attention?" }
	} 
	questions[21101] = {
		action="branch",
		choices = {
			{ text="The Elowan are intelligent plants?",  goto=21100 },
			{ text="The Elowan are dangerous?",  goto=21200 },
			{ text="Tell us about the Elowan warships.",  goto=21300 }, 
			{ text="<Back>", goto=21001 }
		}
	}
	questions[21100] = {
		action="jump", goto=21101,
		player="The Elowan are intelligent plants?",
		alien={"Yes.  The Elowan were created by a mad genius seeking to create both a rapidly multipling planetary terraforming tool and create a sufficiently intelligent servant which could guard his holdings and be immune to treachery and deceit.  Only the first goal was obtained, and most regrettably a rebellion ended his life and threatened to wipe out life on our home world and on several of our colonies." }
	}
	questions[21200] = {
		action="jump", goto=21101,
		player="The Elowan are dangerous?",
		alien={"Yes indeed.  Only a few seads can rapidly spread across an entire planetary surface crowding out and stifling all of the plant growth and covering it with carnivorous growth seeking to devour and destroy all animal life." }
	}
	questions[21300] = {
		action="jump", goto=21101,
		player="Tell us about the Elowan warships.",
		alien={"The Elowan are not necessarily intelligent but are more than clever.  Spreading through several sparsely inhabited Thrynn worlds they discovered on one ancient technological artifact which formed the basis of their incredibly powerful shielding.  Quickly they adapted several small scout vessels with this technology and began to build them en mass.  It is necessary to isolate their ships and attack them quickly with high-powered lasers at close range before their shields recharge." }
	} 
	questions[22101] = {
		action="branch",
		choices = {
			{ text="Tell us about the Minex.",  goto=22100 },
			{ text="Tell us about the Bar-Zhon.",  goto=22200 },
			{ text="Tell us about the Spemin.",  goto=22300 },
			{ text="Tell us about the Tafel.",  goto=22400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[22100] = {
		action="jump", goto=22105,
		player="Tell us about the Minex.",
		alien={"The Minex used to be isolationist industrialists but have set their sights on conquering the galaxy.  Their ships are almost as dangerous as the Gazurtoid and possess similar resistance to missile weaponry.  We have experienced a minor inconvenience at repulsing their waves of ships." }
	}
	questions[22105] = {
		action="jump", goto=22101,
		player="Who are the Gazurtoid?",
		alien={"The Gazurtoid are truly a dangerous enemy who passed through our original territory about a thousand years ago.  Unlike the Minex who possess partial missile resistance, the Gazurtoid exhibited complete immunity from projectile weaponry.  They do not inhabit this region of space." }
	}
	questions[22200] = {
		action="jump", goto=22101,
		player="Tell us about the Bar-Zhon.",
		alien={"The Bar-Zhon are the degenerate descendents of a race of proud empire builders.  They have delusions of grandeur but can be safely ignored." }
	}
	questions[22300] = {
		action="jump", goto=22101,
		player="Tell us about the Spemin.",
		alien={"The Spemin are a race of barely sentient blob creatures, and their ships are easily defeated.  They are truly not worth the effort to destroy, but for some reason their ships are extremely numerous.  We are investigating why they have not run out of fuel a long time ago." }
	}
	questions[22400] = {
		action="jump", goto=22101,
		player="Tell us about the Tafel.",
		alien={"The Tafel are an insidious but weak nuisance in this area of space.  You should destroy them as we do." }
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
		alien={"You have made a grave mistake in angering the Thrynn.  We can be the best of friends but we are certainly the worst of enemies.","We Thrynn were prepared to accept you fully as allies.  You have proven that you are not suitable.  Know we must list you amongst our enemies.","We are the Thrynn.  We ask you not to incite trouble between our races."} }
	greetings[2] = {
		action="",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"We Thrynn claim the right of free passage ass guaranteed all neutral races in the interplanetary treaty of 3190.","In exchange for our safety we offer information.  You may ask what you will.","We are the Thrynn.  We ask you not to incite trouble between our races."}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"We claim the right of free passage ass guaranteed all neutral races in the interplanetary treaty of 3190.","In exchange for our safety we offer information.  You may ask what you will.","We are the Thrynn.  We ask you not to incite trouble between our races."} }
	greetings[4] = {
		action="",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"You have made a grave mistake in angering the Thrynn.  We can be the best of friends but we are certainly the worst of enemies.","We Thrynn were prepared to accept you flly as allies.  You have proven that you are not suitable.  Know we must list you amongst our enemies.","We are the Thrynn.  We ask you not to incite trouble between our races."} }
	greetings[5] = {
		action="attack",
		player="We require information. Comply or be destroyed.",
		alien={"You have made a grave mistake in angering the Thrynn.  We can be the best of friends but we are certainly the worst of enemies.","We Thrynn were prepared to accept you fully as allies.  You have proven that you are not suitable.  Know we must list you amongst our enemies."} }
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="attack",
		player="Your ship is simple and weak.",
		alien={"You have made a grave mistake in angering us.  We can be the best of friends but we are certainly the worst of enemies.","We were prepared to accept you fully as allies.  You have proven that you are not suitable.  Know we must list you amongst our enemies.","We ask you not to incite trouble between our races."} }
	statements[2] = {
		action="attack",
		player="What an sorry excuse for a misshapen creature.",
		alien={"You have made a grave mistake in angering us.  We can be the best of friends but we are certainly the worst of enemies.","We were prepared to accept you fully as allies.  You have proven that you are not suitable.  Know we must list you amongst our enemies."} }
	statements[3] = {
		action="terminate",
		player="Your ship looks like a flying garbage scow.",
		alien={"You have little time, enemies of the Thrynn.  Leave now and do not anger us further.  We would regret destroying you.","Enough talking, we have said too much.","We ask you not to incite trouble between our races."} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	

	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"As your senses tell you, we Thrynn are a reptilian carnivorous race, warm-blooded, with binocular vision and an internal skeletons as you.  We are however oviperous."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races?",
		alien={"We are currently embroiled in a major conflict with the Minex.  We seek your aid in this endeavor."}
	}
	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about your history?",
		alien={"The colonization group which established this empire was sent out using an experimental artificial wormhole generating jump pod.  Unfortunately navigational coherency was lost and we have no idea how far or in what direction we traveled from.  Our colony ship contained the greatest leaders, scientists, and industrialists from our society."}
	}
	questions[30001] = {
		action="jump", goto=1,
		player="<More>",
		alien={"Numerous threats throughout our history have imperiled our people in this region of space.  Only by eliminating hostile races do we ensure our survival."}
	}
	questions[40000] = {
		action="jump", goto=1,
		player="Tell us about the Ancients.",
		alien={"There are a lot of myths concerning the ancient ones.  We do not waste our time with legends and stories. The only relevant information is that they have left behind lumps of high energy crystal.  We are most concerned with locating their ruins for their energy resource value." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="We demand that your race cease attacking the Elowan!",  goto=51000 },
			{ text="Where is your home world?", goto=52000 },
			{ text="Do you know anything about an unnatural virus?", goto=60000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=51001,
		player="",
		alien={"We already have.  Although Elowan weaponry is almost useless against the Minex, we have persuaded them to act as cannon fodder in the Minex' war against us."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="Where is your home world?",
		alien={"Our home world is located at Semias 3 - 5,66."}
	}
	questions[51001] = {
		action="branch",
		choices = {
			{ text="How were you able to convince the Elowan?",  goto=51100 },
			{ text="How goes the war against the Minex?", goto=51200 },
			{ text="Do you know why they have attacked you?", goto=51300 },
			{ text="What tactics do the Minex follow?", goto=51400 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[51100] = {
		action="jump", goto=51001,
		player="",
		alien={"Stress of extended war has produced highly accelerated natural selection and resulted in a reasonable Elowan.  The other races in this area are not as advanced in diplomacy as we Thrynn, and we have been able to take advantage of the Elowan survival drive with the new threats of the Minex to bring them on our side." }
	}
	questions[51200] = {
		action="jump", goto=51001,
		player="",
		alien={"We have very little news at present because we are still withstanding the initial onslaught of the Minex.  When their fleets start wearing thin we will retaliate before their shipyards can respond." }
	}
	questions[51300] = {
		action="jump", goto=51001,
		player="",
		alien={"One irrational xenophobic aquatic race is much like another..." }
	}
	questions[51400] = {
		action="jump", goto=51001,
		player="",
		alien={"The Minex blindly circle our territory with huge fleets and attack anything they run across.  Our coordinated counterattacks have wrecked vast devastation upon their numbers.  Beware, if we detect your ship attempting to salvage any vessel in our territory, we will respond with deadly force.  No tolerance is given to pirates." }
	}

	questions[60000] = {
		action="jump", goto=60001,
		player="",
		alien={"An insidious sickness has begun to infect our people as well as all other races.  The technology behind the sickness matches with artifacts found in extremely old ruins in this area.  We are investigating to discover who is responsible for uncovering and spreading this virus." }
	}
	questions[60001] = {
			action="branch",
			choices = {
				{ text="Have you discovered any leads to the source of the virus?", goto=61000 },
				{ text="What artifacts resemble the virus technology?", goto=62000 },
				{ text="Could the Minex be responsible?", goto=63000 },
				{ text="Could the Elowan be responsible?", goto=64000 },
				{ text="<Back>", goto=50000 }
			}
		}
		questions[61000] = {
			action="jump", goto=60001,
			player="",
			alien={"Not any definitive proof yet.  The guilty party would be a well traveled race and would themselves not bear any sign of infection.  They also would have much to gain by destabilizing this region.  Perhaps a newcomer, hmm?" }
		}
		questions[62000] = {
			action="jump", goto=60001,
			player="",
			alien={"Artifacts from the Bx.  They were known to scavenge and adapt nightmarish technologies taken from an underground city millions of years old.  If this virus originated from anywhere it would be there. The exact system location was lost after the Bar-Zhon war, but was known to be in an M class system on the outward edge of this region of space." }
		}
		questions[63000] = {
			action="jump", goto=60001,
			player="",
			alien={"Possible but unlikely.  Those infected and driven mad by the virus appear to go out of their way to find and attack the Minex.  Not a particularly wise trait to pursue if they were the guilty party.  Besides, the true guilty party would attempt to remain neutral to all and let the sickness ravage and weaken without drawing suspicion to themselves." }
		}
		questions[64000] = {
			action="jump", goto=60001,
			player="",
			alien={"No.  Elowan ships do not explore since they huddle together for mutual defense.  We have continued their spread for many years and they do not possess the intelligence to commit this crime.  Besides they are also infected." }
		}


	questions[11001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your society?",  goto=11000 },
			{ text="What does oviperous mean?", goto=12000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11101,
		player="What can you tell us about your society?",
		alien={"We are a practical people with a complete and total trust in the concept called fate.  With the goal of increasing the length our own species' survival, we have embraced in our social structure the concepts of progression, growth, survival of the fittest, and have a disdain for mercy of any type." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="What does oviperous mean?",
		alien={"Such matters are better left not discussed." }
	}

	
	questions[11101] = {
		action="branch",
		choices = {
			{ text="Do you think of yourselves as merciless?",  goto=11110 },
			{ text="What do you do with the poor, the outcasts, et cetera?",  goto=11120 },
			{ text="How is your society governed?",  goto=11130 },
			{ text="Such inhumanity is hard to imagine.",  goto=11140 },
			{ text="<Back>", goto=11001 }
		}
	}
	questions[11110] = {
		action="jump", goto=11101,
		player="Do you think of yourselves as merciless?",
		alien={"No, of course not.  Children are given a chance to grow and so is any process, individual, or philosophy which may at some time improve the strengths of society at some point in the future.  Unlike nature, we understand patience.  However like nature we have absolutely no tolerance for the weak." }
	}
	questions[11120] = {
		action="jump", goto=11101,
		player="What do you do with the poor, the outcasts, et cetera?",
		alien={"The very concept of welfare is abhorrent.  It is not always easy to accept the fact that the weak must die. But this is the way of the universe is it not?  Strengthening the week so they can survive only saps the strength of the strong and weakens all.  Would you work for an ungrateful, demanding mob for the rest of your life who think it is their right for you to work for them?" }
	}
	questions[11130] = {
		action="jump", goto=11101,
		player="How is your society governed?",
		alien={"Our government system has changed many times over the years.  Our system currently organized in a military hierarchy with extreme upward mobility based ability and nothing else.  Diplomatic skill, ability to form temporary alliances based on mutual goals is the key to success yet mavericks are also given a free hand." }
	}
	questions[11140] = {
		action="jump", goto=11141,
		player="Such inhumanity is ...",
		alien={"Wait, did you say human?  Your physical appearance matches our records of empire humanity." }
	}
	questions[11141] = {
		action="branch",
		choices = {
			{ text="What do you know about ancient humanity?",  goto=11142 },
			{ text="Do you know what happened to the Empire after we left?",  goto=11143 },
			{ text="Our ancestors trace our history to Noah 3.",  goto=11144 },
			{ text="So you were close allies with humanity in the past?",  goto=11145 },
			{ text="<Back>", goto=11101 }
		}
	}
	questions[11142] = {
		action="jump", goto=11141,
		player="What do you know about ancient humanity?",
		alien={"Humanity and the Thrynn once ruled a vast interstellar empire together and will do so again.  Aid us with your undistorted and effective empire technology and we will aid you in manpower and industrial might." }
	}
	questions[11143] = {
		action="jump", goto=11141,
		player="Do you know what happened to the Empire after we left?",
		alien={"Internal strife combined with the migration of xenophobic and technologically mighty species directly through Empire space ripped the cohesion of the Empire apart.  The human taskforces were utterly destroyed and it was believed that none of their population survived the wave of flaring stars.  Obviously we were mistaken." }
	}
	questions[11144] = {
		action="jump", goto=11141,
		player="Our ancestors trace our history to Noah 3.",
		alien={"We have heard of this.  It was widely believed that all Noah colony ships were destroyed by the the Laytonites.  In the past we were allies, your race and mine, united in a common cause.  We must collaborate to stop the Minex." }
	}
	questions[11145] = {
		action="jump", goto=11141,
		player="So you were close allies with humanity in the past?",
		alien={"Indeed, even though that Empire was no more, its legacy shines the way to a bright future.  We shall build another empire and you shall be our allies and rule with us.  Commerce and mutual aid against a common cause - these are the important things to remember." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="What can we do to stop the Minex?",  goto=23000 },
			{ text="Tell us about the Elowan.",  goto=21000 },
			{ text="Tell us about other alien races.",  goto=22000 }, 
			{ text="<Back>", goto=1 }
		}
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="",
		alien={"Your people must aid us with the exchange of military technology.  If you do not possess adequate technology than we will consider a mutual defense pact if your people can provide us with raw materials such as radioactives.  Please convey our request to your leaders." }
	}
	questions[21000] = {
		action="jump", goto=21101,
		player="Tell us about the Elowan.",
		alien={"The Elowan are deceitful and untrustworthy carnivorous plant creatures, mutated into an aggressive race which seeks the destruction of their creators, the benevolent Thrynn.  They are currently in a temporary alliance with us to oppose the Minex." }
	}
	questions[22000] = {
		action="jump", goto=22101,
		player="Tell us about other alien races.",
		alien={"Beside the Elowan, we have knowledge of the Minex, the Bar-Zhon, the Spemin, and the Tafel.  Of whom do you direct your attention?" }
	} 
	questions[21101] = {
		action="branch",
		choices = {
			{ text="The Elowan are intelligent plants?",  goto=21100 },
			{ text="The Elowan are dangerous?",  goto=21200 },
			{ text="Tell us about the Elowan warships.",  goto=21300 }, 
			{ text="<Back>", goto=21001 }
		}
	}
	questions[21100] = {
		action="jump", goto=21101,
		player="The Elowan are intelligent plants?",
		alien={"Yes.  The Elowan were created by a mad genius seeking to create both a rapidly multipling planetary terraforming tool and create a sufficiently intelligent servant which could guard his holdings and be immune to treachery and deceit.  Only the first goal was obtained, and most regrettably a rebellion ended his life and threatened to wipe out life on our home world and on several of our colonies." }
	}
	questions[21200] = {
		action="jump", goto=21101,
		player="The Elowan are dangerous?",
		alien={"Yes indeed.  Only a few seads can rapidly spread across an entire planetary surface crowding out and stifling all of the plant growth and covering it with carnivorous growth seeking to devour and destroy all animal life." }
	}
	questions[21300] = {
		action="jump", goto=21101,
		player="Tell us about the Elowan warships.",
		alien={"The Elowan are not necessarily intelligent but are more than clever.  Spreading through several sparsely inhabited Thrynn worlds they discovered on one ancient technological artifact which formed the basis of their incredibly powerful shielding.  Quickly they adapted several small scout vessels with this technology and began to build them en mass.  It is necessary to isolate their ships and attack them quickly with high-powered lasers at close range before their shields recharge." }
	} 
	questions[22101] = {
		action="branch",
		choices = {
			{ text="Tell us about the Minex.",  goto=22100 },
			{ text="Tell us about the Bar-Zhon.",  goto=22200 },
			{ text="Tell us about the Spemin.",  goto=22300 },
			{ text="Tell us about the Tafel.",  goto=22400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[22100] = {
		action="jump", goto=22105,
		player="Tell us about the Minex.",
		alien={"The Minex used to be isolationist industrialists but have set their sights on conquering the galaxy.  Their ships are almost as dangerous as the Gazurtoid and possess similar resistance to missile weaponry.  We have experienced a minor inconvenience at repulsing their waves of ships." }
	}
	questions[22105] = {
		action="jump", goto=22101,
		player="Who are the Gazurtoid?",
		alien={"The Gazurtoid are truly a dangerous enemy who passed through our original territory about a thousand years ago.  Unlike the Minex who possess partial missile resistance, the Gazurtoid exhibited complete immunity from projectile weaponry.  They do not inhabit this region of space." }
	}
	questions[22200] = {
		action="jump", goto=22101,
		player="Tell us about the Bar-Zhon.",
		alien={"The Bar-Zhon are the degenerate descendents of a race of proud empire builders.  They have delusions of grandeur but can be safely ignored." }
	}
	questions[22300] = {
		action="jump", goto=22101,
		player="Tell us about the Spemin.",
		alien={"The Spemin are a race of barely sentient blob creatures, and their ships are easily defeated.  They are truly not worth the effort to destroy, but for some reason their ships are extremely numerous.  We are investigating why they have not run out of fuel a long time ago." }
	}
	questions[22400] = {
		action="jump", goto=22101,
		player="Tell us about the Tafel.",
		alien={"The Tafel are an insidious but weak nuisance in this area of space.  You should destroy them as we do." }
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

