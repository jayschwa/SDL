const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("sdl", .{});

    const lib = b.addStaticLibrary(.{
        .name = "SDL3",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();

    const t = target.result;
    const os = t.os.tag;
    const is_posix = os == .linux;
    const is_unix = os == .linux;

    const config_h = b.addConfigHeader(.{
        .include_path = "SDL_build_config.h",
        .style = .{ .cmake = upstream.path("include/build_config/SDL_build_config.h.cmake") },
    }, .{
        .HAVE_GCC_ATOMICS = 0,
        .HAVE_GCC_SYNC_LOCK_TEST_AND_SET = 0,

        .SDL_DISABLE_ALLOCA = 0,

        // Comment this if you want to build without any C library requirements
        .HAVE_LIBC = 1,

        // Useful headers
        .HAVE_ALLOCA_H = 1,
        .HAVE_FLOAT_H = 1,
        .HAVE_ICONV_H = 1,
        .HAVE_INTTYPES_H = 1,
        .HAVE_LIMITS_H = 1,
        .HAVE_MALLOC_H = 1,
        .HAVE_MATH_H = 1,
        .HAVE_MEMORY_H = 1,
        .HAVE_SIGNAL_H = 1,
        .HAVE_STDARG_H = 1,
        .HAVE_STDBOOL_H = 1,
        .HAVE_STDDEF_H = 1,
        .HAVE_STDINT_H = 1,
        .HAVE_STDIO_H = 1,
        .HAVE_STDLIB_H = 1,
        .HAVE_STRINGS_H = 1,
        .HAVE_STRING_H = 1,
        .HAVE_SYS_TYPES_H = 1,
        .HAVE_WCHAR_H = 1,
        .HAVE_PTHREAD_NP_H = 0,

        // C library functions
        .HAVE_DLOPEN = 1,
        .HAVE_MALLOC = 1,
        .HAVE_CALLOC = 1,
        .HAVE_REALLOC = 1,
        .HAVE_FDATASYNC = 1,
        .HAVE_FREE = 1,
        .HAVE_GETENV = 1,
        .HAVE_GETHOSTNAME = 1,
        .HAVE_SETENV = 1,
        .HAVE_PUTENV = 1,
        .HAVE_UNSETENV = 1,
        .HAVE_ABS = 1,
        .HAVE_BCOPY = 1,
        .HAVE_MEMSET = 1,
        .HAVE_MEMCPY = 1,
        .HAVE_MEMMOVE = 1,
        .HAVE_MEMCMP = 1,
        .HAVE_WCSLEN = 1,
        .HAVE_WCSNLEN = 1,
        .HAVE_WCSLCPY = 1,
        .HAVE_WCSLCAT = 1,
        .HAVE__WCSDUP = 0,
        .HAVE_WCSDUP = 1,
        .HAVE_WCSSTR = 1,
        .HAVE_WCSCMP = 1,
        .HAVE_WCSNCMP = 1,
        .HAVE_WCSTOL = 1,
        .HAVE_STRLEN = 1,
        .HAVE_STRNLEN = 1,
        .HAVE_STRLCPY = 1,
        .HAVE_STRLCAT = 1,
        .HAVE_STRPBRK = 1,
        .HAVE__STRREV = 0,
        .HAVE__STRUPR = 0,
        .HAVE__STRLWR = 0,
        .HAVE_INDEX = 1,
        .HAVE_RINDEX = 1,
        .HAVE_STRCHR = 1,
        .HAVE_STRRCHR = 1,
        .HAVE_STRSTR = 1,
        .HAVE_STRNSTR = t.isDarwin(),
        .HAVE_STRTOK_R = 1,
        .HAVE_ITOA = 0,
        .HAVE__LTOA = 0,
        .HAVE__UITOA = 0,
        .HAVE__ULTOA = 0,
        .HAVE_STRTOL = 1,
        .HAVE_STRTOUL = 1,
        .HAVE__I64TOA = 0,
        .HAVE__UI64TOA = 0,
        .HAVE_STRTOLL = 1,
        .HAVE_STRTOULL = 1,
        .HAVE_STRTOD = 1,
        .HAVE_ATOI = 1,
        .HAVE_ATOF = 1,
        .HAVE_STRCMP = 1,
        .HAVE_STRNCMP = 1,
        .HAVE_STRCASESTR = 1,
        .HAVE_SSCANF = 1,
        .HAVE_VSSCANF = 1,
        .HAVE_VSNPRINTF = 1,
        .HAVE_ACOS = 1,
        .HAVE_ACOSF = 1,
        .HAVE_ASIN = 1,
        .HAVE_ASINF = 1,
        .HAVE_ATAN = 1,
        .HAVE_ATANF = 1,
        .HAVE_ATAN2 = 1,
        .HAVE_ATAN2F = 1,
        .HAVE_CEIL = 1,
        .HAVE_CEILF = 1,
        .HAVE_COPYSIGN = 1,
        .HAVE_COPYSIGNF = 1,
        .HAVE_COS = 1,
        .HAVE_COSF = 1,
        .HAVE_EXP = 1,
        .HAVE_EXPF = 1,
        .HAVE_FABS = 1,
        .HAVE_FABSF = 1,
        .HAVE_FLOOR = 1,
        .HAVE_FLOORF = 1,
        .HAVE_FMOD = 1,
        .HAVE_FMODF = 1,
        .HAVE_ISINF = 1,
        .HAVE_ISINFF = 1,
        .HAVE_ISINF_FLOAT_MACRO = 1,
        .HAVE_ISNAN = 1,
        .HAVE_ISNANF = 1,
        .HAVE_ISNAN_FLOAT_MACRO = 1,
        .HAVE_LOG = 1,
        .HAVE_LOGF = 1,
        .HAVE_LOG10 = 1,
        .HAVE_LOG10F = 1,
        .HAVE_LROUND = 1,
        .HAVE_LROUNDF = 1,
        .HAVE_MODF = 1,
        .HAVE_MODFF = 1,
        .HAVE_POW = 1,
        .HAVE_POWF = 1,
        .HAVE_ROUND = 1,
        .HAVE_ROUNDF = 1,
        .HAVE_SCALBN = 1,
        .HAVE_SCALBNF = 1,
        .HAVE_SIN = 1,
        .HAVE_SINF = 1,
        .HAVE_SQRT = 1,
        .HAVE_SQRTF = 1,
        .HAVE_TAN = 1,
        .HAVE_TANF = 1,
        .HAVE_TRUNC = 1,
        .HAVE_TRUNCF = 1,
        .HAVE_FOPEN64 = 1,
        .HAVE_FSEEKO = 1,
        .HAVE_FSEEKO64 = 1,
        .HAVE_MEMFD_CREATE = 1,
        .HAVE_POSIX_FALLOCATE = 1,
        .HAVE_SIGACTION = 1,
        .HAVE_SA_SIGACTION = 1,
        .HAVE_ST_MTIM = 1,
        .HAVE_SETJMP = 1,
        .HAVE_NANOSLEEP = 1,
        .HAVE_GMTIME_R = 1,
        .HAVE_LOCALTIME_R = 1,
        .HAVE_NL_LANGINFO = 1,
        .HAVE_SYSCONF = 1,
        .HAVE_SYSCTLBYNAME = t.isDarwin(),
        .HAVE_CLOCK_GETTIME = 1,
        .HAVE_GETPAGESIZE = 1,
        .HAVE_ICONV = 1,
        .SDL_USE_LIBICONV = 1,
        .HAVE_PTHREAD_SETNAME_NP = 1,
        .HAVE_PTHREAD_SET_NAME_NP = 0,
        .HAVE_SEM_TIMEDWAIT = 1,
        .HAVE_GETAUXVAL = 1,
        .HAVE_ELF_AUX_INFO = 1,
        .HAVE_POLL = 1,
        .HAVE__EXIT = 0,

        .HAVE_DBUS_DBUS_H = 0,
        .HAVE_FCITX = 0,
        .HAVE_IBUS_IBUS_H = 0,
        .HAVE_SYS_INOTIFY_H = os == .linux,
        .HAVE_INOTIFY_INIT = os == .linux,
        .HAVE_INOTIFY_INIT1 = os == .linux,
        .HAVE_INOTIFY = os == .linux,
        .HAVE_LIBUSB = 0,
        .HAVE_O_CLOEXEC = 0,

        .HAVE_LINUX_INPUT_H = os == .linux,
        .HAVE_LIBUDEV_H = 0,
        .HAVE_LIBDECOR_H = 0,

        .HAVE_D3D11_H = 0,
        .HAVE_DDRAW_H = 0,
        .HAVE_DSOUND_H = 0,
        .HAVE_DINPUT_H = 0,
        .HAVE_XINPUT_H = 0,
        .HAVE_WINDOWS_GAMING_INPUT_H = 0,
        .HAVE_GAMEINPUT_H = 0,
        .HAVE_DXGI_H = 0,
        .HAVE_DXGI1_6_H = 0,

        .HAVE_MMDEVICEAPI_H = 0,
        .HAVE_AUDIOCLIENT_H = 0,
        .HAVE_TPCSHRD_H = 0,
        .HAVE_SENSORSAPI_H = 0,
        .HAVE_ROAPI_H = 0,
        .HAVE_SHELLSCALINGAPI_H = 0,

        .USE_POSIX_SPAWN = 0,

        // SDL internal assertion support
        .SDL_DEFAULT_ASSERT_LEVEL_CONFIGURED = 0,
        .SDL_DEFAULT_ASSERT_LEVEL = .undef,

        // Allow disabling of major subsystems
        .SDL_AUDIO_DISABLED = 0,
        .SDL_JOYSTICK_DISABLED = 0,
        .SDL_HAPTIC_DISABLED = 0,
        .SDL_HIDAPI_DISABLED = 0,
        .SDL_SENSOR_DISABLED = 0,
        .SDL_RENDER_DISABLED = 0,
        .SDL_THREADS_DISABLED = 0,
        .SDL_VIDEO_DISABLED = 0,
        .SDL_POWER_DISABLED = 0,
        .SDL_CAMERA_DISABLED = 0,
        .SDL_GPU_DISABLED = 0,

        // Enable various audio drivers
        .SDL_AUDIO_DRIVER_ALSA = 0,
        .SDL_AUDIO_DRIVER_ALSA_DYNAMIC = 0,
        .SDL_AUDIO_DRIVER_OPENSLES = 0,
        .SDL_AUDIO_DRIVER_AAUDIO = 0,
        .SDL_AUDIO_DRIVER_COREAUDIO = 0,
        .SDL_AUDIO_DRIVER_DISK = 0,
        .SDL_AUDIO_DRIVER_DSOUND = 0,
        .SDL_AUDIO_DRIVER_DUMMY = 0,
        .SDL_AUDIO_DRIVER_EMSCRIPTEN = 0,
        .SDL_AUDIO_DRIVER_HAIKU = 0,
        .SDL_AUDIO_DRIVER_JACK = 0,
        .SDL_AUDIO_DRIVER_JACK_DYNAMIC = 0,
        .SDL_AUDIO_DRIVER_NETBSD = 0,
        .SDL_AUDIO_DRIVER_OSS = 0,
        .SDL_AUDIO_DRIVER_PIPEWIRE = 0,
        .SDL_AUDIO_DRIVER_PIPEWIRE_DYNAMIC = 0,
        .SDL_AUDIO_DRIVER_PULSEAUDIO = 0,
        .SDL_AUDIO_DRIVER_PULSEAUDIO_DYNAMIC = 0,
        .SDL_AUDIO_DRIVER_SNDIO = 0,
        .SDL_AUDIO_DRIVER_SNDIO_DYNAMIC = 0,
        .SDL_AUDIO_DRIVER_WASAPI = 0,
        .SDL_AUDIO_DRIVER_VITA = 0,
        .SDL_AUDIO_DRIVER_PSP = 0,
        .SDL_AUDIO_DRIVER_PS2 = 0,
        .SDL_AUDIO_DRIVER_N3DS = 0,
        .SDL_AUDIO_DRIVER_QNX = 0,

        // Enable various input drivers
        .SDL_INPUT_LINUXEV = os == .linux,
        .SDL_INPUT_LINUXKD = os == .linux,
        .SDL_INPUT_FBSDKBIO = 0,
        .SDL_INPUT_WSCONS = 0,
        .SDL_HAVE_MACHINE_JOYSTICK_H = 0,
        .SDL_JOYSTICK_ANDROID = 0,
        .SDL_JOYSTICK_DINPUT = 0,
        .SDL_JOYSTICK_DUMMY = 0,
        .SDL_JOYSTICK_EMSCRIPTEN = 0,
        .SDL_JOYSTICK_GAMEINPUT = 0,
        .SDL_JOYSTICK_HAIKU = 0,
        .SDL_JOYSTICK_HIDAPI = 1, // FIXME: Workaround bug in 3.1.6.
        .SDL_JOYSTICK_IOKIT = 0,
        .SDL_JOYSTICK_LINUX = os == .linux,
        .SDL_JOYSTICK_MFI = 0,
        .SDL_JOYSTICK_N3DS = 0,
        .SDL_JOYSTICK_PS2 = 0,
        .SDL_JOYSTICK_PSP = 0,
        .SDL_JOYSTICK_RAWINPUT = 0,
        .SDL_JOYSTICK_USBHID = 0,
        .SDL_JOYSTICK_VIRTUAL = 0,
        .SDL_JOYSTICK_VITA = 0,
        .SDL_JOYSTICK_WGI = 0,
        .SDL_JOYSTICK_XINPUT = 0,
        .SDL_HAPTIC_DUMMY = 0,
        .SDL_HAPTIC_LINUX = os == .linux,
        .SDL_HAPTIC_IOKIT = 0,
        .SDL_HAPTIC_DINPUT = 0,
        .SDL_HAPTIC_ANDROID = 0,
        .SDL_LIBUSB_DYNAMIC = 0,
        .SDL_UDEV_DYNAMIC = 0,

        // Enable various process implementations
        .SDL_PROCESS_DUMMY = 0,
        .SDL_PROCESS_POSIX = is_posix,
        .SDL_PROCESS_WINDOWS = 0,

        // Enable various sensor drivers
        .SDL_SENSOR_ANDROID = 0,
        .SDL_SENSOR_COREMOTION = 0,
        .SDL_SENSOR_WINDOWS = 0,
        .SDL_SENSOR_DUMMY = 0,
        .SDL_SENSOR_VITA = 0,
        .SDL_SENSOR_N3DS = 0,

        // Enable various shared object loading systems
        .SDL_LOADSO_DLOPEN = is_unix,
        .SDL_LOADSO_DUMMY = 0,
        .SDL_LOADSO_LDG = 0,
        .SDL_LOADSO_WINDOWS = 0,

        // Enable various threading systems
        .SDL_THREAD_GENERIC_COND_SUFFIX = 0,
        .SDL_THREAD_GENERIC_RWLOCK_SUFFIX = 0,
        .SDL_THREAD_PTHREAD = is_posix,
        .SDL_THREAD_PTHREAD_RECURSIVE_MUTEX = is_posix,
        .SDL_THREAD_PTHREAD_RECURSIVE_MUTEX_NP = 0,
        .SDL_THREAD_WINDOWS = 0,
        .SDL_THREAD_VITA = 0,
        .SDL_THREAD_PSP = 0,
        .SDL_THREAD_PS2 = 0,
        .SDL_THREAD_N3DS = 0,

        // Enable various RTC systems
        .SDL_TIME_UNIX = is_unix,
        .SDL_TIME_WINDOWS = 0,
        .SDL_TIME_VITA = 0,
        .SDL_TIME_PSP = 0,
        .SDL_TIME_PS2 = 0,
        .SDL_TIME_N3DS = 0,

        // Enable various timer systems
        .SDL_TIMER_HAIKU = 0,
        .SDL_TIMER_DUMMY = 0,
        .SDL_TIMER_UNIX = is_unix,
        .SDL_TIMER_WINDOWS = 0,
        .SDL_TIMER_VITA = 0,
        .SDL_TIMER_PSP = 0,
        .SDL_TIMER_PS2 = 0,
        .SDL_TIMER_N3DS = 0,

        // Enable various video drivers
        .SDL_VIDEO_DRIVER_ANDROID = 0,
        .SDL_VIDEO_DRIVER_COCOA = 0,
        .SDL_VIDEO_DRIVER_DUMMY = 0,
        .SDL_VIDEO_DRIVER_EMSCRIPTEN = 0,
        .SDL_VIDEO_DRIVER_HAIKU = 0,
        .SDL_VIDEO_DRIVER_KMSDRM = 0,
        .SDL_VIDEO_DRIVER_KMSDRM_DYNAMIC = 0,
        .SDL_VIDEO_DRIVER_KMSDRM_DYNAMIC_GBM = 0,
        .SDL_VIDEO_DRIVER_N3DS = 0,
        .SDL_VIDEO_DRIVER_OFFSCREEN = 0,
        .SDL_VIDEO_DRIVER_PS2 = 0,
        .SDL_VIDEO_DRIVER_PSP = 0,
        .SDL_VIDEO_DRIVER_RISCOS = 0,
        .SDL_VIDEO_DRIVER_ROCKCHIP = 0,
        .SDL_VIDEO_DRIVER_RPI = 0,
        .SDL_VIDEO_DRIVER_UIKIT = 0,
        .SDL_VIDEO_DRIVER_VITA = 0,
        .SDL_VIDEO_DRIVER_VIVANTE = 0,
        .SDL_VIDEO_DRIVER_VIVANTE_VDK = 0,
        .SDL_VIDEO_DRIVER_OPENVR = 0,
        .SDL_VIDEO_DRIVER_WAYLAND = 0,
        .SDL_VIDEO_DRIVER_WAYLAND_DYNAMIC = 0,
        .SDL_VIDEO_DRIVER_WAYLAND_DYNAMIC_CURSOR = 0,
        .SDL_VIDEO_DRIVER_WAYLAND_DYNAMIC_EGL = 0,
        .SDL_VIDEO_DRIVER_WAYLAND_DYNAMIC_LIBDECOR = 0,
        .SDL_VIDEO_DRIVER_WAYLAND_DYNAMIC_XKBCOMMON = 0,
        .SDL_VIDEO_DRIVER_WINDOWS = 0,
        .SDL_VIDEO_DRIVER_X11 = os == .linux, // TODO: Detect or use option.
        .SDL_VIDEO_DRIVER_X11_DYNAMIC = 0,
        .SDL_VIDEO_DRIVER_X11_DYNAMIC_XCURSOR = 0,
        .SDL_VIDEO_DRIVER_X11_DYNAMIC_XEXT = 0,
        .SDL_VIDEO_DRIVER_X11_DYNAMIC_XFIXES = 0,
        .SDL_VIDEO_DRIVER_X11_DYNAMIC_XINPUT2 = 0,
        .SDL_VIDEO_DRIVER_X11_DYNAMIC_XRANDR = 0,
        .SDL_VIDEO_DRIVER_X11_DYNAMIC_XSS = 0,
        .SDL_VIDEO_DRIVER_X11_HAS_XKBLOOKUPKEYSYM = 0,
        .SDL_VIDEO_DRIVER_X11_SUPPORTS_GENERIC_EVENTS = os == .linux, // TODO: Detect or use option.
        .SDL_VIDEO_DRIVER_X11_XCURSOR = 0,
        .SDL_VIDEO_DRIVER_X11_XDBE = 0,
        .SDL_VIDEO_DRIVER_X11_XFIXES = 0,
        .SDL_VIDEO_DRIVER_X11_XINPUT2 = 0,
        .SDL_VIDEO_DRIVER_X11_XINPUT2_SUPPORTS_MULTITOUCH = 0,
        .SDL_VIDEO_DRIVER_X11_XRANDR = 0,
        .SDL_VIDEO_DRIVER_X11_XSCRNSAVER = 0,
        .SDL_VIDEO_DRIVER_X11_XSHAPE = 0,
        .SDL_VIDEO_DRIVER_QNX = 0,

        .SDL_VIDEO_RENDER_D3D = 0,
        .SDL_VIDEO_RENDER_D3D11 = 0,
        .SDL_VIDEO_RENDER_D3D12 = 0,
        .SDL_VIDEO_RENDER_GPU = 0,
        .SDL_VIDEO_RENDER_METAL = 0,
        .SDL_VIDEO_RENDER_VULKAN = 0,
        .SDL_VIDEO_RENDER_OGL = 0,
        .SDL_VIDEO_RENDER_OGL_ES2 = 0,
        .SDL_VIDEO_RENDER_PS2 = 0,
        .SDL_VIDEO_RENDER_PSP = 0,
        .SDL_VIDEO_RENDER_VITA_GXM = 0,

        // Enable OpenGL support
        .SDL_VIDEO_OPENGL = 0,
        .SDL_VIDEO_OPENGL_ES = 0,
        .SDL_VIDEO_OPENGL_ES2 = 0,
        .SDL_VIDEO_OPENGL_BGL = 0,
        .SDL_VIDEO_OPENGL_CGL = 0,
        .SDL_VIDEO_OPENGL_GLX = 0,
        .SDL_VIDEO_OPENGL_WGL = 0,
        .SDL_VIDEO_OPENGL_EGL = 0,
        .SDL_VIDEO_OPENGL_OSMESA = 0,
        .SDL_VIDEO_OPENGL_OSMESA_DYNAMIC = 0,

        // Enable Vulkan support
        .SDL_VIDEO_VULKAN = 0,

        // Enable Metal support
        .SDL_VIDEO_METAL = 0,

        // Enable GPU support
        .SDL_GPU_D3D11 = 0,
        .SDL_GPU_D3D12 = 0,
        .SDL_GPU_VULKAN = 0,
        .SDL_GPU_METAL = 0,

        // Enable system power support
        .SDL_POWER_ANDROID = 0,
        .SDL_POWER_LINUX = os == .linux,
        .SDL_POWER_WINDOWS = 0,
        .SDL_POWER_MACOSX = 0,
        .SDL_POWER_UIKIT = 0,
        .SDL_POWER_HAIKU = 0,
        .SDL_POWER_EMSCRIPTEN = 0,
        .SDL_POWER_HARDWIRED = 0,
        .SDL_POWER_VITA = 0,
        .SDL_POWER_PSP = 0,
        .SDL_POWER_N3DS = 0,

        // Enable system filesystem support
        .SDL_FILESYSTEM_ANDROID = 0,
        .SDL_FILESYSTEM_HAIKU = 0,
        .SDL_FILESYSTEM_COCOA = 0,
        .SDL_FILESYSTEM_DUMMY = 0,
        .SDL_FILESYSTEM_RISCOS = 0,
        .SDL_FILESYSTEM_UNIX = is_unix,
        .SDL_FILESYSTEM_WINDOWS = 0,
        .SDL_FILESYSTEM_EMSCRIPTEN = 0,
        .SDL_FILESYSTEM_VITA = 0,
        .SDL_FILESYSTEM_PSP = 0,
        .SDL_FILESYSTEM_PS2 = 0,
        .SDL_FILESYSTEM_N3DS = 0,

        // Enable system storage support
        .SDL_STORAGE_GENERIC = is_unix,
        .SDL_STORAGE_STEAM = 0,

        // Enable system FSops support
        .SDL_FSOPS_POSIX = is_posix,
        .SDL_FSOPS_WINDOWS = 0,
        .SDL_FSOPS_DUMMY = 0,

        // Enable camera subsystem
        .SDL_CAMERA_DRIVER_DUMMY = 0,
        .SDL_CAMERA_DRIVER_DISK = 0,
        .SDL_CAMERA_DRIVER_V4L2 = 0,
        .SDL_CAMERA_DRIVER_COREMEDIA = 0,
        .SDL_CAMERA_DRIVER_ANDROID = 0,
        .SDL_CAMERA_DRIVER_EMSCRIPTEN = 0,
        .SDL_CAMERA_DRIVER_MEDIAFOUNDATION = 0,
        .SDL_CAMERA_DRIVER_PIPEWIRE = 0,
        .SDL_CAMERA_DRIVER_PIPEWIRE_DYNAMIC = 0,
        .SDL_CAMERA_DRIVER_VITA = 0,

        // Enable dialog subsystem
        .SDL_DIALOG_DUMMY = 0,

        // Enable misc subsystem
        .SDL_MISC_DUMMY = 0,

        // Enable locale subsystem
        .SDL_LOCALE_DUMMY = 0,

        // Enable assembly routines
        .SDL_ALTIVEC_BLITTERS = 0,

        // Whether SDL_DYNAMIC_API needs dlopen
        .DYNAPI_NEEDS_DLOPEN = 0,

        // Enable ime support
        .SDL_USE_IME = 0,

        // Platform specific definitions
        .SDL_IPHONE_KEYBOARD = 0,
        .SDL_IPHONE_LAUNCHSCREEN = 0,

        .SDL_VIDEO_VITA_PIB = 0,
        .SDL_VIDEO_VITA_PVR = 0,
        .SDL_VIDEO_VITA_PVR_OGL = 0,

        // Libdecor version info
        .SDL_LIBDECOR_VERSION_MAJOR = 0,
        .SDL_LIBDECOR_VERSION_MINOR = 1,
        .SDL_LIBDECOR_VERSION_PATCH = 0,

        // Configure use of intrinsics
        .SDL_DISABLE_SSE = 1,
        .SDL_DISABLE_SSE2 = 1,
        .SDL_DISABLE_SSE3 = 1,
        .SDL_DISABLE_SSE4_1 = 1,
        .SDL_DISABLE_SSE4_2 = 1,
        .SDL_DISABLE_AVX = 1,
        .SDL_DISABLE_AVX2 = 1,
        .SDL_DISABLE_AVX512F = 1,
        .SDL_DISABLE_MMX = 1,
        .SDL_DISABLE_LSX = 1,
        .SDL_DISABLE_LASX = 1,
        .SDL_DISABLE_NEON = 1,
    });

    lib.addConfigHeader(config_h);
    lib.addIncludePath(upstream.path("include"));
    lib.addIncludePath(upstream.path("src"));

    lib.addCSourceFiles(.{
        .root = upstream.path("src"),
        .files = general_srcs,
    });

    // TODO: Integrate with subsystem detection and flags
    {
        lib.addCSourceFiles(.{
            .root = upstream.path("src"),
            .files = &.{
                "core/linux/SDL_evdev.c",
                "core/linux/SDL_evdev_capabilities.c",
                "core/linux/SDL_evdev_kbd.c",
                "core/linux/SDL_threadprio.c",

                "core/unix/SDL_appid.c",
                "core/unix/SDL_poll.c",

                "dialog/SDL_dialog_utils.c",
                "dialog/unix/SDL_portaldialog.c",
                "dialog/unix/SDL_unixdialog.c",
                "dialog/unix/SDL_zenitydialog.c",

                "filesystem/posix/SDL_sysfsops.c",

                "filesystem/unix/SDL_sysfilesystem.c",

                "haptic/linux/SDL_syshaptic.c",

                "joystick/hidapi/SDL_hidapi_combined.c",
                "joystick/hidapi/SDL_hidapi_gamecube.c",
                "joystick/hidapi/SDL_hidapijoystick.c",
                "joystick/hidapi/SDL_hidapi_luna.c",
                "joystick/hidapi/SDL_hidapi_ps3.c",
                "joystick/hidapi/SDL_hidapi_ps4.c",
                "joystick/hidapi/SDL_hidapi_ps5.c",
                "joystick/hidapi/SDL_hidapi_rumble.c",
                "joystick/hidapi/SDL_hidapi_shield.c",
                "joystick/hidapi/SDL_hidapi_stadia.c",
                "joystick/hidapi/SDL_hidapi_steam.c",
                "joystick/hidapi/SDL_hidapi_steamdeck.c",
                "joystick/hidapi/SDL_hidapi_steam_hori.c",
                "joystick/hidapi/SDL_hidapi_switch.c",
                "joystick/hidapi/SDL_hidapi_wii.c",
                "joystick/hidapi/SDL_hidapi_xbox360.c",
                "joystick/hidapi/SDL_hidapi_xbox360w.c",
                "joystick/hidapi/SDL_hidapi_xboxone.c",

                "joystick/linux/SDL_sysjoystick.c",
                "joystick/steam/SDL_steamcontroller.c",

                "loadso/dlopen/SDL_sysloadso.c",

                "locale/unix/SDL_syslocale.c",

                "main/generic/SDL_sysmain_callbacks.c",

                "misc/unix/SDL_sysurl.c",

                "power/linux/SDL_syspower.c",

                "process/SDL_process.c",

                "process/posix/SDL_posixprocess.c",

                "storage/generic/SDL_genericstorage.c",

                "thread/pthread/SDL_syscond.c",
                "thread/pthread/SDL_sysmutex.c",
                "thread/pthread/SDL_sysrwlock.c",
                "thread/pthread/SDL_syssem.c",
                "thread/pthread/SDL_systhread.c",
                "thread/pthread/SDL_systls.c",

                "time/unix/SDL_systime.c",

                "timer/unix/SDL_systimer.c",
            },
        });

        lib.addCSourceFiles(.{
            .root = upstream.path("src"),
            .files = &.{
                "video/x11/edid-parse.c",
                "video/x11/SDL_x11clipboard.c",
                "video/x11/SDL_x11dyn.c",
                "video/x11/SDL_x11events.c",
                "video/x11/SDL_x11framebuffer.c",
                "video/x11/SDL_x11keyboard.c",
                "video/x11/SDL_x11messagebox.c",
                "video/x11/SDL_x11modes.c",
                "video/x11/SDL_x11mouse.c",
                "video/x11/SDL_x11opengl.c",
                "video/x11/SDL_x11opengles.c",
                "video/x11/SDL_x11pen.c",
                "video/x11/SDL_x11settings.c",
                "video/x11/SDL_x11shape.c",
                "video/x11/SDL_x11touch.c",
                "video/x11/SDL_x11video.c",
                "video/x11/SDL_x11vulkan.c",
                "video/x11/SDL_x11window.c",
                "video/x11/SDL_x11xfixes.c",
                "video/x11/SDL_x11xinput2.c",
                "video/x11/xsettings-client.c",
            },
        });
        lib.linkSystemLibrary("X11");
        lib.linkSystemLibrary("Xext");
    }

    lib.installHeadersDirectory(upstream.path("include/SDL3"), "SDL3", .{});

    const revision_h = b.addConfigHeader(.{
        .style = .{ .cmake = upstream.path("include/build_config/SDL_revision.h.cmake") },
        .include_path = "SDL3/SDL_revision.h",
    }, .{
        .SDL_REVISION = "preview-3.1.6",
        .SDL_VENDOR_INFO = "allyourcodebase.com",
    });
    lib.addConfigHeader(revision_h);
    lib.installHeader(revision_h.getOutput(), "SDL3/SDL_revision.h");

    b.installArtifact(lib);

    const examples = .{
        "clear",
        "primitives",
        "lines",
        "points",
        "rectangles",
    };
    inline for (examples, 1..) |example, i| {
        const exe = b.addExecutable(.{
            .name = example,
            .target = target,
            .optimize = optimize,
        });
        const src = std.fmt.comptimePrint("examples/renderer/{d:0>2}-{s}/{s}.c", .{ i, example, example });
        exe.addCSourceFile(.{
            .file = upstream.path(src),
        });
        exe.linkLibrary(lib);
        b.installArtifact(exe);
    }
}

// General source files.
const general_srcs: []const []const u8 = &.{
    "SDL.c",
    "SDL_assert.c",
    "SDL_error.c",
    "SDL_guid.c",
    "SDL_hashtable.c",
    "SDL_hints.c",
    "SDL_list.c",
    "SDL_log.c",
    "SDL_properties.c",
    "SDL_utils.c",

    "atomic/SDL_atomic.c",
    "atomic/SDL_spinlock.c",

    "audio/SDL_audio.c",
    "audio/SDL_audiocvt.c",
    "audio/SDL_audiodev.c",
    "audio/SDL_audioqueue.c",
    "audio/SDL_audioresample.c",
    "audio/SDL_audiotypecvt.c",
    "audio/SDL_mixer.c",
    "audio/SDL_wave.c",

    "camera/SDL_camera.c",

    "core/SDL_core_unsupported.c",

    "cpuinfo/SDL_cpuinfo.c",

    "dynapi/SDL_dynapi.c",

    "events/imKStoUCS.c",
    "events/SDL_categories.c",
    "events/SDL_clipboardevents.c",
    "events/SDL_displayevents.c",
    "events/SDL_dropevents.c",
    "events/SDL_events.c",
    "events/SDL_keyboard.c",
    "events/SDL_keymap.c",
    "events/SDL_keysym_to_scancode.c",
    "events/SDL_mouse.c",
    "events/SDL_pen.c",
    "events/SDL_quit.c",
    "events/SDL_scancode_tables.c",
    "events/SDL_touch.c",
    "events/SDL_windowevents.c",

    "file/SDL_iostream.c",

    "filesystem/SDL_filesystem.c",

    "gpu/SDL_gpu.c",

    "joystick/controller_type.c",
    "joystick/SDL_gamepad.c",
    "joystick/SDL_joystick.c",
    "joystick/SDL_steam_virtual_gamepad.c",

    "haptic/SDL_haptic.c",

    "hidapi/SDL_hidapi.c",

    "locale/SDL_locale.c",

    "main/SDL_main_callbacks.c",
    "main/SDL_runapp.c",

    "misc/SDL_url.c",

    "power/SDL_power.c",

    "render/SDL_d3dmath.c",
    "render/SDL_render.c",
    "render/SDL_render_unsupported.c",
    "render/SDL_yuv_sw.c",

    "render/direct3d11/SDL_render_d3d11.c",
    "render/direct3d11/SDL_shaders_d3d11.c",

    "render/direct3d12/SDL_render_d3d12.c",
    "render/direct3d12/SDL_shaders_d3d12.c",

    "render/direct3d/SDL_render_d3d.c",
    "render/direct3d/SDL_shaders_d3d.c",

    "render/gpu/SDL_pipeline_gpu.c",
    "render/gpu/SDL_render_gpu.c",
    "render/gpu/SDL_shaders_gpu.c",

    "render/opengles2/SDL_render_gles2.c",
    "render/opengles2/SDL_shaders_gles2.c",

    "render/opengl/SDL_render_gl.c",
    "render/opengl/SDL_shaders_gl.c",

    "render/ps2/SDL_render_ps2.c",

    "render/psp/SDL_render_psp.c",

    "render/software/SDL_blendfillrect.c",
    "render/software/SDL_blendline.c",
    "render/software/SDL_blendpoint.c",
    "render/software/SDL_drawline.c",
    "render/software/SDL_drawpoint.c",
    "render/software/SDL_render_sw.c",
    "render/software/SDL_rotate.c",
    "render/software/SDL_triangle.c",

    "render/vitagxm/SDL_render_vita_gxm.c",
    "render/vitagxm/SDL_render_vita_gxm_memory.c",
    "render/vitagxm/SDL_render_vita_gxm_tools.c",

    "render/vulkan/SDL_render_vulkan.c",
    "render/vulkan/SDL_shaders_vulkan.c",

    "sensor/SDL_sensor.c",

    "stdlib/SDL_crc16.c",
    "stdlib/SDL_crc32.c",
    "stdlib/SDL_getenv.c",
    "stdlib/SDL_iconv.c",
    "stdlib/SDL_malloc.c",
    "stdlib/SDL_memcpy.c",
    "stdlib/SDL_memmove.c",
    "stdlib/SDL_memset.c",
    "stdlib/SDL_mslibc.c",
    "stdlib/SDL_murmur3.c",
    "stdlib/SDL_qsort.c",
    "stdlib/SDL_random.c",
    "stdlib/SDL_stdlib.c",
    "stdlib/SDL_string.c",
    "stdlib/SDL_strtokr.c",

    "storage/SDL_storage.c",

    "thread/SDL_thread.c",

    "time/SDL_time.c",

    "timer/SDL_timer.c",

    "video/SDL_blit_0.c",
    "video/SDL_blit_1.c",
    "video/SDL_blit_A.c",
    "video/SDL_blit_auto.c",
    "video/SDL_blit.c",
    "video/SDL_blit_copy.c",
    "video/SDL_blit_N.c",
    "video/SDL_blit_slow.c",
    "video/SDL_bmp.c",
    "video/SDL_clipboard.c",
    "video/SDL_egl.c",
    "video/SDL_fillrect.c",
    "video/SDL_pixels.c",
    "video/SDL_rect.c",
    "video/SDL_RLEaccel.c",
    "video/SDL_stretch.c",
    "video/SDL_surface.c",
    "video/SDL_video.c",
    "video/SDL_video_unsupported.c",
    "video/SDL_vulkan_utils.c",
    "video/SDL_yuv.c",

    "video/yuv2rgb/yuv_rgb_lsx.c",
    "video/yuv2rgb/yuv_rgb_sse.c",
    "video/yuv2rgb/yuv_rgb_std.c",
};
