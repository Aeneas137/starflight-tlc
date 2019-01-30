/*
	STARFLIGHT - THE LOST COLONY
	module.cpp - ?
	Author: ?
	Date: ?
*/

#include "env.h"
#include <allegro.h>

#include "Module.h"
#include "Game.h"
#include "GameState.h"

using namespace std;

int Module::m_totalNumModules = 0;
int Module::m_numModulesInitialized = 0;

Module::Module() : m_x(0), m_y(0), _functional(true) {}

Module::~Module()
{
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		  delete *i;
	}
}

void Module::AddChildModule(Module *m)
{
	++m_totalNumModules;
	m_modules.push_back(m);
}

//void Module::BlitToParent(BITMAP *parent)
//void Module::Draw(BITMAP *target)
//{
//	if (m_canvas == NULL)
//		return;
//
//	vector<Module*>::iterator i;
//	for (i = m_modules.begin(); i != m_modules.end(); ++i)
//	{
//		if ((*i)->IsFunctional())  //jh
//			//(*i)->BlitToParent(m_canvas);
//			(*i)->Draw(target);
//	}
//
//	//draw canvas onto the back buffer
//	if (IsTransparent())
//		masked_blit(m_canvas,target,0,0,m_x,m_y,m_canvas->w,m_canvas->h);
//	else
//		blit(m_canvas,target,0,0,m_x,m_y,m_canvas->w,m_canvas->h);
//}

// by default this function creates a canvas the size of the whole screen
// when overridden by sub-classes, the canvas size can be changed
//bool Module::InitCanvas(int x, int y, int w, int h)
//{
//	m_x = x;
//	m_y = y;
//	
//	if (m_canvas != NULL)
//		destroy_bitmap(m_canvas);
//
//	m_canvas = create_bitmap(w,h);
//
//	clear_to_color(m_canvas, makecol(0,0,0));
//
//	return (m_canvas != NULL);
//}

bool Module::Init()
{
	bool result = true;

	vector<Module *>::iterator i;
	for (i = m_modules.begin(); (i != m_modules.end()) && result; ++i)
	{
		 result = (*i)->Init();
	}

	return result;
}

void Module::Close()
{
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		(*i)->Close();
	}
}

void Module::Update()
{
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		(*i)->Update();
	}
}

void Module::Draw()
{
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		if (*i)
			(*i)->Draw();
	}
}


// added JH 01-Feb-07
void Module::OnKeyPress(int keyCode)
{
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		(*i)->OnKeyPress(keyCode);
	}
}

void Module::OnKeyPressed(int keyCode)
{
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		(*i)->OnKeyPressed(keyCode);
	}
}

void Module::OnKeyReleased(int keyCode)
{
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		(*i)->OnKeyReleased(keyCode);
	}
}

void Module::OnMouseMove(int x, int y)
{
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		(*i)->OnMouseMove(x - (*i)->m_x,y - (*i)->m_y);
	}
}

void Module::OnMouseClick(int button, int x, int y)
{
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		(*i)->OnMouseClick(button,x - (*i)->m_x,y - (*i)->m_y);
	}
}

void Module::OnMousePressed(int button, int x, int y)
{
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		(*i)->OnMousePressed(button,x - (*i)->m_x,y - (*i)->m_y);
	}
}

void Module::OnMouseReleased(int button, int x, int y)
{
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		(*i)->OnMouseReleased(button,x - (*i)->m_x,y - (*i)->m_y);
	}
}

void Module::OnMouseWheelUp(int x, int y)
{
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		(*i)->OnMouseWheelUp(x - (*i)->m_x,y - (*i)->m_y);
	}
}

void Module::OnMouseWheelDown(int x, int y)
{
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		(*i)->OnMouseWheelDown(x - (*i)->m_x,y - (*i)->m_y);
	}
}
void Module::OnEvent(Event *event)
{	
	vector<Module *>::iterator i;
	for (i = m_modules.begin(); i != m_modules.end(); ++i)
	{
		(*i)->OnEvent(event);
	}
}


