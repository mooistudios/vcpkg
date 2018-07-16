add_library(example-glue STATIC examples/common/example-glue.cpp)
add_library(bgfx::example-glue ALIAS example-glue)
target_link_libraries(example-glue bx::bx bimg::bimg)
target_include_directories(example-glue PRIVATE include 3rdparty)



file(GLOB_RECURSE EXAMPLE_COMMON_SOURCES
  examples/common/*.cpp
  examples/common/*.mm
  examples/common/*.h)

file(GLOB EXAMPLE_COMMON_AMALGAMATED src/amalgamated.*)
list(REMOVE_ITEM EXAMPLE_COMMON_SOURCES ${EXAMPLE_COMMON_AMALGAMATED})

file(GLOB EXAMPLE_COMMON_EXCLUDED
  src/*.bin.h
  examples/common/example-glue.cpp)
list(REMOVE_ITEM EXAMPLE_COMMON_SOURCES ${EXAMPLE_COMMON_EXCLUDED})

if(NOT APPLE)
  file(GLOB EXAMPLE_COMMON_MM_SOURCES src/*.mm)
  list(APPEND EXAMPLE_COMMON_SOURCES ${EXAMPLE_COMMON_MM_SOURCES})
endif()

add_library(example-common STATIC ${EXAMPLE_COMMON_SOURCES})
add_library(bgfx::example-common ALIAS example-common)
target_link_libraries(example-common
  bx::bx
  bimg::bimg
  bimg::bimg_decode
  bgfx
  ib-compress
  dear-imgui)
target_include_directories(example-common PUBLIC 3rdparty examples/common)

if(WITH_SCINTILLA)
  target_compile_definitions(example-common SCI_NAMESPACE SCI_LEXER)
  target_include_directories(example-common
      3rdparty/scintilla/include
      3rdparty/scintilla/lexlib)
  file(GLOB_RECURSE EXAMPLE_COMMON_SCINTILLA_SOURCES
    3rdparty/scintilla/src/*.cxx
    3rdparty/scintilla/src/*.h
    3rdparty/scintilla/lexlib/*.cxx
    3rdparty/scintilla/lexlib/*.h
    3rdparty/scintilla/lexers/*.cxx)
  target_sources(example-common ${EXAMPLE_COMMON_SCINTILLA_SOURCES})
endif()

if(WITH_SDL)
  find_package(SDL2 REQUIRED)
  target_link_libraries(example-common SDL2::SDL2 SDL2::SDL2main)
  target_compile_definitions(example-common PUBLIC ENTRY_CONFIG_USE_SDL=1)
endif()

if(WITH_GLFW)
  find_package(glfw3 REQUIRED)
  target_link_libraries(example-common glfw)
  target_compile_definitions(example-common PUBLIC ENTRY_CONFIG_USE_GLFW=1)
endif()
