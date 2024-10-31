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

    const config_h = b.addConfigHeader(.{
        .include_path = "SDL_build_config.h",
        .style = .{ .cmake = upstream.path("include/build_config/SDL_build_config.h.cmake") },
    }, .{
        .SDL_DEFAULT_ASSERT_LEVEL_CONFIGURED = 1,
    });

    lib.addConfigHeader(config_h);
    lib.addIncludePath(upstream.path("include"));
    lib.addIncludePath(upstream.path("src"));

    lib.addCSourceFiles(.{
        .root = upstream.path("src"),
        .files = general_srcs,
    });

    lib.installConfigHeader(config_h);

    b.installArtifact(lib);
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
