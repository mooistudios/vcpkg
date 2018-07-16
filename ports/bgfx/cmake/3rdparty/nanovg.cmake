file(GLOB_RECURSE NANOVG_SOURCES
  examples/common/nanovg/*.cpp
  examples/common/nanovg/*.h)
file(GLOB NANOVG_EXCLUDED examples/common/nanovg/*.bin.h)
list(REMOVE_ITEM NANOVG_SOURCES ${NANOVG_EXCLUDED})

add_library(nanovg STATIC ${NANOVG_SOURCES})
add_library(bgfx::nanovg ALIAS nanovg)
target_link_libraries(nanovg bx::bx bgfx::bgfx)
target_compile_definitions(nanovg PRIVATE STB_TRUETYPE_IMPLEMENTATION)
target_include_directories(nanovg
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/3rdparty>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/examples/common>
    $<INSTALL_INTERFACE:include/bgfx-extras>)

set_target_properties(nanovg PROPERTIES OUTPUT_NAME bgfx_nanovg)

