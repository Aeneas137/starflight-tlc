
#include "PlanetSurfaceObject.h"
#include "ModulePlanetSurface.h"
#include "Sprite.h"
#include "Game.h"
#include "GameState.h"
#include "Events.h"
#include "Util.h"
using namespace std;

int PlanetSurfaceObject::maxX, PlanetSurfaceObject::minX, PlanetSurfaceObject::maxY, PlanetSurfaceObject::minY = 0;
std::map<std::string, BITMAP*> PlanetSurfaceObject::graphics;

PlanetSurfaceObject::PlanetSurfaceObject() :
	image(NULL),
	itemType(IT_INVALID),
	name(""),
	value(0.0),
	size(0.0),
	danger(0.0),
	damage(0.0),
	stunCount(0),
	health(0),
	itemAge(IA_INVALID),
	shipRepairMetal(false),
	blackMarketItem(false),
	UseAlpha(false),
	alive(1),
	scanned(false),
	selected(false),
	direction(0),
	animColumns(1),
	animStartX(0),
	animStartY(0),
	state(0),
	objectType(0),
	x(0.0f),
	y(0.0f),
	width(0),
	height(0),
	colHalfWidth(0),
	colHalfHeight(0),
	frameWidth(0),
	frameHeight(0),
	scale(1),
	delayX(0),
	delayY(0),
	countX(0),
	countY(0),
	velX(0.0),
	velY(0.0),
	speed(0.0),
	currFrame(0),
	totalFrames(1),
	frameCount(0),
	frameDelay(10),
	animDir(1),
	faceAngle(0),
	moveAngle(0),
	angleOffset(0),
	counter1(0),
	counter2(0),
	counter3(0),
	threshold1(0),
	threshold2(0),
	threshold3(0),
	minimapColor(BRTORANGE),
	minimapSize(1)
{
	defaultAnim = new Animation(0, 1, 0);
	activeAnim = defaultAnim;
}

PlanetSurfaceObject::PlanetSurfaceObject(lua_State* LuaVM, std::string ScriptName) :
	scriptName(ScriptName),
	luaVM(LuaVM),
	itemType(IT_INVALID),
	id(0),
	name(""),
	value(0.0),
	size(0.0),
	danger(0.0),
	damage(0.0),
	stunCount(0),
	health(0),
	itemAge(IA_INVALID),
	shipRepairMetal(false),
	blackMarketItem(false),
	image(NULL),
	selected(false),
	UseAlpha(false),
	alive(1),
	scanned(false),
	direction(0),
	animColumns(1),
	animStartX(0),
	animStartY(0),
	state(0),
	objectType(0),
	x(0.0f),
	y(0.0f),
	width(0),
	height(0),
	colHalfWidth(0),
	colHalfHeight(0),
	frameWidth(0),
	frameHeight(0),
	scale(1),
	delayX(0),
	delayY(0),
	countX(0),
	countY(0),
	velX(0.0),
	velY(0.0),
	speed(0.0),
	currFrame(0),
	totalFrames(1),
	frameCount(0),
	frameDelay(10),
	animDir(1),
	faceAngle(0),
	moveAngle(0),
	angleOffset(0),
	counter1(0),
	counter2(0),
	counter3(0),
	threshold1(0),
	threshold2(0),
	threshold3(0),
	minimapColor(BRTORANGE),
	minimapSize(1)
{
	defaultAnim = new Animation(0, 1, 0);
	activeAnim = defaultAnim;
}

PlanetSurfaceObject::~PlanetSurfaceObject()
{
	//We only need to delete the defaultAnim, not the activeAnim
	if (defaultAnim != NULL)
	{
		delete defaultAnim;
		defaultAnim = NULL;
	}

	//the static graphics map will clean up all the graphics
	for (animationsIt = regAnimations.begin(); animationsIt != regAnimations.end(); ++animationsIt)
	{
		delete animationsIt->second;
		animationsIt->second = NULL;
	}
	regAnimations.clear();
}

void PlanetSurfaceObject::setX(double initX)
{ 
	if (initX < minX)
	{
		x = minX;
	}
	else if (initX > maxX)
	{
		x = maxX;
	}
	else
	{
		x = initX;
	}
}
void PlanetSurfaceObject::setY(double initY)
{
	if (initY < minY)
	{
		y = minY;
	}
	else if (initY > maxY)
	{
		y = maxY;
	}
	else
	{
		y = initY;
	}
}
void PlanetSurfaceObject::setXOffset(double initXOffset)				{ setX(initXOffset - (frameWidth * scale)/2); }
void PlanetSurfaceObject::setYOffset(double initYOffset)				{ setY(initYOffset - (frameHeight * scale)/2); }
void PlanetSurfaceObject::setPos(double initX, double initY)			{ setX(initX); setY(initY); }
void PlanetSurfaceObject::setPosOffset(double initX, double initY)		{ setX(initX - (frameWidth * scale)/2); setY(initY - (frameHeight * scale)/2); }

void PlanetSurfaceObject::Initialize()
{
	g_game->PlanetSurfaceHolder->psObjectHolder = this;

	/* the function name */
	string fname = this->GetScriptName();
	fname += "Initialize";
	lua_getglobal(luaVM, fname.c_str());

	// call the function 
	lua_call(luaVM, 0, 0);
}

int PlanetSurfaceObject::load(const char *filename) 
{
	std::map<std::string, BITMAP*>::iterator it = graphics.find(filename);

	if (it == graphics.end())
	{
		this->image = load_bitmap(filename, NULL);
		if (!this->image) {
			std::string msg = "Error loading sprite file ";
			msg += filename; 
			g_game->message(msg);
			return 0;
		}
		graphics[filename] = image;
	}
	else
	{
		this->image = it->second;
	}

	this->width = image->w;
	this->height = image->h;
	
	//default frame size equals whole image size unless manually changed
	this->frameWidth = this->width;
	this->frameHeight = this->height;

	this->colHalfWidth = this->width/2;
	this->colHalfHeight = this->height/2;

	set_alpha_blender();
    return 1;
}


void PlanetSurfaceObject::Move()
{
	moved = false;
    //update x position
    if (++countX > delayX)  {
        countX = 0;
        setX(x + speed * velX);
		if (speed != 0 && velX != 0)
			moved = true;
    }

    //update y position
    if (++countY > delayY)  {
        countY = 0;
        setY(y + speed * velY);
		if (speed != 0 && velY != 0)
			moved = true;
    }

	if (moved)
		g_game->PlanetSurfaceHolder->CheckForCollisions(this);
}

void PlanetSurfaceObject::Animate() 
{
    //update frame based on animdir
    if (++frameCount > activeAnim->GetDelay())  
	{
        frameCount = 0;
		currFrame += 1;

		if (currFrame < activeAnim->GetStartFrame()) 
		{
            currFrame = activeAnim->GetEndFrame();
		}

		if (currFrame > activeAnim->GetEndFrame()) 
		{
            currFrame = activeAnim->GetStartFrame();
        }
    }
}

void PlanetSurfaceObject::Update()
{
	g_game->PlanetSurfaceHolder->psObjectHolder = this;
	/* the function name */
	lua_getglobal(luaVM, (this->GetScriptName().append("Update")).c_str());

	// call the function 
	lua_call(luaVM, 0, 0);
}

void PlanetSurfaceObject::TimedUpdate()
{
	g_game->PlanetSurfaceHolder->psObjectHolder = this;
	/* the function name */
	lua_getglobal(luaVM, (this->GetScriptName().append("TimedUpdate")).c_str());

	// call the function 
	lua_call(luaVM, 0, 0);
}


void PlanetSurfaceObject::Draw()
{
	if (selected)
		ellipse(g_game->GetBackBuffer(), (int)(getXOffset() - g_game->gameState->player->posPlanet.x), (int)(getYOffset() - g_game->gameState->player->posPlanet.y), (int)(width * scale)/2, (int)(height * scale)/2, GREEN);

	Draw(g_game->GetBackBuffer());
	//rect(g_game->GetBackBuffer(), getXOffset() - g_game->gameState->player->posPlanet.x - getColHalfWidth(), getYOffset() - g_game->gameState->player->posPlanet.y  - getColHalfHeight(), getXOffset() - g_game->gameState->player->posPlanet.x + getColHalfWidth(), getYOffset() - g_game->gameState->player->posPlanet.y + getColHalfHeight(), RED);

}

void PlanetSurfaceObject::Draw(BITMAP *dest)
{
	if (!image) return;
	
	float angle = faceAngle + angleOffset;
	bool scaled = (scale != 1);
	bool rotated = (angle != 0);

	BITMAP *scrapFrame = NULL;
	BITMAP *finalFrame = NULL;


	int fx = animStartX + (currFrame % animColumns) * frameWidth;
	int fy = animStartY + (currFrame / animColumns) * frameHeight;

	if (!scaled && !rotated && !UseAlpha)
	{
		//draw normally
		masked_blit(image, dest, fx, fy, (int)(x - g_game->gameState->player->posPlanet.x), (int)(y - g_game->gameState->player->posPlanet.y), frameWidth, frameHeight);
		return;
	}
	else if (!scaled && !rotated && UseAlpha)
	{
		scrapFrame = create_bitmap(frameWidth, frameHeight);

		blit(image, scrapFrame, fx, fy, 0, 0, frameWidth, frameHeight);
		draw_trans_sprite(dest, scrapFrame, (int)(x - g_game->gameState->player->posPlanet.x), (int)(y  - g_game->gameState->player->posPlanet.y));
		
		destroy_bitmap(scrapFrame);
		return;
	}
	else if (scaled && rotated && !UseAlpha)
	{
		//scrapFrame = create_bitmap(frameWidth, frameHeight);
		
		finalFrame = create_bitmap((int)(frameWidth * scale), (int)(frameHeight * scale));

		stretch_blit(image, finalFrame, fx, fy, frameWidth, frameHeight, 0, 0, (int)(frameWidth * scale), (int)(frameHeight * scale));
		//masked_stretch_blit(image, finalFrame, fx, fy, frameWidth, frameHeight, 0, 0, frameWidth * scale, frameHeight * scale);


		//draw rotated image in scale frame onto rotate frame 
		//adjust for Allegro's 16.16 fixed trig (256 / 360 = 0.7) then divide by 2 radians
		//rotate_sprite(finalFrame, scrapFrame, (int)x, (int)y, itofix((int)(angle / 0.7f / 2.0f)));

		rotate_sprite(dest, finalFrame, (int)(x - g_game->gameState->player->posPlanet.x), (int)(y - g_game->gameState->player->posPlanet.y), itofix((int)(angle / 0.7f / 2.0f)));


		destroy_bitmap(finalFrame);
		//destroy_bitmap(scrapFrame);

		return;
	}
	else if (scaled && !rotated)
	{
		finalFrame = create_bitmap((int)(frameWidth * scale), (int)(frameHeight * scale));
		
		//Scale paste
		stretch_blit(image, finalFrame, fx, fy, frameWidth, frameHeight, 0, 0, (int)(frameWidth * scale), (int)(frameHeight * scale));
	}
	else if (!scaled && rotated && !UseAlpha)
	{
		scrapFrame = create_bitmap(frameWidth, frameHeight);

		blit(image, scrapFrame, fx, fy, 0, 0, frameWidth, frameHeight);

		//adjust for Allegro's 16.16 fixed trig (256 / 360 = 0.7) then divide by 2 radians
		//rotate_sprite(finalFrame, scrapFrame, 0, 0, itofix((int)(angle / 0.7f / 2.0f)));
		rotate_sprite(dest, scrapFrame, (int)(x - g_game->gameState->player->posPlanet.x), (int)(y - g_game->gameState->player->posPlanet.y), itofix((int)(angle / 0.7f / 2.0f)));

		destroy_bitmap(scrapFrame);

		return;
	}
	else if (!scaled && rotated && UseAlpha)
	{
		scrapFrame = create_bitmap(frameWidth, frameHeight);

		if (frameWidth < frameHeight)
		{
			finalFrame = create_bitmap(frameHeight, frameHeight);
		}
		else
		{
			finalFrame = create_bitmap(frameWidth, frameWidth);
		}
		

		blit(image, scrapFrame, fx, fy, 0, 0, frameWidth, frameHeight);
		clear_bitmap(finalFrame);

		//adjust for Allegro's 16.16 fixed trig (256 / 360 = 0.7) then divide by 2 radians
		rotate_sprite(finalFrame, scrapFrame, 0, 0, itofix((int)(angle / 0.7f / 2.0f)));
		//rotate_sprite(dest, scrapFrame, (int)x - g_game->gameState->player->posPlanet.x, (int)y - g_game->gameState->player->posPlanet.y, itofix((int)(angle / 0.7f / 2.0f)));

		destroy_bitmap(scrapFrame);
	}

	if (!UseAlpha)
	{
		//draw normally
		masked_blit(finalFrame, dest, 0, 0, (int)(x - g_game->gameState->player->posPlanet.x), (int)(y - g_game->gameState->player->posPlanet.y), (int)(frameWidth * scale), (int)(frameHeight * scale));
	}
	else
	{
		draw_trans_sprite(dest, finalFrame, (int)(x - g_game->gameState->player->posPlanet.x), (int)(y - g_game->gameState->player->posPlanet.y));
	}

	destroy_bitmap(finalFrame);
}

bool PlanetSurfaceObject::CheckCollision(PlanetSurfaceObject * otherPSO)
{
	//Use the "gets" so the scale of the object is taken into consideration
	double psoHalfWidth = getColHalfWidth();
	double otherPSOHalfWidth = otherPSO->getColHalfWidth();

	//Offsets are the origin of the object, with scale calculated in
	double xDistance = abs((int)(otherPSO->getXOffset() - this->getXOffset()));

    //the purpose of the projection code is to cause a collided object to slide around it's collision circle
	if ( psoHalfWidth + otherPSOHalfWidth > xDistance )
	{
		//Then we have a X axis collision, but we need both a x and a y collision for there to be an actual collision ;)
		double psoHalfHeight = getColHalfHeight();
		double otherPSOHalfHeight = otherPSO->getColHalfHeight();

		double yDistance = abs((int)(otherPSO->getYOffset() - this->getYOffset()));

		if ( psoHalfHeight + otherPSOHalfHeight > yDistance )
		{
			double adjustment = 0;
			int axis = 0;

			//yeah! we have a collision, but now we need to find our projection vector
			if (psoHalfWidth + otherPSOHalfWidth - xDistance < psoHalfHeight + otherPSOHalfHeight - yDistance)
			{
				//we have a projection vector on the x axis
				adjustment = psoHalfWidth + otherPSOHalfWidth - xDistance;
				axis = 0;
			}
			else
			{
				//we have a projection vector on the y axis
				adjustment = psoHalfHeight + otherPSOHalfHeight - yDistance;
				axis = 1;
			}

			g_game->PlanetSurfaceHolder->psObjectHolder = this;

			lua_pushnumber(luaVM, adjustment);
			lua_setglobal(luaVM, "adjustment");

			lua_pushnumber(luaVM, otherPSO->getXOffset());
			lua_setglobal(luaVM, "otherPSOx");

			lua_pushnumber(luaVM, otherPSO->getYOffset());
			lua_setglobal(luaVM, "otherPSOy");
			
            //find the item in the planet surface objects list
			int id = -1;
			for (int i=0; i < (int) g_game->PlanetSurfaceHolder->surfaceObjects.size(); ++i)
			{
				if (otherPSO == g_game->PlanetSurfaceHolder->surfaceObjects[i])
				{
					id = i;
					break;
				}
			}

			lua_pushnumber( luaVM, id);
			lua_setglobal(luaVM, "otherPSOid");
		
			lua_pushnumber( luaVM, otherPSO->getObjectType());
			lua_setglobal(luaVM, "otherPSOtype");

			lua_pushnumber(luaVM, axis);
			lua_setglobal(luaVM, "axis");

			/* the function name */
			lua_getglobal(luaVM, (this->GetScriptName().append("CollisionOccurred")).c_str());

			// call the function 
			lua_call(luaVM, 0, 0);

			return true;
		}
	}
	return false;
}


bool PlanetSurfaceObject::CheckCollision(int x, int y, int width, int height)
{
	//Use the "gets" so the scale of the object is taken into consideration
	double psoHalfWidth = getColHalfWidth();
	double recHalfWidth = width/2;

	//Offsets are the origin of the object, with scale calculated in
	double xDistance = abs( (int)(x + recHalfWidth - this->getXOffset()));

	if ( psoHalfWidth + recHalfWidth > xDistance )
	{
		//Then we have a X axis collision, but we need both a x and a y collision for there to be an actual collision ;)
		double psoHalfHeight = getColHalfHeight();
		double recHalfHeight = height/2;

		double yDistance = abs((int)(y + recHalfHeight - this->getYOffset()));

		if ( psoHalfHeight + recHalfHeight > yDistance )
		{
			double adjustment = 0;
			int axis = 0;

			//yeah! we have a collision, but now we need to find our projection vector
			if (psoHalfWidth + recHalfWidth - xDistance < psoHalfHeight + recHalfHeight - yDistance)
			{
				//we have a projection vector on the x axis
				adjustment = psoHalfWidth + recHalfWidth - xDistance;
				axis = 0;
			}
			else
			{
				//we have a projection vector on the y axis
				adjustment = psoHalfHeight + recHalfHeight - yDistance;
				axis = 1;
			}

			g_game->PlanetSurfaceHolder->psObjectHolder = this;

			lua_pushnumber(luaVM, adjustment);
			lua_setglobal(luaVM, "adjustment");

			lua_pushnumber(luaVM, x);
			lua_setglobal(luaVM, "otherPSOx");

			lua_pushnumber(luaVM, y);
			lua_setglobal(luaVM, "otherPSOy");

			lua_pushnumber( luaVM, -1);
			lua_setglobal(luaVM, "otherPSOid");
		
			lua_pushnumber( luaVM, -14);
			lua_setglobal(luaVM, "otherPSOtype");

			lua_pushnumber(luaVM, axis);
			lua_setglobal(luaVM, "axis");

			/* the function name */
			lua_getglobal(luaVM, (this->GetScriptName().append("CollisionOccurred")).c_str());

			// call the function 
			lua_call(luaVM, 0, 0);

			return true;
		}
	}
	return false;
}


void PlanetSurfaceObject::AddAnimation(std::string name, int startFrame, int endFrame, int delay)
{
	regAnimations[name] = new Animation(startFrame, endFrame, delay);
}

void PlanetSurfaceObject::SetActiveAnimation(std::string name)
{
	animationsIt = regAnimations.find(name);
	if (animationsIt != regAnimations.end())
		activeAnim = animationsIt->second;
}

void PlanetSurfaceObject::OnMouseMove(int x, int y)
{

}

bool PlanetSurfaceObject::OnMouseReleased(int button, int x, int y)
{
	if (button == 0)
	{
		if (PointInside(x,y))
		{
			if (g_game->PlanetSurfaceHolder->selectedPSO != NULL)
			{
				g_game->PlanetSurfaceHolder->selectedPSO->setSelected(false);
			}
			g_game->PlanetSurfaceHolder->selectedPSO = this;
			this->getActions();
			selected = true;
		}
		else 
		{
			if (selected)
			{
				g_game->PlanetSurfaceHolder->selectedPSO = NULL;
				g_game->PlanetSurfaceHolder->activeButtons = 0;
			}
			selected = false;
		}
	}

	return selected;
}

void PlanetSurfaceObject::getActions()
{
	g_game->PlanetSurfaceHolder->psObjectHolder = this;

	/* the function name */
	lua_getglobal(luaVM, (this->GetScriptName().append("GetActions")).c_str());

	// call the function 
	lua_call(luaVM, 0, 0);
}

void PlanetSurfaceObject::OnEvent(int event)
{
	g_game->PlanetSurfaceHolder->psObjectHolder = this;

	lua_pushnumber(luaVM, event);
	lua_setglobal(luaVM, "event");

	/* the function name */
	lua_getglobal(luaVM, (this->GetScriptName().append("OnEvent")).c_str());

	// call the function 
	lua_call(luaVM, 0, 0);
}


void PlanetSurfaceObject::Scan()
{
	g_game->PlanetSurfaceHolder->psObjectHolder = this;

	/* the function name */
	lua_getglobal(luaVM, (this->GetScriptName().append("Scan")).c_str());

	// call the function 
	lua_call(luaVM, 0, 0);
}


int PlanetSurfaceObject::Inside(int x,int y,int left,int top,int right,int bottom)
{
    if (x > left && x < right && y > top && y < bottom)
        return 1;
    else
        return 0;
}

int PlanetSurfaceObject::PointInside(int px,int py)
{
	return Inside(px, py, (int)x, (int)y, (int)(x+(width * scale)), (int)(y+(height * scale)));
}

void PlanetSurfaceObject::EmptyGraphics()
{
	std::map<std::string, BITMAP*>::iterator it;

	for (it = graphics.begin(); it != graphics.end(); ++it)
	{
		destroy_bitmap(it->second);
		it->second = NULL;
	}
	graphics.clear();
}
