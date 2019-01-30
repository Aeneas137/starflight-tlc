#include "Vector3.h"

#pragma once

    const double PI = 3.1415926535;
    const double PI_over_180 = PI / 180.0f;
    const double PI_under_180 = 180.0f / PI;
    
    class Math {
    public:
        static double toDegrees(double radian);
        static double toRadians(double degree);
        static double wrapAngleDegs(double degs);
        static double wrapAngleRads(double rads);
        static double LinearVelocityX(double angle);
        static double LinearVelocityY(double angle);
        static Vector3 LinearVelocity(double angle);
        static double AngleToTarget(double x1,double y1,double x2,double y2);
        static double AngleToTarget(Vector3& source,Vector3& target);
        static double Distance( double x1,double y1,double x2,double y2 );
        static double Distance( Vector3& v, Vector3& vec2  );
        static double Length(Vector3& vec);
        static double Length(double x,double y,double z);
        static double DotProduct(double x1,double y1,double z1,double x2,double y2,double z2);
        static double DotProduct( Vector3& vec1, Vector3& vec2 );
        static Vector3 CrossProduct( double x1,double y1,double z1,double x2,double y2,double z2);
        static Vector3 CrossProduct( Vector3& vec1, Vector3& vec2 );
        static Vector3 Normal(double x,double y,double z);
        static Vector3 Normal(Vector3& vec);
    };
