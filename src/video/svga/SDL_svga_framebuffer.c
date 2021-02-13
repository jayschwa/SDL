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

#include <pc.h>
#include <sys/movedata.h>

#include "SDL_svga_video.h"
#include "SDL_svga_framebuffer.h"

static void
VGA_GetPaletteColor(int index, SDL_Color * color)
{
    outp(0x03C8, index);
    color->r = inp(0x03C9) * UINT8_MAX / 63;
    color->g = inp(0x03C9) * UINT8_MAX / 63;
    color->b = inp(0x03C9) * UINT8_MAX / 63;
}

int
SDL_SVGA_CreateFramebuffer(_THIS, SDL_Window * window, Uint32 * format, void ** pixels, int *pitch)
{
    SDL_DisplayMode mode;
    SDL_Surface *surface;
    int i, w, h;

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
        SDL_Palette *pal = surface->format->palette;
        for (i = 0; i < pal->ncolors && i < 256; i++) {
            VGA_GetPaletteColor(i, &pal->colors[i]);
        }
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

    /* Wait for the start of a vertical blanking interval. */
    while ((inp(0x03DA) & 0x08));
    while (!(inp(0x03DA) & 0x08));

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
