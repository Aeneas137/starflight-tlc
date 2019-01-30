/*
	STARFLIGHT - THE LOST COLONY
	Class: Flux
	Author: Keith Patch
	Date: 10-29-2007
*/

#pragma once
//#include "Sprite.h"
#include "Point2D.h"

typedef int ID;
struct Tile{
	int X, Y;
};

class Flux /*: public Sprite*/{
public:
	Flux(void);
	Flux(int,int);
	virtual ~Flux(void);
	Flux(const Flux& rhs);
    Flux& operator=(const Flux& rhs);
	
	bool distance_check(double d_other_x, double d_other_y, double d_distance); //returns true if the other flux is within the distance value

	int			ID() const			{ return m_id; }
	int&		rID()				{ return m_id; } 
	
	Tile		TILE() const		{ return m_tile; }
	Tile&		rTILE()				{ return m_tile; } 
	Tile		TILE_EXIT() const	{ return m_tile_exit; }
	Tile&		rTILE_EXIT()		{ return m_tile_exit; } 
	
	Point2D		POS() const			{ return m_position; }
	Point2D&	rPOS()				{ return m_position; } 
	Point2D		EXIT() const		{ return m_exit_pos; }
	Point2D&	rEXIT()				{ return m_exit_pos; } 

	bool		VISIBLE() const     { return m_is_visible_map; }
	bool&		rVISIBLE()          { return m_is_visible_map; } 

	bool		PATH_VISIBLE() const				{ return m_is_path_visible; }
	bool&		rPATH_VISIBLE()						{ return m_is_path_visible; } 
	void		PATH_VISIBLE(bool is_path_visible)	{  m_is_path_visible = is_path_visible;}

	bool		VISIBLE_SPACE() const     { return m_is_visible_space; }
	bool&		rVISIBLE_SPACE()          { return m_is_visible_space; } 

	bool		DRAWN() const						{return m_drawn;}
	bool&		rDRAWN()							{ return m_drawn;}
	void		DRAWN(bool has_been_drawn)			{m_drawn = has_been_drawn;}
	bool		LINE_DRAWN() const					{return m_drawn_line;}
	bool&		rLINE_DRAWN()						{ return m_drawn_line;}
	void		LINE_DRAWN(bool has_been_drawn)		{m_drawn_line = has_been_drawn;}

	bool&		rTRAVELED()							{return m_traveled_before;}
	bool		TRAVELED() const					{return m_traveled_before;}
	void		TRAVELED(bool has_been_traveled)	{m_traveled_before = has_been_traveled;}
	
private:
	int		m_id;
	Tile 	m_tile, 
			m_tile_exit;

	Point2D m_position, 
			m_exit_pos;

	bool	m_is_visible_map; //on the starmap
	bool	m_is_visible_space; //in space
	bool    m_is_path_visible; //on starmap
	bool	m_drawn; //drawn to the starmap?
	bool	m_drawn_line; //has the path been drawn
	bool	m_traveled_before;	//has this flux been used before? The Navigator needs to know this stuff.
};
