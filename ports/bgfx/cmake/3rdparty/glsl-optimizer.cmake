file(GLOB_RECURSE GLSL_OPTIMIZER_SOURCES
  3rdparty/glsl-optimizer/src/mesa/*.c
  3rdparty/glsl-optimizer/src/mesa/*.h
  3rdparty/glsl-optimizer/src/glsl/*.c
  3rdparty/glsl-optimizer/src/glsl/*.cpp
  3rdparty/glsl-optimizer/src/glsl/*.h
  3rdparty/glsl-optimizer/src/util/*.c
  3rdparty/glsl-optimizer/src/util/*.h)
file(GLOB_RECURSE GLSL_OPTIMIZER_EXCLUDED
  3rdparty/glsl-optimizer/src/glsl/glcpp/glcpp.c
  3rdparty/glsl-optimizer/src/glsl/glcpp/test/*
  3rdparty/glsl-optimizer/src/glsl/glcpp/*.l
  3rdparty/glsl-optimizer/src/glsl/glcpp/*.y
  3rdparty/glsl-optimizer/src/ir_set_program_inouts.cpp
  3rdparty/glsl-optimizer/src/glsl/main.cpp
  3rdparty/glsl-optimizer/src/glsl/builtin_stubs.cpp)
list(REMOVE_ITEM GLSL_OPTIMIZER_SOURCES ${GLSL_OPTIMIZER_EXCLUDED})

add_library(glsl-optimizer ${GLSL_OPTIMIZER_SOURCES})
add_library(bgfx::glsl-optimizer ALIAS glsl-optimizer)
target_compile_definitions(glsl-optimizer
  PRIVATE
    ENABLE_OPT=1
    ENABLE_HLSL=1)
target_include_directories(glsl-optimizer
  PUBLIC
    3rdparty/glsl-optimizer/src
    3rdparty/glsl-optimizer/include
    3rdparty/glsl-optimizer/src/mesa
    3rdparty/glsl-optimizer/src/mapi
    3rdparty/glsl-optimizer/src/glsl)
