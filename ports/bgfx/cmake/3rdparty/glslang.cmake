file(GLOB_RECURSE GLSLANG_SOURCES
  3rdparty/glslang/glslang/*.cpp
  3rdparty/glslang/glslang/*.h
  3rdparty/glslang/hlsl/*.cpp
  3rdparty/glslang/hlsl/*.h
  3rdparty/glslang/SPIRV/*.cpp
  3rdparty/glslang/SPIRV/*.h
  3rdparty/glslang/OGLCompilersDLL/*.cpp
  3rdparty/glslang/OGLCompilersDLL/*.h)

if(WIN32)
  file(GLOB GLSLANG_EXCLUDED
    3rdparty/glslang/glslang/OSDependent/Unix/ossource.cpp)
  list(REMOVE_ITEM GLSLANG_SOURCES ${GLSLANG_EXCLUDED})
else()
  file(GLOB GLSLANG_EXCLUDED
    3rdparty/glslang/glslang/OSDependent/Windows/main.cpp
    3rdparty/glslang/glslang/OSDependent/Windows/ossource.cpp)
  list(REMOVE_ITEM GLSLANG_SOURCES ${GLSLANG_EXCLUDED})
endif()

add_library(glslang ${GLSLANG_SOURCES})
add_library(bgfx::glslang ALIAS glslang)
target_link_libraries(glslang PRIVATE spirv-opt)
target_compile_features(glslang PUBLIC cxx_std_11)
target_compile_definitions(glslang
  PRIVATE
    ENABLE_OPT=1
    ENABLE_HLSL=1)
target_include_directories(glslang
  PUBLIC
    3rdparty/glslang
    3rdparty/glslang/glslang/Public
    3rdparty/glslang/glslang/Include)
