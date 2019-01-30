#ifndef _TILESCROLLER_H
#define _TILESCROLLER_H 1

#include "env.h"
#include <allegro.h>
#include <stdlib.h>
#include <string.h>
#include "Point2D.h"

#define MAX_SCROLL_SIZE 2500

class TileScroller 
{
private:
   BITMAP *scrollbuffer;
   BITMAP *tiles;

   short tiledata[MAX_SCROLL_SIZE][MAX_SCROLL_SIZE];

   int tilewidth, tileheight, columns, rows;
   int tilesacross, tilesdown;
   float scrollx, scrolly;
   int windowwidth,windowheight;
   
   bool bLoaded;


public:
   ~TileScroller();
   TileScroller();
   void destroy();
   int createScrollBuffer(int width,int height);
   int loadTileImage(char *filename);
   void resetTiles();

   void setTile(int col, int row, short value);
   short getTile(int col, int row);
   short getTilebyCoords(int x, int y);

   int getTileImageColumns() { return this->columns; }
   void setTileImageColumns(int c) { this->columns = c; }

   int getTileImageRows() { return this->rows; }
   void setTileImageRows(int r) { this->rows = r; }

   void setTileSize(int w,int h) { this->tilewidth = w; this->tileheight = h; }
   int getTileWidth() { 
		return tilewidth; 
	}
   void setTileWidth(int width) { this->tilewidth = width; }
	int getTileHeight() { 
		return this->tileheight; 
	}
   void setTileHeight(int height) { this->tileheight = height; }

   void setRegionSize(int w,int h);
   int getTilesAcross() { return this->tilesacross; }
   int getTilesDown() { return this->tilesdown; }

   void setWindowSize(int w,int h) { this->windowwidth = w; this->windowheight = h; }
   int getWindowWidth() { return this->windowwidth; }
   int getWindowHeight() { return this->windowheight; }

   BITMAP *getTileImage() { return this->tiles; }
   void setTileImage(BITMAP *image);

   void setScrollPosition(float x,float y);
   void setScrollPosition(Point2D p);
   float getScrollX() { return this->scrollx; }
   void setScrollX(int x) { this->scrollx = x; }
   float getScrollY() { return this->scrolly; }
   void setScrollY(int y) { this->scrolly = y; }

   void updateScrollBuffer();
   void drawScrollWindow(BITMAP *dest, int x, int y, int width, int height);
};


#endif

