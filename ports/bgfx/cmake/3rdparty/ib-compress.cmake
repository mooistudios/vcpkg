file(GLOB_RECURSE IB_COMPRESS_SOURCES
  3rdparty/ib-compress/*.cpp
  3rdparty/ib-compress/*.h)
file(GLOB EXAMPLE_COMMON_EXCLUDED examples/common/example-glue.cpp)
list(REMOVE_ITEM IB_COMPRESS_SOURCES ${EXAMPLE_COMMON_EXCLUDED})

add_library(ib-compress ${IB_COMPRESS_SOURCES})
add_library(bgfx::ib-compress ALIAS ib-compress)
target_link_libraries(ib-compress bx::bx)
target_include_directories(ib-compress PUBLIC 3rdparty)
