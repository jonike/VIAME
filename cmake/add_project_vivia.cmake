# vivia External Project
#
# Required symbols are:
#   VIAME_BUILD_PREFIX - where packages are built
#   VIAME_BUILD_INSTALL_PREFIX - directory install target
#   VIAME_PACKAGES_DIR - location of git submodule packages
#   VIAME_ARGS_COMMON -
##

set( VIAME_PROJECT_LIST ${VIAME_PROJECT_LIST} vivia )

if( WIN32 )
  set( VIAME_QMAKE_EXE ${VIAME_BUILD_INSTALL_PREFIX}/bin/qmake.exe )
else()
  set( VIAME_QMAKE_EXE ${VIAME_BUILD_INSTALL_PREFIX}/bin/qmake )
endif()

if( APPLE )
  set( VIVIA_DISABLE_FIXUP OFF )
else()
  set( VIVIA_DISABLE_FIXUP ON )
endif()

ExternalProject_Add(vivia
  DEPENDS fletch burnout kwiver
  PREFIX ${VIAME_BUILD_PREFIX}
  SOURCE_DIR ${VIAME_PACKAGES_DIR}/vivia
  CMAKE_GENERATOR ${gen}
  CMAKE_CACHE_ARGS
    ${VIAME_ARGS_COMMON}
    ${VIAME_ARGS_fletch}
    ${VIAME_ARGS_burnout}
    ${VIAME_ARGS_kwiver}
    ${VIAME_ARGS_libkml}
    ${VIAME_ARGS_PROJ4}
    ${VIAME_ARGS_VTK}
    ${VIAME_ARGS_VXL_INSTALL}

    # Required
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DVISGUI_ENABLE_VIDTK:BOOL=OFF

    -DVISGUI_ENABLE_VIQUI:BOOL=${VIAME_ENABLE_SMQTK}
    -DVISGUI_ENABLE_VSPLAY:BOOL=ON
    -DVISGUI_ENABLE_VPVIEW:BOOL=ON
    -DVISGUI_ENABLE_GDAL:BOOL=${VIAME_ENABLE_GDAL}

    -DVISGUI_ENABLE_FAKE_STREAM_SOURCE:BOOL=OFF
    -DVSPSS_ENABLE_FAKE_STREAM_SOURCE:BOOL=OFF
    -DVSPUI_ENABLE_CONTEXT_VIEW:BOOL=OFF
    -DVSPUI_ENABLE_CONTEXT_VIEWER:BOOL=OFF
    -DVSPUI_ENABLE_EVENT_CREATION_TOOL:BOOL=OFF
    -DVSPUI_ENABLE_EVENT_CREATION_TOOLS:BOOL=OFF
    -DVSPUI_ENABLE_KML_EXPORT:BOOL=OFF
    -DVSPUI_ENABLE_REPORT_GENERATOR:BOOL=OFF
    -DVISGUI_ENABLE_KWIVER:BOOL=${VIAME_ENABLE_KWIVER}
    -DVVQS_ENABLE_FAKE_BACKEND:BOOL=OFF
    -DVISGUI_DISABLE_FIXUP_BUNDLE:BOOL=${VIVIA_DISABLE_FIXUP}

    -DLIBJSON_INCLUDE_DIR:PATH=${VIAME_BUILD_INSTALL_PREFIX}/include/json
    -DQT_QMAKE_EXECUTABLE:PATH=${VIAME_QMAKE_EXE}

  INSTALL_DIR ${VIAME_BUILD_INSTALL_PREFIX}
  )

if( VIAME_FORCEBUILD )
  ExternalProject_Add_Step(vivia forcebuild
    COMMAND ${CMAKE_COMMAND}
      -E remove ${VIAME_BUILD_PREFIX}/src/vivia-stamp/vivia-build
    COMMENT "Removing build stamp file for build update (forcebuild)."
    DEPENDEES configure
    DEPENDERS build
    ALWAYS 1
    )
endif()

set(VIAME_ARGS_vivia
  -Dvivia_DIR:PATH=${VIAME_BUILD_PREFIX}/src/vivia-build
  )
