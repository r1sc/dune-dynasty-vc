set(DUNEDYNASTY_SRC_FILES
	src/ai.c
	src/animation.c
	src/audio/adl/fmopl.cpp
	src/audio/adl/opl_dosbox.cpp
	src/audio/adl/opl_mame.cpp
	src/audio/adl/sound_adlib.cpp
	src/audio/audio.c
	src/audio/audio_a5.cpp
	src/audio/mt32mpu.c
	src/binheap.c
	src/buildqueue.c
	src/codec/format40.c
	src/codec/format80.c
	src/common_a5.c
	src/config_a5.c
	src/crashlog/crashlog_none.c
	src/cutscene.c
	src/enhancement.c
	src/explosion.c
	src/file.c
	src/gameloop.c
	src/gfx.c
	src/gui/editbox.c
	src/gui/font.c
	src/gui/gui.c
	src/gui/mentat.c
	src/gui/viewport.c
	src/gui/widget.c
	src/gui/widget_click.c
	src/gui/widget_draw.c
	src/house.c
	src/ini.c
	src/input/input_a5.c
	src/input/input_dd.c
	src/input/mouse_dd.c
	src/load.c
	src/map.c
	src/mapgenerator/skirmish.c
	src/net/server.c
	src/newui/actionpanel.c
	src/newui/halloffame.c
	src/newui/mentat.c
	src/newui/menu.c
	src/newui/menubar.c
	src/newui/savemenu.c
	src/newui/scrollbar.c
	src/newui/slider.c
	src/newui/strategicmap.c
	src/newui/viewport.c
	src/object.c
	src/opendune.c
	src/os/endian.c
	src/pool/house.c
	src/pool/structure.c
	src/pool/team.c
	src/pool/unit.c
	src/save.c
	src/saveload/house.c
	src/saveload/info.c
	src/saveload/map.c
	src/saveload/object.c
	src/saveload/saveload.c
	src/saveload/scenario.c
	src/saveload/scriptengine.c
	src/saveload/structure.c
	src/saveload/team.c
	src/saveload/unit.c
	src/scenario.c
	src/script/general.c
	src/script/script.c
	src/script/structure.c
	src/script/team.c
	src/script/unit.c
	src/shape.c
	src/sprites.c
	src/string.c
	src/structure.c
	src/table/animation.c
	src/table/explosion.c
	src/table/fileinfo.c
	src/table/houseanimation.c
	src/table/houseinfo.c
	src/table/landscapeinfo.c
	src/table/locale.c
	src/table/selectiontype.c
	src/table/sound.c
	src/table/structureinfo.c
	src/table/teamaction.c
	src/table/tilediff.c
	src/table/unitinfo.c
	src/table/widget.c
	src/table/widgetinfo.c
	src/table/windowdesc.c
	src/team.c
	src/tile.c
	src/timer/timer.c
	src/timer/timer_a5.c
	src/tools/coord.c
	src/tools/encoded_index.c
	src/tools/orientation.c
	src/tools/random_general.c
	src/tools/random_lcg.c
	src/tools/random_starport.c
	src/tools/random_xorshift.c
	src/unit.c
	src/video/prim_a5.c
	src/video/video_a5.c
	src/wsa.c
	)

if(WIN32)
    set(DUNEDYNASTY_SRC_FILES
	${DUNEDYNASTY_SRC_FILES} src/audio/midi_win32.c)
elseif(APPLE)
    set(DUNEDYNASTY_SRC_FILES
	${DUNEDYNASTY_SRC_FILES} src/audio/midi_osx.c)
elseif(WITH_ALSA_MIDI)
    set(DUNEDYNASTY_SRC_FILES
	${DUNEDYNASTY_SRC_FILES} src/audio/midi_alsa.c)
else()
    set(DUNEDYNASTY_SRC_FILES
	${DUNEDYNASTY_SRC_FILES} src/audio/midi_none.c)
endif()

if(WITH_FLUIDSYNTH)
    set(DUNEDYNASTY_SRC_FILES
	${DUNEDYNASTY_SRC_FILES}
	src/audio/allegro_midi.cpp
	src/audio/xmi/xmidi.cpp
	)
endif(WITH_FLUIDSYNTH)

if(WITH_MAD)
    set(DUNEDYNASTY_SRC_FILES
	${DUNEDYNASTY_SRC_FILES} src/audio/allegro_mad.c)
endif(WITH_MAD)

if(WITH_AUD)
    set(DUNEDYNASTY_SRC_FILES
	${DUNEDYNASTY_SRC_FILES} src/audio/audlib/audlib_a5.c)
endif(WITH_AUD)

if(WIN32)
    set(DUNEDYNASTY_SRC_FILES
	${DUNEDYNASTY_SRC_FILES} src/os/error_win32.c)
else(WIN32)
    set(DUNEDYNASTY_SRC_FILES
	${DUNEDYNASTY_SRC_FILES} src/os/error.c)
endif(WIN32)

set(OPENDUNE_UNUSED_SRC_FILES
	src/audio/driver.c
	src/audio/sound.c
	src/config.c
	src/crashlog/crashlog.c
	src/crashlog/crashlog_win32.c
	src/os/thread_sdl.c
	src/os/thread_win32.c
	)
