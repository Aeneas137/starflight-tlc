/*
	STARFLIGHT - THE LOST COLONY
	Stardate.h - A robust Stardate class.
	Author: nybble
	Date: Jan-29-2007
*/

#ifndef STARDATE_H
#define STARDATE_H

#include <string>

class Archive;

class Stardate
{
public:
	Stardate();
	//Stardate( const Stardate &stardate );
	Stardate( int day, int hour, int month, int year );
	//Stardate( const std::string &fullDateString );	// dd.hh-mm-yyyy

	Stardate & operator =( const Stardate &stardate );
	int GetDay() const;
	int GetHour() const;
	int GetMonth() const;
	int GetYear() const;
	void SetDay( int day );
	void SetHour( int hour );
	void SetMonth( int month );
	void SetYear( int year );
	void SetDate( int day, int hour, int month, int year );
	void SetDateString( const std::string &dateString );
	void SetFullDateString( const std::string &fullDateString );
	std::string GetDateString() const;			// dd-mm-yyyy
	std::string GetFullDateString() const;		// dd.hh-mm-yyyy

	// the following compare full date strings, including hours
	bool operator==( const Stardate &stardate ) const;
	bool operator!=( const Stardate &stardate ) const;
	bool operator< ( const Stardate &stardate ) const;
	bool operator<=( const Stardate &stardate ) const;
	bool operator> ( const Stardate &stardate ) const;
	bool operator>=( const Stardate &stardate ) const;

	// compares all date properties except hour
	bool IsSameDay( const Stardate &stardate );

	// updates Stardate based on time since last update
	void Update( double gameTimeInSecs, double update_interval );

   void Reset();
   bool Serialize(Archive& out);


   int get_current_date_in_days(void);
   void add_days(int days);

	int totalHours;


private:
	Stardate DateStringToStardate( const std::string &dateString );
	Stardate FullDateStringToStardate( const std::string &fullDateString );
	bool IsNumber( const std::string &str );
	bool IsValidDate( int day, int month, int year );
	void initHours();

	// number of real seconds per game hour
	static const double SECS_PER_HOUR;
	
	static const int DEFAULT_DAY = 1;
	static const int DEFAULT_HOUR = 0;
	static const int DEFAULT_MONTH = 1;
	static const int DEFAULT_YEAR = 4622;

	int m_day;
	int m_hour;
	int m_month;
	int m_year;

};

#endif // STARDATE_H

