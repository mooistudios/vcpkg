function(add_example EXAMPLE_NAME)
  file(GLOB EXAMPLE_SOURCES
    examples/${EXAMPLE_NAME}/*.c
    examples/${EXAMPLE_NAME}/*.cpp
    examples/${EXAMPLE_NAME}/*.h)
  file(GLOB EXAMPLE_EXCLUDED examples/${EXAMPLE_NAME}/*.bin.h)
  if (NOT "${EXAMPLE_EXCLUDED}" STREQUAL "")
    list(REMOVE_ITEM EXAMPLE_SOURCES ${EXAMPLE_EXCLUDED})
  endif()

  add_executable(${EXAMPLE_NAME} ${EXAMPLE_SOURCES})
  target_compile_definitions(${EXAMPLE_NAME} PRIVATE ENTRY_CONFIG_IMPLEMENT_MAIN=1)
  target_link_libraries(${EXAMPLE_NAME}
    example-glue
    example-common)
endfunction()

function(add_combined_example EXAMPLES)
  set(COMBINED_EXAMPLE_SOURCES)
  foreach(EXAMPLE_NAME ${EXAMPLES})
    file(GLOB EXAMPLE_SOURCES
      examples/${EXAMPLE_NAME}/*.c
      examples/${EXAMPLE_NAME}/*.cpp
      examples/${EXAMPLE_NAME}/*.h)
    file(GLOB EXAMPLE_EXCLUDED examples/${EXAMPLE_NAME}/*.bin.h)
    if (NOT "${EXAMPLE_EXCLUDED}" STREQUAL "")
      list(REMOVE_ITEM EXAMPLE_SOURCES ${EXAMPLE_EXCLUDED})
    endif()
    list(APPEND COMBINED_EXAMPLE_SOURCES ${EXAMPLE_SOURCES})
  endforeach()

  # hack for main
  list(APPEND COMBINED_EXAMPLE_SOURCES "examples/25-c99/helloworld.c")

  add_executable(examples ${COMBINED_EXAMPLE_SOURCES})
  add_executable(bgfx::examples ALIAS examples)
  target_link_libraries(examples
    example-glue
    example-common)
endfunction()

set(EXAMPLES
  00-helloworld
  01-cubes
  02-metaballs
  03-raymarch
  04-mesh
  05-instancing
  06-bump
  07-callback
  08-update
  09-hdr
  10-font
  11-fontsdf
  12-lod
  13-stencil
  14-shadowvolumes
  15-shadowmaps-simple
  16-shadowmaps
  17-drawstress
  18-ibl
  19-oit
  20-nanovg
  21-deferred
  22-windows
  23-vectordisplay
  24-nbody
  25-c99
  26-occlusion
  27-terrain
  28-wireframe
  29-debugdraw
  30-picking
  31-rsm
  32-particles
  33-pom
  34-mvs
  35-dynamic
  36-sky)

if (WITH_EXAMPLES)
  foreach(EXAMPLE ${EXAMPLES})
    add_example(${EXAMPLE})
  endforeach()
endif()

if (WITH_COMBINED_EXAMPLES)
  add_combined_example("${EXAMPLES}")
endif()
