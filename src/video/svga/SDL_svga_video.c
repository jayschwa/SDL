/*
  Simple DirectMedia Layer
  Copyright (C) 1997-2020 Sam Lantinga <slouken@libsdl.org>
  Copyright (C) 2020 Jay Petacat <jay@jayschwa.net>

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

#include "SDL_svga_video.h"

#include <dos.h>

#include "../../core/dos/SDL_dos.h"

#include "SDL_svga_events.h"
#include "SDL_svga_framebuffer.h"
#include "SDL_svga_mouse.h"

#define SVGAVID_DRIVER_NAME "vga"

/* Initialization/Query functions */
static int SVGA_VideoInit(_THIS);
static void SVGA_GetDisplayModes(_THIS, SDL_VideoDisplay * display);
static int SVGA_SetDisplayMode(_THIS, SDL_VideoDisplay * display, SDL_DisplayMode * mode);
static void SVGA_VideoQuit(_THIS);
static int SVGA_CreateWindow(_THIS, SDL_Window * window);
static void SVGA_DestroyWindow(_THIS, SDL_Window * window);

/* SVGA driver bootstrap functions */

static void
SVGA_DeleteDevice(SDL_VideoDevice * device)
{
    SDL_free(device);
}

static SDL_VideoDevice *
SVGA_CreateDevice(int devindex)
{
    SDL_VideoDevice *device;
    SDL_DeviceData *devdata;

    devdata = (SDL_DeviceData *) SDL_calloc(1, sizeof(*devdata));
    if (!devdata) {
        SDL_OutOfMemory();
        return NULL;
    }

    /* Initialize all variables that we clean on shutdown */
    device = (SDL_VideoDevice *) SDL_calloc(1, sizeof(*device));
    if (!device) {
        SDL_free(devdata);
        SDL_OutOfMemory();
        return NULL;
    }

    device->driverdata = devdata;

    /* Set the function pointers */
    device->VideoInit = SVGA_VideoInit;
    device->VideoQuit = SVGA_VideoQuit;
    device->GetDisplayModes = SVGA_GetDisplayModes;
    device->SetDisplayMode = SVGA_SetDisplayMode;
    device->PumpEvents = SVGA_PumpEvents;
    device->CreateSDLWindow = SVGA_CreateWindow;
    device->DestroyWindow = SVGA_DestroyWindow;
    device->CreateWindowFramebuffer = SDL_SVGA_CreateFramebuffer;
    device->UpdateWindowFramebuffer = SDL_SVGA_UpdateFramebuffer;
    device->DestroyWindowFramebuffer = SDL_SVGA_DestroyFramebuffer;

    device->free = SVGA_DeleteDevice;

    return device;
}

VideoBootStrap SVGA_bootstrap = {
    SVGAVID_DRIVER_NAME, "SDL DOS VGA driver",
    SVGA_CreateDevice
};

static int
SVGA_VideoInit(_THIS)
{
    SDL_DeviceData *devdata = _this->driverdata;
    union REGS regs;

    /* Save original video mode. */
    regs.h.ah = 0xF;
    int86(0x10, &regs, &regs);
    devdata->original_mode = regs.h.al;

    if (SDL_AddBasicVideoDisplay(NULL) < 0) {
        return -1;
    }

    /* Initialize keyboard. */
    /* TODO: Just move keyboard stuff under this module and rename to DOS! */
    if (SDL_DOS_Init()) {
        return -1;
    }

    DOS_InitMouse();

    return 0;
}

static void
SVGA_GetDisplayModes(_THIS, SDL_VideoDisplay * display)
{
    SDL_DisplayMode mode;

    SDL_zero(mode);

    mode.format = SDL_PIXELFORMAT_INDEX8;
    mode.w = 320;
    mode.h = 200;

    SDL_AddDisplayMode(display, &mode);
}

static int
SVGA_SetDisplayMode(_THIS, SDL_VideoDisplay * display, SDL_DisplayMode * mode)
{
    SDL_DeviceData *devdata = _this->driverdata;
    union REGS regs;

    if (mode->format != SDL_PIXELFORMAT_INDEX8 || mode->w != 320 || mode->h != 200) {
        return SDL_SetError("Invalid display mode");
    }

    /* Switch to video mode. */
    regs.h.ah = 0;
    regs.h.al = 0x13;
    int86(0x10, &regs, &regs);

    devdata->mode_changed = SDL_TRUE;

    DOS_InitMouse(); /* TODO: Is this necessary when video mode changes? */

    return 0;
}

static void
SVGA_VideoQuit(_THIS)
{
    SDL_DeviceData *devdata = _this->driverdata;

    /* Restore original video mode. */
    if (devdata->mode_changed) {
        union REGS regs;

        regs.h.ah = 0;
        regs.h.al = devdata->original_mode;
        int86(0x10, &regs, &regs);
    }

    SDL_DOS_Quit();
    DOS_QuitMouse();
}

static int
SVGA_CreateWindow(_THIS, SDL_Window * window)
{
    /* TODO: Allow only one window. */

    /* Window is always fullscreen. */
    /* QUESTION: Is this appropriate, or should an error be returned instead? */
    window->flags |= SDL_WINDOW_FULLSCREEN;

    return 0;
}

static void
SVGA_DestroyWindow(_THIS, SDL_Window * window)
{
}

#endif /* SDL_VIDEO_DRIVER_SVGA */

/* vi: set ts=4 sw=4 expandtab: */
