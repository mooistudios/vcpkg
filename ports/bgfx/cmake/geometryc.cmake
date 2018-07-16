file(GLOB_RECURSE GEOMETRYC_SOURCES
  src/vertexdecl.*
  tools/geometryc/*.cpp
  tools/geometryc/*.h
  examples/common/bounds.*)

add_executable(geometryc ${GEOMETRYC_SOURCES})
add_executable(bgfx::geometryc ALIAS geometryc)
target_link_libraries(geometryc bx::bx bgfx ib-compress forsyth-too)
target_include_directories(geometryc PRIVATE 3rdparty examples/common)
