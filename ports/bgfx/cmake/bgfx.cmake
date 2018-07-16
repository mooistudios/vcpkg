file(GLOB BGFX_SOURCES
  include/*.h
  src/*.cpp
  src/*.mm
  src/*.h
  scripts/*.natvis)

file(GLOB BGFX_AMALGAMATED src/amalgamated.*)
list(REMOVE_ITEM BGFX_SOURCES ${BGFX_AMALGAMATED})
file(GLOB BGFX_EXCLUDED src/*.bin.h)
list(REMOVE_ITEM BGFX_SOURCES ${BGFX_EXCLUDED})

if(NOT APPLE)
  file(GLOB BGFX_MM_SOURCES src/*.mm)
  list(REMOVE_ITEM BGFX_SOURCES ${BGFX_MM_SOURCES})
endif()

add_library(bgfx ${BGFX_SOURCES})
add_library(bgfx::bgfx ALIAS bgfx)
target_compile_definitions(bgfx PUBLIC BGFX_CONFIG_MULTITHREADED=0)
target_link_libraries(bgfx PRIVATE bx::bx bimg::bimg)
target_include_directories(bgfx PRIVATE 3rdparty
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>)

target_include_directories(bgfx PRIVATE 3rdparty/khronos)

if(APPLE)
  find_library(COCOA_LIBRARY Cocoa)
  find_library(METAL_LIBRARY Metal)
  find_library(QUARTZCORE_LIBRARY QuartzCore)
  mark_as_advanced(COCOA_LIBRARY)
  mark_as_advanced(METAL_LIBRARY)
  mark_as_advanced(QUARTZCORE_LIBRARY)
  target_link_libraries(bgfx
    PUBLIC
      ${COCOA_LIBRARY} ${METAL_LIBRARY} ${QUARTZCORE_LIBRARY})
elseif(ANDROID)
  find_library(EGL_LIBRARY psapi)
  find_library(GLESv2_LIBRARY gdi32)
  target_link_libraries(bgfx PUBLIC ${EGL_LIBRARY} ${GLESv2_LIBRARY})
elseif(UNIX)
  find_package(OpenGL REQUIRED)
  find_package(X11 REQUIRED)
  target_link_libraries(bgfx PUBLIC X11 OpenGL::GL)
elseif(WIN32)
  find_library(PSAPI_LIBRARY psapi)
  find_library(GDI_LIBRARY gdi32)
  target_link_libraries(bgfx PUBLIC ${PSAPI_LIBRARY} ${GDI_LIBRARY})
  target_include_directories(bgfx PRIVATE 3rdparty/dxsdk/include)
endif()
