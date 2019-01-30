#ifndef ARCHIVE_H
#define ARCHIVE_H
#pragma once

#include <string>
#include <stdio.h>

class Archive
{
public:
   Archive();
   virtual ~Archive();

   typedef enum
   {
      AM_NONE = 0,
      AM_STORE,
      AM_LOAD
   } ArchiveMode;

   bool Open(std::string fileName, ArchiveMode mode);
   void Close();

   bool IsOpen();

   Archive& operator<<(double v);
   Archive& operator<<(int v);
   Archive& operator<<(bool v);
   Archive& operator<<(float v);
   Archive& operator<<(std::string &v);
   Archive& operator<<(const char *v);

   Archive& operator>>(double &v);
   Archive& operator>>(int &v);
   Archive& operator>>(bool &v);
   Archive& operator>>(float &v);
   Archive& operator>>(std::string &v);

   bool IsStoring();

private:
   FILE *file;
   ArchiveMode arMode;

   bool VerifyTypeCode(char typeCode);
   void WriteTypeCode(char typeCode);
};

#endif
