#pragma once
#include <string>
#include <allegro.h>

class Button;

class PauseMenu
{
public:
	//ctors
	PauseMenu();
	~PauseMenu();

	bool isShowing()	const { return display; }
	void setShowing(bool value) { display = value; }

	bool isEnabled() { return enabled; }
	void setEnabled(bool value) { enabled = value; }

	bool OnMouseMove(int x, int y);
	bool OnMouseReleased(int button, int x, int y);
	bool OnKeyReleased(int keyCode);
	void Update();
	void Draw();

	static Button	*button1;
	static Button	*button2;
	static Button	*button3;
	static Button	*button4;
	static BITMAP	*bg;

private:
	bool display;
	bool enabled;

	int x,y;

};
