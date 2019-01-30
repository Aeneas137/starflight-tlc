#include "env.h"
#include <stdio.h>
#include <string.h>

#include "Archive.h"

#define TYPECODE_DOUBLE 'D'
#define TYPECODE_INT    'I'
#define TYPECODE_BOOL   'B'
#define TYPECODE_STRING 'S'
#define TYPECODE_FLOAT	'F'

using namespace std;

Archive::Archive()
: file(NULL)
, arMode(AM_NONE)
{
}

Archive::~Archive()
{
   Close();
}

bool Archive::Open(std::string fileName, ArchiveMode mode)
{
   Close();

   std::string fmode;
   if (mode == AM_STORE)
   {
      fmode = "wb";
   }
   else if (mode == AM_LOAD)
   {
      fmode = "rb";
   }

   file = fopen(fileName.c_str(),fmode.c_str());
   if (file == NULL)
      return false;

   arMode = mode;
   return true;
}

void Archive::Close()
{
   if (file != NULL)
   {
      fclose(file);
      file = NULL;
   }
   arMode = AM_NONE;
}

bool Archive::IsOpen()
{
   return (file != NULL);
}

bool Archive::IsStoring()
{
   return arMode == AM_STORE;
}

bool Archive::VerifyTypeCode(char typeCode)
{
   if (IsOpen())
   {
      char loadedTypeCode = '\0';
      size_t numRead = fread(&loadedTypeCode,sizeof(typeCode),1,file);
      if (numRead != 1)
         return false;
      return loadedTypeCode == typeCode;
   }
   else
      return false;
}

void Archive::WriteTypeCode(char typeCode)
{
   if (IsOpen())
      fwrite(&typeCode,sizeof(typeCode),1,file);
}

Archive& Archive::operator<<(double v)
{
   if (IsOpen())
   {
      WriteTypeCode(TYPECODE_DOUBLE);
      fwrite(&v,sizeof(v),1,file);
   }

   return *this;
}

Archive& Archive::operator<<(int v)
{
   if (IsOpen())
   {
      WriteTypeCode(TYPECODE_INT);
      fwrite(&v,sizeof(v),1,file);
   }

   return *this;
}

Archive& Archive::operator<<(float v)
{
   if (IsOpen())
   {
      WriteTypeCode(TYPECODE_FLOAT);
      fwrite(&v,sizeof(v),1,file);
   }

   return *this;
}


Archive& Archive::operator<<(bool v)
{
   if (IsOpen())
   {
      WriteTypeCode(TYPECODE_BOOL);
      fwrite(&v,sizeof(v),1,file);
   }

   return *this;
}

Archive& Archive::operator<<(std::string &v)
{
   return operator<<(v.c_str());
}

Archive& Archive::operator<<(const char *v)
{
   if (IsOpen())
   {
      WriteTypeCode(TYPECODE_STRING);
      fwrite(v,strlen(v)+1,1,file);
   }

   return *this;
}

Archive& Archive::operator>>(double &v)
{
   if (VerifyTypeCode(TYPECODE_DOUBLE))
      fread(&v,sizeof(v),1,file);

   return *this;
}

Archive& Archive::operator>>(int &v)
{
   if (VerifyTypeCode(TYPECODE_INT))
      fread(&v,sizeof(v),1,file);

   return *this;
}

Archive& Archive::operator>>(float &v)
{
   if (VerifyTypeCode(TYPECODE_FLOAT))
      fread(&v,sizeof(v),1,file);

   return *this;
}


Archive& Archive::operator>>(bool &v)
{
   if (VerifyTypeCode(TYPECODE_BOOL))
      fread(&v,sizeof(v),1,file);

   return *this;
}

Archive& Archive::operator>>(std::string &v)
{
   if (VerifyTypeCode(TYPECODE_STRING))
   {
      v = "";
      while (true)
      {
         char c;
         size_t numRead = fread(&c,sizeof(c),1,file);
         
         if (numRead != 1)
            break;

         if (c == '\0')
            break;

         v.push_back(c);
      }
   }

   return *this;
}

