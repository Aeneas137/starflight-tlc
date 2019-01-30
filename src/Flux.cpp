#include "Flux.h"
#include <cstdlib>

#define SQUARE(d_value) d_value*d_value

Flux::Flux(void){
	m_id = 0;
	m_tile.Y = 0; 
	m_tile.X = 0; 
	m_tile_exit.Y = 0;
	m_tile_exit.X = 0;
	m_position.x = 0;
	m_position.y = 0;
	m_exit_pos.x = 0;
	m_exit_pos.y = 0;
	m_is_visible_map = false;
	m_is_path_visible = false;
	m_is_visible_space = false;
	m_drawn = false;
	m_drawn_line = false;
}

Flux::Flux(int Y, int X){
	m_id = 0;
	m_tile.Y = Y; 
	m_tile.X = X; 
	m_tile_exit.Y = 0;
	m_tile_exit.X = 0;
	m_position.x = 0;
	m_position.y = 0;
	m_exit_pos.x = 0;
	m_exit_pos.y = 0;
	m_is_visible_map = false;
	m_is_path_visible = false;
	m_is_visible_space = false;
	m_drawn = false;
	m_drawn_line = false;
}

Flux::~Flux(void){
}

Flux::Flux(const Flux &rhs){
   *this = rhs;
}

Flux & Flux::operator=(const Flux &rhs){
	m_id = rhs.ID();
	m_position.x = rhs.POS().x;
	m_position.y = rhs.POS().y;
	m_exit_pos.x = rhs.EXIT().x;
	m_exit_pos.y = rhs.EXIT().y;

	m_tile.X = rhs.TILE().X; 
	m_tile.Y = rhs.TILE().Y; 
	m_tile_exit.X = rhs.TILE_EXIT().X; 
	m_tile_exit.Y = rhs.TILE_EXIT().Y;

	m_is_visible_map = rhs.VISIBLE();
	m_is_visible_space = rhs.VISIBLE_SPACE();
	m_is_path_visible = rhs.PATH_VISIBLE();
	m_drawn = rhs.DRAWN();
	m_drawn_line = rhs.LINE_DRAWN();

   return *this;
}

bool Flux::distance_check(double d_other_x, double d_other_y, double d_distance){
	/*if(d_distance < sqrt(SQUARE(d_other_x - this->tile.X) + SQUARE(d_other_y - this->tile.Y))){
		return true;
	}else{
		return false;
	}*/

	/*if(abs(this->m_tile.X - d_other_x) < d_distance && abs(this->m_tile.X - d_other_y) < d_distance){
		return true;
	}else{
		return false;
	}*/


	double dx = this->m_tile.X - d_other_x;
	double dy =this->m_tile.Y - d_other_y;
	if(dx*dx + dy*dy < d_distance){
		return true;
	}else{
		return false;
	}
}
