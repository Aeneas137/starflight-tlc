#include "env.h"
#include <allegro.h>
#include <alleggl.h>
#include <gl/glu.h>

#include "Model.h"

using namespace std;

Model::Model()
{
   scaleX = scaleY = scaleZ = 1;
}

Model::~Model()
{
}

void Model::Draw()
{
   glScaled(scaleX,scaleY,scaleZ);

   for (vector<TriangleGroup>::iterator i = TriangleGroups.begin(); i != TriangleGroups.end(); ++i)
   {
      TriangleGroup& triGroup = *i;
      
      map<string,Material>::iterator mi = Materials.find(triGroup.MaterialName);
      if (mi != Materials.end())
      {
         Material& mat = mi->second;
         if (mat.texture != 0)
         	glBindTexture(GL_TEXTURE_2D,mat.texture);
      }

      glBegin(GL_TRIANGLES);
      for (vector<Triangle>::iterator j = triGroup.Triangles.begin(); j != triGroup.Triangles.end(); ++j)
      {
         Triangle& tri = *j;

         for (int k = 0; k < 3; k++)
         {
            if (tri.Normals[k] >= 0)
            {
               Normal& norm = Normals[tri.Normals[k]];
               glNormal3d(norm.i,norm.j,norm.k);
            }

            if (tri.TexCoords[k] >= 0)
            {
               TexCoord& tc = TexCoords[tri.TexCoords[k]];
               glTexCoord2d(tc.u,tc.v);
            }

            if (tri.Vertices[k] >= 0)
            {
               Vertex& v = Vertices[tri.Vertices[k]];
               glVertex3d(v.x,v.y,v.z);
            }
         }
      }
      glEnd();

	   glBindTexture(GL_TEXTURE_2D,0);
   }
}


