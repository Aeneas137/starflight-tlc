This data folder should be located in the same folder as starflighttlc.exe. It contains all of the assets for the game. Each module of the game is represented by a folder in .\data. In each module folder is an .\assets folder containing the original assets. If any changes are made to an asset, the Allegro data file will need to be recreated. Changes involving an edit or replacement for a file requires no changes in source code, while new files added to the data file for a module will require changes in source code. 

For example, for the auxiliary module, we have these folders:

.\data\auxiliary

  auxiliary.dat   <-- data file needed by game


.\data\auxiliary\assets

  gui_aux.bmp                <--original asset files NOT distributed with game
  is_tiles_small.bmp 
  aux_icon_freelance.tga 
  aux_icon_military.tga 
  aux_icon_science.tga 
  high_res_ship_freelance.tga 
  high_res_ship_military.tga 
  high_res_ship_science.tga




All of these .\asset sub-folders should contain a batch file and dat.exe utility (alleg42.dll required). If you just change an asset, running dat_auxiliary.bat (for instance) will recreate the auxiliary.dat file. After it has been created, move it up one folder into .\auxiliary, overwriting the old auxiliary.dat. If you need to ADD new asset files, you'll need to re-paste the constants defined in dat_auxiliary.h into the source code module and add the code to load the new assets. (This probably will never happen).



The dat_auxiliary.bat file looks like this:

dat -c2 -f -bpp 32 -t BMP -h dat_auxiliary.h auxiliary.dat -a gui_aux.bmp is_tiles_small.bmp aux_icon_freelance.tga aux_icon_military.tga aux_icon_science.tga high_res_ship_freelance.tga high_res_ship_military.tga high_res_ship_science.tga


This calls the dat.exe utility, set to convert all images to 32-bit preserving alpha channels, storing all files in auxiliary.dat. 

Remember: DO NOT DISTRIBUTE ORIGINAL ASSETS WITH THE GAME, ONLY THE .DAT FILES.
