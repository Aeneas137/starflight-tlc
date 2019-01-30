#include <exception>
#include "env.h"
#include "DataMgr.h"
#include "ModuleSideViewer.h"
#include "events.h"
#include "Game.h"


/*
	This SideViewer class only has a single purpose--to serve the CargoWindow aka cargo hold.
	It should have been integrated into the cargowindow module but at this point it's not worth
	the effort to merge them.
*/


#define GUI_VIEWER_BMP                   0        /* BMP  */

DATAFILE *svdata;



ModuleSideViewer::ModuleSideViewer(int slideEventType)  
{
	SetSlideEventType(slideEventType);
}

ModuleSideViewer::~ModuleSideViewer()
{
}

bool ModuleSideViewer::Init()
{
	//load the datafile
	svdata = load_datafile("data/cargohold/sideviewer.dat");
	if (!svdata) {
		g_game->message("SideViewer: Error loading datafile");	
		return false;
	}


	img_viewer = (BITMAP*)svdata[GUI_VIEWER_BMP].dat;
	if (img_viewer == NULL) {
		g_game->message("CargoWindow: Error loading gui_viewer");
		return false;
    }

	m_x = (int)g_game->getGlobalNumber("GUI_VIEWER_LEFT");
	m_y = 10;
	gui_viewer_dir = (int)g_game->getGlobalNumber("GUI_VIEWER_SPEED");
	gui_viewer_sliding = false;

   return true;
}

void ModuleSideViewer::Update()
{
}

void ModuleSideViewer::Draw()
{

	static int gvl = (int)g_game->getGlobalNumber("GUI_VIEWER_LEFT");
	static int gvr = (int)g_game->getGlobalNumber("GUI_VIEWER_RIGHT");
	if (gui_viewer_sliding)
   {
		m_x += gui_viewer_dir;
		if (m_x <= gvl)
      {
         m_x = gvl;
         gui_viewer_sliding = false;
      }
      else if (m_x >= gvr)
      {
         m_x = gvr;
			gui_viewer_sliding = false;
      }
	}

	if (img_viewer)
		masked_blit(img_viewer, g_game->GetBackBuffer(), 0, 0, m_x, m_y, img_viewer->w, img_viewer->h);
	else
		TRACE("*** Error in ModuleSideViewer::Draw: img_viewer is null");

}

void ModuleSideViewer::Draw3D()
{
   Module::Draw3D();
}

void ModuleSideViewer::OnKeyPress( int keyCode )
{
   Module::OnKeyPress(keyCode);
}

void ModuleSideViewer::OnKeyPressed(int keyCode)
{
   Module::OnKeyPressed(keyCode);
}

void ModuleSideViewer::OnKeyReleased(int keyCode)
{
   Module::OnKeyReleased(keyCode);
}

void ModuleSideViewer::OnMouseMove(int x, int y)
{
   Module::OnMouseMove(x,y);
}

void ModuleSideViewer::OnMouseClick(int button, int x, int y)
{
   Module::OnMouseClick(button,x,y);
}

void ModuleSideViewer::OnMousePressed(int button, int x, int y)
{
   Module::OnMousePressed(button,x,y);
}

void ModuleSideViewer::OnMouseReleased(int button, int x, int y)
{
   Module::OnMouseReleased(button,x,y);
}

void ModuleSideViewer::OnMouseWheelUp(int x, int y)
{
   Module::OnMouseWheelUp(x,y);
}

void ModuleSideViewer::OnMouseWheelDown(int x, int y)
{
   Module::OnMouseWheelDown(x,y);
}

void ModuleSideViewer::OnEvent(Event * event)
{
   Module::OnEvent(event);

	static int gvs = (int)g_game->getGlobalNumber("GUI_VIEWER_SPEED");

   if ((slideEventType != 0) &&
       (event->getEventType() == slideEventType))
   {
      if (!gui_viewer_sliding)
      {
	      gui_viewer_sliding = true;

         if (m_x < -220)
		      gui_viewer_dir = gvs;
	      else
		      gui_viewer_dir = -gvs;
      }
   }
}

void ModuleSideViewer::Close()
{
	try {
   
		//unload the data file (thus freeing all resources at once)
		unload_datafile(svdata);
		svdata = NULL;	

	}
	catch (std::exception e) {
		TRACE(e.what());
	}
	catch(...) {
		TRACE("Unhandled exception in SideViewer::Close\n");
	}   
}


void ModuleSideViewer::SetSlideEventType(int slideEventType)
{
   this->slideEventType = slideEventType;
}

