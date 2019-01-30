#include "TexturedSphere.h"
#include <allegro.h>
#include <sstream>

TexturedSphere::TexturedSphere(int tex_size) 
{
    TEX_SIZE = tex_size;
    MAP_SIZE = 256;
    ASPECT_RATIO = 1.04;
    M_PI = 3.14159265;
    coord_transform_table = NULL;
    screen2sphere_table = NULL;
    tex_table = NULL; 
    source_bmp = NULL;
    textureWasSet = false;
    InitSphereLookupTables();
}

TexturedSphere::~TexturedSphere()
{
    //only destroy bitmap if it was loaded, not passed
    //a passed texture should be destroyed by the caller
    if (!textureWasSet)
    {
        if (source_bmp != NULL) 
            destroy_bitmap(source_bmp);
    }

    if (coord_transform_table != NULL) 
        free(coord_transform_table);
    if (screen2sphere_table != NULL)
        free(screen2sphere_table);
    if (tex_table != NULL)
        free(tex_table);
}

bool TexturedSphere::LoadTexture(string bmpfile)
{
    //destroy bitmap if it was previously loaded
    if (source_bmp != NULL)
    {
        destroy_bitmap(source_bmp);
        source_bmp = NULL;
    }

    source_bmp = NULL;
    source_bmp = (BITMAP*)load_bitmap(bmpfile.c_str(),NULL);
    if (!source_bmp) return false;

    //assuming texture file was loaded, then generate the map
    CreateTextureTable(source_bmp);
    return true;
}

bool TexturedSphere::SetTexture(BITMAP *new_texture)
{
    //destroy bitmap if it was previously created
    if (source_bmp != NULL)
    {
        destroy_bitmap(source_bmp);
        source_bmp = NULL;
    }

    if (new_texture == NULL)
        return false;
    else {
        source_bmp = new_texture;
        textureWasSet = true; //do not destroy passed texture
    }

    //assuming texture is valid, then generate the map
    CreateTextureTable(source_bmp);

    return true;
}


void TexturedSphere::Spherical2Cartesian(int alpha, int beta, double *x, double *y, double *z)
{
    /* Convert to radians */
	double alpha1 = (double)alpha * 2 * M_PI / MAP_SIZE;
	double beta1  = (double)(beta - MAP_SIZE/2) * M_PI / MAP_SIZE;
	   
	/* Convert to Cartesian */
	*x = cos(alpha1) * cos(beta1);
	*y = sin(beta1);
	*z = sin(alpha1) * cos(beta1);
}
	 
void TexturedSphere::Cartesian2Sphere(double x, double y, double z, int *alpha, int *beta)
{
	double beta1, alpha1, w;
	   
	/* convert to Spherical Coordinates */ 
	beta1 = asin(y);
	if (fabs(cos(beta1)) > 0.0) {  // we'll be dividing by cos(beta1)
	    w = x / cos(beta1);
	    if (w > 1) w = 1; if (w < -1) w = -1;   // Check bounds
	    alpha1 = acos(w);
	    if (z/cos(beta1) < 0) // Check for wrapping around top/bottom of sphere
	        alpha1 = 2 * M_PI - alpha1;
	}
	else 
	    alpha1 = 0;
	   
	/* Convert to texture coordinates */ 
	*alpha = (int)(alpha1 / (M_PI * 2) * MAP_SIZE);
	*beta  = (int)(beta1 / M_PI * MAP_SIZE + MAP_SIZE/2);
	   
	/* 'Clip' the texture coordinates */
	if (*alpha < 0) *alpha = 0;
	if (*alpha >= MAP_SIZE) *alpha = MAP_SIZE-1;
	if (*beta < 0) *beta = 0;
	if (*beta >= MAP_SIZE) *beta = MAP_SIZE-1;
}
	 
// Do not call unless source bitmap has been loaded first!
// unsigned short for 16 bit, can use int for 32 bit, char for 8 bit 
void TexturedSphere::CreateTextureTable(BITMAP *bmp) 
{
	int x, y;
    int p;

    tex_table = (int *)malloc( (TEX_SIZE*(TEX_SIZE+1)*sizeof(int)) );

    //this maps any sized bitmap onto the texture map
	for (int i=0; i<TEX_SIZE; i++) 
    {
	    for (int j=0; j<TEX_SIZE+1; j++) 
        {
            x = i * bmp->w / TEX_SIZE; 
            y = j * bmp->h / TEX_SIZE;
	        p = getpixel(bmp, x, y); 
            
            //map 2D coords into 1D array
            tex_table[j*TEX_SIZE+i] = p;
        }
    }
}

void TexturedSphere::InitSphereLookupTables()
{
	int alpha, beta; // Spherical Coordinates
	int i, j;
	double x, y, z; // Cartesian coordinates 
	 
	coord_transform_table = (int *)malloc( (TEX_SIZE*(TEX_SIZE+1)*sizeof(int)) );
	 
	screen2sphere_table = (int *)malloc(TEX_SIZE * sizeof(int));
	 
	/* Compute the Lookup Table for the Switching between 
	    the Coordinate-Systems */
	for(j = 0; j < TEX_SIZE+1; j++)
    {
	    for(i = 0; i < TEX_SIZE; i++) 
        {
	        /* Convert Spherical Coord. to Cartesian Coord. */
	        Spherical2Cartesian(i, j, &x, &y, &z);

	        /* Convert Cartesian Coord. to Spherical Coord. 
	        Notice it's not x,y,z but x,z,y */
	        Cartesian2Sphere(x, z, y, &alpha, &beta);

	        /* lower order of bits occupied by alpha, 
	        upper order shifted by TEX_SIZE occupied by beta */
	        coord_transform_table[i + j*TEX_SIZE] = alpha + beta*TEX_SIZE;  
        }
	}
	 
	/* Compute the Lookup Table that is used to convert the 2D Screen Coordinates 
        to the initial Spherical Coordinates */
	for(i = 0; i < TEX_SIZE; i++) 
    {
	    screen2sphere_table[i] = (int)(acos((double)(i-TEX_SIZE/2+1) * 2/TEX_SIZE) * TEX_SIZE/M_PI);
	    screen2sphere_table[i] %= TEX_SIZE;
	}
}


//phi, theta, psi must be 0-255 due to lookup table
void TexturedSphere::Draw(BITMAP *dest, int phi, int theta, int psi, int radius, int center_x, int center_y)
{
	int x, y;            // current Pixel-Position 
	int xr;              // Half Width of Sphere (pixels) in current scanline 
	int beta1, alpha1;   // initial spherical coordinates 
	int xinc, xscaled; // auxiliary variables 
	int alpha_beta2,alpha_beta3;  
	    /* spherical coordinates of the 2nd and 3rd rotated system 
	        (the 2 coordinates are stored in a single integer)       */
	 

	/* For all Scanlines ... */
	for(y = -radius+1;y < radius; y++) 
    {
	    /* compute the Width of the Sphere in this Scanline */
	    xr = (int)(sqrt( (double)(radius*radius - y*y) ) * ASPECT_RATIO); // Can be turned into fixed point
	    if (xr==0) xr = 1;
	      
	    /* compute the first Spherical Coordinate beta */
	    beta1 = screen2sphere_table[(y+radius) * TEX_SIZE/(2*radius)] * TEX_SIZE;

        //x << y == x * 2^y
        //TEX_SIZE << 16 = TEX_SIZE * 65535
	    //xinc = (TEX_SIZE << 16) / (2*xr);
        //xinc = (TEX_SIZE * 65535) / (2*xr);
        xinc = 16776960 / (2*xr);
	    xscaled = 0;
	 
	    /* For all Pixels in this Scanline ... */
	    for(x = -xr; x < xr; x++) 
        {
	        /* compute the second Spherical Coordinate alpha */
            //x >> y == x / 2^y
            //xscaled / 2^16
            //xscaled / 65536
	        //alpha1 = screen2sphere_table[xscaled >> 16] / 2;
            alpha1 = screen2sphere_table[xscaled / 65536] / 2;

	        xscaled += xinc;
	      
	        alpha1 = alpha1 + phi;    
	        /* Rotate Texture in the first Coordinate-System (alpha,beta);
	            Switch to the next Coordinate-System and rotate there       */
	        alpha_beta2 = coord_transform_table[beta1 + alpha1] + theta;
	        /* the same Procedure again ... */
	        alpha_beta3 = coord_transform_table[alpha_beta2] + psi;
	     
	        /* draw the Pixel */
	        putpixel(dest, x+center_x, y+center_y, tex_table[alpha_beta3]); 
	    }
	}
}


