#ifdef _DEBUG

// Allegro
#pragma comment(lib,"..\\lib\\alld.lib")

// Perlin Noise 
#pragma comment(lib,"..\\lib\\libnoised.lib")

// LUA
#pragma comment(lib,"..\\lib\\lua5.1d.lib")

#else

// Allegro
#pragma comment(lib,"..\\lib\\alleg.lib")

// Perlin Noise 
#pragma comment(lib,"..\\lib\\libnoise.lib")

// LUA
#pragma comment(lib,"..\\lib\\lua5.1.lib")

#endif

// AllegroFont
#pragma comment(lib,"..\\lib\\alfontdll.lib")

// FMOD
#pragma comment(lib,"..\\lib\\fmodex_vc.lib")

// platform libs
#pragma comment(lib,"opengl32.lib")
#pragma comment(lib,"glu32.lib")
#pragma comment(lib,"user32.lib")
#pragma comment(lib,"gdi32.lib")

