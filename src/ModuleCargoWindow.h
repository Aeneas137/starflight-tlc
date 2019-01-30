#ifndef _CARGO_WINDOW_H
#define _CARGO_WINDOW_H

#include <fmod.hpp>
#include "DataMgr.h"
#include "Module.h"
#include "AudioSystem.h"

class Items;
class Button;
class Label;

namespace ScrollBox
{
   class ScrollBox;
};

/**
 * cargo window
 */
class ModuleCargoWindow : public Module
{
public:
	ModuleCargoWindow();
	virtual ~ModuleCargoWindow();

	virtual bool Init();
	void Update();
	void UpdateLists();
	virtual void Draw();
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
	bool isVisible(void) { return (m_x > gui_viewer_left && initialized); }

	//Force the window into it's starting (hidden) state.
	void ResetViewer(void);

private:
	void InitViewer(void);

	//true between end of Init() and start of Close(). false otherwise.
	bool initialized;

	DATAFILE *cwdata;
	DATAFILE *svdata;

	//the window itself
	BITMAP *img_viewer;
	int gui_viewer_left;
	int gui_viewer_right;
	int gui_viewer_speed;
	bool sliding;
	int sliding_offset;

	//the window content
	Items                   *m_items;
	Items                   *m_playerItemsFiltered;
	ScrollBox::ScrollBox    *m_playerList;
	ScrollBox::ScrollBox    *m_playerListNumItems;
	ScrollBox::ScrollBox    *m_playerListValue;
	
	Button                  *m_jettisonButton;
	Sample                  *m_sndButtonClick;

	Label                   *spaceStatus;
	int                     maxSpace;
};

#endif /* _CARGO_WINDOW_H */
