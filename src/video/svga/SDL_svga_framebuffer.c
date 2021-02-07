/*
  Simple DirectMedia Layer
  Copyright (C) 1997-2020 Sam Lantinga <slouken@libsdl.org>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/
#include "../../SDL_internal.h"

#if SDL_VIDEO_DRIVER_SVGA

#include <sys/movedata.h>

#include "SDL_svga_video.h"
#include "SDL_svga_framebuffer.h"

int
SDL_SVGA_CreateFramebuffer(_THIS, SDL_Window * window, Uint32 * format, void ** pixels, int *pitch)
{
    SDL_DisplayMode mode;
    SDL_Surface *surface;
    int w, h;

    /* Free the old framebuffer surface. */
    SDL_SVGA_DestroyFramebuffer(_this, window);

    /* Get data for current mode. */
    if (SDL_GetWindowDisplayMode(window, &mode)) {
        return -1;
    }

    /* Create a new surface. */
    SDL_GetWindowSize(window, &w, &h);
    surface = SDL_CreateRGBSurfaceWithFormat(0, w, h, 0, mode.format);
    if (!surface) {
        SDL_SVGA_DestroyFramebuffer(_this, window);
        return -1;
    }

    /* Populate color palette. */
    if (surface->format->palette != NULL) {
        /* TODO: Read palette from VGA. */
        Uint32 *colors = surface->format->palette->colors;

        SDL_memset(colors, 0, surface->format->palette->ncolors * sizeof(*colors));

        /* Dark colors */
        colors[0] = SDL_Swap32(0x000000FF); // Black
        colors[1] = SDL_Swap32(0x0000AAFF); // Blue
        colors[2] = SDL_Swap32(0x00AA00FF); // Green
        colors[3] = SDL_Swap32(0x00AAAAFF); // Cyan
        colors[4] = SDL_Swap32(0xAA0000FF); // Red
        colors[5] = SDL_Swap32(0xAA00AAFF); // Magenta
        colors[6] = SDL_Swap32(0xAA5500FF); // Brown
        colors[7] = SDL_Swap32(0xAAAAAAFF); // Light gray

        /* Bright colors */
        colors[8] = SDL_Swap32(0x555555FF); // Dark gray
        colors[9] = SDL_Swap32(0x5555FFFF); // Blue
        colors[10] = SDL_Swap32(0x55FF55FF); // Green
        colors[11] = SDL_Swap32(0x55FFFFFF); // Cyan
        colors[12] = SDL_Swap32(0xFF5555FF); // Red
        colors[13] = SDL_Swap32(0xFF55FFFF); // Magenta
        colors[14] = SDL_Swap32(0xFFFF55FF); // Yellow
        colors[15] = SDL_Swap32(0xFFFFFFFF); // White
    }

    /* Save data and set output parameters. */
    window->surface = surface;
    *format = mode.format;
    *pixels = surface->pixels;
    *pitch = surface->pitch;

    return 0;
}

/* TODO: Draw a real pointer. */
static void
CopyCursorPixels(SDL_Window * window)
{
    SDL_Surface *surface = window->surface;
    Uint32 color = SDL_MapRGB(surface->format, 0xFF, 0, 0);
    int i, k, x, y;

    SDL_GetMouseState(&x, &y);
    x = SDL_max(x, 0);
    y = SDL_max(y, 0);
    x = SDL_min(x, surface->w - 4);
    y = SDL_min(y, surface->h - 4);

    for (i = 0; i < 4; i++) {
        for (k = 0; k < 4; k++) {
            dosmemput(&color, surface->format->BytesPerPixel,
                0xA0000 + surface->pitch * (y + i) + (x + k) * surface->format->BytesPerPixel
            );
        }
    }
}

int
SDL_SVGA_UpdateFramebuffer(_THIS, SDL_Window * window, const SDL_Rect * rects, int numrects)
{
    SDL_Surface *surface = window->surface;

    if (surface == NULL) {
        return SDL_SetError("Missing VGA surface");
    }

    /* Copy surface pixels to VGA memory. */
    dosmemput(surface->pixels, 320 * 200, 0xA0000);

    /* Copy cursor pixels to VGA memory. */
    // CopyCursorPixels(window);

    return 0;
}

void
SDL_SVGA_DestroyFramebuffer(_THIS, SDL_Window * window)
{
    SDL_Surface *surface = window->surface;

    /* Destroy surface. */
    window->surface_valid = SDL_FALSE;
    window->surface = NULL;
    SDL_FreeSurface(surface);
}

#endif /* SDL_VIDEO_DRIVER_SVGA */

/* vi: set ts=4 sw=4 expandtab: */
