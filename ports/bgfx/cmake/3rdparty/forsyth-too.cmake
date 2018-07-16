file(GLOB_RECURSE FORSYTH_TOO_SOURCES
  3rdparty/forsyth-too/*.cpp
  3rdparty/forsyth-too/*.h)
file(GLOB EXAMPLE_COMMON_EXCLUDED examples/common/example-glue.cpp)
list(REMOVE_ITEM FORSYTH_TOO_SOURCES ${EXAMPLE_COMMON_EXCLUDED})

add_library(forsyth-too ${FORSYTH_TOO_SOURCES})
add_library(bgfx::forsyth-too ALIAS forsyth-too)
target_include_directories(forsyth-too PUBLIC 3rdparty)

set_target_properties(forsyth-too PROPERTIES OUTPUT_NAME bgfx_forsythtoo)
