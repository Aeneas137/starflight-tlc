/*
	STARFLIGHT - THE LOST COLONY
*/
#include "PerlinTL.h"
#include <iostream>

void createPlanetSurface(int width, int height, int randomness, PlanetType planet_type, std::string filename)
{
    createPlanetSurface(width,height,randomness,planet_type,filename.c_str());
}

void createPlanetSurface(int width, int height, int randomness, PlanetType planet_type, const char *filename)
{
   module::Perlin perlin;
   perlin.SetSeed(randomness);
   perlin.SetFrequency(1.0);
   perlin.SetOctaveCount(6);
   perlin.SetPersistence (0.5);

   switch(planet_type){
      case PT_FROZEN:   
         perlin.SetOctaveCount(5);
         perlin.SetPersistence (0.4);
         break;

      case PT_GASGIANT: 
         perlin.SetOctaveCount(3);
         perlin.SetPersistence (0.3);
         break;

      case PT_MOLTEN:   
         perlin.SetOctaveCount(6);
         perlin.SetFrequency(1.4);
         perlin.SetPersistence (0.5);
         break;
   }

   utils::NoiseMap heightMap;
   utils::NoiseMapBuilderSphere heightMapBuilder;
   heightMapBuilder.SetSourceModule (perlin);
   heightMapBuilder.SetDestNoiseMap (heightMap);
   heightMapBuilder.SetDestSize (width, height);
   heightMapBuilder.SetBounds (-90.0, 90.0, -180.0, 180.0);
   heightMapBuilder.Build ();

   utils::RendererImage renderer;
   utils::Image image;
   renderer.SetSourceNoiseMap (heightMap);
   renderer.SetDestImage (image);
   renderer.ClearGradient();
	int random_value = 0;
	srand(randomness);

   switch(planet_type) {
      case PT_OCEANIC:  
         renderer.AddGradientPoint (-1.0000, utils::Color (0, 0, 120, 255)); // deeps
         renderer.AddGradientPoint (-0.2500, utils::Color (0, 0, 255, 255)); // shallow
         renderer.AddGradientPoint ( 0.0000, utils::Color (0, 120, 250, 255)); // shore
         renderer.AddGradientPoint ( 0.0625, utils::Color (180, 180, 60, 255)); // sand
         renderer.AddGradientPoint ( 0.1250, utils::Color (50, 160, 0, 255)); // grass
         renderer.AddGradientPoint ( 0.3750, utils::Color (180, 180, 0, 255)); // dirt
         renderer.AddGradientPoint ( 0.7500, utils::Color (150, 150, 150, 255)); // rock
         renderer.AddGradientPoint ( 1.0000, utils::Color (255, 255, 255, 255)); // snow
         break;

	case PT_ACIDIC: 
		//renderer.AddGradientPoint (-1.0000, utils::Color (120, 0, 120, 255)); // deeps
		//renderer.AddGradientPoint (-0.2500, utils::Color (175, 0, 175, 255)); // shallow
		//renderer.AddGradientPoint ( 0.0000, utils::Color (220, 0, 220, 255)); // shore
		renderer.AddGradientPoint (-1.0000, utils::Color (0, 115, 27, 255)); // acid
		renderer.AddGradientPoint (-0.2500, utils::Color (0, 255, 0, 255)); // shallow
		renderer.AddGradientPoint ( 0.0000, utils::Color (60, 240, 135, 255)); // shore
		//renderer.AddGradientPoint ( 0.0625, utils::Color (180, 180, 60, 255)); // sand
        renderer.AddGradientPoint ( 0.1250, utils::Color (155, 50, 80, 255)); // grass
        //renderer.AddGradientPoint ( 0.3750, utils::Color (180, 180, 0, 255)); // dirt
        renderer.AddGradientPoint ( 0.7500, utils::Color (30, 30, 100, 255)); // rock
        renderer.AddGradientPoint ( 1.0000, utils::Color (60, 50, 115, 255)); // snow
        break;

      case PT_FROZEN:
       //  renderer.AddGradientPoint (-1.0000, utils::Color (130, 130, 150, 255)); // deeps
		//   renderer.AddGradientPoint (-0.2500, utils::Color (140, 140, 150, 255)); // shallow
		 renderer.AddGradientPoint (-1.0000, utils::Color (65, 65, 150, 255)); // deeps
         renderer.AddGradientPoint (-0.2500, utils::Color (100, 100, 150, 255)); // shallow
         renderer.AddGradientPoint ( 0.0000, utils::Color (150, 150, 150, 255)); // shore
         renderer.AddGradientPoint ( 0.0625, utils::Color (160, 160, 160, 255)); // sand
         renderer.AddGradientPoint ( 0.1250, utils::Color (170, 170, 170, 255)); // grass
         renderer.AddGradientPoint ( 0.3750, utils::Color (200, 200, 200, 255)); // dirt
         renderer.AddGradientPoint ( 0.7500, utils::Color (230, 230, 230, 255)); // rock
         renderer.AddGradientPoint ( 1.0000, utils::Color (255, 255, 255, 255)); // snow
         break;

      case PT_ROCKY:    
         renderer.AddGradientPoint (-1.0000, utils::Color (120, 100, 100, 255)); // deeps
         renderer.AddGradientPoint (-0.2500, utils::Color (120, 120, 120, 255)); // shallow
         renderer.AddGradientPoint ( 0.0000, utils::Color (160, 150, 160, 255)); // shore
         renderer.AddGradientPoint ( 0.0625, utils::Color (120, 120, 100, 255)); // sand
         renderer.AddGradientPoint ( 0.1250, utils::Color (120, 120, 120, 255)); // grass
         renderer.AddGradientPoint ( 0.3750, utils::Color (150, 160, 170, 255)); // dirt
         renderer.AddGradientPoint ( 0.7500, utils::Color (150, 150, 150, 255)); // rock
         renderer.AddGradientPoint ( 1.0000, utils::Color (160, 150, 160, 255)); // snow
         break;

      case PT_GASGIANT:
		 random_value = rand()%4;
		 if(random_value == 0){ //purple
			 renderer.AddGradientPoint (-1.0000, utils::Color (80, 0, 80, 255)); 
			 renderer.AddGradientPoint (-0.5000, utils::Color (160, 0, 160, 255)); 
			 renderer.AddGradientPoint ( 0.0000, utils::Color (175, 150, 175, 255)); 
			 renderer.AddGradientPoint ( 0.5000, utils::Color (182, 99, 182, 255)); 
			 renderer.AddGradientPoint ( 1.0000, utils::Color (160, 140, 160, 255)); 
		}else if(random_value == 1){ //green
			 renderer.AddGradientPoint (-1.0000, utils::Color (0, 100, 0, 255)); 
			 renderer.AddGradientPoint (-0.5000, utils::Color (0, 140, 0, 255)); 
			 renderer.AddGradientPoint ( 0.0000, utils::Color (100, 180, 100, 255)); 
			 renderer.AddGradientPoint ( 0.5000, utils::Color (0, 150, 0, 255)); 
			 renderer.AddGradientPoint ( 1.0000, utils::Color (0, 180, 0, 255)); 
		 }else if(random_value == 2){ //blue
			 renderer.AddGradientPoint (-1.0000, utils::Color (0, 45, 110, 255)); 
			 renderer.AddGradientPoint (-0.5000, utils::Color (0, 0, 140, 255)); 
			 renderer.AddGradientPoint ( 0.0000, utils::Color (100, 100, 180, 255)); 
			 renderer.AddGradientPoint ( 0.5000, utils::Color (0, 100, 180, 255)); 
			 renderer.AddGradientPoint ( 1.0000, utils::Color (100, 190, 210, 255));
		 }else{	//red
			 renderer.AddGradientPoint (-1.0000, utils::Color (145, 95, 50, 255)); 
			 renderer.AddGradientPoint (-0.5000, utils::Color (70, 0, 0, 255)); 
			 renderer.AddGradientPoint ( 0.0000, utils::Color (180, 100, 100, 255)); 
			 renderer.AddGradientPoint ( 0.5000, utils::Color (150, 0, 0, 255)); 
			 renderer.AddGradientPoint ( 1.0000, utils::Color (255, 145, 0, 255));
		 }
         break;

      case PT_MOLTEN:
			renderer.AddGradientPoint (-1.0000, utils::Color (200, 30, 30, 255)); 
			renderer.AddGradientPoint (-0.6000, utils::Color (235, 40, 40, 255)); 
			renderer.AddGradientPoint (-0.3000, utils::Color (255, 50, 50, 255)); 
			renderer.AddGradientPoint ( 0.0000, utils::Color (80, 70, 70, 255));
			renderer.AddGradientPoint ( 0.1250, utils::Color (100, 100, 100, 255)); 
			renderer.AddGradientPoint ( 0.5000, utils::Color (150, 120, 100, 255)); 
			renderer.AddGradientPoint ( 1.0000, utils::Color (130, 140, 140, 255)); 
			break;

      case PT_ASTEROID: 
			renderer.AddGradientPoint (-1.0000, utils::Color (0, 0, 0, 255)); 
			renderer.AddGradientPoint (-0.6000, utils::Color (20, 20, 20, 255)); 
			renderer.AddGradientPoint (-0.2000, utils::Color (30, 30, 30, 255)); 
			renderer.AddGradientPoint ( 0.0000, utils::Color (40, 40, 40, 255)); 
			renderer.AddGradientPoint ( 0.1000, utils::Color (50, 50, 50, 255));
			renderer.AddGradientPoint ( 0.3000, utils::Color (60, 60, 60, 255)); 
			renderer.AddGradientPoint ( 0.6000, utils::Color (70, 70, 70, 255)); 
			renderer.AddGradientPoint ( 1.0000, utils::Color (90, 90, 90, 255)); 
			break;

      case PT_INVALID:
      default:
			// placeholder -- something in case the type is invalid
			renderer.AddGradientPoint (-1.0000, utils::Color (120, 100, 100, 255)); // deeps
			renderer.AddGradientPoint (-0.2500, utils::Color (120, 120, 120, 255)); // shallow
			renderer.AddGradientPoint ( 0.0000, utils::Color (160, 150, 160, 255)); // shore
			renderer.AddGradientPoint ( 0.0625, utils::Color (120, 120, 100, 255)); // sand
			renderer.AddGradientPoint ( 0.1250, utils::Color (120, 120, 120, 255)); // grass
			renderer.AddGradientPoint ( 0.3750, utils::Color (150, 160, 170, 255)); // dirt
			renderer.AddGradientPoint ( 0.7500, utils::Color (150, 150, 150, 255)); // rock
			renderer.AddGradientPoint ( 1.0000, utils::Color (160, 150, 160, 255)); // snow
			break;
   }

   renderer.EnableLight ();
   renderer.SetLightContrast (3.0);
   renderer.SetLightBrightness (2.0);
   renderer.SetLightColor(utils::Color(255,255,255,255));
   renderer.Render ();

   utils::WriterBMP writer;
   writer.SetSourceImage (image);
   writer.SetDestFilename (filename);
   writer.WriteDestFile ();
}
