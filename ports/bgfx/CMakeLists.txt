cmake_minimum_required(VERSION 3.11 FATAL_ERROR)

project(bgfx CXX C)

find_package(bx REQUIRED)
find_package(bimg REQUIRED)

option(WITH_OVR "Enable OculusVR integration.")
option(WITH_SDL "Enable SDL entry.")
option(WITH_GLFW "Enable GLFW entry.")
option(WITH_PROFILER "Enable building intrusive profiler.")
option(WITH_SCINTILLA "Enable building Scintilla editor.")
option(WITH_TOOLS "Enable building tools.")
option(WITH_EXAMPLES "Enable building examples.")
option(WITH_COMBINED_EXAMPLES "Enable building examples (combined as single executable).")

set(TOOLS_DESTINATION "bin" CACHE STRING "Destination path to install tools.")
set(EXAMPLES_DESTINATION "bin" CACHE STRING "Destination path to install tools.")



if(UNIX AND NOT APPLE)
  set(CMAKE_POSITION_INDEPENDENT_CODE ON)
endif()

include(cmake/3rdparty/dear-imgui.cmake)
include(cmake/3rdparty/nanovg.cmake)
include(cmake/3rdparty/forsyth-too.cmake)
include(cmake/3rdparty/ib-compress.cmake)
include(cmake/3rdparty/fcpp.cmake)
include(cmake/3rdparty/spirv.cmake)
include(cmake/3rdparty/glslang.cmake)
include(cmake/3rdparty/glsl-optimizer.cmake)

include(cmake/bgfx.cmake)
include(cmake/example-common.cmake)

if(WITH_TOOLS)
  include(cmake/geometryc.cmake)
  include(cmake/shaderc.cmake)
  include(cmake/texturec.cmake)
  include(cmake/texturev.cmake)
endif()

if(WITH_EXAMPLES OR WITH_COMBINED_EXAMPLES)
  include(cmake/examples.cmake)
  install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/examples/runtime
    DESTINATION share/bgfx)
endif()
if (WITH_EXAMPLES)
  install(TARGETS ${EXAMPLES} RUNTIME DESTINATION ${EXAMPLES_DESTINATION})
endif()
if (WITH_COMBINED_EXAMPLES)
  install(TARGETS examples RUNTIME DESTINATION ${EXAMPLES_DESTINATION})
endif()

install(TARGETS bgfx dear-imgui nanovg texturev geometryc shaderc
  EXPORT bgfxTargets
  RUNTIME DESTINATION ${TOOLS_DESTINATION}
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  INCLUDES DESTINATION include)


install(EXPORT bgfxTargets
  FILE bgfxTargets.cmake
  NAMESPACE bgfx::
  DESTINATION share/bgfx)

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/bgfx DESTINATION include)
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/dear-imgui
  DESTINATION include/bgfx-extras
  FILES_MATCHING REGEX ".*(h|inl)$")
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/examples/common/nanovg
  DESTINATION include/bgfx-extras
  FILES_MATCHING PATTERN "*.h")

include(CMakePackageConfigHelpers)
install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/bgfxConfig.cmake
  DESTINATION share/bgfx)
