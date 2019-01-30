/*
	STARFLIGHT - THE LOST COLONY
	Point2D.h - A simple class for 2d points, consists of only a few methods and operations.
	Author: ?
	Date: ?
*/

#ifndef POINT2D_H
#define POINT2D_H

#include <cmath>
#include <string>

#include "Archive.h"

///////////////////////////////////////////////////////////////////////////////
// Point2D
//
// This class represents a basic two dimensional point.
///////////////////////////////////////////////////////////////////////////////

class Point2D {
public:
	double x, y;

	Point2D() {}
	Point2D( const Point2D& p ) { *this = p; }
	Point2D( double nx, double ny ) { SetPosition( nx, ny ); }

   void Reset()
   {
      x = y = 0;
   }

   bool Serialize(Archive& ar)
   {
      std::string ClassName = "Point2D";
      int Schema = 0;

      if (ar.IsStoring())
      {
         ar << ClassName;
         ar << Schema;

         ar << x;
         ar << y;
      }
      else
      {
         Reset();

         std::string LoadedClassName;
         ar >> LoadedClassName;
         if (LoadedClassName != ClassName)
            return false;

         int LoadedSchema;
         ar >> LoadedSchema;
         if (LoadedSchema > Schema)
            return false;

         ar >> x;
         ar >> y;
      }

      return true;
   }

	void SetPosition( double nx, double ny ) {
		this->x = nx;
		this->y = ny;
	}

	void Zero() { x = y = 0.0; }

	bool operator==( const Point2D& p ) const {
		const double EPSILON = 0.0001;

		return (
			(((p.x - EPSILON) < x) && (x < (p.x + EPSILON))) &&
			(((p.y - EPSILON) < y) && (y < (p.y + EPSILON)))
		);
	}

	bool operator!=( const Point2D& p ) const {
		return (!(*this == p));
	}

	Point2D& operator=( const Point2D& p ) {
		x = p.x;
		y = p.y;
		return *this;
	}

	static double Distance( const Point2D& a, const Point2D& b ) {
		return sqrt((b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y));
	}
};

#endif // POINT2D_H

