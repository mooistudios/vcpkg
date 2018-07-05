cmake_minimum_required(VERSION 3.11)
project(nanovg C)

set(NANOVG_SOURCES src/nanovg.c)
set(NANOVG_HEADERS src/nanovg.h
                   src/nanovg_gl.h
                   src/nanovg_gl_utils.h)

add_library(nanovg ${NANOVG_SOURCES} ${NANOVG_HEADERS})
set_target_properties(nanovg
  PROPERTIES
  PUBLIC_HEADER "${NANOVG_HEADERS}")
target_include_directories(nanovg PRIVATE 3rdparty/nanovg/src)

#target_compile_definitions(nanovg PRIVATE -D_CRT_SECURE_NO_WARNINGS)

install(TARGETS nanovg
  EXPORT nanovgTargets
  RUNTIME DESTINATION bin
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  PUBLIC_HEADER DESTINATION include)

include(CMakePackageConfigHelpers)
#write_basic_package_version_file(nanovgConfigVersion.cmake COMPATIBILITY SameMajorVersion)
install(EXPORT nanovgTargets DESTINATION share/nanovg)
install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/nanovgConfig.cmake
  #${CMAKE_CURRENT_BINARY_DIR}/nanovgConfigVersion.cmake
  DESTINATION share/nanovg)
