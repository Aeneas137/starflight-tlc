
#include "env.h"
#include <allegro.h>
#include <string.h>
#include "Util.h"
#include "Game.h"
#include "AdvancedTileScroller.h"


AdvancedTileScroller::AdvancedTileScroller(int TilesAcross, int TilesDown, int TileWidth, int TileHeight):
   scrollbuffer(0),
   tiles(0),
   tileWidth(TileWidth),
   tileHeight(TileHeight),
   tilesAcross(TilesAcross),
   tilesDown(TilesDown),
   scrollX(0.0f),
   scrollY(0.0f),
   windowWidth(0),
   windowHeight(0),
   numofTypes(0),
   baseVariations(0),
   tileData(0),
   pointData(0)
{
	tileData = new BITMAP*[TilesAcross * TilesDown];
	pointData = new short[(TilesAcross + 1) * (TilesDown + 1)];
	ResetTiles();
	ResetPointData();
	loadedFromDataFile = false;
}

AdvancedTileScroller::~AdvancedTileScroller()
{
    this->Destroy();
}

void AdvancedTileScroller::Destroy()
{
   if (scrollbuffer) 
   {
	   destroy_bitmap(scrollbuffer);
	   scrollbuffer = NULL;
   }

	for (int i=0; i < (int)tiles.size(); ++i)
	{
	   if (tiles[i] != NULL) 
	   {
		   //if tile images were loaded from bitmap file, then we must free them
		   //but if a pointer to a data file bitmap was used, do not free the memory!
			if (!loadedFromDataFile) destroy_bitmap(tiles[i]->tiles);

		   delete tiles[i];
		   tiles[i] = NULL;
	   }
	}
	tiles.clear();
   
   ClearTileImageCache();
   delete [] pointData;
   delete [] tileData;

}

void AdvancedTileScroller::ResetTiles() 
{
   for (int x=0; x < tilesAcross * tilesDown; ++x)
   {
	   tileData[x] = NULL;
   }
}

void AdvancedTileScroller::ResetPointData() 
{
   for (int x=0; x < (tilesAcross + 1) * (tilesDown + 1); ++x)
   {
	   pointData[x] = 0;
   }
}

void AdvancedTileScroller::ClearTileImageCache()
{
	for (cacheIt = tileImageCache.begin(); cacheIt != tileImageCache.end(); ++cacheIt)
	{
		destroy_bitmap(cacheIt->second);
		cacheIt->second = NULL;
	}
	tileImageCache.clear();
}

void AdvancedTileScroller::PurgePrimaryImages()
{

	for (int i=0; i < (int)tiles.size(); ++i)
	{
		if (tiles[i])
		{
			delete tiles[i];
			tiles[i] = NULL;
			tiles.erase(tiles.begin() + i);
		}
	}
}

bool AdvancedTileScroller::LoadTileSet(char *FileName, int Variations, bool GroundNavigation, bool AirNavigation)
{
	BITMAP *tileSetImage = NULL; 
	tileSetImage = load_bitmap(FileName, NULL);
	if (!tileSetImage) {
		g_game->message("error loading tileSetImage");
		return false;
	}		

	if (tileSetImage != NULL)
		tiles.push_back(new TileSet(tileSetImage, Variations, GroundNavigation, AirNavigation));

	//data not loaded from data file, but from a bitmap file, so we must delete bitmaps afterward
	loadedFromDataFile = false;

	return (tileSetImage != NULL);
}

bool AdvancedTileScroller::LoadTileSet(BITMAP *tileImage, int Variations, bool GroundNavigation, bool AirNavigation)
{
	if (!tileImage) {
		g_game->message("PlanetSurface: error loading tileSetImage");
		return false;
	}		

	tiles.push_back(new TileSet(tileImage, Variations, GroundNavigation, AirNavigation));

	//when loading from data file, we must not free images afterward!
	loadedFromDataFile = true;
	
	return true;
}

bool AdvancedTileScroller::GenerateTiles()
{
	if ((int)tileImageCache.size() > 0)
	{
		ClearTileImageCache();
	}

	for (int x=0; x < tilesAcross; ++x)
	{
		for (int y=0; y < tilesDown; ++y) //Loop through all the tiles
		{
			tileData[tdIndex(x,y)] = GenerateTile(CalcTileBaseType(x, y), x, y);
		}
	}

	return true;
}

BITMAP *AdvancedTileScroller::GenerateTile(int BaseTileSet, int TileX, int TileY)
{
	int key = 0;
	int variation = (int)(pow( (float)(rand() / RAND_MAX), 22) * (tiles[BaseTileSet]->getVariations() + 2));
	if (variation > tiles[BaseTileSet]->getVariations() + 1) variation = tiles[BaseTileSet]->getVariations() + 1;
	int pdIndexes[4];
	pdIndexes[0] = pdIndex(TileX, TileY);
	pdIndexes[1] = pdIndex(TileX, TileY + 1);
	pdIndexes[2] = pdIndex(TileX + 1, TileY + 1);
	pdIndexes[3] = pdIndex(TileX + 1, TileY);

	if ( !(pointData[pdIndexes[0]] == pointData[pdIndexes[1]] && pointData[pdIndexes[1]] == pointData[pdIndexes[2]] && pointData[pdIndexes[2]] == pointData[pdIndexes[3]]) )
		variation = 0;

	key = BaseTileSet				* 0x1;
	key += variation				* 0x10;
	key += pointData[pdIndexes[0]]	* 0x1000;
	key += pointData[pdIndexes[1]]	* 0x10000;
	key += pointData[pdIndexes[2]]	* 0x100000;
	key += pointData[pdIndexes[3]]	* 0x1000000;

	BITMAP *tile = FindTile(key);
	if (tile == NULL)
	{
		tile = create_bitmap(tileWidth, tileHeight);
		BITMAP *scratch = create_bitmap(tileWidth, tileHeight);
		if (variation == 0)
			blit(tiles[BaseTileSet]->getTiles(), tile, 0, 0, 0, 0, tileWidth, tileHeight);
		else if (variation == 1)
			blit(tiles[BaseTileSet]->getTiles(), tile, 3 * tileWidth, 3 * tileHeight, 0, 0, tileWidth, tileHeight);
		else
			blit(tiles[BaseTileSet]->getTiles(), tile, 256 + ((int)((variation-2)%4) * tileWidth), ((int)((variation-2)/4) * tileHeight), 0, 0, tileWidth, tileHeight);

		int pdValues[4];
		pdValues[0] = pointData[pdIndexes[0]];
		pdValues[1] = pointData[pdIndexes[1]];
		pdValues[2] = pointData[pdIndexes[2]];
		pdValues[3] = pointData[pdIndexes[3]];

		//Looks like we have to make the tile
		for (int i=0; i < 4; ++i)
		{			
			if (pdValues[i] > BaseTileSet) //if it's < the other tile gets the accessories and if it's = we don't get any accessories either
			{
				int accessoryType = (int)pow(2, (double)i);
				for (int j=i+1; j < 4; ++j)
				{
					if (pdValues[i] == pdValues[j])
					{
						accessoryType += (int)pow(2, (double)j);
						pdValues[j] = BaseTileSet;
					}
				}

				blit(tiles[pdValues[i]]->getTiles(), scratch, (int)(accessoryType%4) * tileWidth, (int)(accessoryType/4) * tileHeight, 0, 0, tileWidth, tileHeight);
				draw_trans_sprite(tile, scratch, 0, 0);
			}
		}
		destroy_bitmap(scratch);
		tileImageCache[key] = tile;
	}

	return tile;
}


short AdvancedTileScroller::CalcTileBaseType(int TileX, int TileY)
{
	int pdIndexes[4];
	pdIndexes[0] = pdIndex(TileX, TileY);
	pdIndexes[1] = pdIndex(TileX, TileY + 1);
	pdIndexes[2] = pdIndex(TileX + 1, TileY + 1);
	pdIndexes[3] = pdIndex(TileX + 1, TileY);

	int smallest = 0;
	for (int i=0; i < 4; ++i)
	{
		if (pointData[pdIndexes[smallest]] > pointData[pdIndexes[i]])
		{
			smallest = i;
		}
	}
	
	return (pointData[pdIndexes[smallest]] < (int)tiles.size()) ? pointData[pdIndexes[smallest]] : (int)tiles.size() - 1;
}

BITMAP *AdvancedTileScroller::FindTile(int key)
{
	cacheIt = tileImageCache.find(key);

	if (cacheIt != tileImageCache.end())
	{
		return cacheIt->second;
	}

	return NULL;
}



int AdvancedTileScroller::CreateScrollBuffer(int Width, int Height)
{
	windowWidth = Width;
	windowHeight = Height;
	if (scrollbuffer != NULL) 
		delete scrollbuffer;
	scrollbuffer = create_bitmap(Width + (tileWidth * 2), Height + (tileHeight * 2));
	return (scrollbuffer != NULL);
}

/**
 * Fills the scroll buffer with tiles based on current scrollX, scrollY
**/
void AdvancedTileScroller::UpdateScrollBuffer()
{
	//prevent a crash
	if ( (!scrollbuffer) ) return;
	if (tileWidth < 1 || tileHeight < 1) return;

	clear_to_color(scrollbuffer, BLUE);
	//calculate starting tile position
	int tilex = (int)scrollX / tileWidth;
	int tiley = (int)scrollY / tileHeight;

	//calculate the number of columns and rows
	int cols = windowWidth / tileWidth;
	int rows = windowHeight / tileHeight;

	//draw tiles onto the scroll buffer surface
	for (int y=0; y <= rows && y + tiley < tilesDown; ++y) 
	{
		for (int x=0; x <= cols && x + tilex < tilesAcross; ++x)	
		{
			blit(tileData[tdIndex(tilex + x,tiley + y)], scrollbuffer, 0, 0, x * tileWidth, y * tileHeight, tileWidth, tileHeight);
			//if (pointData[pdIndex(tilex + x, tiley + y)] == 0)
			//{
			//	circlefill(scrollbuffer, x * tileWidth, y * tileHeight, 4, RED);
			//	rect(scrollbuffer, (x * tileWidth) - (tileWidth/2), (y * tileHeight) - (tileHeight/2),  (x * tileWidth) + (tileWidth/2), (y * tileHeight) + (tileHeight/2), RED);
			//}
			//else if (pointData[pdIndex(tilex + x, tiley + y)] == 1)
			//	circlefill(scrollbuffer, x * tileWidth, y * tileHeight, 4, BLACK);
			//else if (pointData[pdIndex(tilex + x, tiley + y)] == 2)
			//	circlefill(scrollbuffer, x * tileWidth, y * tileHeight, 4, BLUE);
		}
	}
}

/**
 * Draws the portion of the scroll buffer based on the current partial tile scroll position.
**/ 
void AdvancedTileScroller::DrawScrollWindow(BITMAP *Dest, int X, int Y, int Width, int Height)
{
	//prevent a crash
	if (tileWidth < 1 || tileHeight < 1) return;
	
    //calculate the partial sub-tile lines to draw using modulus
    int partialx = (int)scrollX % tileWidth;
    int partialy = (int)scrollY % tileHeight;
    
	//draw the scroll buffer to the destination bitmap
    if (scrollbuffer)
	    blit(scrollbuffer, Dest, partialx, partialy, X, Y, Width, Height);
}


bool AdvancedTileScroller::CheckCollisionbyCoords(int X, int Y, bool Flying)
{
	bool result = false;

	ConvertCoordstoNearestPoint(X, Y);

	if (Flying)
		result = tiles[getPointData( X , Y )]->IsAirNavigatable();
	else
		result = tiles[getPointData( X , Y )]->IsGroundNavigatable();

	return !result;
}

void AdvancedTileScroller::ConvertCoordstoNearestPoint(int &X, int &Y)
{
	double x, y = 0;

	x = (double)X/tileWidth; y = (double)Y/tileHeight;

	if (  x - floor(x) < .5) 
		X = (int)floor(x); 
	else 
		X = (int)ceil(x);

	if ( y - floor(y) < .5) 
		Y = (int)floor(y); 
	else 
		Y = (int)ceil(y);

}
