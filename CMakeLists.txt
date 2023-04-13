cmake_minimum_required(VERSION 3.15)

set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake CACHE STRING "Vcpkg toolchain file")

project(dunedynasty)

set(DUNE_DYNASTY_VERSION 1.5)

set(DUNE_DATA_DIR "." CACHE PATH "Directory containing game data")

if(WIN32 OR APPLE)
	set(WITH_ALSA_MIDI OFF)
else()
	option(WITH_ALSA_MIDI "ALSA MIDI music" ON)
endif()

option(WITH_ACODEC "FLAC and Ogg Vorbis music" OFF)
option(WITH_AUD "AUD music (Dune 2000)" OFF)
option(WITH_ENET "ENet (multiplayer)" OFF)
option(WITH_FLUIDSYNTH "FluidSynth MIDI music" OFF)
option(WITH_MAD "MP3 music" OFF)
option(PANDORA "Set to ON if targeting an OpenPandora device")

if(NOT DUNE_DATA_DIR)
	set(DUNE_DATA_DIR ".")
endif(NOT DUNE_DATA_DIR)

# ----------------------------------------------------------------
include(cmake/FileList.cmake)
include_directories("include" "${PROJECT_BINARY_DIR}/include")
add_executable(dunedynasty WIN32
	${DUNEDYNASTY_SRC_FILES} ${CMAKE_SOURCE_DIR}/src/icon/icon.rc)

if(MINGW)
	# Work around cmake bug #12480 when cross-compiling.
	# Fixed in cmake commit 6ddb1e5b
	include(Platform/Windows-windres)
elseif(PANDORA)
	add_definitions(-D__PANDORA__)
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Wmissing-prototypes -Wstrict-prototypes -Wold-style-definition -pedantic")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -W -Wall -Wno-unused-parameter")

find_package(unofficial-allegro5 CONFIG REQUIRED)
if(APPLE)
	pkg_check_modules(ALLEGRO5_MAIN REQUIRED allegro_main-${ALLEGRO_VERSION})
endif(APPLE)

find_path(ALLEGRO5_INCLUDE_DIRS allegro5/allegro.h)
include_directories(SYSTEM ${ALLEGRO5_INCLUDE_DIRS})
 target_link_libraries(dunedynasty unofficial-allegro5::allegro unofficial-allegro5::allegro_main unofficial-allegro5::allegro_audio unofficial-allegro5::allegro_acodec unofficial-allegro5::allegro_video unofficial-allegro5::allegro_memfile unofficial-allegro5::allegro_primitives unofficial-allegro5::allegro_image)


if(PANDORA)
	find_package(OpenGLES)
	include_directories(SYSTEM ${OPENGLES_INCLUDE_DIR})
	set(OPENGL_LIBRARIES ${OPENGLES_LIBRARIES})
else(PANDORA)
	find_package(OpenGL)
	include_directories(SYSTEM ${OPENGL_INCLUDE_DIR})
endif(PANDORA)

if(WITH_ACODEC)
    #pkg_check_modules(ALLEGRO5_ACODEC allegro_acodec-${ALLEGRO_VERSION})
    #if(ALLEGRO5_ACODEC_FOUND)
	list(APPEND OPTIONAL_LIBRARIES ${ALLEGRO5_ACODEC_LIBRARIES})
    #elseif(ALLEGRO5_ACODEC_FOUND)
	#message("Allegro 5 audio codecs addon not found")
	#set(WITH_ACODEC OFF)
    #endif(ALLEGRO5_ACODEC_FOUND)
endif(WITH_ACODEC)

if(WIN32)
	target_link_libraries(dunedynasty winmm)
elseif(APPLE)
	find_library(AUDIOTOOLBOX_LIBRARY AudioToolbox)
	find_library(AUDIOUNIT_LIBRARY AudioUnit)
	list(APPEND OPTIONAL_LIBRARIES ${AUDIOTOOLBOX_LIBRARY} ${AUDIOUNIT_LIBRARY})
elseif(WITH_ALSA_MIDI)
    pkg_check_modules(ALSA alsa)
    if(ALSA_FOUND)
	include_directories(SYSTEM ${ALSA_INCLUDE_DIRS})
	list(APPEND OPTIONAL_LIBRARIES ${ALSA_LIBRARIES})
    else(ALSA_FOUND)
	message("ALSA not found")
	set(WITH_ALSA_MIDI OFF)
    endif(ALSA_FOUND)
endif()

if(WITH_ENET)
	find_package(unofficial-enet CONFIG REQUIRED)
	include_directories(SYSTEM ${unofficial-ENet_INCLUDE_DIRS})
	target_link_libraries(dunedynasty unofficial::enet::enet)
endif(WITH_ENET)

if(WITH_FLUIDSYNTH)
    find_package(FluidSynth CONFIG REQUIRED)
    
    include_directories(SYSTEM ${FLUIDSYNTH_INCLUDE_DIRS})
    list(APPEND OPTIONAL_LIBRARIES ${FLUIDSYNTH_LIBRARIES})
endif(WITH_FLUIDSYNTH)

if(WITH_MAD)
    if(MINGW)
	# MINGW MAD missing a package config file.
	set(MAD_LIBRARIES "mad")
	set(MAD_FOUND ON)
    else(MINGW)
	pkg_check_modules(MAD mad)
    endif(MINGW)

    if(MAD_FOUND)
	include_directories(SYSTEM ${MAD_INCLUDE_DIRS})
	list(APPEND OPTIONAL_LIBRARIES ${MAD_LIBRARIES})
    else(MAD_FOUND)
	message("MAD not found")
	set(WITH_MAD OFF)
    endif(MAD_FOUND)
endif(WITH_MAD)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "dist")
configure_file("${CMAKE_SOURCE_DIR}/include/buildcfg.h.in" "${PROJECT_BINARY_DIR}/include/buildcfg.h")





target_link_libraries(dunedynasty
	${OPTIONAL_LIBRARIES}
	${ALLEGRO5_IMAGE_LDFLAGS}
	${ALLEGRO5_MEMFILE_LDFLAGS}
	${ALLEGRO5_PRIMITIVES_LDFLAGS}
	${ALLEGRO5_MAIN_LDFLAGS}
	${ALLEGRO5_LDFLAGS}
	${OPENGL_LIBRARIES}
	)

install(TARGETS dunedynasty DESTINATION "bin")
install(FILES
	${CMAKE_SOURCE_DIR}/CHANGES.txt
	${CMAKE_SOURCE_DIR}/COPYING
	${CMAKE_SOURCE_DIR}/README_dd.txt
	${CMAKE_SOURCE_DIR}/enhancement.txt
	${CMAKE_SOURCE_DIR}/opendune.txt
	${CMAKE_SOURCE_DIR}/dist/dunedynasty.cfg-sample
	DESTINATION "doc/dunedynasty-${DUNE_DYNASTY_VERSION}")

if(IS_ABSOLUTE ${DUNE_DATA_DIR})
    foreach(subdir campaign data gfx music)
	install(DIRECTORY "${CMAKE_SOURCE_DIR}/dist/${subdir}" DESTINATION "${DUNE_DATA_DIR}")
    endforeach(subdir)
endif(IS_ABSOLUTE ${DUNE_DATA_DIR})
