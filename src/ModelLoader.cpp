#include "env.h"
#include "ModelLoader.h"
#include "Model.h"

#include <algorithm>
using namespace std;

Model* ModelLoader::Load(std::string modelFile)
{
   Model * result = new Model;

   bool modelLoaded = false;

   if (modelFile.size() >= 4)
   {
      string fext = modelFile.substr(modelFile.size()-4,4);
      transform(fext.begin(),fext.end(),fext.begin(),(int(*)(int))toupper);

      if (fext == ".OBJ")
         modelLoaded = LoadWavefrontObjFile(modelFile,*result);
   }

   if (!modelLoaded)
   {
      delete result;
      result = NULL;
   }
   else
   {
      Model& m = *result;

      // load textures
      for (map<string,Model::Material>::iterator i = m.Materials.begin(); i != m.Materials.end(); i++)
      {
         Model::Material& mat = i->second;
         mat.texture = 0;
         BITMAP* img = load_bitmap(mat.file.c_str(),NULL);
         if (img != NULL)
         {
            mat.texture = allegro_gl_make_texture_ex(AGL_TEXTURE_RESCALE,img,-1);
            destroy_bitmap(img);
         }
      }      
   }

   return result;
}

bool ModelLoader::LoadWavefrontObjFile(string modelFile, Model& m)
{
   FILE* f = fopen(modelFile.c_str(),"rt");
   if (f == NULL)
      return false;

   string dir;
   int bsPos = (int)modelFile.rfind('\\');
   if (bsPos < 0)
      bsPos = (int)modelFile.rfind('/');
   if (bsPos >= 0)
      dir = modelFile.substr(0,bsPos+1);

   const int maxLineLen = 2048;
   char line[maxLineLen+1];

   Model::TriangleGroup triGroup;

   while (!feof(f))
   {
      memset(line,0,maxLineLen+1);
      if (fgets(line,maxLineLen,f) == NULL)
         break;
      if (line[strlen(line)-1] == '\n')
         line[strlen(line)-1] = '\0';

      // material library file
      if (strncmp(line,"mtllib",6) == 0)
      {
         string matLibFile = dir;
         matLibFile += &line[7];

         FILE* ml = fopen(matLibFile.c_str(),"rt");
         if (ml == NULL)
            continue;

         Model::Material mat;

         while (!feof(ml))
         {
            memset(line,0,maxLineLen+1);
            if (fgets(line,maxLineLen,ml) == NULL)
               break;
            if (line[strlen(line)-1] == '\n')
               line[strlen(line)-1] = '\0';

            // material name
            if (strncmp(line,"newmtl",6) == 0)
            {
               mat.name = &line[7];
            }
            // texture file
            else if (strncmp(line,"map_Kd",6) == 0)
            {
               mat.file = dir;
               mat.file += &line[7];
               m.Materials[mat.name] = mat;
            }
         }

         fclose(ml);
      }
      // vertex
      else if (strncmp(line,"v ",2) == 0)
      {
         char* x = &line[2];
         char* y = strchr(x,' '); *y++ = '\0';
         char* z = strchr(y,' '); *z++ = '\0';
       
         Model::Vertex v;
         v.x = atof(x);
         v.y = atof(y);
         v.z = atof(z);
         m.Vertices.push_back(v);
      }
      // tex coord
      else if (strncmp(line,"vt ",3) == 0)
      {
         char* u = &line[3];
         char* v = strchr(u,' '); *v++ = '\0';
       
         Model::TexCoord t;
         t.u = atof(u);
         t.v = atof(v);
         m.TexCoords.push_back(t);
      }
      // normal
      else if (strncmp(line,"vn ",3) == 0)
      {
         char* i = &line[3];
         char* j = strchr(i,' '); *j++ = '\0';
         char* k = strchr(j,' '); *k++ = '\0';
       
         Model::Normal n;
         n.i = atof(i);
         n.j = atof(j);
         n.k = atof(k);
         m.Normals.push_back(n);
      }
      // new triangle group
      else if (strncmp(line,"g ",2) == 0)
      {
         if (triGroup.Triangles.size() > 0)
         {
            m.TriangleGroups.push_back(triGroup);
            triGroup.Triangles.clear();
            triGroup.Name = "";
            triGroup.MaterialName = "";
         }

         triGroup.Name = &line[2];
      }
      // material reference
      else if (strncmp(line,"usemtl ",7) == 0)
      {
         triGroup.MaterialName = &line[7];
      }
      // triangle
      else if (strncmp(line,"f ",2) == 0)
      {
         char* t1 = &line[2];
         char* t2 = strchr(t1,' '); *t2++ = '\0';
         char* t3 = strchr(t2,' '); *t3++ = '\0';

         char* t1V = t1;
         char* t1T = strchr(t1V,'/'); *t1T++ = '\0';
         char* t1N = strchr(t1T,'/'); *t1N++ = '\0';

         char* t2V = t2;
         char* t2T = strchr(t2V,'/'); *t2T++ = '\0';
         char* t2N = strchr(t2T,'/'); *t2N++ = '\0';

         char* t3V = t3;
         char* t3T = strchr(t3V,'/'); *t3T++ = '\0';
         char* t3N = strchr(t3T,'/'); *t3N++ = '\0';

         Model::Triangle tri;
         tri.Vertices[0] = atoi(t1V)-1;
         tri.Vertices[1] = atoi(t2V)-1;
         tri.Vertices[2] = atoi(t3V)-1;
         tri.TexCoords[0] = atoi(t1T)-1;
         tri.TexCoords[1] = atoi(t2T)-1;
         tri.TexCoords[2] = atoi(t3T)-1;
         tri.Normals[0] = atoi(t1N)-1;
         tri.Normals[1] = atoi(t2N)-1;
         tri.Normals[2] = atoi(t3N)-1;
         triGroup.Triangles.push_back(tri);
      }
   }

   if (triGroup.Triangles.size() > 0)
      m.TriangleGroups.push_back(triGroup);

   fclose(f);
   return true;
}
