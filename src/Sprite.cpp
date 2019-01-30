/*
 * GENERIC ALL-PURPOSE SPRITE CLASS
 *
 * Author: Jonathan Harbour
 * Date: Early 21st century
 *
 * If you don't like this class, make your own, but don't screw with this one.
 *
 */

#include "env.h"
#include <allegro.h>
#include <sstream>
#include "Game.h"
#include "Sprite.h"

#define PI 3.1415926535
#define PI_div_180 0.017453292519444

Sprite::Sprite()
{
	image = NULL;
	frame = NULL;
	alive = true;
	direction = 0;
	animColumns = 1;
	animStartX = 0;
	animStartY = 0;
	x = 0.0;
	y = 0.0;
	width = 0;
	height = 0;
	delayX = 0;
	delayY = 0;
	countX = 0;
	countY = 0;
	velX = 0.0;
	velY = 0.0;
	speed = 0.0;
	currFrame = 0;
	totalFrames = 1;
	frameCount = 0;
	frameDelay = 0;
	frameWidth = 0;
	frameHeight = 0;
	animDir = 1;
	faceAngle = 0.0f;
	moveAngle = 0.0f;
	counter1 = 0;
	counter2 = 0;
	counter3 = 0;
	threshold1 = 0;
	threshold2 = 0;
	threshold3 = 0;
	bLoaded = false;
	DebugMode = false;
}

Sprite::~Sprite()  
{
	//prevent destroying bitmap if it was passed as a pointer rather than loaded
	if (bLoaded) {
		if (this->image != NULL) {
			destroy_bitmap(this->image);
			this->image = NULL;
		}
	}
			
	if (this->frame != NULL) {
        destroy_bitmap(this->frame);
        this->frame = NULL;
    }
}

bool Sprite::load(const char *filename) {
	this->image = load_bitmap(filename, NULL);
	if (!this->image) 
	{
		std::ostringstream s;
		s << "Error loading sprite file: " << filename;
		g_game->message(s.str().c_str());
		return false;
	}
	this->width = image->w;
	this->height = image->h;
	this->bLoaded = true;
	
	//default frame size equals whole image size unless manually changed
	this->frameWidth = this->width;
	this->frameHeight = this->height;
	
	set_alpha_blender();
    return true;
}

bool Sprite::load(std::string filename) {
    return load(filename.c_str());
}

BITMAP *Sprite::getImage()
{
	if (this->image)
		return this->image;
	else
		return NULL;
}
bool Sprite::setImage(BITMAP *source)
{
	//if new source image is null, then abort
	if (!source) return false;
	
	//if old image exists, it must be freed first
	if (this->image && bLoaded) {
		destroy_bitmap(this->image);
		this->image = NULL;
	}
	
	this->image = source;
	this->width = source->w;
	this->height = source->h;
	this->frameWidth = source->w;
	this->frameHeight = source->h;
	this->bLoaded = false;
	
	set_alpha_blender();

	return true;
}


void Sprite::draw(BITMAP *dest) {
    if (this->image)
	    draw_trans_sprite(dest, this->image, (int)this->x, (int)this->y);
}

//draw normally with optional alpha channel support
void Sprite::drawframe(BITMAP *dest, bool UseAlpha)  {
    if (!image) return;

	int fx = animStartX + (currFrame % animColumns) * frameWidth;
	int fy = animStartY + (currFrame / animColumns) * frameHeight;

	if (!UseAlpha) {
		//draw normally
		masked_blit(this->image, dest, fx, fy, (int)x, (int)y, frameWidth, frameHeight);
	} 
	else {
		//paste frame onto scratch image using alpha channel
		BITMAP *temp = create_bitmap(frameWidth, frameHeight);
		masked_blit(image, temp, fx, fy, 0, 0, frameWidth, frameHeight);
		draw_trans_sprite(dest, temp, (int)x, (int)y);
		destroy_bitmap(temp);
	}
	
	if (DebugMode) {
		rect(dest, (int)x, (int)y, (int)x + frameWidth, (int)y + frameHeight, BLUE);
	}
}


//draw with scaling
void Sprite::drawframe_scale(BITMAP *dest, int dest_w, int dest_h)  {
    if (!image) return;

    int fx = animStartX + (currFrame % animColumns) * frameWidth;
    int fy = animStartY + (currFrame / animColumns) * frameHeight;
    masked_stretch_blit(image, dest, fx, fy, frameWidth, frameHeight, (int)x, (int)y, dest_w, dest_h);

	if (DebugMode) {
		rect(dest, (int)x, (int)y, (int)x + dest_w, (int)y + dest_h, BLUE);
	}
}


//draw with rotation
void Sprite::drawframe_rotate(BITMAP *dest, int angle)  {
    if (!image) return;

    //create scratch frame if necessary
    if (!frame) {
        frame = create_bitmap(frameWidth, frameHeight);
    }

    //first, draw frame normally but send it to the scratch frame image
    int fx = animStartX + (currFrame % animColumns) * frameWidth;
    int fy = animStartY + (currFrame / animColumns) * frameHeight;
    blit(image, frame, fx, fy, 0, 0, frameWidth, frameHeight);

    //draw rotated image in scratch frame onto dest 
    //adjust for Allegro's 16.16 fixed trig (256 / 360 = 0.7) then divide by 2 radians
    rotate_sprite(dest, frame, (int)x, (int)y, itofix((int)(angle / 0.7f / 2.0f)));

	if (DebugMode) {
		rect(dest, (int)x, (int)y, (int)x + frameWidth, (int)y + frameHeight, BLUE);
	}
}

void Sprite::move()
{
    //update x position
    if (++countX > delayX)  {
        countX = 0;
        x += velX;
    }

    //update y position
    if (++countY > delayY)  {
        countY = 0;
        y += velY;
    }
}

void Sprite::animate() 
{
	animate(0, totalFrames-1);
}

void Sprite::animate(int low, int high) 
{
    //update frame based on animdir
    if (++frameCount > frameDelay)  {
        frameCount = 0;
		currFrame += animDir;

		if (currFrame < low) {
            currFrame = high;
		}
		if (currFrame > high) {
            currFrame = low;
        }
    }
}

int Sprite::inside(int x,int y,int left,int top,int right,int bottom)
{
    if (x > left && x < right && y > top && y < bottom)
        return 1;
    else
        return 0;
}

int Sprite::pointInside(int px,int py)
{
	return inside(px, py, (int)x, (int)y, (int)x+width, (int)y+height);
}

/*
 * Bounding rectangle collision detection 
 */
bool Sprite::collided(Sprite *other)
{
	if (other == NULL) return false;

    int wa = (int)x + width;
    int ha = (int)y + height;
    int wb = (int)other->x + other->width;
    int hb = (int)other->y + other->height;

    if (inside((int)x, (int)y, (int)other->x, (int)other->y, wb, hb))	return true;
    if (inside((int)x, ha, (int)other->x, (int)other->y, wb, hb))		return true;
    if (inside(wa, (int)y, (int)other->x, (int)other->y, wb, hb))		return true;
    if (inside(wa, ha, (int)other->x, (int)other->y, wb, hb))			return true;
        
    return false;
}

/*
 * Distance based collision detection
 */
bool Sprite::collidedD(Sprite *other)
{
	if (other == NULL) return false;

	//calculate radius 1
	double radius1 = this->getFrameWidth() * 0.4;

	//point = center of sprite 1
	double x1 = this->getX() + this->getFrameWidth()/2;
	double y1 = this->getY() + this->getFrameHeight()/2;

	//calculate radius 2
	double radius2 = other->getFrameWidth() * 0.4;

	//point = center of sprite 2
	double x2 = other->getX() + other->getFrameWidth()/2;
	double y2 = other->getY() + other->getFrameHeight()/2;

	//calculate distance
    double deltaX = (x2-x1);
    double deltaY = (y2-y1);
    double dist = sqrt(deltaX*deltaX + deltaY*deltaY);

	//return distance comparison
	return (dist < radius1 + radius2);


}

double Sprite::calcAngleMoveX(int angle) {
   //calculate X movement value based on direction angle
    return (double) cos(angle * PI_div_180);
}

//calculate Y movement value based on direction angle
double Sprite::calcAngleMoveY(int angle) {
    return (double) sin(angle * PI_div_180);
}
