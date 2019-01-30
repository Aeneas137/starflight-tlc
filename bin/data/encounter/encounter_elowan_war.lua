--[[
	ENCOUNTER SCRIPT FILE: ELOWAN  WAR

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
		alien={"Please thee not, false flattery be not our foresight","Of thee this I prognosticate: irrationality plagues thy inconsistent action.","Pray cease thy unnecessary dementia."} 	}
	greetings[2] = {
		action="",
		player="We bow to your wonderful magnificence and ask that you do not harm our insignificant selves.",
		alien={"Please thee not, false flattery be not our foresight","Of thee this I prognosticate: irrationality plagues thy inconsistent action.","Pray cease thy unnecessary dementia."}	}
	greetings[3] = {
		action="",
		player="Greetings oh highest of the high most great alien beings.",
		alien={"Please thee not, false flattery be not our foresight","Of thee this I prognosticate: irrationality plagues thy inconsistent action.","Pray cease thy unnecessary dementia."} }
	greetings[4] = {
		action="",
		player="We respectfully request that you identify your vastly superior selves.",
		alien={"Please thee not, false flattery be not our foresight","Of thee this I prognosticate: irrationality plagues thy inconsistent action.","Pray cease thy unnecessary dementia."} }
	greetings[5] = {
		action="",
		player="We humbly suggest that you may wish to identify yourselves. If not, that is perfectly o.k.",
		alien={"Please thee not, false flattery be not our foresight","Of thee this I prognosticate: irrationality plagues thy inconsistent action.","Pray cease thy unnecessary dementia."} }


		
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Please do not harm us oh most high and mighty.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[2] = {
		action="",
		player="Greetings and felicitations oh kind and merciful alien.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[3] = {
		action="",
		player="Please do not blast us into atomic particles.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[4] = {
		action="",
		player="Take pity on us who are not fit to grovel in your waste products.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[5] = {
		action="",
		player="We can see that you are indeed the true race.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[6] = {
		action="",
		player="Pray enlighten us with your gems of infinite wisdom.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[7] = {
		action="",
		player="We truly are not worth your trouble to destroy.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[8] = {
		action="",
		player="We want to bathe in your ever spewing fountain of knowledge.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
	statements[9] = {
		action="",
		player="We understand that you could destroy us if you chose. I beg you not to do this.",
		alien={"We ask only that you could either violence nor trespass against us.","Pray, do not listen to such things as the Thrynn might say of us, 'tis naught but empty slander.","'Tis but false concepts art thou laboring under."} }
		
	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD


	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"We are the Elowan, those of the vine and spore, allies of the peaceful, concern'd with such things as may be called beauty and perhaps truth."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"In necessity grows the strength of survival.  The Minex had'st provoked the ire of all in their foolishness.  Provincial 'twas their mistake of provoking both the Thrynn and ourselves with this onslaught.  The feudal conflict of the Thrynn hadst been transformed into a provisional alliance for withstanding this peril."}
	}
	questions[30000] = {
		action="jump", goto=31001,
		player="Can you tell us about your history?",
		alien={"Preytell thy every inquiry will be answered."}
	}
	questions[40000] = {
		action="jump", goto=41001,
		player="Tell us about the Ancients.",
		alien={"Too much has been lost from our racial knowledge, as little r'mained from the days of scattering." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your ships and defenses?",  goto=51000 },
			{ text="Where is your homeworld?",  goto=52000 },
			{ text="Can you tell us any current news?",  goto=60000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[60000] = {
		action="jump", goto=21001,
		player="",
		alien={"In necessity grows the strength of survival.  The Minex had'st provoked the ire of all in their foolishness.  Provincial 'twas their mistake of provoking both the Thrynn and ourselves with this onslaught.  The feudal conflict of the Thrynn hadst been transformed into a provisional alliance for withstanding this peril."}
	}

	questions[51000] = {
		action="jump", goto=51101,
		player="What can you tell us about your ships and defenses?",
		alien={"In truth, essentials will we not to divulge.  Abstractions befitting allies we have no trouble sharing."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="Where is your homeworld?",
		alien={"Encroach upon our sacred colony Cailte 4 - 61,22 at thy peril.  Thy existence shall pass into what thou may call'st thine third life if any betrayal doth proceed." }
	}
	questions[51101] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your ships?",  goto=51100 },
			{ text="How do your ships do in battle?", goto=51200 },
			{ text="I can't help but notice your tight formations.", goto=51300 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[51100] = {
		action="jump", goto=51101,
		player="What can you tell us about your ships?",
		alien={"Doth thy ship not possess sensors?  Our tiny but incredibly sophisticated vessels are equipped with powerful shielding and nearly endless supply of energy projectile weaponry."}
	}
	questions[51200] = {
		action="jump", goto=51101,
		player="How do your ships do in battle?",
		alien={"'Tis a dance of thy greatest dreams united with the ugliness of death.  Perchance nothing demonstrates the truth of existence in like spirit.  We fly the abstract patterns of infinity with the precision of rain watering the ground with projectiles of death 'ere our young may'st continue to stand under the rain of life."}
	}
	questions[51300] = {
		action="jump", goto=51101,
		player="I can't help but notice your tight formations.",
		alien={"Patterns of strength unfold endlessly and the Thrynn lack the innate cooperation the military mind implies.  The rotation of the wounded permit refreshment of their screens, as the Thrynn lack the spatial coordination to control effectively any but the most simple of particle beam weaponry."}
	}

		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your race?",  goto=11000 },
			{ text="How does a race of sentient plants reproduce?", goto=12000 },
			{ text="Why do you say you are allies of the peaceful?", goto=13000 },
			{ text="Where is your homeworld?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="What can you tell us about your race?",
		alien={"At a time when we reach an age of adolescence we are uprooted. In so doing we are become omniverous producers, capable of sustaining ourselves thusly upon photosynthesis with the occasional consumption of meat or plant products." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="How does a race of sentient plants reproduce?",
		alien={"Mayhap one of every 300 of our number doth stay rooted within the ground, and in so doing is its head then transformed into a melon-like fruit called headfruit wherein lie the many seeds of our future.  The sacred harvest festival doth temporarily a third of our race incapacitate, and dwell upon us the duty of traversing and scattering the code of life." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="Why do you say you are allies of the peaceful?",
		alien={"Is not violence, above all things, most base and vile? 'Tis only as a necessity, against those who use it without hesitation, in its application." }
	}
	questions[14000] = {
		action="jump", goto=11001,
		player="Where is your homeworld?",
		alien={"Encroach upon our sacred colony Cailte 4 - 61,22 at thy peril.  Thy existence shall pass into what thou may call'st thine third life if any betrayal doth proceed." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Who are the Thrynn?",  goto=21000 },
			{ text="Why have the Minex attacked you?",  goto=22000 },
			{ text="Do you now have knowledge of this interspecies virus?",  goto=23000 },
			{ text="Have you made contact with other races being attacked?",  goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=21101,
		player="Who are the Thrynn?",
		alien={"An untrustworthy race, one that hath pursued the most vile injustices against us.  In necessity thou shalt observe their aid in our survival, as we now intercede in theirs." }
	}
	questions[22000] = {
		action="jump", goto=21001,
		player="",
		alien={"'Tis an unprovoked action, in all regards, that the Minex hath wrought.  Yet in hope the danger presented by an enemy in truth, unlike ourselves, doest sway the aggressions of the Thrynn away from us." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="",
		alien={"Indeed the great devastation of this affliction had'st begun its work and spared naught many.  Little do we know of that lies within any resolution to this matter." }
	}
	questions[24000] = {
		action="jump", goto=21001,
		player="",
		alien={"'Twas only recently that representatives of the Tafel and Bar-zhon did us contact.  Seeking aid and strength we hath not in spare to provide to them, nor they to us.  Yet not in vain their efforts were made, as agreements to share technology and intelligence would'st perhaps all be saved." }
	}
	questions[21101] = {
		action="branch",
		choices = {
			{ text="How did this alliance with the Thrynn occur?",  goto=21100 },
			{ text="Are you able to withstand the Minex attacks?",  goto=21200 },
			{ text="How do you believe you are superior to the Thrynn?",  goto=21300 },
			{ text="What tactics do the Minex use against you?",  goto=21400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[21100] = {
		action="jump", goto=21101,
		player="",
		alien={"A chance encroachment of our territory by the Minex occurred during an engagement with the Thrynn.  Indiscriminate was the slaughter of both Elowan and Thrynn by the sizable task force.  Upon knowledge of their peral, weary antagonism towards our ships withdrawn, and both forces unit'd in repusing the unjust provocation.  A tender seed that day was planted, Thrynn lasers touched them most effectively, perchance our ships the greatest at coordination of defense was proven." }
	}
	questions[21200] = {
		action="jump", goto=21101,
		player="",
		alien={"The Minex profane and vile attacks have cut bitterly.  Perchance with fortune, the Thrynn's fierce and ruthless attacks, balanced with our fleet support, has heretofore broken all waves. " }
	}
	questions[21300] = {
		action="jump", goto=21101,
		player="",
		alien={"In truth doth our greatest strength lie within our greatest weakness, the precision of our recall, as both interpretation of patterns and a lack of focus contribute to our character." }
	}
	questions[21400] = {
		action="jump", goto=21101,
		player="",
		alien={"Great ignorance doth thou find in the Minex in their pursuit of war.  Only do they attack, with methodical precision, the outlines of our territory.  They speak only with their weapons fiercely, yet great tactical advantage abstain, from failing to thrust towards colony worlds.  An unofficial alliance hath formed, with us as scouts and denfense, and unified taskforces with both our fleets and the Thrynn countering in response." }
	}

	questions[31001] = {
		action="branch",
		choices = {
			{ text="Have you established any other colonies?",  goto=31000 },
			{ text="How did the conflict with the Thrynn start?",  goto=32000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31000] = {
		action="jump", goto=31001,
		player="Have you established any other colonies?",
		alien={"None but a few of us remain, for this last location we defend, as now the Minex assume the prior mantle of the Thrynn." }
	}
	questions[32000] = {
		action="jump", goto=32101,
		player="How did the conflict with the Thrynn start?",
		alien={"'Twas in 2770 that the empire did discover our home system of Eleran and both races and eventually uplift. Contact first was made with the wretched Thrynn. Therefore we were not at first accepted as sentient for they spoke wrongly of us and were not questioned in their slander." }
	}
	questions[32101] = {
		action="branch",
		choices = {
			{ text="But how did the actual conflict began?",  goto=32100 },
			{ text="Where is Eleran located?",  goto=32200 },
			{ text="<Back>", goto=31001 }
		}
	}

	questions[32100] = {
		action="jump", goto=32101,
		player="But how did the actual conflict began?",
		alien={"Both our races developed sub-luminal travel and the final bastion of our home world invaded.  Conflict thus arose from the hunting instinct of Thrynn: sentient beings being the most dangerous prey, and the headfruit of the planted Elowan the most defended and coveted prize." }
	}
	questions[32200] = {
		action="jump", goto=32201,
		player="Where is Eleran located?",
		alien={"Nay this expanse be not our origin.  'Twas only 450 festival cycles our flight from a dying Empire, a wave of flaring stars, and the machinations of the murderous Thrynn did we flee thither.  Of only the former two dangers were we successful in avoiding." }
	}

	questions[32201] = {
		action="branch",
		choices = {
			{ text="Dying empire?", goto=32210 },
			{ text="A wave of flaring stars?", goto=32220 },
			{ text="<Back>", goto=32101 }
		}
	}
	questions[32210] = {
		action="jump", goto=32201,
		player="",
		alien={"If the Nyssian tales be true, the Empire of Man, yourselves a scattered remnant, had'st been destroyed all heretofore save yourselves.  In sooth, the truth of this matter we know little."}
	}
	questions[32220] = {
		action="jump", goto=32221,
		player="",
		alien={"'Tis not known whether any ancient ones survive still.  Mayhap only their heinous legacy, the crystal planet, has been left us.  Its evil task was to destroy all that lives within its range.  Why, we know not.  It's current influence is far from here." }
	}
	questions[32221] = {
		action="jump", goto=32222,
		player="Why would the ancients give us endurium then kill us?",
		alien={"Little is known to us on this subject.  The Nyssian storytellers, in their manner, describe an enemy of the ancient ones named Uyo.  This described homocidal race of withered beings may have been the target for such a device, with our ancestors and thine, only unintended targets."}
	}
	questions[32222] = {
		action="jump", goto=32201,
		player="<More>",
		alien={"'Tis possible the appearance of genocidal technologies, the ill-timed and irrational actions of the Minex, may be mere harbringers of the Uyo's return.  If not responsible for their actions, e'er their innocence be shown, some slight knowledge of this matter may they possess." }
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
		alien={"Thou doest now encounter the Elowan.  'Tis a difficult yet hopeful age we endure.","Statest thou thine intentions and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.","We are Elowan.  We greet thee with no malice, and bear thee no ill will."} }
	greetings[2] = {
		action="",
		player="I am Captain [CAPTAIN] of the starship [SHIPNAME].",
		alien={"Thou doest now encounter the Elowan.  'Tis a difficult yet hopeful age we endure.","Statest thou thine intentions and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.","We are Elowan.  We greet thee with no malice, and bear thee no ill will."} }
	greetings[3] = {
		action="",
		player="Hi there. How are ya? I'm Captain [CAPTAIN]. We're peaceful explorers.",
		alien={"Thou doest now encounter the Elowan.  'Tis a difficult yet hopeful age we endure.","Statest thou thine intentions and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.","We are Elowan.  We greet thee with no malice, and bear thee no ill will."} }
	greetings[4] = {
		action="",
		player="Dude, that is one green ship you have there!",
		alien={"Thou doest now encounter the Elowan.  'Tis a difficult yet hopeful age we endure.","Statest thou thine intentions and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.","We are Elowan.  We greet thee with no malice, and bear thee no ill will."} }
	greetings[5] = {
		action="",
		player="How's it going, weird, carnivorous plant things?",
		alien={"Thou doest now encounter the Elowan.  'Tis a difficult yet hopeful age we endure.","Statest thou thine intentions and name thyself.  Thou willingly encroach upon a war zone?  We are the Elite Elowan Defense force.","We are Elowan.  We greet thee with no malice, and bear thee no ill will."} }

	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship seems to be very powerful.",
		alien={"Such concepts of respect doth we reflect in like measure upon thee.","Trust me like measure shall be granted upon the trustworthy.","Faith and understanding doth we extend to thine companions and thou kind."} }
	statements[2] = {
		action="",
		player="Your ship appears very unusual.",
		alien={"Such concepts of respect doth we reflect in like measure upon thee.","Trust me like measure shall be granted upon the trustworthy.","Faith and understanding doth we extend to thine companions and thou kind."} }
	statements[3] = {
		action="",
		player="We come in peace from Myrrdan, please trust me.",
		alien={"Such concepts of respect doth we reflect in like measure upon thee.","Trust me like measure shall be granted upon the trustworthy.","Faith and understanding doth we extend to thine companions and thou kind."} }
	statements[4] = {
		action="",
		player="There is no limit to what both our races can gain from mutual exchange.",
		alien={"Such concepts of respect doth we reflect in like measure upon thee.","Trust me like measure shall be granted upon the trustworthy.","Faith and understanding doth we extend to thine companions and thou kind."} }
	statements[5] = {
		action="",
		player="Perhaps some day our young shall play and romp together in the blissful light of harmony and friendship.",
		alien={"Such concepts of respect doth we reflect in like measure upon thee.","Trust me like measure shall be granted upon the trustworthy.","Faith and understanding doth we extend to thine companions and thou kind."} }
		 



	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart 


	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"We are the Elowan, those of the vine and spore, allies of the peaceful, concern'd with such things as may be called beauty and perhaps truth."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"In necessity grows the strength of survival.  The Minex had'st provoked the ire of all in their foolishness.  Provincial 'twas their mistake of provoking both the Thrynn and ourselves with this onslaught.  The feudal conflict of the Thrynn hadst been transformed into a provisional alliance for withstanding this peril."}
	}
	questions[30000] = {
		action="jump", goto=31001,
		player="Can you tell us about your history?",
		alien={"Preytell thy every inquiry will be answered."}
	}
	questions[40000] = {
		action="jump", goto=41001,
		player="Tell us about the Ancients.",
		alien={"Too much has been lost from our racial knowledge, as little r'mained from the days of scattering." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your ships and defenses?",  goto=51000 },
			{ text="Where is your homeworld?",  goto=52000 },
			{ text="Can you tell us any current news?",  goto=60000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[60000] = {
		action="jump", goto=21001,
		player="",
		alien={"In necessity grows the strength of survival.  The Minex had'st provoked the ire of all in their foolishness.  Provincial 'twas their mistake of provoking both the Thrynn and ourselves with this onslaught.  The feudal conflict of the Thrynn hadst been transformed into a provisional alliance for withstanding this peril."}
	}

	questions[51000] = {
		action="jump", goto=51101,
		player="What can you tell us about your ships and defenses?",
		alien={"In truth, essentials will we not to divulge.  Abstractions befitting allies we have no trouble sharing."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="Where is your homeworld?",
		alien={"Encroach upon our sacred colony Cailte 4 - 61,22 at thy peril.  Thy existence shall pass into what thou may call'st thine third life if any betrayal doth proceed." }
	}
	questions[51101] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your ships?",  goto=51100 },
			{ text="How do your ships do in battle?", goto=51200 },
			{ text="I can't help but notice your tight formations.", goto=51300 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[51100] = {
		action="jump", goto=51101,
		player="What can you tell us about your ships?",
		alien={"Doth thy ship not possess sensors?  Our tiny but incredibly sophisticated vessels are equipped with powerful shielding and nearly endless supply of energy projectile weaponry."}
	}
	questions[51200] = {
		action="jump", goto=51101,
		player="How do your ships do in battle?",
		alien={"'Tis a dance of thy greatest dreams united with the ugliness of death.  Perchance nothing demonstrates the truth of existence in like spirit.  We fly the abstract patterns of infinity with the precision of rain watering the ground with projectiles of death 'ere our young may'st continue to stand under the rain of life."}
	}
	questions[51300] = {
		action="jump", goto=51101,
		player="I can't help but notice your tight formations.",
		alien={"Patterns of strength unfold endlessly and the Thrynn lack the innate cooperation the military mind implies.  The rotation of the wounded permit refreshment of their screens, as the Thrynn lack the spatial coordination to control effectively any but the most simple of particle beam weaponry."}
	}

		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your race?",  goto=11000 },
			{ text="How does a race of sentient plants reproduce?", goto=12000 },
			{ text="Why do you say you are allies of the peaceful?", goto=13000 },
			{ text="Where is your homeworld?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="What can you tell us about your race?",
		alien={"At a time when we reach an age of adolescence we are uprooted. In so doing we are become omniverous producers, capable of sustaining ourselves thusly upon photosynthesis with the occasional consumption of meat or plant products." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="How does a race of sentient plants reproduce?",
		alien={"Mayhap one of every 300 of our number doth stay rooted within the ground, and in so doing is its head then transformed into a melon-like fruit called headfruit wherein lie the many seeds of our future.  The sacred harvest festival doth temporarily a third of our race incapacitate, and dwell upon us the duty of traversing and scattering the code of life." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="Why do you say you are allies of the peaceful?",
		alien={"Is not violence, above all things, most base and vile? 'Tis only as a necessity, against those who use it without hesitation, in its application." }
	}
	questions[14000] = {
		action="jump", goto=11001,
		player="Where is your homeworld?",
		alien={"Encroach upon our sacred colony Cailte 4 - 61,22 at thy peril.  Thy existence shall pass into what thou may call'st thine third life if any betrayal doth proceed." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Who are the Thrynn?",  goto=21000 },
			{ text="Why have the Minex attacked you?",  goto=22000 },
			{ text="Do you now have knowledge of this interspecies virus?",  goto=23000 },
			{ text="Have you made contact with other races being attacked?",  goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=21101,
		player="Who are the Thrynn?",
		alien={"An untrustworthy race, one that hath pursued the most vile injustices against us.  In necessity thou shalt observe their aid in our survival, as we now intercede in theirs." }
	}
	questions[22000] = {
		action="jump", goto=21001,
		player="",
		alien={"'Tis an unprovoked action, in all regards, that the Minex hath wrought.  Yet in hope the danger presented by an enemy in truth, unlike ourselves, doest sway the aggressions of the Thrynn away from us." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="",
		alien={"Indeed the great devastation of this affliction had'st begun its work and spared naught many.  Little do we know of that lies within any resolution to this matter." }
	}
	questions[24000] = {
		action="jump", goto=21001,
		player="",
		alien={"'Twas only recently that representatives of the Tafel and Bar-zhon did us contact.  Seeking aid and strength we hath not in spare to provide to them, nor they to us.  Yet not in vain their efforts were made, as agreements to share technology and intelligence would'st perhaps all be saved." }
	}
	questions[21101] = {
		action="branch",
		choices = {
			{ text="How did this alliance with the Thrynn occur?",  goto=21100 },
			{ text="Are you able to withstand the Minex attacks?",  goto=21200 },
			{ text="How do you believe you are superior to the Thrynn?",  goto=21300 },
			{ text="What tactics do the Minex use against you?",  goto=21400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[21100] = {
		action="jump", goto=21101,
		player="",
		alien={"A chance encroachment of our territory by the Minex occurred during an engagement with the Thrynn.  Indiscriminate was the slaughter of both Elowan and Thrynn by the sizable task force.  Upon knowledge of their peral, weary antagonism towards our ships withdrawn, and both forces unit'd in repusing the unjust provocation.  A tender seed that day was planted, Thrynn lasers touched them most effectively, perchance our ships the greatest at coordination of defense was proven." }
	}
	questions[21200] = {
		action="jump", goto=21101,
		player="",
		alien={"The Minex profane and vile attacks have cut bitterly.  Perchance with fortune, the Thrynn's fierce and ruthless attacks, balanced with our fleet support, has heretofore broken all waves. " }
	}
	questions[21300] = {
		action="jump", goto=21101,
		player="",
		alien={"In truth doth our greatest strength lie within our greatest weakness, the precision of our recall, as both interpretation of patterns and a lack of focus contribute to our character." }
	}
	questions[21400] = {
		action="jump", goto=21101,
		player="",
		alien={"Great ignorance doth thou find in the Minex in their pursuit of war.  Only do they attack, with methodical precision, the outlines of our territory.  They speak only with their weapons fiercely, yet great tactical advantage abstain, from failing to thrust towards colony worlds.  An unofficial alliance hath formed, with us as scouts and denfense, and unified taskforces with both our fleets and the Thrynn countering in response." }
	}

	questions[31001] = {
		action="branch",
		choices = {
			{ text="Have you established any other colonies?",  goto=31000 },
			{ text="How did the conflict with the Thrynn start?",  goto=32000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31000] = {
		action="jump", goto=31001,
		player="Have you established any other colonies?",
		alien={"None but a few of us remain, for this last location we defend, as now the Minex assume the prior mantle of the Thrynn." }
	}
	questions[32000] = {
		action="jump", goto=32101,
		player="How did the conflict with the Thrynn start?",
		alien={"'Twas in 2770 that the empire did discover our home system of Eleran and both races and eventually uplift. Contact first was made with the wretched Thrynn. Therefore we were not at first accepted as sentient for they spoke wrongly of us and were not questioned in their slander." }
	}
	questions[32101] = {
		action="branch",
		choices = {
			{ text="But how did the actual conflict began?",  goto=32100 },
			{ text="Where is Eleran located?",  goto=32200 },
			{ text="<Back>", goto=31001 }
		}
	}

	questions[32100] = {
		action="jump", goto=32101,
		player="But how did the actual conflict began?",
		alien={"Both our races developed sub-luminal travel and the final bastion of our home world invaded.  Conflict thus arose from the hunting instinct of Thrynn: sentient beings being the most dangerous prey, and the headfruit of the planted Elowan the most defended and coveted prize." }
	}
	questions[32200] = {
		action="jump", goto=32201,
		player="Where is Eleran located?",
		alien={"Nay this expanse be not our origin.  'Twas only 450 festival cycles our flight from a dying Empire, a wave of flaring stars, and the machinations of the murderous Thrynn did we flee thither.  Of only the former two dangers were we successful in avoiding." }
	}

	questions[32201] = {
		action="branch",
		choices = {
			{ text="Dying empire?", goto=32210 },
			{ text="A wave of flaring stars?", goto=32220 },
			{ text="<Back>", goto=32101 }
		}
	}
	questions[32210] = {
		action="jump", goto=32201,
		player="",
		alien={"If the Nyssian tales be true, the Empire of Man, yourselves a scattered remnant, had'st been destroyed all heretofore save yourselves.  In sooth, the truth of this matter we know little."}
	}
	questions[32220] = {
		action="jump", goto=32221,
		player="",
		alien={"'Tis not known whether any ancient ones survive still.  Mayhap only their heinous legacy, the crystal planet, has been left us.  Its evil task was to destroy all that lives within its range.  Why, we know not.  It's current influence is far from here." }
	}
	questions[32221] = {
		action="jump", goto=32222,
		player="Why would the ancients give us endurium then kill us?",
		alien={"Little is known to us on this subject.  The Nyssian storytellers, in their manner, describe an enemy of the ancient ones named Uyo.  This described homocidal race of withered beings may have been the target for such a device, with our ancestors and thine, only unintended targets."}
	}
	questions[32222] = {
		action="jump", goto=32201,
		player="<More>",
		alien={"'Tis possible the appearance of genocidal technologies, the ill-timed and irrational actions of the Minex, may be mere harbringers of the Uyo's return.  If not responsible for their actions, e'er their innocence be shown, some slight knowledge of this matter may they possess." }
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
		alien={"'Tis our wish that no pirates nor interlopers disrespect the Elowan.","Despicable and untrustworthy monster, leave our space."} }
	greetings[2] = {
		action="attack",
		player="This is the starship [SHIPNAME]. We are heavily armed. ",
		alien={"'Tis our wish that no pirates nor interlopers disrespect the Elowan.","Despicable and untrustworthy monster, leave our space."}	}
	greetings[3] = {
		action="",
		player="This is captain [CAPTAIN] of the powerful starship [SHIPNAME]. ",
		alien={"Thou addresses the Elowan."} }
	greetings[4] = {
		action="attack",
		player="You will cooperate and identify yourselves immediately or be annihilated.",
		alien={"'Tis our wish that no pirates nor interlopers disrespect the Elowan.","Despicable and untrustworthy monster, leave our space."} }
	greetings[5] = {
		action="attack",
		player="We require information. Comply or be destroyed.",
		alien={"'Tis our wish that no pirates nor interlopers disrespect the Elowan.","Despicable and untrustworthy monster, leave our space."} }
		
	-- player statements and alien replies
	-- new statements may be added, as they are chosen at random
	--VALID ACTIONS: terminate, attack
	statements[1] = {
		action="",
		player="Your ship is over-embellished and weak.",
		alien={"Nae, we refute this.","Ascetics be not thy forte."} }
	statements[2] = {
		action="",
		player="What an ugly and worthless creature.",
		alien={"Nae, we refute this.","Ascetics be not thy forte."} }
	statements[3] = {
		action="",
		player="Your ship looks like a flying garbage scow.",
		alien={"Nae, we refute this.","Ascetics be not thy forte."} }


	--player questions / alien responses
	--VALID ACTIONS: terminate, attack, restart
	--YOURSELVES THREAD
	


	questions[10000] = {
		action="jump", goto=11001,
		player="What can you tell us about yourselves?",
		alien={"We are the Elowan, those of the vine and spore, allies of the peaceful, concern'd with such things as may be called beauty and perhaps truth."}
	}
	questions[20000] = {
		action="jump", goto=21001,
		player="What can you tell us about the other races in the galaxy?",
		alien={"In necessity grows the strength of survival.  The Minex had'st provoked the ire of all in their foolishness.  Provincial 'twas their mistake of provoking both the Thrynn and ourselves with this onslaught.  The feudal conflict of the Thrynn hadst been transformed into a provisional alliance for withstanding this peril."}
	}
	questions[30000] = {
		action="jump", goto=31001,
		player="Can you tell us about your history?",
		alien={"Preytell thy every inquiry will be answered."}
	}
	questions[40000] = {
		action="jump", goto=41001,
		player="Tell us about the Ancients.",
		alien={"Too much has been lost from our racial knowledge, as little r'mained from the days of scattering." }
	}
	questions[50000] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your ships and defenses?",  goto=51000 },
			{ text="Where is your homeworld?",  goto=52000 },
			{ text="Can you tell us any current news?",  goto=60000 },
			{ text="<Back>",  goto=1 }
		}
	}
 
	questions[60000] = {
		action="jump", goto=21001,
		player="",
		alien={"In necessity grows the strength of survival.  The Minex had'st provoked the ire of all in their foolishness.  Provincial 'twas their mistake of provoking both the Thrynn and ourselves with this onslaught.  The feudal conflict of the Thrynn hadst been transformed into a provisional alliance for withstanding this peril."}
	}

	questions[51000] = {
		action="jump", goto=51101,
		player="What can you tell us about your ships and defenses?",
		alien={"In truth, essentials will we not to divulge.  Abstractions befitting allies we have no trouble sharing."}
	}
	questions[52000] = {
		action="jump", goto=50000,
		player="Where is your homeworld?",
		alien={"Encroach upon our sacred colony Cailte 4 - 61,22 at thy peril.  Thy existence shall pass into what thou may call'st thine third life if any betrayal doth proceed." }
	}
	questions[51101] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your ships?",  goto=51100 },
			{ text="How do your ships do in battle?", goto=51200 },
			{ text="I can't help but notice your tight formations.", goto=51300 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[51100] = {
		action="jump", goto=51101,
		player="What can you tell us about your ships?",
		alien={"Doth thy ship not possess sensors?  Our tiny but incredibly sophisticated vessels are equipped with powerful shielding and nearly endless supply of energy projectile weaponry."}
	}
	questions[51200] = {
		action="jump", goto=51101,
		player="How do your ships do in battle?",
		alien={"'Tis a dance of thy greatest dreams united with the ugliness of death.  Perchance nothing demonstrates the truth of existence in like spirit.  We fly the abstract patterns of infinity with the precision of rain watering the ground with projectiles of death 'ere our young may'st continue to stand under the rain of life."}
	}
	questions[51300] = {
		action="jump", goto=51101,
		player="I can't help but notice your tight formations.",
		alien={"Patterns of strength unfold endlessly and the Thrynn lack the innate cooperation the military mind implies.  The rotation of the wounded permit refreshment of their screens, as the Thrynn lack the spatial coordination to control effectively any but the most simple of particle beam weaponry."}
	}

		
	questions[11001] = {
		action="branch",
		choices = {
			{ text="What can you tell us about your race?",  goto=11000 },
			{ text="How does a race of sentient plants reproduce?", goto=12000 },
			{ text="Why do you say you are allies of the peaceful?", goto=13000 },
			{ text="Where is your homeworld?", goto=14000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[11000] = {
		action="jump", goto=11001,
		player="What can you tell us about your race?",
		alien={"At a time when we reach an age of adolescence we are uprooted. In so doing we are become omniverous producers, capable of sustaining ourselves thusly upon photosynthesis with the occasional consumption of meat or plant products." }
	}
	questions[12000] = {
		action="jump", goto=11001,
		player="How does a race of sentient plants reproduce?",
		alien={"Mayhap one of every 300 of our number doth stay rooted within the ground, and in so doing is its head then transformed into a melon-like fruit called headfruit wherein lie the many seeds of our future.  The sacred harvest festival doth temporarily a third of our race incapacitate, and dwell upon us the duty of traversing and scattering the code of life." }
	}
	questions[13000] = {
		action="jump", goto=11001,
		player="Why do you say you are allies of the peaceful?",
		alien={"Is not violence, above all things, most base and vile? 'Tis only as a necessity, against those who use it without hesitation, in its application." }
	}
	questions[14000] = {
		action="jump", goto=11001,
		player="Where is your homeworld?",
		alien={"Encroach upon our sacred colony Cailte 4 - 61,22 at thy peril.  Thy existence shall pass into what thou may call'st thine third life if any betrayal doth proceed." }
	}

	questions[21001] = {
		action="branch",
		choices = {
			{ text="Who are the Thrynn?",  goto=21000 },
			{ text="Why have the Minex attacked you?",  goto=22000 },
			{ text="Do you now have knowledge of this interspecies virus?",  goto=23000 },
			{ text="Have you made contact with other races being attacked?",  goto=24000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[21000] = {
		action="jump", goto=21101,
		player="Who are the Thrynn?",
		alien={"An untrustworthy race, one that hath pursued the most vile injustices against us.  In necessity thou shalt observe their aid in our survival, as we now intercede in theirs." }
	}
	questions[22000] = {
		action="jump", goto=21001,
		player="",
		alien={"'Tis an unprovoked action, in all regards, that the Minex hath wrought.  Yet in hope the danger presented by an enemy in truth, unlike ourselves, doest sway the aggressions of the Thrynn away from us." }
	}
	questions[23000] = {
		action="jump", goto=21001,
		player="",
		alien={"Indeed the great devastation of this affliction had'st begun its work and spared naught many.  Little do we know of that lies within any resolution to this matter." }
	}
	questions[24000] = {
		action="jump", goto=21001,
		player="",
		alien={"'Twas only recently that representatives of the Tafel and Bar-zhon did us contact.  Seeking aid and strength we hath not in spare to provide to them, nor they to us.  Yet not in vain their efforts were made, as agreements to share technology and intelligence would'st perhaps all be saved." }
	}
	questions[21101] = {
		action="branch",
		choices = {
			{ text="How did this alliance with the Thrynn occur?",  goto=21100 },
			{ text="Are you able to withstand the Minex attacks?",  goto=21200 },
			{ text="How do you believe you are superior to the Thrynn?",  goto=21300 },
			{ text="What tactics do the Minex use against you?",  goto=21400 },
			{ text="<Back>", goto=21001 }
		}
	}
	questions[21100] = {
		action="jump", goto=21101,
		player="",
		alien={"A chance encroachment of our territory by the Minex occurred during an engagement with the Thrynn.  Indiscriminate was the slaughter of both Elowan and Thrynn by the sizable task force.  Upon knowledge of their peral, weary antagonism towards our ships withdrawn, and both forces unit'd in repusing the unjust provocation.  A tender seed that day was planted, Thrynn lasers touched them most effectively, perchance our ships the greatest at coordination of defense was proven." }
	}
	questions[21200] = {
		action="jump", goto=21101,
		player="",
		alien={"The Minex profane and vile attacks have cut bitterly.  Perchance with fortune, the Thrynn's fierce and ruthless attacks, balanced with our fleet support, has heretofore broken all waves. " }
	}
	questions[21300] = {
		action="jump", goto=21101,
		player="",
		alien={"In truth doth our greatest strength lie within our greatest weakness, the precision of our recall, as both interpretation of patterns and a lack of focus contribute to our character." }
	}
	questions[21400] = {
		action="jump", goto=21101,
		player="",
		alien={"Great ignorance doth thou find in the Minex in their pursuit of war.  Only do they attack, with methodical precision, the outlines of our territory.  They speak only with their weapons fiercely, yet great tactical advantage abstain, from failing to thrust towards colony worlds.  An unofficial alliance hath formed, with us as scouts and denfense, and unified taskforces with both our fleets and the Thrynn countering in response." }
	}

	questions[31001] = {
		action="branch",
		choices = {
			{ text="Have you established any other colonies?",  goto=31000 },
			{ text="How did the conflict with the Thrynn start?",  goto=32000 },
			{ text="<Back>", goto=1 }
		}
	}
	questions[31000] = {
		action="jump", goto=31001,
		player="Have you established any other colonies?",
		alien={"None but a few of us remain, for this last location we defend, as now the Minex assume the prior mantle of the Thrynn." }
	}
	questions[32000] = {
		action="jump", goto=32101,
		player="How did the conflict with the Thrynn start?",
		alien={"'Twas in 2770 that the empire did discover our home system of Eleran and both races and eventually uplift. Contact first was made with the wretched Thrynn. Therefore we were not at first accepted as sentient for they spoke wrongly of us and were not questioned in their slander." }
	}
	questions[32101] = {
		action="branch",
		choices = {
			{ text="But how did the actual conflict began?",  goto=32100 },
			{ text="Where is Eleran located?",  goto=32200 },
			{ text="<Back>", goto=31001 }
		}
	}

	questions[32100] = {
		action="jump", goto=32101,
		player="But how did the actual conflict began?",
		alien={"Both our races developed sub-luminal travel and the final bastion of our home world invaded.  Conflict thus arose from the hunting instinct of Thrynn: sentient beings being the most dangerous prey, and the headfruit of the planted Elowan the most defended and coveted prize." }
	}
	questions[32200] = {
		action="jump", goto=32201,
		player="Where is Eleran located?",
		alien={"Nay this expanse be not our origin.  'Twas only 450 festival cycles our flight from a dying Empire, a wave of flaring stars, and the machinations of the murderous Thrynn did we flee thither.  Of only the former two dangers were we successful in avoiding." }
	}

	questions[32201] = {
		action="branch",
		choices = {
			{ text="Dying empire?", goto=32210 },
			{ text="A wave of flaring stars?", goto=32220 },
			{ text="<Back>", goto=32101 }
		}
	}
	questions[32210] = {
		action="jump", goto=32201,
		player="",
		alien={"If the Nyssian tales be true, the Empire of Man, yourselves a scattered remnant, had'st been destroyed all heretofore save yourselves.  In sooth, the truth of this matter we know little."}
	}
	questions[32220] = {
		action="jump", goto=32221,
		player="",
		alien={"'Tis not known whether any ancient ones survive still.  Mayhap only their heinous legacy, the crystal planet, has been left us.  Its evil task was to destroy all that lives within its range.  Why, we know not.  It's current influence is far from here." }
	}
	questions[32221] = {
		action="jump", goto=32222,
		player="Why would the ancients give us endurium then kill us?",
		alien={"Little is known to us on this subject.  The Nyssian storytellers, in their manner, describe an enemy of the ancient ones named Uyo.  This described homocidal race of withered beings may have been the target for such a device, with our ancestors and thine, only unintended targets."}
	}
	questions[32222] = {
		action="jump", goto=32201,
		player="<More>",
		alien={"'Tis possible the appearance of genocidal technologies, the ill-timed and irrational actions of the Minex, may be mere harbringers of the Uyo's return.  If not responsible for their actions, e'er their innocence be shown, some slight knowledge of this matter may they possess." }
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

