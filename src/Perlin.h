/*
	STARFLIGHT - THE LOST COLONY
*/


#ifndef _PERLIN_H
#define _PERLIN_H 1

#include "env.h"
#include "DataMgr.h"

#include "noise/noise.h"
#include "noiseutils.h"
using namespace noise;

void createPlanetSurface(int width, int height, int randomness, PlanetType planet_type, char *filename);



#endif 
