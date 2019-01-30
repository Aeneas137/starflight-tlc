/*
	STARFLIGHT - THE LOST COLONY
	util.cpp - ?
	Author: ?
	Date: ?
*/

#include "env.h"
#include "Game.h"
#include "Util.h"

#include <algorithm>
using namespace std;

void Util::Init()
{
   srand((unsigned int)time(NULL));
}

float Util::Interpolate(float val, float valMin, float valMax, float newMin, float newMax)
{
   float per = ((val-valMin)/(valMax-valMin));
   float newVal = ((newMax-newMin) * per) + newMin;
   return newVal;
}

long Util::DegsToFixed(float degs)
{
   float newDegs = Interpolate(degs,0,359,0,254);
   return ftofix(newDegs);
}

void Util::NormalizeAngle(double &angle)
{
   angle = WrapValue(angle, 0.0, 360.0);
}

void Util::ScaleToWidth(float curWidth, float curHeight, float newWidth, float &newHeight)
{
   float ratio = curHeight / curWidth;
   newHeight = ratio * newWidth;
}

void Util::ScaleToHeight(float curWidth, float curHeight, float newHeight, float &newWidth)
{
   float ratio = curWidth / curHeight;
   newWidth = ratio * newHeight;
}

bool Util::FloatEq(double a, double b, double epsilon /*= 0.0001*/)
{
   if (a == b)
      return true;
   if (a > b - epsilon && a < b + epsilon)
	  return true;

  return false;
}

int Util::ReentrantDelay(int ms)
{
	static int start = 0;
	int retval = 0;

	if (start == 0)
	{
		start = g_game->globalTimer.getTimer();
	}
	else {
		if (g_game->globalTimer.getTimer() > start + ms) {
			start = 0;
			retval = 1;
		}
	}

	return retval;
}

//you realize this is built into the string, right?
void Util::CleanAndTrimString(std::string& s)
{
   if (s.size() == 0)
      return;

   std::string tmp;

   tmp = "";
   for (std::string::iterator i = s.begin(); i != s.end(); ++i)
   {
      char& c = *i;
      if ((c >= 0x20) && (c <= 0x7E))
         tmp += c;
   }
   s = tmp;

   if (s.size() == 0)
      return;

   tmp = "";
   bool leading = true;
   for (std::string::iterator i = s.begin(); i != s.end(); ++i)
   {
      char& c = *i;
      if (leading)
      {
         if (c != 0x20)
         {
            leading = false;
            tmp += c;
         }
      }
      else
      {
         tmp += c;
      }
   }
   s = tmp;

   if (s.size() == 0)
      return;

   tmp = "";
   bool trailing = true;
   for (std::string::reverse_iterator i = s.rbegin(); i != s.rend(); ++i)
   {
      char& c = *i;
      if (trailing)
      {
         if (c != 0x20)
         {
            trailing = false;
            std::string tmp2;
            tmp2 += c;
            tmp = tmp2 + tmp;
         }
      }
      else
      {
         std::string tmp2;
         tmp2 += c;
         tmp = tmp2 + tmp;
      }
   }
   s = tmp;
}


std::string Util::ToUpper(std::string& str)
{
	std::string converted;
	for(int i = 0; i < str.size(); ++i)
		converted += toupper(str[i]);
	return converted;
}

void Util::MakeUpper(std::string& s)
{
   if (s.size() == 0)
      return;
   std::string tmp;
   for (std::string::iterator i = s.begin(); i != s.end(); ++i)
   {
      char& c = *i;

      if ((c >= 0x61) && (c <= 0x7A))
         c -= 32;

      tmp += c;
   }
}

void Util::Tokenize(std::string str, std::vector<std::string>& toks, std::string delim)
{
   toks.clear();

   if (str.size() == 0)
      return;

   string curtok;
   for (string::iterator i = str.begin(); i != str.end(); ++i)
   {
      char & c = *i;

      if (find(delim.begin(),delim.end(),c) == delim.end())
      {
         curtok += c;
      }
      else
      {
         toks.push_back(curtok);
         curtok = "";
      }
   }

   if (curtok.size() > 0)
      toks.push_back(curtok);

   if (find(delim.begin(),delim.end(),str[str.size()-1]) != delim.end())
      toks.push_back("");
}
