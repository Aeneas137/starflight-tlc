/*
	STARFLIGHT - THE LOST COLONY
	Stardate.cpp - A robust Stardate class.
	Author: nybble
	Date: Jan-29-2007
*/

#include "env.h"
#include "Stardate.h"
#include "Util.h"
#include "Archive.h"

#include <iostream>
#include <sstream>
#include <iomanip>
#include <string>
#include <cstdlib>
#include <cctype>

using namespace std;


#define JANUARY 1
#define FEBRUARY 2
#define MARCH 3
#define APRIL 4
#define MAY 5
#define JUNE 6
#define JULY 7
#define AUGUST 8
#define SEPTEMBER 9
#define OCTOBER 10
#define NOVEMBER 11
#define DECEMBER 12



int daysPassedByMonth[] = { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 };


Stardate::Stardate()
{
	SetDate( DEFAULT_DAY, DEFAULT_HOUR, DEFAULT_MONTH, DEFAULT_YEAR );
	initHours();
}

Stardate::Stardate( int day, int hour, int month, int year )
{
	SetDate( day, hour, month, year );
	initHours();
}

void Stardate::initHours()
{
	// calculate the total number of hours based on default stardate
	totalHours = DEFAULT_YEAR * 8760;
	totalHours += daysPassedByMonth[DEFAULT_MONTH-1] * 24;
	totalHours += (DEFAULT_DAY - 1) * 24;
	totalHours += DEFAULT_HOUR;
}


void Stardate::Update( double gameTimeInSecs, double update_interval )
{
	// number of days that should be added based on which month it is
	//static int daysPassedByMonth[12] = { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 };

	//calculate year
	int newHours = totalHours + (int)(gameTimeInSecs / update_interval);
	int year = newHours / 8760;
	int remainingDays = (newHours % 8760) / 24;

	//calculate month
	int i = 11;
	while (daysPassedByMonth[i] > remainingDays) i--;
	int month = i + 1;

	//calculate day
	int day = (remainingDays - daysPassedByMonth[i]) + 1;

	//calculate hour
	int hour = (newHours % 8760) % 24;

	//set new date
	SetDate( day, hour, month, year );
}


//Stardate::Stardate( const Stardate &stardate ) :
//m_day(stardate.m_day),
//m_hour(stardate.m_hour),
//m_month(stardate.m_month),
//m_year(stardate.m_year)
//{
//	paused = true;
//}
//
//
//Stardate::Stardate( const std::string &fullDateString )
//{
//	SetFullDateString( fullDateString );
//}

Stardate & Stardate::operator =( const Stardate &stardate )
{
	m_day = stardate.m_day;
	m_hour = stardate.m_hour;
	m_month = stardate.m_month;
	m_year = stardate.m_year;

	return *this;
}

int Stardate::GetDay() const
{
	return m_day;
}

int Stardate::GetHour() const
{
	return m_hour;
}

int Stardate::GetMonth() const
{
	return m_month;
}

int Stardate::GetYear() const
{
	return m_year;
}

void Stardate::SetDay( int day )
{
	// takes current month into account to test if this is an valid
	// day.  If you are setting componenets individually, be sure
	// to set month and year before setting date
	if (IsValidDate( day, m_month, m_year ))
		m_day = day;
}

void Stardate::SetHour( int hour )
{
	if (hour >= 0 && hour < 24)
		m_hour = hour;
}

void Stardate::SetMonth( int month )
{
	if (month >= 1 && month <= 12)
		m_month = month;
}

void Stardate::SetYear( int year )
{
	if (year > 0)
		m_year = year;
}

void Stardate::SetDate( int day, int hour, int month, int year )
{
	SetYear( year );
	SetMonth( month );
	SetHour( hour );
	SetDay( day );
}

void Stardate::SetDateString( const std::string &dateString )
{
	Stardate s = DateStringToStardate( dateString );

	SetYear( s.GetYear() );
	SetMonth( s.GetMonth() );
	SetHour( 0 );
	SetDay( s.GetDay() );
}
void Stardate::SetFullDateString( const std::string &fullDateString )
{
	Stardate s = FullDateStringToStardate( fullDateString );

	SetYear( s.GetYear() );
	SetMonth( s.GetMonth() );
	SetHour( s.GetHour() );
	SetDay( s.GetDay() );
}

std::string Stardate::GetDateString() const
{
	ostringstream str;

	// dd-mm-yyyy
	str << right << setw(2) << setfill('0') << GetDay() << '-'
		<< right << setw(2) << setfill('0') << GetMonth() << '-'
		<< right << setw(4) << setfill('0') << GetYear();

	return str.str();
}

std::string Stardate::GetFullDateString() const
{
	ostringstream str;

	// hh.mm-dd-yyyy
	str << right << setw(2) << setfill('0') << GetHour() << '.'
		<< right << setw(2) << setfill('0') << GetMonth() << '-'
		<< right << setw(2) << setfill('0') << GetDay() << '-'
		<< right << setw(4) << setfill('0') << GetYear();

	// yyyy-mm-dd.hh
	//str << right << setw(4) << setfill('0') << GetYear() << '-'
	//	<< right << setw(2) << setfill('0') << GetMonth() << '-'
	//	<< right << setw(2) << setfill('0') << GetDay() << '.'
	//	<< right << setw(2) << setfill('0') << GetHour();

	return str.str();
}

bool Stardate::operator==( const Stardate &stardate ) const
{
	return (m_day == stardate.GetDay() && m_hour == stardate.GetHour() &&
		m_month == stardate.GetMonth() && m_year == stardate.GetYear());
}

bool Stardate::operator!=( const Stardate &stardate ) const
{
	return !(*this == stardate);
}

bool Stardate::operator< ( const Stardate &stardate ) const
{
	if (m_year < stardate.GetYear())
		return true;
	else
	if (m_year == stardate.GetYear())
	{
		if (m_month < stardate.GetMonth())
			return true;
		else
		if (m_month == stardate.GetMonth())
		{
			if (m_day < stardate.GetDay())
				return true;
			else
			if (m_day == stardate.GetDay())
			{
				if (m_hour < stardate.GetHour())
					return true;
			}
		}
	}

	return false;
}

bool Stardate::operator<=( const Stardate &stardate ) const
{
	if (*this < stardate || *this == stardate)
		return true;

	return false;
}

bool Stardate::operator> ( const Stardate &stardate ) const
{
	if (!(*this < stardate) && *this != stardate)
		return true;

	return false;
}

bool Stardate::operator>=( const Stardate &stardate ) const
{
	if (!(*this < stardate))
		return true;

	return false;
}

bool Stardate::IsSameDay( const Stardate &stardate )
{
	// returns true if all stardate properties are equal
	// except for the hour (and of course delta)

	if (GetDay() == stardate.GetDay() &&
		GetMonth() == stardate.GetMonth() &&
		GetYear() == stardate.GetYear())
		return true;

	return false;
}

Stardate Stardate::DateStringToStardate( const std::string &dateString )
{
	Stardate sd( DEFAULT_DAY, DEFAULT_HOUR, DEFAULT_MONTH, DEFAULT_YEAR );

	if (dateString.length() != 10)
		return sd;

	// check for dd-mm-yyyy format
	if (dateString.at(2) != '-' || dateString.at(5) != '-')
		return sd;

	string dayStr = dateString.substr( 0, 2 );
	string monthStr = dateString.substr( 3, 2 );
	string yearStr = dateString.substr( 6, 4 );

	if (!IsNumber( dayStr ) || !IsNumber( monthStr ) || !IsNumber( yearStr ))
		return sd;

	// convert to integer representations
	int day = atoi( dayStr.c_str() );
	int month = atoi( monthStr.c_str() );
	int year = atoi( yearStr.c_str() );

	if (!IsValidDate( day, month, year ))
		return sd;

	sd.SetDate( day, 0, month, year );

	return sd;
}

Stardate Stardate::FullDateStringToStardate( const std::string &fullDateString )
{
	Stardate sd( DEFAULT_DAY, DEFAULT_HOUR, DEFAULT_MONTH, DEFAULT_YEAR );

	if (fullDateString.length() != 13)
		return sd;

	// check for dd.hh-mm-yyyy format
	if (fullDateString.at(2) != '.' || fullDateString.at(5) != '-' ||
		fullDateString.at(8) != '-')
		return sd;

	string dayStr = fullDateString.substr( 0, 2 );
	string hourStr = fullDateString.substr( 3, 2 );
	string monthStr = fullDateString.substr( 6, 2 );
	string yearStr = fullDateString.substr( 9, 4 );

	if (!IsNumber( dayStr ) || !IsNumber( monthStr ) || !IsNumber( yearStr ) ||
		!IsNumber( hourStr))
		return sd;

	// convert to integer representations
	int day = atoi( dayStr.c_str() );
	int hour = atoi( hourStr.c_str() );
	int month = atoi( monthStr.c_str() );
	int year = atoi( yearStr.c_str() );

	if (hour < 0 || hour > 23)
		return sd;

	if (!IsValidDate( day, month, year ))
		return sd;

	sd.SetDate( day, hour, month, year );

	return sd;
}

// Returns true if the string is a number
bool Stardate::IsNumber( const std::string &str )
{
	for (int i = 0; (unsigned)i < str.length(); i++) {
		if (!isdigit(str.at(i)))
			return false;
	}

	return true;
}

// Based on the traditional, current day calendar, calculate
// if this is a valid date
bool Stardate::IsValidDate( int day, int month, int year )
{
	// month is from 1 through 12
	if (month < 1 || month > 12)
		return false;

	if (year < 0)
		return false;

	// days in each month
	int daysInMonth[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

	// is this a leap year?
	/*if (!(year % 4)) {
		if ((year % 100)) {			// if this is not a century
			daysInMonth[1] = 29;	// then it's a leap year
		}
		else
		if (!(year % 400)) {		// Or, if it is a century but is
			daysInMonth[1] = 29;	// divisible by 400, it's still a leap year
		}
	}*/

	if (day < 1 || day > daysInMonth[month-1])
		return false;

	return true;
}

void Stardate::Reset()
{
	SetDate( DEFAULT_DAY, DEFAULT_HOUR, DEFAULT_MONTH, DEFAULT_YEAR );
}

bool Stardate::Serialize(Archive& ar)
{
   string ClassName = "Stardate";
   int Schema = 0;

   if (ar.IsStoring())
   {
      ar << ClassName;
      ar << Schema;

      ar << m_day;
      ar << m_hour;
      ar << m_month;
      ar << m_year;
   }
   else
   {
      Reset();

      string LoadClassName;
      ar >> LoadClassName;
      if (LoadClassName != ClassName)
         return false;

      int LoadSchema;
      ar >> LoadSchema;
      if (LoadSchema > Schema)
         return false;

      ar >> m_day;
      ar >> m_hour;
      ar >> m_month;
      ar >> m_year;
   }

   return true;
}

int Stardate::get_current_date_in_days(void)
{
	int i_current_year = m_year;//m_gameState->stardate.GetYear();
	int i_current_month = m_month;// m_gameState->stardate.GetMonth();
	int i_current_day = m_day;//m_gameState->stardate.GetDay();
	int i_days_in_month = 0;
	for(int i = 1; i < i_current_month; i++)
	{
		switch(i){
			case FEBRUARY:
				i_days_in_month += 28;
				break;
			case APRIL: case JUNE: case SEPTEMBER: case NOVEMBER:
				i_days_in_month += 30;
				break;
			case JANUARY: case MARCH: case MAY: case JULY: case AUGUST: case OCTOBER:
				i_days_in_month += 31;
				break;
			default:
				i_days_in_month += 0;
				break;
		}
	}
	return (i_current_year * 365) + i_days_in_month + i_current_day;
}

void Stardate::add_days(int days){
	if(days > 0){
		if(m_day + days > 28){
			int i_days_in_month = 0;
			while(m_day + days > i_days_in_month){
				switch(m_month){
					case FEBRUARY:
						i_days_in_month = 28;
						break;
					case APRIL: case JUNE: case SEPTEMBER: case NOVEMBER:
						i_days_in_month = 30;
						break;
					case JANUARY: case MARCH: case MAY: case JULY: case AUGUST: case OCTOBER:
						i_days_in_month = 31;
						break;
					default:
						i_days_in_month = 0;
						break;
				}
				if(m_day + days > i_days_in_month){
					m_month++;
					if(m_month > 12){m_year++; m_month = m_month-12;}
					days -= i_days_in_month;
					//add_days(days);
				}
			}
		}
		m_day += days;
	}
}
