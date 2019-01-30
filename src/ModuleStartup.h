#pragma once
/*
	STARFLIGHT - THE LOST COLONY
	ModuleStartup.h - Handles opening sequences, videos, copyrights, prior to titlescreen.
	Author: J.Harbour
	Date: Jan 1,2008
*/
 

#include "env.h"
#include <fmod.hpp>
#include <allegro.h>
#include "Module.h"

class ModuleStartup : public Module
{
public:
	ModuleStartup();
	virtual ~ModuleStartup();

	bool Init();
	void Update();
	void Draw();
	void OnKeyPress(int keyCode);
	void OnKeyPressed(int keyCode);
	void OnKeyReleased(int keyCode);
	void OnMouseMove(int x, int y);
	void OnMouseClick(int button, int x, int y);	
	void OnMousePressed(int button, int x, int y);
	void OnMouseReleased(int button, int x, int y);
	void OnEvent(Event *event);
	void Close();

private:
	int fadein(BITMAP *dest, BITMAP *source, int speed);
	int fadeout(BITMAP *dest, BITMAP *source, int speed);

	BITMAP *m_background;
	BITMAP *fader;
	BITMAP *scratchpad;
	BITMAP *copyright;
	int display_mode;

};

const int pages = 5;
const int lines = 30;
const std::string story[pages][lines] = 
{
    {"THE LOST COLONY",
    "",
    "Three centuries ago, our ancestors departed the ancient cradle world of Earth ",
    "on the colony ship Noah 3 to colonize another star system. ",
    "",
    "The Noah 3 colonists did not reach their destination and were never heard ",
    "from again.",
    "",
    "Earth mourned the loss, believing the ship was destroyed en route. The myst-",
    "erious loss of Noah 3 haunted the Solar System and outer colonies for decades.",
    "In time, Noah 3 became legend and merely a footnote in history.",
    "",
    "However, Noah 3 was not destroyed! The colony ship was caught in a massive ",
    "wormhole and sent ten thousand light years from Earth. ",
    "",
    "Badly damaged and losing life support, the colonists of Noah 3 desperately ",
    "searched nearby star systems for a new home, but time was short. After many ",
    "days and dozens of hyperspace jumps, their damaged life support systems ",
    "were running out. They had time to explore one more star, so their scientists",
    "peered through their devices at the nearest stars and found the most likely",
    "system: a class G star, slightly larger and more luminous than Earth's sun, with", 
    "a full complement of planets. ",
    "",
    "Captain Meriwether ordered one final hyperspace jump that took them to the",
    "outskirts of the system. The ship headed inward toward the gravity well of ",
    "the sun. They passed the orbital path of four gas giants and an extensive ",
    "asteroid ring. ",
    "","",""
    },

    {"After many hours they reached the inner system seeking a habitable planet. As ",
    "they cleared the innermost gas giant they found four rocky worlds beyond an ",
    "asteroid ring, and their spirits soared!",
    "",
    "With so many inner planets in view, their odds just went way up.",
    "",
    "At 160 million miles from the sun, the fourth planet in the system was a frozen",
    "wasteland with no atmosphere. Captain Meriwether suspected as much. Although",
    "it would have been nice to have been rewarded with a habitable world on the",
    "first try, the planet was beyond the 'warm zone'.",
    "",
    "As they headed further inward, they reached the third planet at 80 million",
    "miles from the sun, and it was a barren world, no atmosphere, and covered",
    "with craters.",
    "",
    "Fear began to spread among the colonists as well as the bridge crew. Two down",
    "and their odds of survival were diminishing.",
    "",
    "The tension was palpable as they approached the second planet at 55 million ",
    "miles. The world looked promising from a distance...about the right size with a",
    "cloudy atmosphere. The ship entered orbit with everyone on edge. Anticipation",
    "and hope was mingled with fear. Science teams began scanning and analyzing ",
    "the world....",
    "",
    "The thick, cloudy atmosphere...was toxic.",
    "","","","",""
    },

    {"Panic broke out among the three thousand colonists aboard Noah 3, since only ",
    "one world remained and it was too close to the sun to be habitable. Neverthe-,",
    "less, the captain ordered the ship to break orbit and continue to the first planet",
    "in the system.",
    "",
    "As expected, it was a fireball. Tidal forces caused by the sun's gravity had bro-",
    "ken the crust and continually crushed then released the small world, over and ",
    "over for eons.",
    "",
    "The captain ignored panicked pleas from the passenger compartments: ",
    "",
    "'What are we going to do?'",
    "",
    "'Surely we can explore another system?'",
    "",
    "Resigned to their fate, the captain ordered the massive ship into a slow, wide ",
    "elliptical orbit around the sun. Hours later, in the midst of desperation, sensors",
    "picked up another planet! They had missed it before due to it's position behind",
    "the sun. ",
    "",
    "The captain jumped from his seat and punched the con, 'Science Officer Jenner ",
    "to the bridge!'",
    "",
    "When Jenner entered the bridge, complaining about the end of their lives, the",
    "captain pulled him to the sensors and said, 'What do you make of that?'",
    "",
    "Jenner squinted at the sensor screen and his eyes grew wide. ",
    "","",""
    },

    {
        "", "", "", "", "", "", "", "", "", "",
        "", "", "", "", "", "", "", "", "", "",
        "", "", "", "", "", "", "", "", "", ""
    },

    {
        "", "", "", "", "", "", "", "", "", "",
        "", "", "", "", "", "", "", "", "", "",
        "", "", "", "", "", "", "", "", "", ""
    }
};

/*
Captain Meriwether punches the intercom, "Attention everyone, this is the captain. We have located another planet. 
I repeat, there is one more planet! We missed it the first time because it's behind the sun." 
Sobs of grief and panic abate for a moment. 
Many do not believe it. 
Many missed the announcement and ask what the captain said. 
The brave colonists, occupying gigantic living spaces that doubled as landing craft, filled the ship's entire 
two mile length--and fully half of that was devoted to engines and botanical gardens.
Jenner's fingers flashed over his controls and keys in a rush of activity, adjusting the sensors and pulling 
in more data as Noah 3 cleared the corona of the star and the planet came into range. 
He glances up at the captain. "Class . . . M." 
Everyone on the bridge gasps in unison, as the captain leaps from his chair.
Jenner studies the readings coming in from long-range sensors, and his eyes grow wide. 
"Liquid . . . water." The bridge crew look around at each other, bewilderment in their eyes.
"Point eight . . . gee." The captain's mouth begins to open in awe, his breathing quickens.
"Concentrations of . . . oxygen . . . and . . . nitrogen."
The bridge crew cried together in unison. Science Officer Jenner slid down form his seat to the floor, sobbing. 
Captain Meriwether slumped into his seat, mouth gaping wide open, eyes staring at the bulkhead in stunned silence. 
After a moment, he punched the intercom button and began to speak. 
His voice caught in his throat, so he swallowed audibly.
"Attention, all passengers. This is the captain."
The passenger compartments suddenly grew silent, as everyone stared up at the report monitors to listen.
"Off-- Officer Jenner. Please repeat your analysis for the benefit of the whole ship."
Jenner grasped his chair, hauling himself up, wiped his eyes and cleared his throat. 
He punched his own intercom button and read the analysis again, carefully.
"Liquid water. Point eight gee." 
Murmuring began to come through the tinny speakers on the bridge from the passengers. He looked to the captain, 
who nodded to him in approval.
Then Jenner said in a whisper, "Concentrations of oxygen and nitrogen."
The intercom buzzed with a thunderous applause and cries of relief, giving the bridge crew a full set of smiles. 
Back on the passenger levels, many had fallen to their knees or prostrate on the ground, apparently praying. 
Many more could be heard praising the captain, his crew, and the technology of their ship. 
Those with any military background, true to form, saluted each other, grasped arms. 
Throughout the complement, everyone hugged one another. 
Tension turning to joy resulted in outbursts of sobbing and cries of joy. They were lost, doomed to a crowded, 
unimaginable mass death, and suddenly they had hope and joy.

Noah 3 approached the world, which turned out to be the fourth in the system, closest to the asteroid belt 
(which might explain how their sensors had missed it, in addition to it being on the opposite side of the 
sun from their approach). Captain Meriwether ordered the navigator to go into low orbit. Suddenly, an alarm 
klaxon blared throughout the ship. 
Chief Engineer Donovan screamed over the din, "Captain! Coolant is gone! The reactor's overheating. It's gonna go!"
Captain Meriwether jumped from his seat and jammed his thumb into the intercom once again, 
"Attention, this is the captain. Sorry to spoil the celebration, but we have a new problem. 
The reactor is about to go critical! All passengers, to your descent chambers, immediately and launch when ready!" 
He looked at the eager faces on the bridge and said, 
"Abandon ship! To the escape pods! I repeat, all hands, abandon ship!"
As viewed from below Noah 3, eight football-field sized landing craft, shaped like large cigars with wings, 
detached from the ship's hull. They descended, streaking toward the planet as the superstructure of Noah 3 
cracked and became a tumbling fireball across the sky. 
Hours later, the survivors emerged from their cocoons on a new world. The captain and his crew had followed 
the passenger craft in their escape pods and touched down near the largest cluster of Landers. 
But in the urgency of the situation, not all had made it down safely. One Lander lost it's attitude 
thrusters and missed the atmospheric entry trajectory, tumbling and falling into the depths of a large, 
unnamed ocean. Another Lander had been damaged during the breakup of the mother ship. 
Three hundred and fifty people had survived accidental passage through a wormhole across the galaxy 
only to be lost in the end, during descent. It was a tragedy the defied reason, and their lives were 
honored in a memorial tower erected at the center of the first and largest settlement.
Captain Meriwether knew they had been lucky to have survived at all. Six out of eight wasn't bad 
considering their dire situation: the loss of life support, the loss of their reactor--the very 
reactor that was to give their colony power for generations to come. Although safe, they would have 
much work to do on this new world. And what a world it is, absolutely overrun with plant life! 
If sensors are correct, the oceans are as full of life as the continents, and some have already 
reported seeing animals--herds of tens of thousands of herbivores and smaller numbers of predators. 
Who knew what else remained to be discovered on this huge world, untouched by human hand for eons?
They were starting over on a completely fresh and untouched world. After much debate and proposal, 
a vote gave their new world it's name--Myrrdan. 
There was only one question to ponder: would they depart to savagery within a few generations, 
or would their children build a peaceful civilization and skip the millenia of barbarism that had 
plagued Earth's long history? Would their children embrace religion, or science and technology, 
or military conquest, or free trade and capitalism? Captain Meriwether was not sure that he cared, 
as long as their civilization flourished, and set out that very day to build it.

*/