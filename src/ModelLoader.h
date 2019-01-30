#pragma once

#include <string>

class Model;

class ModelLoader
{
public:
   static Model* Load(std::string modelFile);

private:
   ModelLoader();
   virtual ~ModelLoader();

   static bool LoadWavefrontObjFile(std::string modelFile, Model& m);
};
