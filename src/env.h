/*
	STARFLIGHT - THE LOST COLONY
	env.h - environment specific defines
	Author: 
	Date: 
*/

#ifndef ENV_H
#define ENV_H 1


//Allegro looks for this define when compiling ASSERTs
#define DEBUGMODE 1
#define ALLEGRO_ASSERT 1
#define MSVC10_DEBUG 1


#if defined(_MSC_VER) 
	//Visual C++ definitions
	//typedef __int64 int64_t;
	//typedef unsigned __int64 uint64_t;

	// warning C4312: 'type cast' : conversion from 'unsigned int' to 'unsigned char *' of greater size
	#pragma warning( disable: 4312 )

	#define _CRT_SECURE_NO_WARNINGS

#endif


//if not compiling for windows
#if !defined(_MSC_VER) && !defined(WIN32)
	//MessageBox is a winapi function.
	//Right now, it is only used in the very early stage of initialization in
	//ValidateScripts(), before allegro_init() is called. After that point we 
	//(indirectly) use allegro_message() for the same purpose.

	//We'll redefine it to call allegro_message() for the time being. Note that
	//since allegro_init() was not called yet when we use it, you'll get output
	//on stderr but no error window.
	#define MessageBox(a,b,c,d) allegro_message(b)
#endif


#endif
