
#include "env.h"
#include <allegro.h>
#include "TileScroller.h"

TileScroller::TileScroller()
{
   scrollbuffer = NULL;
   tiles = NULL;
   tilewidth = 0;
   tileheight = 0;
   tilesacross = 0;
   tilesdown = 0;
   scrollx = 0.0f;
   scrolly = 0.0f;
   windowwidth = 0;
   windowheight = 0;
   columns = 1;
   rows = 1;
   this->resetTiles();
   bLoaded = false;
}

TileScroller::~TileScroller()
{
	this->destroy();
}

void TileScroller::destroy()
{
	if (scrollbuffer) 
	{
		destroy_bitmap(scrollbuffer);
		scrollbuffer = NULL;
	}

	if (bLoaded && tiles) 
	{
		destroy_bitmap(tiles);
		tiles = NULL;
	}
}

void TileScroller::resetTiles() 
{
   for (int one=0; one<MAX_SCROLL_SIZE; one++)
	  for (int two=0; two<MAX_SCROLL_SIZE; two++)
		 tiledata[one][two] = 0;
}


void TileScroller::setTile(int col, int row, short value)
{
   tiledata[col][row] = value;
}

short TileScroller::getTile(int col, int row)
{
   return tiledata[col][row];
}

short TileScroller::getTilebyCoords(int x, int y)
{
   return tiledata[x/tilewidth][y/tileheight];
}

void TileScroller::setTileImage(BITMAP *image) 
{ 
	if (!image) return;
	
	//if tile image was previously loaded, free it's memory
	if (bLoaded && tiles) {
		destroy_bitmap(tiles);
	}
	
	if (image) {
		this->tiles = image; 
		//image is now a pointer, not loaded
		bLoaded = false;
	}
}

int TileScroller::loadTileImage(char *filename)
{
	tiles = load_bitmap(filename, NULL);
	if (tiles) 
		bLoaded = true;
	else 
		bLoaded = false;

	return bLoaded;
}

int TileScroller::createScrollBuffer(int width,int height)
{
   this->windowwidth = width;
   this->windowheight = height;
	scrollbuffer = create_bitmap(width + tilewidth * 2, height + tileheight * 2);
   return (scrollbuffer != NULL);
}

void TileScroller::setScrollPosition(float x,float y)
{
   scrollx = x;
   scrolly = y;
}

void TileScroller::setScrollPosition(Point2D p) 
{
   this->scrollx = p.x; 
   this->scrolly = p.y;
}

void TileScroller::setRegionSize(int w,int h)
{
   if (w >= 0 && w <= MAX_SCROLL_SIZE) tilesacross = w; 
   if (h >= 0 && h <= MAX_SCROLL_SIZE) tilesdown = h;
}

/**
 * Fills the scroll buffer with tiles based on current scrollx,scrolly
**/
void TileScroller::updateScrollBuffer()
{
   short tilenum,left,top;

   //prevent a crash
   if ( (!scrollbuffer) || (!tiles) ) return;
	if (tilewidth < 1 || tileheight < 1) return;

   //calculate starting tile position
   int tilex = (int)scrollx / tilewidth;
   int tiley = (int)scrolly / tileheight;

   //calculate the number of columns and rows
   int cols = windowwidth / tilewidth;
   int rows = windowheight / tileheight;

   //draw tiles onto the scroll buffer surface
   int tx,ty;
   for (int y=0; y<=rows; y++) {
	  for (int x=0; x<=cols; x++)	{

		  tx = tilex + x;
		  if (tx < 0) tx = 0;
		  ty = tiley + y;
		  if (ty < 0) ty = 0;
		 tilenum = tiledata[tx][ty];

		 left = (tilenum % columns) * tilewidth;
		 top = (tilenum / columns) * tileheight;

		 blit(tiles, scrollbuffer, left, top, x*tilewidth, y*tileheight, tilewidth, tileheight);

		}
	}
}

/**
 * Draws the portion of the scroll buffer based on the current partial tile scroll position.
**/ 
void TileScroller::drawScrollWindow(BITMAP *dest, int x, int y, int width, int height)
{
	//prevent a crash
	if (tilewidth < 1 || tileheight < 1) return;
	
	//calculate the partial sub-tile lines to draw using modulus
	int partialx = (int)scrollx % tilewidth;
	int partialy = (int)scrolly % tileheight;
	
	//draw the scroll buffer to the destination bitmap
	if (scrollbuffer)
		blit(scrollbuffer, dest, partialx, partialy, x, y, width, height);
}
