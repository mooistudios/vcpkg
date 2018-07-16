file(GLOB_RECURSE DEAR_IMGUI_SOURCES
  3rdparty/dear-imgui/*.cpp
  3rdparty/dear-imgui/*.h)

add_library(dear-imgui STATIC ${DEAR_IMGUI_SOURCES})
add_library(bgfx::dear-imgui ALIAS dear-imgui)
target_link_libraries(dear-imgui bx::bx)
target_include_directories(dear-imgui
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/3rdparty>
    $<INSTALL_INTERFACE:include/bgfx-extras>)

set_target_properties(dear-imgui PROPERTIES OUTPUT_NAME bgfx_imgui)
