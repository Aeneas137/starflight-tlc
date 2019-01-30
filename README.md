# starflightt-tlc
Starflight: The Lost Colony

Development started in 2006 between Jon Harbour and Dave Calkins and quickly grew from there (see credits and we need a contributors file). In 2007, I was teaching game dev at UAT (uat.edu) and recruited a team of students to quickly build the game for a demo trip to GDC, and we went in 2008. Students used the game while job seeking. After GDC, the game was an unplayable demo with key systems barely functional. During the next two years, there were only a few of us still working on it, and Steve Wirsz came on to do encounters and dialogue. During 2009-2010, we released the first complete beta and then the final build of the game and then moved on to other things. 

In 2015, I opened the sources again and then in 2017, began a major revision in an attempt to support multiple resolutions. The game was hard coded to 1024x768, either windowed or FS. At the time that was the norm. Now, after the updates, any res can be selected in the Settings screen, but note that the art is scaled and will remain 4:3. Even in a widescreen mode, the game renders to 4:3 with bars. 

Rendering is 100% software. During the 2017 revision, I removed OpenGL via AllegroGL for rendering planets as it required a second frame buffer and interfered with the rest of the game. A software planet renderer does a decent enough job using the same textures (generated with Perlin and buffered for future use). A 256x256 texture is used for planet orbit, and a 500x500 is generated for the planet surface tilemap system (which is very fragile and divided between C++ and LUA, so be careful when working on planet surface code). In summary, no 3D hardware is used at all.

Project requires Visual C++ 2010 (web installer located in \misc). To upgrade this to the latest Visual Studio, someone will have to build all of the libraries, and I do not believe the "latest" versions of libraries are compatible with the game. If you rebuild libs, get the same versions and just build them with the latest compiler, don't try to upgrade the libs. This is a very old game. I recommend not updating the libs until you have it building with the latest VS. For the time being, 2010 is required. Smarter people than myself will be able to update it. :) Speaking of which, would some *very* experienced and talented programmer please volunteer to manage the repo? I'm too busy. 


Major dependencies (included):
* LUA 5.1
* Allegro 4.2
* AllegroGL
* ALFont
* FMOD
* Perlin (libnoise)
