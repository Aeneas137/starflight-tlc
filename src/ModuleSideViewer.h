#pragma once

#include <fmod.hpp>
#include "DataMgr.h"
#include "Module.h"

/**
 * provides a window which slides in from the left.  to use,
 * derive a module from this and render controls/etc. on top
 * of the background
 */
class ModuleSideViewer : public Module
{
public:
   ModuleSideViewer(int slideEventType);
   virtual ~ModuleSideViewer();

	virtual bool Init();
	void Update();
	virtual void Draw();
	virtual void Draw3D();
	virtual void OnKeyPress( int keyCode );
	virtual void OnKeyPressed(int keyCode);
	virtual void OnKeyReleased(int keyCode);
	virtual void OnMouseMove(int x, int y);
	virtual void OnMouseClick(int button, int x, int y);
	virtual void OnMousePressed(int button, int x, int y);
	virtual void OnMouseReleased(int button, int x, int y);
	virtual void OnMouseWheelUp(int x, int y);
	virtual void OnMouseWheelDown(int x, int y);
	virtual void OnEvent(Event *event);
	virtual void Close();

   /**
    * used to set the event which will trigger sliding in and out
    * of this module from the side of the display
    */
   void SetSlideEventType(int slideEventType);

private:

  	BITMAP *img_viewer;
   //BITMAP *border_mask;
   //BITMAP *content_mask;

  	int gui_viewer_dir;
	bool gui_viewer_sliding;

protected:

   int slideEventType;

   //bool BorderHitTest(int x, int y);
   //bool ContentHitTest(int x, int y);
};
