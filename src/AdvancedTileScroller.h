#ifndef ADVANCEDTILESCROLLER_H
#define ADVANCEDTILESCROLLER_H

#include "env.h"
#include <map>
#include <math.h>

class Point2D;
struct BITMAP;

#define pdIndex(col, row) ( ((row) * (tilesAcross + 1)) + (col) )
#define tdIndex(col, row) ( ((row) * tilesAcross) + (col) )

struct TileSet
{
public:
	bool groundNavigation;
	bool airNavigation;
	int variations;
	BITMAP *tiles;

	TileSet(BITMAP *Tiles, int Variations, bool GroundNavigation = true, bool AirNavigation = true): 
		tiles(Tiles), 
		variations(Variations),
		groundNavigation(GroundNavigation), 
		airNavigation(AirNavigation)
	{
	}

	~TileSet()
	{
		//memory is freed by AdvancedTileScroller
		//destroy_bitmap(tiles);
		//tiles = NULL;
	}

	bool IsGroundNavigatable()	{ return groundNavigation; }
	bool IsAirNavigatable()		{ return airNavigation; }
	BITMAP *getTiles()			{ return tiles; }
	int getVariations()			{ return variations; }
};


class AdvancedTileScroller 
{
private:
   BITMAP *scrollbuffer;
   std::vector<TileSet *> tiles;

   std::map<int, BITMAP *> tileImageCache;
   std::map<int, BITMAP *>::iterator cacheIt;

   BITMAP **tileData;
   short *pointData;

   int tileWidth, tileHeight, numofTypes, baseVariations;
   int tilesAcross, tilesDown;
   float scrollX, scrollY;
   int windowWidth,windowHeight;
	bool loadedFromDataFile;

   BITMAP *GenerateTile(int BaseTileSet, int TileX, int TileY);
   short CalcTileBaseType(int TileX, int TileY);
   BITMAP *FindTile(int key);

public:
   AdvancedTileScroller(int TilesAcross, int TilesDown, int TileWidth, int TileHeight);
   ~AdvancedTileScroller();

   void Destroy();
   int CreateScrollBuffer(int Width,int Height);
   bool LoadTileSet(char *FileName, int Variations, bool GroundNavigation = true, bool AirNavigation = true);
   bool LoadTileSet(BITMAP *tileImage, int Variations, bool GroundNavigation = true, bool AirNavigation = true);
   bool GenerateTiles();

   void ResetTiles();
   void ResetPointData();
   void ClearTileImageCache();
   void PurgePrimaryImages();
   void UpdateScrollBuffer();
   void DrawScrollWindow(BITMAP *Dest, int X, int Y, int Width, int Height);
   bool CheckCollisionbyCoords(int X, int Y, bool Flying = false);
   void ConvertCoordstoNearestPoint(int &X, int &Y); 


   //Accessors
   int getNumofTileSets()								const { return (int)tiles.size(); }
   int getNumofTileSetVariations(int index)				const { return tiles[index]->getVariations(); }
   int getTileWidth()									const { return tileWidth; }
   int getTileHeight()									const { return tileHeight; }
   int getTilesAcross()									const { return tilesAcross; }
   int getTilesDown()									const { return tilesDown; }
   int getWindowWidth()									const { return windowWidth; }
   int getWindowHeight()								const { return windowHeight; }
   short getPointData(int Column, int Row)				const { return pointData[pdIndex(Column, Row)]; }
   TileSet *getTileSet(int index)						const { return tiles[index]; }
   float getScrollX()									const { return scrollX; }
   float getScrollY()									const { return scrollY; }

   //Mutators
   void setTileSize(int Width,int Height)				{ tileWidth = Width; tileHeight = Height; }
   void setTileWidth(int Width)							{ tileWidth = Width; }
   void setTileHeight(int Height)						{ tileHeight = Height; }
   void setWindowSize(int Width, int Height)			{ windowWidth = Width; windowHeight = Height; }
   void setScrollPosition(float X, float Y)				{ scrollX = X; scrollY = Y; }
   void setTileImage(BITMAP *image, int Column, int Row){ tileData[tdIndex(Column, Row)] = image; }
   void setPointData(int Column, int Row, short Value)	{ pointData[pdIndex(Column, Row)] = Value; }
   void setScrollX(int X)								{ scrollX = X; }
   void setScrollY(int Y)								{ scrollY = Y; }
   void setRegionSize(int Width, int Height)			{ (Width >= 0 && Width <= 2500) ? (tilesAcross = Width) : tilesAcross = tilesAcross; 
														  (Height >= 0 && Height <= 2500) ? (tilesDown = Height) : tilesDown = tilesDown; }

};


#endif

