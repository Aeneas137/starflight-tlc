--[[
	ENCOUNTER SCRIPT FILE: THRYNN   INITIAL

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
		alien={"We are thynynthrynn, the shield of the thrynn confederacy.  We are the elite guard.  Why are you here?","In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.","This is shield unit Thryssanyn, second force guard of the Thrynn."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"We are thynynthrynn, the shield of the thrynn confederacy.  We are the elite guard.  Why are you here?","In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.","This is shield unit Thryssanyn, second force guard of the Thrynn."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"We are thynynthrynn, the shield of the thrynn confederacy.  We are the elite guard.  Why are you here?","In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.","This is shield unit Thryssanyn, second force guard of the Thrynn."} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"We are thynynthrynn, the shield of the thrynn confederacy.  We are the elite guard.  Why are you here?","In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.","This is shield unit Thryssanyn, second force guard of the Thrynn."} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"We are thynynthrynn, the shield of the thrynn confederacy.  We are the elite guard.  Why are you here?","In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation.","This is shield unit Thryssanyn, second force guard of the Thrynn."} }


		
		
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
		alien={"We are currently embroiled in a conflict with a contagion known as the Elowan, a mutated plant strain which seeks the destruction of all animal life."}
	}
	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about your history?",
		alien={"The colonization group which established this empire was sent out using an experimental artificial wormhole generating jump pod.  Unfortunately navigational coherency was lost and we have no idea how far or in what direction we traveled from.  Our colony ship contained the greatest leaders, scientists, and industrialists from our society."}
	}
	questions[30001] = {
		action="jump", goto=1,
		player="<More>",
		alien={"Unfortunately we carried to this sector a number of headfruit, seeds of a genetically engineered servant species known as the Elowan.  These Elowan recently rebelled and attempted to destroy all animal life.  Don't be deceived by the claims of the Elowan.  For the first time in this drawnout conflict we hold the advantage and must pursue aggression against a plant monsters before they have a chance to regroup."}
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
			{ text="Are you looking for any technologies or artifacts?", goto=53000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=51001,
		player="We demand that your race cease attacking the Elowan!",
		alien={"Hmm.  I would be most interested in the basis of your demand."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="Where is your home world?",
		alien={"Our home world is located at Semias 3 - 5,66."}
	}
	questions[51001] = {
		action="branch",
		choices = {
			{ text="We will attack you if you do not.",  goto=51100 },
			{ text="Your attacks upon them are wrong!", goto=51200 },
			{ text="The Elowan are no threat to you.", goto=51300 },
			{ text="We will do anything you ask to bring about peace.", goto=51400 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[51100] = {
		action="jump", goto=51101,
		player="We will attack you if you do not.",
		alien={"Do you challenge us of the elite guard with the supreme delete functionality?  Prepare to feel the full force of our weaponry!" }
	}
	questions[51101] = {
		action="attack",
		player="Aggressive reptiles, I demand that you surrender your vessel(s)",
		alien={"Very well." }
	}
	questions[51200] = {
		action="jump", goto=51001,
		player="Your attacks upon them are wrong!",
		alien={"The Thrynn greatly regret the necessity to bring destruction to another alien species.  Unfortunately war is the only possible method to resolve conflicts if diplomats fail and negotiations break down.  We were unjustly attacked first and if we do not end this conflict now it may continue indefinitely causing a much greater loss of life.  This responsibility we must not leave for our grandchildren." }
	}
	questions[51300] = {
		action="jump", goto=51001,
		player="The Elowan are no threat to you.",
		alien={"At the current time this may be true, but it was not true in the recent past and may not be true in the future.  This universe is ruled by the aggressive use of force and the only true source of peace is victory." }
	}
	questions[51400] = {
		action="jump", goto=51001,
		player="We will do anything you ask to bring about peace.",
		alien={"Perhaps this idea has merit.  Profess to the Elowan an interest in their homeworld location and take appropriate actions from their response." }
	}

	
	questions[53000] = {
		action="jump", goto=53001,
		player="",
		alien={"The Thrynn Confederacy values technological progress as the primary goal of our society.  We will pay well for the following items:"}
	}
	questions[53001] = {
		action="branch",
		choices = {
			{ text="Elowan Shield Capacitor",  goto=53100 },
			{ text="Your attacks upon them are wrong!", goto=53200 },
			{ text="The Elowan are no threat to you.", goto=53300 },
			{ text="We will do anything you ask to bring about peace.", goto=53400 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[53100] = {
		action="jump", goto=53001,
		player="",
		alien={"The Elowan salvaged and duplicate a very advanced shielding module to protect their ships.  We will pay well for any Shield Capacitors that you are able to salvage." }
	}
	questions[53200] = {
		action="jump", goto=53001,
		player="",
		alien={"We have been made aware of a device known as The Spiral Lens.  This device was stolen from us by pirates.  Our intelligence has located it on the planet Eocho in the Etarlam 172,118 system at coordinates 82N X 55E.  We will pay well for its return." }
	}
	questions[53300] = {
		action="jump", goto=53001,
		player="",
		alien={"The Bar-zhon store considerable information on this sector inside a massive computer system in their ship.  If you are fortunate enough to retrieve an intact data core we will pay well for your efforts." }
	}
	questions[53400] = {
		action="jump", goto=53001,
		player="",
		alien={"The Bar-zhon pirates have developed an interesting new technology similar to our own superior propulsion systems.  If you happen to salvage a coalition afterburner unit we will purchase it because it's function is of great interest to us." }
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
		alien={"We have heard of this.  It was widely believed that all Noah colony ships were destroyed by the collaboration of the Laytonites and the Elowan.    In the past we were allies, your race and mine, united in a common cause.  We must unite to rid the galaxy of those who would oppose us." }
	}
	questions[11145] = {
		action="jump", goto=11141,
		player="So you were close allies with humanity in the past?",
		alien={"Indeed, even though that Empire was no more, its legacy shines the way to a bright future.  We shall build another empire and you shall be our allies and rule with us.  Commerce and mutual aid against a common cause - these are the important things to remember." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Elowan.",  goto=21000 },
			{ text="Tell us about other alien races.",  goto=22000 },
			{ text="Why can't you just all get along?",  goto=23000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=21101,
		player="Tell us about the Elowan.",
		alien={"The Elowan are deceitful and untrustworthy carnivorous plant creatures, mutated into an aggressive race which seeks the destruction of their creators, the benevolent Thrynn." }
	}
	questions[22000] = {
		action="jump", goto=22101,
		player="Tell us about other alien races.",
		alien={"Beside the Elowan, we have knowledge of the Minex, the Bar-Zhon, the Spemin, and the Tafel.  Of whom do you direct your attention?" }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="Why can't you just all get along?",
		alien={"Leave us now you pacifist alien thrawling." }
	}
	questions[23001] = {
		action="jump", goto=24100,
		player="Tell us about...",
		alien={"(Roar!)" }
	}
	questions[21101] = {
		action="branch",
		choices = {
			{ text="The Elowan are intelligent plants?",  goto=21100 },
			{ text="The Elowan are dangerous?",  goto=21200 },
			{ text="Tell us about the Elowan warships.",  goto=21300 },
			{ text="Why do you continue to fight them?",  goto=21400 },
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
	questions[21400] = {
		action="jump", goto=21101,
		player="Why do you continue to fight them?",
		alien={"The Elowan speak fairly but they are contagion, and would spread quickly and declare war if they had not been contained by the selfless Thrynn.  They seek to deceive others into becoming their allies out of desperation of their present condition only." }
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
		action="jump", goto=22101,
		player="Tell us about the Minex.",
		alien={"The Minex used to be more open in the past but have closed their borders due to Elowan treachery.  Unfortunately they have left the burden upon us to control the contagion." }
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
		alien={"Ahhh, just so. We of the Thrynn order wish peace as well.  How may we of service to each other?","We are the Thrynn.  We sincerely hope that we shall both profit from this meeting.","Greetings.  In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Ahhh, just so. We of the Thrynn order wish peace as well.  How may we of service to each other?","We are the Thrynn.  We sincerely hope that we shall both profit from this meeting.","Greetings.  In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation."} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Ahhh, just so. We of the Thrynn order wish peace as well.  How may we of service to each other?","We are the Thrynn.  We sincerely hope that we shall both profit from this meeting.","Greetings.  In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation."} }
	greetings[4] = {
		action="",
		player="Dude, that is one crazy powerful ship you have there!",
		alien={"Ahhh, just so. We of the Thrynn order wish peace as well.  How may we of service to each other?","We are the Thrynn.  We sincerely hope that we shall both profit from this meeting.","Greetings.  In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation."} }
	greetings[5] = {
		action="",
		player="How's it going, lizard guys?",
		alien={"Ahhh, just so. We of the Thrynn order wish peace as well.  How may we of service to each other?","We are the Thrynn.  We sincerely hope that we shall both profit from this meeting.","Greetings.  In the name of the thrynn confederacy of planets, I greet you and offer our hopes for friendship and mutual cooperation."} }

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
		alien={"We are currently embroiled in a conflict with a contagion known as the Elowan, a mutated plant strain which seeks the destruction of all animal life."}
	}
	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about your history?",
		alien={"The colonization group which established this empire was sent out using an experimental artificial wormhole generating jump pod.  Unfortunately navigational coherency was lost and we have no idea how far or in what direction we traveled from.  Our colony ship contained the greatest leaders, scientists, and industrialists from our society."}
	}
	questions[30001] = {
		action="jump", goto=1,
		player="<More>",
		alien={"Unfortunately we carried to this sector a number of headfruit, seeds of a genetically engineered servant species known as the Elowan.  These Elowan recently rebelled and attempted to destroy all animal life.  Don't be deceived by the claims of the Elowan.  For the first time in this drawnout conflict we hold the advantage and must pursue aggression against a plant monsters before they have a chance to regroup."}
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
			{ text="Are you looking for any technologies or artifacts?", goto=53000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=51001,
		player="We demand that your race cease attacking the Elowan!",
		alien={"Hmm.  I would be most interested in the basis of your demand."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="Where is your home world?",
		alien={"Our home world is located at Semias 3 - 5,66."}
	}
	questions[51001] = {
		action="branch",
		choices = {
			{ text="We will attack you if you do not.",  goto=51100 },
			{ text="Your attacks upon them are wrong!", goto=51200 },
			{ text="The Elowan are no threat to you.", goto=51300 },
			{ text="We will do anything you ask to bring about peace.", goto=51400 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[51100] = {
		action="jump", goto=51101,
		player="We will attack you if you do not.",
		alien={"Do you challenge us of the elite guard with the supreme delete functionality?  Prepare to feel the full force of our weaponry!" }
	}
	questions[51101] = {
		action="attack",
		player="Aggressive reptiles, I demand that you surrender your vessel(s)",
		alien={"Very well." }
	}
	questions[51200] = {
		action="jump", goto=51001,
		player="Your attacks upon them are wrong!",
		alien={"The Thrynn greatly regret the necessity to bring destruction to another alien species.  Unfortunately war is the only possible method to resolve conflicts if diplomats fail and negotiations break down.  We were unjustly attacked first and if we do not end this conflict now it may continue indefinitely causing a much greater loss of life.  This responsibility we must not leave for our grandchildren." }
	}
	questions[51300] = {
		action="jump", goto=51001,
		player="The Elowan are no threat to you.",
		alien={"At the current time this may be true, but it was not true in the recent past and may not be true in the future.  This universe is ruled by the aggressive use of force and the only true source of peace is victory." }
	}
	questions[51400] = {
		action="jump", goto=51001,
		player="We will do anything you ask to bring about peace.",
		alien={"Perhaps this idea has merit.  Profess to the Elowan an interest in their homeworld location and take appropriate actions from their response." }
	}

	
	questions[53000] = {
		action="jump", goto=53001,
		player="",
		alien={"The Thrynn Confederacy values technological progress as the primary goal of our society.  We will pay well for the following items:"}
	}
	questions[53001] = {
		action="branch",
		choices = {
			{ text="Elowan Shield Capacitor",  goto=53100 },
			{ text="Your attacks upon them are wrong!", goto=53200 },
			{ text="The Elowan are no threat to you.", goto=53300 },
			{ text="We will do anything you ask to bring about peace.", goto=53400 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[53100] = {
		action="jump", goto=53001,
		player="",
		alien={"The Elowan salvaged and duplicate a very advanced shielding module to protect their ships.  We will pay well for any Shield Capacitors that you are able to salvage." }
	}
	questions[53200] = {
		action="jump", goto=53001,
		player="",
		alien={"We have been made aware of a device known as The Spiral Lens.  This device was stolen from us by pirates.  Our intelligence has located it on the planet Eocho in the Etarlam 172,118 system at coordinates 82N X 55E.  We will pay well for its return." }
	}
	questions[53300] = {
		action="jump", goto=53001,
		player="",
		alien={"The Bar-zhon store considerable information on this sector inside a massive computer system in their ship.  If you are fortunate enough to retrieve an intact data core we will pay well for your efforts." }
	}
	questions[53400] = {
		action="jump", goto=53001,
		player="",
		alien={"The Bar-zhon pirates have developed an interesting new technology similar to our own superior propulsion systems.  If you happen to salvage a coalition afterburner unit we will purchase it because it's function is of great interest to us." }
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
		alien={"Our government system has changed many times over the years.  Our system currently organized in a military hierarchy with extreme upward mobility based ability and nothing else.  Diplomatic skill, ability to form temporary alliances based on mutual goals is the key to success yet Mavericks are also given a free hand." }
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
		alien={"We have heard of this.  It was widely believed that all Noah colony ships were destroyed by the collaboration of the Laytonites and the Elowan.    In the past we were allies, your race and mine, united in a common cause.  We must unite to rid the galaxy of those who would oppose us." }
	}
	questions[11145] = {
		action="jump", goto=11141,
		player="So you were close allies with humanity in the past?",
		alien={"Indeed, even though that Empire was no more, its legacy shines the way to a bright future.  We shall build another empire and you shall be our allies and rule with us.  Commerce and mutual aid against a common cause - these are the important things to remember." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Elowan.",  goto=21000 },
			{ text="Tell us about other alien races.",  goto=22000 },
			{ text="Why can't you just all get along?",  goto=23000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=21101,
		player="Tell us about the Elowan.",
		alien={"The Elowan are deceitful and untrustworthy carnivorous plant creatures, mutated into an aggressive race which seeks the destruction of their creators, the benevolent Thrynn." }
	}
	questions[22000] = {
		action="jump", goto=22101,
		player="Tell us about other alien races.",
		alien={"Beside the Elowan, we have knowledge of the Minex, the Bar-Zhon, the Spemin, and the Tafel.  Of whom do you direct your attention?" }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="Why can't you just all get along?",
		alien={"Leave us now you pacifist alien thrawling." }
	}
	questions[23001] = {
		action="jump", goto=24100,
		player="Tell us about...",
		alien={"(Roar!)" }
	}
	questions[21101] = {
		action="branch",
		choices = {
			{ text="The Elowan are intelligent plants?",  goto=21100 },
			{ text="The Elowan are dangerous?",  goto=21200 },
			{ text="Tell us about the Elowan warships.",  goto=21300 },
			{ text="Why do you continue to fight them?",  goto=21400 },
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
	questions[21400] = {
		action="jump", goto=21101,
		player="Why do you continue to fight them?",
		alien={"The Elowan speak fairly but they are contagion, and would spread quickly and declare war if they had not been contained by the selfless Thrynn.  They seek to deceive others into becoming their allies out of desperation of their present condition only." }
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
		action="jump", goto=22101,
		player="Tell us about the Minex.",
		alien={"The Minex used to be more open in the past but have closed their borders due to Elowan treachery.  Unfortunately they have left the burden upon us to control the contagion." }
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
		action="",
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
		alien={"We are currently embroiled in a conflict with a contagion known as the Elowan, a mutated plant strain which seeks the destruction of all animal life."}
	}
	questions[30000] = {
		action="jump", goto=30001,
		player="What can you tell us about your history?",
		alien={"The colonization group which established this empire was sent out using an experimental artificial wormhole generating jump pod.  Unfortunately navigational coherency was lost and we have no idea how far or in what direction we traveled from.  Our colony ship contained the greatest leaders, scientists, and industrialists from our society."}
	}
	questions[30001] = {
		action="jump", goto=1,
		player="<More>",
		alien={"Unfortunately we carried to this sector a number of headfruit, seeds of a genetically engineered servant species known as the Elowan.  These Elowan recently rebelled and attempted to destroy all animal life.  Don't be deceived by the claims of the Elowan.  For the first time in this drawnout conflict we hold the advantage and must pursue aggression against a plant monsters before they have a chance to regroup."}
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
			{ text="Are you looking for any technologies or artifacts?", goto=53000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[51000] = {
		action="jump", goto=51001,
		player="We demand that your race cease attacking the Elowan!",
		alien={"Hmm.  I would be most interested in the basis of your demand."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="Where is your home world?",
		alien={"Our home world is located at Semias 3 - 5,66."}
	}
	questions[51001] = {
		action="branch",
		choices = {
			{ text="We will attack you if you do not.",  goto=51100 },
			{ text="Your attacks upon them are wrong!", goto=51200 },
			{ text="The Elowan are no threat to you.", goto=51300 },
			{ text="We will do anything you ask to bring about peace.", goto=51400 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[51100] = {
		action="jump", goto=51101,
		player="We will attack you if you do not.",
		alien={"Do you challenge us of the elite guard with the supreme delete functionality?  Prepare to feel the full force of our weaponry!" }
	}
	questions[51101] = {
		action="attack",
		player="Aggressive reptiles, I demand that you surrender your vessel(s)",
		alien={"Very well." }
	}
	questions[51200] = {
		action="jump", goto=51001,
		player="Your attacks upon them are wrong!",
		alien={"The Thrynn greatly regret the necessity to bring destruction to another alien species.  Unfortunately war is the only possible method to resolve conflicts if diplomats fail and negotiations break down.  We were unjustly attacked first and if we do not end this conflict now it may continue indefinitely causing a much greater loss of life.  This responsibility we must not leave for our grandchildren." }
	}
	questions[51300] = {
		action="jump", goto=51001,
		player="The Elowan are no threat to you.",
		alien={"At the current time this may be true, but it was not true in the recent past and may not be true in the future.  This universe is ruled by the aggressive use of force and the only true source of peace is victory." }
	}
	questions[51400] = {
		action="jump", goto=51001,
		player="We will do anything you ask to bring about peace.",
		alien={"Perhaps this idea has merit.  Profess to the Elowan an interest in their homeworld location and take appropriate actions from their response." }
	}

	
	questions[53000] = {
		action="jump", goto=53001,
		player="",
		alien={"The Thrynn Confederacy values technological progress as the primary goal of our society.  We will pay well for the following items:"}
	}
	questions[53001] = {
		action="branch",
		choices = {
			{ text="Elowan Shield Capacitor",  goto=53100 },
			{ text="Your attacks upon them are wrong!", goto=53200 },
			{ text="The Elowan are no threat to you.", goto=53300 },
			{ text="We will do anything you ask to bring about peace.", goto=53400 },
			{ text="<Back>", goto=50000 }
		}
	}
	questions[53100] = {
		action="jump", goto=53001,
		player="",
		alien={"The Elowan salvaged and duplicate a very advanced shielding module to protect their ships.  We will pay well for any Shield Capacitors that you are able to salvage." }
	}
	questions[53200] = {
		action="jump", goto=53001,
		player="",
		alien={"We have been made aware of a device known as The Spiral Lens.  This device was stolen from us by pirates.  Our intelligence has located it on the planet Eocho in the Etarlam 172,118 system at coordinates 82N X 55E.  We will pay well for its return." }
	}
	questions[53300] = {
		action="jump", goto=53001,
		player="",
		alien={"The Bar-zhon store considerable information on this sector inside a massive computer system in their ship.  If you are fortunate enough to retrieve an intact data core we will pay well for your efforts." }
	}
	questions[53400] = {
		action="jump", goto=53001,
		player="",
		alien={"The Bar-zhon pirates have developed an interesting new technology similar to our own superior propulsion systems.  If you happen to salvage a coalition afterburner unit we will purchase it because it's function is of great interest to us." }
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
		alien={"Our government system has changed many times over the years.  Our system currently organized in a military hierarchy with extreme upward mobility based ability and nothing else.  Diplomatic skill, ability to form temporary alliances based on mutual goals is the key to success yet Mavericks are also given a free hand." }
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
		alien={"We have heard of this.  It was widely believed that all Noah colony ships were destroyed by the collaboration of the Laytonites and the Elowan.    In the past we were allies, your race and mine, united in a common cause.  We must unite to rid the galaxy of those who would oppose us." }
	}
	questions[11145] = {
		action="jump", goto=11141,
		player="So you were close allies with humanity in the past?",
		alien={"Indeed, even though that Empire was no more, its legacy shines the way to a bright future.  We shall build another empire and you shall be our allies and rule with us.  Commerce and mutual aid against a common cause - these are the important things to remember." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Tell us about the Elowan.",  goto=21000 },
			{ text="Tell us about other alien races.",  goto=22000 },
			{ text="Why can't you just all get along?",  goto=23000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=21101,
		player="Tell us about the Elowan.",
		alien={"The Elowan are deceitful and untrustworthy carnivorous plant creatures, mutated into an aggressive race which seeks the destruction of their creators, the benevolent Thrynn." }
	}
	questions[22000] = {
		action="jump", goto=22101,
		player="Tell us about other alien races.",
		alien={"Beside the Elowan, we have knowledge of the Minex, the Bar-Zhon, the Spemin, and the Tafel.  Of whom do you direct your attention?" }
	}
	questions[23000] = {
		action="jump", goto=23001,
		player="Why can't you just all get along?",
		alien={"Leave us now you pacifist alien thrawling." }
	}
	questions[23001] = {
		action="jump", goto=24100,
		player="Tell us about...",
		alien={"(Roar!)" }
	}
	questions[21101] = {
		action="branch",
		choices = {
			{ text="The Elowan are intelligent plants?",  goto=21100 },
			{ text="The Elowan are dangerous?",  goto=21200 },
			{ text="Tell us about the Elowan warships.",  goto=21300 },
			{ text="Why do you continue to fight them?",  goto=21400 },
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
	questions[21400] = {
		action="jump", goto=21101,
		player="Why do you continue to fight them?",
		alien={"The Elowan speak fairly but they are contagion, and would spread quickly and declare war if they had not been contained by the selfless Thrynn.  They seek to deceive others into becoming their allies out of desperation of their present condition only." }
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
		action="jump", goto=22101,
		player="Tell us about the Minex.",
		alien={"The Minex used to be more open in the past but have closed their borders due to Elowan treachery.  Unfortunately they have left the burden upon us to control the contagion." }
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
    mass = 5                        -- 1=tiny, 10=huge
	engineclass = 6
	shieldclass = 6
	armorclass = 3
	laserclass = 5
	missileclass = 5
	laser_modifier = 100			-- % of damage received, used for racial abilities, 0-100 %
	missile_modifier = 80			-- % of damage received, used for racial abilities, 0-100%


	--5 COMBAT DROP ITEMS (see stfltitems.xml), default (31) = iron
	--drop rate is based on values less than the random number, so 0 = always, 100 = never
	--If you set low probabilities here and none are chosen, game will choose a random mineral (id # 30-54) to fill in
	--14 -  Thrynn Battle Armor
	--16 -  Whining Orb
	
	DROPITEM1 = 14;	    DROPRATE1 = 95;		DROPQTY1 = 1
	DROPITEM2 = 16;		DROPRATE2 = 97;	    DROPQTY2 = 1
	DROPITEM3 = 34;		DROPRATE3 = 20;		DROPQTY3 = 4
	DROPITEM4 = 35;		DROPRATE4 = 40;		DROPQTY4 = 2
	DROPITEM5 = 54;		DROPRATE5 = 80;		DROPQTY5 = 2


	--initialize dialog
	if player_profession == "military" and active_quest == 30 and artifact10 == 0 then
		first_question = 74000
	elseif player_profession == "military" and active_quest == 30 and artifact10 > 0 then
		first_question = 74100
	elseif player_profession == "military" and active_quest == 35 and artifact22 > 0 then
		first_question = 79000
	elseif player_profession == "freelance" and active_quest == 32 and artifact10 == 0 then
		first_question = 96000
	elseif player_profession == "freelance" and active_quest == 32 and artifact10 > 0 then
		first_question = 96100
	elseif player_profession == "freelance" and active_quest == 34 and artifact18 == 1 then
		first_question = 98000
	elseif player_profession == "freelance" and active_quest == 35 and artifact27 == 0 and artifact28 == 0 then
		first_question = 99000
	elseif player_profession == "freelance" and active_quest == 35 and artifact27 == 1 and artifact28 == 0 then
		first_question = 99500
--	elseif artifact10 > 10 then
--		first_question = 500	
--	elseif artifact10 > 13 then
--		first_question = 600
--	elseif artifact10 > 15 then
--		first_question = 700
--	elseif artifact10 > 20 then
--		first_question = 800
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
	    RESPONSE = "Die you vile murderous alien!"
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
		action="terminate",
		player="This is Captain [CAPTAIN] of the starship [SHIPNAME].  Me we ask you a few questions?",
		alien={"Do not detain us.  We are currently attempting to repulse an unprovoked Elowan offensive." }
	}


	
	questions[74100] = {
		action="jump", goto=1,
		artifact10 = 0,
--		active_quest = active_quest + 1,
--		ship_laser_class = ship_laser_class + 1,
		player="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have a Elowan Shield Capacitor for you.",
		alien={"Very well.  You have shown your willingness to assist us against irrational aggression.  We are transmitting specifications for our advanced laser cannons.  Your people should be able to adapt the technology easily. " }
	}

	questions[79000] = {
		action="jump", goto=79001,
		player="This is Captain [CAPTAIN] of the starship [SHIPNAME].  We have a Minex electronics system here.  Are you interested in it?",
		alien={"Yes [CAPTAIN].  We will pay well for Minex technology.  We will be willing to upgrade your lasers to class 6 for the device. " }
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
--		active_quest = active_quest + 1,
--		ship_laser_class = 6,
		player="",
		alien={"Our engineers are being sent over your ship as we speak. " }
	}
	questions[79200] = {
		action="jump", goto=1,
		player="",
		alien={"Very well." }
	}

	questions[96000] = {
		action="terminate",
		player="I understand you want a shield capacitor?",
		alien={"You understand correctly.  Bring one to us and we will upgrade your laser weaponry if possible. I do not have the time to elaborate further as we are currently attempting to repulse an unprovoked Elowan offensive." }
	}


	questions[96100] = {
		action="jump", goto=96101,
		artifact10 = 0,
--		active_quest = active_quest + 1,
--		ship_laser_class = ship_laser_class + 1,
		player="I have a Elowan Shield Capacitor for you.",
		alien={"Very well.  You have shown your willingness to assist us against irrational aggression.  We are transmitting specifications for our advanced laser cannons.  Your people should be able to adapt the technology easily. " }
	}
	questions[96101] = {
		action="jump", goto=1,
--	    player_money = player_money +  2000,
	    player="Why have you not been able to salvage one yourself before now?",
		alien={"We do not truly need the unit.  Your actions have increased the Elowan's distrust of Myrrdan.  This is not a negative thing.   The Thrynn Confederacy is willing to enter to a profitable agreement for your actions." }
	}

	questions[98000] = {
		action="jump", goto=98001,
		player="Would you be interested in purchasing incredibly old artistic containers?",
		alien={"Hmm.  I confirm the age of the artifacts and their unusual structure.  The artistic design does not match up anything in our databases of known alien races.  I am willing to offer an amount of 16,000 M.U. Myrrdan resource units.  Do you concur?" }
	}
	questions[98001] = {
		action="branch",
		choices = {
			{ text="Yes, I agree to 16,000 M.U. ",  goto=98100 },
			{ text="No.",  goto=98200 },
		}
	}
	questions[98100] = {
		artifact18 = 0,
--		player_money = player_money + 12000,
---		active_quest = active_quest + 1,
		action="jump", goto=1,
		player="",
		alien={"Commencing exchange. " }
	}
	questions[98200] = {
		action="jump", goto=1,
		player="",
		alien={"Very well. " }
	}
	questions[99000] = {
		action="jump", goto=99001,
		player="Tell us about the Elowan – Tafel conflict",
		alien={"The Elowan are untrustworthy, deceitful, and that is all.  The Tafel staked first claim to the planet and the Elowan aggressively invaded and now are attempting to justify their aggression with fraudulent claims.  We have notified the Tafel of our full tactical support if they decide on military action to resolve the conflict." }
	}
	questions[99001] = {
		action="jump", goto=1,
		player="Do you know how the conflict started?",
		alien={"No, we have only recently focused interest on the situation." }
	}
	questions[99500] = {
		action="jump", goto=1,
		player="Tell us about this drone that one of your ships launched.",
		alien={"Our databanks contained no reference to any drone of that type and it is far too primitive to be of Thrynn manufacture.  A guess would be that it is of Tafel or pirate manufacture." }
	}

	questions[500] = {
		action="jump", goto=501,
		player="Can you tell me about...",
		alien={"Our scanners indicate that you have aboard your ship an Elowan Shield Capacitor.  This device is of interest to us.  We will buy all such devices from you for 2000 M.U. equivalent Myrrdan resources per device.  Agreed?" }
	}
	questions[501] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=510 },
			{ text="No.",  goto=520 },
		}
	}
	questions[510] = {
--		player_money = player_money + artifact10 * 2000,
		artifact10 = 0,
		action="jump", goto=1,
		player="",
		alien={"Commencing exchange. " }
	}
	questions[520] = {
		action="jump", goto=1,
		player="",
		alien={"Very well. " }
	}
	

	questions[600] = {
		action="jump", goto=601,
		player="Can you tell me about...",
		alien={"Our scanners indicate that you have aboard your ship a Spiral Lens.  This device is of interest to us.  We will buy it from you for 7000 M.U. equivalent Myrrdan resources.  Agreed?" }
	}
	questions[601] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=610 },
			{ text="No.",  goto=620 },
		}
	}
	questions[610] = {
--		player_money = player_money + 7000,
		artifact13 = 0,
		action="jump", goto=1,
		player="",
		alien={"Commencing exchange. " }
	}
	questions[620] = {
		action="jump", goto=1,
		player="",
		alien={"Very well. " }
	}



	questions[700] = {
		action="jump", goto=701,
		player="Can you tell me about...",
		alien={"Our scanners indicate that you have aboard your ship a Bar-Zhon Data Cube.  This device is of interest to us.  We will buy all such devices from you for 2500 M.U. equivalent Myrrdan resources per device.  Agreed?" }
	}
	questions[701] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=710 },
			{ text="No.",  goto=720 },
		}
	}
	questions[710] = {
--		player_money = player_money + artifact15 * 2500,
		artifact15 = 0,
		action="jump", goto=1,
		player="",
		alien={"Commencing exchange. " }
	}
	questions[720] = {
		action="jump", goto=1,
		player="",
		alien={"Very well. " }
	}



	questions[800] = {
		action="jump", goto=801,
		player="Can you tell me about...",
		alien={"Our scanners indicate that you have aboard your ship a Coalition Afterburner.  This device is of interest to us.  We will buy all such devices from you for 2000 M.U. equivalent Myrrdan resources per device.  Agreed?" }
	}
	questions[801] = {
		action="branch",
		choices = {
			{ text="Yes, I agree.",  goto=810 },
			{ text="No.",  goto=820 },
		}
	}
	questions[810] = {
--		player_money = player_money + artifact20 * 2000,
		artifact20 = 0,
		action="jump", goto=1,
		player="",
		alien={"Commencing exchange. " }
	}
	questions[820] = {
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

