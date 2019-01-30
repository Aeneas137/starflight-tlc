#include "env.h"
#include "GameState.h"

void GameState::DumpStats(GameState* gs) {
	TRACE("dumping game statistics\n");
	TRACE("\tcurrent save game file= %s\n", gs->currentSaveGameFile.c_str());
	//std::string tstr= gs->getProfessionString();
	TRACE("\tprofession type: %s\n", gs->getProfessionString().c_str());
	//tstr= gs->stardate.GetFullDateString();
	TRACE("\tStarDate: %s\n", gs->stardate.GetFullDateString().c_str());

	TRACE("\tactive quest, stored value, quest status: %d   %d   %d\n",
			gs->activeQuest, gs->storedValue, gs->questCompleted);
	TRACE("\tcurrent star, current planet, control panel mode: %d, %d, %d\n",
		gs->player->currentStar, gs->player->currentPlanet, gs->player->controlPanelMode);
	TRACE("\tcurrent module= %s\n", gs->currentModule.c_str());
	TRACE("\tcurrent mode when game saved= %s\n\n", gs->currentModeWhenGameSaved.c_str());

	TRACE("\t\tpos hyperspace x, y:  %d, %d\n", gs->player->posHyperspace.x, gs->player->posHyperspace.y);
	TRACE("\t\tpos system x, y:  %d, %d\n", 	gs->player->posSystem.x,	gs->player->posSystem.y);
	TRACE("\t\tpos planet x, y:  %d, %d\n",		gs->player->posPlanet.x,	gs->player->posPlanet.y);
	TRACE("\t\tpos starport x, y:  %d, %d\n", 	gs->player->posStarport.x,	gs->player->posStarport.y);
	TRACE("\t\tpos combat x, y:  %d, %d\n\n",	gs->player->posCombat.x, 	gs->player->posCombat.y);
}
