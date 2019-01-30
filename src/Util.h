/*
	STARFLIGHT - THE LOST COLONY
	util.h - ?
	Author: ?
	Date: ?
*/

#ifndef UTIL_H
#define UTIL_H

#include "env.h"
#include <allegro.h>
#include <stdlib.h>
#include <math.h> 
#include <iostream>
#include <iomanip>
#include <sstream>
#include <string>
#include <vector>
#include "Point2D.h"

#define DEGS2RADS ((float)(3.14159/180.0))
#define CLOCKS2SECS(c) ((double)(c) / (double)CLOCKS_PER_SEC)

class Util
{
public:

   /**
    * Initialize utility methods; this should be called before any other
    * methods in this class
    */
   static void Init();

	template <class T> static std::string ToString(const T & t, int width = 1, int precision = 2)
	{
	  std::ostringstream oss;
	  oss.precision(precision);
	  oss.width(width);
	  oss.fill('0');
	  oss.setf(std::ios_base::fixed);
	  oss << t; 
	  return oss.str();
	}

    template<typename T> static T FromString(const std::string& str)
    {
        std::istringstream ss(str);
        T ret;
        ss >> ret;
        return ret;
    }

    static int StringToInt(const std::string &str)
    {
        int i;
        try {
            i = std::stoi(str);
        }
        catch (...) {
            return 0;
        }
        return i;
    }

    static double StringToDouble(const std::string &str)
    {
        double d;
        try {
            d = std::stod(str);
        }
        catch (...) {
            return 0;
        }
        return d;
    }

    /**
     * Rounds to nearest whole number (including negatives)
     */
    static double Round(double num) 
    {
        return (num > 0.0) ? floor(num + 0.5) : ceil(num - 0.5);
    }


   /**
    * returns a random number in the range [min.max] inclusive
    */
   static int Random(int min, int max)
   {
	   return rand() % (max - min + 1) + min;
   }

   /**
    * given a min-max range, this takes the value and wraps it as
    * necessary to keep it within the range [min, max)
    */
   static double WrapValue(double value, double min=0.0, double max=360.0)
   {
      /*
      if (val < min) { val = max + 1 + (val-min); }
      else if (val > max) { val = val - max - 1; }
      */
      if ( min >= max )
      {
         return max;
      }

      if ( value < min ) { value = max + fmod((value-min), (max-min)); }
      else if ( value >= max ) { value = fmod((value-min), (max-min)); }

	  return value;
   }

   /**
    * limit the signed value to having the specified magnitude
    */
   template<class T> static void ClampValue(T &val, T mag)
   {
      if (val > mag)
         val = mag;
      if (val < -mag)
         val = -mag;
   }

     /**
    * limit the signed value to having the specified magnitude
    */
   template<class T> static T ClampValue(T val, T low, T high)
   {
      if (val > high)
         val = high;
      if (val < low)
         val = low;
	  return val;
   }

   /**
    * simple interpolation
    */
   static float Interpolate(float val, float valMin, float valMax, float newMin, float newMax);

   /**
    * converts an angle in degrees to an allegro fixed point angular value
    */
   static long DegsToFixed(float degs);

   /**
    * normalize the specified angle to force it into [0,360) degrees
    */
   static void NormalizeAngle(double &angle);

   /**
    * Scales to the specified width, preserving the aspect ratio
    */
   static void ScaleToWidth(float curWidth, float curHeight, float newWidth, float &newHeight);

   /**
    * Scales to the specified height, preserving the aspect ratio
    */
   static void ScaleToHeight(float curWidth, float curHeight, float newHeight, float &newWidth);

   /**
    * Checks to see if two floating point numbers are equal.
	*/
   static bool FloatEq(double a, double b, double epsilon = 0.0001);

	//this function will continue to return false until millisecond delay has 
	//transpired, which is useful when called from inside a loop or timed routine
	static int ReentrantDelay(int ms);
	
   // cleans non-printing chars and leading/trailing whitespace from strings
   static void CleanAndTrimString(std::string& s);

   // converts a string to all upper case
   static std::string ToUpper(std::string& str);
   static void MakeUpper(std::string& s);

   // breaks up a string into tokens using the specified delimeter(s)
   static void Tokenize(std::string str, std::vector<std::string>& toks, std::string delim);

};

class Rect
{
public:
	int left;
	int top;
	int right;
	int bottom;
	
public:
	Rect() 
	{
		left = 0;
		top = 0;
		right = 0;
		bottom = 0;
	}
	
	Rect(Point2D ul, Point2D lr)
	{
		left = (int)ul.x;
		top = (int)ul.y;
		right = (int)lr.x;
		bottom = (int)lr.y;
	}
	
	Rect(int l, int t, int r, int b)
	{
		left = l;
		top = t;
		right = r;
		bottom = b;
	}
	
	bool contains(Point2D p)
	{
		return contains(p.x,p.y);
	}
	
	bool contains(int x,int y)
	{
		return (x >= left && x <= right && y >= top && y <= bottom);
	}

	bool contains(double x,double y)
	{
		return (x >= left && x <= right && y >= top && y <= bottom);
	}

};


#endif
