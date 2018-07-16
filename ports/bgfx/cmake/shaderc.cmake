file(GLOB_RECURSE SHADERC_SOURCES
  tools/shaderc/*.cpp
  tools/shaderc/*.h
  tools/vertexdecl.*
  src/shader_spirv.*)

add_executable(shaderc ${SHADERC_SOURCES})
add_executable(bgfx::shaderc ALIAS shaderc)
target_link_libraries(shaderc
    bx::bx
    bimg::bimg
    bgfx
    fcpp
    glslang
    glsl-optimizer)
