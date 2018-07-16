file(GLOB_RECURSE FCPP_SOURCES
    3rdparty/fcpp/*.h
    3rdparty/fcpp/cpp1.c
    3rdparty/fcpp/cpp2.c
    3rdparty/fcpp/cpp3.c
    3rdparty/fcpp/cpp4.c
    3rdparty/fcpp/cpp5.c
    3rdparty/fcpp/cpp6.c)

add_library(fcpp ${FCPP_SOURCES})
add_library(bgfx::fcpp ALIAS fcpp)
target_compile_definitions(fcpp
  PRIVATE
    NINCLUDE=64
    NWORK=65536
    NBUFF=65536
    OLD_PREPROCESSOR=0)
target_include_directories(fcpp PUBLIC 3rdparty/fcpp)
